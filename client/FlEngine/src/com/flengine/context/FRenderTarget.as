// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.FRenderTarget

package com.flengine.context
{
    import com.flengine.textures.FTexture;
    import flash.geom.Matrix3D;

    public class FRenderTarget 
    {

        public static const DEFAULT_RENDER_TARGET:FRenderTarget = new (FRenderTarget)();

        var cTexture:FTexture;
        var mMatrix:Matrix3D;
        var iRenderedTo:int = 0;

        public function FRenderTarget(p_texture:FTexture=null, p_matrix:Matrix3D=null)
        {
            cTexture = p_texture;
            mMatrix = p_matrix;
        }

        public function toString():String
        {
            return ((((((("[" + ((cTexture) ? cTexture.id : "BackBuffer")) + " , ") + mMatrix) + " , ") + iRenderedTo) + "]"));
        }


    }
}//package com.flengine.context

