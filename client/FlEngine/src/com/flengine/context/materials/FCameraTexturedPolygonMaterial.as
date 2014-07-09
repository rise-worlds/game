// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.materials.FCameraTexturedPolygonMaterial

package com.flengine.context.materials
{
    import flash.utils.ByteArray;
    import flash.display3D.Program3D;
    import flash.display3D.VertexBuffer3D;
    import flash.display3D.IndexBuffer3D;
    import flash.display3D.textures.Texture;
    import __AS3__.vec.Vector;
    import flash.display3D.Context3D;
    import com.flengine.textures.FTextureBase;
    import com.flengine.components.FCamera;
    import com.flengine.core.FStats;

    public class FCameraTexturedPolygonMaterial implements IGMaterial 
    {

        private const VertexShaderEmbed:Class = FCameraTexturedPolygonMaterialVertex_ash;
        private const VertexShaderCode:ByteArray = (new VertexShaderEmbed() as ByteArray);

        private var _p3ShaderProgramLinear:Program3D;
        private var _p3ShaderProgramNearest:Program3D;
        private var __vb3VertexBuffer:VertexBuffer3D;
        private var __vb3UVBuffer:VertexBuffer3D;
        private var __ib3IndexBuffer:IndexBuffer3D;
        private var __bInitializedThisFrame:Boolean = false;
        private var __cActiveTexture:Texture;
        private var __iActiveFiltering:int;
        private var __aPrograms:Vector.<Program3D>;
        private var __p3dColorProgram:Program3D;
        private var __cContext:Context3D;
        private var __iMaxVertices:int;
        private var __aVertices:Vector.<Number>;
        private var __aUVs:Vector.<Number>;
        private var __aIndices:Vector.<uint>;

        public function FCameraTexturedPolygonMaterial()
        {
            __aPrograms = new Vector.<Program3D>();
            super();
        }

        function initialize(p_context:Context3D, p_maxVertices:int):void
        {
            var _local4:int;
            __cContext = p_context;
            __iMaxVertices = p_maxVertices;
            VertexShaderCode.endian = "littleEndian";
            __p3dColorProgram = __cContext.createProgram();
            __p3dColorProgram.upload(VertexShaderCode, FFragmentShadersCommon.getColorShaderCode());
            __aPrograms = new Vector.<Program3D>();
            _p3ShaderProgramNearest = __cContext.createProgram();
            _p3ShaderProgramNearest.upload(VertexShaderCode, FFragmentShadersCommon.getTexturedShaderCode(true, 0, true));
            __aPrograms.push(_p3ShaderProgramNearest);
            _p3ShaderProgramLinear = __cContext.createProgram();
            _p3ShaderProgramLinear.upload(VertexShaderCode, FFragmentShadersCommon.getTexturedShaderCode(true, 1, true));
            __aPrograms.push(_p3ShaderProgramLinear);
            __vb3VertexBuffer = __cContext.createVertexBuffer(__iMaxVertices, 2);
            __vb3UVBuffer = __cContext.createVertexBuffer(__iMaxVertices, 2);
            __ib3IndexBuffer = __cContext.createIndexBuffer(__iMaxVertices);
            var _local3:Vector.<uint> = new Vector.<uint>();
            _local4 = 0;
            while (_local4 < __iMaxVertices)
            {
                _local3.push(_local4);
                _local4++;
            };
            __ib3IndexBuffer.uploadFromVector(_local3, 0, __iMaxVertices);
        }

        public function bind(p_context:Context3D, p_reinitialize:Boolean, p_camera:FCamera, p_maxVertices:int):void
        {
            if ((((((_p3ShaderProgramLinear == null)) || (((p_reinitialize) && (!(__bInitializedThisFrame)))))) || (!((p_maxVertices == __iMaxVertices)))))
            {
                initialize(p_context, p_maxVertices);
            };
            __bInitializedThisFrame = p_reinitialize;
            __cContext.setProgramConstantsFromVector("vertex", 4, p_camera.aCameraVector, 2);
            __cActiveTexture = null;
            __iActiveFiltering = FTextureBase.defaultFilteringType;
            __cContext.setProgram(__aPrograms[__iActiveFiltering]);
        }

        public function draw(p_transform:Vector.<Number>, p_texture:Texture, p_filtering:int, p_vertices:Vector.<Number>, p_uvs:Vector.<Number>, p_currentVertices:int, p_dirty:Boolean):void
        {
            if (__cActiveTexture != p_texture)
            {
                __cActiveTexture = p_texture;
                __cContext.setTextureAt(0, __cActiveTexture);
                if (__cActiveTexture == null)
                {
                    p_filtering = -1;
                };
            };
            if (__iActiveFiltering != p_filtering)
            {
                __iActiveFiltering = p_filtering;
                if (__cActiveTexture)
                {
                    __cContext.setProgram(__aPrograms[__iActiveFiltering]);
                }
                else
                {
                    __cContext.setProgram(__p3dColorProgram);
                };
            };
            if (p_dirty)
            {
                __aVertices = p_vertices;
                __vb3VertexBuffer.uploadFromVector(__aVertices, 0, (__aVertices.length / 2));
            };
            if (p_uvs != __aUVs)
            {
                __aUVs = p_uvs;
                __vb3UVBuffer.uploadFromVector(__aUVs, 0, (__aUVs.length / 2));
            };
            __cContext.setVertexBufferAt(0, __vb3VertexBuffer, 0, "float2");
            __cContext.setVertexBufferAt(1, __vb3UVBuffer, 0, "float2");
            __cContext.setProgramConstantsFromVector("vertex", 6, p_transform, 4);
            FStats.iDrawCalls = (FStats.iDrawCalls + 1);
            __cContext.drawTriangles(__ib3IndexBuffer, 0, (p_currentVertices / 3));
        }

        public function push():void
        {
        }

        public function clear():void
        {
            __cContext.setTextureAt(0, null);
            __cContext.setVertexBufferAt(0, null);
            __cContext.setVertexBufferAt(1, null);
            __cActiveTexture = null;
            __iActiveFiltering = 0;
        }


    }
}//package com.flengine.context.materials

