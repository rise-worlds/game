// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.particles.FParticleOld

package com.flengine.components.particles
{
    import com.flengine.components.FComponent;
    import com.flengine.core.FNode;

    public class FParticleOld extends FComponent 
    {

        var cNextParticle:FParticle;
        var cPreviousParticle:FParticle;
        var nVelocityX:Number = 0;
        var nVelocityY:Number = 0;
        protected var _nEnergy:Number = 0;
        protected var _nInitialVelX:Number = 0;
        protected var _nInitialVelY:Number = 0;
        protected var _nInitialVelAngular:Number = 0;
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

        public function FParticleOld(p_node:FNode)
        {
            super(p_node);
        }

        override public function set active(p_value:Boolean):void
        {
            _bActive = p_value;
            _nAccumulatedEnergy = 0;
            cNode.transform.alpha = 1;
        }

        function init(p_energy:Number, p_velX:Number, p_velY:Number, p_velAngular:Number, p_initialRed:Number, p_initialGreen:Number, p_initialBlue:Number, p_initialAlpha:Number, p_endRed:Number, p_endGreen:Number, p_endBlue:Number, p_endAlpha:Number):void
        {
            _nEnergy = p_energy;
            nVelocityX = p_velX;
            _nInitialVelX = p_velX;
            nVelocityY = p_velY;
            _nInitialVelY = p_velY;
            _nInitialVelAngular = p_velAngular;
            _nInitialRed = p_initialRed;
            _nInitialGreen = p_initialGreen;
            _nInitialBlue = p_initialBlue;
            _nInitialAlpha = p_initialAlpha;
            _nEndRed = p_endRed;
            _nEndGreen = p_endGreen;
            _nEndBlue = p_endBlue;
            _nEndAlpha = p_endAlpha;
        }

        override public function update(p_deltaTime:Number, p_parentTransformUpdate:Boolean, p_parentColorUpdate:Boolean):void
        {
            _nAccumulatedEnergy = (_nAccumulatedEnergy + p_deltaTime);
            if (_nAccumulatedEnergy >= _nEnergy)
            {
                cNode.active = false;
                return;
            };
            var _local4:Number = (_nAccumulatedEnergy / _nEnergy);
            cNode.cTransform.red = (((_nEndRed - _nInitialRed) * _local4) + _nInitialRed);
            cNode.cTransform.green = (((_nEndGreen - _nInitialGreen) * _local4) + _nInitialGreen);
            cNode.cTransform.blue = (((_nEndBlue - _nInitialBlue) * _local4) + _nInitialBlue);
            cNode.cTransform.alpha = (((_nEndAlpha - _nInitialAlpha) * _local4) + _nInitialAlpha);
            cNode.cTransform.x = (cNode.cTransform.x + (nVelocityX * p_deltaTime));
            cNode.cTransform.y = (cNode.cTransform.y + (nVelocityY * p_deltaTime));
            cNode.cTransform.rotation = (cNode.cTransform.rotation + (_nInitialVelAngular * p_deltaTime));
        }


    }
}//package com.flengine.components.particles

