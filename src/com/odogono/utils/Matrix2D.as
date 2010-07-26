package com.odogono.utils
{
	import away3d.core.math.Number3D;
	
	
	public class Matrix2D
	{
		public var m11:Number, m12:Number, m13:Number;
		public var m21:Number, m22:Number, m23:Number;
		public var m31:Number, m32:Number, m33:Number;
		
		
		private static var tempMatrix1:Matrix2D = new Matrix2D();
		private static var tempMatrix2:Matrix2D = new Matrix2D();
		
		public function Matrix2D()
		{
			identity();
		}
		
		
		public function identity():void
		{
			m11 = 1; m12 = 0; m13 = 0;
			m21 = 0; m22 = 1; m23 = 0;
			m31 = 0; m32 = 0; m33 = 1;
		}
		
		/*public function clear():void
		{
			m11 = m12 = m13 = 0;
			m21 = m22 = m23 = 0;
			m31 = m32 = m33 = 0;
		}//*/
		
		
		public function transformVector2Ds( point:Number3D ):void
		{
			var tempX:Number = (m11*point.x) + (m21*point.z) + (m31);
			var tempZ:Number = (m12*point.x) + (m22*point.z) + (m32);
			
			point.x = tempX;
			point.z = tempZ;
		}
		

		public function translate( x:Number, z:Number):void
		{
			// var mat:Matrix2D = new Matrix2D;
			
			tempMatrix1.m11 = 1; tempMatrix1.m12 = 0; tempMatrix1.m13 = 0;
			tempMatrix1.m21 = 0; tempMatrix1.m22 = 1; tempMatrix1.m23 = 0;
			tempMatrix1.m31 = x; tempMatrix1.m32 = z; tempMatrix1.m33 = 1;
			
			matrixMultiply(tempMatrix1);
		}
		

		public function rotate( rot:Number ):void
		{
			// var mat:Matrix2D = new Matrix2D;
			var sin:Number = Math.sin(rot);
			var cos:Number = Math.cos(rot);
			
			tempMatrix1.m11 = cos; 	tempMatrix1.m12 = sin; 	tempMatrix1.m13 = 0;
			tempMatrix1.m21 = -sin; 	tempMatrix1.m22 = cos; 	tempMatrix1.m23 = 0;
			tempMatrix1.m31 = 0; 		tempMatrix1.m32 = 0; 		tempMatrix1.m33 = 1;
			
			matrixMultiply(tempMatrix1);
		}
		
		
		public function rotateVector( fwd:Number3D, side:Number3D ):void
		{
			tempMatrix1.m11 = fwd.x; 	tempMatrix1.m12 = fwd.z; 	tempMatrix1.m13 = 0;
			tempMatrix1.m21 = side.x; 	tempMatrix1.m22 = side.z; 	tempMatrix1.m23 = 0;
			tempMatrix1.m31 = 0; 		tempMatrix1.m32 = 0; 		tempMatrix1.m33 = 1;
			
			matrixMultiply(tempMatrix1);
		}
		
		
		
		public function matrixMultiply( mat:Matrix2D ):void
		{
			// var temp:Matrix2D = new Matrix2D;
			
			//first row
			tempMatrix2.m11 = (m11*mat.m11) + (m12*mat.m21) + (m13*mat.m31);
			tempMatrix2.m12 = (m11*mat.m12) + (m12*mat.m22) + (m13*mat.m32);
			tempMatrix2.m13 = (m11*mat.m13) + (m12*mat.m23) + (m13*mat.m33);
			
			//second
			tempMatrix2.m21 = (m21*mat.m11) + (m22*mat.m21) + (m23*mat.m31);
			tempMatrix2.m22 = (m21*mat.m12) + (m22*mat.m22) + (m23*mat.m32);
			tempMatrix2.m23 = (m21*mat.m13) + (m22*mat.m23) + (m23*mat.m33);
			
			//third
			tempMatrix2.m31 = (m31*mat.m11) + (m32*mat.m21) + (m33*mat.m31);
			tempMatrix2.m32 = (m31*mat.m12) + (m32*mat.m22) + (m33*mat.m32);
			tempMatrix2.m33 = (m31*mat.m13) + (m32*mat.m23) + (m33*mat.m33);
			
			copy(tempMatrix2);
		}
		
		
		public function copy( mat:Matrix2D ):void
		{
			m11 = mat.m11; m12 = mat.m12; m13 = mat.m13;
			m21 = mat.m21; m22 = mat.m22; m23 = mat.m23;
			m31 = mat.m31; m32 = mat.m32; m33 = mat.m33;
		}
	}
}