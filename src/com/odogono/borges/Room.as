package com.odogono.borges
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.math.Number3D;
	import away3d.core.utils.Init;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.Plane;
	
	import com.odogono.utils.MathUtils;
	
	
	
	
	public class Room extends ObjectContainer3D
	{
		
		public static const NORTH:int	= 0;
		public static const EAST:int	= 1;
		public static const SOUTH:int	= 2;
		public static const WEST:int	= 3;
		
		
		private var plane:Plane;
	
		public var doors:Array;
		
		public var wallDoors:Array = new Array(4);
		
		public var entryDoor:Door;
		
		/**
		 * Contains the arrows that make up the room
		 */
		public var walls:Array = new Array();
		
		
		public static var roomCount:int = 0;
		public var roomNo:int = 0;
		
		public function Room( init:Object )
		{
			var i:int = 0;
			var door:Door;
			var initObject:Init = Init.parse(init);
			var initDoorDir:int = -1;
			
			var mat:ColorMaterial = new ColorMaterial(0xff333333 );
			init.material = mat;
			
			roomNo = roomCount++;
			
			plane = new Plane(init);
			
			this.addChild(plane);
			
			doors = new Array();
			
			for( i = 0;i<wallDoors.length;i++ )
				wallDoors[i] = [];
			
			var initDoor:Door = initObject.getObject("initDoor",Door) as Door;
			
			if( initDoor )
			{
				initDoorDir = inverseDirection(initDoor.wall); 
				entryDoor = door = createDoor( initDoorDir );
				door.initial = true;
				wallDoors[door.wall].push( door );
				doors.push(door);
			}
			
			
			var targetDoorCount:int = Main.random.nextIntRange(2,4);
			
			while( doors.length < targetDoorCount )
			{
				var candidate:int = Main.random.nextIntRange(0,3);
				
				if( wallDoors[candidate].length <= 0 )
				{
					door = createDoor(candidate);
					wallDoors[door.wall].push( door );
					doors.push(door);
				}
			}
			
			
			// create from 1 to 3 other doors
//			for( i=1;i<Main.random.nextIntRange(2,4);i++ )
//			{
//				for(var d:int=0;d<4;d++ )
//				{
//					if( d == initDoorDir )
//						continue;
//					
//					if( Main.random.nextIntRange(0,100) > 50 )
//					{
//						door = createDoor(d);
//						wallDoors[door.wall].push( door );
//						doors.push(door);
//					}
//				}
//			}
			
//			for( i=0;i<4;i++ )
//			{
//				if( i == initDoorDir )
//					continue;
//				
//				if( wallDoors[i].length<=0 && Main.random.nextIntRange(0,100) > 50 || (i == 3 && doors.length <= 1 ) )
//				{
//					door = createDoor(i);
//					wallDoors[door.wall].push( door );
//					doors.push(door);
//				}
//			}
			
			if( initDoor )
			{
				var normal:Number3D = Room.directionNormal(initDoor.wall);
				MathUtils.mul(normal, Main.random.nextDoubleRange(1000, 4000) );
				// var tpos:Door = wallDoors[initDoorDir][0];
				
				moveTo( 
					initDoor.room.position.x+normal.x + (initDoor.x - entryDoor.x), 
					0, 
					initDoor.room.position.z+normal.z + (initDoor.y - entryDoor.y));
			}
		}
		
		
		public function getRandomDoor():Door
		{
			while( true )
			{
				var result:Door = doors[Main.random.nextIntRange(0,doors.length-1)];
				
				if( result.initial == false )
					return result;
			}
			
			return null;
		}
		
		
		public function destroy():void
		{
			Main.log("destroying room " + roomNo);
			// clear the walls
			for each( var wall:BorgesArrow in walls )
				BorgesArrowManager.destroy(wall);
			
			walls = null;
			
			// clear the doors
			for each( var door:Door in doors )
			{
				for each( var edge:BorgesArrow in door.object3D.children )
				{
					BorgesArrowManager.destroy(edge);
				}
				
				Main.viewDoors.scene.removeChild( door.object3D );
				
				
				if( door.exitArrow )
				{
					BorgesArrowManager.destroy( door.exitArrow );
				}//*/
				
				door.room = null;
			}
			
			doors = null;
			
			
			this.removeChild(plane);
			plane = null;
			wallDoors = null;
		}
		
		public function getWallSpans( wall:int, margin:int = 0 ):Array
		{
			var result:Array;
			var i:int = 0;
			var door:Door;
			var basic:Array
			var base:Number;
			
			switch( wall )
			{
				case NORTH:
				case SOUTH:
					base = position.x;
					break;
				case EAST:
				case WEST:
					base = position.z;
					break;
			}
			
			switch( wall )
			{
				case NORTH: basic = [ base-halfWidth, base+halfWidth ]; break; // x
				case SOUTH: basic = [ base+halfWidth, base-halfWidth ]; break; // x
				case EAST: basic = [ base+halfHeight-margin, base-halfHeight ];break; // z
				case WEST: basic = [ base-halfHeight-margin, base+halfHeight ];break; // z
			}
			
			if( wallDoors[wall].length <= 0 )
				return basic;
			else
			{
				result = []
				result.push( basic[0] );
				
				for each( door in wallDoors[wall] )
				{
					result.push( base + door.position - (Door.WIDTH/2) - margin );
					result.push( base + door.position + (Door.WIDTH/2) + margin);
				}
				
				result.push( basic[1] );
			}
			
//			if( wall == WEST )
//				result = [ -halfWidth-margin, -200, 200, halfHeight ];
			
			if( basic[0] < basic[1] )
				result.sort(Array.NUMERIC);
			else
				result.sort(Array.DESCENDING | Array.NUMERIC);
			
			
				
			return result;
		}
		
		private function createDoor( wall:int ):Door
		{
			var result:Door = new Door();
			var margin:Number = Door.WIDTH+100;
			
			result.room = this;
			result.wall = wall;
			
			switch(result.wall)
			{
				case NORTH:
					result.y = (height/2.0);
					result.x = Main.random.nextDoubleRange( (-halfWidth)+margin, halfWidth - margin );
					break;
					
				case SOUTH:
					result.y = -(height/2.0);
					result.x = Main.random.nextDoubleRange( (-halfWidth)+margin, halfWidth - margin );
					break;
					
				case WEST:
					result.x = -(width/2.0);
					result.y = Main.random.nextDoubleRange( (-halfHeight)+margin, halfHeight - margin );
					break;
					
				case EAST:
					result.x = (width/2.0);
					result.y = Main.random.nextDoubleRange( (-halfHeight)+margin, halfHeight - margin );
					break;
			}
			
//			Main.log("door created on " + result.wall + " wall at " + result.x + "," + result.y );
			
			return result;
		}
		
		
		public static function inverseDirection(dir:int):int
		{
			switch(dir)
			{
				case NORTH: return SOUTH;
				case EAST: return WEST;
				case SOUTH: return NORTH;
				case WEST: return EAST;
				default: return -1;
			}
		}
		
		public static function directionNormal(dir:int):Number3D
		{
			switch(dir)
			{
				case NORTH: return new Number3D(0,0,1);
				case SOUTH: return new Number3D(0,0,-1);
				case WEST: return new Number3D(-1,0,0);
				case EAST: default: return new Number3D(1,0,0);
			}
		}
		
		public function get halfWidth():Number
		{
			return plane.width/2.0;
		}
		
		public function get halfHeight():Number
		{
			return plane.height/2.0;
		}
		
		public function get height():Number
		{
			return plane.height;
		}
		
		public function get width():Number
		{
			return plane.width;
		}

	}
}