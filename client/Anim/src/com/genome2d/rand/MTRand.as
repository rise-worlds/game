// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.rand.MTRand

package com.genome2d.rand
{
    import __AS3__.vec.Vector;

    public class MTRand 
    {

        private static const MTRAND_N:int = 624;
        private static const mag01:Array = [0, 2567483615];
        private static const UPPER_MASK:uint = 0x80000000;
        private static const LOWER_MASK:uint = 2147483647;
        private static const MTRAND_M:uint = 397;
        private static const TEMPERING_MASK_B:uint = 2636928640;
        private static const TEMPERING_MASK_C:uint = 0xEFC60000;

        protected var mt:Vector.<uint>;
        protected var mti:int;

        public function MTRand()
        {
            mt = new Vector.<uint>();
            mt.fixed = false;
            mt.length = 624;
            mt.fixed = true;
            SRand(4357);
        }

        public function SRand(seed:uint):void
        {
            if (seed == 0)
            {
                seed = 4357;
            };
            mt[0] = (seed & 0xFFFFFFFF);
            mti = 1;
            while (mti < 624)
            {
                mt[mti] = ((1812433253 * (mt[(mti - 1)] ^ ((mt[(mti - 1)] >> 30) & 3))) + mti);
                var _local2:int = mti;
                var _local3:int = (mt[_local2] & 0xFFFFFFFF);
                mt[_local2] = _local3;
                mti++;
            };
        }

        public function Next():uint
        {
            var _local2:int;
            var _local1:int;
            if (mti >= 624)
            {
                _local1 = 0;
                while (_local1 < (624 - 397))
                {
                    _local2 = ((mt[_local1] & 0x80000000) | (mt[(_local1 + 1)] & 2147483647));
                    mt[_local1] = ((mt[(_local1 + 397)] ^ ((_local2 >> 1) & 2147483647)) ^ mag01[(_local2 & 1)]);
                    _local1++;
                };
                while (_local1 < (624 - 1))
                {
                    _local2 = ((mt[_local1] & 0x80000000) | (mt[(_local1 + 1)] & 2147483647));
                    mt[_local1] = ((mt[(_local1 + (397 - 624))] ^ ((_local2 >> 1) & 2147483647)) ^ mag01[(_local2 & 1)]);
                    _local1++;
                };
                _local2 = ((mt[(624 - 1)] & 0x80000000) | (mt[0] & 2147483647));
                mt[(624 - 1)] = ((mt[(397 - 1)] ^ ((_local2 >> 1) & 2147483647)) ^ mag01[(_local2 & 1)]);
                mti = 0;
            };
            _local2 = mt[mti++];
            _local2 = (_local2 ^ ((_local2 >> 11) & 2097151));
            _local2 = (_local2 ^ ((_local2 << 7) & 2636928640));
            _local2 = (_local2 ^ ((_local2 << 15) & 0xEFC60000));
            _local2 = (_local2 ^ ((_local2 >> 18) & 16383));
            return ((_local2 & 2147483647));
        }

        public function NextRange(range:uint):uint
        {
            return ((Next() % range));
        }

        public function NextFloat(range:Number):Number
        {
            return (((Next() / 2147483647) * range));
        }

        public function Dispose():void
        {
            mt.splice(0, mt.length);
            mt = null;
        }


    }
}//package com.flengine.rand

