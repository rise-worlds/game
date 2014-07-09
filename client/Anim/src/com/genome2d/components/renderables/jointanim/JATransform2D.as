// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.components.renderables.jointanim.JATransform2D

package com.genome2d.components.renderables.jointanim
{
    public class JATransform2D extends JAMatrix3 
    {

        private static var _helpMatrix:JAMatrix3 = new JAMatrix3();


        public function Scale(sx:Number, sy:Number):void
        {
            _helpMatrix.LoadIdentity();
            _helpMatrix.m00 = sx;
            _helpMatrix.m11 = sy;
            MulJAMatrix3(_helpMatrix, this, this);
        }

        public function Translate(tx:Number, ty:Number):void
        {
            _helpMatrix.LoadIdentity();
            _helpMatrix.m02 = tx;
            _helpMatrix.m12 = ty;
            MulJAMatrix3(_helpMatrix, this, this);
        }

        public function RotateDeg(rot:Number):void
        {
            RotateRad((0.0174532925199433 * rot));
        }

        public function RotateRad(rot:Number):void
        {
            _helpMatrix.LoadIdentity();
            var _local3:Number = Math.sin(rot);
            var _local2:Number = Math.cos(rot);
            _helpMatrix.m00 = _local2;
            _helpMatrix.m01 = _local3;
            _helpMatrix.m10 = -(_local3);
            _helpMatrix.m11 = _local2;
            MulJAMatrix3(_helpMatrix, this, this);
        }


    }
}//package com.flengine.components.renderables.jointanim

