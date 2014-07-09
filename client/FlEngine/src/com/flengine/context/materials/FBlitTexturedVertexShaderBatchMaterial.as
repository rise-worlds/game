// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.materials.FBlitTexturedVertexShaderBatchMaterial

package com.flengine.context.materials
{
    import __AS3__.vec.Vector;
    import flash.utils.ByteArray;
    import flash.display3D.VertexBuffer3D;
    import flash.display3D.IndexBuffer3D;
    import flash.display3D.textures.Texture;
    import flash.display3D.Context3D;
    import flash.utils.Dictionary;
    import flash.display3D.Program3D;
    import com.flengine.core.FlEngine;
    import flash.system.ApplicationDomain;
    import com.flengine.textures.FTexture;
    import com.flengine.core.FStats;
	import com.flengine.fl2d;
	use namespace fl2d;

    public final class FBlitTexturedVertexShaderBatchMaterial implements IGMaterial 
    {

        private static const NORMALIZED_VERTICES:Vector.<Number> = Vector.<Number>([-0.5, 0.5, -0.5, -0.5, 0.5, -0.5, 0.5, 0.5]);
        private static const NORMALIZED_UVS:Vector.<Number> = Vector.<Number>([0, 1, 0, 0, 1, 0, 1, 1]);

        private static var _helpBindFloat2:String = "float2";

        private const BATCH_CONSTANTS:int = 124;
        private const CONSTANTS_PER_BATCH:int = 2;
        private const BATCH_SIZE:int = 62;
        private const VertexShaderEmbed:Class = FBlitTexturedVertexShaderBatchMaterialVertex_ash;
        private const VertexShaderCode:ByteArray = (new VertexShaderEmbed() as ByteArray);

        private var __vb3VertexBuffer:VertexBuffer3D;
        private var __vb3UVBuffer:VertexBuffer3D;
        private var __vb3RegisterIndexBuffer:VertexBuffer3D;
        private var __ib3IndexBuffer:IndexBuffer3D;
        private var __bInitializedThisFrame:Boolean;
        private var __iQuadCount:int = 0;
        private var __cActiveContextTexture:Texture;
        private var __aVertexConstants:Vector.<Number>;
        private var __baVertexArray:ByteArray;
        private var __iConstantsOffset:int = 0;
        private var __iActiveAtf:int = 0;
        private var __bUseFastMem:Boolean = false;
        private var __cContext:Context3D;
        private var __aCachedPrograms:Dictionary;

        public function FBlitTexturedVertexShaderBatchMaterial()
        {
            __aVertexConstants = new Vector.<Number>(496);
            super();
        }

        private function getCachedProgram(p_repeat:Boolean, p_filtering:int, p_atf:int):Program3D
        {
            var _local4 = (((((p_repeat) ? 1 : 0) << 31) | ((p_filtering & 1) << 29)) | ((p_atf & 3) << 27));
            if (__aCachedPrograms[_local4] != null)
            {
                return (__aCachedPrograms[_local4]);
            };
            var _local5:Program3D = __cContext.createProgram();
            _local5.upload(VertexShaderCode, FFragmentShadersCommon.getTexturedShaderCode(p_repeat, p_filtering, false, p_atf));
            __aCachedPrograms[_local4] = _local5;
            return (_local5);
        }

        fl2d function initialize(p_context:Context3D):void
        {
            var _local7:int;
            var _local3:int;
            __cContext = p_context;
            __bUseFastMem = FlEngine.getInstance().cConfig.useFastMem;
            VertexShaderCode.endian = "littleEndian";
            __aCachedPrograms = new Dictionary();
            var _local4:Vector.<Number> = new Vector.<Number>();
            var _local6:Vector.<Number> = new Vector.<Number>();
            var _local2:Vector.<Number> = new Vector.<Number>();
            _local7 = 0;
            while (_local7 < 62)
            {
                _local4 = _local4.concat(NORMALIZED_VERTICES);
                _local6 = _local6.concat(NORMALIZED_UVS);
                _local3 = (4 + (_local7 * 2));
                _local2.push(_local3, (_local3 + 1));
                _local2.push(_local3, (_local3 + 1));
                _local2.push(_local3, (_local3 + 1));
                _local2.push(_local3, (_local3 + 1));
                _local7++;
            };
            __vb3VertexBuffer = p_context.createVertexBuffer(248, 2);
            __vb3VertexBuffer.uploadFromVector(_local4, 0, 248);
            __vb3UVBuffer = p_context.createVertexBuffer(248, 2);
            __vb3UVBuffer.uploadFromVector(_local6, 0, 248);
            __vb3RegisterIndexBuffer = p_context.createVertexBuffer(248, 2);
            __vb3RegisterIndexBuffer.uploadFromVector(_local2, 0, 248);
            var _local5:Vector.<uint> = new Vector.<uint>();
            _local7 = 0;
            while (_local7 < 62)
            {
                _local5 = _local5.concat(Vector.<uint>([(4 * _local7), ((4 * _local7) + 1), ((4 * _local7) + 2), (4 * _local7), ((4 * _local7) + 2), ((4 * _local7) + 3)]));
                _local7++;
            };
            __ib3IndexBuffer = p_context.createIndexBuffer(372);
            __ib3IndexBuffer.uploadFromVector(_local5, 0, 372);
            __baVertexArray = new ByteArray();
            __baVertexArray.endian = "littleEndian";
            __baVertexArray.length = 0x0800;
        }

        [Inline]
        public function bind(p_context:Context3D, p_reinitialize:Boolean):void
        {
            if ((((__aCachedPrograms == null)) || (((p_reinitialize) && (!(__bInitializedThisFrame))))))
            {
                initialize(p_context);
            };
            __bInitializedThisFrame = p_reinitialize;
            __cContext.setProgram(getCachedProgram(true, 0, __iActiveAtf));
            __cContext.setVertexBufferAt(0, __vb3VertexBuffer, 0, _helpBindFloat2);
            __cContext.setVertexBufferAt(1, __vb3UVBuffer, 0, _helpBindFloat2);
            __cContext.setVertexBufferAt(2, __vb3RegisterIndexBuffer, 0, _helpBindFloat2);
            __iQuadCount = 0;
            __iConstantsOffset = 0;
            __cActiveContextTexture = null;
            if (__bUseFastMem)
            {
                ApplicationDomain.currentDomain.domainMemory = __baVertexArray;
            };
        }

        [Inline]
        public function draw(p_x:Number, p_y:Number, p_scaleX:Number, p_scaleY:Number, p_texture:FTexture):void
        {
            var _local7:Texture = p_texture.cContextTexture.tTexture;
            var _local8 = !((__cActiveContextTexture == _local7));
            var _local6 = !((__iActiveAtf == p_texture.iAtfType));
            if (_local8)
            {
                if (__cActiveContextTexture != null)
                {
                    push();
                };
                if (_local8)
                {
                    __cActiveContextTexture = _local7;
                    __cContext.setTextureAt(0, __cActiveContextTexture);
                };
                if (_local6)
                {
                    __iActiveAtf = p_texture.iAtfType;
                    __cContext.setProgram(getCachedProgram(true, 0, __iActiveAtf));
                };
            };
            __iConstantsOffset = (__iQuadCount << 3);
            __aVertexConstants[__iConstantsOffset] = p_x;
            __aVertexConstants[(__iConstantsOffset + 1)] = p_y;
            __aVertexConstants[(__iConstantsOffset + 2)] = (p_texture.iWidth * p_scaleX);
            __aVertexConstants[(__iConstantsOffset + 3)] = (p_texture.iHeight * p_scaleY);
            __aVertexConstants[(__iConstantsOffset + 4)] = p_texture.uvX;
            __aVertexConstants[(__iConstantsOffset + 5)] = p_texture.uvY;
            __aVertexConstants[(__iConstantsOffset + 6)] = p_texture.uvScaleX;
            __aVertexConstants[(__iConstantsOffset + 7)] = p_texture.uvScaleY;
            __iQuadCount++;
            if (__iQuadCount == 62)
            {
                push();
            };
        }

        [Inline]
        public function push():void
        {
            FStats.iDrawCalls = (FStats.iDrawCalls + 1);
            if (__bUseFastMem)
            {
                __cContext.setProgramConstantsFromByteArray("vertex", 4, 124, __baVertexArray, 0);
            }
            else
            {
                __cContext.setProgramConstantsFromVector("vertex", 4, __aVertexConstants, 124);
            };
            __cContext.drawTriangles(__ib3IndexBuffer, 0, (__iQuadCount * 2));
            __iQuadCount = 0;
            __iConstantsOffset = 0;
        }

        [Inline]
        public function clear():void
        {
            __cContext.setTextureAt(0, null);
            __cContext.setVertexBufferAt(0, null);
            __cContext.setVertexBufferAt(1, null);
            __cContext.setVertexBufferAt(2, null);
            __cActiveContextTexture = null;
        }


    }
}//package com.flengine.context.materials

