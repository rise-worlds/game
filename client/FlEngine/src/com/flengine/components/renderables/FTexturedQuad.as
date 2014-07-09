// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.FTexturedQuad

package com.flengine.components.renderables
{
    import __AS3__.vec.Vector;
    import com.flengine.context.filters.FFilter;
    import com.flengine.textures.FTexture;
    import com.flengine.core.FNode;
    import com.flengine.components.FTransform;
    import com.flengine.context.FContext;
    import com.flengine.components.FCamera;
    import flash.geom.Rectangle;
    import flash.geom.Matrix3D;
    import flash.geom.Vector3D;
    import flash.events.MouseEvent;
	import com.flengine.fl2d;
	use namespace fl2d;

    public class FTexturedQuad extends FRenderable 
    {

        private static const NORMALIZED_VERTICES_3D:Vector.<Number> = Vector.<Number>([-0.5, 0.5, 0, -0.5, -0.5, 0, 0.5, -0.5, 0, 0.5, 0.5, 0]);

        public var filter:FFilter;
        fl2d var cTexture:FTexture;
        protected var _aTransformedVertices:Vector.<Number>;
        public var mousePixelEnabled:Boolean = false;

        public function FTexturedQuad(p_node:FNode)
        {
            _aTransformedVertices = new Vector.<Number>();
            super(p_node);
        }

        public function getTexture():FTexture
        {
            return (cTexture);
        }

        override public function render(p_context:FContext, p_camera:FCamera, p_maskRect:Rectangle):void
        {
            if (cTexture == null)
            {
                return;
            };
            var _local4:FTransform = cNode.cTransform;
            p_context.draw(cTexture, _local4.nWorldX, _local4.nWorldY, _local4.nWorldScaleX, _local4.nWorldScaleY, _local4.nWorldRotation, _local4.nWorldRed, _local4.nWorldGreen, _local4.nWorldBlue, _local4.nWorldAlpha, iBlendMode, p_maskRect, filter);
        }

        override public function getWorldBounds(p_target:Rectangle=null):Rectangle
        {
            var _local4:int;
            var _local2:Vector.<Number> = getTransformedVertices3D();
            if (_local2 == null)
            {
                return (p_target);
            };
            if (p_target)
            {
                p_target.setTo(_local2[0], _local2[1], 0, 0);
            }
            else
            {
                p_target = new Rectangle(_local2[0], _local2[1], 0, 0);
            };
            var _local3:int = _local2.length;
            _local4 = 3;
            while (_local4 < _local3)
            {
                if (p_target.left > _local2[_local4])
                {
                    p_target.left = _local2[_local4];
                };
                if (p_target.right < _local2[_local4])
                {
                    p_target.right = _local2[_local4];
                };
                if (p_target.top > _local2[(_local4 + 1)])
                {
                    p_target.top = _local2[(_local4 + 1)];
                };
                if (p_target.bottom < _local2[(_local4 + 1)])
                {
                    p_target.bottom = _local2[(_local4 + 1)];
                };
                _local4 = (_local4 + 3);
            };
            return (p_target);
        }

        fl2d function getTransformedVertices3D():Vector.<Number>
        {
            if (cTexture == null)
            {
                return (null);
            };
            var _local1:Rectangle = cTexture.region;
            var _local2:Matrix3D = cNode.cTransform.worldTransformMatrix;
            _local2.prependTranslation(-(cTexture.nPivotX), -(cTexture.nPivotY), 0);
            _local2.prependScale(_local1.width, _local1.height, 1);
            _local2.transformVectors(NORMALIZED_VERTICES_3D, _aTransformedVertices);
            _local2.prependScale((1 / _local1.width), (1 / _local1.height), 1);
            _local2.prependTranslation(cTexture.nPivotX, cTexture.nPivotY, 0);
            return (_aTransformedVertices);
        }

        public function hitTestObject(p_sprite:FTexturedQuad):Boolean
        {
            var _local3:Vector.<Number> = p_sprite.getTransformedVertices3D();
            var _local2:Vector.<Number> = getTransformedVertices3D();
            var _local5:Number = ((((_local3[0] + _local3[3]) + _local3[6]) + _local3[9]) / 4);
            var _local4:Number = ((((_local3[1] + _local3[4]) + _local3[7]) + _local3[10]) / 4);
            if (isSeparating(_local3[3], _local3[4], (_local3[0] - _local3[3]), (_local3[1] - _local3[4]), _local5, _local4, _local2))
            {
                return (false);
            };
            if (isSeparating(_local3[6], _local3[7], (_local3[3] - _local3[6]), (_local3[4] - _local3[7]), _local5, _local4, _local2))
            {
                return (false);
            };
            if (isSeparating(_local3[9], _local3[10], (_local3[6] - _local3[9]), (_local3[7] - _local3[10]), _local5, _local4, _local2))
            {
                return (false);
            };
            if (isSeparating(_local3[0], _local3[1], (_local3[9] - _local3[0]), (_local3[10] - _local3[1]), _local5, _local4, _local2))
            {
                return (false);
            };
            _local5 = ((((_local2[0] + _local2[3]) + _local2[6]) + _local2[9]) / 4);
            _local4 = ((((_local2[1] + _local2[4]) + _local2[7]) + _local2[10]) / 4);
            if (isSeparating(_local2[3], _local2[4], (_local2[0] - _local2[3]), (_local2[1] - _local2[4]), _local5, _local4, _local3))
            {
                return (false);
            };
            if (isSeparating(_local2[6], _local2[7], (_local2[3] - _local2[6]), (_local2[4] - _local2[7]), _local5, _local4, _local3))
            {
                return (false);
            };
            if (isSeparating(_local2[9], _local2[10], (_local2[6] - _local2[9]), (_local2[7] - _local2[10]), _local5, _local4, _local3))
            {
                return (false);
            };
            if (isSeparating(_local2[0], _local2[1], (_local2[9] - _local2[0]), (_local2[10] - _local2[1]), _local5, _local4, _local3))
            {
                return (false);
            };
            return (true);
        }

        private function isSeparating(p_sx:Number, p_sy:Number, p_ex:Number, p_ey:Number, p_cx:Number, p_cy:Number, p_vertices:Vector.<Number>):Boolean
        {
            var _local13:Number = -(p_ey);
            var _local14 = p_ex;
            var _local8:Number = ((_local13 * (p_cx - p_sx)) + (_local14 * (p_cy - p_sy)));
            var _local11:Number = ((_local13 * (p_vertices[0] - p_sx)) + (_local14 * (p_vertices[1] - p_sy)));
            var _local12:Number = ((_local13 * (p_vertices[3] - p_sx)) + (_local14 * (p_vertices[4] - p_sy)));
            var _local9:Number = ((_local13 * (p_vertices[6] - p_sx)) + (_local14 * (p_vertices[7] - p_sy)));
            var _local10:Number = ((_local13 * (p_vertices[9] - p_sx)) + (_local14 * (p_vertices[10] - p_sy)));
            if ((((((((((_local8 < 0)) && ((_local11 >= 0)))) && ((_local12 >= 0)))) && ((_local9 >= 0)))) && ((_local10 >= 0))))
            {
                return (true);
            };
            if ((((((((((_local8 > 0)) && ((_local11 <= 0)))) && ((_local12 <= 0)))) && ((_local9 <= 0)))) && ((_local10 <= 0))))
            {
                return (true);
            };
            return (false);
        }

        public function hitTestPoint(p_point:Vector3D, p_pixelEnabled:Boolean=false):Boolean
        {
            var _local4:Number = cTexture.width;
            var _local6:Number = cTexture.height;
            var _local5:Matrix3D = cNode.cTransform.getTransformedWorldTransformMatrix(_local4, _local6, 0, true);
            var _local3:Vector3D = _local5.transformVector(p_point);
            _local3.x = (_local3.x + 0.5);
            _local3.y = (_local3.y + 0.5);
            if ((((((((_local3.x >= (-(cTexture.nPivotX) / _local4))) && ((_local3.x <= (1 - (cTexture.nPivotX / _local4)))))) && ((_local3.y >= (-(cTexture.nPivotY) / _local6))))) && ((_local3.y <= (1 - (cTexture.nPivotY / _local6))))))
            {
                if (((mousePixelEnabled) && ((cTexture.getAlphaAtUV((_local3.x + (cTexture.pivotX / _local4)), (_local3.y + (cTexture.nPivotY / _local6))) == 0))))
                {
                    return (false);
                };
                return (true);
            };
            return (false);
        }

        override public function processMouseEvent(p_captured:Boolean, p_event:MouseEvent, p_position:Vector3D):Boolean
        {
            if (((p_captured) && ((p_event.type == "mouseUp"))))
            {
                cNode.cMouseDown = null;
            };
            if (((p_captured) || ((cTexture == null))))
            {
                if (cNode.cMouseOver == cNode)
                {
                    cNode.handleMouseEvent(cNode, "mouseOut", NaN, NaN, p_event.buttonDown, p_event.ctrlKey);
                };
                return (false);
            };
            var _local4:Number = cTexture.width;
            var _local7:Number = cTexture.height;
            var _local5:Matrix3D = cNode.cTransform.getTransformedWorldTransformMatrix(_local4, _local7, 0, true);
            var _local6:Vector3D = _local5.transformVector(p_position);
            _local6.x = (_local6.x + 0.5);
            _local6.y = (_local6.y + 0.5);
            if ((((((((_local6.x >= (-(cTexture.nPivotX) / _local4))) && ((_local6.x <= (1 - (cTexture.nPivotX / _local4)))))) && ((_local6.y >= (-(cTexture.nPivotY) / _local7))))) && ((_local6.y <= (1 - (cTexture.nPivotY / _local7))))))
            {
                if (((mousePixelEnabled) && ((cTexture.getAlphaAtUV((_local6.x + (cTexture.pivotX / _local4)), (_local6.y + (cTexture.nPivotY / _local7))) == 0))))
                {
                    if (cNode.cMouseOver == cNode)
                    {
                        cNode.handleMouseEvent(cNode, "mouseOut", ((_local6.x * _local4) + cTexture.nPivotX), ((_local6.y * _local7) + cTexture.nPivotY), p_event.buttonDown, p_event.ctrlKey);
                    };
                    return (false);
                };
                cNode.handleMouseEvent(cNode, p_event.type, ((_local6.x * _local4) + cTexture.nPivotX), ((_local6.y * _local7) + cTexture.nPivotY), p_event.buttonDown, p_event.ctrlKey);
                if (cNode.cMouseOver != cNode)
                {
                    cNode.handleMouseEvent(cNode, "mouseOver", ((_local6.x * _local4) + cTexture.nPivotX), ((_local6.y * _local7) + cTexture.nPivotY), p_event.buttonDown, p_event.ctrlKey);
                };
                return (true);
            };
            if (cNode.cMouseOver == cNode)
            {
                cNode.handleMouseEvent(cNode, "mouseOut", ((_local6.x * _local4) + cTexture.nPivotX), ((_local6.y * _local7) + cTexture.nPivotY), p_event.buttonDown, p_event.ctrlKey);
            };
            return (false);
        }

        override public function dispose():void
        {
            super.dispose();
            cTexture = null;
        }


    }
}//package com.flengine.components.renderables

