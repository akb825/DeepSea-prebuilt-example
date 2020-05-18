find_package(DeepSea COMPONENTS ApplicationSDL RenderBootstrap Scene REQUIRED)

set(shaderConfigs)
set(source TestScene.c LightData.cpp LightData.h LightData.fbs TestSceneCube.msl
	TestSceneGround.msl)
if (TARGET deepsea_render_opengl)
	list(APPEND shaderConfigs glsl-1.1 glsl-1.5 glsl-es-1.0 glsl-es-3.0)
endif()
if (TARGET deepsea_render_vulkan)
	list(APPEND shaderConfigs spirv-1.0)
endif()
if (TARGET deepsea_render_metal)
	if (IOS)
		list(APPEND shaderConfigs metal-ios-1.1)
	else()
		list(APPEND shaderConfigs metal-osx-1.1)
	endif()
endif()

add_test_executable(TestSceneApp ${source})

target_link_libraries(TestSceneApp PRIVATE
	deepsea_render_bootstrap deepsea_scene deepsea_application_sdl)
target_include_directories(TestSceneApp PRIVATE ${FLATBUFFERS_INCLUDE_DIRS})
ds_link_main_lib(TestSceneApp deepsea_application_sdl_main)

if (TARGET deepsea_easy_profiler)
	target_link_libraries(TestSceneApp PRIVATE deepsea_easy_profiler)
	target_compile_definitions(TestSceneApp PRIVATE DS_HAS_EASY_PROFILER=1)
endif()

convert_flatbuffers(generatedFlatbuffers FILE ${CMAKE_CURRENT_SOURCE_DIR}/LightData.fbs
	DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
	INCLUDE ${DEEPSEA_INCLUDE_DIR}
	PYTHON ${CMAKE_CURRENT_SOURCE_DIR}/python)
convert_flatbuffers_target(TestSceneApp_flatbuffers generatedFlatbuffers)
add_dependencies(TestSceneApp TestSceneApp_flatbuffers)

ds_config_binary_dir(assetsDir assets)
ds_config_binary_dir(configDir)
set(shaderDir ${assetsDir}/shaders)
add_custom_target(TestSceneApp_prepare
	COMMAND ${CMAKE_COMMAND} -E make_directory ${shaderDir})

# Compile shaders.
ds_compile_shaders(shaders FILE ${CMAKE_CURRENT_SOURCE_DIR}/TestSceneCube.msl
	${CMAKE_CURRENT_SOURCE_DIR}/TestSceneGround.msl
	OUTPUT TestScene.mslb CONFIG ${shaderConfigs} OUTPUT_DIR ${shaderDir}
	DEPENDS_RECURSE ${DEEPSEA_INCLUDE_DIR}/DeepSea/Render/*.mslh
		${DEEPSEA_INCLUDE_DIR}/DeepSea/Scene/*.mslh
	INCLUDE ${DEEPSEA_INCLUDE_DIR})
ds_compile_shaders_target(TestSceneApp_shaders shaders
	DEPENDS TestSceneApp_prepare)

# Convert scene.
set(sharedDir ${ROOT_DIR}/Shared)
if (ANDROID)
	set(textureFormat ETC1)
elseif (IOS)
	set(textureFormat PVRTC1_RGB_4BPP)
else()
	set(textureFormat BC1_RGB)
endif()
set(textureDecoration UNorm)
set(srcDir ${CMAKE_CURRENT_SOURCE_DIR})
ds_scene_resource_shader_module_config(testSceneModule TestScene.mslb ${assetsDir} ${shaderDir}
	${shaderConfigs})
ds_configure_file(resources.json ${configDir}/resources.json CONFIG_VAR testSceneModule @ONLY)

ds_create_scene_resources(resources FILE ${configDir}/resources.json
	OUTPUT ${assetsDir}/resources.dssr DEPENDS ${sharedDir}/SimpleTexture.png)
ds_create_scene_resources_target(TestSceneApp_scene_resources resources
	DEPENDS TestSceneApp_shaders)

ds_create_scene(scene FILE ${CMAKE_CURRENT_SOURCE_DIR}/scene.json OUTPUT ${assetsDir}/scene.dss
	MODULE_DIRECTORIES ${CMAKE_CURRENT_SOURCE_DIR}/python EXTENSIONS TestSceneExtension)
ds_create_scene_target(TestSceneApp_scene scene DEPENDS TestSceneApp_prepare)

ds_create_view(view FILE ${CMAKE_CURRENT_SOURCE_DIR}/view.json OUTPUT ${assetsDir}/view.dsv)
ds_create_view_target(TestSceneApp_view view DEPENDS TestSceneApp_prepare)

# Copy 
ds_build_assets_dir(finalAssetsDir TestSceneApp)
set(finalAssetsDir ${finalAssetsDir}/TestScene-assets)
add_custom_target(TestSceneApp_assets
	DEPENDS TestSceneApp_shaders TestSceneApp_scene_resources
		TestSceneApp_scene TestSceneApp_view
	COMMAND ${CMAKE_COMMAND} -E remove_directory ${finalAssetsDir}
	COMMAND ${CMAKE_COMMAND} -E make_directory ${finalAssetsDir}
	COMMAND ${CMAKE_COMMAND} -E copy_directory ${assetsDir} ${finalAssetsDir}
	COMMENT "Copying assets for TestScene")
add_dependencies(TestSceneApp TestSceneApp_assets)
