package com.genome2d.components.renderables.jointanim;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureAtlas;
import flash.display.Bitmap;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.Vector;
import haxe.Timer;

/**
 * ...
 * @author Rise
 */
class JointAnimate {
	public static var Load_Successed:Int = 0;
	public static var Load_MagicError:Int = -1;
	public static var Load_VersionError:Int = -2;
	public static var Load_Failed:Int = -3;
	public static var Load_LoadSpriteError:Int = -4;
	public static var Load_LoadMainSpriteError:Int = -5;
	public static var Load_GetImageTextureAtlasError:Int = -6;

	public static var ImageSearchPathVector:Array<Dynamic> = [];

	private var _loaded:Bool;
	private var _version:UInt;
	private var _animRate:Int;
	private var _animRect:Rectangle;
	private var _imageVector:Vector<JAImage>;
	private var _mainAnimDef:JAAnimDef;
	//private var _remapList:Array<Dynamic>;
	private var _particleAttachOffset:Point;
	//private var _randUsed:Bool;
	//private var _rand:MTRand;
	private var _drawScale:Float;
	private var _imgScale:Float;

	public function new() {
		//_randUsed = false;
		//_rand = new MTRand();
		//_rand.SRand(Math.round(haxe.Timer.stamp() * 1000)); //Timer.stamp();Lib.getTimer()
		_drawScale = 1;
		_imgScale = 1;
		_loaded = false;
		_animRect = new Rectangle();
		_imageVector = new Vector<JAImage>();
		_mainAnimDef = new JAAnimDef();
		//_remapList = [];
	}

	#if swc @:extern #end
	public var drawScale(get, never):Float;
	#if swc @:getter(drawScale) #end
	inline private function get_drawScale():Float {
		return _drawScale;
	}
	#if swc @:extern #end
	public var imgScale(get, never):Float;
	#if swc @:getter(imgScale) #end
	inline private function get_imgScale():Float {
		return _imgScale;
	}
	#if swc @:extern #end
	public var loaded(get, never):Bool;
	#if swc @:getter(loaded) #end
	inline private function get_loaded():Bool {
		return _loaded;
	}
	#if swc @:extern #end
	public var particleAttachOffset(get, never):Point;
	#if swc @:getter(particleAttachOffset) #end
	inline private function get_particleAttachOffset():Point {
		return _particleAttachOffset;
	}
	#if swc @:extern #end
	public var mainAnimDef(get, never):JAAnimDef;
	#if swc @:getter(mainAnimDef) #end
	inline private function get_mainAnimDef():JAAnimDef {
		return _mainAnimDef;
	}
	#if swc @:extern #end
	public var imageVector(get, never):Vector<JAImage>;
	#if swc @:getter(imageVector) #end
	inline private function get_imageVector():Vector<JAImage> {
		return _imageVector;
	}
	#if swc @:extern #end
	public var animRect(get, never):Rectangle;
	#if swc @:getter(animRect) #end
	inline private function get_animRect():Rectangle {
		return _animRect;
	}

