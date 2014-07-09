package com.genome2d.components.renderables.jointanim;

import com.genome2d.context.GContextCamera;
import com.genome2d.context.IContext;
import com.genome2d.error.GError;
import com.genome2d.geom.GRectangle;
import com.genome2d.node.GNode;
import com.genome2d.textures.GTexture;
import flash.geom.Matrix;
import flash.geom.Matrix3D;
import flash.geom.Rectangle;
import flash.geom.Vector3D;
import flash.Lib;
import flash.Vector;

/**
 * ...
 * @author Rise
 */
class JAnim extends GComponent implements IRenderable {
	private static var NORMALIZED_VERTICES_3D:Array<Float> = [-0.5, 0.5, 0, -0.5, -0.5, 0, 0.5, -0.5, 0, 0.5, 0.5, 0];

	private static var _helpTransform:JATransform = new JATransform();
	private static var _helpCallTransform:Vector<JATransform> = new Vector<JATransform>(1000);
	private static var _helpCallColor:Vector<JAColor> = new Vector<JAColor>(1000);
	private static var _helpCallDepth:Int = 0;
	private static var _helpDrawSpriteASrcRect:GRectangle = new GRectangle();
	private static var _helpCalcTransform:JATransform;
	private static var _helpCalcColor:JAColor;
	private static var _helpANextObjectPos:Vector<JAObjectPos> = new Vector<JAObjectPos>(3);
	public static var UpdateCnt:Int = 0;
	private static var _helpGetTransformedVertices3DTransformMatrix:Matrix3D = new Matrix3D();
	private static var _helpMatrix3DVector1:Array<Float> = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];
	private static var _helpMatrix3DArg1:Matrix3D = new Matrix3D();
	private static var _helpJAnimRender:JATransform2D = new JATransform2D();
	private static var _helpJAnimRenderVector:Vector<Float> = new Vector<Float>(16);
	private static var bInit:Bool = false;
	private static var _helpDrawSprite:Matrix = new Matrix();

	private var _JointAnimate:JointAnimate;
	private var _id:Int;
	private var _listener:JAnimListener;
	private var _animRunning:Bool;
	private var _paused:Bool;
	private var _interpolate:Bool;
	private var _color:JAColor;
	private var _transform:JATransform2D;
	private var _drawTransform:JATransform2D;
	private var _mirror:Bool;
	private var _additive:Bool;
	private var _inNode:Bool;
	private var _mainSpriteInst:JASpriteInst;
	private var _transDirty:Bool;
	private var _blendTicksTotal:Float;
	private var _blendTicksCur:Float;
	private var _blendDelay:Float;
	private var _lastPlayedFrameLabel:String;
	private var _helpGetTransformedVertices3DVector:Vector<Float>;
	private var mOfsTab:Array<Int> = [0, 1, 2];

	public function new() 
	{
		_helpGetTransformedVertices3DVector = new Vector<Float>();
		//super(p_node);
		super();
		//if (jointAnimate == null)
		//{
		//	throw (new GError("Joint Animate is null!"));
		//};
		//_inNode = !((p_node == null));
		//_JointAnimate = jointAnimate;
		//_id = id;
		//_listener = listener;
		_mirror = false;
		_animRunning = false;
		_paused = false;
		_transform = new JATransform2D();
		_interpolate = true;
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

	public function setJointAnim(jointAnimate:JointAnimate, id:Int, listener:JAnimListener = null):Void {
		//_inNode = (node != null);
		if (jointAnimate == null)
        {
            throw (new GError("Joint Animate is null!"));
        }
		_inNode = false;
		_JointAnimate = jointAnimate;
		_id = id;
		_listener = listener;
	}

	public static function HelpCallInitialize():Void 
	{
		var _local1:Int;
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
			}
			bInit = true;
		}
	}

	override public function dispose():Void 
	{
		super.dispose();
		_color = null;
		_transform = null;
		_mainSpriteInst.Dispose();
		_JointAnimate = null;
	}

	////override public function processMouseEvent(p_captured:Bool, p_event:MouseEvent, p_position:Vector3D):Bool
	////{
	////	return (false);
	////}
    //
	///*override*/
	public function getBounds(p_target:GRectangle = null):GRectangle 
	{
		var _local4:Int;
		var _local2:Vector<Float> = getTransformedVertices3D();
		if (p_target != null) 
		{
			p_target.setTo(_local2[0], _local2[1], 0, 0);
		}
		else 
		{
			p_target = new Rectangle(_local2[0], _local2[1], 0, 0);
		};
		var _local3:Int = _local2.length;
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
    
	private function getTransformedVertices3D():Vector<Float> {
		//_helpGetTransformedVertices3DTransformMatrix.copyfFrom(node.transform.matrix);
		var matrix3d:Matrix3D = new Matrix3D();
		matrix3d.identity();
		matrix3d.prependScale(node.transform.scaleX, node.transform.scaleY, 1);
		matrix3d.prependRotation(node.transform.rotation * 180 / Math.PI, Vector3D.Z_AXIS);
		matrix3d.prependTranslation(node.transform.x, node.transform.y, 0);
    
		_helpGetTransformedVertices3DTransformMatrix.copyFrom(matrix3d);
		_helpMatrix3DVector1[0] = _transform.a;
		_helpMatrix3DVector1[1] = _transform.b;
		_helpMatrix3DVector1[4] = _transform.c;
		_helpMatrix3DVector1[5] = _transform.d;
		_helpMatrix3DVector1[12] = _transform.tx;
		_helpMatrix3DVector1[13] = _transform.ty;
		_helpMatrix3DArg1.copyRawDataFrom(Vector.ofArray(_helpMatrix3DVector1));
		_helpGetTransformedVertices3DTransformMatrix.prepend(_helpMatrix3DArg1);
		NORMALIZED_VERTICES_3D[0] = _JointAnimate.animRect.x;
		NORMALIZED_VERTICES_3D[1] = _JointAnimate.animRect.y;
		NORMALIZED_VERTICES_3D[2] = 0;
		NORMALIZED_VERTICES_3D[3] = _JointAnimate.animRect.x;
		NORMALIZED_VERTICES_3D[4] = (_JointAnimate.animRect.y + _JointAnimate.animRect.height);
		NORMALIZED_VERTICES_3D[5] = 0;
		NORMALIZED_VERTICES_3D[6] = (_JointAnimate.animRect.x + _JointAnimate.animRect.width);
		NORMALIZED_VERTICES_3D[7] = (_JointAnimate.animRect.y + _JointAnimate.animRect.height);
		NORMALIZED_VERTICES_3D[8] = 0;
		NORMALIZED_VERTICES_3D[9] = (_JointAnimate.animRect.x + _JointAnimate.animRect.width);
		NORMALIZED_VERTICES_3D[10] = _JointAnimate.animRect.y;
		NORMALIZED_VERTICES_3D[11] = 0;
		_helpGetTransformedVertices3DTransformMatrix.transformVectors(Vector.ofArray(NORMALIZED_VERTICES_3D), _helpGetTransformedVertices3DVector);
		return (_helpGetTransformedVertices3DVector);
	}
    
///*//override*/ public function render(p_context:IContext, p_camera:GContextCamera, p_maskRect:Rectangle):Void
	/*override*/ public function render(p_camera:GContextCamera, p_useMatrix:Bool):Void {
		if (_inNode) {
			var matrix3d:Matrix3D = new Matrix3D();
			matrix3d.identity();
			matrix3d.prependScale(node.transform.scaleX, node.transform.scaleY, 1);
			matrix3d.prependRotation(node.transform.rotation * 180 / Math.PI, Vector3D.Z_AXIS);
			matrix3d.prependTranslation(node.transform.x, node.transform.y, 0);
			_drawTransform = JAMatrix3.MulJAMatrix3_M3D(matrix3d, _transform, _helpJAnimRender);
		}
		else 
		{
			_drawTransform = _transform;
		}
		Draw(node.core.getContext());
	}
	/*override*/ public function update(p_deltaTime:Float, p_parentTransformUpdate:Bool, p_parentColorUpdate:Bool):Void
	{
		if (_inNode)
		{
			//_drawTransform = JAMatrix3.MulJAMatrix3_M3D(node.transform.worldTransformMatrix, _transform, _helpJAnimRender);
		}
		else
		{
			_drawTransform = _transform;
		}
		Update((p_deltaTime * 0.1));
	}
	
	#if swc @:extern #end
	public var transform(get, never):JATransform2D;
	#if swc @:getter(transform) #end
	inline private function get_transform():JATransform2D 
	{
		return _transform;
	}
	#if swc @:extern #end
	public var lastPlayedLabel(get, never):String;
	#if swc @:getter(lastPlayedLabel) #end
	inline private function get_lastPlayedLabel():String 
	{
		return _lastPlayedFrameLabel;
	}
	#if swc @:extern #end
	public var interpolate(get, set):Bool;
	#if swc @:getter(interpolate) #end
	inline private function get_interpolate():Bool 
	{
		return _interpolate;
	}
	#if swc @:setter(interpolate) #end
	inline private function set_interpolate(val:Bool):Bool 
	{
		_interpolate = val;
		return _interpolate;
	}

	#if swc @:extern #end
	public var mirror(get, set):Bool;
	#if swc @:getter(mirror) #end
	inline private function get_mirror():Bool 
	{
		return _mirror;
	}
	#if swc @:setter(mirror) #end
	inline private function set_mirror(val:Bool):Bool 
	{
		_mirror = val;
		return _mirror;
	}

	#if swc @:extern #end
	public var additive(get, set):Bool;
	#if swc @:getter(additive) #end
	inline private function get_additive():Bool 
	{
		return _additive;
	}
	#if swc @:setter(additive) #end
	inline private function set_additive(val:Bool):Bool 
	{
		_additive = val;
		return _additive;
	}
	
	#if swc @:extern #end
	public var color(get, set):Int;
	#if swc @:getter(color) #end
	inline private function get_color():Int 
	{
		return _color.toInt();
	}
	#if swc @:setter(color) #end
	inline private function set_color(val:Int):Int 
	{
		_color.alpha = ((val >> 24) & 0xFF);
		_color.red = ((val >> 16) & 0xFF);
		_color.green = ((val >> 8) & 0xFF);
		_color.blue = (val & 0xFF);
		return _color.toInt();
	}
	#if swc @:extern #end
	public var mainSpriteInst(get, never):JASpriteInst;
	#if swc @:getter(mainSpriteInst) #end
	inline private function get_mainSpriteInst():JASpriteInst 
	{
		return _mainSpriteInst;
	}

	public function IsActive():Bool 
	{
		if (_animRunning) 
		{
			return (true);
		}
		return (false);
	}

	public function GetToFirstFrame():Void 
	{
		var _local1:Bool;
		var _local2:Bool;
		while (((!((_mainSpriteInst.spriteDef == null))) && ((_mainSpriteInst.frameNum < _mainSpriteInst.spriteDef.workAreaStart)))) 
		{
			_local1 = _animRunning;
			_local2 = _paused;
			_animRunning = true;
			_paused = false;
			Update(0);
			_animRunning = _local1;
			_paused = _local2;
		}
	}

	public function ResetAnim():Void 
	{
		ResetAnimHelper(_mainSpriteInst);
		_animRunning = false;
		GetToFirstFrame();
		_blendTicksTotal = 0;
		_blendTicksCur = 0;
		_blendDelay = 0;
	}

	public function SetupSpriteInst(theName:String = ""):Bool 
	{
		if (_mainSpriteInst == null) 
		{
			return (false);
		}
		if ((_mainSpriteInst.spriteDef != null) && (theName == "")) 
		{
			return (true);
		}
		if (_JointAnimate.mainAnimDef.mainSpriteDef != null) 
		{
			InitSpriteInst(_mainSpriteInst, _JointAnimate.mainAnimDef.mainSpriteDef);
			return (true);
		}
		if (_JointAnimate.mainAnimDef.spriteDefVector.length == 0) 
		{
			return (false);
		}
		var aName:String = theName;
		if (aName.length == 0) 
		{
			aName = "main";
		}
		var aWantDef:JASpriteDef = null;
		var i:Int = 0;
		while (i < _JointAnimate.mainAnimDef.spriteDefVector.length) 
		{
			if (((!((_JointAnimate.mainAnimDef.spriteDefVector[i].name == null))) && ((_JointAnimate.mainAnimDef.spriteDefVector[i].name == aName)))) 
			{
				aWantDef = _JointAnimate.mainAnimDef.spriteDefVector[i];
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
		return (true);
	}

	public function Play(theFrameLabel:String, resetAnim:Bool = true):Bool {
		if(theFrameLabel == null) {
			theFrameLabel = '';
		}
		_animRunning = false;
		if (_JointAnimate.mainAnimDef.mainSpriteDef != null) 
		{
			if (!SetupSpriteInst()) 
			{
				return (false);
			}
			var aFrameNum:Int = _JointAnimate.mainAnimDef.mainSpriteDef.GetLabelFrame(theFrameLabel);
			if (aFrameNum == -1) 
			{
				return (false);
			}
			_lastPlayedFrameLabel = theFrameLabel;
			return (PlayIndex(aFrameNum, resetAnim));
		}
		_lastPlayedFrameLabel = theFrameLabel;
		SetupSpriteInst(theFrameLabel);
		return (PlayIndex(_mainSpriteInst.spriteDef.workAreaStart, resetAnim));
	}

	public function PlayIndex(theFrameNum:Int = 0, resetAnim:Bool = true):Bool 
	{
		if (!SetupSpriteInst()) 
		{
			return (false);
		}
		if (theFrameNum >= _mainSpriteInst.spriteDef.frames.length) 
		{
			_animRunning = false;
			return (false);
		}
		if (((!((_mainSpriteInst.frameNum == theFrameNum))) && (resetAnim))) 
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
		return (true);
	}

	public function Update(val:Float):Void 
	{
		if (!SetupSpriteInst()) 
		{
			return;
		}
		UpdateF(val);
	}

	private function UpdateF(val:Float):Void 
	{
		if (_paused) 
		{
			return;
		}
		AnimUpdate(val);
	}

	public function Draw(p_context:IContext):Void 
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

	private function DrawSprite(p_context:IContext, theSpriteInst:JASpriteInst, theTransform:JATransform, theColor:JAColor, additive:Bool, parentFrozen:Bool):Void {
		var aChildSpriteInst:JASpriteInst = null;
		var _local24:JATransform = null;
		var aNewColor:JAColor = null;
		var anImageDrawCount:Int;
		var anImage:JAImage = null;
		var _local13:JATransform = null;
		var _local21:JAMemoryImage = null;
		var _local23:GRectangle = null;
		var _local12:Float;
		var _local14:Float;
		var _local18:Int;
		var aFrame:JAFrame = theSpriteInst.spriteDef.frames[Std.int(theSpriteInst.frameNum)];
		var aCurTransform:JATransform = _helpCallTransform[_helpCallDepth];
		var aCurColor:JAColor = _helpCallColor[_helpCallDepth];
		_helpCallDepth++;
		var frozen:Bool = ((((parentFrozen) || ((theSpriteInst.delayFrames > 0)))) || (aFrame.hasStop));
		var anObjectPosIdx:Int = 0;
		while (anObjectPosIdx < aFrame.frameObjectPosVector.length) 
		{
			var anObjectPos:JAObjectPos = aFrame.frameObjectPosVector[anObjectPosIdx];
			if(anObjectPos == null) {
				continue;
			}
			var anObjectInst:JAObjectInst = theSpriteInst.children[anObjectPos.objectNum];
			if ((_listener != null) && (anObjectInst.predrawCallback)) 
			{
				anObjectInst.predrawCallback = _listener.JAnimObjectPredraw(_id, this, p_context, theSpriteInst, anObjectInst, theTransform, theColor);
			};
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
			};
			//new
			//if(_listener != null) {
			//	aCurColor = _listener.JAnimObjectPredraw(theSpriteInst, anObjectInst, theTransform, aCurColor);
			//}
			if ((((theTransform == null)) && (!((_JointAnimate.drawScale == 1))))) 
			{
				_helpTransform.matrix.LoadIdentity();
				_helpTransform.matrix.a = _JointAnimate.drawScale;
				_helpTransform.matrix.d = _JointAnimate.drawScale;
				_helpTransform.matrix = JAMatrix3.MulJAMatrix3(_drawTransform, _helpTransform.matrix, _helpTransform.matrix);
				_local24 = _helpTransform.TransformSrc(aCurTransform, aCurTransform);
			}
			else 
			{
				if ((((theTransform == null)) || (anObjectPos.isSprite))) 
				{
					_local24 = aCurTransform;
					if (_JointAnimate.drawScale != 1) 
					{
						_helpTransform.matrix.LoadIdentity();
						_helpTransform.matrix.a = _JointAnimate.drawScale;
						_helpTransform.matrix.d = _JointAnimate.drawScale;
						_local24.matrix = JAMatrix3.MulJAMatrix3(_helpTransform.matrix, _local24.matrix, _local24.matrix);
					};
					_local24.matrix = JAMatrix3.MulJAMatrix3(_drawTransform, _local24.matrix, _local24.matrix);
				}
				else 
				{
					_local24 = theTransform.TransformSrc(aCurTransform, aCurTransform);
				};
			};
			aNewColor = _helpCallColor[_helpCallDepth];
			_helpCallDepth++;
			aNewColor.Set(cast (((aCurColor.red * theColor.red) * anObjectInst.colorMult.red) / 0xFE01),
				cast (((aCurColor.green * theColor.green) * anObjectInst.colorMult.green) / 0xFE01),
				cast (((aCurColor.blue * theColor.blue) * anObjectInst.colorMult.blue) / 0xFE01),
				cast (((aCurColor.alpha * theColor.alpha) * anObjectInst.colorMult.alpha) / 0xFE01));
			if (aNewColor.alpha != 0) 
			{
				if (anObjectPos.isSprite) 
				{
					aChildSpriteInst = theSpriteInst.children[anObjectPos.objectNum].spriteInst;
					DrawSprite(p_context, aChildSpriteInst, _local24, aNewColor, ((anObjectPos.isAdditive) || (additive)), frozen);
				}
				else 
				{
					anImageDrawCount = 0;
					while (true) 
					{
						anImage = _JointAnimate.imageVector[anObjectPos.resNum];
						_local13 = _local24.TransformSrc(anImage.transform, _local24);
						_local23 = _helpDrawSpriteASrcRect;
						if ((((anObjectPos.animFrameNum == 0)) || ((anImage.images.length == 1)))) 
						{
							_local21 = anImage.images[0];
							_local21.GetCelRect(anObjectPos.animFrameNum, _local23);
						}
						else 
						{
							_local21 = anImage.images[anObjectPos.animFrameNum];
							_local21.GetCelRect(0, _local23);
						}
						if (anObjectPos.hasSrcRect) 
						{
							_local23 = anObjectPos.srcRect;
						}
						if (_JointAnimate.imgScale != 1) 
						{
							_local12 = _local13.matrix.tx;
							_local14 = _local13.matrix.ty;
							_helpTransform.matrix.LoadIdentity();
							_helpTransform.matrix.a = (1 / _JointAnimate.imgScale);
							_helpTransform.matrix.d = (1 / _JointAnimate.imgScale);
							_local13 = _helpTransform.TransformSrc(_local13, _local13);
							_local13.matrix.tx = _local12;
							_local13.matrix.ty = _local14;
						}
						_local18 = 0;
						if (((!((_listener == null))) && (anObjectInst.imagePredrawCallback))) 
						{
							_local18 = _listener.JAnimImagePredraw(theSpriteInst, anObjectInst, _local13, _local21, p_context, anImageDrawCount);
							if (_local18 == 0) 
							{
								anObjectInst.imagePredrawCallback = false;
							}
							if (_local18 == 2) break;
						}
						_helpTransform.matrix.LoadIdentity();
						//_helpTransform.matrix.tx = (_local23.width / 2);
						//_helpTransform.matrix.ty = (_local23.height / 2);
						_helpTransform.matrix.tx = (_local23.width / 2);
						_helpTransform.matrix.ty = (_local23.height / 2);
						if (_local21.imageExist) {
							_helpTransform.matrix.tx -= _local21.texture.pivotX;
							_helpTransform.matrix.ty -= _local21.texture.pivotY;
						}
						//_helpTransform.matrix.tx = (anImage.origWidth / 2);
						//_helpTransform.matrix.ty = (anImage.origHeight / 2);
						//_helpTransform.matrix.tx = (_local21.texture.width / 2);
						//_helpTransform.matrix.ty = (anImage.origHeight / 2);
						//_helpTransform.matrix.tx = (_local23.width / 2) + _local21.texture.pivotX;
						//_helpTransform.matrix.ty = (_local23.height / 2) + _local21.texture.pivotY;
						//texture.width*.5-texture.pivotX, -texture.height*.5-texture.pivotY, texture.width, texture.height
						if (_mirror) 
						{
							_helpTransform.matrix.a = -1;
						}
						_local13.matrix = JAMatrix3.MulJAMatrix3(_local13.matrix, _helpTransform.matrix, _local13.matrix);
						if (_mirror) 
						{
							_local13.matrix.tx = ((_JointAnimate.animRect.width - _local13.matrix.tx) + (2 * _drawTransform.tx));
							_local13.matrix.c = -(_local13.matrix.c);
							_local13.matrix.b = -(_local13.matrix.b);
						}
						_helpDrawSprite.a = _local13.matrix.a;
						_helpDrawSprite.b = _local13.matrix.b;
						_helpDrawSprite.c = _local13.matrix.c;
						_helpDrawSprite.d = _local13.matrix.d;
						_helpDrawSprite.tx = _local13.matrix.tx;
						_helpDrawSprite.ty = _local13.matrix.ty;
						if (_local21.imageExist) {
							p_context.drawMatrix(_local21.texture,
								_helpDrawSprite.a,
								_helpDrawSprite.b,
								_helpDrawSprite.c,
								_helpDrawSprite.d,
								_helpDrawSprite.tx,
								_helpDrawSprite.ty/*,
								(aNewColor.red * 0.003921568627451),
								(aNewColor.green * 0.003921568627451),
								(aNewColor.blue * 0.003921568627451),
								(aNewColor.alpha * 0.003921568627451),
								((((additive) || (anObjectPos.isAdditive))) ? 2 : 1)*/);
						}
						else 
						{
							if (_listener != null) 
							{
								_listener.JAnimImageNotExistDraw(_local21.name, p_context, _helpDrawSprite,
									(aNewColor.red * 0.003921568627451),
									(aNewColor.green * 0.003921568627451),
									(aNewColor.blue * 0.003921568627451),
									(aNewColor.alpha * 0.003921568627451),
									((((additive) || (anObjectPos.isAdditive))) ? 2 : 1));
							}
						}
						if (_local18 != 3) break;
						anImageDrawCount++;
					}
					if (((!((_listener == null))) && (anObjectInst.postdrawCallback))) 
					{
						anObjectInst.postdrawCallback = _listener.JAnimObjectPostdraw(_id, this, p_context, theSpriteInst, anObjectInst, theTransform, theColor);
					}
				}
			}
			anObjectPosIdx++;
		}
	}

	private function AnimUpdate(val:Float):Void 
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

	private function PrepSpriteInstFrame(theSpriteInst:JASpriteInst, theObjectPos:JAObjectPos):Void 
	{
		var aCurFrame:JAFrame = theSpriteInst.spriteDef.frames[Std.int(theSpriteInst.frameNum)];
		if (theSpriteInst.onNewFrame) {
			if (theSpriteInst.lastFrameNum < theSpriteInst.frameNum) {
				var _local6:Int = Std.int(theSpriteInst.frameNum);
				var _local10:Int = Std.int(theSpriteInst.lastFrameNum + 1);
				while (_local10 < _local6) {
					var _local7:JAFrame = theSpriteInst.spriteDef.frames[_local10];
					FrameHit(theSpriteInst, _local7, theObjectPos);
					_local10++;
				}
			}
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
		var anObjectPosIdx:Int = 0;
		while (anObjectPosIdx < aCurFrame.frameObjectPosVector.length) 
		{
			var theObjectPos:JAObjectPos = aCurFrame.frameObjectPosVector[anObjectPosIdx];
			if (theObjectPos.isSprite) 
			{
				var aSpriteInst:JASpriteInst = theSpriteInst.children[theObjectPos.objectNum].spriteInst;
				if (aSpriteInst != null) 
				{
					var aPhysFrameNum:Int = Std.int(theSpriteInst.frameNum + (theSpriteInst.frameRepeats * theSpriteInst.spriteDef.frames.length));
					var aPhysLastFrameNum:Int = Std.int(theSpriteInst.lastFrameNum + (theSpriteInst.frameRepeats * theSpriteInst.spriteDef.frames.length));
					if ((aSpriteInst.lastUpdated != aPhysLastFrameNum) && (aSpriteInst.lastUpdated != aPhysFrameNum)) 
					{
						aSpriteInst.frameNum = 0;
						aSpriteInst.lastFrameNum = 0;
						aSpriteInst.frameRepeats = 0;
						aSpriteInst.delayFrames = 0;
						aSpriteInst.onNewFrame = true;
					}
					PrepSpriteInstFrame(aSpriteInst, theObjectPos);
					aSpriteInst.lastUpdated = aPhysFrameNum;
				}
			}
			anObjectPosIdx++;
		}
	}

	private function IncSpriteInstFrame(theSpriteInst:JASpriteInst, theObjectPos:JAObjectPos, theFrac:Float):Void 
	{
		var aLastFrameNum:Int = Std.int(theSpriteInst.frameNum);
		var aLastFrame:JAFrame = theSpriteInst.spriteDef.frames[aLastFrameNum];
		if (aLastFrame.hasStop) 
		{
			return;
		}
		theSpriteInst.lastFrameNum = theSpriteInst.frameNum;
		var aTimeScale:Float = ((theObjectPos != null) ? theObjectPos.timeScale : 1);
		theSpriteInst.frameNum = (theSpriteInst.frameNum + ((theFrac * (theSpriteInst.spriteDef.animRate / 100)) / aTimeScale));
		if (theSpriteInst == _mainSpriteInst) 
		{
			if (!theSpriteInst.spriteDef.frames[(theSpriteInst.spriteDef.frames.length - 1)].hasStop) 
			{
				if (theSpriteInst.frameNum >= ((theSpriteInst.spriteDef.workAreaStart + theSpriteInst.spriteDef.workAreaDuration) + 1)) 
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
		if (((theSpriteInst.onNewFrame) && ((theSpriteInst.delayFrames > 0)))) 
		{
			theSpriteInst.onNewFrame = false;
			theSpriteInst.frameNum = aLastFrameNum;
			theSpriteInst.lastFrameNum = theSpriteInst.frameNum;
			theSpriteInst.delayFrames--;
			return;
		}
		var anObjectPosIdx:Int = 0;
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

	private function DoFramesHit(theSpriteInst:JASpriteInst, theObjectPos:JAObjectPos):Void 
	{
		var aCurFrame:JAFrame = theSpriteInst.spriteDef.frames[Std.int(theSpriteInst.frameNum)];
		FrameHit(theSpriteInst, aCurFrame, theObjectPos);
		var anObjectPosIdx:Int = 0;
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

	private function FrameHit(theSpriteInst:JASpriteInst, theFrame:JAFrame, theObjectPos:JAObjectPos):Void {
		var aCurParam1:Int;
		var aCommaPos:Int;
		var _local4 = null;
		var _local7:Bool;
		var _local17:Int;
		var aCurParam2:Int;
		var _local19:String = null;
		var _local5:Int;
		var _local12:Float;
		var _local15:Float;
		var _local9 = null;
		theSpriteInst.onNewFrame = false;
		var anObjectPosIdx:Int = 0;
		while (anObjectPosIdx < theFrame.frameObjectPosVector.length) 
		{
			var anObjectPos:JAObjectPos = theFrame.frameObjectPosVector[anObjectPosIdx];
			if ((anObjectPos != null) && anObjectPos.isSprite) 
			{
				var aSpriteInst:JASpriteInst = theSpriteInst.children[anObjectPos.objectNum].spriteInst;
				if (aSpriteInst != null) 
				{
					var aPreload:Int = 0;
					while (aPreload < anObjectPos.preloadFrames) 
					{
						IncSpriteInstFrame(aSpriteInst, anObjectPos, (100 / theSpriteInst.spriteDef.animRate));
						aPreload++;
					}
				}
			}
			anObjectPosIdx++;
		}
		if(theFrame.commandVector != null) 
		{
			var aCmdNum:Int = 0;
			while (aCmdNum < theFrame.commandVector.length) 
			{
				var aCommand:JACommand  = theFrame.commandVector[aCmdNum];
				if ((((_listener == null)) || (!(_listener.JAnimCommand(_id, this, theSpriteInst, aCommand.command, aCommand.param))))) {
					if (aCommand.command == "delay") 
					{
						aCommaPos = aCommand.param.indexOf(",");
						if (aCommaPos != -1) 
						{
							aCurParam1 = cast aCommand.param.substr(0, aCommaPos);
							aCurParam2 = cast aCommand.param.substr((aCommaPos + 1));
							if (aCurParam2 <= aCurParam1) 
							{
								aCurParam2 = (aCurParam1 + 1);
							}
							theSpriteInst.delayFrames = (aCurParam1 + ((cast Math.random() * 100000) % (aCurParam2 - aCurParam1)));
						}
						else 
						{
							aCurParam1 = cast aCommand.param;
							theSpriteInst.delayFrames = aCurParam1;
						}
					}
					else 
					{
						if (aCommand.command == "playsample") 
						{
							_local19 = aCommand.param;
							_local5 = 0;
							_local12 = 1;
							_local15 = 0;
							_local7 = true;
							while (_local19.length > 0) 
							{
								aCommaPos = _local19.indexOf(",");
								if (aCommaPos == -1) 
								{
									_local4 = _local19;
								}
								else 
								{
									_local4 = _local19.substr(0, aCommaPos);
								}
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
										_local12 = cast _local4.substr(7);
									}
									else 
									{
										if (_local4.substr(0, 4) == "pan=") 
										{
											_local5 = cast _local4.substr(4);
										}
										else 
										{
											if (_local4.substr(0, 6) == "steps=") 
											{
												_local15 = cast _local4.substr(6);
											}
										}
									}
								}
								if (aCommaPos == -1) break;
								_local19 = _local19.substr((aCommaPos + 1));
							}
							if (_listener != null) 
							{
								_listener.JAnimPLaySample(_local9, _local5, _local12, _local15);
							}
						}
					}
				}
				aCmdNum++;
			}
		}
	}

	private function UpdateTransforms(theSpriteInst:JASpriteInst, theTransform:JATransform, theColor:JAColor, parentFrozen:Bool):Void 
	{
		if (theTransform != null) 
		{
			theSpriteInst.curTransform.clone(theTransform);
		}
		else 
		{
			theSpriteInst.curTransform.matrix.copy(_drawTransform);
		}
		if (theSpriteInst.curColor == null) 
		{
			theSpriteInst.curColor = new JAColor();
		}
		theSpriteInst.curColor.clone(theColor);
		var aFrame:JAFrame = theSpriteInst.spriteDef.frames[Std.int(theSpriteInst.frameNum)];
		var aCurTransform:JATransform = _helpCallTransform[_helpCallDepth];
		var aCurColor:JAColor = _helpCallColor[_helpCallDepth];
		_helpCallDepth++;
		var frozen:Bool = (parentFrozen || (theSpriteInst.delayFrames > 0) || aFrame.hasStop);
		var anObjectPosIdx:Int = 0;
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
				if (theTransform != null) {
					aCurTransform = theTransform.TransformSrc(aCurTransform, aCurTransform);
				}
				UpdateTransforms(theSpriteInst.children[anObjectPos.objectNum].spriteInst, aCurTransform, aCurColor, frozen);
			}
			anObjectPosIdx++;
		}
	}

	private function CalcObjectPos(theSpriteInst:JASpriteInst, theObjectPosIdx:Int, frozen:Bool):Void 
	{
		var _local17:JASpriteInst = null;
		var _local6 = null;
		var _local7 = null;
		var _local8:Int;
		var aBlendInterp:Float;
		var _local18:Bool;
		var iFrameNum:Float = theSpriteInst.frameNum;
		var aFrame:JAFrame = theSpriteInst.spriteDef.frames[Std.int(iFrameNum)];
		var anObjectPos:JAObjectPos = aFrame.frameObjectPosVector[theObjectPosIdx];
		var anObjectInst:JAObjectInst = theSpriteInst.children[anObjectPos.objectNum];
		_helpANextObjectPos[0] = null;
		_helpANextObjectPos[1] = null;
		_helpANextObjectPos[2] = null;
		
		mOfsTab[0] = theSpriteInst.spriteDef.frames.length - 1;
		if ((((theSpriteInst == _mainSpriteInst)) && ((theSpriteInst.frameNum >= theSpriteInst.spriteDef.workAreaStart)))) 
		{
			mOfsTab[0] = (theSpriteInst.spriteDef.workAreaDuration - 1);
		}
		var aCurTransform:JATransform = _helpCallTransform[_helpCallDepth];
		var aCurColor:JAColor = _helpCallColor[_helpCallDepth];
		_helpCallDepth++;
		if (((_interpolate) && (!(frozen)))) 
		{
			var anOfsIdx:Int = 0;
			while (anOfsIdx < 3) 
			{
				var aNextFrame:JAFrame = theSpriteInst.spriteDef.frames[Std.int(iFrameNum + mOfsTab[anOfsIdx]) % theSpriteInst.spriteDef.frames.length];
				if ((theSpriteInst == _mainSpriteInst) && (theSpriteInst.frameNum >= theSpriteInst.spriteDef.workAreaStart)) {
					aNextFrame = theSpriteInst.spriteDef.frames[Std.int(iFrameNum + mOfsTab[anOfsIdx] - theSpriteInst.spriteDef.workAreaStart) % (theSpriteInst.spriteDef.workAreaDuration + 1) + theSpriteInst.spriteDef.workAreaStart];
				}
				else 
				{
					//aNextFrame = theSpriteInst.spriteDef.frames[cast ((theSpriteInst.frameNum + (((anOfsIdx) == 0) ? totalFrames : (((anOfsIdx) == 1) ? _local16 : _local13))) % theSpriteInst.spriteDef.frames.length)];
					aNextFrame = theSpriteInst.spriteDef.frames[Std.int(iFrameNum + mOfsTab[anOfsIdx]) % theSpriteInst.spriteDef.frames.length];
				}
				if (aFrame.hasStop) 
				{
					aNextFrame = aFrame;
				}
				if (aNextFrame.frameObjectPosVector.length > theObjectPosIdx) 
				{
					_helpANextObjectPos[anOfsIdx] = aNextFrame.frameObjectPosVector[theObjectPosIdx];
					if ((_helpANextObjectPos[anOfsIdx] == null) || _helpANextObjectPos[anOfsIdx].objectNum != anObjectPos.objectNum) 
					{
						_helpANextObjectPos[anOfsIdx] = null;
					}
				}
				if (_helpANextObjectPos[anOfsIdx] == null) 
				{
					var aCheckObjectPosIdx:Int = 0;
					while (aCheckObjectPosIdx < aNextFrame.frameObjectPosVector.length) 
					{
						if (aNextFrame.frameObjectPosVector[aCheckObjectPosIdx].objectNum == anObjectPos.objectNum) 
						{
							_helpANextObjectPos[anOfsIdx] = aNextFrame.frameObjectPosVector[aCheckObjectPosIdx];
							break;
						}
						aCheckObjectPosIdx++;
					}
				}
				anOfsIdx++;
			}
			//if (_helpANextObjectPos[1] != null) {
			// new
			if (_helpANextObjectPos[1] != null && ((anObjectPos.transform != _helpANextObjectPos[1].transform) || (anObjectPos.color != _helpANextObjectPos[1].color))) {
				var anInterp:Float = (theSpriteInst.frameNum - Math.floor(theSpriteInst.frameNum));
				_local18 = false;
				aCurTransform = anObjectPos.transform.InterpolateTo(_helpANextObjectPos[1].transform, anInterp, aCurTransform);
				aCurColor.Set(cast (((anObjectPos.color.red * (1 - anInterp)) + (_helpANextObjectPos[1].color.red * anInterp)) + 0.5), 
					cast (((anObjectPos.color.green * (1 - anInterp)) + (_helpANextObjectPos[1].color.green * anInterp)) + 0.5), 
					cast (((anObjectPos.color.blue * (1 - anInterp)) + (_helpANextObjectPos[1].color.blue * anInterp)) + 0.5), 
					cast (((anObjectPos.color.alpha * (1 - anInterp)) + (_helpANextObjectPos[1].color.alpha * anInterp)) + 0.5));
			}
			else 
			{
				aCurTransform.clone(anObjectPos.transform);
				aCurColor.clone(anObjectPos.color);
			}
		}
		else 
		{
			aCurTransform.clone(anObjectPos.transform);
			aCurColor.clone(anObjectPos.color);
		}
		aCurTransform.matrix = JAMatrix3.MulJAMatrix3(anObjectInst.transform, aCurTransform.matrix, aCurTransform.matrix);
		if (((((anObjectInst.isBlending) && (!((_blendTicksTotal == 0))))) && ((theSpriteInst == _mainSpriteInst)))) {
			aBlendInterp = (_blendTicksCur / _blendTicksTotal);
			aCurTransform = anObjectInst.blendSrcTransform.InterpolateTo(aCurTransform, aBlendInterp, aCurTransform);
			aCurColor.Set(cast (((anObjectInst.blendSrcColor.red * (1 - aBlendInterp)) + (aCurColor.red * aBlendInterp)) + 0.5),
						cast (((anObjectInst.blendSrcColor.green * (1 - aBlendInterp)) + (aCurColor.green * aBlendInterp)) + 0.5),
						cast (((anObjectInst.blendSrcColor.blue * (1 - aBlendInterp)) + (aCurColor.blue * aBlendInterp)) + 0.5),
						cast (((anObjectInst.blendSrcColor.alpha * (1 - aBlendInterp)) + (aCurColor.alpha * aBlendInterp)) + 0.5));
		}
		_helpCalcTransform = aCurTransform;
		_helpCalcColor = aCurColor;
		_helpANextObjectPos[0] = null;
		_helpANextObjectPos[1] = null;
		_helpANextObjectPos[2] = null;
	}

	private function InitSpriteInst(theSpriteInst:JASpriteInst, theSpriteDef:JASpriteDef):Void 
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
		var anObjectNum:Int = 0;
		while (anObjectNum < theSpriteDef.objectDefVector.length) 
		{
			theSpriteInst.children[anObjectNum] = new JAObjectInst();
			var anObjectDef:JAObjectDef = theSpriteDef.objectDefVector[anObjectNum];
			var anObjectInst = theSpriteInst.children[anObjectNum];
			anObjectInst.colorMult = new JAColor();
			anObjectInst.colorMult.clone(JAColor.White);
			anObjectInst.name = anObjectDef.name;
			anObjectInst.isBlending = false;
			var aChildSpriteDef:JASpriteDef = anObjectDef.spriteDef;
			if (aChildSpriteDef != null) {
				var aChildSpriteInst:JASpriteInst = new JASpriteInst();
				aChildSpriteInst.parent = theSpriteInst;
				InitSpriteInst(aChildSpriteInst, aChildSpriteDef);
				anObjectInst.spriteInst = aChildSpriteInst;
			}
			anObjectNum++;
		}
		if (theSpriteInst == _mainSpriteInst) 
		{
			GetToFirstFrame();
		}
	}

	private function ResetAnimHelper(theSpriteInst:JASpriteInst):Void 
	{
		theSpriteInst.frameNum = 0;
		theSpriteInst.lastFrameNum = 0;
		theSpriteInst.frameRepeats = 0;
		theSpriteInst.delayFrames = 0;
		theSpriteInst.lastUpdated = -1;
		theSpriteInst.onNewFrame = true;
		var i:Int = 0;
		while (i < theSpriteInst.children.length) 
		{
			var aSpriteInst = theSpriteInst.children[i].spriteInst;
			if (aSpriteInst != null) 
			{
				ResetAnimHelper(aSpriteInst);
			}
			i++;
		}
		_transDirty = true;
	}
}