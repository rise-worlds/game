// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.FSprite

package com.flengine.components.renderables
{
    import com.flengine.core.FNode;
    import com.flengine.textures.FTextureBase;
    import com.flengine.textures.FTexture;
	import com.flengine.fl2d;
	use namespace fl2d;

    public class FSprite extends FTexturedQuad 
    {

        public function FSprite(p_node:FNode)
        {
            super(p_node);
        }

        public function get textureId():String
        {
            if (cTexture)
            {
                return (cTexture.id);
            };
            return ("");
        }

        public function set textureId(p_value:String):void
        {
            cTexture = (FTextureBase.getTextureBaseById(p_value) as FTexture);
        }

        public function setTexture(p_texture:FTexture):void
        {
            cTexture = p_texture;
        }


    }
}//package com.flengine.components.renderables

