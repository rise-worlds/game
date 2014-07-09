// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.core.FConfig

package com.flengine.core
{
    import flash.geom.Rectangle;
    import flash.display.Stage3D;
	import com.flengine.fl2d;
	use namespace fl2d;

    public class FConfig 
    {

        public var backgroundRed:Number = 0;
        public var backgroundGreen:Number = 0;
        public var backgroundBlue:Number = 0;
        public var renderMode:String = "auto";
        public var useSeparatedAlphaShaders:Boolean = true;
        public var enableStats:Boolean = false;
        public var showExtendedStats:Boolean = false;
        public var enableNativeContentMouseCapture:Boolean = true;
        public var useFastMem:Boolean = false;
        protected var _sProfile:String;
        protected var _rViewRect:Rectangle;
        private var __iAntiAliasing:int = 0;
        private var __bEnableDepthAndStencil:Boolean = false;
        public var enableFixedTimeStep:Boolean = false;
        public var fixedTimeStep:int = 30;
        public var renderFrameSkip:int = 0;
        public var timeStepScale:Number = 1;
        protected var _st3ExternalStage3D:Stage3D;

        public function FConfig(p_rect:Rectangle, p_profile:String="baselineConstrained", p_externalStage3d:Stage3D=null)
        {
            _rViewRect = p_rect;
            _sProfile = p_profile;
            _st3ExternalStage3D = p_externalStage3d;
        }

        public function set backgroundColor(p_value:int):void
        {
            backgroundRed = (((p_value >> 16) & 0xFF) / 0xFF);
            backgroundGreen = (((p_value >> 8) & 0xFF) / 0xFF);
            backgroundBlue = ((p_value & 0xFF) / 0xFF);
        }

        public function get profile():String
        {
            return (_sProfile);
        }

        public function get viewRect():Rectangle
        {
            return (_rViewRect);
        }

        public function set viewRect(p_rect:Rectangle):void
        {
            _rViewRect = p_rect;
            if (FlEngine.getInstance().cContext)
            {
                FlEngine.getInstance().cContext.invalidate();
            };
        }

        public function get antiAliasing():int
        {
            return (__iAntiAliasing);
        }

        public function set antiAliasing(p_value:int):void
        {
            __iAntiAliasing = p_value;
            if (FlEngine.getInstance().cContext)
            {
                FlEngine.getInstance().cContext.invalidate();
            };
        }

        public function get enableDepthAndStencil():Boolean
        {
            return (__bEnableDepthAndStencil);
        }

        public function set enableDepthAndStencil(p_value:Boolean):void
        {
            __bEnableDepthAndStencil = p_value;
            if (FlEngine.getInstance().cContext)
            {
                FlEngine.getInstance().cContext.invalidate();
            };
        }

        public function get externalStage3D():Stage3D
        {
            return (_st3ExternalStage3D);
        }


    }
}//package com.flengine.core

