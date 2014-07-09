package com.genome2d.components.renderables.jointanim;
import flash.Vector;

/**
 * ...
 * @author Rise
 */
class JASpriteInst {
	public var parent:JASpriteInst;
	public var delayFrames:Int;
	public var frameNum:Float;
	public var lastFrameNum:Float;
	public var frameRepeats:Int;
	public var onNewFrame:Bool;
	public var lastUpdated:Int;
	public var curTransform:JATransform;
	public var curColor:JAColor;
	public var children:Vector<JAObjectInst>;
	public var spriteDef:JASpriteDef;

	public function new() {
		children = new Vector<JAObjectInst>();
		curTransform = new JATransform();
		spriteDef = null;
	}

	public function Dispose():Void {
		var aChildIdx:Int = 0;
		while (aChildIdx < children.length) {
			children[aChildIdx].Dispose();
			aChildIdx++;
		}
		children.splice(0, children.length);
		children = null;
		curTransform = null;
		spriteDef = null;
		curColor = null;
	}

	public function Reset():Void {
		var aChildIdx:Int = 0;
		while (aChildIdx < children.length) {
			children[aChildIdx].Dispose();
			aChildIdx++;
		}
		children.splice(0, children.length);
	}
}