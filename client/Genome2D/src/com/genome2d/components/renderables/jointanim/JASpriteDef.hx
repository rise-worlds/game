package com.genome2d.components.renderables.jointanim;
import flash.Vector;

/**
 * 单个组合动画（标签）
 * @author Rise
 */
class JASpriteDef {
	public var name:String;
	public var animRate:Float;
	public var workAreaStart:Int;						// 开始时间
	public var workAreaDuration:Int;					// 持续时间
	public var frames:Vector<JAFrame>;					// 帧序列
	public var objectDefVector:Array<JAObjectDef>;
	public var label:Dynamic;

	public function new() {
		frames = new Vector<JAFrame>();
		objectDefVector = new Array<JAObjectDef>();
		label = {};
	}

	public function GetLabelFrame(theLabel:String):Int {
		var _local2:String = theLabel.toUpperCase();
		if (Reflect.field(label, _local2) != null) {
			return Reflect.field(label, _local2);
		};
		return (-1);
	}
}