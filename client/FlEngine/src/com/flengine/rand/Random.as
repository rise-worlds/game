// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.rand.Random

package com.flengine.rand
{
    public class Random 
    {

        private var mPRNG:PseudoRandomNumberGenerator;

        public function Random(prng:PseudoRandomNumberGenerator)
        {
            mPRNG = prng;
        }

        public function SetSeed(seed:Number):void
        {
            mPRNG.SetSeed(seed);
        }

        public function Next():Number
        {
            return (mPRNG.Next());
        }

        public function Float(min:Number, max:Number=NaN):Number
        {
            if (isNaN(max))
            {
                max = min;
                min = 0;
            };
            return (((Next() * (max - min)) + min));
        }

        public function Bool(chance:Number=0.5):Boolean
        {
            return ((Next() < chance));
        }

        public function Sign(chance:Number=0.5):int
        {
            return ((((Next())<chance) ? 1 : -1));
        }

        public function Bit(chance:Number=0.5, shift:uint=0):int
        {
            return ((((Next())<chance) ? (1 << shift) : 0));
        }

        public function Int(min:Number, max:Number=NaN):int
        {
            if (isNaN(max))
            {
                max = min;
                min = 0;
            };
            return (Float(min, max));
        }

        public function Reset():void
        {
            mPRNG.Reset();
        }


    }
}//package com.flengine.rand

