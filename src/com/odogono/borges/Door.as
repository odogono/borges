package com.odogono.borges
{
	import away3d.containers.ObjectContainer3D;
	
	
	import flash.geom.Point;
	
	public class Door extends Point
	{
		public static const WIDTH:int = 150;
		public static const HEIGHT:int = 300;
		
		
		public var room:Room;
		
		public var wall:int = Room.NORTH;
		
		public var exitArrow:BorgesArrow;
		
		public var object3D:ObjectContainer3D;
		
		/**
		 * Whether this is a door that is entered
		 */
		public var initial:Boolean = false;
		
		public function Door()
		{
		}

		public function get position():Number
		{
			switch(wall)
			{
				case Room.NORTH:
				case Room.SOUTH:
					return this.x;
				case Room.WEST:
				case Room.EAST:
					return this.y;
			}
			
			return this.x;
		}
	}
}