# automatically generated by the FlatBuffers compiler, do not modify

# namespace: TestScene

import flatbuffers
from flatbuffers.compat import import_numpy
np = import_numpy()

class LightData(object):
    __slots__ = ['_tab']

    @classmethod
    def GetRootAsLightData(cls, buf, offset):
        n = flatbuffers.encode.Get(flatbuffers.packer.uoffset, buf, offset)
        x = LightData()
        x.Init(buf, n + offset)
        return x

    # LightData
    def Init(self, buf, pos):
        self._tab = flatbuffers.table.Table(buf, pos)

    # LightData
    def VariableGroupDesc(self):
        o = flatbuffers.number_types.UOffsetTFlags.py_type(self._tab.Offset(4))
        if o != 0:
            return self._tab.String(o + self._tab.Pos)
        return None

    # LightData
    def Direction(self):
        o = flatbuffers.number_types.UOffsetTFlags.py_type(self._tab.Offset(6))
        if o != 0:
            x = o + self._tab.Pos
            from DeepSeaScene.Vector3f import Vector3f
            obj = Vector3f()
            obj.Init(self._tab.Bytes, x)
            return obj
        return None

    # LightData
    def Color(self):
        o = flatbuffers.number_types.UOffsetTFlags.py_type(self._tab.Offset(8))
        if o != 0:
            x = o + self._tab.Pos
            from DeepSeaScene.Vector3f import Vector3f
            obj = Vector3f()
            obj.Init(self._tab.Bytes, x)
            return obj
        return None

    # LightData
    def Ambient(self):
        o = flatbuffers.number_types.UOffsetTFlags.py_type(self._tab.Offset(10))
        if o != 0:
            x = o + self._tab.Pos
            from DeepSeaScene.Vector3f import Vector3f
            obj = Vector3f()
            obj.Init(self._tab.Bytes, x)
            return obj
        return None

def LightDataStart(builder): builder.StartObject(4)
def LightDataAddVariableGroupDesc(builder, variableGroupDesc): builder.PrependUOffsetTRelativeSlot(0, flatbuffers.number_types.UOffsetTFlags.py_type(variableGroupDesc), 0)
def LightDataAddDirection(builder, direction): builder.PrependStructSlot(1, flatbuffers.number_types.UOffsetTFlags.py_type(direction), 0)
def LightDataAddColor(builder, color): builder.PrependStructSlot(2, flatbuffers.number_types.UOffsetTFlags.py_type(color), 0)
def LightDataAddAmbient(builder, ambient): builder.PrependStructSlot(3, flatbuffers.number_types.UOffsetTFlags.py_type(ambient), 0)
def LightDataEnd(builder): return builder.EndObject()
