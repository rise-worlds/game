package com.genome2d.components.renderables.jointanim
{	
	public class JAAnimDef
	{
		
		public var mainSpriteDef:JASpriteDef;
		public var spriteDefVector:Vector.<JASpriteDef>;
		public var objectNamePool:Array;
		
		public function JAAnimDef()
		{
			mainSpriteDef = null;
			spriteDefVector = new Vector.<JASpriteDef>();
			objectNamePool = [];
		}
	
	}
}