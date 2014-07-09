package com.genome2d.components.renderables.jointanim;
import flash.Vector;

/**
 * 动画集合
 * @author Rise
 */
class JAAnimDef {
	public var mainSpriteDef:JASpriteDef;
	public var spriteDefVector:Vector<JASpriteDef>;		// 标签列表
	public var objectNamePool:Array<Dynamic>;			// 标签、资源名字列表

	public function new() {
		mainSpriteDef = null;
		spriteDefVector = new Vector<JASpriteDef>();
		objectNamePool = [];
	}

}