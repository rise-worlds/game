// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.textures.FTextureAtlas

package com.flengine.textures
{
    import flash.utils.Dictionary;
    import com.flengine.error.FError;
    import flash.geom.Rectangle;
	import com.flengine.fl2d;
	use namespace fl2d;

    public class FTextureAtlas extends FTextureBase 
    {

        private var __dTextures:Dictionary;

        public function FTextureAtlas(p_id:String, p_sourceType:int, p_width:int, p_height:int, p_source:*, p_transparent:Boolean, p_uploadCallback:Function)
        {
            super(p_id, p_sourceType, p_source, p_transparent, p_uploadCallback);
            if (((!(FTextureUtils.isValidTextureSize(p_width))) || (!(FTextureUtils.isValidTextureSize(p_height)))))
            {
                throw (new FError("FError: Invalid atlas size, it needs to be power of 2."));
            };
            iWidth = p_width;
            iHeight = p_height;
            __dTextures = new Dictionary();
        }

        public static function getTextureAtlasById(p_id:String):FTextureAtlas
        {
            return ((FTextureBase.getTextureBaseById(p_id) as FTextureAtlas));
        }


        public function get textures():Dictionary
        {
            return (__dTextures);
        }

        override public function set filteringType(p_type:int):void
        {
            super.filteringType = p_type;
            for each (var _local2:FTexture in __dTextures)
            {
                _local2.iFilteringType = p_type;
            };
        }

        public function getTexture(p_id:String):FTexture
        {
            return (__dTextures[p_id]);
        }

        override protected function invalidateContextTexture(p_reinitialize:Boolean):void
        {
            super.invalidateContextTexture(p_reinitialize);
            for each (var _local2:FTexture in __dTextures)
            {
                _local2.cContextTexture = cContextTexture;
                _local2.iAtfType = iAtfType;
            };
        }

        public function addSubTexture(p_subId:String, p_region:Rectangle, p_frameWidth:Number, p_frameHeight:Number, p_pivotX:Number=0, p_pivotY:Number=0, p_invalidate:Boolean=false):FTexture
        {
            var _local8:FTexture = new FTexture(((_sId + "_") + p_subId), iSourceType, getSource(), p_region, bTransparent, p_frameWidth, p_frameHeight, p_pivotX, p_pivotY, null, this);
            _local8.sSubId = p_subId;
            _local8.filteringType = filteringType;
            _local8.cContextTexture = cContextTexture;
            __dTextures[p_subId] = _local8;
            if (p_invalidate)
            {
                invalidate();
            };
            return (_local8);
        }

        public function removeSubTexture(p_subId:String):void
        {
            __dTextures[p_subId] = null;
        }

        private function disposeSubTextures():void
        {
            var _local2 = null;
            for (var _local1:String in __dTextures)
            {
                _local2 = __dTextures[_local1];
                _local2.dispose();
                delete __dTextures[_local1];
            };
            __dTextures = new Dictionary();
        }

        override public function dispose():void
        {
            disposeSubTextures();
            if (baByteArray)
            {
                baByteArray = null;
            };
            if (bdBitmapData)
            {
                bdBitmapData.dispose();
                bdBitmapData = null;
            };
            if (cContextTexture)
            {
                cContextTexture.dispose();
            };
            super.dispose();
        }


    }
}//package com.flengine.textures

