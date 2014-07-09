// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.materials.FCameraTexturedParticlesBatchMaterial

package com.flengine.context.materials
{
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import flash.utils.ByteArray;
    import flash.display3D.Program3D;
    import flash.display3D.VertexBuffer3D;
    import flash.display3D.IndexBuffer3D;
    import flash.display3D.textures.Texture;
    import flash.display3D.Context3D;
    import com.adobe.utils.AGALMiniAssembler;
    import com.flengine.components.FCamera;

    public class FCameraTexturedParticlesBatchMaterial implements IGMaterial 
    {

        private static const DATA_PER_VERTEX:int = 10;
        private static const NORMALIZED_VERTICES:Vector.<Number> = Vector.<Number>([-0.5, 0.5, -0.5, -0.5, 0.5, -0.5, 0.5, 0.5]);
        private static const NORMALIZED_UVS:Vector.<Number> = Vector.<Number>([0, 1, 0, 0, 1, 0, 1, 1]);
        private static const VERTEX_SHADER_CODE:Array = ["mov vt0, va0", "mov vt1, va1", "mov vt2, va2", "mov vt3, va3", "mov vt4, va4", "sub vt6.x, vc8.y, va4.x", "div vt6.x, vt6.x, va4.y", "frc vt6.x, vt6.x", "sat vt6.x, vt6.x", "sub vt6.y, vc8.w, vt6.x", "mul vt1.x, vt6.y, va3.x", "mul vt1.y, vt6.x, va3.y", "add vt1.x, vt1.x, vt1.y", "mul vt2.xy, vt1.xx, vc6.zw", "mul vt5.xy, va0.xy, vt2.xy", "mul vt1.xy, va2.zw, vt6.xx", "add vt1.xy, vt5.xy, vt1.xy", "add vt5.xy, vt1.xy, va2.xy", "mov vt4.x, vc8.x", "sin vt2.x, vt4.x", "cos vt2.y, vt4.x", "mul vt3.x, vt5.x, vt2.y", "mul vt3.y, vt5.y, vt2.x", "sub vt4.x, vt3.x, vt3.y", "mul vt3.y, vt5.y, vt2.y", "mul vt3.x, vt5.x, vt2.x", "add vt4.y, vt3.y, vt3.x", "add vt1.xy, vt4.xy, vc6.xy", "sub vt1.xy, vt1.xy, vc5.xy", "mul vt1.xy, vt1.xy, vc5.zw", "mov vt4.x, vc4.x", "sin vt2.x, vt4.x", "cos vt2.y, vt4.x", "mul vt3.x, vt1.x, vt2.y", "mul vt3.y, vt1.y, vt2.x", "sub vt4.x, vt3.x, vt3.y", "mul vt3.y, vt1.y, vt2.y", "mul vt3.x, vt1.x, vt2.x", "add vt4.y, vt3.y, vt3.x", "add vt1, vt4.xy, vc4.yz", "mov vt1.zw, vt0.zw", "m44 op, vt1, vc0", "mul vt0.xy, va1.xy, vc7.zw", "add vt0.xy, vt0.xy, vc7.xy", "mov v0, vt0", "mul vt1.x, vt6.y, va3.z", "mul vt1.y, vt6.x, va3.w", "add vt1.x, vt1.x, vt1.y", "mov vt2, vc9", "mul vt2.w, vt2.w, vt1.x", "mov v1, vt2"];

        private static var __aCached:Dictionary = new Dictionary();

        private const VertexShaderEmbed:Class = FCameraTexturedParticlesBatchMaterialVertex_ash;
        private const VertexShaderCode:ByteArray = (new VertexShaderEmbed() as ByteArray);

        private var _p3ShaderProgram:Program3D;
        private var __vb3VertexBuffer:VertexBuffer3D;
        private var __ib3IndexBuffer:IndexBuffer3D;
        private var __iActiveAtf:int = 0;
        private var __iActiveFiltering:int = 0;
        private var __cActiveTexture:Texture;
        private var __bReinitialized:Boolean = false;
        private var __bInitializedThisFrame:Boolean = false;
        private var __cContext:Context3D;


        public static function getByHash(p_hash:String):FCameraTexturedParticlesBatchMaterial
        {
            var _local2:FCameraTexturedParticlesBatchMaterial = __aCached[p_hash];
            if (_local2 == null)
            {
                _local2 = new (FCameraTexturedParticlesBatchMaterial)();
                __aCached[p_hash] = _local2;
            };
            return (_local2);
        }


        public function bind(p_context:Context3D, p_reinitialize:Boolean, p_camera:FCamera, p_particles:Vector.<Number>):void
        {
            var _local7:int;
            var _local10:int;
            var _local8:*;
            var _local6:int;
            var _local9:*;
            var _local5:AGALMiniAssembler;
            __cContext = p_context;
            if (!p_reinitialize)
            {
                __bReinitialized = false;
            };
            if (__bReinitialized)
            {
                p_reinitialize = false;
            };
            if (p_reinitialize)
            {
                __bReinitialized = true;
            };
            if ((((_p3ShaderProgram == null)) || (((p_reinitialize) && (!(__bInitializedThisFrame))))))
            {
                VertexShaderCode.endian = "littleEndian";
                _local5 = new AGALMiniAssembler();
                _local5.assemble("vertex", VERTEX_SHADER_CODE.join("\n"));
                _p3ShaderProgram = __cContext.createProgram();
                _p3ShaderProgram.upload(_local5.agalcode, FFragmentShadersCommon.getTexturedShaderCode(true, 1, true, __iActiveAtf));
                _local7 = (p_particles.length / 10);
                _local8 = new Vector.<Number>();
                _local10 = 0;
                while (_local10 < _local7)
                {
                    _local6 = (_local10 * 10);
                    _local8.push(NORMALIZED_VERTICES[0], NORMALIZED_VERTICES[1]);
                    _local8.push(NORMALIZED_UVS[0], NORMALIZED_UVS[1]);
                    _local8.push(p_particles[_local6], p_particles[(_local6 + 1)], p_particles[(_local6 + 2)], p_particles[(_local6 + 3)]);
                    _local8.push(p_particles[(_local6 + 4)], p_particles[(_local6 + 5)], p_particles[(_local6 + 6)], p_particles[(_local6 + 7)]);
                    _local8.push(p_particles[(_local6 + 8)], p_particles[(_local6 + 9)]);
                    _local8.push(NORMALIZED_VERTICES[2], NORMALIZED_VERTICES[3]);
                    _local8.push(NORMALIZED_UVS[2], NORMALIZED_UVS[3]);
                    _local8.push(p_particles[_local6], p_particles[(_local6 + 1)], p_particles[(_local6 + 2)], p_particles[(_local6 + 3)]);
                    _local8.push(p_particles[(_local6 + 4)], p_particles[(_local6 + 5)], p_particles[(_local6 + 6)], p_particles[(_local6 + 7)]);
                    _local8.push(p_particles[(_local6 + 8)], p_particles[(_local6 + 9)]);
                    _local8.push(NORMALIZED_VERTICES[4], NORMALIZED_VERTICES[5]);
                    _local8.push(NORMALIZED_UVS[4], NORMALIZED_UVS[5]);
                    _local8.push(p_particles[_local6], p_particles[(_local6 + 1)], p_particles[(_local6 + 2)], p_particles[(_local6 + 3)]);
                    _local8.push(p_particles[(_local6 + 4)], p_particles[(_local6 + 5)], p_particles[(_local6 + 6)], p_particles[(_local6 + 7)]);
                    _local8.push(p_particles[(_local6 + 8)], p_particles[(_local6 + 9)]);
                    _local8.push(NORMALIZED_VERTICES[6], NORMALIZED_VERTICES[7]);
                    _local8.push(NORMALIZED_UVS[6], NORMALIZED_UVS[7]);
                    _local8.push(p_particles[_local6], p_particles[(_local6 + 1)], p_particles[(_local6 + 2)], p_particles[(_local6 + 3)]);
                    _local8.push(p_particles[(_local6 + 4)], p_particles[(_local6 + 5)], p_particles[(_local6 + 6)], p_particles[(_local6 + 7)]);
                    _local8.push(p_particles[(_local6 + 8)], p_particles[(_local6 + 9)]);
                    _local10++;
                };
                __vb3VertexBuffer = __cContext.createVertexBuffer((4 * _local7), 14);
                __vb3VertexBuffer.uploadFromVector(_local8, 0, (4 * _local7));
                _local9 = new Vector.<uint>();
                _local10 = 0;
                while (_local10 < _local7)
                {
                    _local9 = _local9.concat(Vector.<uint>([(4 * _local10), ((4 * _local10) + 1), ((4 * _local10) + 2), (4 * _local10), ((4 * _local10) + 2), ((4 * _local10) + 3)]));
                    _local10++;
                };
                __ib3IndexBuffer = __cContext.createIndexBuffer((6 * _local7));
                __ib3IndexBuffer.uploadFromVector(_local9, 0, (6 * _local7));
            };
            __bInitializedThisFrame = p_reinitialize;
            __cContext.setProgram(_p3ShaderProgram);
            __cContext.setProgramConstantsFromVector("vertex", 4, p_camera.aCameraVector, 2);
            __cContext.setProgramConstantsFromVector("fragment", 1, Vector.<Number>([1, 1, 0, 0.1]), 1);
            __cContext.setVertexBufferAt(0, __vb3VertexBuffer, 0, "float2");
            __cContext.setVertexBufferAt(1, __vb3VertexBuffer, 2, "float2");
            __cContext.setVertexBufferAt(2, __vb3VertexBuffer, 4, "float4");
            __cContext.setVertexBufferAt(3, __vb3VertexBuffer, 8, "float4");
            __cContext.setVertexBufferAt(4, __vb3VertexBuffer, 12, "float2");
        }

        public function draw(p_transform:Vector.<Number>, p_texture:Texture, p_filtering:int, p_count:int):void
        {
            __cContext.setTextureAt(0, p_texture);
            __cContext.setProgramConstantsFromVector("vertex", 6, p_transform, 4);
            __cContext.drawTriangles(__ib3IndexBuffer, 0, (p_count * 2));
        }

        public function push():void
        {
        }

        public function clear():void
        {
            __cContext.setTextureAt(0, null);
            __cContext.setVertexBufferAt(0, null);
            __cContext.setVertexBufferAt(1, null);
            __cContext.setVertexBufferAt(2, null);
            __cContext.setVertexBufferAt(3, null);
            __cContext.setVertexBufferAt(4, null);
            __cActiveTexture = null;
            __iActiveFiltering = 0;
        }


    }
}//package com.flengine.context.materials

