// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.jointanim.JointAnimate

package com.flengine.components.renderables.jointanim
{
    import flash.geom.Rectangle;
    import __AS3__.vec.Vector;
    import flash.geom.Point;
    import com.flengine.rand.MTRand;
    import flash.utils.getTimer;
    import flash.utils.ByteArray;
    import com.flengine.textures.FTextureAtlas;
    import com.flengine.components.renderables.JAMemoryImage;
    import com.flengine.textures.FTexture;
    import flash.utils.Dictionary;
    import flash.geom.*;
    import com.adobe.utils.*;
    import flash.utils.*;

    public class JointAnimate 
    {

        public static const Load_Successed:int = 0;
        public static const Load_MagicError:int = -1;
        public static const Load_VersionError:int = -2;
        public static const Load_Failed:int = -3;
        public static const Load_LoadSpriteError:int = -4;
        public static const Load_LoadMainSpriteError:int = -5;
        public static const Load_GetImageTextureAtlasError:int = -6;

        public static var ImageSearchPathVector:Array = [];

        private var _loaded:Boolean;
        private var _version:uint;
        private var _animRate:int;
        private var _animRect:Rectangle;
        private var _imageVector:Vector.<JAImage>;
        private var _mainAnimDef:JAAnimDef;
        private var _remapList:Array;
        private var _particleAttachOffset:Point;
        private var _randUsed:Boolean;
        private var _rand:MTRand;
        private var _drawScale:Number;
        private var _imgScale:Number;

        public function JointAnimate()
        {
            _randUsed = false;
            _rand = new MTRand();
            _rand.SRand(getTimer());
            _drawScale = 1;
            _imgScale = 1;
            _loaded = false;
            _animRect = new Rectangle();
            _imageVector = new Vector.<JAImage>();
            _mainAnimDef = new JAAnimDef();
            _remapList = [];
        }

        public function get drawScale():Number
        {
            return (_drawScale);
        }

        public function get imgScale():Number
        {
            return (_imgScale);
        }

        public function get loaded():Boolean
        {
            return (_loaded);
        }

        public function get particleAttachOffset():Point
        {
            return (_particleAttachOffset);
        }

        public function get mainAnimDef():JAAnimDef
        {
            return (_mainAnimDef);
        }

        public function get imageVector():Vector.<JAImage>
        {
            return (_imageVector);
        }

        public function get animRect():Rectangle
        {
            return (_animRect);
        }

        private function AddOnceImageToList(name:String, list:Array):void
        {
            var _local4:int;
            var _local3 = null;
            _local4 = 0;
            while (_local4 < list.length)
            {
                _local3 = list[_local4];
                if (name == _local3.imageName)
                {
                    return;
                };
                _local4++;
            };
            list.push({"imageName":name});
        }

        public function GetImageFileList(stream:ByteArray, list:Array):int
        {
            var _local10:int;
            var _local8 = null;
            var _local5 = null;
            var _local3 = null;
            var _local9:int;
            var _local7:int;
            var _local4:uint = stream.readUnsignedInt();
            if (_local4 != 3136297300)
            {
                return (-1);
            };
            var _local11:int = stream.readUnsignedInt();
            if (_local11 > 5)
            {
                return (-2);
            };
            stream.readUnsignedByte();
            stream.readShort();
            stream.readShort();
            stream.readShort();
            stream.readShort();
            var _local6:int = stream.readShort();
            _local10 = 0;
            while (_local10 < _local6)
            {
                _local8 = ReadString(stream);
                _local5 = Remap(_local8);
                _local3 = "";
                _local9 = _local5.indexOf("(");
                _local7 = _local5.indexOf(")");
                if (((((!((_local9 == -1))) && (!((_local7 == -1))))) && ((_local9 < _local7))))
                {
                    _local3 = _local5.substr((_local9 + 1), ((_local7 - _local9) - 1)).toLowerCase();
                    _local5 = (_local5.substr(0, _local9) + _local5.substr((_local7 + 1)));
                }
                else
                {
                    _local7 = _local5.indexOf("$");
                    if (_local7 != -1)
                    {
                        _local3 = _local5.substr(0, _local7).toLowerCase();
                        _local5 = _local5.substr((_local7 + 1));
                    };
                };
                if (_local11 >= 4)
                {
                    stream.readShort();
                    stream.readShort();
                };
                if (_local11 == 1)
                {
                    stream.readShort();
                    stream.readShort();
                    stream.readShort();
                }
                else
                {
                    stream.readInt();
                    stream.readInt();
                    stream.readInt();
                    stream.readInt();
                    stream.readShort();
                    stream.readShort();
                };
                if (_local5.length > 0)
                {
                    AddOnceImageToList(_local5, list);
                };
                _local10++;
            };
            return (0);
        }

        public function LoadPam(steam:ByteArray, texture:FTextureAtlas):int
        {
            var _local13:int;
            var _local10:int;
            var _local12:int;
            var _local5:int;
            var _local6 = null;
            var _local11 = null;
            var _local8 = null;
            var _local17 = null;
            var _local3:Number;
            var _local4:Number;
            var _local15:Number;
            var _local16:uint = steam.readUnsignedInt();
            if (_local16 != 3136297300)
            {
                return (-1);
            };
            _version = steam.readUnsignedInt();
            if (_version > 5)
            {
                return (-2);
            };
            _animRate = steam.readUnsignedByte();
            _animRect.x = (steam.readShort() / 20);
            _animRect.y = (steam.readShort() / 20);
            _animRect.width = (steam.readShort() / 20);
            _animRect.height = (steam.readShort() / 20);
            var _local9:int = steam.readShort();
            _imageVector.length = _local9;
            _local13 = 0;
            while (_local13 < _local9)
            {
                _imageVector[_local13] = new JAImage();
                _local13++;
            };
            _local13 = 0;
            while (_local13 < _local9)
            {
                _local6 = _imageVector[_local13];
                _local6.drawMode = 0;
                _local11 = ReadString(steam);
                _local8 = Remap(_local11);
                _local17 = "";
                _local12 = _local8.indexOf("(");
                _local10 = _local8.indexOf(")");
                if (((((!((_local12 == -1))) && (!((_local10 == -1))))) && ((_local12 < _local10))))
                {
                    _local17 = _local8.substr((_local12 + 1), ((_local10 - _local12) - 1)).toLowerCase();
                    _local8 = (_local8.substr(0, _local12) + _local8.substr((_local10 + 1)));
                }
                else
                {
                    _local10 = _local8.indexOf("$");
                    if (_local10 != -1)
                    {
                        _local17 = _local8.substr(0, _local10).toLowerCase();
                        _local8 = _local8.substr((_local10 + 1));
                    };
                };
                _local6.cols = 1;
                _local6.rows = 1;
                _local12 = _local8.indexOf("[");
                _local10 = _local8.indexOf("]");
                if (((((!((_local12 == -1))) && (!((_local10 == -1))))) && ((_local12 < _local10))))
                {
                    _local17 = _local8.substr((_local12 + 1), ((_local10 - _local12) - 1)).toLowerCase();
                    _local8 = (_local8.substr(0, _local12) + _local8.substr((_local10 + 1)));
                    _local5 = _local17.indexOf(",");
                    if (_local5 != -1)
                    {
                        _local6.cols = _local17.substr(0, _local5);
                        _local6.rows = _local17.substr((_local5 + 1));
                    };
                };
                if (_local17.indexOf("add") != -1)
                {
                    _local6.drawMode = 1;
                };
                if (_version >= 4)
                {
                    _local6.origWidth = steam.readShort();
                    _local6.origHeight = steam.readShort();
                }
                else
                {
                    _local6.origWidth = -1;
                    _local6.origHeight = -1;
                };
                if (_version == 1)
                {
                    _local3 = (steam.readShort() / 1000);
                    _local4 = Math.sin(_local3);
                    _local15 = Math.cos(_local3);
                    _local6.transform.matrix.m00 = _local15;
                    _local6.transform.matrix.m01 = -(_local4);
                    _local6.transform.matrix.m10 = _local4;
                    _local6.transform.matrix.m11 = _local15;
                    _local6.transform.matrix.m02 = (steam.readShort() / 20);
                    _local6.transform.matrix.m12 = (steam.readShort() / 20);
                }
                else
                {
                    _local6.transform.matrix.m00 = (steam.readInt() / 0x140000);
                    _local6.transform.matrix.m01 = (steam.readInt() / 0x140000);
                    _local6.transform.matrix.m10 = (steam.readInt() / 0x140000);
                    _local6.transform.matrix.m11 = (steam.readInt() / 0x140000);
                    _local6.transform.matrix.m02 = (steam.readShort() / 20);
                    _local6.transform.matrix.m12 = (steam.readShort() / 20);
                };
                _local6.imageName = _local8;
                if (_local6.imageName.length > 0)
                {
                    if (texture != null)
                    {
                        if (Load_GetImage(_local6, texture) == false)
                        {
                            Load_GetImageNoTexture(_local6);
                        };
                    }
                    else
                    {
                        Load_GetImageNoTexture(_local6);
                    };
                };
                _local13++;
            };
            var _local14:int = steam.readShort();
            _mainAnimDef.spriteDefVector.length = _local14;
            _local13 = 0;
            while (_local13 < _local14)
            {
                _mainAnimDef.spriteDefVector[_local13] = new JASpriteDef();
                _local13++;
            };
            _local13 = 0;
            while (_local13 < _local14)
            {
                if (LoadSpriteDef(steam, _mainAnimDef.spriteDefVector[_local13]) == false)
                {
                    return (-4);
                };
                _local13++;
            };
            var _local7:Boolean = (((_version <= 3)) || (steam.readBoolean()));
            if (_local7)
            {
                _mainAnimDef.mainSpriteDef = new JASpriteDef();
                if (LoadSpriteDef(steam, _mainAnimDef.mainSpriteDef) == false)
                {
                    return (-5);
                };
            };
            _loaded = true;
            return (0);
        }

        private function Load_GetImageNoTexture(p_theImage:JAImage):void
        {
            var _local2:JAMemoryImage = new JAMemoryImage(null);
            _local2.width = p_theImage.origWidth;
            _local2.height = p_theImage.origHeight;
            _local2.loadFlag = 2;
            _local2.texture = null;
            _local2.name = p_theImage.imageName;
            _local2.imageExist = false;
            p_theImage.images.push(_local2);
        }

        private function Load_GetImage(p_theImage:JAImage, p_texture:FTextureAtlas):Boolean
        {
            var _local4:FTexture = p_texture.getTexture(p_theImage.imageName);
            if (_local4 == null)
            {
                return (false);
            };
            var _local3:JAMemoryImage = new JAMemoryImage(null);
            _local3.width = _local4.frameWidth;
            _local3.height = _local4.frameHeight;
            _local3.loadFlag = 2;
            _local3.texture = _local4;
            p_theImage.OnMemoryImageLoadCompleted(_local3);
            p_theImage.images.push(_local3);
            return (true);
        }

        private function ReadString(bytes:ByteArray):String
        {
            var _local2:uint = bytes.readShort();
            return (bytes.readUTFBytes(_local2));
        }

        private function Remap(str:String):String
        {
            var _local5:int;
            var _local3:Array = [];
            var _local4 = str;
            var _local2:uint = _remapList.length;
            _local5 = 0;
            while (_local5 < _local2)
            {
                if (WildcardReplace(str, _remapList[_local5][0], _remapList[_local5][1], _local3))
                {
                    _local4 = _local3[0];
                    break;
                };
                _local5++;
            };
            _local3.splice(0);
            _local3 = null;
            return (_local4);
        }

        private function WildcardReplace(theValue:String, theWildcard:String, theReplacement:String, theResult:Array):Boolean
        {
            var _local6:int;
            var _local5:int;
            var _local7:int;
            var _local8:Boolean;
            var _local9:int;
            if (theWildcard.length == 0)
            {
                return (false);
            };
            if (theWildcard.charAt(0) == "*")
            {
                if (theWildcard.length == 1)
                {
                    theResult.push(WildcardExpand(theValue, 0, theValue.length, theReplacement));
                    return (true);
                };
                if (theWildcard.charAt((theWildcard.length - 1)) == "*")
                {
                    _local6 = (theWildcard.length - 2);
                    _local5 = (theValue.length - _local6);
                    _local7 = 0;
                    while (_local7 <= _local5)
                    {
                        _local8 = true;
                        _local9 = 0;
                        while (_local9 < _local6)
                        {
                            if (theWildcard.charAt((_local9 + 1)).toUpperCase() != theValue.charAt((_local7 + _local9)).toUpperCase())
                            {
                                _local8 = false;
                                break;
                            };
                            _local9++;
                        };
                        if (_local8)
                        {
                            theResult.push(WildcardExpand(theValue, _local7, (_local7 + _local6), theReplacement));
                            return (true);
                        };
                        _local7++;
                    };
                }
                else
                {
                    if (theValue.length < (theWildcard.length - 1))
                    {
                        return (false);
                    };
                    if (theWildcard.substr(1).toUpperCase() != theValue.substr(((theValue.length - theWildcard.length) + 1)).toUpperCase())
                    {
                        return (false);
                    };
                    theResult.push(WildcardExpand(theValue, ((theValue.length - theWildcard.length) + 1), theValue.length, theReplacement));
                    return (true);
                };
            }
            else
            {
                if (theWildcard.charAt((theWildcard.length - 1)) == "*")
                {
                    if (theValue.length < (theWildcard.length - 1))
                    {
                        return (false);
                    };
                    if (theWildcard.substr(0, (theWildcard.length - 1)).toUpperCase() != theValue.substr(0, (theWildcard.length - 1)).toUpperCase())
                    {
                        return (false);
                    };
                    theResult.push(WildcardExpand(theValue, 0, (theWildcard.length - 1), theReplacement));
                    return (true);
                };
                if (theWildcard.toUpperCase() == theValue.toUpperCase())
                {
                    if (theReplacement.length > 0)
                    {
                        if (theReplacement.charAt(0) == "*")
                        {
                            theResult.push((theValue + theReplacement.substr(1)));
                        }
                        else
                        {
                            if (theReplacement.charAt((theReplacement.length - 1)) == "*")
                            {
                                theResult.push((theReplacement.substr(0, (theReplacement.length - 1)) + theValue));
                            }
                            else
                            {
                                theResult.push(theReplacement);
                            };
                        };
                    }
                    else
                    {
                        theResult.push(theReplacement);
                    };
                    return (true);
                };
            };
            return (false);
        }

        private function WildcardExpand(theValue:String, theMatchStart:int, theMatchEnd:int, theReplacement:String):String
        {
            var _local5 = null;
            if (theReplacement.length == 0)
            {
                _local5 = "";
            }
            else
            {
                if (theReplacement.charAt(0) == "*")
                {
                    if (theReplacement.length == 1)
                    {
                        _local5 = (theValue.substr(0, theMatchStart) + theValue.substr(theMatchEnd));
                    }
                    else
                    {
                        if (theReplacement.charAt((theReplacement.length - 1)) == "*")
                        {
                            _local5 = ((theValue.substr(0, theMatchStart) + theReplacement.substr(1, (theReplacement.length - 2))) + theValue.substr(theMatchEnd));
                        }
                        else
                        {
                            _local5 = (theValue.substr(0, theMatchStart) + theReplacement.substr(1, (theReplacement.length - 1)));
                        };
                    };
                }
                else
                {
                    if (theReplacement.charAt((theReplacement.length - 1)) == "*")
                    {
                        _local5 = (theReplacement.substr(0, (theReplacement.length - 1)) + theValue.substr(theMatchEnd));
                    }
                    else
                    {
                        _local5 = theReplacement;
                    };
                };
            };
            return (_local5);
        }

        private function LoadSpriteDef(steam:ByteArray, jaSpriteDef:JASpriteDef):Boolean
        {
            var _local22:int;
            var _local19:int;
            var _local15 = null;
            var _local4:int;
            var _local3:int;
            var _local17:int;
            var _local12:int;
            var _local25 = null;
            var _local21:int;
            var _local24 = null;
            var _local20:int;
            var _local13:int;
            var _local7:int;
            var _local11:int;
            var _local14:Number;
            var _local16:Number;
            var _local23:Number;
            var _local9 = null;
            var _local8 = null;
            var _local10:int;
            var _local18:int;
            var _local27 = null;
            if (_version >= 4)
            {
                jaSpriteDef.name = ReadString(steam);
                jaSpriteDef.animRate = (steam.readInt() / 65536);
                _mainAnimDef.objectNamePool.push(jaSpriteDef.name);
            }
            else
            {
                jaSpriteDef.name = null;
                jaSpriteDef.animRate = _animRate;
            };
            var _local5:int = steam.readShort();
            if (_version >= 5)
            {
                jaSpriteDef.workAreaStart = steam.readShort();
                jaSpriteDef.workAreaDuration = steam.readShort();
            }
            else
            {
                jaSpriteDef.workAreaStart = 0;
                jaSpriteDef.workAreaDuration = (_local5 - 1);
            };
            jaSpriteDef.workAreaDuration = (Math.min((jaSpriteDef.workAreaStart + jaSpriteDef.workAreaDuration), (_local5 - 1)) - jaSpriteDef.workAreaStart);
            jaSpriteDef.frames.length = _local5;
            _local22 = 0;
            while (_local22 < _local5)
            {
                jaSpriteDef.frames[_local22] = new JAFrame();
                _local22++;
            };
            var _local6:Dictionary = new Dictionary();
            _local22 = 0;
            while (_local22 < _local5)
            {
                _local15 = jaSpriteDef.frames[_local22];
                _local4 = steam.readUnsignedByte();
                if ((_local4 & 1))
                {
                    _local3 = steam.readByte();
                    if (_local3 == 0xFF)
                    {
                        _local3 = steam.readShort();
                    };
                    _local19 = 0;
                    while (_local19 < _local3)
                    {
                        _local17 = steam.readShort();
                        if (_local17 >= 2047)
                        {
                            _local17 = steam.readUnsignedInt();
                        };
                        delete _local6[_local17];
                        _local19++;
                    };
                };
                if ((_local4 & 2))
                {
                    _local12 = steam.readByte();
                    if (_local12 == 0xFF)
                    {
                        _local12 = steam.readShort();
                    };
                    _local19 = 0;
                    while (_local19 < _local12)
                    {
                        _local25 = new JAObjectPos();
                        _local21 = steam.readShort();
                        _local25.objectNum = (_local21 & 2047);
                        if (_local25.objectNum == 2047)
                        {
                            _local25.objectNum = steam.readUnsignedInt();
                        };
                        _local25.isSprite = !(((_local21 & 0x8000) == 0));
                        _local25.isAdditive = !(((_local21 & 0x4000) == 0));
                        _local25.resNum = steam.readByte();
                        _local25.hasSrcRect = false;
                        _local25.color = JAColor.White;
                        _local25.animFrameNum = 0;
                        _local25.timeScale = 1;
                        _local25.name = null;
                        if ((_local21 & 0x2000) != 0)
                        {
                            _local25.preloadFrames = steam.readShort();
                        }
                        else
                        {
                            _local25.preloadFrames = 0;
                        };
                        if ((_local21 & 0x1000))
                        {
                            _local24 = ReadString(steam);
                            _mainAnimDef.objectNamePool.push(_local24);
                            _local25.name = _local24;
                            _local24 = null;
                        };
                        if ((_local21 & 0x0800))
                        {
                            _local25.timeScale = (steam.readUnsignedInt() / 65536);
                        };
                        if (jaSpriteDef.objectDefVector.length < (_local25.objectNum + 1))
                        {
                            _local20 = 0;
                            while (_local20 < (_local25.objectNum + 1))
                            {
                                jaSpriteDef.objectDefVector.push(new JAObjectDef());
                                _local20++;
                            };
                        };
                        jaSpriteDef.objectDefVector[_local25.objectNum].name = _local25.name;
                        if (_local25.isSprite)
                        {
                            jaSpriteDef.objectDefVector[_local25.objectNum].spriteDef = _mainAnimDef.spriteDefVector[_local25.resNum];
                        };
                        _local6[_local25.objectNum] = _local25;
                        _local19++;
                    };
                };
                if ((_local4 & 4))
                {
                    _local13 = steam.readByte();
                    if (_local13 == 0xFF)
                    {
                        _local13 = steam.readShort();
                    };
                    _local19 = 0;
                    while (_local19 < _local13)
                    {
                        _local7 = steam.readShort();
                        _local11 = (_local7 & 1023);
                        if (_local11 == 1023)
                        {
                            _local11 = steam.readUnsignedInt();
                        };
                        _local25 = _local6[_local11];
                        _local25.transform.matrix.LoadIdentity();
                        if ((_local7 & 0x1000))
                        {
                            _local25.transform.matrix.m00 = (steam.readInt() / 65536);
                            _local25.transform.matrix.m01 = (steam.readInt() / 65536);
                            _local25.transform.matrix.m10 = (steam.readInt() / 65536);
                            _local25.transform.matrix.m11 = (steam.readInt() / 65536);
                        }
                        else
                        {
                            if ((_local7 & 0x4000))
                            {
                                _local14 = (steam.readShort() / 1000);
                                _local16 = Math.sin(_local14);
                                _local23 = Math.cos(_local14);
                                if (_version == 2)
                                {
                                    _local16 = -(_local16);
                                };
                                _local25.transform.matrix.m00 = _local23;
                                _local25.transform.matrix.m01 = -(_local16);
                                _local25.transform.matrix.m10 = _local16;
                                _local25.transform.matrix.m11 = _local23;
                            };
                        };
                        _local9 = new JAMatrix3();
                        if ((_local7 & 0x0800))
                        {
                            _local9.m02 = (steam.readInt() / 20);
                            _local9.m12 = (steam.readInt() / 20);
                        }
                        else
                        {
                            _local9.m02 = (steam.readShort() / 20);
                            _local9.m12 = (steam.readShort() / 20);
                        };
                        _local25.transform.matrix = JAMatrix3.MulJAMatrix3(_local9, _local25.transform.matrix, _local25.transform.matrix);
                        _local25.hasSrcRect = !(((_local7 & 0x8000) == 0));
                        if ((_local7 & 0x8000))
                        {
                            if (_local25.srcRect == null)
                            {
                                _local25.srcRect = new Rectangle();
                            };
                            _local25.srcRect.x = (steam.readShort() / 20);
                            _local25.srcRect.y = (steam.readShort() / 20);
                            _local25.srcRect.width = (steam.readShort() / 20);
                            _local25.srcRect.height = (steam.readShort() / 20);
                        };
                        if ((_local7 & 0x2000))
                        {
                            if (_local25.color == JAColor.White)
                            {
                                _local25.color = new JAColor();
                            };
                            _local25.color.red = steam.readUnsignedByte();
                            _local25.color.green = steam.readUnsignedByte();
                            _local25.color.blue = steam.readUnsignedByte();
                            _local25.color.alpha = steam.readUnsignedByte();
                        };
                        if ((_local7 & 0x0400))
                        {
                            _local25.animFrameNum = steam.readShort();
                        };
                        _local19++;
                    };
                };
                if ((_local4 & 8))
                {
                    _local8 = ReadString(steam);
                    _local8 = Remap(_local8).toUpperCase();
                    jaSpriteDef.label[_local8] = _local22;
                };
                if ((_local4 & 16))
                {
                    _local15.hasStop = true;
                };
                if ((_local4 & 32))
                {
                    _local10 = steam.readByte();
                    _local15.commandVector.length = _local10;
                    _local19 = 0;
                    while (_local19 < _local10)
                    {
                        _local15.commandVector[_local19] = new JACommand();
                        _local19++;
                    };
                    _local19 = 0;
                    while (_local19 < _local10)
                    {
                        _local15.commandVector[_local19].command = Remap(ReadString(steam));
                        _local15.commandVector[_local19].param = Remap(ReadString(steam));
                        _local19++;
                    };
                };
                _local18 = 0;
                for each (var _local26:JAObjectPos in _local6)
                {
                    _local15.frameObjectPosVector[_local18] = new JAObjectPos();
                    _local15.frameObjectPosVector[_local18].clone(_local26);
                    _local26.preloadFrames = 0;
                    _local18++;
                };
                _local22++;
            };
            if (_local5 == 0)
            {
                jaSpriteDef.frames.length = 1;
                jaSpriteDef.frames[0] = new JAFrame();
            };
            _local22 = 0;
            while (_local22 < jaSpriteDef.objectDefVector.length)
            {
                _local27 = jaSpriteDef.objectDefVector[_local22];
                _local22++;
            };
            return (true);
        }

const PAM_MAGIC:uint = 3136297300;
const PAM_VERSION:uint = 5;
const FRAMEFLAGS_HAS_REMOVES:uint = 1;
const FRAMEFLAGS_HAS_ADDS:uint = 2;
const FRAMEFLAGS_HAS_MOVES:uint = 4;
const FRAMEFLAGS_HAS_FRAME_NAME:uint = 8;
const FRAMEFLAGS_HAS_STOP:uint = 16;
const FRAMEFLAGS_HAS_COMMANDS:uint = 32;
const MOVEFLAGS_HAS_SRCRECT:uint = 0x8000;
const MOVEFLAGS_HAS_ROTATE:uint = 0x4000;
const MOVEFLAGS_HAS_COLOR:uint = 0x2000;
const MOVEFLAGS_HAS_MATRIX:uint = 0x1000;
const MOVEFLAGS_HAS_LONGCOORDS:uint = 0x0800;
const MOVEFLAGS_HAS_ANIMFRAMENUM:uint = 0x0400;

    }
}//package com.flengine.components.renderables.jointanim


