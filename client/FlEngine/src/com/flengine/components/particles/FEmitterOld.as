// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.particles.FEmitterOld

package com.flengine.components.particles
{
    import com.flengine.components.FComponent;
    import __AS3__.vec.Vector;
    import com.flengine.core.FNodePool;
    import com.flengine.components.particles.fields.FField;
    import com.flengine.core.FNode;
    import com.flengine.error.FError;

    public class FEmitterOld extends FComponent 
    {

        public var emit:Boolean = true;
        public var angle:Number = 0;
        public var uniformScale:Boolean = true;
        private var __nMinScaleX:Number = 1;
        private var __nMaxScaleX:Number = 1;
        private var __nMinScaleY:Number = 1;
        private var __nMaxScaleY:Number = 1;
        private var __nMinEnergy:Number = 1;
        private var __nMaxEnergy:Number = 1;
        private var __iMinEmission:Number = 1;
        private var __iMaxEmission:Number = 1;
        private var __nMinWorldVelocityX:Number = 0;
        private var __nMaxWorldVelocityX:Number = 0;
        private var __nMinWorldVelocityY:Number = 0;
        private var __nMaxWorldVelocityY:Number = 0;
        private var __nMinLocalVelocityX:Number = 0;
        private var __nMaxLocalVelocityX:Number = 0;
        private var __nMinLocalVelocityY:Number = 0;
        private var __nMaxLocalVelocityY:Number = 0;
        private var __nMinAngularVelocity:Number = 0;
        private var __nMaxAngularVelocity:Number = 0;
        public var initialParticleRed:Number = 1;
        public var initialParticleGreen:Number = 1;
        public var initialParticleBlue:Number = 1;
        public var initialParticleAlpha:Number = 1;
        public var endParticleRed:Number = 1;
        public var endParticleGreen:Number = 1;
        public var endParticleBlue:Number = 1;
        public var endParticleAlpha:Number = 1;
        public var initialDispersionX:Number = 0;
        public var initialDispersionY:Number = 0;
        public var initialAngle:Number = 0;
        public var burst:Boolean = false;
        public var useWorldSpace:Boolean = false;
        private var _aPreviousParticlePools:Array;
        protected var _xParticlePrototype:XML;
        protected var _nAccumulatedEmission:Number = 0;
        protected var _aParticles:Vector.<FParticleOld>;
        protected var _iActiveParticles:int = 0;
        protected var _cParticlePool:FNodePool;
        var iFieldsCount:int = 0;
        var aFields:Vector.<FField>;

        public function FEmitterOld(p_node:FNode)
        {
            _aPreviousParticlePools = [];
            _aParticles = new Vector.<FParticleOld>();
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

        public function set minScaleX(p_size:Number):void
        {
            __nMinScaleX = p_size;
            if (__nMaxScaleX < __nMinScaleX)
            {
                __nMaxScaleX = __nMinScaleX;
            };
        }

        public function get minScaleX():Number
        {
            return (__nMinScaleX);
        }

        public function set maxScaleX(p_size:Number):void
        {
            __nMaxScaleX = p_size;
            if (__nMinScaleX > __nMaxScaleX)
            {
                __nMinScaleX = __nMaxScaleX;
            };
        }

        public function get maxScaleX():Number
        {
            return (__nMaxScaleX);
        }

        public function set minScaleY(p_size:Number):void
        {
            __nMinScaleY = p_size;
            if (__nMaxScaleY < __nMinScaleY)
            {
                __nMaxScaleY = __nMinScaleY;
            };
        }

        public function get minScaleY():Number
        {
            return (__nMinScaleY);
        }

        public function set maxScaleY(p_size:Number):void
        {
            __nMaxScaleY = p_size;
            if (__nMinScaleY > __nMaxScaleY)
            {
                __nMinScaleY = __nMaxScaleY;
            };
        }

        public function get maxScaleY():Number
        {
            return (__nMaxScaleY);
        }

        public function set minEnergy(p_energy:Number):void
        {
            __nMinEnergy = p_energy;
            if (__nMaxEnergy < __nMinEnergy)
            {
                __nMaxEnergy = __nMinEnergy;
            };
        }

        public function get minEnergy():Number
        {
            return (__nMinEnergy);
        }

        public function set maxEnergy(p_energy:Number):void
        {
            __nMaxEnergy = p_energy;
            if (__nMinEnergy > __nMaxEnergy)
            {
                __nMinEnergy = __nMaxEnergy;
            };
        }

        public function get maxEnergy():Number
        {
            return (__nMaxEnergy);
        }

        public function set minEmission(p_emission:int):void
        {
            __iMinEmission = p_emission;
            if (__iMaxEmission < __iMinEmission)
            {
                __iMaxEmission = __iMinEmission;
            };
        }

        public function get minEmission():int
        {
            return (__iMinEmission);
        }

        public function set maxEmission(p_emission:int):void
        {
            __iMaxEmission = p_emission;
            if (__iMinEmission > __iMaxEmission)
            {
                __iMinEmission = __iMaxEmission;
            };
        }

        public function get maxEmission():int
        {
            return (__iMaxEmission);
        }

        public function set minWorldVelocityX(p_velocity:Number):void
        {
            __nMinWorldVelocityX = p_velocity;
            if (__nMaxWorldVelocityX < __nMinWorldVelocityX)
            {
                __nMaxWorldVelocityX = __nMinWorldVelocityX;
            };
        }

        public function get minWorldVelocityX():Number
        {
            return (__nMinWorldVelocityX);
        }

        public function set maxWorldVelocityX(p_velocity:Number):void
        {
            __nMaxWorldVelocityX = p_velocity;
            if (__nMinWorldVelocityX > __nMaxWorldVelocityX)
            {
                __nMinWorldVelocityX = __nMaxWorldVelocityX;
            };
        }

        public function get maxWorldVelocityX():Number
        {
            return (__nMaxWorldVelocityX);
        }

        public function set minWorldVelocityY(p_velocity:Number):void
        {
            __nMinWorldVelocityY = p_velocity;
            if (__nMaxWorldVelocityY < __nMinWorldVelocityY)
            {
                __nMaxWorldVelocityY = __nMinWorldVelocityY;
            };
        }

        public function get minWorldVelocityY():Number
        {
            return (__nMinWorldVelocityY);
        }

        public function set maxWorldVelocityY(p_velocity:Number):void
        {
            __nMaxWorldVelocityY = p_velocity;
            if (__nMinWorldVelocityY > __nMaxWorldVelocityY)
            {
                __nMinWorldVelocityY = __nMaxWorldVelocityY;
            };
        }

        public function get maxWorldVelocityY():Number
        {
            return (__nMaxWorldVelocityY);
        }

        public function set minLocalVelocityX(p_velocity:Number):void
        {
            __nMinLocalVelocityX = p_velocity;
            if (__nMaxLocalVelocityX < __nMinLocalVelocityX)
            {
                __nMaxLocalVelocityX = __nMinLocalVelocityX;
            };
        }

        public function get minLocalVelocityX():Number
        {
            return (__nMinLocalVelocityX);
        }

        public function set maxLocalVelocityX(p_velocity:Number):void
        {
            __nMaxLocalVelocityX = p_velocity;
            if (__nMinLocalVelocityX > __nMaxLocalVelocityX)
            {
                __nMinLocalVelocityX = __nMaxLocalVelocityX;
            };
        }

        public function get maxLocalVelocityX():Number
        {
            return (__nMaxLocalVelocityX);
        }

        public function set minLocalVelocityY(p_velocity:Number):void
        {
            __nMinLocalVelocityY = p_velocity;
            if (__nMaxLocalVelocityY < __nMinLocalVelocityY)
            {
                __nMaxLocalVelocityY = __nMinLocalVelocityY;
            };
        }

        public function get minLocalVelocityY():Number
        {
            return (__nMinLocalVelocityY);
        }

        public function set maxLocalVelocityY(p_velocity:Number):void
        {
            __nMaxLocalVelocityY = p_velocity;
            if (__nMinLocalVelocityY > __nMaxLocalVelocityY)
            {
                __nMinLocalVelocityY = __nMaxLocalVelocityY;
            };
        }

        public function get maxLocalVelocityY():Number
        {
            return (__nMaxLocalVelocityY);
        }

        public function set minAngularVelocity(p_velocity:Number):void
        {
            __nMinAngularVelocity = p_velocity;
            if (__nMaxAngularVelocity < __nMinLocalVelocityY)
            {
                __nMaxAngularVelocity = __nMinAngularVelocity;
            };
        }

        public function get minAngularVelocity():Number
        {
            return (__nMinAngularVelocity);
        }

        public function set maxAngularVelocity(p_velocity:Number):void
        {
            __nMaxAngularVelocity = p_velocity;
            if (__nMinAngularVelocity > __nMaxAngularVelocity)
            {
                __nMinAngularVelocity = __nMaxAngularVelocity;
            };
        }

        public function get maxAngularVelocity():Number
        {
            return (__nMaxAngularVelocity);
        }

        public function setParticlePrototype(p_xml:XML):void
        {
            _xParticlePrototype = p_xml;
        }

        public function get particlesCachedCount():int
        {
            return (_cParticlePool.cachedCount);
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
                        "time":(__nMaxEnergy * 1000)
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
            var _local1:int = (minEmission + ((maxEmission - minEmission) * Math.random()));
            _local2 = 0;
            while (_local2 < _local1)
            {
                activateParticle();
                emit = false;
                _local2++;
            };
        }

        override public function update(p_deltaTime:Number, p_parentTransformUpdate:Boolean, p_parentColorUpdate:Boolean):void
        {
            var _local4:int;
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
                _local4 = (minEmission + ((maxEmission - minEmission) * Math.random()));
                _nAccumulatedEmission = (_nAccumulatedEmission + ((_local4 * p_deltaTime) * 0.001));
                while (_nAccumulatedEmission > 0)
                {
                    activateParticle();
                    _nAccumulatedEmission = (_nAccumulatedEmission - 1);
                };
            };
        }

        private function activateParticle():void
        {
            var _local10:Number;
            var _local15:Number;
            var _local4:Number;
            var _local13:FNode = _cParticlePool.getNext();
            if (_local13 == null)
            {
                return;
            };
            var _local11:FParticleOld = (_local13.getComponent(FParticleOld) as FParticleOld);
            if (_local11 == null)
            {
                throw (new FError("FError: Cannot instantiate abstract class."));
            };
            var _local1:Number = (__nMinScaleX + ((__nMaxScaleX - __nMinScaleX) * Math.random()));
            var _local2:Number = ((uniformScale) ? _local1 : (__nMinScaleY + ((__nMaxScaleY - __nMinScaleY) * Math.random())));
            _local13.transform.useWorldSpace = useWorldSpace;
            if (useWorldSpace)
            {
                _local13.transform.x = ((cNode.transform.nWorldX + (Math.random() * initialDispersionX)) - (initialDispersionX * 0.5));
                _local13.transform.y = ((cNode.transform.nWorldY + (Math.random() * initialDispersionY)) - (initialDispersionY * 0.5));
            }
            else
            {
                _local13.transform.x = ((Math.random() * initialDispersionX) - (initialDispersionX * 0.5));
                _local13.transform.y = ((Math.random() * initialDispersionY) - (initialDispersionY * 0.5));
            };
            _local13.transform.scaleX = _local1;
            _local13.transform.scaleY = _local2;
            _local13.transform.rotation = (((initialAngle)>0) ? (initialAngle * Math.random()) : 0);
            var _local16:Number = Math.sin(cNode.transform.nWorldRotation);
            var _local3:Number = Math.cos(cNode.transform.nWorldRotation);
            var _local6:Number = (__nMinLocalVelocityX + (Math.random() * (__nMaxLocalVelocityX - __nMinLocalVelocityX)));
            var _local8:Number = (__nMinLocalVelocityY + (Math.random() * (__nMaxLocalVelocityY - __nMinLocalVelocityY)));
            var _local14:Number = (__nMinWorldVelocityX + (Math.random() * (__nMaxWorldVelocityX - __nMinWorldVelocityX)));
            var _local12:Number = (__nMinWorldVelocityY + (Math.random() * (__nMaxWorldVelocityY - __nMinWorldVelocityY)));
            _local10 = (_local14 + ((_local6 * _local3) - (_local8 * _local16)));
            var _local5 = _local10;
            _local15 = (_local12 + ((_local8 * _local3) + (_local6 * _local16)));
            var _local7 = _local15;
            if (angle != 0)
            {
                _local4 = ((Math.random() * angle) - (angle / 2));
                _local16 = Math.sin(_local4);
                _local3 = Math.cos(_local4);
                _local10 = ((_local5 * _local3) - (_local7 * _local16));
                _local15 = ((_local7 * _local3) + (_local5 * _local16));
            };
            var _local9:Number = (__nMinAngularVelocity + (Math.random() * (__nMaxAngularVelocity - __nMinAngularVelocity)));
            _local11.init(((__nMinEnergy + ((__nMaxEnergy - __nMinEnergy) * Math.random())) * 1000), (_local10 * 0.001), (_local15 * 0.001), _local9, initialParticleRed, initialParticleGreen, initialParticleBlue, initialParticleAlpha, endParticleRed, endParticleGreen, endParticleBlue, endParticleAlpha);
            cNode.addChild(_local13);
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
            iFieldsCount = (iFieldsCount + 1);
            aFields.push(p_field);
        }


    }
}//package com.flengine.components.particles

