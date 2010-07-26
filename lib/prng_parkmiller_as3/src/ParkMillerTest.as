/**
* @mxmlc -default-size 640;480 -output ParkMillerTest.swf -default-frame-rate 60 -incremental=false -optimize=true -source-path D:\dcc\flash\actionscript\classes\AS3 ;C:\Programme\FlashDevelop\Library -default-background-color 0xffffff
*/
package
{
	import de.polygonal.math.PM_PRNG;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.flashdevelop.utils.FlashConnect3;
	import flash.utils.getTimer;
	
	public class ParkMillerTest extends MovieClip
	{
		public static function tr(...rest):void
		{
			FlashConnect3.trace(rest.join(" "));
		}
		
		public var r:PM_PRNG;
		
		public var i:uint;
		public var k:int;
		public var t:Timer;
		
		public var startTime:Number;
		
		public function ParkMillerTest()
		{
			r = new PM_PRNG();
			
			i = (1 << 31) - 1;
			k = 0;
			
			//distribute computation
			t = new Timer(1000);
			t.addEventListener(TimerEvent.TIMER, update);
			t.start();
			
			startTime = getTimer();
		}
		
		/*
			 from http://www.firstpr.com.au/dsp/rand31/#History-implementation
				
			 	Value           Number of results after seed of 1
				
			     16807          1
			 282475249          2
			1622650073          3
			 984943658          4
			1144108930          5
			 470211272          6
			 101027544          7
			1457850878          8
			1458777923          9
			2007237709         10
			
			 925166085       9998
			1484786315       9999
			1043618065      10000
			1589873406      10001
			2010798668      10002
			
			1227283347    1000000
			1808217256    2000000
			1140279430    3000000
			 851767375    4000000
			1885818104    5000000
			
			 168075678   99000000
			1209575029  100000000
			 941596188  101000000

			1207672015 2147483643
			1475608308 2147483644
			1407677000 2147483645
			1          2147483646  <<< Starting the sequence again with the original seed.
			16807      2147483647
		*/

		public function update(e:TimerEvent):void
		{
			//iterations/second (balanced for ~2,13 ghz pentium mobile)
			var j:int = 1e+6 * 4;
			
			var time:int = getTimer();
			
			while (i)
			{
				if (k >= 1 && k <= 10)
				{
					switch (k)
					{
						case 1:
						if (r.seed == 16807) ParkMillerTest.tr("pass " + k);
						else ParkMillerTest.tr("fail " + k);
						break;
						
						case 2:
						if (r.seed == 282475249) ParkMillerTest.tr("pass " + k);
						else ParkMillerTest.tr("fail " + k);
						break;
						
						case 3:
						if (r.seed == 1622650073) ParkMillerTest.tr("pass " + k);
						else ParkMillerTest.tr("fail " + k);
						break;
						
						case 4:
						if (r.seed == 984943658) ParkMillerTest.tr("pass " + k);
						else ParkMillerTest.tr("fail " + k);
						break;
						
						case 5:
						if (r.seed == 1144108930) ParkMillerTest.tr("pass " + k);
						else ParkMillerTest.tr("fail " + k);
						break;
						
						case 6:
						if (r.seed == 470211272) ParkMillerTest.tr("pass " + k);
						else ParkMillerTest.tr("fail " + k);
						break;
						
						case 7:
						if (r.seed == 101027544) ParkMillerTest.tr("pass " + k);
						else ParkMillerTest.tr("fail " + k);
						break;
						
						case 8:
						if (r.seed == 1457850878) ParkMillerTest.tr("pass " + k);
						else ParkMillerTest.tr("fail " + k);
						break;
						
						case 9:
						if (r.seed == 1458777923) ParkMillerTest.tr("pass " + k);
						else ParkMillerTest.tr("fail " + k);
						break;
						
						case 10:
						if (r.seed == 2007237709) ParkMillerTest.tr("pass " + k);
						else ParkMillerTest.tr("fail " + k);
						break;
					}
					
				}
				else
				if (k >= 9998 && k <= 10002)
				{
					switch (k)
					{
						case 9998:
						if (r.seed == 925166085) ParkMillerTest.tr("pass " + k);
						else ParkMillerTest.tr("fail " + k);
						break;
						
						case 9999:
						if (r.seed == 1484786315) ParkMillerTest.tr("pass " + k);
						else ParkMillerTest.tr("fail " + k);
						break;
						
						case 10000:
						if (r.seed == 1043618065) ParkMillerTest.tr("pass " + k);
						else ParkMillerTest.tr("fail " + k);
						break;
						
						case 10001:
						if (r.seed == 1589873406) ParkMillerTest.tr("pass " + k);
						else ParkMillerTest.tr("fail " + k);
						break;
						
						case 10002:
						if (r.seed == 2010798668) ParkMillerTest.tr("pass " + k);
						else ParkMillerTest.tr("fail " + k);
						break;
					}
				}
				else
				if (k == 1000000)
				{
					if (r.seed == 1227283347) ParkMillerTest.tr("pass " + k);
					else ParkMillerTest.tr("fail " + k);
				}
				else
				if (k == 2000000)
				{
					if (r.seed == 1808217256) ParkMillerTest.tr("pass " + k);
					else ParkMillerTest.tr("fail " + k);
				}
				else
				if (k == 3000000)
				{
					if (r.seed == 1140279430) ParkMillerTest.tr("pass " + k);
					else ParkMillerTest.tr("fail " + k);
				}
				else
				if (k == 4000000)
				{
					if (r.seed == 851767375) ParkMillerTest.tr("pass " + k);
					else ParkMillerTest.tr("fail " + k);
				}
				else
				if (k == 5000000)
				{
					if (r.seed == 1885818104) ParkMillerTest.tr("pass " + k);
					else ParkMillerTest.tr("fail " + k);
				}
				else
				if (k == 99000000)
				{
					if (r.seed == 168075678) ParkMillerTest.tr("pass " + k);
					else ParkMillerTest.tr("fail " + k);
				}
				else
				if (k == 100000000)
				{
					if (r.seed == 1209575029) ParkMillerTest.tr("pass " + k);
					else ParkMillerTest.tr("fail " + k);
				}
				else
				if (k == 101000000)
				{
					if (r.seed == 941596188) ParkMillerTest.tr("pass " + k);
					else ParkMillerTest.tr("fail " + k);
				}
				else
				if (k == 2147483643)
				{
					if (r.seed == 1207672015) ParkMillerTest.tr("pass " + k);
					else ParkMillerTest.tr("fail " + k);
				}
				else
				if (k == 2147483644)
				{
					if (r.seed == 1475608308) ParkMillerTest.tr("pass " + k);
					else ParkMillerTest.tr("fail " + k);
				}
				else
				if (k == 2147483645)
				{
					if (r.seed == 1407677000) ParkMillerTest.tr("pass " + k);
					else ParkMillerTest.tr("fail " + k);
				}
				else
				if (k == 2147483646)
				{
					if (r.seed == 1) ParkMillerTest.tr("pass " + k);
					else ParkMillerTest.tr("fail " + k);
					
					t.stop();
					ParkMillerTest.tr("total time " + ( (getTimer() - startTime) / 1000 / 60  ) +  " minutes.");
				}
				
				r.nextInt();
				
				k++;
				i--;
				j--;
				
				if (j == 0) break;
			}
			
			ParkMillerTest.tr((getTimer() - time) + "ms, iteration " + k);
		}
	}
}
