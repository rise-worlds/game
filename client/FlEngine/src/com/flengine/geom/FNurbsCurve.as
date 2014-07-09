// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.geom.FNurbsCurve

package com.flengine.geom
{
    import __AS3__.vec.Vector;
    import flash.geom.Point;

    public class FNurbsCurve extends FCurve 
    {

        public var knot:Array;
        protected var _d:int;

        public function FNurbsCurve(p_points:Vector.<Number>=null, p_degree:int=3, p_knot:Array=null)
        {
            super(p_points);
            _d = p_degree;
            if (p_knot != null)
            {
                knot = p_knot;
            }
            else
            {
                generateKnotVector();
            };
        }

        public function generateKnotVector():void
        {
            var _local2:int;
            knot = [];
            var _local1:int = (_aPoints.length / 2);
            _local2 = 0;
            while (_local2 < (_d + _local1))
            {
                if (_local2 <= _d)
                {
                    knot.push(0);
                }
                else
                {
                    if (_local2 >= _local1)
                    {
                        knot.push(1);
                    }
                    else
                    {
                        knot.push(((_local2 - _d) / (_local1 - _d)));
                    };
                };
                _local2++;
            };
            knot.push(2);
        }

        public function set d(value:int):void
        {
            _d = value;
        }

        public function get d():int
        {
            return (_d);
        }

        override public function addPoint(p_x:Number, p_y:Number, p_index:Number=-1):void
        {
            super.addPoint(p_x, p_y, p_index);
            generateKnotVector();
        }

        private function Nik(i:int, k:int, t:Number):Number
        {
            if (k == 0)
            {
                if ((((t >= knot[i])) && ((t < knot[(i + 1)]))))
                {
                    return (1);
                };
                return (0);
            };
            var _local4:int;
            if (knot[(i + k)] != knot[i])
            {
                _local4 = (_local4 + (((t - knot[i]) / (knot[(i + k)] - knot[i])) * Nik(i, (k - 1), t)));
            };
            if (knot[((i + k) + 1)] != knot[(i + 1)])
            {
                _local4 = (_local4 + (((knot[((i + k) + 1)] - t) / (knot[((i + k) + 1)] - knot[(i + 1)])) * Nik((i + 1), (k - 1), t)));
            };
            return (_local4);
        }

        private function Nikd(i:int, k:int, t:Number):Number
        {
            if (k == 0)
            {
                return (0);
            };
            var _local4:int;
            if (knot[(i + k)] != knot[i])
            {
                _local4 = (_local4 + ((Nik(i, (k - 1), t) + ((t - knot[i]) * Nikd(i, (k - 1), t))) / (knot[(i + k)] - knot[i])));
            };
            if (knot[((i + k) + 1)] != knot[(i + 1)])
            {
                _local4 = (_local4 + ((-(Nik((i + 1), (k - 1), t)) + ((knot[((i + k) + 1)] - t) * Nikd((i + 1), (k - 1), t))) / (knot[((i + k) + 1)] - knot[(i + 1)])));
            };
            return (_local4);
        }

        override public function getNormalAtDistance(t:Number):Point
        {
            var _local4:int;
            var _local3:Number;
            var _local2:Point = new Point();
            _local4 = 0;
            while (_local4 < _aPoints.length)
            {
                _local3 = Nikd((_local4 / 2), d, t);
                _local2.x = (_local2.x + (_aPoints[(_local4 + 1)] * _local3));
                _local2.y = (_local2.y - (_aPoints[_local4] * _local3));
                _local4 = (_local4 + 2);
            };
            return (_local2);
        }

        override public function interpolateByDistance(t:Number):Point
        {
            var _local4:int;
            var _local3:Number;
            var _local2:Point = new Point();
            _local4 = 0;
            while (_local4 < _aPoints.length)
            {
                _local3 = Nik((_local4 / 2), _d, t);
                _local2.x = (_local2.x + (_aPoints[_local4] * _local3));
                _local2.y = (_local2.y + (_aPoints[(_local4 + 1)] * _local3));
                _local4 = (_local4 + 2);
            };
            return (_local2);
        }


    }
}//package com.flengine.geom

