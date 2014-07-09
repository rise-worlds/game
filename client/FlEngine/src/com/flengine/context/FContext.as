// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.FContext

package com.flengine.context
{
    import __AS3__.vec.Vector;
    import com.flengine.signals.HelpSignal;
    import flash.display3D.Context3D;
    import flash.geom.Matrix3D;
    import flash.display.Stage;
    import flash.display.Stage3D;
    import com.flengine.core.FlEngine;
    import com.flengine.context.materials.IGMaterial;
    import flash.geom.Rectangle;
    import com.flengine.textures.FTexture;
    import com.flengine.context.materials.FBlitColorVertexShaderBatchMaterial;
    import com.flengine.context.materials.FBlitTexturedVertexShaderBatchMaterial;
    import com.flengine.context.materials.FShadowMaterial;
    import com.flengine.context.materials.FDrawColorCameraVertexShaderBatchMaterial;
    import com.flengine.context.materials.FDrawColorCameraVertexBufferCPUBatchMaterial;
    import com.flengine.context.materials.FDrawTextureCameraVertexShaderBatchMaterial;
    import com.flengine.context.materials.FDrawTextureCameraVertexShaderBatchMaterial2;
    import com.flengine.context.materials.FDrawTextureCameraVertexBufferCPUBatchMaterial;
    import com.flengine.components.FCamera;
    import flash.events.ErrorEvent;
    import com.flengine.textures.FTextureBase;
    import flash.events.Event;
    import com.flengine.error.FError;
    import com.flengine.core.FStats;
    import com.flengine.context.filters.FFilter;
    import flash.geom.Matrix;
    import flash.display3D.Context3DClearMask;
    import flash.display.BitmapData;
	import com.flengine.fl2d;
	use namespace fl2d;

    public class FContext 
    {

        public static const NEAR:int = 0;
        public static const FAR:int = 100;

        fl2d var eInitialized:HelpSignal;
        fl2d var eFailed:HelpSignal;
        private var __bInitialized:Boolean = false;
        fl2d var bReinitialize:Boolean = false;
        fl2d var cContext:Context3D;
        private var __mProjectionMatrix:Matrix3D;
        private var __stStage:Stage;
        private var __st3Stage3D:Stage3D;
        private var __cCore:FlEngine;
        fl2d var cActiveMaterial:IGMaterial;
        fl2d var iActiveBlendMode:int;
        fl2d var bActivePremultiplied:Boolean;
        fl2d var rActiveMaskRect:Rectangle;
        protected var _cRenderTarget:FTexture;
        protected var _cBlitColorMaterial:FBlitColorVertexShaderBatchMaterial;
        protected var _cBlitMaterial:FBlitTexturedVertexShaderBatchMaterial;
        protected var _cShadowMaterial:FShadowMaterial;
        protected var _cDrawColorShaderMaterial:FDrawColorCameraVertexShaderBatchMaterial;
        protected var _cDrawColorBufferMaterial:FDrawColorCameraVertexBufferCPUBatchMaterial;
        protected var _cDrawTextureShaderMaterial:FDrawTextureCameraVertexShaderBatchMaterial;
        protected var _cDrawTextureShaderMaterial2:FDrawTextureCameraVertexShaderBatchMaterial2;
        protected var _cDrawTextureBufferCPUMaterial:FDrawTextureCameraVertexBufferCPUBatchMaterial;
        protected var _aBlitColorTransform:Vector.<Number>;
        protected var _aBlitTexturedTransform:Vector.<Number>;
        private var __cActiveCamera:FCamera;
        private var __iActiveStencilMaskLayer:int = 0;

        public function FContext(p_core:FlEngine)
        {
            eInitialized = new HelpSignal();
            eFailed = new HelpSignal();
            rActiveMaskRect = new Rectangle();
            _aBlitColorTransform = new <Number>[0, 0, 0, 0, 0, 0, 0, 0];
            _aBlitTexturedTransform = new <Number>[0, 0, 0, 0, 0, 0, 0, 0];
            super();
            __cCore = p_core;
        }

        public function get context():Context3D
        {
            return (cContext);
        }

        public function setCamera(p_camera:FCamera):void
        {
            if (__cActiveCamera == p_camera)
            {
                return;
            };
            if (cActiveMaterial != null)
            {
                cActiveMaterial.push();
                cActiveMaterial.clear();
                cActiveMaterial = null;
            };
            __cActiveCamera = p_camera;
        }

        fl2d function init(p_stage:Stage, p_stage3D:Stage3D=null):void
        {
            __stStage = p_stage;
            if (p_stage3D == null)
            {
                __st3Stage3D = __stStage.stage3Ds[0];
                __st3Stage3D.addEventListener("context3DCreate", onContextInitialized);
                __st3Stage3D.addEventListener("error", onContextError);
                initStage3D();
            }
            else
            {
                onContextInitialized(null);
            };
        }

        private function initStage3D():void
        {
            if (__st3Stage3D.requestContext3D.length == 1)
            {
                __st3Stage3D.requestContext3D(__cCore.cConfig.renderMode);
            }
            else
            {
                __st3Stage3D.requestContext3D(__cCore.cConfig.renderMode, __cCore.cConfig.profile);
            };
        }

        fl2d function dispose():void
        {
            eInitialized.dispose();
            eInitialized = null;
            eFailed.dispose();
            eFailed = null;
            __stStage.stage3Ds[0].removeEventListener("context3DCreate", onContextInitialized);
            __stStage.stage3Ds[0].removeEventListener("error", onContextError);
            cContext.dispose();
        }

        private function onContextError(event:ErrorEvent):void
        {
            eFailed.dispatch(event);
        }

        private function onContextInitialized(event:Event):void
        {
            var _local2 = null;
            if (__cCore.cConfig.externalStage3D == null)
            {
                _local2 = (event.target as Stage3D);
                cContext = _local2.context3D;
                cContext.enableErrorChecking = false;
            }
            else
            {
                cContext = __cCore.cConfig.externalStage3D.context3D;
            };
            invalidate();
            _cBlitColorMaterial = new FBlitColorVertexShaderBatchMaterial();
            _cBlitMaterial = new FBlitTexturedVertexShaderBatchMaterial();
            _cShadowMaterial = new FShadowMaterial();
            _cDrawColorShaderMaterial = new FDrawColorCameraVertexShaderBatchMaterial();
            _cDrawColorBufferMaterial = new FDrawColorCameraVertexBufferCPUBatchMaterial();
            _cDrawTextureShaderMaterial = new FDrawTextureCameraVertexShaderBatchMaterial();
            _cDrawTextureShaderMaterial2 = new FDrawTextureCameraVertexShaderBatchMaterial2();
            _cDrawTextureBufferCPUMaterial = new FDrawTextureCameraVertexBufferCPUBatchMaterial();
            FTextureBase.invalidate();
            if (!__bInitialized)
            {
                eInitialized.dispatch(null);
                __bInitialized = true;
            };
            bReinitialize = true;
        }

        private function getProjectionMatrix(p_width:int, p_height:int, p_transform:Matrix3D=null):Matrix3D
        {
            var _local4:Matrix3D = new Matrix3D(Vector.<Number>([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0.01, 0, 0, 0, 0, 1]));
            _local4.prependTranslation((-(p_width) / 2), (-(p_height) / 2), 0);
            _local4.appendScale((2 / p_width), (-2 / p_height), 1);
            if (p_transform)
            {
                _local4.prepend(p_transform);
            };
            return (_local4);
        }

        fl2d function invalidate():void
        {
            if (__cCore.cConfig.externalStage3D == null)
            {
                __st3Stage3D.x = __cCore.cConfig.viewRect.left;
                __st3Stage3D.y = __cCore.cConfig.viewRect.top;
                if (cContext == null)
                {
                    return;
                };
                try
                {
                    cContext.configureBackBuffer(__cCore.cConfig.viewRect.width, __cCore.cConfig.viewRect.height, __cCore.cConfig.antiAliasing, __cCore.cConfig.enableDepthAndStencil);
                }
                catch(e:Error)
                {
                    throw (new FError("FError: Cannot initialize Context3D."));
                };
            };
            __cCore.cDefaultCamera.node.cTransform.x = (__cCore.cConfig.viewRect.width / 2);
            __cCore.cDefaultCamera.node.cTransform.y = (__cCore.cConfig.viewRect.height / 2);
            __mProjectionMatrix = getProjectionMatrix(__cCore.cConfig.viewRect.width, __cCore.cConfig.viewRect.height);
        }

        fl2d function createTexture(p_width:int, p_height:int, p_format:String, p_optimizeForRenderToTexture:Boolean):FContextTexture
        {
            return (new FContextTexture(cContext, p_width, p_height, p_format, p_optimizeForRenderToTexture));
        }

        fl2d function begin(p_red:Number, p_green:Number, p_blue:Number):void
        {
            FStats.clear();
            _cRenderTarget = null;
            cActiveMaterial = null;
            bActivePremultiplied = true;
            iActiveBlendMode = 0;
            __cActiveCamera = __cCore.cDefaultCamera;
            if (__cCore.cConfig.externalStage3D == null)
            {
                cContext.clear(p_red, p_green, p_blue, 1);
            };
            cContext.setDepthTest(false, "always");
            cContext.setStencilActions("frontAndBack", "always", "keep", "keep", "keep");
            FBlendMode.setBlendMode(cContext, 0, bActivePremultiplied);
            cContext.setProgramConstantsFromMatrix("vertex", 0, __mProjectionMatrix, true);
        }

        fl2d function end():void
        {
            if (__cCore.cConfig.enableStats)
            {
                FStats.draw();
            };
            if (cActiveMaterial)
            {
                cActiveMaterial.push();
                cActiveMaterial.clear();
            };
            if (__cCore.cConfig.externalStage3D == null)
            {
                cContext.present();
            };
            bReinitialize = false;
        }

        public function blitColor(p_x:Number, p_y:Number, p_width:Number, p_height:Number, p_red:Number, p_green:Number, p_blue:Number, p_alpha:Number, p_blendMode:int, p_maskRect:Rectangle):void
        {
            var _local12 = !((_cBlitColorMaterial == cActiveMaterial));
            var _local11 = !((p_blendMode == iActiveBlendMode));
            var _local13 = !(rActiveMaskRect.equals(p_maskRect));
            if (_cBlitColorMaterial != cActiveMaterial)
            {
                if (cActiveMaterial != null)
                {
                    cActiveMaterial.push();
                    cActiveMaterial.clear();
                };
                if (_local12)
                {
                    cActiveMaterial = _cBlitColorMaterial;
                    _cBlitColorMaterial.bind(cContext, bReinitialize);
                };
                if (_local11)
                {
                    iActiveBlendMode = p_blendMode;
                    FBlendMode.setBlendMode(cContext, iActiveBlendMode, bActivePremultiplied);
                };
                if (_local13)
                {
                    rActiveMaskRect.setTo(p_maskRect.x, p_maskRect.y, p_maskRect.width, p_maskRect.height);
                    cContext.setScissorRectangle(rActiveMaskRect);
                };
            };
            _aBlitColorTransform[0] = p_x;
            _aBlitColorTransform[1] = p_y;
            _aBlitColorTransform[2] = p_width;
            _aBlitColorTransform[3] = p_height;
            _aBlitColorTransform[4] = p_red;
            _aBlitColorTransform[5] = p_green;
            _aBlitColorTransform[6] = p_blue;
            _aBlitColorTransform[7] = p_alpha;
            _cBlitColorMaterial.draw(_aBlitColorTransform);
        }

        public function blit(p_texture:FTexture, p_x:Number, p_y:Number, p_scaleX:Number=1, p_scaleY:Number=1, p_blendMode:int=1, p_maskRect:Rectangle=null):void
        {
            var _local9 = null;
            var _local10 = !((_cBlitMaterial == cActiveMaterial));
            var _local8:Boolean = ((!((p_blendMode == iActiveBlendMode))) || (!((p_texture.premultiplied == bActivePremultiplied))));
            if (((_local10) || (_local8)))
            {
                if (cActiveMaterial != null)
                {
                    cActiveMaterial.push();
                    if (_local10)
                    {
                        cActiveMaterial.clear();
                    };
                };
                if (_local10)
                {
                    cActiveMaterial = _cBlitMaterial;
                    _cBlitMaterial.bind(cContext, bReinitialize);
                    if (!rActiveMaskRect.equals(__cCore.cDefaultCamera.rViewRectangle))
                    {
                        _local9 = __cCore.cDefaultCamera.rViewRectangle;
                        rActiveMaskRect.setTo(_local9.x, _local9.y, _local9.width, _local9.height);
                        cContext.setScissorRectangle(rActiveMaskRect);
                    };
                };
                if (_local8)
                {
                    iActiveBlendMode = p_blendMode;
                    bActivePremultiplied = p_texture.premultiplied;
                    FBlendMode.setBlendMode(cContext, iActiveBlendMode, bActivePremultiplied);
                };
            };
            _cBlitMaterial.draw(p_x, p_y, p_scaleX, p_scaleY, p_texture);
        }

        public function drawShadow(p_x:Number, p_y:Number, p_scaleX:Number, p_scaleY:Number, p_rotation:Number, p_lightX:Number, p_lightY:Number, p_depth:Number=1, p_maskRect:Rectangle=null):void
        {
            if (p_maskRect == null)
            {
                p_maskRect = __cActiveCamera.rViewRectangle;
            };
            if (checkAndSetupRender(_cShadowMaterial, iActiveBlendMode, bActivePremultiplied, p_maskRect))
            {
                _cShadowMaterial.bind(cContext, bReinitialize, __cActiveCamera);
            };
            _cShadowMaterial.draw(p_x, p_y, p_scaleX, p_scaleY, p_rotation, p_lightX, p_lightY, p_depth);
        }

        public function drawLine(p_x1:Number, p_y1:Number, p_x2:Number, p_y2:Number, p_thin:Number=1, p_red:Number=1, p_green:Number=1, p_blue:Number=1, p_alpha:Number=1, p_blendMode:int=1, p_maskRect:Rectangle=null):void
        {
            if (p_maskRect == null)
            {
                p_maskRect = __cActiveCamera.rViewRectangle;
            };
            if (checkAndSetupRender(_cDrawColorShaderMaterial, p_blendMode, bActivePremultiplied, p_maskRect))
            {
                _cDrawColorShaderMaterial.bind(cContext, bReinitialize, __cActiveCamera);
            };
            var _local16:Number = ((p_x1 + p_x2) * 0.5);
            var _local15:Number = ((p_y1 + p_y2) * 0.5);
            var _local13:Number = Math.sqrt((((p_x1 - p_x2) * (p_x1 - p_x2)) + ((p_y1 - p_y2) * (p_y1 - p_y2))));
            var _local14:Number = ((p_x2 - p_x1) / _local13);
            var _local12 = 0;
            if (_local13 > 0.001)
            {
                if (p_y1 < p_y2)
                {
                    _local12 = (Math.acos(_local14) + 3.14159265358979);
                }
                else
                {
                    _local12 = Math.acos(-(_local14));
                };
            };
            _cDrawColorShaderMaterial.draw(_local16, _local15, _local13, p_thin, _local12, p_red, p_green, p_blue, p_alpha);
        }

        public function drawColorQuad(p_x:Number, p_y:Number, p_width:Number=1, p_height:Number=1, p_rotation:Number=0, p_red:Number=1, p_green:Number=1, p_blue:Number=1, p_alpha:Number=1, p_blendMode:int=1, p_maskRect:Rectangle=null):void
        {
            if (p_maskRect == null)
            {
                p_maskRect = __cActiveCamera.rViewRectangle;
            };
            if (checkAndSetupRender(_cDrawColorShaderMaterial, p_blendMode, bActivePremultiplied, p_maskRect))
            {
                _cDrawColorShaderMaterial.bind(cContext, bReinitialize, __cActiveCamera);
            };
            _cDrawColorShaderMaterial.draw(p_x, p_y, p_width, p_height, p_rotation, p_red, p_green, p_blue, p_alpha);
        }

        public function drawColorPoly(p_vertices:Vector.<Number>, p_x:Number, p_y:Number, p_scaleX:Number=1, p_scaleY:Number=1, p_rotation:Number=0, p_red:Number=1, p_green:Number=1, p_blue:Number=1, p_alpha:Number=1, p_blendMode:int=1, p_maskRect:Rectangle=null):void
        {
            if (p_maskRect == null)
            {
                p_maskRect = __cActiveCamera.rViewRectangle;
            };
            if (checkAndSetupRender(_cDrawColorBufferMaterial, p_blendMode, bActivePremultiplied, p_maskRect))
            {
                _cDrawColorBufferMaterial.bind(cContext, bReinitialize, __cActiveCamera);
            };
            _cDrawColorBufferMaterial.drawPoly(p_vertices, p_x, p_y, p_scaleX, p_scaleY, p_rotation, p_red, p_green, p_blue, p_alpha);
        }

        public function draw(p_texture:FTexture, p_x:Number, p_y:Number, p_scaleX:Number=1, p_scaleY:Number=1, p_rotation:Number=0, p_red:Number=1, p_green:Number=1, p_blue:Number=1, p_alpha:Number=1, p_blendMode:int=1, p_maskRect:Rectangle=null, p_filter:FFilter=null):void
        {
            if ((((p_alpha == 0)) || ((p_texture == null))))
            {
                return;
            };
            if (p_maskRect == null)
            {
                p_maskRect = __cActiveCamera.rViewRectangle;
            };
            if (checkAndSetupRender(_cDrawTextureShaderMaterial, p_blendMode, p_texture.premultiplied, p_maskRect))
            {
                _cDrawTextureShaderMaterial.bind(cContext, bReinitialize, __cActiveCamera);
            };
            _cDrawTextureShaderMaterial.draw(p_x, p_y, p_scaleX, p_scaleY, p_rotation, p_red, p_green, p_blue, p_alpha, p_texture, p_filter);
        }

        public function draw2(p_texture:FTexture, p_matrix:Matrix, p_red:Number=1, p_green:Number=1, p_blue:Number=1, p_alpha:Number=1, p_blendMode:int=1, p_maskRect:Rectangle=null, p_filter:FFilter=null):void
        {
            if (p_alpha == 0)
            {
                return;
            };
            if (p_maskRect == null)
            {
                p_maskRect = __cActiveCamera.rViewRectangle;
            };
            if (checkAndSetupRender(_cDrawTextureBufferCPUMaterial, p_blendMode, p_texture.premultiplied, p_maskRect))
            {
                _cDrawTextureBufferCPUMaterial.bind(cContext, bReinitialize, __cActiveCamera);
            };
            _cDrawTextureBufferCPUMaterial.drawMatrix(p_matrix, p_red, p_green, p_blue, p_alpha, p_texture, p_filter);
        }

        public function draw3(p_texture:FTexture, p_matrix:Matrix, p_red:Number=1, p_green:Number=1, p_blue:Number=1, p_alpha:Number=1, p_blendMode:int=1, p_maskRect:Rectangle=null, p_filter:FFilter=null):void
        {
            if ((((p_alpha == 0)) || ((p_texture == null))))
            {
                return;
            };
            if (p_maskRect == null)
            {
                p_maskRect = __cActiveCamera.rViewRectangle;
            };
            if (checkAndSetupRender(_cDrawTextureShaderMaterial2, p_blendMode, p_texture.premultiplied, p_maskRect))
            {
                _cDrawTextureShaderMaterial2.bind(cContext, bReinitialize, __cActiveCamera);
            };
            _cDrawTextureShaderMaterial2.draw(p_matrix, p_red, p_green, p_blue, p_alpha, p_texture, p_filter);
        }

        public function drawPoly(p_texture:FTexture, p_vertices:Vector.<Number>, p_uvs:Vector.<Number>, p_x:Number, p_y:Number, p_scaleX:Number, p_scaleY:Number, p_rotation:Number, p_red:Number=1, p_green:Number=1, p_blue:Number=1, p_alpha:Number=1, p_blendMode:int=1, p_maskRect:Rectangle=null, p_filter:FFilter=null):void
        {
            if (p_alpha == 0)
            {
                return;
            };
            if (p_maskRect == null)
            {
                p_maskRect = __cActiveCamera.rViewRectangle;
            };
            if (checkAndSetupRender(_cDrawTextureBufferCPUMaterial, p_blendMode, p_texture.premultiplied, p_maskRect))
            {
                _cDrawTextureBufferCPUMaterial.bind(cContext, bReinitialize, __cActiveCamera);
            };
            _cDrawTextureBufferCPUMaterial.drawPoly(p_vertices, p_uvs, p_x, p_y, p_scaleX, p_scaleY, p_rotation, p_red, p_green, p_blue, p_alpha, p_texture, p_filter);
        }

        fl2d function checkAndSetupRender(p_material:IGMaterial, p_blendMode:int, p_premultiplied:Boolean, p_maskRect:Rectangle):Boolean
        {
            var _local7:Boolean = ((!((p_material == cActiveMaterial))) || ((cActiveMaterial == null)));
            var _local5:Boolean = ((!((p_blendMode == iActiveBlendMode))) || (!((p_premultiplied == bActivePremultiplied))));
            var _local6 = !(rActiveMaskRect.equals(p_maskRect));
            if (((((_local7) || (_local5))) || (_local6)))
            {
                if (cActiveMaterial != null)
                {
                    cActiveMaterial.push();
                    if (_local7)
                    {
                        cActiveMaterial.clear();
                    };
                };
                if (_local7)
                {
                    cActiveMaterial = p_material;
                };
                if (_local5)
                {
                    iActiveBlendMode = p_blendMode;
                    bActivePremultiplied = p_premultiplied;
                    FBlendMode.setBlendMode(cContext, iActiveBlendMode, bActivePremultiplied);
                };
                if (_local6)
                {
                    rActiveMaskRect.setTo(p_maskRect.x, p_maskRect.y, p_maskRect.width, p_maskRect.height);
                    cContext.setScissorRectangle(rActiveMaskRect);
                };
            };
            return (_local7);
        }

        public function push():void
        {
            if (cActiveMaterial != null)
            {
                cActiveMaterial.push();
            };
        }

        fl2d function clearStencil():void
        {
            if (cActiveMaterial)
            {
                cActiveMaterial.push();
            };
            cContext.clear(0, 0, 0, 0, 0, 0, Context3DClearMask.STENCIL);
        }

        fl2d function renderAsStencilMask(p_maskLayer:int):void
        {
            if (cActiveMaterial)
            {
                cActiveMaterial.push();
            };
            __iActiveStencilMaskLayer = p_maskLayer;
            cContext.setStencilReferenceValue(__iActiveStencilMaskLayer);
            cContext.setStencilActions("frontAndBack", "greaterEqual", "incrementSaturate");
            cContext.setColorMask(false, false, false, false);
        }

        fl2d function renderToColor(p_stencilLayer:int):void
        {
            if (cActiveMaterial)
            {
                cActiveMaterial.push();
            };
            __iActiveStencilMaskLayer = p_stencilLayer;
            cContext.setStencilReferenceValue(__iActiveStencilMaskLayer);
            cContext.setStencilActions("frontAndBack", "lessEqual", "keep");
            cContext.setColorMask(true, true, true, true);
        }

        public function setRenderTarget(p_texture:FTexture=null, p_transform:Matrix3D=null, p_red:Number=0, p_green:Number=0, p_blue:Number=0, p_alpha:Number=0):void
        {
            if (_cRenderTarget == p_texture)
            {
                return;
            };
            if (cActiveMaterial != null)
            {
                cActiveMaterial.push();
            };
            if (p_texture == null)
            {
                cContext.setRenderToBackBuffer();
                cContext.setProgramConstantsFromMatrix("vertex", 0, ((p_transform) ? getProjectionMatrix(__cCore.cConfig.viewRect.width, __cCore.cConfig.viewRect.height, p_transform) : __mProjectionMatrix), true);
            }
            else
            {
                cContext.setRenderToTexture(p_texture.cContextTexture.tTexture, __cCore.cConfig.enableDepthAndStencil, __cCore.cConfig.antiAliasing);
                cContext.clear(p_red, p_green, p_blue, p_alpha);
                cContext.setProgramConstantsFromMatrix("vertex", 0, getProjectionMatrix(p_texture.gpuWidth, p_texture.gpuHeight, p_transform), true);
            };
            _cRenderTarget = p_texture;
        }

        public function getRenderTarget():FTexture
        {
            return (_cRenderTarget);
        }

        public function drawToBitmapData(p_bitmapData:BitmapData):void
        {
            if (cActiveMaterial)
            {
                cActiveMaterial.push();
            };
            cContext.drawToBitmapData(p_bitmapData);
        }


    }
}//package com.flengine.context

