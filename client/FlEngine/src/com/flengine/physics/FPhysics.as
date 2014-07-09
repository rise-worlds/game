// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.physics.FPhysics

package com.flengine.physics
{
	import com.flengine.fl2d;
	use namespace fl2d;
	
    public class FPhysics 
    {

        protected var _bRunning:Boolean = true;
        public var minimumTimeStep:int = 0;


        fl2d function step(p_deltaTime:Number):void
        {
        }

        public function setGravity(p_x:Number, p_y:Number):void
        {
        }

        public function stop():void
        {
            _bRunning = false;
        }

        public function start():void
        {
            _bRunning = true;
        }

        public function pause():void
        {
            _bRunning = !(_bRunning);
        }

        public function dispose():void
        {
        }


    }
}//package com.flengine.physics

