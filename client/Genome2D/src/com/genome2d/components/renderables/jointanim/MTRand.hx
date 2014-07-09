package com.genome2d.components.renderables.jointanim;
import flash.Vector;
/**
 * ...
 * @author Rise
 */
class MTRand {
	private static inline var MTRAND_N:Int = 624;
	private static var mag01:Array<Dynamic> = [0, 0x9908B0DF];
	private static inline var UPPER_MASK:UInt = 0x80000000;
	private static inline var LOWER_MASK:UInt = 0x7FFFFFFF;
	private static inline var MTRAND_M:UInt = 397;
	private static inline var TEMPERING_MASK_B:UInt = 0x9D2C5680;
	private static inline var TEMPERING_MASK_C:UInt = 0xEFC60000;

	private var mt:Vector<UInt>;
	private var mti:Int;

	public function new() {
		mt = new Vector<UInt>();
		mt.fixed = false;
		mt.length = 624;
		mt.fixed = true;
		SRand(4357);
	}

	public function SRand(seed:UInt):Void {
		if (seed == 0) {
			seed = 4357;
		};
		mt[0] = (seed & 0xFFFFFFFF);
		mti = 1;
		while (mti < 624) {
			mt[mti] = ((0x6C078965 * (mt[(mti - 1)] ^ ((mt[(mti - 1)] >> 30) & 3))) + mti);
			var _local2 = mti;
			var _local3 = (mt[_local2] & 0xFFFFFFFF);
			mt[_local2] = _local3;
			mti++;
		};
	}

	public function Next():UInt {
		var _local2:Int;
		var _local1:Int;
		if (mti >= 624) {
			_local1 = 0;
			while (_local1 < (624 - 397)) {
				_local2 = ((mt[_local1] & 0x80000000) | (mt[(_local1 + 1)] & LOWER_MASK));
				mt[_local1] = ((mt[(_local1 + 397)] ^ ((_local2 >> 1) & LOWER_MASK)) ^ mag01[(_local2 & 1)]);
				_local1++;
			};
			while (_local1 < (624 - 1)) {
				_local2 = ((mt[_local1] & 0x80000000) | (mt[(_local1 + 1)] & LOWER_MASK));
				mt[_local1] = ((mt[(_local1 + (397 - 624))] ^ ((_local2 >> 1) & LOWER_MASK)) ^ mag01[(_local2 & 1)]);
				_local1++;
			};
			_local2 = ((mt[(624 - 1)] & 0x80000000) | (mt[0] & LOWER_MASK));
			mt[(624 - 1)] = ((mt[(397 - 1)] ^ ((_local2 >> 1) & LOWER_MASK)) ^ mag01[(_local2 & 1)]);
			mti = 0;
		};
		_local2 = mt[mti++];
		_local2 = (_local2 ^ ((_local2 >> 11) & 0x1FFFFF));
		_local2 = (_local2 ^ ((_local2 << 7) & 0x9D2C5680));
		_local2 = (_local2 ^ ((_local2 << 15) & 0xEFC60000));
		_local2 = (_local2 ^ ((_local2 >> 18) & 0x3FFF));
		return ((_local2 & LOWER_MASK));
	}

	public function NextRange(range:UInt):UInt {
		return ((Next() % range));
	}

	public function NextFloat(range:Float):Float {
		return (((Next() / LOWER_MASK) * range));
	}

	public function Dispose():Void {
		mt.splice(0, mt.length);
		mt = null;
	}
}