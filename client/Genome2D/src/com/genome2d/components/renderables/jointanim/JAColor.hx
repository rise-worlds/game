package com.genome2d.components.renderables.jointanim;

/**
 * ...
 * @author Rise
 */
class JAColor {
	public static var White:JAColor = new JAColor(0xFF, 0xFF, 0xFF);

	public var red:Int;
	public var green:Int;
	public var blue:Int;
	public var alpha:Int;

	public function new(r:Int = 0, g:Int = 0, b:Int = 0, a:Int = 0xFF) {
		red = r;
		green = g;
		blue = b;
		alpha = a;
	}

	public static function FromInt(theColor:Int, out:JAColor):JAColor {
		out.Set(((theColor >> 16) & 0xFF), ((theColor >> 8) & 0xFF), (theColor & 0xFF), ((theColor >> 24) & 0xFF));
		return (out);
	}


	public function clone(from:JAColor):Void {
		this.red = from.red;
		this.green = from.green;
		this.blue = from.blue;
		this.alpha = from.alpha;
	}

	public function Set(r:Int, g:Int, b:Int, a:Int = 0xFF):Void {
		red = r;
		green = g;
		blue = b;
		alpha = a;
	}

	public function IsWhite():Bool {
		return ((red == 0xFF) && (green == 0xFF) && (blue == 0xFF));
	}

	public function toInt():UInt {
		return (((alpha << 24) & 0xFF000000) | ((red << 16) & 0xFF0000) | ((green << 8) & 0xFF00) | (blue & 0xFF));
	}

}