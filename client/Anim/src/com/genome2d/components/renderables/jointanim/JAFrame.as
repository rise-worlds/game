package com.genome2d.components.renderables.jointanim
{	
	public class JAFrame
	{
		public var hasStop:Boolean;
		public var commandVector:Vector.<JACommand>;
		public var frameObjectPosVector:Vector.<JAObjectPos>;
		
		public function JAFrame()
		{
			commandVector = new Vector.<JACommand>();
			frameObjectPosVector = new Vector.<JAObjectPos>();
		}
	
	}
}