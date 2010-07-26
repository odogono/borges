package com.odogono.borges 
{
	import away3d.cameras.Camera3D;
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.core.draw.*;
	import away3d.core.light.*;
	import away3d.core.math.*;
	import away3d.core.render.*;
	import away3d.events.*;
	import away3d.lights.*;
	import away3d.loaders.*;
	import away3d.materials.*;
	import away3d.primitives.*;
	import away3d.sprites.*;
	
	import caurina.transitions.Tweener;
	
	import com.odogono.utils.MathUtils;
	import de.polygonal.math.PM_PRNG;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.ui.*;
	import flash.utils.*;
	

	[SWF(width='800',height='600',backgroundColor='0xFFFFFF',frameRate='30')]
	public class Main extends Sprite
	{
		public static var screenwidth:Number = 800;
		public static var screenheight:Number = 600;
		
		
		public static var instance:Main;
		public static var random:PM_PRNG = new PM_PRNG();
		
		private static var redraw:Boolean = false;
		
		public static var cameraTarget:Object3D;
		public static var camera:Camera3D;
//		public var camera:HoverCamera3D;
		public var light:PointLight3D;
		
		
		public static var view:View3D;
		public static var viewSprites:View3D;
		public static var viewArrows:View3D;
		public static var viewRooms:View3D;
		public static var viewDoors:View3D;
		
		public static var timer:Timer;
		public static const FRAME_RATE:int = 40;
		public static const period:Number = 1000 / FRAME_RATE;
	    public static var beforeTime:int = 0;
	    public static var afterTime:int = 0;
	    public static var timeDiff:int = 0;
	    public static var sleepTime:int = 0;
	    public static var overSleepTime:int = 0;
	    public static var excess:int = 0;
	    
	    public static var deltaTime:Number;
	    //public static var lastTime:Number;
	    private static var _running:Boolean = false;
		public static var delayTime:Number = 0;
		public static var accruedTime:Number = 0;
		
	    
		public static var updates:int = 0;
		
		public static var tweenTime:int = 0;
		
		public static var currentRoom:Room;
		public static var nextRoom:Room;
		public static var previousRoom:Room;
		
		public static var movingToRoom:Boolean;
		
		/**
		 * Whether the whole moving from room to room
		 * thing is working
		 */
		public static var roomMoving:Boolean;
		
		public static var roomsVisited:int;
		
		public static var enterTime:int;
		public static var leaveTime:int;
		
//		public static var rooms:Array = new Array();
		
		
		public static const TRAVEL_TIME:int = 2;
		
		public static const COLOUR_WALL:int = 0;
		public static const COLOUR_DOOR:int = 1;
		public static const COLOUR_EXIT:int = 2;
		public static const COLOUR_EXIT_ACTIVE:int = 3;
		
		public static var palettes:Array =[
			[0xCCCCCC,0x555555,0xCCCCCC,0x111111],
			[0x69D2E7,0xA7DBD8,0xE0E4CC,0xF38630],
			[0xEBC88D,0x9A4E44,0x67B26D,0x701627,0x510725],
			[0xE8E4B4,0xBEB677,0xB18C58,0xB86751,0x594C46],
			[0xCBE86B,0x1C140D,0xF2E9E1,0xCBE86B],
			[0xDECFEB,0x804D6E,0x1A4D6F,0xA9E1F8],
			[0x39968A,0xE4B95E,0xF1DF75,0xE0F0C0,0xAFDFC7],
			[0xE8FD8E,0xEE0C49,0xF7858F,0xFFEEC0,0x93A49E],
			[0x829EA9,0x328FB0,0x9F1610,0xD6B264,0x61534A],
			[0xFFEBE6,0xFFC7B6,0xFFFBDB,0xFFF7BE,0xFCF09A],
			[0xFF0042,0xFF0044,0xFF2B1A,0xFE0000,0xFE0084],
			[0xEDF1E8,0x605C5B,0xC6010A,0x826D3F],
			[0xDFEDE7,0xCCE8E0,0xB6D3CC,0xC1E7E2,0xD8EDE9],
			[0x373636,0x59595E,0xBB1E09,0x7E7D7D,0xF7F6F5],
			[0xCE174B,0xDB234F,0xA3A3A3,0xB6DB23,0xC2E632],
			[0x4298C7,0x074769,0x03151F,0x452828,0xCF5D5D],
			[0xF774A4,0x69FC56,0xEDD53B,0xF09348,0x48F0D1],
			[0x504940,0x30332F,0x91866A,0xEBDEBF,0xF74D5B],
			[0xA55050,0x805858,0xCE3030,0xF01212],
			[0xEDDBF0,0x8893DB,0xD7ABCF,0xB38C69,0xC0C0C0]
		];
		
//		public static var colours:Array = [0xCCCCCC,0x555555,0x888888,0x111111];
		
		public static var colours:Array = [0x69D2E7,0xA7DBD8,0xE0E4CC,0xF38630];
		
		
		public function Main()
		{
			instance = this;
			stage.quality = StageQuality.LOW;
			
			//2144400885; 
			Main.random.seed = int(Math.random() * int.MAX_VALUE);
			Main.log("random: " + Main.random.seed );
			
			
			
			var dist:Number = 3000;
			
			cameraTarget = new Object3D();
			camera = new Camera3D({zoom:10, focus:100, x:dist, y:dist, z:-dist});
			

			light = new PointLight3D({ambient:0.5, diffuse:0.2, specular:2.5, brightness:0.5, distance:2000, x:10000, y:10000, z:5000});
			camera.lookAt( new Number3D(0,0,0) );
			
			viewRooms = new View3D({x:Main.screenwidth>>1,y:Main.screenheight>>1,renderer:Renderer.BASIC, camera:camera});
			viewDoors = new View3D({x:Main.screenwidth>>1,y:Main.screenheight>>1,renderer:Renderer.BASIC, camera:camera});
			view = viewArrows = new View3D({x:Main.screenwidth>>1,y:Main.screenheight>>1,renderer:Renderer.BASIC, camera:camera});
			
			addChild(viewRooms);
			addChild(viewArrows);
			addChild(viewDoors);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame,false,0,true);
			//lastTime = getTimer();
			delayTime = FRAME_RATE;
			
			new ResourceManager();
			ResourceManager.loadResources();
			
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			this.stage.addEventListener(Event.RESIZE, onResize);
			
		}
		
		
		
		public static function onResize(event:Event):void
		{
//			instance.x = (instance.stage.stageWidth/2);
//			instance.y = (instance.stage.stageHeight/2);
			
			viewRooms.x = instance.stage.stageWidth/2;
			viewRooms.y = instance.stage.stageHeight/2;
			
			viewDoors.x = instance.stage.stageWidth/2;
			viewDoors.y = instance.stage.stageHeight/2;
			
			viewArrows.x = instance.stage.stageWidth/2;
			viewArrows.y = instance.stage.stageHeight/2;
			
//			view.x=stage.width/2
//     		view.scaleX=((stage.width / 100) * (originalwidth / 100)); 
		}
		
		
		
//		public static var colours:Array = [ 0xC4533D,0xB8DEDE,0xC0CCC7,0x97B3B8,0xD1A477 ];
		
		
		public static function onReady():void
		{
			var arrow:Arrow;
			new BorgesArrowManager();
			
			BorgesArrowManager.template.dashed = false;
			BorgesArrowManager.template.length = 0;
			
			Tweener.getVersion();
			
//			Tweener.addTween(cameraTarget, {z:3000, time:4, transition:"easeInOutQuad"});
//			Tweener.addTween(camera, {z:5000, time:4, transition:"linear"});
						
			currentRoom = previousRoom = createRoom();
			camera.position = createRoomCameraPosition( currentRoom );
			
			roomMoving = true;
			displayRoom(currentRoom);
			
			
//			createRoom( {initDoor:room.wallDoors[Room.NORTH][0]} );
			
		}
		
		
		private static function createRoom(params:Object=null):Room
		{
			if( !params )
				params = new Object();
			
			var paletteIndex:int = 0;
			
			if( roomsVisited < 10 )
				paletteIndex = 0;
			else if( roomsVisited < 25 )
				paletteIndex = Main.random.nextIntRange(1, 5);
			else if( roomsVisited < 50 )
				paletteIndex = Main.random.nextIntRange(6, 9);
			else
				paletteIndex = Main.random.nextIntRange(0, palettes.length-1);
			
			colours = palettes[ paletteIndex ];
			Main.log("using palette " + paletteIndex );
			
			params.width = random.nextDoubleRange(800,2500);
			params.height = random.nextDoubleRange(600,2500);
			
			var room:Room = new Room(params);
			
//			rooms.push(room);
			
			return room;
		}
		
		
		private static function displayRoom(room:Room):Room
		{
			Main.log("displaying room " + room.roomNo );
			
			BorgesArrowManager.template.width = 100;
			createRoomDoors(room);
			BorgesArrowManager.template.width = 100;
			createRoomWalls(room);
			
			resetAutoTimer();
			
			return room;
		}
		
		public static function resetAutoTimer():void
		{
			enterTime = getTimer();
			leaveTime = Main.random.nextIntRange(100,2000);
			movingToRoom = false;
		}
		
		private static function moveToRoom( exitingDoor:Door):void
		{
			movingToRoom = true;
			
			var target:Number3D = new Number3D();
			nextRoom = createRoom( {initDoor:exitingDoor} );
			
			target.x = nextRoom.position.x+nextRoom.entryDoor.x;
			target.z = nextRoom.position.z+nextRoom.entryDoor.y;
			
//			Main.log("moving arrow from " 
//					+ exitingDoor.exitArrow.target 
//					+ " to " 
//					+ target 
//					+ " dist: " 
//					+ MathUtils.distance(exitingDoor.exitArrow.target,target) );
//			Main.log("origin: " + exitingDoor.exitArrow.origin );
			
			var distance:Number = MathUtils.distance(exitingDoor.exitArrow.target, target);
			Main.log("move dist: " + distance );
			
			
			exitingDoor.exitArrow.tweenTarget({ 
				x:target.x,
				z:target.z, time:Math.max(1.2,(distance/1000.0)),
				onComplete: onExitArrowArrive, onCompleteParams:[ exitingDoor.exitArrow, distance ] });
				
				/*function():void
				{ 
					previousRoom = currentRoom;
					currentRoom = nextRoom;
					displayRoom(currentRoom);
					
					// arrow from previous to next
					Tweener.addTween(exitingDoor.exitArrow.origin,
						{ x:currentRoom.position.x+currentRoom.entryDoor.x,
							z:currentRoom.position.z+currentRoom.entryDoor.y, time:2 
							,onComplete:
							function():void
							{
								destroyRoom(previousRoom);
								previousRoom = null;
								Main.log("arrowcount: " + ArrowManager.arrowCount);
							}
							});
					
				} });//*/
			
			Tweener.addTween(cameraTarget, {x:nextRoom.position.x, z:nextRoom.position.z, time:(distance/1000), transition:"easeInOutQuad"});
			var campos:Number3D = createRoomCameraPosition(nextRoom);
			Tweener.addTween(camera, {x:campos.x, y:campos.y, z:campos.z, time:(distance/800), transition:"easeInOutQuad"});
//			Main.log("room diff: " + MathUtils.sub(currentRoom.position, nextRoom.position, true ) );
//			Main.log("currcam: " + MathUtils.sub(currentRoom.position,camera.position,true) );
//			Main.log("nextcam: " + MathUtils.sub(nextRoom.position,campos,true) );
//			displayRoom(nextRoom);
			
		}
		
		private static function onExitArrowArrive( arrow:BorgesArrow, distance:Number ):void
		{
			var firstRoom:Room;
//			Main.log("exit arrow arrived at " + arrow.target + ": " + arrow.length);
//			Main.log("arrow " + arrow.no + " index: " + ArrowManager.arrows.indexOf( arrow ) );
//			Main.log("origin: " + arrow.origin );
			arrow.update();
			previousRoom = currentRoom;
			currentRoom = nextRoom;
			displayRoom(currentRoom);
			
//			Main.log("prev: " + previousRoom.roomNo );
//			Main.log("curr: " + currentRoom.roomNo );
			
			// arrow from previous to next
			Tweener.addTween(arrow.origin,
				{ 
					x:currentRoom.position.x+currentRoom.entryDoor.x,
					z:currentRoom.position.z+currentRoom.entryDoor.y,
//					x:currentRoom.position.x,
//					z:currentRoom.position.z,
					time:1 //(distance/1200) 
					,onComplete:
					function():void
					{
//						if( rooms.length > 2 )
//						{	
//							firstRoom = rooms.shift();
//							firstRoom.destroy();
//							firstRoom = null;
//						}
						previousRoom.destroy();
						previousRoom = null;
						Main.log("arrowcount: " + BorgesArrowManager.arrowCount);
					}
				});//*/
				
			roomsVisited++;
			//previousRoom.destroy();
			//previousRoom = null;
		}
		
		private static function createRoomCameraPosition( room:Room ):Number3D
		{
			var current:Number3D = MathUtils.sub(currentRoom.position,camera.position,true);
			var distX:Number = current.x;
			var distZ:Number = current.z;
			
			if( random.nextIntRange(0,100) > 50 )
				distX = -distX;
			else if( random.nextIntRange(0,100) > 50 )
				distZ = -distZ;
					
			var result:Number3D = new Number3D( room.position.x-distX, Math.abs(distX), room.position.z-distZ );
				
//			Main.log("room " + room.roomNo + " campos: " + result );
			return result;
		}
		
		
		private static function createRoomWalls( room:Room ):void
		{
			var i:int;
			var door:Door;
			var arrow:Arrow;
			var duration:Number = 0.1;
			var delay:Number = 0;
			var halfWidth:Number = room.halfWidth;
			var halfHeight:Number = room.height/2.0;
			var dec:Number = BorgesArrowManager.template.width/4.0;
			var spans:Array;
			
			BorgesArrowManager.template.colour = colours[COLOUR_WALL]; // 0x888888;
			
			// NORTH
			spans = room.getWallSpans(Room.NORTH, dec);
			for( i=0;i<spans.length;i+=2 )
			{
				createEdge( room, spans[i], room.position.z+halfHeight-dec, duration, delay, {x:spans[i+1]} );
				delay += duration;
			}
			
			// EAST			
			spans = room.getWallSpans(Room.EAST, dec );
			for( i=0;i<spans.length;i+=2 )
			{
				createEdge( room, room.position.x+halfWidth-dec, spans[i], duration, delay, {z:spans[i+1]} );
				delay += duration;
			}
			
			// SOUTH
			spans = room.getWallSpans(Room.SOUTH, dec );
			for( i=0;i<spans.length;i+=2 )
			{
				createEdge( room, spans[i], room.position.z-halfHeight, duration, delay, {x:spans[i+1]} );
				delay += duration;
			}

			// WEST
			spans = room.getWallSpans(Room.WEST, dec );
			for( i=0;i<spans.length;i+=2 )
			{
				createEdge( room, room.position.x-halfWidth, spans[i], duration, delay, {z:spans[i+1]} );
//				Main.log("edge " + spans[i] + "," + (-halfHeight) + " -> " + spans[i+1] + "," + (-halfHeight) );
				delay += duration;
			}
			
		}
		
		private static function createEdge( room:Room, x:Number, z:Number, time:Number, duration:Number, tween:Object, immediate:Boolean=false ):BorgesArrow
		{
			var result:BorgesArrow;
			
			tween.time = time;
			tween.delay = duration;
			
			BorgesArrowManager.pop();
			BorgesArrowManager.move( x,0,z );
			
			if( immediate )
			{
				result = BorgesArrowManager.create();
				if( tween.z )
					result.target.z = tween.z;
				else if( tween.x )
					result.target.x = tween.x;
//				Main.log("imediate arrow: " + arrow.origin + " -> " + arrow.target );
				
			}
			else
			{
				result = BorgesArrowManager.create().tweenTarget(tween);
			}
			
			room.walls.push( result );
			
			return result;
		}
		
		private static function createRoomDoors(room:Room):void
		{
			var target:Number3D;
			var temp:Number3D = new Number3D();
			var arrow:BorgesArrow;
			
			BorgesArrowManager.template.colour = colours[COLOUR_DOOR];// 0x000000;
			
			var doorContainer:ObjectContainer3D;
			
			for each( var door:Door in room.doors )
			{
				door.object3D = doorContainer = createDoor();
				doorContainer.moveTo( room.position.x+door.x, 0, room.position.z+door.y );
				
				if( door.wall == Room.WEST )
					doorContainer.rotationY = 90;
				else if( door.wall == Room.EAST )
					doorContainer.rotationY = -90;
					
				
				if( !door.initial )
				{
					// create exit arrow
					
					BorgesArrowManager.push();
					BorgesArrowManager.template.dashed = false;
					BorgesArrowManager.template.colour = colours[COLOUR_EXIT];// 0xCCCCCC;
					BorgesArrowManager.template.width = 300;
					BorgesArrowManager.template.createHead = true;
					BorgesArrowManager.template.origin = doorContainer.position;
					
					
					temp = Room.directionNormal(door.wall);
					MathUtils.mul(temp,100);
					MathUtils.add(BorgesArrowManager.template.origin, temp);
					MathUtils.mul(temp,4);
					MathUtils.add(temp, BorgesArrowManager.template.origin);
					MathUtils.copy(BorgesArrowManager.template.target, temp );
					
					
//					Main.log("wayout: " + ArrowManager.template );
					door.exitArrow = arrow = BorgesArrowManager.create();
//					Main.log("created exit arrow " + arrow.no + " index " + ArrowManager.arrows.indexOf( arrow ) );
					
					arrow.addOnMouseOver( onArrowEvent );
					arrow.addOnMouseOut(onArrowEvent);
					arrow.addOnMouseUp( onArrowEvent );
					
					arrow.properties.door = door;
					arrow.properties.room = door.room;
					
					BorgesArrowManager.pop();
				}
			}
		}
		
		
		
		public static function onArrowEvent( evt:MouseEvent3D ):void
		{
			var arrow:BorgesArrow = evt.target as BorgesArrow;
			
			switch( evt.type )
			{
				case MouseEvent3D.MOUSE_OVER:
					arrow.colour = colours[COLOUR_EXIT_ACTIVE];// 0x000000;
					Tweener.removeTweens( cameraTarget );
					Tweener.addTween(cameraTarget, {x:arrow.position.x, z:arrow.position.z, time:4, transition:"easeInOutQuad"});
					
					resetAutoTimer();
					
					
					break;
				case MouseEvent3D.MOUSE_OUT:
					arrow.colour = colours[COLOUR_EXIT]; //0xCCCCCC;
					break;
				
				case MouseEvent3D.MOUSE_UP:
					moveToRoom( arrow.properties.door );
					arrow.removeOnMouseOver( onArrowEvent );
					arrow.removeOnMouseOut( onArrowEvent );
					arrow.removeOnMouseUp( onArrowEvent );
					break;
			}
		}
		
		
		private static function createDoor():ObjectContainer3D
		{
			var width:Number = 150;
			var height:Number = 300;
			var arrow:Arrow;
			var duration:Number = 0.1;
			var delay:Number = 0;
			var dec:Number = BorgesArrowManager.template.width/4.0;
			
			var cont:ObjectContainer3D = new ObjectContainer3D();
			viewDoors.scene.addChild(cont);
			
			BorgesArrowManager.pop();
			BorgesArrowManager.move( -(width-dec),0,0);
			cont.addChild( BorgesArrowManager.create(false).tweenTarget({z:height, time:duration, delay:delay}) );
			
			delay += duration;
			
			BorgesArrowManager.pop();
			BorgesArrowManager.move( -(width),0,height);
			cont.addChild( BorgesArrowManager.create(false).tweenTarget({x:width, time:duration, delay:delay}) );
			
			delay += duration;
			
			BorgesArrowManager.pop();
			BorgesArrowManager.move( width-(dec-5),0,height);
			cont.addChild( BorgesArrowManager.create(false).tweenTarget({z:0, time:duration, delay:delay}) );

			cont.rotationX = 90;
			
			
			return cont;
		}
		
		
		private function onEnterFrame(event:Event):void
		{
			var container:ObjectContainer3D;
        	
        	if( roomMoving && movingToRoom == false && getTimer() > enterTime+leaveTime )
        	{
        		Main.log("moving out of room");
        		movingToRoom = true;
        		
        		// choose one of the rooms doors
        		var door:Door = currentRoom.getRandomDoor();
        		
        		Tweener.addTween(cameraTarget, 
        			{	x:door.exitArrow.position.x, 
        				z:door.exitArrow.position.z, 
        				time:2, 
        				transition:"easeInOutQuad",
        				onComplete:function():void
        				{
        					moveToRoom( door );
        				}}
        		);		
        	}

        	redraw = true;
        	
        	if( redraw )
        	{	
	        	for each( var arrow:BorgesArrow in BorgesArrowManager.arrows )
	        	{
	        		if( arrow != null )
	        		{
	        			arrow.visible = true;
	    	    		arrow.update();
	    	    	}
        		}
        		
        		camera.lookAt(cameraTarget.position);
            	
            	viewRooms.render();
            	viewArrows.render();
            	viewDoors.render();
            	redraw = false;
//            	log("target: " + cameraTarget.position );
         	}
        }
        
        
        public static function get trueRandom():Number
		{
			return Math.random();
		}
		
		public static function trueRandomRange(min:Number, max:Number):Number
		{
			return Math.round(min + ((max - min) * Math.random()))
		}
		
		public static function nextIntRange( property:Object ):uint
		{
			var value:Array = property as Array;
			
			return random.nextIntRange( value[0], value[1] );
		}
		
		private static var _timer:Number;
		
        public static function startTimer():void
        {
        	_timer = getTimer();
        }
        
        public static function stopTimer():Number
        {
        	return getTimer() - _timer;
        }
        
        public static function log( msg:String ):void
        {
        	var now:Date = new Date();

        	var secs:Number = now.getSeconds();
        	var hrs:Number = now.getHours();
        	var mins:Number = now.getMinutes();
        	var ms:Number = now.getMilliseconds();
        	trace( updates + " : " + " : " + "/" + mins + ":" + secs + ":" + ms + " " + msg );
        	
        }
        
        
        
        /*private static function initHoverCamera():void
		{
			var dist:Number = 3000;
			camera = new HoverCamera3D({zoom:3, focus:200, x:dist, y:dist, z:dist, distance:dist});
			var hoverCamera:HoverCamera3D = camera as HoverCamera3D;
			
			// create a 3D-viewport
			hoverCamera.tiltangle = 40;
			hoverCamera.targettiltangle = 40;
			hoverCamera.mintiltangle =  20;
			hoverCamera.maxtiltangle = 50;
			hoverCamera.yfactor = 1;
			hoverCamera.steps = 7;
			
		}//*/
		
        /*public function addCameraEvents():void
        {
        	var hoverCamera:HoverCamera3D = camera as HoverCamera3D;
        	var rotCamera:Boolean = false;
			var lastMouseX:Number = mouseX;
			var lastMouseY:Number = mouseY;
			var firstClick:Boolean = true;
			
			//
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			function onEnterFrame(event:Event):void 
			{
			       //
			       if (rotCamera) {
			               if (firstClick == true) {
			                       firstClick = false;
			                       lastMouseX = view.mouseX;
			                       lastMouseY = view.mouseY;
			               }
			               //
			               var dragX:Number = (view.mouseX - lastMouseX);
			               var dragY:Number = (view.mouseY - lastMouseY);
			               //
			               lastMouseX = view.mouseX;
			               lastMouseY = view.mouseY;
			               //
			               hoverCamera.targetpanangle += dragX;
			               hoverCamera.targettiltangle += dragY
			               hoverCamera.hover();
			       } else {
			               //
			       }
			       // rerender viewport on each frame
			       // view.render();
			}
			
			var hit:MovieClip = new MovieClip();
			hit.graphics.beginFill(0xFF0000);
			hit.graphics.drawRect(0, 0, 500, 600);
			hit.graphics.endFill();
			addChild(hit);
			hit.alpha = 0;
			hit.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			function mouseDownHandler(evt:MouseEvent):void {
			       rotCamera = true;
			}
			hit.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			function mouseUpHandler(evt:MouseEvent):void {
			       rotCamera = false;
			       firstClick = true;
			}
			hit.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseEvent);
			
			function onMouseEvent(event:MouseEvent):void {
			       //Main.log("camzoom: " + camera.zoom);
			       var dir:Number = (event.delta > 0) ? .5 : -.5;
			       hoverCamera.distance -= ( dir * 50 );
			       hoverCamera.update();
			       // camera.zoom = Math.max(2, Math.min(8, (camera.zoom+dir)));
			       //camera.distanceTo(-40);
			}
        }//*/ 
	}
}
