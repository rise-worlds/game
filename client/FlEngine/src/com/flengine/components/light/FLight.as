// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.light.FLight

package com.flengine.components.light
{
    import com.flengine.components.FComponent;
    import com.flengine.textures.FTexture;
    import com.flengine.core.FNode;

    public class FLight extends FComponent 
    {

        public var shadows:Boolean = true;
        var cTexture:FTexture;
        var iRadius:int;
        var iRadiusSquared:int;

        public function FLight(p_node:FNode)
        {
            super(p_node);
            radius = 100;
        }

        public function get radius():int
        {
            return (iRadius);
        }

        public function set radius(p_value:int):void
        {
            iRadius = p_value;
            iRadiusSquared = (iRadius * iRadius);
        }

        public function getTexture():FTexture
        {
            return (cTexture);
        }

        public function set textureId(p_value:String):void
        {
            cTexture = FTexture.getTextureById(p_value);
        }

        public function get textureId():String
        {
            if (cTexture)
            {
                return (cTexture.id);
            };
            return ("");
        }

        public function toString():String
        {
            return (((node.transform.x + ":") + node.transform.y));
        }


    }
}//package com.flengine.components.light

