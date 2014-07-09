// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.particles.fields.FForceField

package com.flengine.components.particles.fields
{
    import com.flengine.core.FNode;
    import com.flengine.components.particles.FParticle;
    import com.flengine.components.particles.FSimpleParticle;

    public class FForceField extends FField 
    {

        public var radius:Number = 0;
        public var forceX:Number = 0;
        public var forceXVariance:Number = 0;
        public var forceY:Number = 0;
        public var forceYVariance:Number = 0;

        public function FForceField(p_node:FNode)
        {
            super(p_node);
        }

        override public function updateParticle(p_particle:FParticle, p_deltaTime:Number):void
        {
            if (!_bActive)
            {
                return;
            };
            var _local3:Number = (cNode.cTransform.nWorldX - p_particle.cNode.cTransform.nWorldX);
            var _local4:Number = (cNode.cTransform.nWorldY - p_particle.cNode.cTransform.nWorldY);
            var _local5:Number = ((_local3 * _local3) + (_local4 * _local4));
            if ((((_local5 > (radius * radius))) && ((radius > 0))))
            {
                return;
            };
            p_particle.nVelocityX = (p_particle.nVelocityX + ((forceX * 0.001) * p_deltaTime));
            p_particle.nVelocityY = (p_particle.nVelocityY + ((forceY * 0.001) * p_deltaTime));
        }

        override public function updateSimpleParticle(p_particle:FSimpleParticle, p_deltaTime:Number):void
        {
            if (!_bActive)
            {
                return;
            };
            var _local3:Number = (cNode.cTransform.nWorldX - p_particle.nX);
            var _local4:Number = (cNode.cTransform.nWorldY - p_particle.nY);
            var _local5:Number = ((_local3 * _local3) + (_local4 * _local4));
            if ((((_local5 > (radius * radius))) && ((radius > 0))))
            {
                return;
            };
            p_particle.nVelocityX = (p_particle.nVelocityX + ((forceX * 0.001) * p_deltaTime));
            p_particle.nVelocityY = (p_particle.nVelocityY + ((forceY * 0.001) * p_deltaTime));
        }


    }
}//package com.flengine.components.particles.fields

