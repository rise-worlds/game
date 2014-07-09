// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.rand.Hermite

package com.flengine.rand
{
    import __AS3__.vec.Vector;

    public class Hermite 
    {

        public static const NUM_DIMS:int = 4;

        public var points:Vector.<HermitePoint>;
        private var q:Vector.<Vector.<Number>>;
        private var z:Vector.<Number>;
        private var mPieces:Vector.<HermitePiece>;
        private var mIsBuilt:Boolean = false;
        private var mXSub:Vector.<Number>;

        public function Hermite()
        {
            var _local1:int;
            points = new Vector.<HermitePoint>();
            mPieces = new Vector.<HermitePiece>();
            mXSub = new Vector.<Number>(2, true);
            super();
            q = new Vector.<Vector.<Number>>(4, true);
            _local1 = 0;
            while (_local1 < 4)
            {
                q[_local1] = new Vector.<Number>(4, true);
                _local1++;
            };
            z = new Vector.<Number>(4, true);
        }

        public function rebuild():void
        {
            mIsBuilt = false;
        }

        public function evaluate(inX:Number):Number
        {
            var _local6:int;
            var _local2 = null;
            var _local5 = null;
            var _local4 = null;
            if (!mIsBuilt)
            {
                if (!build())
                {
                    return (0);
                };
                mIsBuilt = true;
            };
            var _local3:int = mPieces.length;
            _local6 = 0;
            while (_local6 < _local3)
            {
                if (inX < points[(_local6 + 1)].x)
                {
                    _local2 = points[_local6];
                    _local5 = points[(_local6 + 1)];
                    _local4 = mPieces[_local6];
                    return (evaluatePiece(inX, _local2.x, _local5.x, _local4));
                };
                _local6++;
            };
            return (points[(points.length - 1)].fx);
        }

        private function build():Boolean
        {
            var _local3:int;
            mPieces.length = 0;
            var _local1:int = points.length;
            if (_local1 < 2)
            {
                return (false);
            };
            var _local2:int = (_local1 - 1);
            _local3 = 0;
            while (_local3 < _local2)
            {
                mPieces[_local3] = createPiece(_local3);
                _local3++;
            };
            return (true);
        }

        private function createPiece(offset:int):HermitePiece
        {
            var _local6:int;
            var _local2 = null;
            var _local5:int;
            var _local3:int;
            _local6 = 0;
            while (_local6 <= 1)
            {
                _local2 = points[(offset + _local6)];
                _local5 = (2 * _local6);
                z[_local5] = _local2.x;
                z[(_local5 + 1)] = _local2.x;
                q[_local5][0] = _local2.fx;
                q[(_local5 + 1)][0] = _local2.fx;
                q[(_local5 + 1)][1] = _local2.fxp;
                if (_local6 > 0)
                {
                    q[_local5][1] = ((q[_local5][0] - q[(_local5 - 1)][0]) / (z[_local5] - z[(_local5 - 1)]));
                };
                _local6++;
            };
            _local6 = 2;
            while (_local6 < 4)
            {
                _local3 = 2;
                while (_local3 <= _local6)
                {
                    q[_local6][_local3] = ((q[_local6][(_local3 - 1)] - q[(_local6 - 1)][(_local3 - 1)]) / (z[_local6] - z[(_local6 - _local3)]));
                    _local3++;
                };
                _local6++;
            };
            var _local4:HermitePiece = new HermitePiece();
            _local6 = 0;
            while (_local6 < 4)
            {
                _local4.coeffs[_local6] = q[_local6][_local6];
                _local6++;
            };
            return (_local4);
        }

        private function evaluatePiece(inX:Number, x0:Number, x1:Number, piece:HermitePiece):Number
        {
            var _local7:int;
            mXSub[0] = (inX - x0);
            mXSub[1] = (inX - x1);
            var _local5 = 1;
            var _local6:Number = piece.coeffs[0];
            _local7 = 1;
            while (_local7 < 4)
            {
                _local5 = (_local5 * mXSub[((_local7 - 1) / 2)]);
                _local6 = (_local6 + (_local5 * piece.coeffs[_local7]));
                _local7++;
            };
            return (_local6);
        }


    }
}//package com.flengine.rand

