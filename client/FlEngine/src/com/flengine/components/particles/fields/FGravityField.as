// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.particles.fields.FGravityField

package com.flengine.components.particles.fields
{
    import com.flengine.core.FNode;
    import com.flengine.components.particles.FParticle;
    import com.flengine.components.particles.FSimpleParticle;

    public class FGravityField extends FField 
    {

        public var radius:Number = -1;
        public var gravity:Number = 0;
        public var gravityVariance:Number = 0;
        public var inverseGravity:Boolean = false;

        public function FGravityField(p_node:FNode)
        {
            super(p_node);
        }

        override public function updateParticle(p_particle:FParticle, p_deltaTime:Number):void
        {
            var _local4:Number;
            if (!_bActive)
            {
                return;
            };
            var _local5:Number = (cNode.cTransform.nWorldX - p_particle.cNode.cTransform.nWorldX);
            var _local6:Number = (cNode.cTransform.nWorldY - p_particle.cNode.cTransform.nWorldY);
            var _local7:Number = ((_local5 * _local5) + (_local6 * _local6));
            if ((((_local7 > (radius * radius))) && ((radius > 0))))
            {
                return;
            };
            if (_local7 != 0)
            {
                _local4 = Math.sqrt(_local7);
                _local5 = (_local5 / ((inverseGravity) ? -(_local4) : _local4));
                _local6 = (_local6 / ((inverseGravity) ? -(_local4) : _local4));
            };
            var _local3:Number = gravity;
            if (gravityVariance > 0)
            {
                _local3 = (_local3 + (gravityVariance * Math.random()));
            };
            p_particle.nVelocityX = (p_particle.nVelocityX + (((_local3 * _local5) * 0.001) * p_deltaTime));
            p_particle.nVelocityY = (p_particle.nVelocityY + (((_local3 * _local6) * 0.001) * p_deltaTime));
        }

        override public function updateSimpleParticle(p_particle:FSimpleParticle, p_deltaTime:Number):void
        {
            var _local4:Number;
            if (!_bActive)
            {
                return;
            };
            var _local5:Number = (cNode.cTransform.nWorldX - p_particle.nX);
            var _local6:Number = (cNode.cTransform.nWorldY - p_particle.nY);
            var _local7:Number = ((_local5 * _local5) + (_local6 * _local6));
            if ((((_local7 > (radius * radius))) && ((radius > 0))))
            {
                return;
            };
            if (_local7 != 0)
            {
                _local4 = Math.sqrt(_local7);
                _local5 = (_local5 / ((inverseGravity) ? -(_local4) : _local4));
                _local6 = (_local6 / ((inverseGravity) ? -(_local4) : _local4));
            };
            var _local3:Number = gravity;
            if (gravityVariance > 0)
            {
                _local3 = (_local3 + (gravityVariance * Math.random()));
            };
            p_particle.nVelocityX = (p_particle.nVelocityX + (((_local3 * _local5) * 0.001) * p_deltaTime));
            p_particle.nVelocityY = (p_particle.nVelocityY + (((_local3 * _local6) * 0.001) * p_deltaTime));
        }


    }
}//package com.flengine.components.particles.fields

