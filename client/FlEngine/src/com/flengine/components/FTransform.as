// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.FTransform

package com.flengine.components
{
    import flash.geom.Matrix3D;
    import com.flengine.core.FNode;
    import flash.geom.Rectangle;
    import flash.geom.Vector3D;
	import com.flengine.fl2d;
	use namespace fl2d;

    public class FTransform extends FComponent 
    {

        public var visible:Boolean = true;
        private var __bWorldTransformMatrixDirty:Boolean = true;
        private var __mWorldTransformMatrix:Matrix3D;
        private var __mLocalTransformMatrix:Matrix3D;
        fl2d var bTransformDirty:Boolean = true;
        fl2d var nWorldX:Number = 0;
        fl2d var nLocalX:Number = 0;
        fl2d var nWorldY:Number = 0;
        fl2d var nLocalY:Number = 0;
        fl2d var nWorldScaleX:Number = 1;
        private var __nLocalScaleX:Number = 1;
        fl2d var nWorldScaleY:Number = 1;
        private var __nLocalScaleY:Number = 1;
        fl2d var nWorldRotation:Number = 0;
        private var __nLocalRotation:Number = 0;
        fl2d var bColorDirty:Boolean = true;
        fl2d var nWorldRed:Number = 1;
        private var _red:Number = 1;
        fl2d var nWorldGreen:Number = 1;
        private var _green:Number = 1;
        fl2d var nWorldBlue:Number = 1;
        private var _blue:Number = 1;
        fl2d var nWorldAlpha:Number = 1;
        private var _alpha:Number = 1;
        public var useWorldSpace:Boolean = false;
        public var useWorldColor:Boolean = false;
        fl2d var cMask:FNode;
        fl2d var rMaskRect:Rectangle;
        fl2d var rAbsoluteMaskRect:Rectangle;

        public function FTransform(p_node:FNode)
        {
            __mWorldTransformMatrix = new Matrix3D();
            __mLocalTransformMatrix = new Matrix3D();
            super(p_node);
        }

        public function get worldTransformMatrix():Matrix3D
        {
            var _local2:Number;
            var _local1:Number;
            if (__bWorldTransformMatrixDirty)
            {
                _local2 = (((nWorldScaleX)==0) ? 1E-6 : nWorldScaleX);
                _local1 = (((nWorldScaleY)==0) ? 1E-6 : nWorldScaleY);
                __mWorldTransformMatrix.identity();
                __mWorldTransformMatrix.prependScale(_local2, _local1, 1);
                __mWorldTransformMatrix.prependRotation(((nWorldRotation * 180) / 3.14159265358979), Vector3D.Z_AXIS);
                __mWorldTransformMatrix.appendTranslation(nWorldX, nWorldY, 0);
                __bWorldTransformMatrixDirty = false;
            };
            return (__mWorldTransformMatrix);
        }

        public function get localTransformMatrix():Matrix3D
        {
            __mLocalTransformMatrix.identity();
            __mLocalTransformMatrix.prependScale(__nLocalScaleX, __nLocalScaleY, 1);
            __mLocalTransformMatrix.prependRotation(((__nLocalRotation * 180) / 3.14159265358979), Vector3D.Z_AXIS);
            __mLocalTransformMatrix.appendTranslation(nLocalX, nLocalY, 0);
            return (__mLocalTransformMatrix);
        }

        override public function set active(p_active:Boolean):void
        {
            super.active = p_active;
            bTransformDirty = _bActive;
        }

        public function getTransformedWorldTransformMatrix(p_scaleX:Number, p_scaleY:Number, p_rotation:Number, p_invert:Boolean):Matrix3D
        {
            var _local5:Matrix3D = worldTransformMatrix.clone();
            if (((!((p_scaleX == 1))) && (!((p_scaleY == 1)))))
            {
                _local5.prependScale(p_scaleX, p_scaleY, 1);
            };
            if (p_rotation != 0)
            {
                _local5.prependRotation(p_rotation, Vector3D.Z_AXIS);
            };
            if (p_invert)
            {
                _local5.invert();
            };
            return (_local5);
        }

        public function get x():Number
        {
            return (nLocalX);
        }

        public function set x(p_x:Number):void
        {
            nWorldX = (nLocalX = p_x);
            bTransformDirty = true;
            if (cNode.cBody)
            {
                cNode.cBody.x = p_x;
            };
            if (rMaskRect)
            {
                rAbsoluteMaskRect.x = (rMaskRect.x + nWorldX);
            };
        }

        public function get y():Number
        {
            return (nLocalY);
        }

        public function set y(p_y:Number):void
        {
            nWorldY = (nLocalY = p_y);
            bTransformDirty = true;
            if (cNode.cBody)
            {
                cNode.cBody.y = p_y;
            };
            if (rMaskRect)
            {
                rAbsoluteMaskRect.y = (rMaskRect.y + nWorldY);
            };
        }

        public function setPosition(p_x:Number, p_y:Number):void
        {
            nWorldX = (nLocalX = p_x);
            nWorldY = (nLocalY = p_y);
            bTransformDirty = true;
            if (cNode.cBody)
            {
                cNode.cBody.x = p_x;
                cNode.cBody.y = p_y;
            };
            if (rMaskRect)
            {
                rAbsoluteMaskRect.x = (rMaskRect.x + nWorldX);
                rAbsoluteMaskRect.y = (rMaskRect.y + nWorldY);
            };
        }

        public function setScale(p_scaleX:Number, p_scaleY:Number):void
        {
            nWorldScaleX = (__nLocalScaleX = p_scaleX);
            nWorldScaleY = (__nLocalScaleY = p_scaleY);
            bTransformDirty = true;
            if (cNode.cBody)
            {
                cNode.cBody.scaleX = p_scaleX;
                cNode.cBody.scaleY = p_scaleY;
            };
        }

        public function get scaleX():Number
        {
            return (__nLocalScaleX);
        }

        public function set scaleX(p_scaleX:Number):void
        {
            nWorldScaleX = (__nLocalScaleX = p_scaleX);
            bTransformDirty = true;
            if (cNode.cBody)
            {
                cNode.cBody.scaleX = p_scaleX;
            };
        }

        public function get scaleY():Number
        {
            return (__nLocalScaleY);
        }

        public function set scaleY(p_scaleY:Number):void
        {
            nWorldScaleY = (__nLocalScaleY = p_scaleY);
            bTransformDirty = true;
            if (cNode.cBody)
            {
                cNode.cBody.scaleY = p_scaleY;
            };
        }

        public function get rotation():Number
        {
            return (__nLocalRotation);
        }

        public function set rotation(p_rotation:Number):void
        {
            nWorldRotation = (__nLocalRotation = p_rotation);
            bTransformDirty = true;
            if (cNode.cBody)
            {
                cNode.cBody.rotation = p_rotation;
            };
        }

        public function set color(p_value:int):void
        {
            red = (((p_value >> 16) & 0xFF) / 0xFF);
            green = (((p_value >> 8) & 0xFF) / 0xFF);
            blue = ((p_value & 0xFF) / 0xFF);
        }

        public function get red():Number
        {
            return (_red);
        }

        public function set red(p_red:Number):void
        {
            nWorldRed = (_red = p_red);
            bColorDirty = true;
        }

        public function get green():Number
        {
            return (_green);
        }

        public function set green(p_green:Number):void
        {
            nWorldGreen = (_green = p_green);
            bColorDirty = true;
        }

        public function get blue():Number
        {
            return (_blue);
        }

        public function set blue(p_blue:Number):void
        {
            nWorldBlue = (_blue = p_blue);
            bColorDirty = true;
        }

        public function get alpha():Number
        {
            return (_alpha);
        }

        public function set alpha(p_alpha:Number):void
        {
            nWorldAlpha = (_alpha = p_alpha);
            bColorDirty = true;
        }

        public function get mask():FNode
        {
            return (cMask);
        }

        public function set mask(p_mask:FNode):void
        {
            if (cMask)
            {
                cMask.iUsedAsMask--;
            };
            cMask = p_mask;
            cMask.iUsedAsMask++;
        }

        public function get maskRect():Rectangle
        {
            return (rMaskRect);
        }

        public function set maskRect(p_rect:Rectangle):void
        {
            rMaskRect = p_rect;
            rAbsoluteMaskRect = p_rect.clone();
            rAbsoluteMaskRect.x = (rAbsoluteMaskRect.x + nWorldX);
            rAbsoluteMaskRect.y = (rAbsoluteMaskRect.y + nWorldY);
        }

        fl2d function invalidate(p_invalidateTransform:Boolean, p_invalidateColor:Boolean):void
        {
            var _local3:Number;
            var _local5:Number;
            if (cNode.cParent == null)
            {
                bColorDirty = (bTransformDirty = false);
                return;
            };
            var _local4:FTransform = cNode.cParent.cTransform;
            if (((!((cNode.cBody == null))) && (cNode.cBody.isDynamic())))
            {
                nLocalX = (nWorldX = cNode.cBody.x);
                nLocalY = (nWorldY = cNode.cBody.y);
                __nLocalRotation = (nWorldRotation = cNode.cBody.rotation);
                __bWorldTransformMatrixDirty = true;
            }
            else
            {
                if (p_invalidateTransform)
                {
                    if (!useWorldSpace)
                    {
                        if (_local4.nWorldRotation != 0)
                        {
                            _local3 = Math.cos(_local4.nWorldRotation);
                            _local5 = Math.sin(_local4.nWorldRotation);
                            nWorldX = ((((nLocalX * _local4.nWorldScaleX) * _local3) - ((nLocalY * _local4.nWorldScaleY) * _local5)) + _local4.nWorldX);
                            nWorldY = ((((nLocalY * _local4.nWorldScaleY) * _local3) + ((nLocalX * _local4.nWorldScaleX) * _local5)) + _local4.nWorldY);
                        }
                        else
                        {
                            nWorldX = ((nLocalX * _local4.nWorldScaleX) + _local4.nWorldX);
                            nWorldY = ((nLocalY * _local4.nWorldScaleY) + _local4.nWorldY);
                        };
                        nWorldScaleX = (__nLocalScaleX * _local4.nWorldScaleX);
                        nWorldScaleY = (__nLocalScaleY * _local4.nWorldScaleY);
                        nWorldRotation = (__nLocalRotation + _local4.nWorldRotation);
                        if (rMaskRect)
                        {
                            rAbsoluteMaskRect.x = (rMaskRect.x + nWorldX);
                            rAbsoluteMaskRect.y = (rMaskRect.y + nWorldY);
                        };
                        if (((!((cNode.cBody == null))) && (cNode.cBody.isKinematic())))
                        {
                            cNode.cBody.x = nWorldX;
                            cNode.cBody.y = nWorldY;
                            cNode.cBody.rotation = nWorldRotation;
                        };
                        bTransformDirty = false;
                        __bWorldTransformMatrixDirty = true;
                    };
                };
            };
            if (((p_invalidateColor) && (!(useWorldColor))))
            {
                nWorldRed = (_red * _local4.nWorldRed);
                nWorldGreen = (_green * _local4.nWorldGreen);
                nWorldBlue = (_blue * _local4.nWorldBlue);
                nWorldAlpha = (_alpha * _local4.nWorldAlpha);
                bColorDirty = false;
            };
        }

        public function setColor(p_red:Number=1, p_green:Number=1, p_blue:Number=1, p_alpha:Number=1):void
        {
            red = p_red;
            green = p_green;
            blue = p_blue;
            alpha = p_alpha;
        }

        public function worldToLocal(p_position:Vector3D):Vector3D
        {
            if (cNode.cParent == null)
            {
                return (p_position);
            };
            var _local2:Matrix3D = getTransformedWorldTransformMatrix(1, 1, 0, true);
            return (_local2.transformVector(p_position));
        }

        public function localToWorld(p_position:Vector3D):Vector3D
        {
            if (cNode.cParent == null)
            {
                return (p_position);
            };
            p_position = localTransformMatrix.transformVector(p_position);
            return (cNode.cParent.cTransform.localToWorld(p_position));
        }

        public function toString():String
        {
            return ((((((((((((("[" + x) + ",") + y) + ",") + scaleX) + ",") + scaleY) + "]\n[") + nWorldX) + ",") + nWorldY) + "]"));
        }


    }
}//package com.flengine.components

