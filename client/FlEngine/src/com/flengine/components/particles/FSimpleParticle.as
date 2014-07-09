// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.particles.FSimpleParticle

package com.flengine.components.particles
{
    public class FSimpleParticle 
    {

        private static var availableInstance:FSimpleParticle;
        private static var count:int = 0;

        var cNext:FSimpleParticle;
        var cPrevious:FSimpleParticle;
        var nX:Number;
        var nY:Number;
        var nRotation:Number;
        var nScaleX:Number;
        var nScaleY:Number;
        var nRed:Number;
        var nGreen:Number;
        var nBlue:Number;
        var nAlpha:Number;
        var nVelocityX:Number = 0;
        var nVelocityY:Number = 0;
        var nAccelerationX:Number;
        var nAccelerationY:Number;
        var nEnergy:Number = 0;
        var nInitialScale:Number = 1;
        var nEndScale:Number = 1;
        var nInitialVelocityX:Number;
        var nInitialVelocityY:Number;
        var nInitialVelocityAngular:Number;
        var nInitialAccelerationX:Number;
        var nInitialAccelerationY:Number;
        var nInitialRed:Number;
        var nInitialGreen:Number;
        var nInitialBlue:Number;
        var nInitialAlpha:Number;
        var nEndRed:Number;
        var nEndGreen:Number;
        var nEndBlue:Number;
        var nEndAlpha:Number;
        private var __nRedDif:Number;
        private var __nGreenDif:Number;
        private var __nBlueDif:Number;
        private var __nAlphaDif:Number;
        private var __nScaleDif:Number;
        var nAccumulatedEnergy:Number = 0;
        private var __cNextInstance:FSimpleParticle;
        private var __iId:int = 0;

        public function FSimpleParticle():void
        {
            __iId = count++;
        }

        public static function precache(p_precacheCount:int):void
        {
            var _local4 = null;
            var _local2 = null;
            if (p_precacheCount < count)
            {
                return;
            };
            var _local3:FSimpleParticle = get();
            while (count < p_precacheCount)
            {
                _local4 = get();
                _local4.cPrevious = _local3;
                _local3 = _local4;
            };
            while (_local3)
            {
                _local2 = _local3;
                _local3 = _local2.cPrevious;
                _local2.dispose();
            };
        }

        static function get():FSimpleParticle
        {
            var _local1:FSimpleParticle = availableInstance;
            if (_local1)
            {
                availableInstance = _local1.__cNextInstance;
                _local1.__cNextInstance = null;
            }
            else
            {
                _local1 = new (FSimpleParticle)();
            };
            return (_local1);
        }


        public function toString():String
        {
            return ((("[" + __iId) + "]"));
        }

        function init(p_emitter:FSimpleEmitter, p_invalidate:Boolean=true):void
        {
            var _local5:Number;
            var _local3:Number;
            var _local8:Number;
            var _local9:Number;
            var _local16:Number;
            var _local7:Number;
            var _local11:Number;
            nAccumulatedEnergy = 0;
            nEnergy = (p_emitter.energy * 1000);
            if (p_emitter.energyVariance > 0)
            {
                nEnergy = (nEnergy + ((p_emitter.energyVariance * 1000) * Math.random()));
            };
            nInitialScale = p_emitter.initialScale;
            if (p_emitter.initialScaleVariance > 0)
            {
                nInitialScale = (nInitialScale + (p_emitter.initialScaleVariance * Math.random()));
            };
            nEndScale = p_emitter.endScale;
            if (p_emitter.endScaleVariance > 0)
            {
                nEndScale = (nEndScale + (p_emitter.endScaleVariance * Math.random()));
            };
            var _local13:Number = p_emitter.initialVelocity;
            if (p_emitter.initialVelocityVariance > 0)
            {
                _local13 = (_local13 + (p_emitter.initialVelocityVariance * Math.random()));
            };
            var _local10:Number = p_emitter.initialAcceleration;
            if (p_emitter.initialAccelerationVariance > 0)
            {
                _local10 = (_local10 + (p_emitter.initialAccelerationVariance * Math.random()));
            };
            _local5 = _local13;
            var _local15:Number = _local5;
            _local3 = 0;
            var _local14:Number = _local3;
            _local8 = _local10;
            var _local12:Number = _local8;
            _local9 = 0;
            var _local4:Number = _local9;
            var _local6:Number = p_emitter.cNode.transform.nWorldRotation;
            if (_local6 != 0)
            {
                _local16 = Math.sin(_local6);
                _local7 = Math.cos(_local6);
                _local5 = (_local13 * _local7);
                _local15 = _local5;
                _local3 = (_local13 * _local16);
                _local14 = _local3;
                _local8 = (_local10 * _local7);
                _local12 = _local8;
                _local9 = (_local10 * _local16);
                _local4 = _local9;
            };
            if (((!((p_emitter.dispersionAngle == 0))) || (!((p_emitter.dispersionAngleVariance == 0)))))
            {
                _local11 = p_emitter.dispersionAngle;
                if (p_emitter.dispersionAngleVariance > 0)
                {
                    _local11 = (_local11 + (p_emitter.dispersionAngleVariance * Math.random()));
                };
                _local16 = Math.sin(_local11);
                _local7 = Math.cos(_local11);
                _local5 = ((_local15 * _local7) - (_local14 * _local16));
                _local3 = ((_local14 * _local7) + (_local15 * _local16));
                _local8 = ((_local12 * _local7) - (_local4 * _local16));
                _local9 = ((_local4 * _local7) + (_local12 * _local16));
            };
            nInitialVelocityX = (nVelocityX = (_local5 * 0.001));
            nInitialVelocityY = (nVelocityY = (_local3 * 0.001));
            nInitialAccelerationX = (nAccelerationX = (_local8 * 0.001));
            nInitialAccelerationY = (nAccelerationY = (_local9 * 0.001));
            nInitialVelocityAngular = p_emitter.initialAngularVelocity;
            if (p_emitter.initialAngularVelocityVariance > 0)
            {
                nInitialVelocityAngular = (nInitialVelocityAngular + (p_emitter.initialAngularVelocityVariance * Math.random()));
            };
            nInitialRed = p_emitter.initialRed;
            if (p_emitter.initialRedVariance > 0)
            {
                nInitialRed = (nInitialRed + (p_emitter.initialRedVariance * Math.random()));
            };
            nInitialGreen = p_emitter.initialGreen;
            if (p_emitter.initialGreenVariance > 0)
            {
                nInitialGreen = (nInitialGreen + (p_emitter.initialGreenVariance * Math.random()));
            };
            nInitialBlue = p_emitter.initialBlue;
            if (p_emitter.initialBlueVariance > 0)
            {
                nInitialBlue = (nInitialBlue + (p_emitter.initialBlueVariance * Math.random()));
            };
            nInitialAlpha = p_emitter.initialAlpha;
            if (p_emitter.initialAlphaVariance > 0)
            {
                nInitialAlpha = (nInitialAlpha + (p_emitter.initialAlphaVariance * Math.random()));
            };
            nEndRed = p_emitter.endRed;
            if (p_emitter.endRedVariance > 0)
            {
                nEndRed = (nEndRed + (p_emitter.endRedVariance * Math.random()));
            };
            nEndGreen = p_emitter.endGreen;
            if (p_emitter.endGreenVariance > 0)
            {
                nEndGreen = (nEndGreen + (p_emitter.endGreenVariance * Math.random()));
            };
            nEndBlue = p_emitter.endBlue;
            if (p_emitter.endBlueVariance > 0)
            {
                nEndBlue = (nEndBlue + (p_emitter.endBlueVariance * Math.random()));
            };
            nEndAlpha = p_emitter.endAlpha;
            if (p_emitter.endAlphaVariance > 0)
            {
                nEndAlpha = (nEndAlpha + (p_emitter.endAlphaVariance * Math.random()));
            };
            __nRedDif = (nEndRed - nInitialRed);
            __nGreenDif = (nEndGreen - nInitialGreen);
            __nBlueDif = (nEndBlue - nInitialBlue);
            __nAlphaDif = (nEndAlpha - nInitialAlpha);
            __nScaleDif = (nEndScale - nInitialScale);
        }

        function update(p_emitter:FSimpleEmitter, p_deltaTime:Number):void
        {
            var _local5:int;
            var _local4:Number;
            nAccumulatedEnergy = (nAccumulatedEnergy + p_deltaTime);
            if (nAccumulatedEnergy >= nEnergy)
            {
                p_emitter.deactivateParticle(this);
                return;
            };
            _local5 = 0;
            while (_local5 < p_emitter.iFieldsCount)
            {
                p_emitter.aFields[_local5].updateSimpleParticle(this, p_deltaTime);
                _local5++;
            };
            var _local3:Number = (nAccumulatedEnergy / nEnergy);
            nVelocityX = (nVelocityX + (nAccelerationX * p_deltaTime));
            nVelocityY = (nVelocityY + (nAccelerationY * p_deltaTime));
            nRed = ((__nRedDif * _local3) + nInitialRed);
            nGreen = ((__nGreenDif * _local3) + nInitialGreen);
            nBlue = ((__nBlueDif * _local3) + nInitialBlue);
            nAlpha = ((__nAlphaDif * _local3) + nInitialAlpha);
            nX = (nX + (nVelocityX * p_deltaTime));
            nY = (nY + (nVelocityY * p_deltaTime));
            nRotation = (nRotation + (nInitialVelocityAngular * p_deltaTime));
            nScaleX = (nScaleY = ((__nScaleDif * _local3) + nInitialScale));
            if (p_emitter.special)
            {
                _local4 = Math.sqrt(((nVelocityX * nVelocityX) + (nVelocityY * nVelocityY)));
                nScaleY = (_local4 * 10);
                nRotation = -(Math.atan2(nVelocityX, nVelocityY));
            };
        }

        function dispose():void
        {
            if (cNext)
            {
                cNext.cPrevious = cPrevious;
            };
            if (cPrevious)
            {
                cPrevious.cNext = cNext;
            };
            cNext = null;
            cPrevious = null;
            __cNextInstance = availableInstance;
            availableInstance = this;
        }


    }
}//package com.flengine.components.particles

