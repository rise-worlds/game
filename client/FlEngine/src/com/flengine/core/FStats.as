// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.core.FStats

package com.flengine.core
{
    import com.flengine.textures.FTexture;
    import flash.text.TextField;
    import flash.display.BitmapData;
    import com.flengine.textures.factories.FTextureFactory;
    import flash.text.TextFormat;
    import flash.utils.getTimer;
    import flash.system.System;
    import com.flengine.textures.FTextureBase;
	import com.flengine.fl2d;
	use namespace fl2d;

    public class FStats 
    {

        public static var x:Number = 10;
        public static var y:Number = 10;
        public static var scaleX:Number = 1;
        public static var scaleY:Number = 1;
        private static var __cTexture:FTexture;
        private static var __tfStatsField:TextField;
        private static var __bInitialized:Boolean = false;
        private static var __iPreviousTime:uint;
        private static var __sFPSString:String;
        private static var __sFPSSimpleString:String;
        private static var __iFPS:int = 0;
        private static var __iLastFPS:int = -1;
        private static var __sMemString:String;
        private static var __sMemSimpleString:String;
        private static var __iMem:int;
        private static var __iMemMax:int;
        private static var __bdBitmapData:BitmapData;
        fl2d static var iDrawCalls:int = 0;


        public static function get fps():int
        {
            return (__iLastFPS);
        }

        fl2d static function init():void
        {
            __bdBitmapData = new BitmapData(0x0100, 16, false, 0);
            __cTexture = FTextureFactory.createFromBitmapData("stats_internal", __bdBitmapData);
            var _local1:TextFormat = new TextFormat("_sans", 9, 0xFFFFFF);
            __tfStatsField = new TextField();
            __tfStatsField.defaultTextFormat = _local1;
            __tfStatsField.autoSize = "left";
            __tfStatsField.multiline = true;
            __tfStatsField.backgroundColor = 0;
            __tfStatsField.background = true;
            __bInitialized = true;
        }

        private static function invalidateTextureSize():void
        {
            __bdBitmapData = new BitmapData(0x0100, __tfStatsField.height, false, 0);
        }

        fl2d static function update():void
        {
            var _local1:uint = getTimer();
            if ((_local1 - 1000) > __iPreviousTime)
            {
                __iPreviousTime = _local1;
                __iLastFPS = __iFPS;
                __sFPSString = ((("<font color='#999999'>FPS:</font> " + __iLastFPS) + " / ") + FlEngine.getInstance().stage.frameRate);
                __iFPS = 0;
                __iMem = (System.totalMemory / 0x100000);
                __iMemMax = (((__iMem)>__iMemMax) ? __iMem : __iMemMax);
                __sMemString = (((("<font color='#999999'>MEM:</font> " + __iMem.toFixed(2)) + " / ") + __iMemMax.toFixed(2)) + "MB");
            };
            __iFPS++;
        }

        fl2d static function clear():void
        {
            if (!__bInitialized)
            {
                init();
            };
            iDrawCalls = 0;
        }

        fl2d static function draw():void
        {
            var _local2:int;
            var _local1:int;
            if (FlEngine.getInstance().cConfig.showExtendedStats)
            {
                __tfStatsField.htmlText = (((((__sFPSString + " ") + __sMemString) + " <font color='#999999'>DRAWS:</font> ") + iDrawCalls) + "\n");
                __tfStatsField.htmlText = (((((__tfStatsField.htmlText + "<font color='#999999'>TEXTURES:</font> ") + (FTextureBase.getTextureCount() - 1)) + " <font color='#999999'>GPU TEXTURES:</font> ") + (FTextureBase.getGPUTextureCount() - 1)) + "\n");
                _local2 = FlEngine.getInstance().aCameras.length;
                if (_local2 > 0)
                {
                    __tfStatsField.htmlText = (((__tfStatsField.htmlText + "<font color='#999999'>CUSTOM CAMERAS:</font> ") + _local2) + "\n");
                    _local1 = 0;
                    while (_local1 < _local2)
                    {
                        __tfStatsField.htmlText = (((((__tfStatsField.htmlText + "<font color='#999999'>CAMERA #") + _local1) + ":</font> ") + FlEngine.getInstance().aCameras[_local1].iRenderedNodesCount) + "\n");
                        _local1++;
                    };
                }
                else
                {
                    __tfStatsField.htmlText = (((__tfStatsField.htmlText + "<font color='#999999'>DEFAULT CAMERA:</font> ") + FlEngine.getInstance().cDefaultCamera.iRenderedNodesCount) + "\n");
                };
            }
            else
            {
                __tfStatsField.htmlText = ((((__sFPSString + " ") + __sMemString) + " <font color='#999999'>DRAWS:</font> ") + iDrawCalls);
            };
            if ((((__cTexture.height < __tfStatsField.height)) || (((!(FlEngine.getInstance().cConfig.showExtendedStats)) && ((__cTexture.height > 16))))))
            {
                invalidateTextureSize();
            }
            else
            {
                __bdBitmapData.fillRect(__bdBitmapData.rect, 0);
            };
            __bdBitmapData.draw(__tfStatsField);
            __cTexture.bitmapData = __bdBitmapData;
            __cTexture.invalidate();
            FlEngine.getInstance().context.blit(__cTexture, (((__cTexture.width * scaleX) / 2) + x), (((__cTexture.height * scaleY) / 2) + y), scaleX, scaleY, 0);
        }


    }
}//package com.flengine.core

