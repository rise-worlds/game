// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.filters.FDistortFilter

package com.flengine.context.filters
{
    import __AS3__.vec.Vector;
    import flash.display3D.Context3D;
    import com.flengine.textures.FTexture;

    public class FDistortFilter extends FFilter 
    {

        public var redOffset:Number = 8;
        public var greenOffset:Number = 16;
        public var blueOffset:Number = 12;
        public var frequency:int = 40;

        public function FDistortFilter()
        {
            iId = 7;
            bOverrideFragmentShader = true;
            fragmentCode = "mul ft3, v0, fc2.x\t\t\t\t\t\t\t\nsin ft3, ft3\t\t\t\t\t\t\t\t\nmul ft4, ft3.y, fc1\t\t\t\t\t\t\nadd ft0, v0, ft4.xwww \t\t\t\t\t\t\ntex ft1, ft0, fs0 <2d,linear,mipnone,clamp>\nadd ft0, v0, ft4.ywww\t\t\t\t\t\t\ntex ft2, ft0, fs0 <2d,linear,mipnone,clamp>\nmov ft1.y, ft2.xy\t\t\t\t\t\t\t\nadd ft0, v0, ft4.zwww\t\t\t\t\t\t\ntex ft2, ft0, fs0 <2d,linear,mipnone,clamp>\nmov ft1.z, ft2.xyz\t\t\t\t\t\t\t\nmov oc, ft1";
            _aFragmentConstants = new <Number>[0.1, 0.05, 0.2, 0, 4, 0, 0, 0];
        }

        override public function bind(p_context:Context3D, p_texture:FTexture):void
        {
            var _local3:Number = (1 / p_texture.gpuWidth);
            _aFragmentConstants = new <Number>[(redOffset * _local3), (greenOffset * _local3), (blueOffset * _local3), 0, frequency, 0, 0, 0];
            super.bind(p_context, p_texture);
        }


    }
}//package com.flengine.context.filters

