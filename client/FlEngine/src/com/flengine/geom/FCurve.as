// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.geom.FCurve

package com.flengine.geom
{
    import __AS3__.vec.Vector;
    import flash.geom.Point;
    import flash.display.Graphics;

    public class FCurve 
    {

        protected var _nNormalEpsilon:Number = 0.001;
        protected var _bLengthDirty:Boolean = true;
        protected var _aPoints:Vector.<Number>;
        protected var _nLength:Number = 0;

        public function FCurve(p_points:Vector.<Number>)
        {
            if (p_points == null)
            {
                _aPoints = new Vector.<Number>();
            }
            else
            {
                _aPoints = p_points;
            };
        }

        public function get length():Number
        {
            var _local1:Number;
            var _local4:Number;
            var _local2 = null;
            var _local3 = null;
            if (_bLengthDirty)
            {
                _nLength = 0;
                _local1 = (1 / _aPoints.length);
                _local4 = 0;
                while (_local4 < 100)
                {
                    _local2 = interpolateByDistance((_local4 * _local1));
                    if (_local3 != null)
                    {
                        _nLength = (_nLength + Point.distance(_local3, _local2));
                    };
                    _local3 = _local2;
                    _local4++;
                };
                _bLengthDirty = false;
            };
            return (_nLength);
        }

        public function set points(p_points:Vector.<Number>):void
        {
            _aPoints = p_points;
            _bLengthDirty = true;
        }

        public function get points():Vector.<Number>
        {
            return (_aPoints);
        }

        public function addPoint(p_x:Number, p_y:Number, p_index:Number=-1):void
        {
            if (p_index == -1)
            {
                _aPoints.push(p_x, p_y);
            }
            else
            {
                _aPoints.splice((p_index * 2), 0, p_x, p_y);
            };
            _bLengthDirty = true;
        }

        public function removePoint(p_index:Number):void
        {
            _aPoints.splice(p_index, 1);
        }

        public function getNormalAtDistance(t:Number):Point
        {
            var _local3:Point = interpolateByDistance((t - _nNormalEpsilon));
            var _local2:Point = interpolateByDistance((t + _nNormalEpsilon));
            var _local5:Number = (_local2.x - _local3.x);
            var _local4:Number = (_local2.y - _local3.y);
            return (new Point(_local4, -(_local5)));
        }

        public function interpolateByDistance(t:Number):Point
        {
            return (new Point());
        }

        public function drawPath(p_target:Graphics, p_points:Number):void
        {
            var _local3:Number;
            var _local5:Number;
            var _local4 = null;
            _local3 = (1 / (p_points - 1));
            _local5 = 0;
            while (_local5 < p_points)
            {
                _local4 = interpolateByDistance((_local5 * _local3));
                if (_local5 == 0)
                {
                    p_target.moveTo(_local4.x, _local4.y);
                }
                else
                {
                    p_target.lineTo(_local4.x, _local4.y);
                };
                _local5++;
            };
        }


    }
}//package com.flengine.geom

