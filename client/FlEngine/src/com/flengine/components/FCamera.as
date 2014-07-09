// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.FCamera

package com.flengine.components
{
    import __AS3__.vec.Vector;
    import flash.geom.Rectangle;
    import com.flengine.core.FNode;
    import com.flengine.context.FContext;
    import flash.events.MouseEvent;
    import flash.geom.Vector3D;
	import com.flengine.fl2d;
	use namespace fl2d;

    public class FCamera extends FComponent 
    {

        public var mask:int = 0xFFFFFF;
        public var normalizedViewX:Number = 0;
        public var normalizedViewY:Number = 0;
        public var normalizedViewWidth:Number = 1;
        public var normalizedViewHeight:Number = 1;
        public var backgroundRed:Number = 0;
        public var backgroundGreen:Number = 0;
        public var backgroundBlue:Number = 0;
        public var backgroundAlpha:Number = 0;
        fl2d var rViewRectangle:Rectangle;
        fl2d var rendererData:Object;
        fl2d var bCapturedThisFrame:Boolean = false;
        fl2d var nViewX:Number = 0;
        fl2d var nViewY:Number = 0;
        fl2d var nScaleX:Number = 1;
        fl2d var nScaleY:Number = 1;
        fl2d var aCameraVector:Vector.<Number>;
        fl2d var iRenderedNodesCount:int;

        public function FCamera(p_node:FNode)
        {
            aCameraVector = new <Number>[0, 0, 0, 0, 0, 0, 0, 0];
            super(p_node);
            rViewRectangle = new Rectangle();
            if (((!((cNode == cNode.cCore.root))) && (cNode.isOnStage())))
            {
                cNode.cCore.addCamera(this);
            };
            cNode.onAddedToStage.add(onAddedToStage);
            cNode.onRemovedFromStage.add(onRemovedFromStage);
        }

        override public function getPrototype():XML
        {
            _xPrototype = super.getPrototype();
            return (_xPrototype);
        }

        public function get backgroundColor():uint
        {
            var _local4:uint = ((backgroundAlpha * 0xFF) << 24);
            var _local1:uint = ((backgroundRed * 0xFF) << 16);
            var _local3:uint = ((backgroundGreen * 0xFF) << 8);
            var _local2:uint = (backgroundBlue * 0xFF);
            return ((((_local4 + _local1) + _local3) + _local2));
        }

        public function get zoom():Number
        {
            return (nScaleX);
        }

        public function set zoom(p_value:Number):void
        {
            nScaleX = (nScaleY = p_value);
        }

        override public function update(p_deltaTime:Number, p_parentTransformUpdate:Boolean, p_parentColorUpdate:Boolean):void
        {
        }

        fl2d function invalidate():void
        {
            rViewRectangle.x = (normalizedViewX * cNode.cCore.cConfig.viewRect.width);
            rViewRectangle.y = (normalizedViewY * cNode.cCore.cConfig.viewRect.height);
            var _local2:Number = ((((normalizedViewWidth + normalizedViewX))>1) ? (1 - normalizedViewX) : normalizedViewWidth);
            var _local1:Number = ((((normalizedViewHeight + normalizedViewY))>1) ? (1 - normalizedViewY) : normalizedViewHeight);
            rViewRectangle.width = (_local2 * cNode.cCore.cConfig.viewRect.width);
            rViewRectangle.height = (_local1 * cNode.cCore.cConfig.viewRect.height);
            aCameraVector[0] = cNode.cTransform.nWorldRotation;
            aCameraVector[1] = (rViewRectangle.x + (rViewRectangle.width / 2));
            aCameraVector[2] = (rViewRectangle.y + (rViewRectangle.height / 2));
            aCameraVector[4] = cNode.cTransform.nWorldX;
            aCameraVector[5] = cNode.cTransform.nWorldY;
            aCameraVector[6] = nScaleX;
            aCameraVector[7] = nScaleY;
        }

        override public function render(p_context:FContext, p_camera:FCamera, p_maskRect:Rectangle):void
        {
            if (((!((p_camera == null))) || (!(cNode.active))))
            {
                return;
            };
            iRenderedNodesCount = 0;
            if (backgroundAlpha != 0)
            {
                p_context.blitColor((rViewRectangle.x + (rViewRectangle.width / 2)), (rViewRectangle.y + (rViewRectangle.height / 2)), rViewRectangle.width, rViewRectangle.height, backgroundRed, backgroundGreen, backgroundBlue, backgroundAlpha, 1, rViewRectangle);
            };
            p_context.setCamera(this);
            cNode.cCore.root.render(p_context, this, rViewRectangle, false);
        }

        fl2d function captureMouseEvent(p_captured:Boolean, p_event:MouseEvent, p_position:Vector3D):Boolean
        {
            if (((bCapturedThisFrame) || (!(cNode.active))))
            {
                return (false);
            };
            bCapturedThisFrame = true;
            if (!rViewRectangle.contains(p_position.x, p_position.y))
            {
                return (false);
            };
            p_position.x = (p_position.x - (rViewRectangle.x + (rViewRectangle.width / 2)));
            p_position.y = (p_position.y - (rViewRectangle.y + (rViewRectangle.height / 2)));
            var _local6:Number = Math.cos(-(cNode.cTransform.nWorldRotation));
            var _local7:Number = Math.sin(-(cNode.cTransform.nWorldRotation));
            var _local5:Number = ((p_position.x * _local6) - (p_position.y * _local7));
            var _local4:Number = ((p_position.y * _local6) + (p_position.x * _local7));
            _local5 = (_local5 / nScaleY);
            _local4 = (_local4 / nScaleX);
            p_position.x = (_local5 + cNode.cTransform.nWorldX);
            p_position.y = (_local4 + cNode.cTransform.nWorldY);
            return (cNode.cCore.root.processMouseEvent(p_captured, p_event, p_position, this));
        }

        override public function dispose():void
        {
            cNode.cCore.removeCamera(this);
            cNode.onAddedToStage.remove(onAddedToStage);
            cNode.onRemovedFromStage.remove(onRemovedFromStage);
            super.dispose();
        }

        private function onAddedToStage(value:Object):void
        {
            cNode.cCore.addCamera(this);
        }

        private function onRemovedFromStage(value:Object):void
        {
            cNode.cCore.removeCamera(this);
        }


    }
}//package com.flengine.components

