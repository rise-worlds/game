// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.light.FLightMap

package com.flengine.components.light
{
    import com.flengine.components.renderables.FRenderable;
    import __AS3__.vec.Vector;
    import com.flengine.textures.FTexture;
    import com.flengine.context.filters.FBlurPassFilter;
    import com.flengine.core.FNode;
    import com.flengine.textures.factories.FTextureFactory;
    import com.flengine.components.FCamera;
    import com.flengine.core.FlEngine;
    import com.flengine.context.FContext;
    import flash.geom.Rectangle;
    import flash.display3D.Context3D;
    import com.flengine.components.renderables.FSprite;
    import com.flengine.components.renderables.FTexturedQuad;
    import com.flengine.components.renderables.FMovieClip;
    import flash.display3D.Context3DClearMask;

    public class FLightMap extends FRenderable 
    {

        private static var __iCount:int = 0;

        protected var _cLightMap:FTexture;
        protected var _cLightMapBlurred:FTexture;
        protected var _nLightMapScale:Number = 1;
        protected var _cBlurV:FBlurPassFilter;
        protected var _cBlurH:FBlurPassFilter;
        public var ambientRed:Number = 0;
        public var ambientGreen:Number = 0;
        public var ambientBlue:Number = 0;
        public var ambientAlpha:Number = 1;
        public var softShadows:Boolean = false;
        public var stencilOverdraw:Boolean = false;
        public var pad:int = 20;
        protected var _aLights:Vector.<FLight>;
        protected var _cCasterContainer:FNode;
        protected var _aSpotVertices:Vector.<Number>;

        public function FLightMap(p_node:FNode)
        {
            _aLights = new Vector.<FLight>();
            _aSpotVertices = new Vector.<Number>(6);
            super(p_node);
            __iCount = (__iCount + 1);
            _cLightMap = FTextureFactory.createRenderTexture(("lightMap_gen" + __iCount), (node.core.config.viewRect.width + pad), (node.core.config.viewRect.height + pad), false);
            _cLightMap.filteringType = 1;
            _cLightMapBlurred = FTextureFactory.createRenderTexture(("lightMapBlurred_gen" + __iCount), (node.core.config.viewRect.width + pad), (node.core.config.viewRect.height + pad), false);
            _cLightMapBlurred.filteringType = 1;
            _cBlurV = new FBlurPassFilter(4, 0);
            _cBlurH = new FBlurPassFilter(4, 1);
        }

        public function get lights():Vector.<FLight>
        {
            return (_aLights);
        }

        public function set casterContainer(p_value:FNode):void
        {
            _cCasterContainer = p_value;
        }

        public function addLight(p_light:FLight):void
        {
            _aLights.push(p_light);
        }

        public function removeLight(p_light:FLight):void
        {
            _aLights.splice(_aLights.indexOf(p_light), 1);
        }

        override public function render(p_context:FContext, p_camera:FCamera, p_maskRect:Rectangle):void
        {
            var _local7:int;
            var _local6 = null;
            p_context.setRenderTarget(_cLightMap, null, ambientRed, ambientGreen, ambientBlue, ambientAlpha);
            var _local5:FCamera = node.core.defaultCamera;
            _local5.aCameraVector[4] = p_camera.cNode.cTransform.nWorldX;
            _local5.aCameraVector[5] = p_camera.cNode.cTransform.nWorldY;
            var _local4:int = _aLights.length;
            _local7 = 0;
            while (_local7 < _local4)
            {
                _local6 = _aLights[_local7];
                if (!(((_local6.active == false)) || (!(_local6.node.isOnStage()))))
                {
                    if ((_local6 is FSpotLight))
                    {
                        drawSpotLight(p_context, (_local6 as FSpotLight));
                    }
                    else
                    {
                        drawOmniLight(p_context, _local6, p_camera.zoom);
                    };
                };
                _local7++;
            };
            if (softShadows)
            {
                p_context.setRenderTarget(_cLightMapBlurred, null, ambientRed, ambientGreen, ambientBlue, ambientAlpha);
                p_context.setCamera(FlEngine.getInstance().defaultCamera);
                p_context.draw(_cLightMap, ((_nLightMapScale * _cLightMap.width) * 0.5), ((_nLightMapScale * _cLightMap.height) * 0.5), 1, 1, 0, 1, 1, 1, 1, 1, null, _cBlurV);
                p_context.setRenderTarget(null);
                p_context.setCamera(p_camera);
                p_context.draw(_cLightMapBlurred, p_camera.cNode.cTransform.nWorldX, p_camera.cNode.cTransform.nWorldY, (1 / _nLightMapScale), (1 / _nLightMapScale), 0, 1, 1, 1, 1, 3, null, _cBlurH);
            }
            else
            {
                p_context.setRenderTarget(null);
                p_context.setCamera(p_camera);
                p_context.draw(_cLightMap, p_camera.cNode.cTransform.nWorldX, p_camera.cNode.cTransform.nWorldY, (1 / (p_camera.zoom * _nLightMapScale)), (1 / (p_camera.zoom * _nLightMapScale)), 0, 1, 1, 1, 1, 3);
            };
        }

        protected function drawOmniLight(p_context:FContext, p_light:FLight, p_zoom:Number):void
        {
            var _local10:Number;
            var _local6:Number;
            var _local7:Number;
            var _local4 = null;
            var _local5 = null;
            var _local11:Number = p_light.cNode.cTransform.nWorldX;
            var _local9:Number = p_light.cNode.cTransform.nWorldY;
            var _local8:Context3D = p_context.context;
            if (p_light.shadows)
            {
                p_context.push();
                _local8.setCulling("front");
                _local8.setStencilReferenceValue(1);
                _local8.setStencilActions("frontAndBack", "always", "set");
                _local8.setColorMask(false, false, false, false);
                _local4 = _cCasterContainer.firstChild;
                while (_local4)
                {
                    _local5 = (_local4.getComponent(FSprite) as FTexturedQuad);
                    if (_local5 == null)
                    {
                        (_local4.getComponent(FMovieClip) as FTexturedQuad);
                    };
                    if (_local5 != null)
                    {
                        _local6 = Math.abs((_local11 - _local4.cTransform.x));
                        _local7 = Math.abs((_local9 - _local4.cTransform.y));
                        if (((_local6 * _local6) + (_local7 * _local7)) < p_light.iRadiusSquared)
                        {
                            p_context.drawShadow((_local4.cTransform.nWorldX * _nLightMapScale), (_local4.cTransform.nWorldY * _nLightMapScale), ((_local5.getTexture().width * _nLightMapScale) * _local4.cTransform.nWorldScaleX), ((_local5.getTexture().height * _nLightMapScale) * _local4.cTransform.nWorldScaleY), _local4.transform.rotation, (_local11 * _nLightMapScale), (_local9 * _nLightMapScale), _local4.userData.shadowDepth);
                        };
                    };
                    _local4 = _local4.next;
                };
                p_context.push();
                if (stencilOverdraw)
                {
                    _local8.setCulling("back");
                    _local8.setStencilReferenceValue(0);
                    _local4 = _cCasterContainer.firstChild;
                    while (_local4)
                    {
                        _local5 = (_local4.getComponent(FSprite) as FTexturedQuad);
                        if (_local5 == null)
                        {
                            (_local4.getComponent(FMovieClip) as FTexturedQuad);
                        };
                        if (_local5 != null)
                        {
                            _local6 = Math.abs((_local11 - _local4.transform.x));
                            _local7 = Math.abs((_local9 - _local4.transform.y));
                            if (((_local6 * _local6) + (_local7 * _local7)) < p_light.iRadiusSquared)
                            {
                                p_context.drawColorQuad((_local4.cTransform.nWorldX * _nLightMapScale), (_local4.cTransform.nWorldY * _nLightMapScale), (_local5.getTexture().width * _nLightMapScale), (_local5.getTexture().height * _nLightMapScale), _local4.transform.rotation);
                            };
                        };
                        _local4 = _local4.next;
                    };
                    p_context.push();
                };
                _local8.setCulling("back");
                _local8.setStencilReferenceValue(0);
                _local8.setColorMask(true, true, true, true);
                _local8.setStencilActions("frontAndBack", "equal", "keep");
            };
            p_context.draw(p_light.getTexture(), (_local11 * _nLightMapScale), (_local9 * _nLightMapScale), (_nLightMapScale * p_light.cNode.cTransform.nWorldScaleX), (_nLightMapScale * p_light.cNode.cTransform.nWorldScaleY), p_light.cNode.cTransform.nWorldRotation, p_light.cNode.cTransform.nWorldRed, p_light.cNode.cTransform.nWorldGreen, p_light.cNode.cTransform.nWorldBlue, p_light.cNode.cTransform.nWorldAlpha, 2);
            if (p_light.shadows)
            {
                p_context.push();
                _local8.clear(0, 0, 0, 1, 1, 0, Context3DClearMask.STENCIL);
            };
        }

        protected function drawSpotLight(p_context:FContext, p_light:FSpotLight):void
        {
            var _local7:Number;
            var _local4:Number;
            var _local5:Number;
            var _local11:Number;
            var _local9 = null;
            var _local10 = null;
            var _local13:Number = p_light.cNode.cTransform.nWorldX;
            var _local12:Number = p_light.cNode.cTransform.nWorldY;
            var _local6:Context3D = p_context.context;
            _local6.clear(0, 0, 0, 1, 1, 1, Context3DClearMask.STENCIL);
            _local6.setCulling("front");
            _local6.setStencilReferenceValue(1);
            _local6.setStencilActions("frontAndBack", "always", "set");
            _local6.setColorMask(false, false, false, false);
            var _local8:int;
            var _local3:Number = p_light.dispersion;
            _aSpotVertices[0] = 0;
            _aSpotVertices[1] = 0;
            _aSpotVertices[2] = (Math.cos((_local8 + _local3)) * 1000);
            _aSpotVertices[3] = (Math.sin((_local8 + _local3)) * 1000);
            _aSpotVertices[4] = (Math.cos((_local8 - _local3)) * 1000);
            _aSpotVertices[5] = (Math.sin((_local8 - _local3)) * 1000);
            p_context.drawColorPoly(_aSpotVertices, (_local13 * _nLightMapScale), (_local12 * _nLightMapScale), 1, 1, (p_light.cNode.cTransform.nWorldRotation - 1.5707963267949));
            p_context.push();
            _local6.setStencilReferenceValue(0);
            _local9 = _cCasterContainer.firstChild;
            while (_local9)
            {
                _local10 = (_local9.getComponent(FSprite) as FTexturedQuad);
                if (_local10 == null)
                {
                    (_local9.getComponent(FMovieClip) as FTexturedQuad);
                };
                if (_local10 != null)
                {
                    _local7 = 10;
                    _local4 = Math.abs((_local13 - _local9.transform.x));
                    _local5 = Math.abs((_local12 - _local9.transform.y));
                    _local11 = _local9.userData.shadowPad;
                    if (((_local4 * _local4) + (_local5 * _local5)) < p_light.iRadiusSquared)
                    {
                        p_context.drawShadow((_local9.transform.x * _nLightMapScale), (_local9.transform.y * _nLightMapScale), (_local11 + ((_local10.getTexture().width * _nLightMapScale) * _local9.cTransform.nWorldScaleX)), (_local11 + ((_local10.getTexture().height * _nLightMapScale) * _local9.cTransform.nWorldScaleY)), _local9.transform.rotation, (_local13 * _nLightMapScale), (_local12 * _nLightMapScale), _local9.userData.shadowDepth);
                    };
                };
                _local9 = _local9.next;
            };
            p_context.push();
            if (stencilOverdraw)
            {
                _local6.setCulling("back");
                _local6.setStencilReferenceValue(1);
                _local9 = _cCasterContainer.firstChild;
                while (_local9)
                {
                    _local10 = (_local9.getComponent(FSprite) as FTexturedQuad);
                    if (_local10 == null)
                    {
                        (_local9.getComponent(FMovieClip) as FTexturedQuad);
                    };
                    if (_local10 != null)
                    {
                        _local4 = Math.abs((_local13 - _local9.transform.x));
                        _local5 = Math.abs((_local12 - _local9.transform.y));
                        if (((_local4 * _local4) + (_local5 * _local5)) < p_light.iRadiusSquared)
                        {
                            p_context.drawColorQuad((_local9.transform.x * _nLightMapScale), (_local9.transform.y * _nLightMapScale), (_local10.getTexture().width * _nLightMapScale), (_local10.getTexture().height * _nLightMapScale), _local9.transform.rotation);
                        };
                    };
                    _local9 = _local9.next;
                };
                p_context.push();
            };
            _local6.setCulling("back");
            _local6.setColorMask(true, true, true, true);
            _local6.setStencilReferenceValue(1);
            _local6.setStencilActions("frontAndBack", "equal", "keep");
            p_context.draw(p_light.getTexture(), (_local13 * _nLightMapScale), (_local12 * _nLightMapScale), (_nLightMapScale * p_light.cNode.cTransform.nWorldScaleX), (_nLightMapScale * p_light.cNode.cTransform.nWorldScaleY), p_light.cNode.cTransform.nWorldRotation, p_light.cNode.cTransform.nWorldRed, p_light.cNode.cTransform.nWorldGreen, p_light.cNode.cTransform.nWorldBlue, p_light.cNode.cTransform.nWorldAlpha, 2);
            p_context.push();
            _local6.setStencilReferenceValue(0);
            _local6.clear(0, 0, 0, 1, 1, 0, Context3DClearMask.STENCIL);
        }


    }
}//package com.flengine.components.light

