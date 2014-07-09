// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.jointanim.JATransform

package com.flengine.components.renderables.jointanim
{
    public class JATransform 
    {

        private static var _m00:Number;
        private static var _m01:Number;
        private static var _m10:Number;
        private static var _m11:Number;
        private static var _m02:Number;
        private static var _m12:Number;
        private static var __m00:Number;
        private static var __m01:Number;
        private static var __m10:Number;
        private static var __m11:Number;
        private static var __m02:Number;
        private static var __m12:Number;

        public var matrix:JAMatrix3;

        public function JATransform()
        {
            matrix = new JAMatrix3();
        }

        public function clone(from:JATransform):void
        {
            this.matrix.clone(from.matrix);
        }

        public function TransformSrc(theSrcTransform:JATransform, outTransform:JATransform):JATransform
        {
            __m00 = theSrcTransform.matrix.m00;
            __m01 = theSrcTransform.matrix.m01;
            __m10 = theSrcTransform.matrix.m10;
            __m11 = theSrcTransform.matrix.m11;
            __m02 = theSrcTransform.matrix.m02;
            __m12 = theSrcTransform.matrix.m12;
            _m00 = matrix.m00;
            _m01 = matrix.m01;
            _m10 = matrix.m10;
            _m11 = matrix.m11;
            _m02 = matrix.m02;
            _m12 = matrix.m12;
            outTransform.matrix.m00 = ((_m00 * __m00) + (_m01 * __m10));
            outTransform.matrix.m01 = ((_m00 * __m01) + (_m01 * __m11));
            outTransform.matrix.m10 = ((_m10 * __m00) + (_m11 * __m10));
            outTransform.matrix.m11 = ((_m10 * __m01) + (_m11 * __m11));
            outTransform.matrix.m02 = ((_m02 + (_m00 * __m02)) + (_m01 * __m12));
            outTransform.matrix.m12 = ((_m12 + (_m10 * __m02)) + (_m11 * __m12));
            return (outTransform);
        }

        public function InterpolateTo(theNextTransform:JATransform, thePct:Number, outTransform:JATransform):JATransform
        {
            __m00 = theNextTransform.matrix.m00;
            __m01 = theNextTransform.matrix.m01;
            __m10 = theNextTransform.matrix.m10;
            __m11 = theNextTransform.matrix.m11;
            __m02 = theNextTransform.matrix.m02;
            __m12 = theNextTransform.matrix.m12;
            _m00 = matrix.m00;
            _m01 = matrix.m01;
            _m10 = matrix.m10;
            _m11 = matrix.m11;
            _m02 = matrix.m02;
            _m12 = matrix.m12;
            outTransform.matrix.m00 = ((_m00 * (1 - thePct)) + (__m00 * thePct));
            outTransform.matrix.m01 = ((_m01 * (1 - thePct)) + (__m01 * thePct));
            outTransform.matrix.m10 = ((_m10 * (1 - thePct)) + (__m10 * thePct));
            outTransform.matrix.m11 = ((_m11 * (1 - thePct)) + (__m11 * thePct));
            outTransform.matrix.m02 = ((_m02 * (1 - thePct)) + (__m02 * thePct));
            outTransform.matrix.m12 = ((_m12 * (1 - thePct)) + (__m12 * thePct));
            return (outTransform);
        }


    }
}//package com.flengine.components.renderables.jointanim

