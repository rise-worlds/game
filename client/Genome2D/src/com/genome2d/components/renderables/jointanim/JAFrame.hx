package com.genome2d.components.renderables.jointanim;
import flash.Vector;
/**
 * ...
 * @author Rise
 */
class JAFrame {
	public var hasStop:Bool;
	public var commandVector:Vector<JACommand>;
	public var frameObjectPosVector:Vector<JAObjectPos>;

	public function new() {
		commandVector = new Vector<JACommand>();
		frameObjectPosVector = new Vector<JAObjectPos>();
	}

}