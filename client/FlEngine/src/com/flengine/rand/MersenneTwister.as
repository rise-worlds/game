// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.rand.MersenneTwister

package com.flengine.rand
{
    import __AS3__.vec.Vector;

    public class MersenneTwister implements PseudoRandomNumberGenerator 
    {

        private static const MTRAND_N:Number = 624;
        private static const MTRAND_M:Number = 397;
        private static const MATRIX_A:Number = 2567483615;
        private static const UPPER_MASK:Number = 0x80000000;
        private static const LOWER_MASK:Number = 2147483647;
        private static const TEMPERING_MASK_B:Number = 2636928640;
        private static const TEMPERING_MASK_C:Number = 0xEFC60000;

        private var mt:Vector.<Number>;
        private var y:Number = 0;
        private var z:Number = 0;
        private var mSeed:Number = 0;

        public function MersenneTwister():void
        {
            mt = new Vector.<Number>();
            super();
        }

        public function SetSeed(seed:Number):void
        {
            if (seed == 0)
            {
                seed = 4357;
            };
            mSeed = seed;
            mt[0] = (seed & 0xFFFFFFFF);
            z = 1;
            while (z < 624)
            {
                mt[z] = ((1812433253 + (mt[(z - 1)] ^ ((mt[(z - 1)] >> 30) & 3))) + z);
                var _local2 = z;
                var _local3 = (mt[_local2] & 0xFFFFFFFF);
                mt[_local2] = _local3;
                z++;
            };
        }

        public function Next():Number
        {
            var _local4:int;
            var _local2:int;
            var _local1:int;
            var _local3:Array = [0, 2567483615];
            if (z >= 624)
            {
                _local4 = 0;
                _local2 = 227;
                _local4 = 0;
                while (_local4 < _local2)
                {
                    y = ((mt[_local4] & 0x80000000) | (mt[(_local4 + 1)] & 2147483647));
                    mt[_local4] = ((mt[(_local4 + 397)] ^ ((y >> 1) & 2147483647)) ^ _local3[(y & 1)]);
                    _local4++;
                };
                _local1 = 623;
                while (_local4 < _local1)
                {
                    y = ((mt[_local4] & 0x80000000) | (mt[(_local4 + 1)] & 2147483647));
                    mt[_local4] = ((mt[(_local4 + (397 - 624))] ^ ((y >> 1) & 2147483647)) ^ _local3[(y & 1)]);
                    _local4++;
                };
                y = ((mt[(624 - 1)] & 0x80000000) | (mt[0] & 2147483647));
                mt[(624 - 1)] = ((mt[(397 - 1)] ^ ((y >> 1) & 2147483647)) ^ _local3[(y & 1)]);
                z = 0;
            };
            y = mt[z++];
            y = (y ^ ((y >> 11) & 2097151));
            y = (y ^ ((y << 7) & 2636928640));
            y = (y ^ ((y << 15) & 0xEFC60000));
            y = (y ^ ((y >> 18) & 16383));
            y = (y & 2147483647);
            return ((y / 2147483647));
        }

        public function Reset():void
        {
            SetSeed(mSeed);
        }


    }
}//package com.flengine.rand

