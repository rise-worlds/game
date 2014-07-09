// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.filters.FPixelateFilter

package com.flengine.context.filters
{
    import __AS3__.vec.Vector;
    import flash.display3D.Context3D;
    import com.flengine.textures.FTexture;

    public class FPixelateFilter extends FFilter 
    {

        public var pixelSize:int = 1;

        public function FPixelateFilter(p_pixelSize:int)
        {
            iId = 10;
            bOverrideFragmentShader = true;
            fragmentCode = "div ft0, v0, fc1                       \nfrc ft1, ft0                           \nsub ft0, ft0, ft1                      \nmul ft1, ft0, fc1                      \nadd ft0.xy, ft1,xy, fc1.zw \t\t\t\ntex oc, ft0, fs0<2d, clamp, nearest>";
            pixelSize = p_pixelSize;
        }

        override public function bind(p_context:Context3D, p_texture:FTexture):void
        {
            _aFragmentConstants = new <Number>[(pixelSize / p_texture.gpuWidth), (pixelSize / p_texture.gpuHeight), (pixelSize / (p_texture.gpuWidth * 2)), (pixelSize / (p_texture.gpuHeight * 2))];
            super.bind(p_context, p_texture);
        }


    }
}//package com.flengine.context.filters

