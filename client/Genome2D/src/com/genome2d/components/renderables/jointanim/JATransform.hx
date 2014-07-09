package com.genome2d.components.renderables.jointanim;

/**
 * ...
 * @author Rise
 */
class JATransform {
	private static var _a:Float;
	private static var _c:Float;
	private static var _b:Float;
	private static var _d:Float;
	private static var _tx:Float;
	private static var _ty:Float;
	private static var __a:Float;
	private static var __c:Float;
	private static var __b:Float;
	private static var __d:Float;
	private static var __tx:Float;
	private static var __ty:Float;
	public var matrix:JAMatrix3;

	public function new() {
		matrix = new JAMatrix3();
	}

	public function clone(from:JATransform):Void {
		this.matrix.copy(from.matrix);
	}

	public function TransformSrc(theSrcTransform:JATransform, outTransform:JATransform):JATransform {
		__a = theSrcTransform.matrix.a;
		__c = theSrcTransform.matrix.c;
		__b = theSrcTransform.matrix.b;
		__d = theSrcTransform.matrix.d;
		__tx = theSrcTransform.matrix.tx;
		__ty = theSrcTransform.matrix.ty;
		_a = matrix.a;
		_c = matrix.c;
		_b = matrix.b;
		_d = matrix.d;
		_tx = matrix.tx;
		_ty = matrix.ty;
		outTransform.matrix.a = ((_a * __a) + (_c * __b));
		outTransform.matrix.c = ((_a * __c) + (_c * __d));
		outTransform.matrix.b = ((_b * __a) + (_d * __b));
		outTransform.matrix.d = ((_b * __c) + (_d * __d));
		outTransform.matrix.tx = ((_tx + (_a * __tx)) + (_c * __ty));
		outTransform.matrix.ty = ((_ty + (_b * __tx)) + (_d * __ty));
		return (outTransform);
	}

	public function InterpolateTo(theNextTransform:JATransform, thePct:Float, outTransform:JATransform):JATransform {
		__a = theNextTransform.matrix.a;
		__c = theNextTransform.matrix.c;
		__b = theNextTransform.matrix.b;
		__d = theNextTransform.matrix.d;
		__tx = theNextTransform.matrix.tx;
		__ty = theNextTransform.matrix.ty;
		_a = matrix.a;
		_c = matrix.c;
		_b = matrix.b;
		_d = matrix.d;
		_tx = matrix.tx;
		_ty = matrix.ty;
		outTransform.matrix.a = ((_a * (1 - thePct)) + (__a * thePct));
		outTransform.matrix.c = ((_c * (1 - thePct)) + (__c * thePct));
		outTransform.matrix.b = ((_b * (1 - thePct)) + (__b * thePct));
		outTransform.matrix.d = ((_d * (1 - thePct)) + (__d * thePct));
		outTransform.matrix.tx = ((_tx * (1 - thePct)) + (__tx * thePct));
		outTransform.matrix.ty = ((_ty * (1 - thePct)) + (__ty * thePct));
		return (outTransform);
	}

}