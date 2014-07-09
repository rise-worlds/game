// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.particles.FEmitter

package com.flengine.components.particles
{
    import com.flengine.components.FComponent;
    import flash.display.BitmapData;
    import __AS3__.vec.Vector;
    import com.flengine.core.FNodePool;
    import com.flengine.components.particles.fields.FField;
    import com.flengine.core.FNode;
    import com.flengine.error.FError;

    public class FEmitter extends FComponent 
    {

        public var emit:Boolean = true;
        public var initialScale:Number = 1;
        public var initialScaleVariance:Number = 0;
        public var endScale:Number = 1;
        public var endScaleVariance:Number = 0;
        public var energy:Number = 1;
        public var energyVariance:Number = 0;
        public var emission:int = 1;
        public var emissionVariance:int = 0;
        public var emissionTime:Number = 1;
        public var emissionDelay:Number = 0;
        public var initialVelocity:Number = 0;
        public var initialVelocityVariance:Number = 0;
        public var initialAcceleration:Number = 0;
        public var initialAccelerationVariance:Number = 0;
        public var angularVelocity:Number = 0;
        public var angularVelocityVariance:Number = 0;
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
        public var useWorldSpace:Boolean = false;
        public var bitmapData:BitmapData;
        private var __aOffsets:Vector.<int>;
        private var _aPreviousParticlePools:Array;
        protected var _xParticlePrototype:XML;
        protected var _nAccumulatedTime:Number = 0;
        protected var _nAccumulatedEmission:Number = 0;
        protected var _aParticles:Vector.<FParticle>;
        protected var _iActiveParticles:int = 0;
        protected var _cParticlePool:FNodePool;
        var iFieldsCount:int = 0;
        var aFields:Vector.<FField>;

        public function FEmitter(p_node:FNode)
        {
            _aPreviousParticlePools = [];
            _aParticles = new Vector.<FParticle>();
            aFields = new Vector.<FField>();
            super(p_node);
        }

        override public function getPrototype():XML
        {
            _xPrototype = super.getPrototype();
            if (_xParticlePrototype != null)
            {
                _xPrototype.particlePrototype = <particlePrototype/>
				
                ;
                _xPrototype.particlePrototype.appendChild(_xParticlePrototype);
            };
            return (_xPrototype);
        }

        override public function bindFromPrototype(p_prototype:XML):void
        {
            super.bindFromPrototype(p_prototype);
            if (p_prototype.particlesPrototype != null)
            {
                setParticlePrototype(p_prototype.particlePrototype.node[0]);
            };
        }

        public function get initialColor():int
        {
            return ((((initialRed * 0xFF0000) + (initialGreen * 0xFF00)) + (initialBlue * 0xFF)));
        }

        public function set initialColor(p_value:int):void
        {
            initialRed = (((p_value >> 16) & 0xFF) / 0xFF);
            initialGreen = (((p_value >> 8) & 0xFF) / 0xFF);
            initialBlue = ((p_value & 0xFF) / 0xFF);
        }

        public function get endColor():int
        {
            return ((((endRed * 0xFF0000) + (endGreen * 0xFF00)) + (endBlue * 0xFF)));
        }

        public function set endColor(p_value:int):void
        {
            endRed = (((p_value >> 16) & 0xFF) / 0xFF);
            endGreen = (((p_value >> 8) & 0xFF) / 0xFF);
            endBlue = ((p_value & 0xFF) / 0xFF);
        }

        public function invalidateBitmapData():void
        {
            var _local3:int;
            __aOffsets = new Vector.<int>();
            var _local1:int = bitmapData.width;
            var _local2:Vector.<uint> = bitmapData.getVector(bitmapData.rect);
            _local3 = 0;
            while (_local3 < _local2.length)
            {
                if (((_local2[_local3] >> 24) & 0xFF) > 0)
                {
                    __aOffsets.push((_local3 % _local1), (_local3 / _local1));
                };
                _local3++;
            };
        }

        public function setParticlePrototype(p_xml:XML):void
        {
            _xParticlePrototype = p_xml;
        }

        public function get particlesCachedCount():int
        {
            if (_cParticlePool != null)
            {
                return (_cParticlePool.cachedCount);
            };
            return (0);
        }

        protected function setInitialParticlePosition(p_particleNode:FNode):void
        {
            if (useWorldSpace)
            {
                p_particleNode.cTransform.x = ((cNode.cTransform.nWorldX + (Math.random() * dispersionXVariance)) - (dispersionXVariance * 0.5));
                p_particleNode.cTransform.y = ((cNode.cTransform.nWorldY + (Math.random() * dispersionYVariance)) - (dispersionYVariance * 0.5));
            }
            else
            {
                p_particleNode.cTransform.x = ((Math.random() * dispersionXVariance) - (dispersionXVariance * 0.5));
                p_particleNode.cTransform.y = ((Math.random() * dispersionYVariance) - (dispersionYVariance * 0.5));
            };
        }

        protected function get initialParticleY():Number
        {
            return (((cNode.cTransform.nWorldY + (Math.random() * dispersionYVariance)) - (dispersionYVariance * 0.5)));
        }

        override public function set active(p_value:Boolean):void
        {
            super.active = p_value;
            if (_cParticlePool)
            {
                _cParticlePool.deactivate();
            };
        }

        public function init(p_maxCount:int=0, p_precacheCount:int=0, p_disposeImmediately:Boolean=true):void
        {
            _nAccumulatedTime = 0;
            _nAccumulatedEmission = 0;
            if (_cParticlePool)
            {
                if (p_disposeImmediately)
                {
                    _cParticlePool.dispose();
                }
                else
                {
                    _aPreviousParticlePools.push({
                        "pool":_cParticlePool,
                        "time":((energy + energyVariance) * 1000)
                    });
                };
            };
            _cParticlePool = new FNodePool(_xParticlePrototype, p_maxCount, p_precacheCount);
        }

        public function forceBurst():void
        {
            var _local2:int;
            if (!_cParticlePool)
            {
                return;
            };
            var _local1:int = (emission + (emissionVariance * Math.random()));
            _local2 = 0;
            while (_local2 < _local1)
            {
                activateParticle();
                _local2++;
            };
            emit = false;
        }

        override public function update(p_deltaTime:Number, p_parentTransformUpdate:Boolean, p_parentColorUpdate:Boolean):void
        {
            var _local4:Number;
            var _local5:int;
            if (_aPreviousParticlePools.length > 0)
            {
                _aPreviousParticlePools[0].time = (_aPreviousParticlePools[0].time - p_deltaTime);
                if (_aPreviousParticlePools[0].time <= 0)
                {
                    _aPreviousParticlePools[0].pool.dispose();
                    _aPreviousParticlePools.shift();
                };
            };
            if (((!(emit)) || ((_cParticlePool == null))))
            {
                return;
            };
            if (burst)
            {
                forceBurst();
            }
            else
            {
                _nAccumulatedTime = (_nAccumulatedTime + (p_deltaTime * 0.001));
                _local4 = (_nAccumulatedTime % (emissionTime + emissionDelay));
                if (_local4 <= emissionTime)
                {
                    _local5 = emission;
                    if (emissionVariance > 0)
                    {
                        _local5 = (_local5 + (emissionVariance * Math.random()));
                    };
                    _nAccumulatedEmission = (_nAccumulatedEmission + ((_local5 * p_deltaTime) * 0.001));
                    while (_nAccumulatedEmission > 0)
                    {
                        activateParticle();
                        _nAccumulatedEmission--;
                    };
                };
            };
        }

        private function activateParticle():void
        {
            var _local3:int;
            var _local2:FNode = _cParticlePool.getNext();
            if (_local2 == null)
            {
                return;
            };
            var _local1:FParticle = (_local2.getComponent(FParticle) as FParticle);
            if (_local1 == null)
            {
                throw (new FError("FError: Cannot instantiate abstract class."));
            };
            _local1.cEmitter = this;
            _local2.cTransform.useWorldSpace = useWorldSpace;
            if (useWorldSpace)
            {
                if (bitmapData)
                {
                    _local3 = ((((__aOffsets.length - 1) / 2) * Math.random()) * 2);
                    _local2.cTransform.x = ((cNode.cTransform.nWorldX - (bitmapData.width / 2)) + __aOffsets[_local3]);
                    _local2.cTransform.y = ((cNode.cTransform.nWorldY - (bitmapData.height / 2)) + __aOffsets[(_local3 + 1)]);
                }
                else
                {
                    setInitialParticlePosition(_local2);
                };
            }
            else
            {
                setInitialParticlePosition(_local2);
            };
            var _local4 = (initialScale + (initialScaleVariance * Math.random()));
            _local2.transform.scaleY = _local4;
            _local2.cTransform.scaleX = _local4;
            _local2.cTransform.rotation = (initialAngle + (Math.random() * initialAngleVariance));
            _local1.init();
            cNode.addChild(_local2);
        }

        override public function dispose():void
        {
            if (_cParticlePool != null)
            {
                _cParticlePool.dispose();
            };
            _cParticlePool = null;
            super.dispose();
        }

        public function clear(p_disposeCachedParticles:Boolean=false):void
        {
            if (_cParticlePool == null)
            {
                return;
            };
            if (p_disposeCachedParticles)
            {
                _cParticlePool.dispose();
            }
            else
            {
                _cParticlePool.deactivate();
            };
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

