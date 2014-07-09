// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.FContextTexture

package com.flengine.context
{
    import flash.display3D.Context3D;
    import flash.display3D.textures.Texture;
    import flash.display.BitmapData;
    import flash.utils.ByteArray;
	import com.flengine.fl2d;
	use namespace fl2d;

    public class FContextTexture 
    {

        private var __cContext:Context3D;
        fl2d var iWidth:int;
        fl2d var iHeight:int;
        fl2d var tTexture:Texture;

        public function FContextTexture(p_context:Context3D, p_width:int, p_height:int, p_format:String, p_optimizeForRenderToTexture:Boolean)
        {
            __cContext = p_context;
            if (__cContext.driverInfo == "Disposed")
            {
                return;
            };
            iWidth = p_width;
            iHeight = p_height;
            tTexture = p_context.createTexture(iWidth, iHeight, p_format, p_optimizeForRenderToTexture);
        }

        fl2d function getTexture():Texture
        {
            return (tTexture);
        }

        fl2d function dispose():void
        {
            if (tTexture != null)
            {
                tTexture.dispose();
            };
        }

        fl2d function uploadFromBitmapData(p_bitmapData:BitmapData):void
        {
            if ((((tTexture == null)) || ((__cContext.driverInfo == "Disposed"))))
            {
                return;
            };
            tTexture.uploadFromBitmapData(p_bitmapData, 0);
        }

        fl2d function uploadFromCompressedByteArray(p_data:ByteArray, p_byteArrayOffset:uint, p_asyncBoolean:Boolean):void
        {
            if ((((tTexture == null)) || ((__cContext.driverInfo == "Disposed"))))
            {
                return;
            };
            tTexture.uploadCompressedTextureFromByteArray(p_data, p_byteArrayOffset, p_asyncBoolean);
        }

        fl2d function uploadFromByteArray(p_data:ByteArray, p_byteArrayOffset:uint):void
        {
            if ((((tTexture == null)) || ((__cContext.driverInfo == "Disposed"))))
            {
                return;
            };
            tTexture.uploadFromByteArray(p_data, p_byteArrayOffset, 0);
        }


    }
}//package com.flengine.context

