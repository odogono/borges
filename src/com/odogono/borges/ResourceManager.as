package com.odogono.borges
{
	import away3d.core.math.*;
	import away3d.materials.*;
	import away3d.primitives.*;
	import away3d.sprites.*;
	
	//import br.com.stimuli.loading.*;
	//import br.com.stimuli.loading.loadingtypes.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.ui.*;
	
	
	// import com.adobe.serialization.json.*;
	
	
	public class ResourceManager
	{
		private static var instance:ResourceManager;
		public static var BULKLOADER_NAME:String = "main";
		
		public static var arrowBitmap:BitmapData;
		public static var arrowTailBitmap:BitmapData;
		
		
		public static var resourcesLoaded:Boolean = false;
		
		
		[Embed(source="../res/arrow.png")]
		public static var arrowImage:Class;

		[Embed(source="../res/tail.png")]
		public static var tailImage:Class;
		
		public function ResourceManager()
		{
			instance = this;
			
		}
		
		
		
		
		
		
		
		public static function createGradient():void
		{
			var shape:Shape = new Shape();
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(Main.screenwidth, Main.screenheight,(90 * Math.PI/180));
			
			shape.graphics.beginGradientFill(GradientType.LINEAR, [0x0010a1, 0x00cbff], [100, 100], [0x00, 0xFF], matrix, SpreadMethod.PAD);  
			shape.graphics.drawRect(0,0,Main.screenwidth,Main.screenheight);
			shape.graphics.endFill();
			
			Main.instance.addChild(shape);
		}
		
		
		
		public static function loadResources():void
		{
			arrowTailBitmap = new tailImage().bitmapData;
			arrowBitmap = new arrowImage().bitmapData;
			resourcesLoaded = true;
			Main.onReady();
			
//			var loader:BulkLoader = new BulkLoader(BULKLOADER_NAME,5, BulkLoader.LOG_ERRORS);
//			loader.logFunction = Main.log;
//			
//			resourcesLoaded = false;
//			
//			// loader.add("../res/settings.json", {id:"settings",type:"text"}).addEventListener(Event.COMPLETE, instance.onSettingsLoaded,false,0,true);
//
//			loader.add("res/tail.png", {id:"tail"});
//			loader.add("res/arrow.png", {id:"arrow"});
//			
//			// loader.addEventListener(BulkLoader.ERROR,instance.onError,false,0,true);
//			loader.addEventListener(BulkLoader.COMPLETE, instance.onResourcesLoaded,false,0,true);
//			loader.start();
		}




//		private function onResourcesLoaded(evt:Event):void
//		{
//			var loader:BulkLoader = BulkLoader.getLoader(BULKLOADER_NAME);
//			loader.logLevel = BulkLoader.LOG_VERBOSE;
//			arrowTailBitmap = new tailImage().bitmapData;
//			arrowBitmap = new arrowImage().bitmapData;
//			
//			//arrowTailBitmap = loader.getBitmapData("tail");
//        	//arrowBitmap = loader.getBitmapData("arrow");
//        	
//        	resourcesLoaded = true;
//        	Main.onReady();
//		}
	}
}