// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.particles.FSimpleEmitter

package com.flengine.components.particles
{
    import com.flengine.components.renderables.FRenderable;
    import com.flengine.textures.FTexture;
    import __AS3__.vec.Vector;
    import com.flengine.components.particles.fields.FField;
    import com.flengine.core.FNode;
    import com.flengine.context.FContext;
    import com.flengine.components.FCamera;
    import flash.geom.Rectangle;

    public class FSimpleEmitter extends FRenderable 
    {

        public var emit:Boolean = false;
        public var initialScale:Number = 1;
        public var initialScaleVariance:Number = 0;
        public var endScale:Number = 1;
        public var endScaleVariance:Number = 0;
        public var energy:Number = 0;
        public var energyVariance:Number = 0;
        public var emission:int = 1;
        public var emissionVariance:int = 0;
        public var emissionTime:Number = 1;
        public var emissionDelay:Number = 0;
        public var initialVelocity:Number = 0;
        public var initialVelocityVariance:Number = 0;
        public var initialAcceleration:Number = 0;
        public var initialAccelerationVariance:Number = 0;
        public var initialAngularVelocity:Number = 0;
        public var initialAngularVelocityVariance:Number = 0;
        public var initialRed:Number = 1;
        public var initialRedVariance:Number = 0;
        public var initialGreen:Number = 1;
        public var initialGreenVariance:Number = 0;
        public var initialBlue:Number = 1;
        public var initialBlueVariance:Number = 0;
        public var initialAlpha:Number = 1;
        public var initialAlphaVariance:Number = 0;
        public var endRed:Number = 1;
        public var endRedVariance:Number = 0;
        public var endGreen:Number = 1;
        public var endGreenVariance:Number = 0;
        public var endBlue:Number = 1;
        public var endBlueVariance:Number = 0;
        public var endAlpha:Number = 1;
        public var endAlphaVariance:Number = 0;
        public var dispersionXVariance:Number = 0;
        public var dispersionYVariance:Number = 0;
        public var dispersionAngle:Number = 0;
        public var dispersionAngleVariance:Number = 0;
        public var initialAngle:Number = 0;
        public var initialAngleVariance:Number = 0;
        public var burst:Boolean = false;
        public var special:Boolean = false;
        protected var _nAccumulatedTime:Number = 0;
        protected var _nAccumulatedEmission:Number = 0;
        protected var _cFirstParticle:FSimpleParticle;
        protected var _cLastParticle:FSimpleParticle;
        protected var _iActiveParticles:int = 0;
        private var __nLastUpdateTime:Number;
        private var __cTexture:FTexture;
        var iFieldsCount:int = 0;
        var aFields:Vector.<FField>;

        public function FSimpleEmitter(p_node:FNode)
        {
            aFields = new Vector.<FField>();
            super(p_node);
        }

        override public function bindFromPrototype(p_prototype:XML):void
        {
            super.bindFromPrototype(p_prototype);
        }

        public function get initialColor():int
        {
            var _local1:uint = ((initialRed * 0xFF) << 16);
            var _local3:uint = ((initialGreen * 0xFF) << 8);
            var _local2:uint = (initialBlue * 0xFF);
            return (((_local1 + _local3) + _local2));
        }

        public function set initialColor(p_value:int):void
        {
            initialRed = (((p_value >> 16) & 0xFF) / 0xFF);
            initialGreen = (((p_value >> 8) & 0xFF) / 0xFF);
            initialBlue = ((p_value & 0xFF) / 0xFF);
        }

        public function get endColor():int
        {
            var _local1:uint = ((endRed * 0xFF) << 16);
            var _local3:uint = ((endGreen * 0xFF) << 8);
            var _local2:uint = (endBlue * 0xFF);
            return (((_local1 + _local3) + _local2));
        }

        public function set endColor(p_value:int):void
        {
            endRed = (((p_value >> 16) & 0xFF) / 0xFF);
            endGreen = (((p_value >> 8) & 0xFF) / 0xFF);
            endBlue = ((p_value & 0xFF) / 0xFF);
        }

        public function get textureId():String
        {
            return (((__cTexture) ? __cTexture.id : ""));
        }

        public function set textureId(p_value:String):void
        {
            __cTexture = FTexture.getTextureById(p_value);
        }

        public function setTexture(p_texture:FTexture):void
        {
            __cTexture = p_texture;
        }

        protected function setInitialParticlePosition(p_particle:FSimpleParticle):void
        {
            var _local2:Number;
            p_particle.nX = cNode.cTransform.nWorldX;
            if (dispersionXVariance > 0)
            {
                p_particle.nX = (p_particle.nX + ((dispersionXVariance * Math.random()) - (dispersionXVariance * 0.5)));
            };
            p_particle.nY = cNode.cTransform.nWorldY;
            if (dispersionYVariance > 0)
            {
                p_particle.nY = (p_particle.nY + ((dispersionYVariance * Math.random()) - (dispersionYVariance * 0.5)));
            };
            p_particle.nRotation = initialAngle;
            if (initialAngleVariance > 0)
            {
                p_particle.nRotation = (p_particle.nRotation + (initialAngleVariance * Math.random()));
            };
            var _local3 = initialScale;
            p_particle.nScaleY = _local3;
            p_particle.nScaleX = _local3;
            if (initialScaleVariance > 0)
            {
                _local2 = (initialScaleVariance * Math.random());
                p_particle.nScaleX = (p_particle.nScaleX + _local2);
                p_particle.nScaleY = (p_particle.nScaleY + _local2);
            };
        }

        public function init(p_maxCount:int=0, p_precacheCount:int=0, p_disposeImmediately:Boolean=true):void
        {
            _nAccumulatedTime = 0;
            _nAccumulatedEmission = 0;
        }

        private function createParticle():FSimpleParticle
        {
            var _local1:FSimpleParticle = FSimpleParticle.get();
            if (_cFirstParticle)
            {
                _local1.cNext = _cFirstParticle;
                _cFirstParticle.cPrevious = _local1;
                _cFirstParticle = _local1;
            }
            else
            {
                _cFirstParticle = _local1;
                _cLastParticle = _local1;
            };
            return (_local1);
        }

        public function forceBurst():void
        {
            var _local1:int;
            var _local2:int = (emission + (emissionVariance * Math.random()));
            _local1 = 0;
            while (_local1 < _local2)
            {
                activateParticle();
                _local1++;
            };
            emit = false;
        }

        override public function update(p_deltaTime:Number, p_parentTransformUpdate:Boolean, p_parentColorUpdate:Boolean):void
        {
            var _local5:Number;
            var _local6:int;
            var _local4 = null;
            var _local7 = null;
            __nLastUpdateTime = p_deltaTime;
            if (emit)
            {
                if (burst)
                {
                    forceBurst();
                }
                else
                {
                    _nAccumulatedTime = (_nAccumulatedTime + (p_deltaTime * 0.001));
                    _local5 = (_nAccumulatedTime % (emissionTime + emissionDelay));
                    if (_local5 <= emissionTime)
                    {
                        _local6 = emission;
                        if (emissionVariance > 0)
                        {
                            _local6 = (_local6 + (emissionVariance * Math.random()));
                        };
                        _nAccumulatedEmission = (_nAccumulatedEmission + ((_local6 * p_deltaTime) * 0.001));
                        while (_nAccumulatedEmission > 0)
                        {
                            activateParticle();
                            _nAccumulatedEmission--;
                        };
                    };
                };
            };
            _local4 = _cFirstParticle;
            while (_local4)
            {
                _local7 = _local4.cNext;
                _local4.update(this, __nLastUpdateTime);
                _local4 = _local7;
            };
        }

        override public function render(p_context:FContext, p_camera:FCamera, p_maskRect:Rectangle):void
        {
            var _local6 = null;
            var _local7 = null;
            var _local5:Number;
            var _local4:Number;
            if (__cTexture == null)
            {
                return;
            };
            var _local8:int;
            _local6 = _cFirstParticle;
            while (_local6)
            {
                _local7 = _local6.cNext;
                _local5 = (cNode.cTransform.nWorldX + ((_local6.nX - cNode.cTransform.nWorldX) * 1));
                _local4 = (cNode.cTransform.nWorldY + ((_local6.nY - cNode.cTransform.nWorldY) * 1));
                p_context.draw(__cTexture, _local5, _local4, (_local6.nScaleX * cNode.cTransform.nWorldScaleX), (_local6.nScaleY * cNode.cTransform.nWorldScaleY), _local6.nRotation, _local6.nRed, _local6.nGreen, _local6.nBlue, _local6.nAlpha, iBlendMode, p_maskRect);
                _local6 = _local7;
            };
        }

        private function activateParticle():void
        {
            var _local1:FSimpleParticle = createParticle();
            setInitialParticlePosition(_local1);
            _local1.init(this);
        }

        function deactivateParticle(p_particle:FSimpleParticle):void
        {
            if (p_particle == _cLastParticle)
            {
                _cLastParticle = _cLastParticle.cPrevious;
            };
            if (p_particle == _cFirstParticle)
            {
                _cFirstParticle = _cFirstParticle.cNext;
            };
            p_particle.dispose();
        }

        override public function dispose():void
        {
            super.dispose();
        }

        public function clear(p_disposeCachedParticles:Boolean=false):void
        {
        }

        public function addField(p_field:FField):void
        {
            if (p_field == null)
            {
                throw (new Error("Field cannot be null."));
            };
            iFieldsCount++;
            aFields.push(p_field);
        }


    }
}//package com.flengine.components.particles

