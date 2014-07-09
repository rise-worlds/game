// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.filters.FHDRPassFilter

package com.flengine.context.filters
{
    import __AS3__.vec.Vector;
    import com.flengine.textures.FTexture;
    import com.flengine.error.FError;
    import flash.display3D.Context3D;

    public class FHDRPassFilter extends FFilter 
    {

        public var texture:FTexture;
        private var _nSaturation:Number = 1.3;

        public function FHDRPassFilter(p_saturation:Number=1.3)
        {
            iId = 8;
            fragmentCode = "tex ft1, v0, fs1 <2d,linear,mipnone,clamp>\t\nsub ft0.xyz, fc1.www, ft0.xyz               \nadd ft0.xyz, ft1.xyz, ft0.xyz               \nsub ft0.xyz, ft0.xyz, fc2.yyy               \nsat ft0.xyz, ft0.xyz                        \ndp3 ft2.x, ft1.xyz, fc1.xyz                \nsub ft1.xyz, ft1.xyz, ft2.xxx                \nmul ft1.xyz, ft1.xyz, fc2.xxx                \nadd ft1.xyz, ft1.xyz, ft2.xxx                \nadd ft0.xyz, ft0.xyz, ft1.xyz               \nsub ft0.xyz, ft0.xyz, fc2.yyy               \n";
            _aFragmentConstants = new <Number>[0.2125, 0.7154, 0.0721, 1, p_saturation, 0.5, 0, 0];
            _nSaturation = p_saturation;
        }

        public function get saturation():Number
        {
            return (_nSaturation);
        }

        public function set saturation(p_value:Number):void
        {
            _nSaturation = p_value;
            _aFragmentConstants[4] = _nSaturation;
        }

        override public function bind(p_context:Context3D, p_texture:FTexture):void
        {
            super.bind(p_context, p_texture);
            if (texture == null)
            {
                throw (FError("There is no texture set for HDR pass."));
            };
            p_context.setTextureAt(1, texture.cContextTexture.tTexture);
        }

        override public function clear(p_context:Context3D):void
        {
            p_context.setTextureAt(1, null);
        }


    }
}//package com.flengine.context.filters

