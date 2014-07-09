// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.FRenderable

package com.flengine.components.renderables
{
    import com.flengine.components.FComponent;
    import com.flengine.core.FNode;
    import flash.geom.Rectangle;
	import com.flengine.fl2d;
	use namespace fl2d;

    public class FRenderable extends FComponent 
    {

        var iBlendMode:int = 1;

        public function FRenderable(p_node:FNode)
        {
            super(p_node);
        }

        public function set blendMode(p_blendMode:int):void
        {
            iBlendMode = p_blendMode;
        }

        public function get blendMode():int
        {
            return (iBlendMode);
        }

        public function getWorldBounds(p_target:Rectangle=null):Rectangle
        {
            if (p_target)
            {
                p_target.setTo(cNode.cTransform.nWorldX, cNode.cTransform.nWorldY, 0, 0);
            }
            else
            {
                p_target = new Rectangle(cNode.cTransform.nWorldX, cNode.cTransform.nWorldY, 0, 0);
            };
            return (p_target);
        }


    }
}//package com.flengine.components.renderables

