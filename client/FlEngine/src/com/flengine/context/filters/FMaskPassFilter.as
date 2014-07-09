// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.filters.FMaskPassFilter

package com.flengine.context.filters
{
    import com.flengine.textures.FTexture;
    import flash.display3D.Context3D;

    public class FMaskPassFilter extends FFilter 
    {

        protected var _cMaskTexture:FTexture;

        public function FMaskPassFilter(p_maskTexture:FTexture)
        {
            _cMaskTexture = p_maskTexture;
            fragmentCode = "tex ft1, v0, fs1 <2d,clamp,linear,mipnone>\t\nmul ft0, ft0, ft1.wwww                     \n";
        }

        override public function bind(p_context:Context3D, p_texture:FTexture):void
        {
            super.bind(p_context, p_texture);
            if (_cMaskTexture == null)
            {
                throw (Error("There is no mask set."));
            };
            p_context.setTextureAt(1, _cMaskTexture.cContextTexture.tTexture);
        }

        override public function clear(p_context:Context3D):void
        {
            p_context.setTextureAt(1, null);
        }


    }
}//package com.flengine.context.filters

