// Decompiled by AS3 Sorcerer 2.20
// http://www.as3sorcerer.com/

//com.flengine.context.FBlendMode

package com.flengine.context
{
    import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import com.flengine.fl2d;
	use namespace fl2d;

    public class FBlendMode 
    {

        public static const NONE:int = 0;
        public static const NORMAL:int = 1;
        public static const ADD:int = 2;
        public static const MULTIPLY:int = 3;
        public static const SCREEN:int = 4;
        public static const ERASE:int = 5;

        //private static var blendFactors:Array = [[["one", "zero"], ["sourceAlpha", "oneMinusSourceAlpha"], ["sourceAlpha", "destinationAlpha"], ["destinationColor", "oneMinusSourceAlpha"], ["sourceAlpha", "one"], ["zero", "oneMinusSourceAlpha"]], [["one", "zero"], ["one", "oneMinusSourceAlpha"], ["one", "one"], ["destinationColor", "oneMinusSourceAlpha"], ["one", "oneMinusSourceColor"], ["zero", "oneMinusSourceAlpha"]]];
		private static var blendFactors:Array = 
			[
				[
					[Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO], 
					[Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA], 
					[Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.DESTINATION_ALPHA], 
					[Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA], 
					[Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE], 
					[Context3DBlendFactor.ZERO, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA]
				], 
				[
					[Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO], 
					[Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA], 
					[Context3DBlendFactor.ONE, Context3DBlendFactor.ONE], 
					[Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA], 
					[Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR], 
					[Context3DBlendFactor.ZERO, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA]
				]
			];

        public static function addBlendMode(p_normalFactors:Array, p_premultipliedFactors:Array):int
        {
            blendFactors[0].push(p_normalFactors);
            blendFactors[1].push(p_premultipliedFactors);
            return (blendFactors[0].length);
        }

        fl2d static function setBlendMode(p_context:Context3D, p_mode:int, p_premultiplied:Boolean):void
        {
            p_context.setBlendFactors(blendFactors[int(p_premultiplied)][p_mode][0], blendFactors[int(p_premultiplied)][p_mode][1]);
        }


    }
}//package com.flengine.context

