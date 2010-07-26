package com.odogono.utils
{
	import away3d.core.math.Number3D;
	import away3d.core.math.MatrixAway3D;
	
	public class MathUtils
	{
		public static const HALF_PI:Number = Math.PI / 2.0;
		public static const DOUBLE_PI:Number = Math.PI * 2.0;
		public static const QUARTER_PI:Number = Math.PI / 4.0;
		public static const EIGHTH_PI:Number = Math.PI / 8.0;
		public static const DEGREES_TO_RADIANS:Number = 180.0 / Math.PI;
		public static const RADIANS_TO_DEGREES:Number = Math.PI / 180.0;
		
		public static const ON_PLANE:int = 0;
		public static const PLANE_BACKSIDE:int = 1;
		public static const PLANE_FRONT:int = 2;
		
		
		public static var dist:Number;
		public static var point:Number3D;
		
		
		private static var matrix:Matrix2D = new Matrix2D;
		
		public static function copy( num:Object, rhs:Object ):void
		{
			num.x = rhs.x;
			num.y = rhs.y;
			num.z = rhs.z;
		}
		
		public static function add( num:Object, rhs:Object ):void
		{
			num.x += rhs.x;
			num.y += rhs.y;
			num.z += rhs.z;
		}
		
		public static function sub( num:Number3D, rhs:Number3D, create:Boolean=false ):Number3D
		{
			if( create )
			{
				var result:Number3D = new Number3D();
				result.x = num.x - rhs.x;
				result.y = num.y - rhs.y;
				result.z = num.z - rhs.z;
				return result;
			}
			num.x -= rhs.x;
			num.y -= rhs.y;
			num.z -= rhs.z;
			
			return null;
		}
		
		public static function mul( num:Number3D, rhs:Number ):void
		{
			num.x *= rhs;
			num.y *= rhs;
			num.z *= rhs;
		}
		
		public static function div( num:Number3D, rhs:Number ):void
		{
			if( rhs == 0 )
				return;
			
			num.x /= rhs;
			num.y /= rhs;
			num.z /= rhs;
		}
		
		public static function clear( num:Number3D ):void
		{
			num.x = num.y = num.z = 0;
		}
		
		public static function clone( num:Number3D ):Number3D
		{
			return new Number3D( num.x, num.y, num.z );
		}
		
		
		public static const ANTI_CLOCKWISE:Number = -1;
		public static const CLOCKWISE:Number = 1;
		
		public static function sign( num:Number3D, rhs:Number3D ):Number
		{
			if( num.z*rhs.x > num.x*rhs.z )
				return ANTI_CLOCKWISE;
			else
				return CLOCKWISE;
		}
		
		
		public static function clamp( num:Number, min:Number, max:Number ):Number
		{
			if( num < min )
				num = min;
			if( num > max )
				num = max;
				
			return num;
		}
		
		
		public static function truncate( num:Number3D, max:Number ):void
		{
			if( MathUtils.length(num) > max )
			{
				num.normalize();
				MathUtils.mul(num, max);
			}
		}
		
		
		public static function isZero( num:Number3D ):Boolean
		{
			return (num.x*num.x + num.y*num.y + num.z*num.z) < 0.001;
		}
		
		public static function equal( v1:Number3D, v2:Number3D ):Boolean
		{
			return v1.x == v2.x && v1.y == v2.y && v1.z == v2.z;
		}
		
		
		public static function normalize( src:Number3D ):Number3D
		{
			var result:Number3D = new Number3D(src.x,src.y,src.z);
			result.normalize();
			return result;
		}
		
		public static function invert( src:Number3D ):Number3D
		{
			src.x = -src.x;
			src.y = -src.y;
			src.z = -src.z;
			
			return src;
		}
		
		public static function copyAndNormalize( src:Number3D, trg:Number3D ):void
		{
			src.x = trg.x;
			src.y = trg.y;
			src.z = trg.z;
			src.normalize();
		}
		
		
		public static function addAndReturn( src:Number3D, add:Number3D ):Number3D
		{
			var result:Number3D = new Number3D();
			
			result.add( src, add );
			
			return result;
		}
		
		
		public static function normaliseThenMultiply( src:Number3D, mul:Number ):Number3D
		{
			var result:Number3D = new Number3D(src.x,src.y,src.z);
			result.normalize();
			MathUtils.mul( result, mul );
			return result;
		}
		
		public static function normaliseThenDivide( src:Number3D, div:Number ):Number3D
		{
			var result:Number3D = new Number3D(src.x,src.y,src.z);
			result.normalize();
			MathUtils.div( result, div );
			return result;
		}
		
		public static function perp( num:Number3D ):Number3D
		{
			var result:Number3D = new Number3D;
			result.cross(num,new Number3D(0,1,0));
			return result;
		}
		
		public static function copyAndPerp( src:Number3D, num:Number3D ):void
		{
			src.x = 1 * num.z - 0 * num.y;
        	src.y = 0 * num.x - 0 * num.z;
        	src.z = 0 * num.y - 1 * num.x;
		}
		
		
		public static function reflect( src:Number3D, norm:Number3D ):void
		{
			var dot:Number = -src.x * norm.x - src.z * norm.z;
			
			src.x = src.x + 2 * norm.x * dot;
			src.z = src.z + 2 * norm.z * dot;
		}
		
		public static function lineIntersection( a:Number3D, b:Number3D, c:Number3D, d:Number3D ):Boolean
		{
			var rTop:Number = (a.z-c.z)*(d.x-c.x)-(a.x-c.x)*(d.z-c.y);
			var sTop:Number = (a.z-c.z)*(b.x-a.x)-(a.x-c.x)*(b.z-a.z);
			var bot:Number = (b.x-a.x)*(d.z-c.z)-(b.z-a.z)*(d.x-c.x);
			
			if( bot == 0 ) //parallel
				return false;
				
			var r:Number = rTop/bot;
			var s:Number = sTop/bot;
			
//			Main.log("r: " + r + " s: " + s );
			if( (r > 0) && (r < 1) && (s > 0) && (s < 1) )
				return true;
			
			return false;
		}
		
		public static function lineIntersectionSuper( a:Number3D, b:Number3D, c:Number3D, d:Number3D ):Boolean
		{
			var result:Number;
			var rTop:Number = (a.z-c.z)*(d.x-c.x)-(a.x-c.x)*(d.z-c.z);
			var rBot:Number = (b.x-a.x)*(d.z-c.z)-(b.z-a.z)*(d.x-c.x);
			
			var sTop:Number = (a.z-c.z)*(b.x-a.x)-(a.x-c.x)*(b.z-a.z);
			var sBot:Number = (b.x-a.x)*(d.z-c.z)-(b.z-a.z)*(d.x-c.x);

	
			// check for parallel lines
			if( (rBot == 0) || (sBot == 0 ) )
				return false;
				
			var r:Number = rTop/rBot;
			var s:Number = sTop/sBot;
			
			if( (r>0) && (r<1) && (s>0) && (s<1) )
			{
				dist = a.distance(b) * r;
				
				MathUtils.point = new Number3D(b.x,b.y,b.z);
				MathUtils.sub( point, a );
				MathUtils.mul(point,r);
				MathUtils.add(point,a);
				
				return true;
			}
			else
			{
				dist = 0;
				
				return false;
			}
		}
		
		public static function lineIntersectionDistance( a:Number3D, b:Number3D, c:Number3D, d:Number3D ):Number
		{
			var rTop:Number = (a.z-c.z)*(d.x-c.x)-(a.x-c.x)*(d.z-c.y);
			var sTop:Number = (a.z-c.z)*(b.x-a.x)-(a.x-c.x)*(b.z-a.z);
			var bot:Number = (b.x-a.x)*(d.z-c.z)-(b.z-a.z)*(d.x-c.x);
			
			if( bot == 0 ) //parallel
			{
				if( (rTop == 0) && (sTop == 0) )
					return 0;
				
				return -1;
			}
			
			var r:Number = rTop/bot;
			var s:Number = sTop/bot;
			
			if( (r > 0) && (r < 1) && (s > 0) && (s < 1) )
			{
				// lines intersect
				return a.distance(b) * r;
			}
			
			return -1;
		}


		public static function distanceSquared( v1:Object, v2:Object ):Number
		{
			var radius:Number = 0;
			var v1n:Number3D = toNumber3D(v1);
			var v2n:Number3D = toNumber3D(v2);
			
			if( v1 is Region )
				radius += (v1 as Region).radius;
			if( v2 is Region )
				radius += (v2 as Region).radius;
			
			
			var zS:Number = v2n.z - v1n.z;
			var yS:Number = v2n.y - v1n.y;
			var xS:Number = v2n.x - v1n.x;
			
			return (zS*zS + yS*yS + xS*xS) - (radius*radius);
		}
		
		public static function length( v:Number3D ):Number
		{
			return Math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
		}
		
		public static function lengthSquared( v:Number3D ):Number
		{
			return (v.x * v.x + v.y * v.y + v.z * v.z);
		}
		
		public static function lengthSquared2D( v:Number3D ):Number
		{
			return v.x * v.x + v.z * v.z;
		}
		
		
		public static function distance( a:Object, b:Object ):Number
		{
			var an:Number3D = toNumber3D(a);
			var bn:Number3D = toNumber3D(b);
				
			return an.distance(bn);
		}
		
		
		public static function toNumber3D( item:Object ):Number3D
		{
			if( item is Number3D )
				return item as Number3D;
			else if( item is Region )
				return (item as Region).centre;
			else
				throw "Unknown Object type " + item;
		}
		
		
		public static function toRegion( item:Object ):Region
		{
			if( item is Number3D )
			{
				return Region.CreateRegion(item, 100);
			}
			else if( item is Region )
				return (item as Region);
			else
				throw "Unknown Object type " + item;
		}//*/
		
		public static function distanceToRayPlaneIntersection( 
						rayOrigin:Number3D, 
						rayHeading:Number3D, 
						planePoint:Number3D, 
						planeNormal:Number3D ):Number
		{
			var d:Number = -planeNormal.dot(planePoint);
			
			var denom:Number = planeNormal.dot(rayHeading);
			
			// normal is parallel to vector
			if( (denom < 0.000001) && (denom > -0.000001) )
			{
				return -1.0;
			}
			
			var numer:Number = planeNormal.dot(rayOrigin) + d;
			
			return -(numer / denom);
		}
		
		
		public static function whereIsPoint( point:Number3D, pointOnPlane:Number3D, planeNormal:Number3D ):int
		{
			var dir:Number3D = new Number3D;
			
			dir.sub( pointOnPlane, point );
			
			var d:Number = dir.dot(planeNormal);
			
			if( d < 0.000001)
				return PLANE_FRONT;
			
			else if( d > 0.000001 )
				return PLANE_BACKSIDE;
			
			return ON_PLANE;
		}
		
		
		public static function getAngleBetween( v:Number3D, w:Object ):Number
		{
			var wn:Number3D = null;
			if( w is Number3D )
				wn = w as Number3D;
			else if( w is Region )
				wn = (w as Region).centre;
			
			return getAngle( wn.x,wn.z, v.x, v.z );
		}
		
		public static function getAngle(ax:Number, az:Number, bx:Number, bz:Number):Number
		{
			var x:Number = bx - ax;
			var z:Number = bz - az;
			var angle:Number;
			
			if( (x==0) && (z>=0))
				angle = Math.PI*2; // (3*Math.PI/2);
			else if((x == 0) && (z <=0))
			    angle = (Math.PI);
			else if((x < 0) && (z <= 0))
			    angle = (Math.PI+(Math.PI/2)) - Math.atan(z/x);
			else if((x < 0) && (z >= 0))
			    angle = (3*Math.PI/2) + Math.abs(Math.atan(z/x));
			else if(z > 0)
			    angle = (2*Math.PI+(Math.PI/2)) - Math.atan(z/x);
			else 
				angle = -1 * Math.atan(z/x) + (Math.PI/2);
				
			return angle; // * (180/Math.PI);
		}
		
		/*
		public static function getDegrees(ax:Number, ay:Number, bx:Number, by:Number):Number
		{
			var x:Number = bx - ax;
			var y:Number = by - ay;
			var angle:Number;
			
			if( (x==0) && (y>=0))
				angle = Math.PI*2; // (3*Math.PI/2);
			else if((x == 0) && (y <=0))
			    angle = (Math.PI);
			else if((x < 0) && (y <= 0))
			    angle = (Math.PI+(Math.PI/2)) - Math.atan(y/x);
			else if((x < 0) && (y >= 0))
			    angle = (3*Math.PI/2) + Math.abs(Math.atan(y/x));
			else if(y > 0)
			    angle = (2*Math.PI+(Math.PI/2)) - Math.atan(y/x);
			else 
				angle = -1 * Math.atan(y/x) + (Math.PI/2);
				
			return angle * (180/Math.PI);
		}//*/
		
		public static function pointToLocalSpace( 
								point:Number3D,
								heading:Number3D,
								side:Number3D,
								position:Number3D ):Number3D
		{
			var transPoint:Number3D = new Number3D(point.x, point.y, point.z);
			
			matrix.identity();
			
			var tx:Number = -position.dot(heading);
			var tz:Number = -position.dot(side);
			
			// create the transformation matrix
			matrix.m11 = heading.x;
			matrix.m12 = side.x;
			matrix.m21 = heading.z;
			matrix.m22 = side.z;
			matrix.m31 = tx;
			matrix.m32 = tz;
			
			matrix.transformVector2Ds(transPoint);
	
			return transPoint;
		}
		
		
		/**
		 * Transforms a point from the agent's local space into world space
		 */
		public static function pointToWorldSpace(
									point:Number3D,
									heading:Number3D,
									side:Number3D,
									position:Number3D ):Number3D
		{
			// make a copy of the point
			var transPoint:Number3D = new Number3D(point.x, point.y, point.z);
			
			matrix.identity();
			
			//rotate
			matrix.rotateVector(heading,side);
			
			// translate
			matrix.translate( position.x, position.z );
			
			// now transform
			matrix.transformVector2Ds(transPoint);
			
			return transPoint;
		}
		
		
		public static function vectorRotateAroundOrigin( v:Number3D, ang:Number ):void
		{
			matrix.identity();
			
			matrix.rotate(ang);
			
			matrix.transformVector2Ds(v);
		}
		
		
		public static function vector3DRotateAroundOrigin( v:Number3D, ang:Number ):void
		{
			var m:Matrix3D = Matrix3D.eulerRotation( -ang, ang, 0 );
			
			Matrix3D.vectorMult(m, v );
		}
		
		
		public static function rotateAboutYAxis( v:Number3D, ang:Number ):void
		{
			
			var ca:Number = Math.cos( ang );
			var sa:Number = Math.sin( ang );
	
			/*v.x = (ca * v.x) + (sa * v.z);
			v.z = (sa * v.x) + (ca * v.z);/
			
			v.x = Math.cos(ang)*v.z;
			v.z = Math.sin(ang)*v.z;/*/
			
			var x:Number = sa*v.z;
			var z:Number = ca*v.z;
			
			v.x = x;
			v.z = z;
		}
		
		
		public static function rotateAboutXAxis( v:Number3D, ang:Number ):void
		{
			var ca:Number = Math.cos( ang );
			var sa:Number = Math.sin( ang );
			
			var ry:Number = ( ca * v.y ) - ( sa * v.z );
			var rz:Number = ( sa * v.y ) + ( ca * v.z );
			
			v.y = ry;
			v.z = rz;
			// v.y = ( ca * v.y ) + ( sa * v.z );
			// v.z = ( sa * v.y ) + ( ca * v.z );
		}
		
	
		
		
		public static function vectorMult( m:Matrix3D, v:Number3D ): void
		{
			var vx:Number,vy:Number,vz:Number;
			
			v.x =	(vx=v.x) * m.n11 + (vy=v.y) * m.n12 + (vz=v.z) * m.n13 + m.n14;
			v.y = 	vx * m.n21 + vy * m.n22 + vz * m.n23 + m.n24;
			v.z = 	vx * m.n31 + vy * m.n32 + vz * m.n33 + m.n34;
		}
		
		
		public static function getNormal( v:Number3D ):Number
		{
			return Math.sqrt( v.x*v.x + v.y*v.y + v.z*v.z );
		}
		
		/**
		* Returns the angle in radian between the two 3D vectors. The formula used here is very simple.
		* It comes from the definition of the dot product between two vectors.
		* @param	v	Vector	The first Vector
		* @param	w	Vector	The second vector
		* @return 	Number	The angle in radian between the two vectors.
		*/
		/*public static function getAngle ( v:Number3D, w:Number3D ):Number
		{
			var ncos:Number = v.dot(w) / ( MathUtils.getNormal(v) * MathUtils.getNormal(w) );
			// var ncos:Number = WVectorMath.dot( v, w ) / ( WVectorMath.getNorm(v) * WVectorMath.getNorm(w) );
			var sin2:Number = 1 - ncos * ncos;
			
			if (sin2<0)
			{
				trace(" wrong "+ncos);
				sin2 = 0;
			}
			//I took long time to find this bug. Who can guess that (1-cos*cos) is negative ?!
			//sqrt returns a NaN for a negative value !
			return  Math.atan2( Math.sqrt(sin2), ncos );
			
			//return Math.acos( VectorMath.dot( v, w ) / (VectorMath.getNorm(v) * VectorMath.getNorm(w)) );
		}//*/
		
		public static function axisRotation ( u:Number, v:Number, w:Number, angle:Number ) : Matrix3D
		{
			var m:Matrix3D 	= Matrix3D.createIdentity();
			angle = toRadian( angle );
			
			// -- modification pour verifier qu'il n'y ai pas un probleme de precision avec la camera
			var nCos:Number	= Math.cos( angle );
			var nSin:Number	= Math.sin( angle );
			var scos:Number	= 1 - nCos ;

			var suv	:Number = u * v * scos ;
			var svw	:Number = v * w * scos ;
			var suw	:Number = u * w * scos ;
			var sw	:Number = nSin * w ;
			var sv	:Number = nSin * v ;
			var su	:Number = nSin * u ;
			
			m.n11  =   nCos + u * u * scos	;
			m.n12  = - sw 	+ suv 			;
			m.n13  =   sv 	+ suw			;

			m.n21  =   sw 	+ suv 			;
			m.n22  =   nCos + v * v * scos ;
			m.n23  = - su 	+ svw			;

			m.n31  = - sv	+ suw 			;
			m.n32  =   su	+ svw 			;
			m.n33  =   nCos	+ w * w * scos	;

			return m;
		}
		
		
		/**
		 * Convert an angle from Degrees to Radians unit
		 * @param n  Number Number representing the angle in dregrees
		 * @return Number The angle in radian unit
		 */
		public static function toRadian ( n:Number ):Number
		{
			return n * TO_RADIAN;
		}
		
		public static function toDegree ( n:Number ):Number
		{
			return n * TO_DEGREE;
		}
		
		public static function get TO_DEGREE():Number { return __TO_DREGREE; }
		internal static const __TO_DREGREE:Number = 180.0 /  Math.PI;
		
		/**
		 * Constant used to convert degress to radians.
		 */
		public static function get TO_RADIAN():Number { return __TO_RADIAN; }
		internal static const __TO_RADIAN:Number = Math.PI / 180;
		
		
		
		
		public static function calculateLaunchVector( src:Number3D, 
														target:Number3D, 
														speed:Number, 
														shot1:Number3D, shot2:Number3D ):Boolean
		{
			var g:Number = 1.8;
			var targetVec:Number3D = new Number3D(target.x, target.y, target.z);
			MathUtils.sub( targetVec, src );
			
			var x:Number = Math.sqrt( targetVec.x*targetVec.x + targetVec.z*targetVec.z);
			var y:Number = targetVec.y;
			
			
			var a:Number = (-g * x * x) / (2.0 * speed * speed);
			var b:Number = x;
			var c:Number = -(y + g*x*x/(2*speed*speed));
			var d:Number = b*b - 4*a*c;
			
			if( d<0 )
				return false;
				
			var t1:Number = (-b + Math.sqrt(d))/(2*a);
			var t2:Number = (-b - Math.sqrt(d))/(2*a);

			shot1.x = targetVec.x;
			shot1.y = t1*x;
			shot1.z = targetVec.z;
			
			// make length of shot velocity be equal to speed (if you just need direction, normalize instead)
			MathUtils.mul(shot1, speed/MathUtils.length(shot1));

			shot2.x = targetVec.x;
			shot2.y = t2*x;
			shot2.z = targetVec.z;
			
			MathUtils.mul(shot2, speed/MathUtils.length(shot2));

			return true;
		}
		

		public static function positionToString( num:Object ):String
		{
			if( num is Number3D )
				return number3DtoString(num as Number3D);
			else if( num is Region )
				return (num as Region).toString();
			else
				throw "unknown datatype " + num;
		}
		
		public static function number3DtoString( num:Number3D ):String
		{
			return printf("%.3f,%.3f,%.3f",num.x,num.y,num.z);
		}
		
		public static function numberToString( num:Number ):String
		{
			return printf("%.3f", num, 0.2654684 );
		}
		
		
		/*public static function awayMatrix3DToString( mat:MatrixAway3D ):String
		{
			return printf("%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f",
				mat.sxx, mat.sxy, mat.sxz, mat.tx,
				mat.syx, mat.syy, mat.syz, mat.ty,
				mat.szx, mat.szy, mat.szz, mat.tz,
				mat.swx, mat.swy, mat.swz, mat.tw
			);
		}
		
		public static function stringToAwayMatrix3D( str:String ):MatrixAway3D
		{
			try
			{
				var els:Array = str.split(",");
				var result:MatrixAway3D = new MatrixAway3D();
				
				result.sxx = els[0];
				result.sxy = els[1];
				result.sxz = els[2];
				result.tx = els[3];
				
				result.syx = els[4];
				result.syy = els[5];
				result.syz = els[6];
				result.ty = els[7];
				
				result.szx = els[8];
				result.szy = els[9];
				result.szz = els[10];
				result.tz = els[11];
				
				result.swx = els[12];
				result.swy = els[13];
				result.swz = els[14];
				result.tw = els[15];
				
				return result;
				
			}catch( ex:Object )
			{
				
			}
			
			return null;
		}//*/
		
	}
}