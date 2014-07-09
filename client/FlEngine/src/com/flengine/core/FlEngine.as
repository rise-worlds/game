// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.core.FlEngine

package com.flengine.core
{
    import com.flengine.signals.HelpSignal;
    import com.flengine.physics.FPhysics;
    import __AS3__.vec.Vector;
    import com.flengine.components.FCamera;
    import com.flengine.context.FContext;
    import flash.display.Stage;
    import com.flengine.error.FError;
    import flash.utils.getTimer;
    import flash.events.Event;
    import flash.geom.Vector3D;
    import flash.events.MouseEvent;
    import flash.events.TouchEvent;
	import com.flengine.fl2d;
	use namespace fl2d;

    public class FlEngine 
    {

        public static const VERSION:String = "0.9.3.1186";

        private static var __cInstance:FlEngine;
        private static var __bInstantiable:Boolean = false;

        private var __eOnInitialized:HelpSignal;
        private var __eOnFailed:HelpSignal;
        private var __eOnPreUpdate:HelpSignal;
        private var __eOnPostUpdate:HelpSignal;
        private var __eOnCameraAdded:HelpSignal;
        private var __eOnPreRender:HelpSignal;
        private var __eOnPostRender:HelpSignal;
        public var root:FNode;
        public var physics:FPhysics;
        public var autoUpdate:Boolean = true;
        public var paused:Boolean = false;
        private var __iRenderFrameCount:int = 0;
        private var __bInitialized:Boolean = false;
        fl2d var nCurrentDeltaTime:Number = 0;
        fl2d var aCameras:Vector.<FCamera>;
        fl2d var cDefaultCamera:FCamera;
        fl2d var cConfig:FConfig;
        fl2d var cContext:FContext;
        private var __stStage:Stage;
        private var __nLastTime:Number;
        private var __iFrameId:int = 0;

        public function FlEngine()
        {
            __eOnInitialized = new HelpSignal();
            __eOnFailed = new HelpSignal();
            __eOnPreUpdate = new HelpSignal();
            __eOnPostUpdate = new HelpSignal();
            __eOnCameraAdded = new HelpSignal();
            __eOnPreRender = new HelpSignal();
            __eOnPostRender = new HelpSignal();
            if (!__bInstantiable)
            {
                throw (new FError("FError: FlEngine is a singleton and cannot be instantiated directly use getInstance instead."));
            };
            __cInstance = this;
            aCameras = new Vector.<FCamera>();
            root = new FNode("root");
            cDefaultCamera = (FNodeFactory.createNodeWithComponent(FCamera) as FCamera);
            __nLastTime = getTimer();
        }

        public static function getInstance():FlEngine
        {
            __bInstantiable = true;
            if (__cInstance == null)
            {
                new (FlEngine)();
            };
            __bInstantiable = false;
            return (__cInstance);
        }

        public static function get frameId():int
        {
            if (!__cInstance)
            {
                return (0);
            };
            return (__cInstance.__iFrameId);
        }


        public function get onInitialized():HelpSignal
        {
            return (__eOnInitialized);
        }

        public function get onFailed():HelpSignal
        {
            return (__eOnFailed);
        }

        public function get onPreUpdate():HelpSignal
        {
            return (__eOnPreUpdate);
        }

        public function get onPostUpdate():HelpSignal
        {
            return (__eOnPostUpdate);
        }

        public function get onCameraAdded():HelpSignal
        {
            return (__eOnCameraAdded);
        }

        public function get onPreRender():HelpSignal
        {
            return (__eOnPreRender);
        }

        public function get onPostRender():HelpSignal
        {
            return (__eOnPostRender);
        }

        public function isInitialized():Boolean
        {
            return (__bInitialized);
        }

        public function get defaultCamera():FCamera
        {
            return (cDefaultCamera);
        }

        public function get config():FConfig
        {
            return (cConfig);
        }

        public function get context():FContext
        {
            return (cContext);
        }

        public function get driverInfo():String
        {
            if (!__bInitialized)
            {
                return ("FlEngine not initialized yet.");
            };
            return (cContext.cContext.driverInfo);
        }

        public function get stage():Stage
        {
            return (__stStage);
        }

        public function init(p_stage:Stage, p_config:FConfig):void
        {
            __stStage = p_stage;
            cConfig = p_config;
            if (cContext)
            {
                cContext.dispose();
            };
            cContext = new FContext(this);
            cContext.eInitialized.add(onContextInitialized);
            cContext.eFailed.add(onContextFailed);
            cContext.init(__stStage, cConfig.externalStage3D);
        }

        private function onContextFailed(value:Object):void
        {
            __eOnFailed.dispatch(null);
        }

        private function onContextInitialized(value:Object):void
        {
            __bInitialized = true;
            cDefaultCamera.invalidate();
            __stStage.addEventListener("enterFrame", onEnterFrame);
            onInitialized.dispatch(null);
        }

        private function onEnterFrame(event:Event):void
        {
            FStats.update();
            if (!autoUpdate)
            {
                return;
            };
            __iFrameId++;
            update();
            __iRenderFrameCount++;
            if (__iRenderFrameCount >= (cConfig.renderFrameSkip + 1))
            {
                __iRenderFrameCount = 0;
                beginRender();
                render();
                endRender();
            };
        }

        public function beginRender():void
        {
            cContext.begin(cConfig.backgroundRed, cConfig.backgroundGreen, cConfig.backgroundBlue);
        }

        public function endRender():void
        {
            cContext.end();
        }

        public function update():void
        {
            var _local1:Number = getTimer();
            nCurrentDeltaTime = ((paused) ? 0 : (_local1 - __nLastTime));
            if (((cConfig.enableFixedTimeStep) && (!(paused))))
            {
                nCurrentDeltaTime = cConfig.fixedTimeStep;
            };
            nCurrentDeltaTime = (nCurrentDeltaTime * cConfig.timeStepScale);
            __nLastTime = _local1;
            __eOnPreUpdate.dispatch(nCurrentDeltaTime);
            root.update(nCurrentDeltaTime, false, false);
            if (((!((physics == null))) && ((nCurrentDeltaTime > 0))))
            {
                physics.step(nCurrentDeltaTime);
            };
            __eOnPostUpdate.dispatch(nCurrentDeltaTime);
        }

        public function render():void
        {
            var _local1:int;
            __eOnPreRender.dispatch(null);
            if (aCameras.length == 0)
            {
                cDefaultCamera.invalidate();
                cDefaultCamera.render(cContext, null, null);
            }
            else
            {
                _local1 = 0;
                while (_local1 < aCameras.length)
                {
                    if (aCameras[_local1] != null)
                    {
                        aCameras[_local1].invalidate();
                        aCameras[_local1].render(cContext, null, null);
                    };
                    _local1++;
                };
            };
            __eOnPostRender.dispatch(null);
        }

        private function onMouseEvent(event:MouseEvent):void
        {
            var _local2:Boolean;
            var _local3:int;
            if (((cConfig.enableNativeContentMouseCapture) && (!((event.target == __stStage)))))
            {
                _local2 = true;
            };
            if (aCameras.length == 0)
            {
                cDefaultCamera.bCapturedThisFrame = false;
                cDefaultCamera.captureMouseEvent(_local2, event, new Vector3D((event.stageX - cConfig.viewRect.x), (event.stageY - cConfig.viewRect.y)));
            }
            else
            {
                _local3 = 0;
                while (_local3 < aCameras.length)
                {
                    aCameras[_local3].bCapturedThisFrame = false;
                    _local3++;
                };
                _local3 = (aCameras.length - 1);
                while (_local3 >= 0)
                {
                    if (aCameras.length > _local3)
                    {
                        _local2 = ((aCameras[_local3].captureMouseEvent(_local2, event, new Vector3D((event.stageX - cConfig.viewRect.x), (event.stageY - cConfig.viewRect.y)))) || (_local2));
                    };
                    _local3--;
                };
            };
        }

        private function onTouchEvent(event:TouchEvent):void
        {
        }

        public function getCameraAt(p_index:int):FCamera
        {
            if ((((p_index >= aCameras.length)) || ((p_index < 0))))
            {
                return (null);
            };
            return (aCameras[p_index]);
        }

        public function setCameraIndex(p_camera:FCamera, p_index:int):void
        {
            var _local3:int = aCameras.indexOf(p_camera);
            if (_local3 == -1)
            {
                throw (new FError("FError: Camera is not present inside render graph."));
            };
            if ((((p_index > aCameras.length)) || ((p_index < 0))))
            {
                throw (new FError("FError: Camera index is outside of valid index range."));
            };
            var _local4:FCamera = aCameras[p_index];
            aCameras[p_index] = p_camera;
            aCameras[_local3] = _local4;
        }

        public function getCameraIndex(p_camera:FCamera):int
        {
            var _local2:int;
            _local2 = 0;
            while (_local2 < aCameras.length)
            {
                if (aCameras[_local2] == p_camera)
                {
                    return (_local2);
                };
                _local2++;
            };
            return (-1);
        }

		fl2d function addCamera(p_camera:FCamera):void
        {
            if (aCameras.indexOf(p_camera) != -1)
            {
                return;
            };
            aCameras.push(p_camera);
            __eOnCameraAdded.dispatch(p_camera);
        }

        fl2d function removeCamera(p_camera:FCamera):void
        {
            var _local2:int = aCameras.indexOf(p_camera);
            if (_local2 != -1)
            {
                aCameras.splice(_local2, 1);
            };
        }


    }
}//package com.flengine.core

