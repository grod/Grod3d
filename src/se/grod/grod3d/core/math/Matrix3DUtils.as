/**

	Author: Gustav Buchholtz (gustav.buchholtz@gmail.com), http://www.grod.se/
	
	* ----------------------------------------------------------------------------
	* "THE BEER-WARE LICENSE" (Revision 42):
	* Gustav Buchholtz wrote this file. As long as you retain this notice you
	* can do whatever you want with this stuff. If we meet some day, and you think
	* this stuff is worth it, you can buy me a beer in return.
	* ---------------------------------------------------------------------------- 
*/


package se.grod.grod3d.core.math
{
	
	import flash.geom.Matrix3D;
	
	public class Matrix3DUtils
	{
	
		public static function makeFrustum( left:Number, right:Number, top:Number, bottom:Number, near:Number, far:Number ):Matrix3D
		{
			var result 	: Matrix3D 			= new Matrix3D();
			var rawData : Vector.<Number> 	= new Vector.<Number>();
			
			var x : Number = 2 * near / ( right - left );
			var y : Number = 2 * near / ( top - bottom );

			var a : Number = ( right + left ) / ( right - left );
			var b : Number = ( top + bottom ) / ( top - bottom );
			var c : Number = - ( far + near ) / ( far - near );
			var d : Number = - 2 * far * near / ( far - near );

			rawData.push(x); rawData.push(0); rawData.push(a);  rawData.push(0);
			rawData.push(0); rawData.push(y); rawData.push(b);  rawData.push(0);
			rawData.push(0); rawData.push(0); rawData.push(c);  rawData.push(d);
			rawData.push(0); rawData.push(0); rawData.push(-1); rawData.push(0);
			
			result.rawData = rawData;
			
			return result;
		}
	
	}

}