	public function LoadPam(steam:ByteArray, texture:GTextureAtlas):Int {
		var magic:UInt = steam.readUnsignedInt();
		if (magic != PAM_MAGIC) {
			return Load_MagicError;
		}
		_version = steam.readUnsignedInt();
		if (_version > 5) {
			return Load_VersionError;
		}
		_animRate = steam.readUnsignedByte();
		_animRect.x = (steam.readShort() / 20);
		_animRect.y = (steam.readShort() / 20);
		_animRect.width = (steam.readShort() / 20);
		_animRect.height = (steam.readShort() / 20);
		var aNumImages:Int = steam.readShort();
		_imageVector.length = aNumImages;
		var i:Int = 0;
		while (i < aNumImages) {
			var image:JAImage = new JAImage();
			image.drawMode = 0;
			var imageName:String = ReadString(steam);
			image.cols = 1;
			image.rows = 1;
			image.origWidth = steam.readShort();
			image.origHeight = steam.readShort();
			image.transform.matrix.a = (steam.readInt() / (65536.0 * 20.0));
			image.transform.matrix.c = (steam.readInt() / (65536.0 * 20.0));
			image.transform.matrix.b = (steam.readInt() / (65536.0 * 20.0));
			image.transform.matrix.d = (steam.readInt() / (65536.0 * 20.0));
			image.transform.matrix.tx = (steam.readShort() / 20);
			image.transform.matrix.ty = (steam.readShort() / 20);
			// new
			if ((Math.abs(image.transform.matrix.a - 1.0) < 0.005) 
				&& (image.transform.matrix.b == 0.0) 
				&& (image.transform.matrix.c == 0.0) 
				&& (Math.abs(image.transform.matrix.d - 1.0) < 0.005) 
				&& (image.transform.matrix.tx == 0.0) 
				&& (image.transform.matrix.ty == 0.0)) {
					image.transform.matrix.LoadIdentity();
			}
			image.imageName = imageName;
			if (image.imageName.length > 0) {
				if (texture != null) {
					if (Load_GetImage(image, texture) == false) {
						Load_GetImageNoTexture(image);
					}
				}
				else {
					Load_GetImageNoTexture(image);
				}
			}
			
			_imageVector[i] = image;
			i++;
		}
		var aNumSprites:Int = steam.readShort();
		_mainAnimDef.spriteDefVector.length = aNumSprites;
		i = 0;
		while (i < aNumSprites) {
			_mainAnimDef.spriteDefVector[i] = new JASpriteDef();
			LoadSpriteDef(steam, _mainAnimDef.spriteDefVector[i]);
			i++;
		}
		var hasMainSpriteDef:Bool = steam.readBoolean();
		if (hasMainSpriteDef) {
			_mainAnimDef.mainSpriteDef = new JASpriteDef();
			LoadSpriteDef(steam, _mainAnimDef.mainSpriteDef);
		}
		_loaded = true;
		return (0);
	}

	private function Load_GetImageNoTexture(p_theImage:JAImage):Void {
		var _local2:JAMemoryImage = new JAMemoryImage(null);
		_local2.width = p_theImage.origWidth;
		_local2.height = p_theImage.origHeight;
		_local2.loadFlag = 2;
		_local2.texture = null;
		_local2.name = p_theImage.imageName;
		_local2.imageExist = false;
		p_theImage.images.push(_local2);
	}

	private function Load_GetImage(p_theImage:JAImage, p_texture:GTextureAtlas):Bool {
		var _local4:GTexture = p_texture.getSubTexture(p_theImage.imageName);
		if (_local4 == null) {
			return (false);
		}
		var _local3:JAMemoryImage = new JAMemoryImage(null);
		_local3.width = cast _local4.frameWidth;
		_local3.height = cast _local4.frameHeight;
		_local3.loadFlag = JAMemoryImage.Image_Loaded;
		_local3.texture = _local4;
		p_theImage.OnMemoryImageLoadCompleted(_local3);
		p_theImage.images.push(_local3);
		return (true);
	}

	private function ReadString(bytes:ByteArray):String {
		var _local2:Int = bytes.readShort();
		return (bytes.readUTFBytes(_local2));
	}
	
