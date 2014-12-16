package com.genome2d.components.renderables.jointanim
{
	import com.genome2d.components.GComponent;
	import __AS3__.vec.Vector;
	import com.genome2d.components.renderables.jointanim.JAMemoryImage;
	import com.genome2d.context.GBlendMode;
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
		
		public function JAnim() // (p_node:FNode, jointAnimate:JointAnimate, id:int, listener:JAnimListener = null)
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
		
		public function setJointAnim(jointAnimate:JointAnimate, id:int, listener:JAnimListener = null):void
		{
			if (jointAnimate == null)
			{
				throw(new Error("Joint Animate is null!"));
			}
			_inNode = false;
			_JointAnimate = jointAnimate;
			_id = id;
			_listener = listener;
		}
		
		public static function HelpCallInitialize():void
		{
			if (!bInit)
			{
				_helpCallTransform.fixed = true;
				_helpCallColor.fixed = true;
				var i:int = 0;
				while (i < 1000)
				{
					_helpCallTransform[i] = new JATransform();
					_helpCallColor[i] = new JAColor();
					i++;
				}
				
				bInit = true;
			}
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
			}
			
			return (false);
		}
		
		public function GetToFirstFrame():void
		{
			while ((_mainSpriteInst.spriteDef != null) && (_mainSpriteInst.frameNum < _mainSpriteInst.spriteDef.workAreaStart))
			{
				var wasAnimRunning:Boolean = _animRunning;
				var wasPaused:Boolean = _paused;
				_animRunning = true;
				_paused = false;
				Update(0);
				_animRunning = wasAnimRunning;
				_paused = wasPaused;
			}
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
		
		public function SetupSpriteInst(theName:String = ""):Boolean
		{
			if (_mainSpriteInst == null)
			{
				return false;
			}
			
			if ((_mainSpriteInst.spriteDef != null) && (theName == ""))
			{
				return true;
			}
			
			if (_JointAnimate.mainAnimDef.mainSpriteDef != null)
			{
				InitSpriteInst(_mainSpriteInst, _JointAnimate.mainAnimDef.mainSpriteDef);
				return true;
			}
			
			if (_JointAnimate.mainAnimDef.spriteDefVector.length == 0)
			{
				return false;
			}
			
			var aName:String = theName;
			if (aName.length == 0)
			{
				aName = "main";
			}
			
			var aWantDef:JASpriteDef;
			var i:int = 0;
			while (i < _JointAnimate.mainAnimDef.spriteDefVector.length)
			{
				var aPopAnimSpriteDef:JASpriteDef = _JointAnimate.mainAnimDef.spriteDefVector[i];
				if ((aPopAnimSpriteDef.name != null) && (aPopAnimSpriteDef.name == aName))
				{
					aWantDef = aPopAnimSpriteDef;
					_lastPlayedFrameLabel = aName;
					break;
				}
				
				i++;
			}
			
			if (aWantDef == null)
			{
				aWantDef = _JointAnimate.mainAnimDef.spriteDefVector[0];
			}
			
			if (aWantDef != _mainSpriteInst.spriteDef)
			{
				if (_mainSpriteInst.spriteDef != null)
				{
					_mainSpriteInst.Reset();
					_mainSpriteInst.parent = null;
				}
				
				InitSpriteInst(_mainSpriteInst, aWantDef);
				_transDirty = true;
			}
			
			return true;
		}
		
		public function Play(theFrameLabel:String, resetAnim:Boolean = true):Boolean
		{
			_animRunning = false;
			if (_JointAnimate.mainAnimDef.mainSpriteDef)
			{
				if (!SetupSpriteInst())
				{
					return false;
				}
				
				var aFrameNum:int = _JointAnimate.mainAnimDef.mainSpriteDef.GetLabelFrame(theFrameLabel);
				if (aFrameNum == -1)
				{
					return false;
				}
				
				_lastPlayedFrameLabel = theFrameLabel;
				return PlayIndex(aFrameNum, resetAnim);
			}
			
			_lastPlayedFrameLabel = theFrameLabel;
			SetupSpriteInst(theFrameLabel);
			return PlayIndex(_mainSpriteInst.spriteDef.workAreaStart, resetAnim);
		}
		
		public function PlayIndex(theFrameNum:int = 0, resetAnim:Boolean = true):Boolean
		{
			if (!SetupSpriteInst())
			{
				return false;
			}
			
			if (theFrameNum >= _mainSpriteInst.spriteDef.frames.length)
			{
				_animRunning = false;
				return false;
			}
			
			if ((_mainSpriteInst.frameNum != theFrameNum) && resetAnim)
			{
				ResetAnim();
			}
			
			_paused = false;
			_animRunning = true;
			_mainSpriteInst.delayFrames = 0;
			_mainSpriteInst.frameNum = theFrameNum;
			_mainSpriteInst.lastFrameNum = theFrameNum;
			_mainSpriteInst.frameRepeats = 0;
			if (_blendDelay == 0)
			{
				DoFramesHit(_mainSpriteInst, null);
			}
			
			return true;
		}
		
		public function Update(val:Number):void
		{
			if (!SetupSpriteInst())
			{
				return;
			}
			
			UpdateF(val);
		}
		
		private function UpdateF(val:Number):void
		{
			if (_paused)
			{
				return;
			}
			
			AnimUpdate(val);
		}
		
		public function Draw(p_context:IContext):void
		{
			if (!SetupSpriteInst())
			{
				return;
			}
			
			_helpCallDepth = 0;
			if (!_inNode)
			{
				_drawTransform = _transform;
			}
			
			if (_transDirty)
			{
				UpdateTransforms(_mainSpriteInst, null, _color, false);
				_transDirty = false;
			}
			
			DrawSprite(p_context, _mainSpriteInst, null, _color, _additive, false);
		}
		
		private function DrawSprite(p_context:IContext, theSpriteInst:JASpriteInst, theTransform:JATransform, theColor:JAColor, additive:Boolean, parentFrozen:Boolean):void
		{
			var aChildSpriteInst:JASpriteInst = null;
			var aNewTransform:JATransform = null;
			var _local23:Rectangle = null;
			var _local12:Number;
			var _local14:Number;
			var _local18:int;
			var index:int = int(theSpriteInst.frameNum);
			var aFrame:JAFrame = theSpriteInst.spriteDef.frames[index];
			var aCurTransform:JATransform = _helpCallTransform[_helpCallDepth];
			var aCurColor:JAColor = _helpCallColor[_helpCallDepth];
			_helpCallDepth++;
			var frozen:Boolean = (parentFrozen || (theSpriteInst.delayFrames > 0) || aFrame.hasStop);
			var anObjectPosIdx:int = 0;
			while (anObjectPosIdx < aFrame.frameObjectPosVector.length)
			{
				var anObjectPos:JAObjectPos = aFrame.frameObjectPosVector[anObjectPosIdx];
				var anObjectInst:JAObjectInst = theSpriteInst.children[anObjectPos.objectNum];
				if ((_listener != null) && anObjectInst.predrawCallback)
				{
					anObjectInst.predrawCallback = _listener.JAnimObjectPredraw(_id, this, p_context, theSpriteInst, anObjectInst, theTransform, theColor);
				}
				
				if (anObjectPos.isSprite)
				{
					aChildSpriteInst = theSpriteInst.children[anObjectPos.objectNum].spriteInst;
					aCurColor.clone(aChildSpriteInst.curColor);
					aCurTransform.clone(aChildSpriteInst.curTransform);
				}
				else
				{
					CalcObjectPos(theSpriteInst, anObjectPosIdx, frozen);
					aCurTransform = _helpCalcTransform;
					aCurColor = _helpCalcColor;
					_helpCalcTransform = null;
					_helpCalcColor = null;
				}
				
				if ((theTransform == null) && (_JointAnimate.drawScale != 1))
				{
					_helpTransform.matrix.LoadIdentity();
					_helpTransform.matrix.m00 = _JointAnimate.drawScale;
					_helpTransform.matrix.m11 = _JointAnimate.drawScale;
					_helpTransform.matrix = JAMatrix3.MulJAMatrix3(_drawTransform, _helpTransform.matrix, _helpTransform.matrix);
					aNewTransform = _helpTransform.TransformSrc(aCurTransform, aCurTransform);
				}
				else
				{
					if ((theTransform == null) || anObjectPos.isSprite)
					{
						aNewTransform = aCurTransform;
						if (_JointAnimate.drawScale != 1)
						{
							_helpTransform.matrix.LoadIdentity();
							_helpTransform.matrix.m00 = _JointAnimate.drawScale;
							_helpTransform.matrix.m11 = _JointAnimate.drawScale;
							aNewTransform.matrix = JAMatrix3.MulJAMatrix3(_helpTransform.matrix, aNewTransform.matrix, aNewTransform.matrix);
						}
						//把本地坐标变换到世界坐标（偏移）
						aNewTransform.matrix = JAMatrix3.MulJAMatrix3(_drawTransform, aNewTransform.matrix, aNewTransform.matrix);
					}
					else
					{
						aNewTransform = theTransform.TransformSrc(aCurTransform, aCurTransform);
					}
				}
				
				var aNewColor:JAColor = _helpCallColor[_helpCallDepth];
				_helpCallDepth++;
				aNewColor.Set((((aCurColor.red * theColor.red) * anObjectInst.colorMult.red) / 65025), (((aCurColor.green * theColor.green) * anObjectInst.colorMult.green) / 65025), (((aCurColor.blue * theColor.blue) * anObjectInst.colorMult.blue) / 65025), (((aCurColor.alpha * theColor.alpha) * anObjectInst.colorMult.alpha) / 65025));
				if (aNewColor.alpha != 0)
				{
					if (anObjectPos.isSprite)
					{
						aChildSpriteInst = theSpriteInst.children[anObjectPos.objectNum].spriteInst;
						DrawSprite(p_context, aChildSpriteInst, aNewTransform, aNewColor, (anObjectPos.isAdditive || additive), frozen);
					}
					else
					{
						var anImageDrawCount:int = 0;
						while (true)
						{
							if (anObjectPos.animFrameNum < 0)
							{
								break;
							}
							var anImage:JAImage = _JointAnimate.imageVector[anObjectPos.resNum];
							var anImageTransform:JATransform = aNewTransform.TransformSrc(anImage.transform, aNewTransform);
							var aDrawImage:JAMemoryImage = null;
							_local23 = _helpDrawSpriteASrcRect;
							if ((anObjectPos.animFrameNum == 0) || (anImage.images.length == 1))
							{
								aDrawImage = anImage.images[0];
								aDrawImage.GetCelRect(anObjectPos.animFrameNum, _local23);
							}
							else
							{
								aDrawImage = anImage.images[anObjectPos.animFrameNum];
								aDrawImage.GetCelRect(0, _local23);
							}
							
							if (anObjectPos.hasSrcRect)
							{
								_local23 = anObjectPos.srcRect;
							}
							
							if (_JointAnimate.imgScale != 1)
							{
								_local12 = anImageTransform.matrix.m02;
								_local14 = anImageTransform.matrix.m12;
								_helpTransform.matrix.LoadIdentity();
								_helpTransform.matrix.m00 = (1 / _JointAnimate.imgScale);
								_helpTransform.matrix.m11 = (1 / _JointAnimate.imgScale);
								anImageTransform = _helpTransform.TransformSrc(anImageTransform, anImageTransform);
								anImageTransform.matrix.m02 = _local12;
								anImageTransform.matrix.m12 = _local14;
							}
							
							_local18 = 0;
							if ((_listener != null) && anObjectInst.imagePredrawCallback)
							{
								_local18 = _listener.JAnimImagePredraw(theSpriteInst, anObjectInst, anImageTransform, aDrawImage, p_context, anImageDrawCount);
								if (_local18 == 0)
								{
									anObjectInst.imagePredrawCallback = false;
								}
								
								if (_local18 == 2)
									break;
							}
							
							_helpTransform.matrix.LoadIdentity();
							_helpTransform.matrix.m02 = (_local23.width / 2);
							_helpTransform.matrix.m12 = (_local23.height / 2);
							//if (_local21.imageExist)
							//{
							//	_helpTransform.matrix.m02 -= _local21.texture.pivotX;
							//	_helpTransform.matrix.m12 -= _local21.texture.pivotY;
							//}
							//_helpTransform.matrix.m02 = -_local21.texture.frameWidth * 0.5 -_local21.texture.pivotX;
							//_helpTransform.matrix.m12 = -_local21.texture.frameHeight * 0.5-_local21.texture.pivotY;
							if (_mirror)
							{
								_helpTransform.matrix.m00 = -1;
							}
							
							anImageTransform.matrix = JAMatrix3.MulJAMatrix3(anImageTransform.matrix, _helpTransform.matrix, anImageTransform.matrix);
							if (_mirror)
							{
								anImageTransform.matrix.m02 = ((_JointAnimate.animRect.width - anImageTransform.matrix.m02) + (2 * _drawTransform.m02));
								anImageTransform.matrix.m01 = -(anImageTransform.matrix.m01);
								anImageTransform.matrix.m10 = -(anImageTransform.matrix.m10);
							}
							
							_helpDrawSprite.a = anImageTransform.matrix.m00;
							_helpDrawSprite.b = anImageTransform.matrix.m10;
							_helpDrawSprite.c = anImageTransform.matrix.m01;
							_helpDrawSprite.d = anImageTransform.matrix.m11;
							_helpDrawSprite.tx = anImageTransform.matrix.m02;
							_helpDrawSprite.ty = anImageTransform.matrix.m12;
							if (aDrawImage.imageExist)
							{
								// TODO:
								//p_context.draw2(_local21.texture, _helpDrawSprite, (_local8.red * 0.003921568627451), (_local8.green * 0.003921568627451), (_local8.blue * 0.003921568627451), (_local8.alpha * 0.003921568627451), ((((additive) || (_local20.isAdditive))) ? GBlendMode.ADD : GBlendMode.NORMAL));
								p_context.drawMatrix(aDrawImage.texture, _helpDrawSprite.a, _helpDrawSprite.b, _helpDrawSprite.c, _helpDrawSprite.d, _helpDrawSprite.tx, _helpDrawSprite.ty, (aNewColor.red * 0.003921568627451), (aNewColor.green * 0.003921568627451), (aNewColor.blue * 0.003921568627451), (aNewColor.alpha * 0.003921568627451), ((additive || anObjectPos.isAdditive) ? GBlendMode.ADD : GBlendMode.NORMAL));
								//node.core.getContext().draw(_local21.texture, node.transform.g2d_worldX, node.transform.g2d_worldY, node.transform.g2d_worldScaleX, node.transform.g2d_worldScaleY, node.transform.g2d_worldRotation, node.transform.g2d_worldRed, node.transform.g2d_worldGreen, node.transform.g2d_worldBlue, node.transform.g2d_worldAlpha, 0, null);
							}
							else
							{
								if (_listener != null)
								{
									_listener.JAnimImageNotExistDraw(aDrawImage.name, p_context, _helpDrawSprite, (aNewColor.red * 0.003921568627451), (aNewColor.green * 0.003921568627451), (aNewColor.blue * 0.003921568627451), (aNewColor.alpha * 0.003921568627451), ((((additive) || (anObjectPos.isAdditive))) ? GBlendMode.ADD : GBlendMode.NORMAL));
								}
							}
							if (_local18 != 3)
								break;
							anImageDrawCount++;
						}
						
						if ((_listener != null) && (anObjectInst.postdrawCallback))
						{
							anObjectInst.postdrawCallback = _listener.JAnimObjectPostdraw(_id, this, p_context, theSpriteInst, anObjectInst, theTransform, theColor);
						}
					}
				}
				
				anObjectPosIdx++;
			}
		}
		
		private function AnimUpdate(val:Number):void
		{
			if (!_animRunning)
			{
				return;
			}
			
			if (_blendTicksTotal > 0)
			{
				_blendTicksCur = (_blendTicksCur + val);
				if (_blendTicksCur >= _blendTicksTotal)
				{
					_blendTicksTotal = 0;
				}
			}
			
			_transDirty = true;
			if (_blendDelay > 0)
			{
				_blendDelay = (_blendDelay - val);
				if (_blendDelay <= 0)
				{
					_blendDelay = 0;
					DoFramesHit(_mainSpriteInst, null);
				}
				
				return;
			}
			
			IncSpriteInstFrame(_mainSpriteInst, null, val);
			PrepSpriteInstFrame(_mainSpriteInst, null);
		}
		
		private function PrepSpriteInstFrame(theSpriteInst:JASpriteInst, theObjectPos:JAObjectPos):void
		{
			var index:int = int(theSpriteInst.frameNum);
			var aCurFrame:JAFrame = theSpriteInst.spriteDef.frames[index];
			if (theSpriteInst.onNewFrame)
			{
//				TODO: 在有些状态下_local10会大于theSpriteInst.spriteDef.frames.length
//				if (theSpriteInst.lastFrameNum < theSpriteInst.frameNum)
//				{
//					var _local6:int = theSpriteInst.frameNum;
//					var _local10:int = (theSpriteInst.lastFrameNum + 1);
//					while (_local10 < _local6)
//					{
//						var _local7:JAFrame = theSpriteInst.spriteDef.frames[_local10];
//						FrameHit(theSpriteInst, _local7, theObjectPos);
//						_local10++;
//					}
//				}
				
				FrameHit(theSpriteInst, aCurFrame, theObjectPos);
			}
			
			if (aCurFrame.hasStop)
			{
				if (theSpriteInst == _mainSpriteInst)
				{
					_animRunning = false;
					if (_listener != null)
					{
						_listener.JAnimStopped(_id, this);
					}
				}
				
				return;
			}
			
			var anObjectPosIdx:int = 0;
			while (anObjectPosIdx < aCurFrame.frameObjectPosVector.length)
			{
				var anObjectPos:JAObjectPos = aCurFrame.frameObjectPosVector[anObjectPosIdx];
				if (anObjectPos.isSprite)
				{
					var aSpriteInst:JASpriteInst = theSpriteInst.children[anObjectPos.objectNum].spriteInst;
					if (aSpriteInst != null)
					{
						var aPhysFrameNum:int = (theSpriteInst.frameNum + (theSpriteInst.frameRepeats * theSpriteInst.spriteDef.frames.length));
						var aPhysLastFrameNum:int = (theSpriteInst.lastFrameNum + (theSpriteInst.frameRepeats * theSpriteInst.spriteDef.frames.length));
						if ((aSpriteInst.lastUpdated != aPhysLastFrameNum) && (aSpriteInst.lastUpdated != aPhysFrameNum))
						{
							aSpriteInst.frameNum = 0;
							aSpriteInst.lastFrameNum = 0;
							aSpriteInst.frameRepeats = 0;
							aSpriteInst.delayFrames = 0;
							aSpriteInst.onNewFrame = true;
						}
						
						PrepSpriteInstFrame(aSpriteInst, anObjectPos);
						aSpriteInst.lastUpdated = aPhysFrameNum;
					}
				}
				
				anObjectPosIdx++;
			}
		}
		
		private function IncSpriteInstFrame(theSpriteInst:JASpriteInst, theObjectPos:JAObjectPos, theFrac:Number):void
		{
			var aLastFrameNum:int = theSpriteInst.frameNum;
			var aLastFrame:JAFrame = theSpriteInst.spriteDef.frames[aLastFrameNum];
			if (aLastFrame.hasStop)
			{
				return;
			}
			
			theSpriteInst.lastFrameNum = theSpriteInst.frameNum;
			var aTimeScale:Number = ((theObjectPos != null) ? theObjectPos.timeScale : 1);
			theSpriteInst.frameNum = (theSpriteInst.frameNum + ((theFrac * (theSpriteInst.spriteDef.animRate / 100)) / aTimeScale));
			if (theSpriteInst == _mainSpriteInst)
			{
				if (!theSpriteInst.spriteDef.frames[(theSpriteInst.spriteDef.frames.length - 1)].hasStop)
				{
					if (theSpriteInst.frameNum >= (theSpriteInst.spriteDef.workAreaStart + theSpriteInst.spriteDef.workAreaDuration + 1))
					{
						theSpriteInst.frameRepeats++;
						theSpriteInst.frameNum = (theSpriteInst.frameNum - (theSpriteInst.spriteDef.workAreaDuration + 1));
						theSpriteInst.lastFrameNum = theSpriteInst.frameNum;
					}
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
							}
							
							return;
						}
						
						theSpriteInst.frameRepeats++;
					}
				}
			}
			else
			{
				if (theSpriteInst.frameNum >= theSpriteInst.spriteDef.frames.length)
				{
					theSpriteInst.frameRepeats++;
					theSpriteInst.frameNum = (theSpriteInst.frameNum - theSpriteInst.spriteDef.frames.length);
				}
			}
			
			theSpriteInst.onNewFrame = !((theSpriteInst.frameNum == aLastFrameNum));
			if (theSpriteInst.onNewFrame && (theSpriteInst.delayFrames > 0))
			{
				theSpriteInst.onNewFrame = false;
				theSpriteInst.frameNum = aLastFrameNum;
				theSpriteInst.lastFrameNum = theSpriteInst.frameNum;
				theSpriteInst.delayFrames--;
				return;
			}
			
			var anObjectPosIdx:int = 0;
			while (anObjectPosIdx < aLastFrame.frameObjectPosVector.length)
			{
				var anObjectPos:JAObjectPos = aLastFrame.frameObjectPosVector[anObjectPosIdx];
				if (anObjectPos.isSprite)
				{
					var aSpriteInst:JASpriteInst = theSpriteInst.children[anObjectPos.objectNum].spriteInst;
					IncSpriteInstFrame(aSpriteInst, anObjectPos, (theFrac / aTimeScale));
				}
				
				anObjectPosIdx++;
			}
		}
		
		private function DoFramesHit(theSpriteInst:JASpriteInst, theObjectPos:JAObjectPos):void
		{
			var aCurFrame:JAFrame = theSpriteInst.spriteDef.frames[theSpriteInst.frameNum];
			FrameHit(theSpriteInst, aCurFrame, theObjectPos);
			var anObjectPosIdx:int = 0;
			while (anObjectPosIdx < aCurFrame.frameObjectPosVector.length)
			{
				var anObjectPos:JAObjectPos = aCurFrame.frameObjectPosVector[anObjectPosIdx];
				if (anObjectPos.isSprite)
				{
					var aSpriteInst:JASpriteInst = theSpriteInst.children[anObjectPos.objectNum].spriteInst;
					if (aSpriteInst != null)
					{
						DoFramesHit(aSpriteInst, anObjectPos);
					}
				}
				
				anObjectPosIdx++;
			}
		}
		
		private function FrameHit(theSpriteInst:JASpriteInst, theFrame:JAFrame, theObjectPos:JAObjectPos):void
		{
			var aPreload:int;
			var aCommaPos:int;
			theSpriteInst.onNewFrame = false;
			var anObjectPosIdx:int = 0;
			while (anObjectPosIdx < theFrame.frameObjectPosVector.length)
			{
				var anObjectPos:JAObjectPos = theFrame.frameObjectPosVector[anObjectPosIdx];
				if (anObjectPos.isSprite)
				{
					var aSpriteInst:JASpriteInst = theSpriteInst.children[anObjectPos.objectNum].spriteInst;
					if (aSpriteInst != null)
					{
						aPreload = 0;
						while (aPreload < anObjectPos.preloadFrames)
						{
							IncSpriteInstFrame(aSpriteInst, anObjectPos, (100 / theSpriteInst.spriteDef.animRate));
							aPreload++;
						}
					}
				}
				
				anObjectPosIdx++;
			}
			
			var aCmdNum:int = 0;
			while (aCmdNum < theFrame.commandVector.length)
			{
				var aCommand:JACommand  = theFrame.commandVector[aCmdNum];
				if ((_listener == null) || (!_listener.JAnimCommand(_id, this, theSpriteInst, aCommand.command, aCommand.param)))
				{
					if (aCommand.command == "delay")
					{
						var delayMin:int, delayMax:int;
						aCommaPos = aCommand.param.indexOf(",");
						if (aCommaPos != -1)
						{
							delayMin = parseInt(aCommand.param.substr(0, aCommaPos));
							delayMax = parseInt(aCommand.param.substr(aCommaPos + 1));
							if (delayMax <= delayMin)
							{
								delayMax = (delayMin + 1);
							}
							
							theSpriteInst.delayFrames = (delayMin + ((Math.random() * 100000) % (delayMax - delayMin)));
						}
						else
						{
							delayMin = parseInt(aCommand.param);
							theSpriteInst.delayFrames = delayMin;
						}
					}
					else if (aCommand.command == "playsample")
					{
						var aParam:String = aCommand.param;
						var _local5:int = 0;
						var _local12:Number = 1;
						var _local15:Number = 0;
						var _local7:Boolean = true;
						var _local4:String = null;
						var _local9:String = null;
						while (aParam.length > 0)
						{
							aCommaPos = aParam.indexOf(",");
							if (aCommaPos == -1)
							{
								_local4 = aParam;
							}
							else
							{
								_local4 = aParam.substr(0, aCommaPos);
							}
							
							if (_local7)
							{
								_local9 = _local4;
								_local7 = false;
							}
							else
							{
								var _local17:int;
								while ((_local17 = _local4.indexOf(" ")) != -1)
								{
									_local4 = (_local4.substr(0, _local17) + _local4.substr((_local17 + 1)));
								}
								
								if (_local4.substr(0, 7) == "volume=")
								{
									_local12 = parseFloat(_local4.substr(7));
								}
								else if (_local4.substr(0, 4) == "pan=")
								{
									_local5 = parseInt(_local4.substr(4));
								}
								else if (_local4.substr(0, 6) == "steps=")
								{
									_local15 = parseFloat(_local4.substr(6));
								}
							}
							
							if (aCommaPos == -1)
								break;
							aParam = aParam.substr((aCommaPos + 1));
						}
						
						if (_listener != null)
						{
							_listener.JAnimPLaySample(_local9, _local5, _local12, _local15);
						}
					}
				}
				
				aCmdNum++;
			}
		}
		
		private function UpdateTransforms(theSpriteInst:JASpriteInst, theTransform:JATransform, theColor:JAColor, parentFrozen:Boolean):void
		{
			if (theTransform)
			{
				theSpriteInst.curTransform.clone(theTransform);
			}
			else
			{
				theSpriteInst.curTransform.matrix.clone(_drawTransform);
			}
			
			if (theSpriteInst.curColor == null)
			{
				theSpriteInst.curColor = new JAColor();
			}
			
			theSpriteInst.curColor.clone(theColor);
			var index:int = int(theSpriteInst.frameNum);
			var aFrame:JAFrame = theSpriteInst.spriteDef.frames[index];
			var aCurTransform:JATransform = _helpCallTransform[_helpCallDepth];
			var aCurColor:JAColor = _helpCallColor[_helpCallDepth];
			_helpCallDepth++;
			var frozen:Boolean = ((((parentFrozen) || ((theSpriteInst.delayFrames > 0)))) || (aFrame.hasStop));
			var anObjectPosIdx:int = 0;
			while (anObjectPosIdx < aFrame.frameObjectPosVector.length)
			{
				var anObjectPos:JAObjectPos = aFrame.frameObjectPosVector[anObjectPosIdx];
				if (anObjectPos.isSprite)
				{
					CalcObjectPos(theSpriteInst, anObjectPosIdx, frozen);
					aCurTransform = _helpCalcTransform;
					aCurColor = _helpCalcColor;
					_helpCalcTransform = null;
					_helpCalcColor = null;
					if (theTransform != null)
					{
						aCurTransform = theTransform.TransformSrc(aCurTransform, aCurTransform);
					}
					
					UpdateTransforms(theSpriteInst.children[anObjectPos.objectNum].spriteInst, aCurTransform, aCurColor, frozen);
				}
				
				anObjectPosIdx++;
			}
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
			}
			
			var _local15:JATransform = _helpCallTransform[_helpCallDepth];
			var _local4:JAColor = _helpCallColor[_helpCallDepth];
			_helpCallDepth++;
			if (((_interpolate) && (!(frozen))))
			{
				_local10 = 0;
				while (_local10 < 3)
				{
					_local19 = theSpriteInst.spriteDef.frames[((theSpriteInst.frameNum + (((_local10) == 0) ? _local14 : (((_local10) == 1) ? _local16 : _local13))) % theSpriteInst.spriteDef.frames.length)];
					if ((((theSpriteInst == _mainSpriteInst)) && ((theSpriteInst.frameNum >= theSpriteInst.spriteDef.workAreaStart))))
					{
						_local19 = theSpriteInst.spriteDef.frames[((((theSpriteInst.frameNum + (((_local10) == 0) ? _local14 : (((_local10) == 1) ? _local16 : _local13))) - theSpriteInst.spriteDef.workAreaStart) % (theSpriteInst.spriteDef.workAreaDuration + 1)) + theSpriteInst.spriteDef.workAreaStart)];
					}
					else
					{
						_local19 = theSpriteInst.spriteDef.frames[((theSpriteInst.frameNum + (((_local10) == 0) ? _local14 : (((_local10) == 1) ? _local16 : _local13))) % theSpriteInst.spriteDef.frames.length)];
					}
					
					if (_local11.hasStop)
					{
						_local19 = _local11;
					}
					
					if (_local19.frameObjectPosVector.length > theObjectPosIdx)
					{
						_helpANextObjectPos[_local10] = _local19.frameObjectPosVector[theObjectPosIdx];
						if (_helpANextObjectPos[_local10].objectNum != _local12.objectNum)
						{
							_helpANextObjectPos[_local10] = null;
						}
					}
					
					if (_helpANextObjectPos[_local10] == null)
					{
						_local8 = 0;
						while (_local8 < _local19.frameObjectPosVector.length)
						{
							if (_local19.frameObjectPosVector[_local8].objectNum == _local12.objectNum)
							{
								_helpANextObjectPos[_local10] = _local19.frameObjectPosVector[_local8];
								break;
							}
							
							_local8++;
						}
					}
					
					_local10++;
				}
				
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
				}
			}
			else
			{
				_local15.clone(_local12.transform);
				_local4.clone(_local12.color);
			}
			
			_local15.matrix = JAMatrix3.MulJAMatrix3(_local5.transform, _local15.matrix, _local15.matrix);
			if (((((_local5.isBlending) && (!((_blendTicksTotal == 0))))) && ((theSpriteInst == _mainSpriteInst))))
			{
				_local9 = (_blendTicksCur / _blendTicksTotal);
				_local15 = _local5.blendSrcTransform.InterpolateTo(_local15, _local9, _local15);
				_local4.Set((((_local5.blendSrcColor.red * (1 - _local9)) + (_local4.red * _local9)) + 0.5), (((_local5.blendSrcColor.green * (1 - _local9)) + (_local4.green * _local9)) + 0.5), (((_local5.blendSrcColor.blue * (1 - _local9)) + (_local4.blue * _local9)) + 0.5), (((_local5.blendSrcColor.alpha * (1 - _local9)) + (_local4.alpha * _local9)) + 0.5));
			}
			
			_helpCalcTransform = _local15;
			_helpCalcColor = _local4;
			_helpANextObjectPos[0] = null;
			_helpANextObjectPos[1] = null;
			_helpANextObjectPos[2] = null;
		}
		
		private function InitSpriteInst(theSpriteInst:JASpriteInst, theSpriteDef:JASpriteDef):void
		{
			theSpriteInst.frameRepeats = 0;
			theSpriteInst.delayFrames = 0;
			theSpriteInst.spriteDef = theSpriteDef;
			theSpriteInst.lastUpdated = -1;
			theSpriteInst.onNewFrame = true;
			theSpriteInst.frameNum = 0;
			theSpriteInst.lastFrameNum = 0;
			theSpriteInst.children.splice(0, theSpriteInst.children.length);
			theSpriteInst.children.length = theSpriteDef.objectDefVector.length;
			var i:int = 0;
			while (i < theSpriteDef.objectDefVector.length)
			{
				theSpriteInst.children[i] = new JAObjectInst();
				i++;
			}
			
			i = 0;
			while (i < theSpriteDef.objectDefVector.length)
			{
				var anObjectDef:JAObjectDef = theSpriteDef.objectDefVector[i];
				var anObjectInst:JAObjectInst = theSpriteInst.children[i];
				anObjectInst.colorMult = new JAColor();
				anObjectInst.colorMult.clone(JAColor.White);
				anObjectInst.name = anObjectDef.name;
				anObjectInst.isBlending = false;
				var aChildSpriteDef:JASpriteDef = anObjectDef.spriteDef;
				if (aChildSpriteDef != null)
				{
					var aChildSpriteInst:JASpriteInst = new JASpriteInst();
					aChildSpriteInst.parent = theSpriteInst;
					InitSpriteInst(aChildSpriteInst, aChildSpriteDef);
					anObjectInst.spriteInst = aChildSpriteInst;
				}
				
				i++;
			}
			
			if (theSpriteInst == _mainSpriteInst)
			{
				GetToFirstFrame();
			}
		}
		
		private function ResetAnimHelper(theSpriteInst:JASpriteInst):void
		{
			theSpriteInst.frameNum = 0;
			theSpriteInst.lastFrameNum = 0;
			theSpriteInst.frameRepeats = 0;
			theSpriteInst.delayFrames = 0;
			theSpriteInst.lastUpdated = -1;
			theSpriteInst.onNewFrame = true;
			var i:int = 0;
			while (i < theSpriteInst.children.length)
			{
				var aSpriteInst:JASpriteInst = theSpriteInst.children[i].spriteInst;
				if (aSpriteInst != null)
				{
					ResetAnimHelper(aSpriteInst);
				}
				
				i++;
			}
			
			_transDirty = true;
		}
	
	}
}