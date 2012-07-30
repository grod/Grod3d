/**

	Author: Gustav Buchholtz (gustav.buchholtz@gmail.com), http://www.grod.se/
	
	* ----------------------------------------------------------------------------
	* "THE BEER-WARE LICENSE" (Revision 42):
	* Gustav Buchholtz wrote this file. As long as you retain this notice you
	* can do whatever you want with this stuff. If we meet some day, and you think
	* this stuff is worth it, you can buy me a beer in return.
	* ---------------------------------------------------------------------------- 
*/


package se.grod.grod3d.utils
{	
	public class ColorUtils
	{
		public static function hexToVector4( hex : uint ) : Vector.<Number>
		{
			var r : Number = ((hex & 0xFF0000 ) >> 16) 	/ 255;
			var g : Number = ((hex & 0x00FF00 ) >> 8) 	/ 255;
			var b : Number = (hex & 0x0000FF )			/ 255;
			
			return Vector.<Number>([ r, g, b, 1 ]);
		}
	}
}