	private function LoadSpriteDef(steam:ByteArray, jaSpriteDef:JASpriteDef):Bool {
		var aFrameNum:Int;
		var aRemoveNum:Int;
		var aFrame:JAFrame = null;
		var aFrameFlags:Int;
		var aNumRemoves:Int;
		var anObjectId:Int;
		var aNumAdds:Int;
		var aPopAnimObjectPos:JAObjectPos = null;
		var _local24:String = null;
		var _local20:Int;
		var _local14:Float;
		var _local16:Float;
		var _local23:Float;
		var _local27:JAObjectDef = null;
		if (_version >= 4) {
			jaSpriteDef.name = ReadString(steam);
			jaSpriteDef.animRate = (steam.readInt() / 0x10000);
			_mainAnimDef.objectNamePool.push(jaSpriteDef.name);
		}
		else {
			jaSpriteDef.name = null;
			jaSpriteDef.animRate = _animRate;
		}
		var aNumFrames:Int = steam.readShort();	// 总时间
		if (_version >= 5) {
			jaSpriteDef.workAreaStart = steam.readShort();
			jaSpriteDef.workAreaDuration = steam.readShort();
		}
		else {
			jaSpriteDef.workAreaStart = 0;
			jaSpriteDef.workAreaDuration = (aNumFrames - 1);
		}
		jaSpriteDef.workAreaDuration = untyped(Math.min((jaSpriteDef.workAreaStart + jaSpriteDef.workAreaDuration), (aNumFrames - 1)) - jaSpriteDef.workAreaStart);
		jaSpriteDef.frames.length = aNumFrames;
		aFrameNum = 0;
		var aCurObjectMap:Dictionary = new Dictionary();
		while (aFrameNum < aNumFrames) {
			jaSpriteDef.frames[aFrameNum] = new JAFrame();
			aFrame = jaSpriteDef.frames[aFrameNum];
			aFrameFlags = steam.readUnsignedByte();
			if ((aFrameFlags & FRAMEFLAGS_HAS_REMOVES) != 0) {
				aNumRemoves = steam.readByte();
				if (aNumRemoves == 0xFF) {
					aNumRemoves = steam.readShort();
				}
				aRemoveNum = 0;
				while (aRemoveNum < aNumRemoves) {
					anObjectId = steam.readShort();
					if (anObjectId >= 0x7FF) {
						anObjectId = steam.readUnsignedInt();
					}
					//delete aCurObjectMap[anObjectId];
					Reflect.deleteField(aCurObjectMap, anObjectId + "");
					aRemoveNum++;
				}
			}
			if ((aFrameFlags & FRAMEFLAGS_HAS_ADDS) != 0) {
				aNumAdds = steam.readByte();
				if (aNumAdds == 0xFF) {
					aNumAdds = steam.readShort();
				}
				var anAddNum:Int = 0;
				while (anAddNum < aNumAdds) {
					aPopAnimObjectPos = new JAObjectPos();
					var anObjectNumAndType:Int = steam.readShort();
					aPopAnimObjectPos.objectNum = (anObjectNumAndType & 0x7FF);
					if (aPopAnimObjectPos.objectNum == 0x7FF) {
						aPopAnimObjectPos.objectNum = steam.readUnsignedInt();
					}
					aPopAnimObjectPos.isSprite = !(((anObjectNumAndType & 0x8000) == 0));
					aPopAnimObjectPos.isAdditive = !(((anObjectNumAndType & 0x4000) == 0));
					aPopAnimObjectPos.resNum = steam.readByte();
					aPopAnimObjectPos.hasSrcRect = false;
					aPopAnimObjectPos.color = JAColor.White;
					aPopAnimObjectPos.animFrameNum = 0;
					aPopAnimObjectPos.timeScale = 1;
					aPopAnimObjectPos.name = null;
					if ((anObjectNumAndType & 0x2000) != 0) {
						aPopAnimObjectPos.preloadFrames = steam.readShort();
					}
					else {
						aPopAnimObjectPos.preloadFrames = 0;
					}
					if ((anObjectNumAndType & 0x1000) != 0) {
						_local24 = ReadString(steam);
						_mainAnimDef.objectNamePool.push(_local24);
						aPopAnimObjectPos.name = _local24;
						_local24 = null;
					}
					if ((anObjectNumAndType & 0x0800) != 0) {
						aPopAnimObjectPos.timeScale = (steam.readUnsignedInt() / 0x10000);
					}
					if (jaSpriteDef.objectDefVector.length < (aPopAnimObjectPos.objectNum + 1)) {
						_local20 = 0;
						while (_local20 < (aPopAnimObjectPos.objectNum + 1)) {
							jaSpriteDef.objectDefVector.push(new JAObjectDef());
							_local20++;
						}
					}
					jaSpriteDef.objectDefVector[aPopAnimObjectPos.objectNum].name = aPopAnimObjectPos.name;
					if (aPopAnimObjectPos.isSprite) {
						jaSpriteDef.objectDefVector[aPopAnimObjectPos.objectNum].spriteDef = _mainAnimDef.spriteDefVector[aPopAnimObjectPos.resNum];
					}
					Reflect.setField(aCurObjectMap, aPopAnimObjectPos.objectNum + "", aPopAnimObjectPos);
					anAddNum++;
				}
			}
			if ((aFrameFlags & FRAMEFLAGS_HAS_MOVES) != 0) {
				var aNumMoves:Int = steam.readByte();
				if (aNumMoves == 0xFF) {
					aNumMoves = steam.readShort();
				}
				var aMoveNum:Int = 0;
				while (aMoveNum < aNumMoves) {
					var aFlagsAndObjectNum:Int = steam.readShort();
					var anObjectNum:Int = (aFlagsAndObjectNum & 0x3FF);
					if (anObjectNum == 0x3FF) {
						anObjectNum = steam.readUnsignedInt();
					}
					aPopAnimObjectPos = Reflect.field(aCurObjectMap, anObjectNum + "");
					aPopAnimObjectPos.transform.matrix.LoadIdentity();
					if ((aFlagsAndObjectNum & MOVEFLAGS_HAS_MATRIX) != 0) {
						aPopAnimObjectPos.transform.matrix.a = (steam.readInt() / 65536.0);
						aPopAnimObjectPos.transform.matrix.c = (steam.readInt() / 65536.0);
						aPopAnimObjectPos.transform.matrix.b = (steam.readInt() / 65536.0);
						aPopAnimObjectPos.transform.matrix.d = (steam.readInt() / 65536.0);
					}
					else {
						if ((aFlagsAndObjectNum & MOVEFLAGS_HAS_ROTATE) != 0) {
							var aRot:Float = (steam.readShort() / 1000);
							aPopAnimObjectPos.transform.matrix.LoadIdentity();
							aPopAnimObjectPos.transform.matrix.rotate(aRot);
						}
					}
					var aMatrix:JAMatrix3 = new JAMatrix3();
					if ((aFlagsAndObjectNum & MOVEFLAGS_HAS_LONGCOORDS) != 0) {
						aMatrix.tx = (steam.readInt() / 20);
						aMatrix.ty = (steam.readInt() / 20);
					}
					else {
						aMatrix.tx = (steam.readShort() / 20);
						aMatrix.ty = (steam.readShort() / 20);
					};
					aPopAnimObjectPos.transform.matrix = JAMatrix3.MulJAMatrix3(aMatrix, aPopAnimObjectPos.transform.matrix, aPopAnimObjectPos.transform.matrix);
					//aPopAnimObjectPos.transform.concat(aMatrix); // new
					aPopAnimObjectPos.hasSrcRect = ((aFlagsAndObjectNum & MOVEFLAGS_HAS_SRCRECT) != 0);
					if ((aFlagsAndObjectNum & MOVEFLAGS_HAS_SRCRECT) != 0) {
						if (aPopAnimObjectPos.srcRect == null) {
							aPopAnimObjectPos.srcRect = new Rectangle();
						}
						aPopAnimObjectPos.srcRect.x = (steam.readShort() / 20);
						aPopAnimObjectPos.srcRect.y = (steam.readShort() / 20);
						aPopAnimObjectPos.srcRect.width = (steam.readShort() / 20);
						aPopAnimObjectPos.srcRect.height = (steam.readShort() / 20);
					}
					if ((aFlagsAndObjectNum & MOVEFLAGS_HAS_COLOR) != 0) {
						if (aPopAnimObjectPos.color == JAColor.White) {
							aPopAnimObjectPos.color = new JAColor();
						}
						aPopAnimObjectPos.color.red = steam.readUnsignedByte();
						aPopAnimObjectPos.color.green = steam.readUnsignedByte();
						aPopAnimObjectPos.color.blue = steam.readUnsignedByte();
						aPopAnimObjectPos.color.alpha = steam.readUnsignedByte();
					}
					if ((aFlagsAndObjectNum & MOVEFLAGS_HAS_ANIMFRAMENUM) != 0) {
						aPopAnimObjectPos.animFrameNum = steam.readShort();
					}
					aMoveNum++;
				}
			}
			if ((aFrameFlags & FRAMEFLAGS_HAS_FRAME_NAME) != 0) {
				var aFrameName:String = ReadString(steam);
				Reflect.setField(jaSpriteDef.label, aFrameName, aFrameNum);
			}
			if ((aFrameFlags & FRAMEFLAGS_HAS_STOP) != 0) {
				aFrame.hasStop = true;
			}
			if ((aFrameFlags & FRAMEFLAGS_HAS_COMMANDS) != 0) {
				var aNumCmds:Int = steam.readByte();
				aFrame.commandVector.length = aNumCmds;
				var aCmdNum:Int = 0;
				while (aCmdNum < aNumCmds) {
					aFrame.commandVector[aCmdNum] = new JACommand();
					aFrame.commandVector[aCmdNum].command = ReadString(steam);
					aFrame.commandVector[aCmdNum].param = ReadString(steam);
					aCmdNum++;
				}
			}
			var aCurObjectNum:Int = 0;
			var textureIds:Array<String> = untyped __keys__(aCurObjectMap);
			for (i in 0...textureIds.length) {
				var anObjectPos:JAObjectPos = untyped aCurObjectMap[textureIds[i]];
				aFrame.frameObjectPosVector[aCurObjectNum] = new JAObjectPos();
				aFrame.frameObjectPosVector[aCurObjectNum].clone(anObjectPos);
				anObjectPos.preloadFrames = 0;
				aCurObjectNum++;
			}
			aFrameNum++;
		}
		if (aNumFrames == 0) {
			jaSpriteDef.frames.length = 1;
			jaSpriteDef.frames[0] = new JAFrame();
		}
		//aFrameNum = 0;
		//while (aFrameNum < jaSpriteDef.objectDefVector.length) {
		//	_local27 = jaSpriteDef.objectDefVector[aFrameNum];
		//	aFrameNum++;
		//}
		return (true);
	}

	private static var PAM_MAGIC:UInt = 0xBAF01954;
	private static var PAM_VERSION:UInt = 5;
	private static var FRAMEFLAGS_HAS_REMOVES:UInt = 1;
	private static var FRAMEFLAGS_HAS_ADDS:UInt = 2;
	private static var FRAMEFLAGS_HAS_MOVES:UInt = 4;
	private static var FRAMEFLAGS_HAS_FRAME_NAME:UInt = 8;
	private static var FRAMEFLAGS_HAS_STOP:UInt = 16;
	private static var FRAMEFLAGS_HAS_COMMANDS:UInt = 32;
	private static var MOVEFLAGS_HAS_SRCRECT:UInt = 0x8000;
	private static var MOVEFLAGS_HAS_ROTATE:UInt = 0x4000;
	private static var MOVEFLAGS_HAS_COLOR:UInt = 0x2000;
	private static var MOVEFLAGS_HAS_MATRIX:UInt = 0x1000;
	private static var MOVEFLAGS_HAS_LONGCOORDS:UInt = 0x0800;
	private static var MOVEFLAGS_HAS_ANIMFRAMENUM:UInt = 0x0400;
}
