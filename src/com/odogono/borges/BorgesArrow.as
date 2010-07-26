package com.odogono.borges
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.math.Number3D;
	import away3d.core.utils.Init;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TransformBitmapMaterial;
	import away3d.primitives.Plane;
	
	import caurina.transitions.Tweener;
	
	import com.odogono.utils.*;
	
	import flash.display.BitmapData;
	
	
	public class BorgesArrow extends ObjectContainer3D
	{
		
		public var origin:Number3D = new Number3D;
		public var target:Number3D = new Number3D;
		
		
		// private var start:Number3D;
		// private var end:Number3D;
		
		private var bitmap:BitmapData;
		
		private var _colour:uint;
		
		private var head:Plane;
		private var tail:Plane;
		
		private var headMaterial:BitmapMaterial;
		private var tailMaterial:TransformBitmapMaterial;
		private var blackMaterial:ColorMaterial;
		private var _width:Number;
		
		public var multiplier:Number;
		
		public var dashed:Boolean;
		
		public var invisibleIfTooShort:Boolean = true;
		
		public var createHead:Boolean = false;
		
		public var properties:Object = new Object();
		
		
		public var no:int = -1;
		
		public function BorgesArrow( _start:Number3D, _end:Number3D, init:Object )
		{
			var initObject:Init = Init.parse(init);
			
			this.origin = new Number3D(_start.x, _start.y, _start.z);
			this.target = new Number3D(_end.x, _end.y, _end.z);
			
			bitmap = initObject.getBitmap("bitmap");
			_colour = initObject.getInt("colour", 0xFFFFFF);
			_width = initObject.getNumber("width", 175);
			alpha = initObject.getNumber("alpha", 1.0, {min:0.0,max:1.0});
			this.multiplier = initObject.getInt("multiplier", 1 );
			this.dashed = initObject.getBoolean("dashed",false);
			this.createHead = initObject.getBoolean("head",false);
			
			if(!bitmap) bitmap = ResourceManager.arrowBitmap;
			
			headMaterial = new BitmapMaterial(bitmap);
    		headMaterial.color = _colour;
    		headMaterial.alpha = this.alpha;
    		
    		if( dashed )
    		{
    			tailMaterial = new TransformBitmapMaterial(ResourceManager.arrowTailBitmap);
    			
    			tailMaterial.color = _colour;
    			tailMaterial.alpha = this.alpha;
    		
				tailMaterial.repeat = true;
    		}
    		else
    		{
    			tailMaterial = new TransformBitmapMaterial(bitmap);
    			blackMaterial = new ColorMaterial(_colour);
    			
    			tailMaterial.color = _colour;
    			tailMaterial.alpha = this.alpha;
				tailMaterial.scaleY = 0.5;
    			tailMaterial.offsetY = -64;//-64;
    		}
    		
    		if( createHead )
    		{
    			head = new Plane({width:_width, height:_width, material:headMaterial});
    			this.addChild(head);
    		}
//    		else
//    			_width = _width / 2.0;
    		
    		var tailHeight:Number = _width * 2.0;
    		
    		
    		
    		tail = new Plane({width:_width, height:0, material:tailMaterial});
//    		tail = new Plane({width:_width, height:0, material:blackMaterial});
    		tail.bothsides = true;
    		
    		//if( createHead )
    		//	tail.z = -(_width*2)
    		this.addChild(tail);
    		
    		
    		var distance:Number = Math.max( _width, origin.distance(target) ) * this.multiplier ;
    		// _width<<1
    		distance = 0;
    		tail.height = (distance);
    		
    		if( createHead )
    			tail.height -= _width;
    		
    		if( dashed )
    			tailMaterial.scaleY = 1.0/(tail.height/128);
    		
    		tail.z = (tail.height/2.0);
    		
    		if( createHead )
    			head.z = (tail.height + (_width/2.0));
    		else
    			tail.z += (_width/2.0);
    		
    		var ang2:Number = MathUtils.toDegree( MathUtils.getAngle(origin.x,origin.z,target.x,target.z) );
    		
    		this.rotationY = ang2; //this.start.getAngle(this.end);
    		
    		this.x = origin.x;
    		this.z = origin.z;
    		
		}
		
		public function destroy():void
		{
			this.removeChild(tail);
			
			if( createHead )
				this.removeChild(head);
				
			properties = null;
			origin = null;
			target = null;
			bitmap = null;
			headMaterial = null;
			tailMaterial = null;	
		}
		
		public function get length():int
		{
			return tail.height;
		}
		
		public function set length( l:int ):void
		{
			tail.height = l;
		}
		
		public function set colour( val:uint ):void
		{
			headMaterial.color = val;
			tailMaterial.color = val;
			_colour = val;
		}
		
		public function get colour():uint
		{
			return _colour;
		}
		
		
		public function get width():Number
		{
			return _width;	
		}
		
		public function set width( val:Number ):void
		{
			this._width = val;
		}
		
		
		public function move( x:Number,y:Number,z:Number ):BorgesArrow
		{
			origin.x += x;
			origin.y += y;
			origin.z += z;
			
			target.x += x;
			target.y += y;
			target.z += z;
			
			return this;
		}
		
		
		public function tweenTarget( props:Object ):BorgesArrow
		{
			if( props.hasOwnProperty("transition") == false )
				props.transition = "linear";
			Tweener.addTween(target, props );
			return this;
		}
		
		public function update():void
		{
			if( isNaN(origin.x) || isNaN(origin.z) )
				return;
			
			this.x = origin.x;
    		this.z = origin.z;
    		
//			var distance:Number = Math.max( _width, origin.distance(target)   ) * this.multiplier;
			var distance:Number = origin.distance(target)  * this.multiplier;
			
			tail.height = (distance);
    		if( createHead )
    			tail.height -= _width;
    		
    		tail.z = (tail.height/2.0);
    		
    		if( createHead )
    			head.z = (tail.height + (_width/2.0));
    		
    		if( invisibleIfTooShort && tail.height <= 0 )
    			visible = false;
    		
    		if( dashed )
    			tailMaterial.scaleY = 1.0/(tail.height/128);
    		
    		var ang2:Number = MathUtils.toDegree( MathUtils.getAngle(origin.x,origin.z,target.x,target.z) );
    		this.rotationY = ang2;
		}
		
		/*
		override public function clone(object:Object3D=null):Object3D
		{
			var result:Arrow = new Arrow(origin,target,{bitmap:bitmap, colour:_colour, width:_width} );
			
			return result;
		}//*/
		
		override public function toString():String
		{
			return origin.toString() + " -> " + target.toString() + " (" + this.rotationY + ")";
		}
		
	}
}