// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.jointanim.JAMatrix3

package com.genome2d.components.renderables.jointanim
{
    import __AS3__.vec.Vector;
    import flash.geom.Matrix3D;

    public class JAMatrix3 
    {

        private static var _helpMatrixArg1:JAMatrix3 = new (JAMatrix3)();
        private static var _helpMatrixArg2:JAMatrix3 = new (JAMatrix3)();
        private static var _helpMatrix3DVector1:Vector.<Number> = Vector.<Number>([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]);
        private static var _helpMatrix3DVector2:Vector.<Number> = Vector.<Number>([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]);
        private static var _helpMatrix3DArg1:Matrix3D = new Matrix3D();
        private static var _helpMatrix3DArg2:Matrix3D = new Matrix3D();

        public var m00:Number;
        public var m01:Number;
        public var m02:Number;
        public var m10:Number;
        public var m11:Number;
        public var m12:Number;

        public function JAMatrix3()
        {
            LoadIdentity();
        }

        public static function MulJAMatrix3(d:JAMatrix3, c:JAMatrix3, out:JAMatrix3):JAMatrix3
        {
            _helpMatrixArg1.m00 = d.m00;
            _helpMatrixArg1.m01 = d.m01;
            _helpMatrixArg1.m02 = d.m02;
            _helpMatrixArg1.m10 = d.m10;
            _helpMatrixArg1.m11 = d.m11;
            _helpMatrixArg1.m12 = d.m12;
            _helpMatrixArg2.m00 = c.m00;
            _helpMatrixArg2.m01 = c.m01;
            _helpMatrixArg2.m02 = c.m02;
            _helpMatrixArg2.m10 = c.m10;
            _helpMatrixArg2.m11 = c.m11;
            _helpMatrixArg2.m12 = c.m12;
            out.m00 = ((_helpMatrixArg1.m00 * _helpMatrixArg2.m00) + (_helpMatrixArg1.m01 * _helpMatrixArg2.m10));
            out.m10 = ((_helpMatrixArg1.m10 * _helpMatrixArg2.m00) + (_helpMatrixArg1.m11 * _helpMatrixArg2.m10));
            out.m01 = ((_helpMatrixArg1.m00 * _helpMatrixArg2.m01) + (_helpMatrixArg1.m01 * _helpMatrixArg2.m11));
            out.m11 = ((_helpMatrixArg1.m10 * _helpMatrixArg2.m01) + (_helpMatrixArg1.m11 * _helpMatrixArg2.m11));
            out.m02 = (((_helpMatrixArg1.m00 * _helpMatrixArg2.m02) + (_helpMatrixArg1.m01 * _helpMatrixArg2.m12)) + _helpMatrixArg1.m02);
            out.m12 = (((_helpMatrixArg1.m10 * _helpMatrixArg2.m02) + (_helpMatrixArg1.m11 * _helpMatrixArg2.m12)) + _helpMatrixArg1.m12);
            return (out);
        }

        public static function MulJAMatrix3_M3D(c:Matrix3D, d:JATransform2D, out:JATransform2D):JATransform2D
        {
            _helpMatrix3DVector1[0] = d.m00;
            _helpMatrix3DVector1[1] = d.m10;
            _helpMatrix3DVector1[4] = d.m01;
            _helpMatrix3DVector1[5] = d.m11;
            _helpMatrix3DVector1[12] = d.m02;
            _helpMatrix3DVector1[13] = d.m12;
            _helpMatrix3DArg1.copyRawDataFrom(_helpMatrix3DVector1);
            _helpMatrix3DArg1.prepend(c);
            _helpMatrix3DArg1.copyRawDataTo(_helpMatrix3DVector1);
            out.m00 = _helpMatrix3DVector1[0];
            out.m10 = _helpMatrix3DVector1[1];
            out.m01 = _helpMatrix3DVector1[4];
            out.m11 = _helpMatrix3DVector1[5];
            out.m02 = _helpMatrix3DVector1[12];
            out.m12 = _helpMatrix3DVector1[13];
            return (out);
        }

        public static function MulJAMatrix3_2D(d:JAMatrix3, c:JATransform2D, out:JATransform2D):JATransform2D
        {
            _helpMatrixArg1.m00 = d.m00;
            _helpMatrixArg1.m01 = d.m01;
            _helpMatrixArg1.m02 = d.m02;
            _helpMatrixArg1.m10 = d.m10;
            _helpMatrixArg1.m11 = d.m11;
            _helpMatrixArg1.m12 = d.m12;
            _helpMatrixArg2.m00 = c.m00;
            _helpMatrixArg2.m01 = c.m01;
            _helpMatrixArg2.m02 = c.m02;
            _helpMatrixArg2.m10 = c.m10;
            _helpMatrixArg2.m11 = c.m11;
            _helpMatrixArg2.m12 = c.m12;
            out.m00 = ((_helpMatrixArg1.m00 * _helpMatrixArg2.m00) + (_helpMatrixArg1.m01 * _helpMatrixArg2.m10));
            out.m10 = ((_helpMatrixArg1.m10 * _helpMatrixArg2.m00) + (_helpMatrixArg1.m11 * _helpMatrixArg2.m10));
            out.m01 = ((_helpMatrixArg1.m00 * _helpMatrixArg2.m01) + (_helpMatrixArg1.m01 * _helpMatrixArg2.m11));
            out.m11 = ((_helpMatrixArg1.m10 * _helpMatrixArg2.m01) + (_helpMatrixArg1.m11 * _helpMatrixArg2.m11));
            out.m02 = (((_helpMatrixArg1.m00 * _helpMatrixArg2.m02) + (_helpMatrixArg1.m01 * _helpMatrixArg2.m12)) + _helpMatrixArg1.m02);
            out.m12 = (((_helpMatrixArg1.m10 * _helpMatrixArg2.m02) + (_helpMatrixArg1.m11 * _helpMatrixArg2.m12)) + _helpMatrixArg1.m12);
            return (out);
        }

        public static function MulJAVec2X(m:JAMatrix3, x:Number, y:Number):Number
        {
            return ((((m.m00 * x) + (m.m01 * y)) + m.m02));
        }

        public static function MulJAVec2Y(m:JAMatrix3, x:Number, y:Number):Number
        {
            return ((((m.m10 * x) + (m.m11 * y)) + m.m12));
        }

        public static function cloneTo(sourceMatrix:JAMatrix3, newMatrix:JAMatrix3):void
        {
            sourceMatrix.m00 = newMatrix.m00;
            sourceMatrix.m01 = newMatrix.m01;
            sourceMatrix.m02 = newMatrix.m02;
            sourceMatrix.m10 = newMatrix.m10;
            sourceMatrix.m11 = newMatrix.m11;
            sourceMatrix.m12 = newMatrix.m12;
        }


        public function clone(from:JAMatrix3):void
        {
            this.m00 = from.m00;
            this.m01 = from.m01;
            this.m02 = from.m02;
            this.m10 = from.m10;
            this.m11 = from.m11;
            this.m12 = from.m12;
        }

        public function ZeroMatrix():void
        {
            m00 = 0;
            m01 = 0;
            m02 = 0;
            m10 = 0;
            m11 = 0;
            m12 = 0;
        }

        public function LoadIdentity():void
        {
            m00 = 1;
            m01 = 0;
            m02 = 0;
            m10 = 0;
            m11 = 1;
            m12 = 0;
        }


    }
}//package com.flengine.components.renderables.jointanim

