package com.genome2d.components.renderables.jointanim
{	
	public class JASpriteDef
	{
		public var name:String;
		public var animRate:Number;
		public var workAreaStart:int;
		public var workAreaDuration:int;
		public var frames:Vector.<JAFrame>;
		public var objectDefVector:Vector.<JAObjectDef>;
		public var label:Object;
		
		public function JASpriteDef()
		{
			frames = new Vector.<JAFrame>();
			objectDefVector = new Vector.<JAObjectDef>();
			label = {};
		}
		
		public function GetLabelFrame(theLabel:String):int
		{
			var key:String = theLabel.toUpperCase();
			if (label[key] != null)
			{
				return (label[key]);
			}
			
			return -1;
		}
	
	}
}