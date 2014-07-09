// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.jointanim.JAnim

package com.genome2d.components.renderables.jointanim
{
	import com.genome2d.components.GComponent;
    import __AS3__.vec.Vector;
	import com.genome2d.components.renderables.jointanim.JAMemoryImage;
    import flash.geom.Rectangle;
    import flash.geom.Matrix3D;
    import flash.geom.Matrix;
    import com.genome2d.node.GNode;
    import flash.events.MouseEvent;
    import flash.geom.Vector3D;
    import com.genome2d.context.IContext;

    public class JAnim extends GComponent 
    {

        private static const NORMALIZED_VERTICES_3D:Vector.<Number> = Vector.<Number>([-0.5, 0.5, 0, -0.5, -0.5, 0, 0.5, -0.5, 0, 0.5, 0.5, 0]);

        private static var _helpTransform:JATransform = new JATransform();
        private static var _helpCallTransform:Vector.<JATransform> = new Vector.<JATransform>(1000);
        private static var _helpCallColor:Vector.<JAColor> = new Vector.<JAColor>(1000);
        private static var _helpCallDepth:int = 0;
        private static var _helpDrawSpriteASrcRect:Rectangle = new Rectangle();
        private static var _helpCalcTransform:JATransform;
        private static var _helpCalcColor:JAColor;
        private static var _helpANextObjectPos:Vector.<JAObjectPos> = new Vector.<JAObjectPos>(3);
        public static var UpdateCnt:int = 0;
        private static var _helpGetTransformedVertices3DTransformMatrix:Matrix3D = new Matrix3D();
        private static var _helpMatrix3DVector1:Vector.<Number> = Vector.<Number>([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]);
        private static var _helpMatrix3DArg1:Matrix3D = new Matrix3D();
        private static var _helpJAnimRender:JATransform2D = new JATransform2D();
        private static var _helpJAnimRenderVector:Vector.<Number> = new Vector.<Number>(16);
        private static var bInit:Boolean = false;
        private static var _helpDrawSprite:Matrix = new Matrix();

        private var _JointAnimate:JointAnimate;
        private var _id:int;
        private var _listener:JAnimListener;
        private var _animRunning:Boolean;
        private var _paused:Boolean;
        private var _interpolate:Boolean;
        private var _color:JAColor;
        private var _transform:JATransform2D;
        private var _drawTransform:JATransform2D;
        private var _mirror:Boolean;
        private var _additive:Boolean;
        private var _inNode:Boolean;
        private var _mainSpriteInst:JASpriteInst;
        private var _transDirty:Boolean;
        private var _blendTicksTotal:Number;
        private var _blendTicksCur:Number;
        private var _blendDelay:Number;
        private var _lastPlayedFrameLabel:String;
        private var _helpGetTransformedVertices3DVector:Vector.<Number>;

        public function JAnim()// (p_node:FNode, jointAnimate:JointAnimate, id:int, listener:JAnimListener = null)
        {
            _helpGetTransformedVertices3DVector = new Vector.<Number>();
			super();
            //super(p_node);
            //if (jointAnimate == null)
            //{
            //    throw (new Error("Joint Animate is null!"));
            //};
            //_inNode = !((p_node == null));
            //_JointAnimate = jointAnimate;
            //_id = id;
            //_listener = listener;
            _mirror = false;
            _animRunning = false;
            _paused = false;
            _transform = new JATransform2D();
            //_interpolate = true;
            _interpolate = false;
            _color = new JAColor();
            _color.clone(JAColor.White);
            _additive = false;
            _transDirty = true;
            _mainSpriteInst = new JASpriteInst();
            _mainSpriteInst.spriteDef = null;
            _mainSpriteInst.parent = null;
            _blendDelay = 0;
            _blendTicksCur = 0;
            _blendTicksTotal = 0;
        }
		
		public function setJointAnim(jointAnimate:JointAnimate, id:int, listener:JAnimListener=null):void 
		{
			if (jointAnimate == null)
            {
                throw (new Error("Joint Animate is null!"));
            }
            _inNode = false;
            _JointAnimate = jointAnimate;
            _id = id;
            _listener = listener;
		}

        public static function HelpCallInitialize():void
        {
            var _local1:int;
            if (!bInit)
            {
                _helpCallTransform.fixed = true;
                _helpCallColor.fixed = true;
                _local1 = 0;
                while (_local1 < 1000)
                {
                    _helpCallTransform[_local1] = new JATransform();
                    _helpCallColor[_local1] = new JAColor();
                    _local1++;
                };
                bInit = true;
            };
        }


        override public function dispose():void
        {
            super.dispose();
            _color = null;
            _transform = null;
            _mainSpriteInst.Dispose();
            _JointAnimate = null;
        }

        //override public function processMouseEvent(p_captured:Boolean, p_event:MouseEvent, p_position:Vector3D):Boolean
        //{
        //    return (false);
        //}

        //override public function getWorldBounds(p_target:Rectangle=null):Rectangle
        //override public function getBounds(p_target:Rectangle=null):Rectangle
        //{
        //    var _local4:int;
        //    var _local2:Vector.<Number> = getTransformedVertices3D();
        //    if (p_target)
        //    {
        //        p_target.setTo(_local2[0], _local2[1], 0, 0);
        //    }
        //    else
        //    {
        //        p_target = new Rectangle(_local2[0], _local2[1], 0, 0);
        //    };
        //    var _local3:int = _local2.length;
        //    _local4 = 3;
        //    while (_local4 < _local3)
        //    {
        //        if (p_target.left > _local2[_local4])
        //        {
        //            p_target.left = _local2[_local4];
        //        };
        //        if (p_target.right < _local2[_local4])
        //        {
        //            p_target.right = _local2[_local4];
        //        };
        //        if (p_target.top > _local2[(_local4 + 1)])
        //        {
        //            p_target.top = _local2[(_local4 + 1)];
        //        };
        //        if (p_target.bottom < _local2[(_local4 + 1)])
        //        {
        //            p_target.bottom = _local2[(_local4 + 1)];
        //        };
        //        _local4 = (_local4 + 3);
        //    };
        //    return (p_target);
        //}
        //
        //private function getTransformedVertices3D():Vector.<Number>
        //{
		//	// TODO:
        //    //_helpGetTransformedVertices3DTransformMatrix.copyFrom(cNode.cTransform.worldTransformMatrix);
		//	var temp:Matrix3D = new Matrix3D;
		//	//temp.
		//	//_helpGetTransformedVertices3DTransformMatrix.copyFrom(
        //    _helpMatrix3DVector1[0] = _transform.m00;
        //    _helpMatrix3DVector1[1] = _transform.m10;
        //    _helpMatrix3DVector1[4] = _transform.m01;
        //    _helpMatrix3DVector1[5] = _transform.m11;
        //    _helpMatrix3DVector1[12] = _transform.m02;
        //    _helpMatrix3DVector1[13] = _transform.m12;
        //    _helpMatrix3DArg1.copyRawDataFrom(_helpMatrix3DVector1);
        //    _helpGetTransformedVertices3DTransformMatrix.prepend(_helpMatrix3DArg1);
        //    NORMALIZED_VERTICES_3D[0] = _JointAnimate.animRect.x;
        //    NORMALIZED_VERTICES_3D[1] = _JointAnimate.animRect.y;
        //    NORMALIZED_VERTICES_3D[2] = 0;
        //    NORMALIZED_VERTICES_3D[3] = _JointAnimate.animRect.x;
        //    NORMALIZED_VERTICES_3D[4] = (_JointAnimate.animRect.y + _JointAnimate.animRect.height);
        //    NORMALIZED_VERTICES_3D[5] = 0;
        //    NORMALIZED_VERTICES_3D[6] = (_JointAnimate.animRect.x + _JointAnimate.animRect.width);
        //    NORMALIZED_VERTICES_3D[7] = (_JointAnimate.animRect.y + _JointAnimate.animRect.height);
        //    NORMALIZED_VERTICES_3D[8] = 0;
        //    NORMALIZED_VERTICES_3D[9] = (_JointAnimate.animRect.x + _JointAnimate.animRect.width);
        //    NORMALIZED_VERTICES_3D[10] = _JointAnimate.animRect.y;
        //    NORMALIZED_VERTICES_3D[11] = 0;
        //    _helpGetTransformedVertices3DTransformMatrix.transformVectors(NORMALIZED_VERTICES_3D, _helpGetTransformedVertices3DVector);
        //    return (_helpGetTransformedVertices3DVector);
        //}
		//
        //override public function render(p_context:IContext, p_camera:FCamera, p_maskRect:Rectangle):void
        //{
        //    if (_inNode)
        //    {
        //        _drawTransform = JAMatrix3.MulJAMatrix3_M3D(cNode.cTransform.worldTransformMatrix, _transform, _helpJAnimRender);
        //    }
        //    else
        //    {
        //        _drawTransform = _transform;
        //    };
        //    Draw(p_context);
        //}
        //
        //override public function update(p_deltaTime:Number, p_parentTransformUpdate:Boolean, p_parentColorUpdate:Boolean):void
        //{
        //    if (_inNode)
        //    {
        //        _drawTransform = JAMatrix3.MulJAMatrix3_M3D(cNode.cTransform.worldTransformMatrix, _transform, _helpJAnimRender);
        //    }
        //    else
        //    {
        //        _drawTransform = _transform;
        //    };
        //    Update((p_deltaTime * 0.1));
        //}

        public function get transform():JATransform2D
        {
            return (_transform);
        }

        public function get lastPlayedLabel():String
        {
            return (_lastPlayedFrameLabel);
        }

        public function get interpolate():Boolean
        {
            return (_interpolate);
        }

        public function set interpolate(val:Boolean):void
        {
            //_interpolate = val;
        }

        public function set mirror(val:Boolean):void
        {
            _mirror = val;
        }

        public function get mirror():Boolean
        {
            return (_mirror);
        }

        public function set additive(val:Boolean):void
        {
            _additive = val;
        }

        public function get additive():Boolean
        {
            return (_additive);
        }

        public function set color(c:uint):void
        {
            _color.alpha = ((c >> 24) & 0xFF);
            _color.red = ((c >> 16) & 0xFF);
            _color.green = ((c >> 8) & 0xFF);
            _color.blue = (c & 0xFF);
        }

        public function get color():uint
        {
            return (_color.toInt());
        }

        public function get mainSpriteInst():JASpriteInst
        {
            return (_mainSpriteInst);
        }

        public function IsActive():Boolean
        {
            if (_animRunning)
            {
                return (true);
            };
            return (false);
        }

        public function GetToFirstFrame():void
        {
            var _local1:Boolean;
            var _local2:Boolean;
            while (((!((_mainSpriteInst.spriteDef == null))) && ((_mainSpriteInst.frameNum < _mainSpriteInst.spriteDef.workAreaStart))))
            {
                _local1 = _animRunning;
                _local2 = _paused;
                _animRunning = true;
                _paused = false;
                Update(0);
                _animRunning = _local1;
                _paused = _local2;
            };
        }

        public function ResetAnim():void
        {
            ResetAnimHelper(_mainSpriteInst);
            _animRunning = false;
            GetToFirstFrame();
            _blendTicksTotal = 0;
            _blendTicksCur = 0;
            _blendDelay = 0;
        }

        public function SetupSpriteInst(theName:String=""):Boolean
        {
            var _local4:int;
            if (_mainSpriteInst == null)
            {
                return (false);
            };
            if (((!((_mainSpriteInst.spriteDef == null))) && ((theName == ""))))
            {
                return (true);
            };
            if (_JointAnimate.mainAnimDef.mainSpriteDef != null)
            {
                InitSpriteInst(_mainSpriteInst, _JointAnimate.mainAnimDef.mainSpriteDef);
                return (true);
            };
            if (_JointAnimate.mainAnimDef.spriteDefVector.length == 0)
            {
                return (false);
            };
            var _local3:String = theName;
            if (_local3.length == 0)
            {
                _local3 = "main";
            };
            var _local2:JASpriteDef;
            _local4 = 0;
            while (_local4 < _JointAnimate.mainAnimDef.spriteDefVector.length)
            {
                if (((!((_JointAnimate.mainAnimDef.spriteDefVector[_local4].name == null))) && ((_JointAnimate.mainAnimDef.spriteDefVector[_local4].name == _local3))))
                {
                    _local2 = _JointAnimate.mainAnimDef.spriteDefVector[_local4];
                    _lastPlayedFrameLabel = _local3;
                    break;
                };
                _local4++;
            };
            if (_local2 == null)
            {
                _local2 = _JointAnimate.mainAnimDef.spriteDefVector[0];
            };
            if (_local2 != _mainSpriteInst.spriteDef)
            {
                if (_mainSpriteInst.spriteDef != null)
                {
                    _mainSpriteInst.Reset();
                    _mainSpriteInst.parent = null;
                };
                InitSpriteInst(_mainSpriteInst, _local2);
                _transDirty = true;
            };
            return (true);
        }

        public function Play(theFrameLabel:String, resetAnim:Boolean=true):Boolean
        {
            var _local3:int;
            _animRunning = false;
            if (_JointAnimate.mainAnimDef.mainSpriteDef)
            {
                if (!SetupSpriteInst())
                {
                    return (false);
                };
                _local3 = _JointAnimate.mainAnimDef.mainSpriteDef.GetLabelFrame(theFrameLabel);
                if (_local3 == -1)
                {
                    return (false);
                };
                _lastPlayedFrameLabel = theFrameLabel;
                return (PlayIndex(_local3, resetAnim));
            };
            _lastPlayedFrameLabel = theFrameLabel;
            SetupSpriteInst(theFrameLabel);
            return (PlayIndex(_mainSpriteInst.spriteDef.workAreaStart, resetAnim));
        }

        public function PlayIndex(theFrameNum:int=0, resetAnim:Boolean=true):Boolean
        {
            if (!SetupSpriteInst())
            {
                return (false);
            };
            if (theFrameNum >= _mainSpriteInst.spriteDef.frames.length)
            {
                _animRunning = false;
                return (false);
            };
            if (((!((_mainSpriteInst.frameNum == theFrameNum))) && (resetAnim)))
            {
                ResetAnim();
            };
            _paused = false;
            _animRunning = true;
            _mainSpriteInst.delayFrames = 0;
            _mainSpriteInst.frameNum = theFrameNum;
            _mainSpriteInst.lastFrameNum = theFrameNum;
            _mainSpriteInst.frameRepeats = 0;
            if (_blendDelay == 0)
            {
                DoFramesHit(_mainSpriteInst, null);
            };
            return (true);
        }

        public function Update(val:Number):void
        {
            if (!SetupSpriteInst())
            {
                return;
            };
            UpdateF(val);
        }

        private function UpdateF(val:Number):void
        {
            if (_paused)
            {
                return;
            };
            AnimUpdate(val);
        }

        public function Draw(p_context:IContext):void
        {
            if (!SetupSpriteInst())
            {
                return;
            };
            _helpCallDepth = 0;
            if (!_inNode)
            {
                _drawTransform = _transform;
            };
            if (_transDirty)
            {
                UpdateTransforms(_mainSpriteInst, null, _color, false);
                _transDirty = false;
            };
            DrawSprite(p_context, _mainSpriteInst, null, _color, _additive, false);
        }

        private function DrawSprite(p_context:IContext, theSpriteInst:JASpriteInst, theTransform:JATransform, theColor:JAColor, additive:Boolean, parentFrozen:Boolean):void
        {
            var _local7:JASpriteInst = null;
            var _local16:int;
            var _local20:JAObjectPos = null;
            var _local9:JAObjectInst = null;
            var _local24:JATransform = null;
            var _local8:JAColor = null;
            var _local19:int;
            var _local11:JAImage = null;
            var _local13:JATransform = null;
            var _local21:JAMemoryImage = null;
            var _local23:Rectangle = null;
            var _local12:Number;
            var _local14:Number;
            var _local18:int;
			var index:int = int(theSpriteInst.frameNum);
            var _local17:JAFrame = theSpriteInst.spriteDef.frames[index];
            var _local22:JATransform = _helpCallTransform[_helpCallDepth];
            var _local10:JAColor = _helpCallColor[_helpCallDepth];
            _helpCallDepth++;
            var _local15:Boolean = ((((parentFrozen) || ((theSpriteInst.delayFrames > 0)))) || (_local17.hasStop));
            _local16 = 0;
            while (_local16 < _local17.frameObjectPosVector.length)
            {
                _local20 = _local17.frameObjectPosVector[_local16];
                _local9 = theSpriteInst.children[_local20.objectNum];
                if (((!((_listener == null))) && (_local9.predrawCallback)))
                {
                    _local9.predrawCallback = _listener.JAnimObjectPredraw(_id, this, p_context, theSpriteInst, _local9, theTransform, theColor);
                };
                if (_local20.isSprite)
                {
                    _local7 = theSpriteInst.children[_local20.objectNum].spriteInst;
                    _local10.clone(_local7.curColor);
                    _local22.clone(_local7.curTransform);
                }
                else
                {
                    CalcObjectPos(theSpriteInst, _local16, _local15);
                    _local22 = _helpCalcTransform;
                    _local10 = _helpCalcColor;
                    _helpCalcTransform = null;
                    _helpCalcColor = null;
                };
                if ((((theTransform == null)) && (!((_JointAnimate.drawScale == 1)))))
                {
                    _helpTransform.matrix.LoadIdentity();
                    _helpTransform.matrix.m00 = _JointAnimate.drawScale;
                    _helpTransform.matrix.m11 = _JointAnimate.drawScale;
                    _helpTransform.matrix = JAMatrix3.MulJAMatrix3(_drawTransform, _helpTransform.matrix, _helpTransform.matrix);
                    _local24 = _helpTransform.TransformSrc(_local22, _local22);
                }
                else
                {
                    if ((((theTransform == null)) || (_local20.isSprite)))
                    {
                        _local24 = _local22;
                        if (_JointAnimate.drawScale != 1)
                        {
                            _helpTransform.matrix.LoadIdentity();
                            _helpTransform.matrix.m00 = _JointAnimate.drawScale;
                            _helpTransform.matrix.m11 = _JointAnimate.drawScale;
                            _local24.matrix = JAMatrix3.MulJAMatrix3(_helpTransform.matrix, _local24.matrix, _local24.matrix);
                        };//把本地坐标变换到世界坐标（偏移）
                        _local24.matrix = JAMatrix3.MulJAMatrix3(_drawTransform, _local24.matrix, _local24.matrix);
                    }
                    else
                    {
                        _local24 = theTransform.TransformSrc(_local22, _local22);
                    };
                };
                _local8 = _helpCallColor[_helpCallDepth];
                _helpCallDepth++;
                _local8.Set((((_local10.red * theColor.red) * _local9.colorMult.red) / 65025), (((_local10.green * theColor.green) * _local9.colorMult.green) / 65025), (((_local10.blue * theColor.blue) * _local9.colorMult.blue) / 65025), (((_local10.alpha * theColor.alpha) * _local9.colorMult.alpha) / 65025));
                if (_local8.alpha != 0)
                {
                    if (_local20.isSprite)
                    {
                        _local7 = theSpriteInst.children[_local20.objectNum].spriteInst;
                        DrawSprite(p_context, _local7, _local24, _local8, ((_local20.isAdditive) || (additive)), _local15);
                    }
                    else
                    {
                        _local19 = 0;
                        while (true)
                        {
                            _local11 = _JointAnimate.imageVector[_local20.resNum];
                            _local13 = _local24.TransformSrc(_local11.transform, _local24);
                            _local23 = _helpDrawSpriteASrcRect;
                            if ((((_local20.animFrameNum == 0)) || ((_local11.images.length == 1))))
                            {
                                _local21 = _local11.images[0];
                                _local21.GetCelRect(_local20.animFrameNum, _local23);
                            }
                            else
                            {
                                _local21 = _local11.images[_local20.animFrameNum];
                                _local21.GetCelRect(0, _local23);
                            };
                            if (_local20.hasSrcRect)
                            {
                                _local23 = _local20.srcRect;
                            };
                            if (_JointAnimate.imgScale != 1)
                            {
                                _local12 = _local13.matrix.m02;
                                _local14 = _local13.matrix.m12;
                                _helpTransform.matrix.LoadIdentity();
                                _helpTransform.matrix.m00 = (1 / _JointAnimate.imgScale);
                                _helpTransform.matrix.m11 = (1 / _JointAnimate.imgScale);
                                _local13 = _helpTransform.TransformSrc(_local13, _local13);
                                _local13.matrix.m02 = _local12;
                                _local13.matrix.m12 = _local14;
                            };
                            _local18 = 0;
                            if (((!((_listener == null))) && (_local9.imagePredrawCallback)))
                            {
                                _local18 = _listener.JAnimImagePredraw(theSpriteInst, _local9, _local13, _local21, p_context, _local19);
                                if (_local18 == 0)
                                {
                                    _local9.imagePredrawCallback = false;
                                };
                                if (_local18 == 2) break;
                            };
                            _helpTransform.matrix.LoadIdentity();
                            _helpTransform.matrix.m02 = (_local23.width / 2);
                            _helpTransform.matrix.m12 = (_local23.height / 2);
							if (_local21.imageExist)
							{
								_helpTransform.matrix.m02 -= _local21.texture.pivotX;
								_helpTransform.matrix.m12 -= _local21.texture.pivotY;
							}
                            //_helpTransform.matrix.m02 = -_local21.texture.frameWidth * 0.5 -_local21.texture.pivotX;
                            //_helpTransform.matrix.m12 = -_local21.texture.frameHeight * 0.5-_local21.texture.pivotY;
                            if (_mirror)
                            {
                                _helpTransform.matrix.m00 = -1;
                            };
                            _local13.matrix = JAMatrix3.MulJAMatrix3(_local13.matrix, _helpTransform.matrix, _local13.matrix);
                            if (_mirror)
                            {
                                _local13.matrix.m02 = ((_JointAnimate.animRect.width - _local13.matrix.m02) + (2 * _drawTransform.m02));
                                _local13.matrix.m01 = -(_local13.matrix.m01);
                                _local13.matrix.m10 = -(_local13.matrix.m10);
                            };
                            _helpDrawSprite.a = _local13.matrix.m00;
                            _helpDrawSprite.b = _local13.matrix.m10;
                            _helpDrawSprite.c = _local13.matrix.m01;
                            _helpDrawSprite.d = _local13.matrix.m11;
                            _helpDrawSprite.tx = _local13.matrix.m02;
                            _helpDrawSprite.ty = _local13.matrix.m12;
                            if (_local21.imageExist)
                            {
								// TODO:
                                //p_context.draw2(_local21.texture, _helpDrawSprite, (_local8.red * 0.003921568627451), (_local8.green * 0.003921568627451), (_local8.blue * 0.003921568627451), (_local8.alpha * 0.003921568627451), ((((additive) || (_local20.isAdditive))) ? 2 : 1));
                                p_context.drawMatrix(_local21.texture, 
									_helpDrawSprite.a, _helpDrawSprite.b, _helpDrawSprite.c, _helpDrawSprite.d, _helpDrawSprite.tx, _helpDrawSprite.ty,
									(_local8.red * 0.003921568627451), (_local8.green * 0.003921568627451), (_local8.blue * 0.003921568627451), (_local8.alpha * 0.003921568627451), ((((additive) || (_local20.isAdditive))) ? 2 : 1));
								//node.core.getContext().draw(_local21.texture, node.transform.g2d_worldX, node.transform.g2d_worldY, node.transform.g2d_worldScaleX, node.transform.g2d_worldScaleY, node.transform.g2d_worldRotation, node.transform.g2d_worldRed, node.transform.g2d_worldGreen, node.transform.g2d_worldBlue, node.transform.g2d_worldAlpha, 0, null);
                            }
                            else
                            {
                                if (_listener != null)
                                {
                                    _listener.JAnimImageNotExistDraw(_local21.name, p_context, _helpDrawSprite, (_local8.red * 0.003921568627451), (_local8.green * 0.003921568627451), (_local8.blue * 0.003921568627451), (_local8.alpha * 0.003921568627451), ((((additive) || (_local20.isAdditive))) ? 2 : 1));
                                };
                            };
                            if (_local18 != 3) break;
                            _local19++;
                        };
                        if (((!((_listener == null))) && (_local9.postdrawCallback)))
                        {
                            _local9.postdrawCallback = _listener.JAnimObjectPostdraw(_id, this, p_context, theSpriteInst, _local9, theTransform, theColor);
                        };
                    };
                };
                _local16++;
            };
        }

        private function AnimUpdate(val:Number):void
        {
            if (!_animRunning)
            {
                return;
            };
            if (_blendTicksTotal > 0)
            {
                _blendTicksCur = (_blendTicksCur + val);
                if (_blendTicksCur >= _blendTicksTotal)
                {
                    _blendTicksTotal = 0;
                };
            };
            _transDirty = true;
            if (_blendDelay > 0)
            {
                _blendDelay = (_blendDelay - val);
                if (_blendDelay <= 0)
                {
                    _blendDelay = 0;
                    DoFramesHit(_mainSpriteInst, null);
                };
                return;
            };
            IncSpriteInstFrame(_mainSpriteInst, null, val);
            PrepSpriteInstFrame(_mainSpriteInst, null);
        }

        private function PrepSpriteInstFrame(theSpriteInst:JASpriteInst, theObjectPos:JAObjectPos):void
        {
            var _local6:int;
            var _local10:int;
            var _local7:JAFrame = null;
            var _local11:int;
            var _local5:JAObjectPos = null;
            var _local8:JASpriteInst = null;
            var _local4:int;
            var _local3:int;
			var index:int = int(theSpriteInst.frameNum);
            var _local9:JAFrame = theSpriteInst.spriteDef.frames[index];
            if (theSpriteInst.onNewFrame)
            {
                if (theSpriteInst.lastFrameNum < theSpriteInst.frameNum)
                {
                    _local6 = theSpriteInst.frameNum;
                    _local10 = (theSpriteInst.lastFrameNum + 1);
                    while (_local10 < _local6)
                    {
                        _local7 = theSpriteInst.spriteDef.frames[_local10];
                        FrameHit(theSpriteInst, _local7, theObjectPos);
                        _local10++;
                    };
                };
                FrameHit(theSpriteInst, _local9, theObjectPos);
            };
            if (_local9.hasStop)
            {
                if (theSpriteInst == _mainSpriteInst)
                {
                    _animRunning = false;
                    if (_listener != null)
                    {
                        _listener.JAnimStopped(_id, this);
                    };
                };
                return;
            };
            _local11 = 0;
            while (_local11 < _local9.frameObjectPosVector.length)
            {
                _local5 = _local9.frameObjectPosVector[_local11];
                if (_local5.isSprite)
                {
                    _local8 = theSpriteInst.children[_local5.objectNum].spriteInst;
                    if (_local8 != null)
                    {
                        _local4 = (theSpriteInst.frameNum + (theSpriteInst.frameRepeats * theSpriteInst.spriteDef.frames.length));
                        _local3 = (theSpriteInst.lastFrameNum + (theSpriteInst.frameRepeats * theSpriteInst.spriteDef.frames.length));
                        if (((!((_local8.lastUpdated == _local3))) && (!((_local8.lastUpdated == _local4)))))
                        {
                            _local8.frameNum = 0;
                            _local8.lastFrameNum = 0;
                            _local8.frameRepeats = 0;
                            _local8.delayFrames = 0;
                            _local8.onNewFrame = true;
                        };
                        PrepSpriteInstFrame(_local8, _local5);
                        _local8.lastUpdated = _local4;
                    };
                };
                _local11++;
            };
        }

        private function IncSpriteInstFrame(theSpriteInst:JASpriteInst, theObjectPos:JAObjectPos, theFrac:Number):void
        {
            var _local9:int;
            var _local4:JAObjectPos = null;
            var _local8:JASpriteInst = null;
            var _local5:int = theSpriteInst.frameNum;
            var _local7:JAFrame = theSpriteInst.spriteDef.frames[_local5];
            if (_local7.hasStop)
            {
                return;
            };
            theSpriteInst.lastFrameNum = theSpriteInst.frameNum;
            var _local6:Number = (((theObjectPos)!=null) ? theObjectPos.timeScale : 1);
            theSpriteInst.frameNum = (theSpriteInst.frameNum + ((theFrac * (theSpriteInst.spriteDef.animRate / 100)) / _local6));
            if (theSpriteInst == _mainSpriteInst)
            {
                if (!theSpriteInst.spriteDef.frames[(theSpriteInst.spriteDef.frames.length - 1)].hasStop)
                {
                    if (theSpriteInst.frameNum >= ((theSpriteInst.spriteDef.workAreaStart + theSpriteInst.spriteDef.workAreaDuration) + 1))
                    {
                        theSpriteInst.frameRepeats++;
                        theSpriteInst.frameNum = (theSpriteInst.frameNum - (theSpriteInst.spriteDef.workAreaDuration + 1));
                        theSpriteInst.lastFrameNum = theSpriteInst.frameNum;
                    };
                }
                else
                {
                    if (theSpriteInst.frameNum >= (theSpriteInst.spriteDef.workAreaStart + theSpriteInst.spriteDef.workAreaDuration))
                    {
                        theSpriteInst.onNewFrame = true;
                        theSpriteInst.frameNum = (theSpriteInst.spriteDef.workAreaStart + theSpriteInst.spriteDef.workAreaDuration);
                        theSpriteInst.lastFrameNum = theSpriteInst.frameNum;
                        if (theSpriteInst.spriteDef.workAreaDuration != 0)
                        {
                            _animRunning = false;
                            if (_listener != null)
                            {
                                _listener.JAnimStopped(_id, this);
                            };
                            return;
                        };
                        theSpriteInst.frameRepeats++;
                    };
                };
            }
            else
            {
                if (theSpriteInst.frameNum >= theSpriteInst.spriteDef.frames.length)
                {
                    theSpriteInst.frameRepeats++;
                    theSpriteInst.frameNum = (theSpriteInst.frameNum - theSpriteInst.spriteDef.frames.length);
                };
            };
            theSpriteInst.onNewFrame = !((theSpriteInst.frameNum == _local5));
            if (((theSpriteInst.onNewFrame) && ((theSpriteInst.delayFrames > 0))))
            {
                theSpriteInst.onNewFrame = false;
                theSpriteInst.frameNum = _local5;
                theSpriteInst.lastFrameNum = theSpriteInst.frameNum;
                theSpriteInst.delayFrames--;
                return;
            };
            _local9 = 0;
            while (_local9 < _local7.frameObjectPosVector.length)
            {
                _local4 = _local7.frameObjectPosVector[_local9];
                if (_local4.isSprite)
                {
                    _local8 = theSpriteInst.children[_local4.objectNum].spriteInst;
                    IncSpriteInstFrame(_local8, _local4, (theFrac / _local6));
                };
                _local9++;
            };
        }

        private function DoFramesHit(theSpriteInst:JASpriteInst, theObjectPos:JAObjectPos):void
        {
            var _local6:int;
            var _local3:JAObjectPos = null;
            var _local4:JASpriteInst = null;
            var _local5:JAFrame = theSpriteInst.spriteDef.frames[theSpriteInst.frameNum];
            FrameHit(theSpriteInst, _local5, theObjectPos);
            _local6 = 0;
            while (_local6 < _local5.frameObjectPosVector.length)
            {
                _local3 = _local5.frameObjectPosVector[_local6];
                if (_local3.isSprite)
                {
                    _local4 = theSpriteInst.children[_local3.objectNum].spriteInst;
                    if (_local4 != null)
                    {
                        DoFramesHit(_local4, _local3);
                    };
                };
                _local6++;
            };
        }

        private function FrameHit(theSpriteInst:JASpriteInst, theFrame:JAFrame, theObjectPos:JAObjectPos):void
        {
            var _local13:int;
            var _local14:JAObjectPos = null;
            var _local8:JASpriteInst = null;
            var _local18:int;
            var _local16:int;
            var _local6:int;
            var _local4:String = null;
            var _local7:Boolean;
            var _local17:int;
            var _local11:int;
            var _local10:JACommand = null;
            var _local20:int;
            var _local19:String = null;
            var _local5:int;
            var _local12:Number;
            var _local15:Number;
            var _local9:String = null;
            theSpriteInst.onNewFrame = false;
            _local13 = 0;
            while (_local13 < theFrame.frameObjectPosVector.length)
            {
                _local14 = theFrame.frameObjectPosVector[_local13];
                if (_local14.isSprite)
                {
                    _local8 = theSpriteInst.children[_local14.objectNum].spriteInst;
                    if (_local8 != null)
                    {
                        _local18 = 0;
                        while (_local18 < _local14.preloadFrames)
                        {
                            IncSpriteInstFrame(_local8, _local14, (100 / theSpriteInst.spriteDef.animRate));
                            _local18++;
                        };
                    };
                };
                _local13++;
            };
            _local11 = 0;
            while (_local11 < theFrame.commandVector.length)
            {
                _local10 = theFrame.commandVector[_local11];
                if ((((_listener == null)) || (!(_listener.JAnimCommand(_id, this, theSpriteInst, _local10.command, _local10.param)))))
                {
                    if (_local10.command == "delay")
                    {
                        _local6 = _local10.param.indexOf(",");
                        if (_local6 != -1)
                        {
                            _local16 = parseInt(_local10.param.substr(0, _local6));
                            _local20 = parseInt(_local10.param.substr((_local6 + 1)));
                            if (_local20 <= _local16)
                            {
                                _local20 = (_local16 + 1);
                            };
                            theSpriteInst.delayFrames = (_local16 + ((Math.random() * 100000) % (_local20 - _local16)));
                        }
                        else
                        {
                            _local16 = parseInt(_local10.param);
                            theSpriteInst.delayFrames = _local16;
                        };
                    }
                    else
                    {
                        if (_local10.command == "playsample")
                        {
                            _local19 = _local10.param;
                            _local5 = 0;
                            _local12 = 1;
                            _local15 = 0;
                            _local7 = true;
                            while (_local19.length > 0)
                            {
                                _local6 = _local19.indexOf(",");
                                if (_local6 == -1)
                                {
                                    _local4 = _local19;
                                }
                                else
                                {
                                    _local4 = _local19.substr(0, _local6);
                                };
                                if (_local7)
                                {
                                    _local9 = _local4;
                                    _local7 = false;
                                }
                                else
                                {
                                    while ((_local17 = _local4.indexOf(" ")) != -1)
                                    {
                                        _local4 = (_local4.substr(0, _local17) + _local4.substr((_local17 + 1)));
                                    };
                                    if (_local4.substr(0, 7) == "volume=")
                                    {
                                        _local12 = parseFloat(_local4.substr(7));
                                    }
                                    else
                                    {
                                        if (_local4.substr(0, 4) == "pan=")
                                        {
                                            _local5 = parseInt(_local4.substr(4));
                                        }
                                        else
                                        {
                                            if (_local4.substr(0, 6) == "steps=")
                                            {
                                                _local15 = parseFloat(_local4.substr(6));
                                            };
                                        };
                                    };
                                };
                                if (_local6 == -1) break;
                                _local19 = _local19.substr((_local6 + 1));
                            };
                            if (_listener != null)
                            {
                                _listener.JAnimPLaySample(_local9, _local5, _local12, _local15);
                            };
                        };
                    };
                };
                _local11++;
            };
        }

        private function UpdateTransforms(theSpriteInst:JASpriteInst, theTransform:JATransform, theColor:JAColor, parentFrozen:Boolean):void
        {
            var _local9:int;
            var _local6:JAObjectPos = null;
            if (theTransform)
            {
                theSpriteInst.curTransform.clone(theTransform);
            }
            else
            {
                theSpriteInst.curTransform.matrix.clone(_drawTransform);
            };
            if (theSpriteInst.curColor == null)
            {
                theSpriteInst.curColor = new JAColor();
            };
            theSpriteInst.curColor.clone(theColor);
			var index:int = int(theSpriteInst.frameNum);
            var _local5:JAFrame = theSpriteInst.spriteDef.frames[index];
            var _local7:JATransform = _helpCallTransform[_helpCallDepth];
            var _local8:JAColor = _helpCallColor[_helpCallDepth];
            _helpCallDepth++;
            var _local10:Boolean = ((((parentFrozen) || ((theSpriteInst.delayFrames > 0)))) || (_local5.hasStop));
            _local9 = 0;
            while (_local9 < _local5.frameObjectPosVector.length)
            {
                _local6 = _local5.frameObjectPosVector[_local9];
                if (_local6.isSprite)
                {
                    CalcObjectPos(theSpriteInst, _local9, _local10);
                    _local7 = _helpCalcTransform;
                    _local8 = _helpCalcColor;
                    _helpCalcTransform = null;
                    _helpCalcColor = null;
                    if (theTransform != null)
                    {
                        _local7 = theTransform.TransformSrc(_local7, _local7);
                    };
                    UpdateTransforms(theSpriteInst.children[_local6.objectNum].spriteInst, _local7, _local8, _local10);
                };
                _local9++;
            };
        }

        private function CalcObjectPos(theSpriteInst:JASpriteInst, theObjectPosIdx:int, frozen:Boolean):void
        {
            //var _local17 = null;
            //var _local6 = null;
            //var _local7 = null;
            var _local10:int;
            var _local19:JAFrame = null;
            var _local8:int;
            var _local9:Number;
            var _local18:Boolean;
			var index:int = theSpriteInst.frameNum;
            var _local11:JAFrame = theSpriteInst.spriteDef.frames[index];
            var _local12:JAObjectPos = _local11.frameObjectPosVector[theObjectPosIdx];
            var _local5:JAObjectInst = theSpriteInst.children[_local12.objectNum];
            _helpANextObjectPos[0] = null;
            _helpANextObjectPos[1] = null;
            _helpANextObjectPos[2] = null;
            var _local14:int = (theSpriteInst.spriteDef.frames.length - 1);
            var _local16:int = 1;
            var _local13:int = 2;
            if ((((theSpriteInst == _mainSpriteInst)) && ((theSpriteInst.frameNum >= theSpriteInst.spriteDef.workAreaStart))))
            {
                _local14 = (theSpriteInst.spriteDef.workAreaDuration - 1);
            };
            var _local15:JATransform = _helpCallTransform[_helpCallDepth];
            var _local4:JAColor = _helpCallColor[_helpCallDepth];
            _helpCallDepth++;
            if (((_interpolate) && (!(frozen))))
            {
                _local10 = 0;
                while (_local10 < 3)
                {
                    _local19 = theSpriteInst.spriteDef.frames[((theSpriteInst.frameNum + (((_local10)==0) ? _local14 : (((_local10)==1) ? _local16 : _local13))) % theSpriteInst.spriteDef.frames.length)];
                    if ((((theSpriteInst == _mainSpriteInst)) && ((theSpriteInst.frameNum >= theSpriteInst.spriteDef.workAreaStart))))
                    {
                        _local19 = theSpriteInst.spriteDef.frames[((((theSpriteInst.frameNum + (((_local10)==0) ? _local14 : (((_local10)==1) ? _local16 : _local13))) - theSpriteInst.spriteDef.workAreaStart) % (theSpriteInst.spriteDef.workAreaDuration + 1)) + theSpriteInst.spriteDef.workAreaStart)];
                    }
                    else
                    {
                        _local19 = theSpriteInst.spriteDef.frames[((theSpriteInst.frameNum + (((_local10)==0) ? _local14 : (((_local10)==1) ? _local16 : _local13))) % theSpriteInst.spriteDef.frames.length)];
                    };
                    if (_local11.hasStop)
                    {
                        _local19 = _local11;
                    };
                    if (_local19.frameObjectPosVector.length > theObjectPosIdx)
                    {
                        _helpANextObjectPos[_local10] = _local19.frameObjectPosVector[theObjectPosIdx];
                        if (_helpANextObjectPos[_local10].objectNum != _local12.objectNum)
                        {
                            _helpANextObjectPos[_local10] = null;
                        };
                    };
                    if (_helpANextObjectPos[_local10] == null)
                    {
                        _local8 = 0;
                        while (_local8 < _local19.frameObjectPosVector.length)
                        {
                            if (_local19.frameObjectPosVector[_local8].objectNum == _local12.objectNum)
                            {
                                _helpANextObjectPos[_local10] = _local19.frameObjectPosVector[_local8];
                                break;
                            };
                            _local8++;
                        };
                    };
                    _local10++;
                };
                if (_helpANextObjectPos[1] != null)
                {
                    _local9 = (theSpriteInst.frameNum - Math.floor(theSpriteInst.frameNum));
                    _local18 = false;
                    _local15 = _local12.transform.InterpolateTo(_helpANextObjectPos[1].transform, _local9, _local15);
                    _local4.Set((((_local12.color.red * (1 - _local9)) + (_helpANextObjectPos[1].color.red * _local9)) + 0.5), (((_local12.color.green * (1 - _local9)) + (_helpANextObjectPos[1].color.green * _local9)) + 0.5), (((_local12.color.blue * (1 - _local9)) + (_helpANextObjectPos[1].color.blue * _local9)) + 0.5), (((_local12.color.alpha * (1 - _local9)) + (_helpANextObjectPos[1].color.alpha * _local9)) + 0.5));
                }
                else
                {
                    _local15.clone(_local12.transform);
                    _local4.clone(_local12.color);
                };
            }
            else
            {
                _local15.clone(_local12.transform);
                _local4.clone(_local12.color);
            };
            _local15.matrix = JAMatrix3.MulJAMatrix3(_local5.transform, _local15.matrix, _local15.matrix);
            if (((((_local5.isBlending) && (!((_blendTicksTotal == 0))))) && ((theSpriteInst == _mainSpriteInst))))
            {
                _local9 = (_blendTicksCur / _blendTicksTotal);
                _local15 = _local5.blendSrcTransform.InterpolateTo(_local15, _local9, _local15);
                _local4.Set((((_local5.blendSrcColor.red * (1 - _local9)) + (_local4.red * _local9)) + 0.5), (((_local5.blendSrcColor.green * (1 - _local9)) + (_local4.green * _local9)) + 0.5), (((_local5.blendSrcColor.blue * (1 - _local9)) + (_local4.blue * _local9)) + 0.5), (((_local5.blendSrcColor.alpha * (1 - _local9)) + (_local4.alpha * _local9)) + 0.5));
            };
            _helpCalcTransform = _local15;
            _helpCalcColor = _local4;
            _helpANextObjectPos[0] = null;
            _helpANextObjectPos[1] = null;
            _helpANextObjectPos[2] = null;
        }

        private function InitSpriteInst(theSpriteInst:JASpriteInst, theSpriteDef:JASpriteDef):void
        {
            var _local7:int;
            var _local6:JAObjectDef = null;
            var _local5:JAObjectInst = null;
            var _local4:JASpriteDef = null;
            var _local3:JASpriteInst = null;
            theSpriteInst.frameRepeats = 0;
            theSpriteInst.delayFrames = 0;
            theSpriteInst.spriteDef = theSpriteDef;
            theSpriteInst.lastUpdated = -1;
            theSpriteInst.onNewFrame = true;
            theSpriteInst.frameNum = 0;
            theSpriteInst.lastFrameNum = 0;
            theSpriteInst.children.splice(0, theSpriteInst.children.length);
            theSpriteInst.children.length = theSpriteDef.objectDefVector.length;
            _local7 = 0;
            while (_local7 < theSpriteDef.objectDefVector.length)
            {
                theSpriteInst.children[_local7] = new JAObjectInst();
                _local7++;
            };
            _local7 = 0;
            while (_local7 < theSpriteDef.objectDefVector.length)
            {
                _local6 = theSpriteDef.objectDefVector[_local7];
                _local5 = theSpriteInst.children[_local7];
                _local5.colorMult = new JAColor();
                _local5.colorMult.clone(JAColor.White);
                _local5.name = _local6.name;
                _local5.isBlending = false;
                _local4 = _local6.spriteDef;
                if (_local4 != null)
                {
                    _local3 = new JASpriteInst();
                    _local3.parent = theSpriteInst;
                    InitSpriteInst(_local3, _local4);
                    _local5.spriteInst = _local3;
                };
                _local7++;
            };
            if (theSpriteInst == _mainSpriteInst)
            {
                GetToFirstFrame();
            };
        }

        private function ResetAnimHelper(theSpriteInst:JASpriteInst):void
        {
            var _local3:int;
            var _local2:JASpriteInst = null;
            theSpriteInst.frameNum = 0;
            theSpriteInst.lastFrameNum = 0;
            theSpriteInst.frameRepeats = 0;
            theSpriteInst.delayFrames = 0;
            theSpriteInst.lastUpdated = -1;
            theSpriteInst.onNewFrame = true;
            _local3 = 0;
            while (_local3 < theSpriteInst.children.length)
            {
                _local2 = theSpriteInst.children[_local3].spriteInst;
                if (_local2 != null)
                {
                    ResetAnimHelper(_local2);
                };
                _local3++;
            };
            _transDirty = true;
        }


    }
}//package com.flengine.components.renderables.jointanim

