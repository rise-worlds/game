// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.physics.FBody

package com.flengine.components.physics
{
    import com.flengine.components.FComponent;
    import com.flengine.core.FNode;
    import com.flengine.components.FTransform;
	import com.flengine.fl2d;
	use namespace fl2d;

    public class FBody extends FComponent 
    {

        public function FBody(p_node:FNode):void
        {
            super(p_node);
        }

        public function get x():Number
        {
            return (0);
        }

        public function set x(p_x:Number):void
        {
        }

        public function get y():Number
        {
            return (0);
        }

        public function set y(p_y:Number):void
        {
        }

        public function get scaleX():Number
        {
            return (1);
        }

        public function set scaleX(p_scaleX:Number):void
        {
        }

        public function get scaleY():Number
        {
            return (1);
        }

        public function set scaleY(p_scaleY:Number):void
        {
        }

        public function get rotation():Number
        {
            return (0);
        }

        public function set rotation(p_rotation:Number):void
        {
        }

        public function isDynamic():Boolean
        {
            return (false);
        }

        public function isKinematic():Boolean
        {
            return (false);
        }

        fl2d function addToSpace():void
        {
        }

        fl2d function removeFromSpace():void
        {
        }

        fl2d function invalidateKinematic(p_transform:FTransform):void
        {
        }


    }
}//package com.flengine.components.physics

