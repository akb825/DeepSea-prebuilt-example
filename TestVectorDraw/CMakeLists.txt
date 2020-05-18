find_package(DeepSea COMPONENTS ApplicationSDL RenderBootstrap VectorDraw REQUIRED)

set(libraries)
set(defines)
set(shaderConfigs)
set(srgbShaderConfigs)
set(source TestVectorDraw.c
	VectorElementFill.msl VectorElementLine.msl VectorElementImage.msl VectorElementText.msl
	VectorElementFillSRGB.msl VectorElementLineSRGB.msl VectorElementTextSRGB.msl)
if (TARGET deepsea_render_opengl)
	list(APPEND shaderConfigs glsl-1.1 glsl-1.5 glsl-4.0 glsl-es-1.0 glsl-es-3.0 glsl-es-3.2)
	list(APPEND srgbShaderConfigs glsl-1.5 glsl-4.0 glsl-es-3.0 glsl-es-3.2)
endif()
if (TARGET deepsea_render_vulkan)
	list(APPEND shaderConfigs spirv-1.0)
	list(APPEND srgbShaderConfigs spirv-1.0)
endif()
if (TARGET deepsea_render_metal)
	if (IOS)
		list(APPEND shaderConfigs metal-ios-1.1)
		list(APPEND srgbShaderConfigs metal-ios-1.1)
	else()
		list(APPEND shaderConfigs metal-osx-1.1)
		list(APPEND srgbShaderConfigs metal-osx-1.1)
	endif()
endif()

add_test_executable(TestVectorDrawApp ${source})

target_link_libraries(TestVectorDrawApp PRIVATE deepsea_render_bootstrap
	deepsea_application_sdl deepsea_vector_draw ${libraries})
ds_link_main_lib(TestVectorDrawApp deepsea_application_sdl_main)
target_compile_definitions(TestVectorDrawApp PRIVATE ${defines})

set(shaderDir ${CMAKE_CURRENT_BINARY_DIR}/shaders)
set(resourceDir ${CMAKE_CURRENT_BINARY_DIR}/resources)
set(imageDir ${CMAKE_CURRENT_BINARY_DIR}/images)
add_custom_target(TestVectorDrawApp_prepare
	COMMAND ${CMAKE_COMMAND} -E make_directory ${shaderDir}
	COMMAND ${CMAKE_COMMAND} -E make_directory ${resourceDir}
	COMMAND ${CMAKE_COMMAND} -E make_directory ${imageDir})

# Shaders
set(shaderOptions OUTPUT_DIR ${shaderDir}
	INCLUDE ${DEEPSEA_INCLUDE_DIR}
	DEPENDENCY_RECURSE ${DEEPSEA_INCLUDE_DIR}/DeepSea/Render/*.mslh
		${DEEPSEA_INCLUDE_DIR}/DeepSea/Text/*.mslh
		${DEEPSEA_INCLUDE_DIR}/DeepSea/VectorDraw/*.mslh)
ds_compile_shaders(shaders FILE ${CMAKE_CURRENT_SOURCE_DIR}/VectorElementFill.msl
	${CMAKE_CURRENT_SOURCE_DIR}/VectorElementLine.msl
	${CMAKE_CURRENT_SOURCE_DIR}/VectorElementImage.msl
	${CMAKE_CURRENT_SOURCE_DIR}/VectorElementTextColor.msl
	${CMAKE_CURRENT_SOURCE_DIR}/VectorElementTextGradient.msl
	OUTPUT TestVectorDraw.mslb
	CONFIG ${shaderConfigs} ${shaderOptions})
ds_compile_shaders(shaders FILE ${CMAKE_CURRENT_SOURCE_DIR}/VectorElementFillSRGB.msl
	${CMAKE_CURRENT_SOURCE_DIR}/VectorElementLineSRGB.msl
	${CMAKE_CURRENT_SOURCE_DIR}/VectorElementImage.msl
	${CMAKE_CURRENT_SOURCE_DIR}/VectorElementTextColorSRGB.msl
	${CMAKE_CURRENT_SOURCE_DIR}/VectorElementTextGradientSRGB.msl
	OUTPUT TestVectorDrawAppSRGB.mslb
	CONFIG ${srgbShaderConfigs} ${shaderOptions})
ds_compile_shaders_target(TestVectorDrawApp_shaders shaders
	DEPENDS TestVectorDrawApp_prepare)

# Shared resources
ds_create_vector_resources(resources FILE ${CMAKE_CURRENT_SOURCE_DIR}/resources.json
	OUTPUT ${resourceDir}/resources.dsvr)
ds_create_vector_resources_target(TestVectorDrawApp_resources resources
	DEPENDS TestVectorDrawApp_prepare)

# SVGs
file(GLOB svgFiles SVGs/*.svg)
foreach (svg ${svgFiles})
	get_filename_component(svgName ${svg} NAME_WE)
	ds_convert_svg(svgs FILE ${svg} OUTPUT ${imageDir}/${svgName}.dsvi)
endforeach()
ds_convert_svg_target(TestVectorDrawApp_svgs svgs
	DEPENDS TestVectorDrawApp_prepare)

ds_build_assets_dir(assetsDir TestVectorDrawApp)
set(assetsDir ${assetsDir}/TestVectorDraw-assets)
add_custom_target(TestVectorDrawApp_assets
	DEPENDS TestVectorDrawApp_shaders TestVectorDrawApp_resources
		TestVectorDrawApp_svgs
	COMMAND ${CMAKE_COMMAND} -E remove_directory ${assetsDir}
	COMMAND ${CMAKE_COMMAND} -E make_directory ${assetsDir}
	COMMAND ${CMAKE_COMMAND} -E copy_directory ${shaderDir} ${assetsDir}
	COMMAND ${CMAKE_COMMAND} -E copy_directory ${resourceDir} ${assetsDir}
	COMMAND ${CMAKE_COMMAND} -E copy_directory ${imageDir} ${assetsDir}
	COMMENT "Copying assets for TestVectorDrawApp")
add_dependencies(TestVectorDrawApp TestVectorDrawApp_assets)
