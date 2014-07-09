package com.genome2d.components.renderables.jointanim;

/**
 * ...
 * @author Rise
 */
class JAObjectInst {
	public var name:String;
	public var spriteInst:JASpriteInst;
	public var blendSrcTransform:JATransform;
	public var blendSrcColor:JAColor;
	public var isBlending:Bool;
	public var transform:JATransform2D;
	public var colorMult:JAColor;
	public var predrawCallback:Bool;
	public var imagePredrawCallback:Bool;
	public var postdrawCallback:Bool;

	public function new() {
		name = null;
		spriteInst = null;
		predrawCallback = true;
		predrawCallback = true;
		imagePredrawCallback = true;
		isBlending = false;
		transform = new JATransform2D();
		colorMult = new JAColor();
		blendSrcColor = new JAColor();
		blendSrcTransform = new JATransform();
	}

	public function Dispose():Void {
	}
}