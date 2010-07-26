package com.odogono.utils
{
	import away3d.containers.Scene3D;
	import away3d.core.math.Number3D;
	import away3d.materials.WireframeMaterial;
	import away3d.primitives.GridPlane;
	

	
	public class Region
	{
		public static const NORMAL:int = 0;
		public static const HALFSIZE:int = 1;
		public static const SPECIAL:int = 2;
		
		public var regionID:int;
		
		public var top:Number;
		public var left:Number;
		public var right:Number;
		public var bottom:Number;
		
		// protected var _width:Number;
		// protected var _length:Number;
		
		public var centre:Number3D;
		// public var radius:Number;
		
		
		public var gridPlane:GridPlane;

		
		public static function CreateRegion( _centreX:Object, _centreZ:Number, _radius:Number = 0 ):Region
		{
			if( _centreX is Number3D )
			{
				return new Region( _centreX.z-_centreZ, _centreX.x-_centreZ,_centreX.x+_centreZ,_centreX.z+_centreZ );
			}
			else
			{
				var cenx:Number = _centreX as Number;
				
				return new Region( _centreZ-_radius, cenx-_radius, cenx+_radius, _centreZ+_radius );
			}
		}
		
		
		public function Region( _top:Number = 0, _left:Number = 0, _right:Number = 0, _bottom:Number = 0, _id:int = -1)
		{
			top = _top; left = _left; right = _right; bottom = _bottom; regionID = _id;
			
			centre = new Number3D( (_left+_right) * 0.5, 0, (_top+_bottom)*0.5 );
			
//			_width = Math.abs(right - left);
			// _length = Math.abs(bottom - top);
			// radius = Math.min(length,_width) / 2;
		}
		
		public function get x():Number
		{
			return centre.x;
		}
		public function get y():Number
		{
			return centre.y;
		}
		public function get z():Number
		{
			return centre.z;
		}
		
		public function set x( n:Number ):void
		{ centre.x = n; }
		public function set y( n:Number ):void
		{ centre.y = n; }
		public function set z( n:Number ):void
		{ centre.z = n; }
		
		
		public function get radius():Number
		{
			return Math.min(length,width)/2;
		}
		
		public function set radius( num:Number ):void
		{
			left = centre.x - num;
			right = centre.x + num;
			top = centre.z - num;
			bottom = centre.z + num;
		}
		
		
		public function get width():Number
    	{
    		return Math.abs(right - left);
    	}
    	
    	/*public function get height():Number
    	{
    		return Math.abs(top - bottom);
    	}//*/
    	
    	public function get length():Number
    	{
    		return Math.abs(top - bottom); //Math.max( this.width, this.height );
    	}
    	
    	/*
    	public function get breadth():Number
    	{
    		return Math.min( this.width, this.height );
    	}//*/
    	
    	
    	/*public function getRandomPosition():Number3D
    	{
    		return new Number3D( Main.random.nextNumberRange(left,right), 0, Main.random.nextNumberRange(top, bottom) );
    	}//*/
    	
    	public function inside( pos:Number3D, modififer:int = NORMAL, margin:Number = 0.1 ):Boolean
    	{
    		var marginX:Number = width;
    		var marginZ:Number = length;
    		
    		if( modififer == NORMAL )
    		{
    			 return ((pos.x > left) && (pos.x < right) &&
         					(pos.z > top) && (pos.z < bottom));
    		}
    		else if( modififer == SPECIAL )
    		{
    			marginX = width * margin;
    			marginZ = length * margin;
    			
    			return ((pos.x > (left+marginX)) && (pos.x < (right-marginX)) &&
		        	(pos.z > (top+marginZ)) && (pos.z < (bottom-marginZ)));
    		}
    		else
    		{
    			marginX = width * 0.25;
    			marginZ = length * 0.25;
    			
    			return ((pos.x > (left+marginX)) && (pos.x < (right-marginX)) &&
		        	(pos.z > (top+marginZ)) && (pos.z < (bottom-marginZ)));
    		}
    	}
		
//		public function addToScene( scene:Scene3D, pitch:Pitch = null ):void
//		{
//			var w:Number = width;
//			var l:Number = length;
//			var pos:Number3D = centre.clone();
//			
//			if( pitch != null )
//			{
//				pos = pitch.worldToLocal(pos);
//				w = pitch.worldWidthToLocal(w);
//				l = pitch.worldLengthToLocal(l);
//			}
//			
//			if( gridPlane == null )
//			{
//				gridPlane = new GridPlane();
//				var gm:WireframeMaterial = new WireframeMaterial(0xFFFFFF, {width:2});
//    			gridPlane.material = gm;
//			}
//			gridPlane.width = w;
//			gridPlane.height = l;
//			
//			gridPlane.position = pos;
//    		
//    		if( scene.children.indexOf(gridPlane) == -1 )
//	    		scene.addChild(gridPlane);
//		}
		
		
		public function toString():String
		{
			return MathUtils.number3DtoString( centre ) + "," + radius;
		}
		
	}
}