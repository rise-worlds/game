// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.textures.factories.FTextureAtlasFactory

package com.flengine.textures.factories
{
    import __AS3__.vec.Vector;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.display.MovieClip;
    import com.flengine.textures.FTextureAtlas;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import com.flengine.utils.FPackerRectangle;
    import com.flengine.utils.FMaxRectPacker;
    import com.flengine.textures.FTextureUtils;
    import com.flengine.utils.FPacker;
    import flash.geom.Rectangle;
    import flash.display.Bitmap;
    import com.flengine.error.FError;
    import flash.utils.ByteArray;
    import flash.geom.Point;

    public class FTextureAtlasFactory 
    {


        public static function createFromMovieClip(p_id:String, p_movieClip:MovieClip, p_forceMod2:Boolean=false):FTextureAtlas
        {
            var _local11:int;
            var _local8:int;
            var _local6:int;
            var _local5 = null;
            var _local4 = null;
            var _local10:Vector.<BitmapData> = new Vector.<BitmapData>();
            var _local7:Vector.<String> = new Vector.<String>();
            var _local9:Matrix = new Matrix();
            _local11 = 1;
            while (_local11 < p_movieClip.totalFrames)
            {
                p_movieClip.gotoAndStop(_local11);
                _local8 = ((((!(((p_movieClip.width % 2) == 0))) && (p_forceMod2))) ? (p_movieClip.width + 1) : p_movieClip.width);
                _local6 = ((((!(((p_movieClip.height % 2) == 0))) && (p_forceMod2))) ? (p_movieClip.height + 1) : p_movieClip.height);
                _local5 = new BitmapData(p_movieClip.width, p_movieClip.height, true, 0);
                _local4 = p_movieClip.getBounds(p_movieClip);
                _local9.identity();
                _local9.translate(-(_local4.x), -(_local4.y));
                _local5.draw(p_movieClip, _local9);
                _local10.push(_local5);
                _local7.push(_local11);
                _local11++;
            };
            return (createFromBitmapDatas(p_id, _local10, _local7));
        }

        public static function createFromFont(p_id:String, p_format:TextFormat, p_chars:String, p_forceMod2:Boolean=false):FTextureAtlas
        {
            var _local11:int;
            var _local9:int;
            var _local7:int;
            var _local6 = null;
            var _local5:TextField = new TextField();
            _local5.embedFonts = true;
            _local5.defaultTextFormat = p_format;
            _local5.multiline = false;
            _local5.autoSize = "left";
            var _local10:Vector.<BitmapData> = new Vector.<BitmapData>();
            var _local8:Vector.<String> = new Vector.<String>();
            _local11 = 0;
            while (_local11 < p_chars.length)
            {
                _local5.text = p_chars.charAt(_local11);
                _local9 = ((((!(((_local5.width % 2) == 0))) && (p_forceMod2))) ? (_local5.width + 1) : _local5.width);
                _local7 = ((((!(((_local5.height % 2) == 0))) && (p_forceMod2))) ? (_local5.height + 1) : _local5.height);
                _local6 = new BitmapData(_local9, _local7, true, 0);
                _local6.draw(_local5);
                _local10.push(_local6);
                _local8.push(p_chars.charCodeAt(_local11));
                _local11++;
            };
            return (createFromBitmapDatas(p_id, _local10, _local8));
        }

        public static function createFromBitmapDatas(p_id:String, p_bitmaps:Vector.<BitmapData>, p_ids:Vector.<String>, p_packer:FPacker=null, p_padding:int=2):FTextureAtlas
        {
            var _local12:int;
            var _local10 = null;
            var _local8 = null;
            var _local11:Vector.<FPackerRectangle> = new Vector.<FPackerRectangle>();
            _local12 = 0;
            while (_local12 < p_bitmaps.length)
            {
                _local8 = p_bitmaps[_local12];
                _local10 = FPackerRectangle.get(0, 0, _local8.width, _local8.height, p_ids[_local12], _local8);
                _local11.push(_local10);
                _local12++;
            };
            if (p_packer == null)
            {
                p_packer = new FMaxRectPacker(1, 1, 0x0800, 0x0800, true);
            };
            p_packer.packRectangles(_local11, p_padding);
            if (p_packer.rectangles.length != p_bitmaps.length)
            {
                return (null);
            };
            var _local9:BitmapData = new BitmapData(p_packer.width, p_packer.height, true, 0);
            p_packer.draw(_local9);
            var _local7:FTextureAtlas = new FTextureAtlas(p_id, 3, _local9.width, _local9.height, _local9, FTextureUtils.isBitmapDataTransparent(_local9), null);
            var _local6:int = p_packer.rectangles.length;
            _local12 = 0;
            while (_local12 < _local6)
            {
                _local10 = p_packer.rectangles[_local12];
                _local7.addSubTexture(_local10.id, _local10.rect, _local10.rect.width, _local10.rect.height, _local10.pivotX, _local10.pivotY);
                _local12++;
            };
            _local7.invalidate();
            return (_local7);
        }

        public static function createFromBitmapDataAndXML(p_id:String, p_bitmapData:BitmapData, p_xml:XML):FTextureAtlas
        {
            var _local11:int;
            var _local6 = null;
            var _local4 = null;
            var _local5:Number;
            var _local7:Number;
            var _local9:Number;
            var _local10:Number;
            var _local8:FTextureAtlas = new FTextureAtlas(p_id, 3, p_bitmapData.width, p_bitmapData.height, p_bitmapData, FTextureUtils.isBitmapDataTransparent(p_bitmapData), null);
            _local11 = 0;
            while (_local11 < p_xml.children().length())
            {
                _local6 = p_xml.children()[_local11];
                _local4 = new Rectangle(_local6.@x, _local6.@y, _local6.@width, _local6.@height);
                _local5 = (((((_local6.@frameX == undefined)) && ((_local6.@frameWidth == undefined)))) ? 0 : (((_local6.@frameWidth - _local4.width) / 2) + _local6.@frameX));
                _local7 = (((((_local6.@frameY == undefined)) && ((_local6.@frameHeight == undefined)))) ? 0 : (((_local6.@frameHeight - _local4.height) / 2) + _local6.@frameY));
                _local9 = (((_local6.@frameWidth)==undefined) ? _local6.@width : _local6.@frameWidth);
                _local10 = (((_local6.@frameHeight)==undefined) ? _local6.@height : _local6.@frameHeight);
                _local8.addSubTexture(_local6.@name, _local4, _local9, _local10, _local5, _local7, false);
                _local11++;
            };
            _local8.invalidate();
            return (_local8);
        }

        public static function createFromAssets(p_id:String, p_bitmapAsset:Class, p_xmlAsset:Class):FTextureAtlas
        {
            var _local4:Bitmap = new (p_bitmapAsset)();
            var _local5:XML = XML(new (p_xmlAsset)());
            return (createFromBitmapDataAndXML(p_id, _local4.bitmapData, _local5));
        }

        public static function createFromBitmapDataAndFontXML(p_id:String, p_bitmapData:BitmapData, p_fontXml:XML):FTextureAtlas
        {
            var _local9:int;
            var _local6 = null;
            var _local4 = null;
            var _local5:int;
            var _local7:int;
            var _local8:FTextureAtlas = new FTextureAtlas(p_id, 3, p_bitmapData.width, p_bitmapData.height, p_bitmapData, FTextureUtils.isBitmapDataTransparent(p_bitmapData), null);
            _local9 = 0;
            while (_local9 < p_fontXml.chars.children().length())
            {
                _local6 = p_fontXml.chars.children()[_local9];
                _local4 = new Rectangle(_local6.@x, _local6.@y, _local6.@width, _local6.@height);
                _local5 = -(_local6.@xoffset);
                _local7 = -(_local6.@yoffset);
                _local8.addSubTexture(_local6.@id, _local4, _local4.width, _local4.height, _local5, _local7);
                _local9++;
            };
            _local8.invalidate();
            return (_local8);
        }

        public static function createFromATFAndXML(p_id:String, p_atfData:ByteArray, p_xml:XML, p_uploadCallback:Function=null):FTextureAtlas
        {
            var _local9:int;
            var _local10:int;
            var _local11 = null;
            var _local5 = null;
            var _local6:Number;
            var _local7:Number;
            var _local14:String = String.fromCharCode(p_atfData[0], p_atfData[1], p_atfData[2]);
            if (_local14 != "ATF")
            {
                throw (new FError("FError: Invalid ATF data."));
            };
            var _local15:Boolean = true;
            switch (p_atfData[6])
            {
                case 1:
                    _local9 = 0;
                    break;
                case 3:
                    _local9 = 1;
                    _local15 = false;
                    break;
                case 5:
                    _local9 = 2;
            };
            var _local8:int = Math.pow(2, p_atfData[7]);
            var _local12:int = Math.pow(2, p_atfData[8]);
            var _local13:FTextureAtlas = new FTextureAtlas(p_id, _local9, _local8, _local12, p_atfData, _local15, p_uploadCallback);
            _local10 = 0;
            while (_local10 < p_xml.children().length())
            {
                _local11 = p_xml.children()[_local10];
                _local5 = new Rectangle(_local11.@x, _local11.@y, _local11.@width, _local11.@height);
                _local6 = (((((_local11.@frameX == undefined)) && ((_local11.@frameWidth == undefined)))) ? 0 : (((_local11.@frameWidth - _local5.width) / 2) + _local11.@frameX));
                _local7 = (((((_local11.@frameY == undefined)) && ((_local11.@frameHeight == undefined)))) ? 0 : (((_local11.@frameHeight - _local5.height) / 2) + _local11.@frameY));
                _local13.addSubTexture(_local11.@name, _local5, _local5.width, _local5.height, _local6, _local7);
                _local10++;
            };
            _local13.invalidate();
            return (_local13);
        }

        public static function createFromBitmapDataAndRegions(p_id:String, p_bitmapData:BitmapData, p_regions:Vector.<Rectangle>, p_ids:Vector.<String>=null, p_pivots:Vector.<Point>=null):FTextureAtlas
        {
            var _local9:int;
            var _local6 = null;
            var _local8:Boolean;
            var _local7:FTextureAtlas = new FTextureAtlas(p_id, 3, p_bitmapData.width, p_bitmapData.height, p_bitmapData, FTextureUtils.isBitmapDataTransparent(p_bitmapData), null);
            _local9 = 0;
            while (_local9 < p_regions.length)
            {
                _local6 = (((p_ids)==null) ? _local9 : p_ids[_local9]);
                _local8 = !((p_bitmapData.histogram(p_regions[_local9])[3][0xFF] == (p_regions[_local9].width * p_regions[_local9].height)));
                if (p_pivots)
                {
                    _local7.addSubTexture(_local6, p_regions[_local9], p_regions[_local9].width, p_regions[_local9].height, p_pivots[_local9].x, p_pivots[_local9].y);
                }
                else
                {
                    _local7.addSubTexture(_local6, p_regions[_local9], p_regions[_local9].width, p_regions[_local9].height);
                };
                _local9++;
            };
            _local7.invalidate();
            return (_local7);
        }


    }
}//package com.flengine.textures.factories

