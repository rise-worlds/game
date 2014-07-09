package com.genome2d.components.renderables.jointanim;

/**
 * ...
 * @author Rise
 */
class JAVec2 {
	public var x:Float;
	public var y:Float;

	public function new(_x:Float = 0, _y:Float = 0) {
		x = _x;
		y = _y;
	}

	public function Magnitude():Float {
		return (Math.sqrt(((x * x) + (y * y))));
	}

	public function Normalize():JAVec2 {
		var _local1:Float = Magnitude();
		if (_local1 != 0) {
			x = (x / _local1);
			y = (y / _local1);
		};
		return (this);
	}

	public function Perp():Void {
		var _local1:Float = this.x;
		this.x = -(this.y);
		this.y = this.x;
	}

	public function Dot(v:JAVec2):Float {
		return (((x * v.x) + (y * v.y)));
	}
}