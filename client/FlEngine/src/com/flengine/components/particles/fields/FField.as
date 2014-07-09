// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.particles.fields.FField

package com.flengine.components.particles.fields
{
    import com.flengine.components.FComponent;
    import com.flengine.core.FNode;
    import com.flengine.components.particles.FParticle;
    import com.flengine.components.particles.FSimpleParticle;

    public class FField extends FComponent 
    {

        protected var _bUpdateParticles:Boolean = true;

        public function FField(p_node:FNode)
        {
            super(p_node);
        }

        public function updateParticle(p_particle:FParticle, p_deltaTime:Number):void
        {
        }

        public function updateSimpleParticle(p_particle:FSimpleParticle, p_deltaTime:Number):void
        {
        }


    }
}//package com.flengine.components.particles.fields

