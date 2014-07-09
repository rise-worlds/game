package com.genome2d.components.renderables.jointanim;
import com.genome2d.geom.GMatrix;
import flash.geom.Matrix;
import flash.geom.Matrix3D;
import flash.Vector;

/**
 * @author Rise
 * [ a c tx ]
 * [ b d ty ]
 * [ u v w  ]
 * u=0,v=0,w=1
 */
class JAMatrix3 extends GMatrix {
	private static var _helpMatrixArg1:JAMatrix3 = new JAMatrix3();
	private static var _helpMatrixArg2:JAMatrix3 = new JAMatrix3();
	private static var _helpMatrix3DVector1:Array<Float> = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];
	private static var _helpMatrix3DVector2:Array<Float> = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];
	private static var _helpMatrix3DArg1:Matrix3D = new Matrix3D();
	private static var _helpMatrix3DArg2:Matrix3D = new Matrix3D();

	public function new() {
		super();
		//LoadIdentity();
	}

	public static function MulJAMatrix3(d:JAMatrix3, c:JAMatrix3, out:JAMatrix3):JAMatrix3 {
		_helpMatrixArg1.a = d.a;
		_helpMatrixArg1.c = d.c;
		_helpMatrixArg1.tx = d.tx;
		_helpMatrixArg1.b = d.b;
		_helpMatrixArg1.d = d.d;
		_helpMatrixArg1.ty = d.ty;
		_helpMatrixArg2.a = c.a;
		_helpMatrixArg2.c = c.c;
		_helpMatrixArg2.tx = c.tx;
		_helpMatrixArg2.b = c.b;
		_helpMatrixArg2.d = c.d;
		_helpMatrixArg2.ty = c.ty;
		out.a = ((_helpMatrixArg1.a * _helpMatrixArg2.a) + (_helpMatrixArg1.c * _helpMatrixArg2.b));
		out.b = ((_helpMatrixArg1.b * _helpMatrixArg2.a) + (_helpMatrixArg1.d * _helpMatrixArg2.b));
		out.c = ((_helpMatrixArg1.a * _helpMatrixArg2.c) + (_helpMatrixArg1.c * _helpMatrixArg2.d));
		out.d = ((_helpMatrixArg1.b * _helpMatrixArg2.c) + (_helpMatrixArg1.d * _helpMatrixArg2.d));
		out.tx = (((_helpMatrixArg1.a * _helpMatrixArg2.tx) + (_helpMatrixArg1.c * _helpMatrixArg2.ty)) + _helpMatrixArg1.tx);
		out.ty = (((_helpMatrixArg1.b * _helpMatrixArg2.tx) + (_helpMatrixArg1.d * _helpMatrixArg2.ty)) + _helpMatrixArg1.ty);
		return (out);
	}

	public static function MulJAMatrix3_M3D(c:Matrix3D, d:JATransform2D, out:JATransform2D):JATransform2D {
		_helpMatrix3DVector1[0] = d.a;
		_helpMatrix3DVector1[1] = d.b;
		_helpMatrix3DVector1[4] = d.c;
		_helpMatrix3DVector1[5] = d.d;
		_helpMatrix3DVector1[12] = d.tx;
		_helpMatrix3DVector1[13] = d.ty;
		_helpMatrix3DArg1.copyRawDataFrom(Vector.ofArray(_helpMatrix3DVector1));
		_helpMatrix3DArg1.prepend(c);
		_helpMatrix3DArg1.copyRawDataTo(Vector.ofArray(_helpMatrix3DVector1));
		out.a = _helpMatrix3DVector1[0];
		out.b = _helpMatrix3DVector1[1];
		out.c = _helpMatrix3DVector1[4];
		out.d = _helpMatrix3DVector1[5];
		out.tx = _helpMatrix3DVector1[12];
		out.ty = _helpMatrix3DVector1[13];
		return (out);
	}

	public static function MulJAMatrix3_2D(d:JAMatrix3, c:JATransform2D, out:JATransform2D):JATransform2D {
		_helpMatrixArg1.a = d.a;
		_helpMatrixArg1.c = d.c;
		_helpMatrixArg1.tx = d.tx;
		_helpMatrixArg1.b = d.b;
		_helpMatrixArg1.d = d.d;
		_helpMatrixArg1.ty = d.ty;
		_helpMatrixArg2.a = c.a;
		_helpMatrixArg2.c = c.c;
		_helpMatrixArg2.tx = c.tx;
		_helpMatrixArg2.b = c.b;
		_helpMatrixArg2.d = c.d;
		_helpMatrixArg2.ty = c.ty;
		out.a = ((_helpMatrixArg1.a * _helpMatrixArg2.a) + (_helpMatrixArg1.c * _helpMatrixArg2.b));
		out.b = ((_helpMatrixArg1.b * _helpMatrixArg2.a) + (_helpMatrixArg1.d * _helpMatrixArg2.b));
		out.c = ((_helpMatrixArg1.a * _helpMatrixArg2.c) + (_helpMatrixArg1.c * _helpMatrixArg2.d));
		out.d = ((_helpMatrixArg1.b * _helpMatrixArg2.c) + (_helpMatrixArg1.d * _helpMatrixArg2.d));
		out.tx = (((_helpMatrixArg1.a * _helpMatrixArg2.tx) + (_helpMatrixArg1.c * _helpMatrixArg2.ty)) + _helpMatrixArg1.tx);
		out.ty = (((_helpMatrixArg1.b * _helpMatrixArg2.tx) + (_helpMatrixArg1.d * _helpMatrixArg2.ty)) + _helpMatrixArg1.ty);
		return (out);
	}

	public static function MulJAVec2X(m:JAMatrix3, x:Float, y:Float):Float {
		return ((((m.a * x) + (m.c * y)) + m.tx));
	}

	public static function MulJAVec2Y(m:JAMatrix3, x:Float, y:Float):Float {
		return ((((m.b * x) + (m.d * y)) + m.ty));
	}

	public static function cloneTo(sourceMatrix:JAMatrix3, newMatrix:JAMatrix3):Void {
		sourceMatrix.a = newMatrix.a;
		sourceMatrix.c = newMatrix.c;
		sourceMatrix.tx = newMatrix.tx;
		sourceMatrix.b = newMatrix.b;
		sourceMatrix.d = newMatrix.d;
		sourceMatrix.ty = newMatrix.ty;
	}

//public function clone(from:JAMatrix3):JAMatrix3
//{
//	this.a = from.a;
//	this.b = from.b;
//	this.c = from.c;
//	this.d = from.d;
//	this.tx = from.tx;
//	this.ty = from.ty;
//}

	public function copy(from:JAMatrix3):Void {
		this.a = from.a;
		this.c = from.c;
		this.tx = from.tx;
		this.b = from.b;
		this.d = from.d;
		this.ty = from.ty;
	}

	public function ZeroMatrix():Void {
		a = 0;
		c = 0;
		tx = 0;
		b = 0;
		d = 0;
		ty = 0;
	}

	public function LoadIdentity():Void {
		a = 1;
		c = 0;
		tx = 0;
		b = 0;
		d = 1;
		ty = 0;
	}
}