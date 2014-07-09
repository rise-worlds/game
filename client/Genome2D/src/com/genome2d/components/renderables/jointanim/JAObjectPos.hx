package com.genome2d.components.renderables.jointanim;
import com.genome2d.geom.GRectangle;

/**
 * ...
 * @author Rise
 */
class JAObjectPos {
	public var name:String;
	public var objectNum:Int;
	public var isSprite:Bool;					// 是否是标签
	public var isAdditive:Bool;
	public var resNum:Int;
	public var hasSrcRect:Bool;
	public var srcRect:GRectangle;
	public var color:JAColor;
	public var animFrameNum:Int;
	public var timeScale:Float;
	public var preloadFrames:Int;
	public var transform:JATransform;

	public function new() {
		transform = new JATransform();
	}

	public function clone(from:JAObjectPos):Void {
		this.name = from.name;
		this.objectNum = from.objectNum;
		this.isSprite = from.isSprite;
		this.isAdditive = from.isAdditive;
		this.resNum = from.resNum;
		this.hasSrcRect = from.hasSrcRect;
		if (this.hasSrcRect)
		{
			if (from.srcRect != null)
			{
				this.srcRect = from.srcRect.clone();
			}
		}
		if (from.color != JAColor.White)
		{
			this.color = new JAColor();
			this.color.clone(from.color);
		}
		else
		{
			this.color = from.color;
		}
		this.animFrameNum = from.animFrameNum;
		this.timeScale = from.timeScale;
		this.preloadFrames = from.preloadFrames;
		transform.clone(from.transform);
	}
}