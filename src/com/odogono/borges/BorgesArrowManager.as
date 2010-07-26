package com.odogono.borges
{
	import away3d.core.math.Number3D;
	
	import com.odogono.utils.MathUtils;
	
	public class BorgesArrowManager
	{
		public static var instance:BorgesArrowManager;
		
		public static var template:BorgesArrow;
		
		public var stack:Array;
		
		public static var arrowCount:int;
		
		public static var arrows:Array;
		
		public function BorgesArrowManager()
		{
			instance = this;
			stack = new Array();
			arrows = new Array();
			
			template = new BorgesArrow(
				new Number3D(0,0,0),
				new Number3D(0,0,0), { colour:0x000000, width:200 } );
		}
		
		public static function create( addToScene:Boolean = true ):BorgesArrow
		{
			var result:BorgesArrow = createArrow(
					MathUtils.clone(template.origin),
					MathUtils.clone(template.target),
						{dashed:template.dashed, 
						colour:template.colour,
						head:template.createHead, 
						width:template.width}, addToScene );
			
			//result.length = 0;
			//result.update();
			
//			Main.log("created arrow: " + result.origin + " -> " + result.target + " " + result.length );
			return result;
		}
		
		
		public static function destroy( arrow:BorgesArrow ):BorgesArrow
		{
			if( arrow == null )
				return null;
			
			arrow.destroy();
			
			Main.viewArrows.scene.removeChild(arrow);
			
//			Main.log("removing arrow " + arrow.no + " at " + arrows.indexOf(arrow) );
			arrows.splice( arrows.indexOf(arrow),1 );
			
			arrowCount--;
			
			return arrow;
		}

		public static function push():void
		{
			instance.stack.push( template );
			template = new BorgesArrow(
				new Number3D(0,0,0),
				new Number3D(0,0,0), { colour:0x000000, width:200 } );
				
			// MathUtils.clear( template.origin );
			// MathUtils.clear( template.target );
		}
		
		public static function pop():void
		{
			if( instance.stack.length > 0 )
				template = instance.stack.pop();
			else
			{
				MathUtils.clear( template.origin );
				MathUtils.clear( template.target );
				template.createHead = false;
			}
		}
		
		public static function move( x:Number, y:Number, z:Number ):void
		{
			template.move(x,y,z);
		}
		
		
		private static function createArrow( src:Number3D, dst:Number3D, init:Object=null, addToScene:Boolean = true ):BorgesArrow
		{
			var result:BorgesArrow;
			
			result = new BorgesArrow( 
    			src, 
    			dst, 
    			init
    			);
    			
    		if( addToScene )
    			Main.viewArrows.scene.addChild(result)
    		
    		result.no = arrowCount;
    		arrows.push( result );
    		arrowCount++;
    		
    		return result;
		}
		
		/*
		public static function removeArrow( arrow:Arrow ):void
		{
			Main.viewArrows.scene.removeChild(arrow);
		}//*/
	}
}