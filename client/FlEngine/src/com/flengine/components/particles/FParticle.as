// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.particles.FParticle

package com.flengine.components.particles
{
    import com.flengine.components.FComponent;
    import com.flengine.core.FNode;

    public class FParticle extends FComponent 
    {

        var nVelocityX:Number = 0;
        var nVelocityY:Number = 0;
        var nAccelerationX:Number;
        var nAccelerationY:Number;
        protected var _nEnergy:Number = 0;
        protected var _nInitialScale:Number = 1;
        protected var _nEndScale:Number = 1;
        protected var _nInitialVelocityX:Number;
        protected var _nInitialVelocityY:Number;
        protected var _nInitialVelocityAngular:Number;
        protected var _nInitialAccelerationX:Number;
        protected var _nInitialAccelerationY:Number;
        protected var _nInitialRed:Number;
        protected var _nInitialGreen:Number;
        protected var _nInitialBlue:Number;
        protected var _nInitialAlpha:Number;
        protected var _nEndRed:Number;
        protected var _nEndGreen:Number;
        protected var _nEndBlue:Number;
        protected var _nEndAlpha:Number;
        var cEmitter:FEmitter;
        protected var _nAccumulatedEnergy:Number = 0;

        public function FParticle(p_node:FNode)
        {
            super(p_node);
        }

        override public function set active(p_value:Boolean):void
        {
            _bActive = p_value;
            _nAccumulatedEnergy = 0;
        }

        function init(p_invalidate:Boolean=true):void
        {
            var _local4:Number;
            var _local2:Number;
            var _local6:Number;
            var _local7:Number;
            var _local9:Number;
            _nEnergy = ((cEmitter.energy + (cEmitter.energyVariance * Math.random())) * 1000);
            if (cEmitter.energyVariance > 0)
            {
                _nEnergy = (_nEnergy + (cEmitter.energyVariance * Math.random()));
            };
            _nInitialScale = cEmitter.initialScale;
            if (cEmitter.initialScaleVariance > 0)
            {
                _nInitialScale = (_nInitialScale + (cEmitter.initialScaleVariance * Math.random()));
            };
            _nEndScale = cEmitter.endScale;
            if (cEmitter.endScaleVariance > 0)
            {
                _nEndScale = (_nEndScale + (cEmitter.endScaleVariance * Math.random()));
            };
            var _local14:Number = Math.sin(cEmitter.cNode.transform.nWorldRotation);
            var _local5:Number = Math.cos(cEmitter.cNode.transform.nWorldRotation);
            var _local11:Number = cEmitter.initialVelocity;
            if (cEmitter.initialVelocityVariance > 0)
            {
                _local11 = (_local11 + (cEmitter.initialVelocityVariance * Math.random()));
            };
            var _local8:Number = cEmitter.initialAcceleration;
            if (cEmitter.initialAccelerationVariance > 0)
            {
                _local8 = (_local8 + (cEmitter.initialAccelerationVariance * Math.random()));
            };
            _local4 = (_local11 * _local5);
            var _local13:Number = _local4;
            _local2 = (_local11 * _local14);
            var _local12:Number = _local2;
            _local6 = (_local8 * _local5);
            var _local10:Number = _local6;
            _local7 = (_local8 * _local14);
            var _local3:Number = _local7;
            if (((!((cEmitter.dispersionAngle == 0))) || (!((cEmitter.dispersionAngleVariance == 0)))))
            {
                _local9 = cEmitter.dispersionAngle;
                if (cEmitter.dispersionAngleVariance > 0)
                {
                    _local9 = (_local9 + (cEmitter.dispersionAngleVariance * Math.random()));
                };
                _local14 = Math.sin(_local9);
                _local5 = Math.cos(_local9);
                _local4 = ((_local13 * _local5) - (_local12 * _local14));
                _local2 = ((_local12 * _local5) + (_local13 * _local14));
                _local6 = ((_local10 * _local5) - (_local3 * _local14));
                _local7 = ((_local3 * _local5) + (_local10 * _local14));
            };
            _nInitialVelocityX = (nVelocityX = (_local4 * 0.001));
            _nInitialVelocityY = (nVelocityY = (_local2 * 0.001));
            _nInitialAccelerationX = (nAccelerationX = (_local6 * 0.001));
            _nInitialAccelerationY = (nAccelerationY = (_local7 * 0.001));
            _nInitialVelocityAngular = cEmitter.angularVelocity;
            if (cEmitter.angularVelocityVariance > 0)
            {
                _nInitialVelocityAngular = (_nInitialVelocityAngular + (cEmitter.angularVelocityVariance * Math.random()));
            };
            _nInitialRed = cEmitter.initialRed;
            if (cEmitter.initialRedVariance > 0)
            {
                _nInitialRed = (_nInitialRed + (cEmitter.initialRedVariance * Math.random()));
            };
            _nInitialGreen = cEmitter.initialGreen;
            if (cEmitter.initialGreenVariance > 0)
            {
                _nInitialGreen = (_nInitialGreen + (cEmitter.initialGreenVariance * Math.random()));
            };
            _nInitialBlue = cEmitter.initialBlue;
            if (cEmitter.initialBlueVariance > 0)
            {
                _nInitialBlue = (_nInitialBlue + (cEmitter.initialBlueVariance * Math.random()));
            };
            _nInitialAlpha = cEmitter.initialAlpha;
            if (cEmitter.initialAlphaVariance > 0)
            {
                _nInitialAlpha = (_nInitialAlpha + (cEmitter.initialAlphaVariance * Math.random()));
            };
            _nEndRed = cEmitter.endRed;
            if (cEmitter.endRedVariance > 0)
            {
                _nEndRed = (_nEndRed + (cEmitter.endRedVariance * Math.random()));
            };
            _nEndGreen = cEmitter.endGreen;
            if (cEmitter.endGreenVariance > 0)
            {
                _nEndGreen = (_nEndGreen + (cEmitter.endGreenVariance * Math.random()));
            };
            _nEndBlue = cEmitter.endBlue;
            if (cEmitter.endBlueVariance > 0)
            {
                _nEndBlue = (_nEndBlue + (cEmitter.endBlueVariance * Math.random()));
            };
            _nEndAlpha = cEmitter.endAlpha;
            if (cEmitter.endAlphaVariance > 0)
            {
                _nEndAlpha = (_nEndAlpha + (cEmitter.endAlphaVariance * Math.random()));
            };
        }

        override public function update(p_deltaTime:Number, p_parentTransformUpdate:Boolean, p_parentColorUpdate:Boolean):void
        {
            var _local5:int;
            _nAccumulatedEnergy = (_nAccumulatedEnergy + p_deltaTime);
            if (_nAccumulatedEnergy >= _nEnergy)
            {
                cNode.active = false;
                return;
            };
            _local5 = 0;
            while (_local5 < cEmitter.iFieldsCount)
            {
                cEmitter.aFields[_local5].updateParticle(this, p_deltaTime);
                _local5++;
            };
            var _local4:Number = (_nAccumulatedEnergy / _nEnergy);
            nVelocityX = (nVelocityX + (nAccelerationX * p_deltaTime));
            nVelocityY = (nVelocityY + (nAccelerationY * p_deltaTime));
            cNode.cTransform.red = (((_nEndRed - _nInitialRed) * _local4) + _nInitialRed);
            cNode.cTransform.green = (((_nEndGreen - _nInitialGreen) * _local4) + _nInitialGreen);
            cNode.cTransform.blue = (((_nEndBlue - _nInitialBlue) * _local4) + _nInitialBlue);
            cNode.cTransform.alpha = (((_nEndAlpha - _nInitialAlpha) * _local4) + _nInitialAlpha);
            cNode.cTransform.x = (cNode.cTransform.x + (nVelocityX * p_deltaTime));
            cNode.cTransform.y = (cNode.cTransform.y + (nVelocityY * p_deltaTime));
            cNode.cTransform.rotation = (cNode.cTransform.rotation + (_nInitialVelocityAngular * p_deltaTime));
            var _local6 = (((_nEndScale - _nInitialScale) * _local4) + _nInitialScale);
            cNode.cTransform.scaleY = _local6;
            cNode.cTransform.scaleX = _local6;
        }


    }
}//package com.flengine.components.particles

