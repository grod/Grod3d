/**

	Author: Gustav Buchholtz (gustav.buchholtz@gmail.com), http://www.grod.se/
	
	* ----------------------------------------------------------------------------
	* "THE BEER-WARE LICENSE" (Revision 42):
	* Gustav Buchholtz wrote this file. As long as you retain this notice you
	* can do whatever you want with this stuff. If we meet some day, and you think
	* this stuff is worth it, you can buy me a beer in return.
	* ---------------------------------------------------------------------------- 
*/


package se.grod.grod3d.lights
{	
	import se.grod.grod3d.lights.Light;
	
	public class PointLight extends Light
	{
		public function PointLight(color:uint = 0xFFFFFF, x:Number = 0, y:Number = 0, z:Number = 0) : void
		{
			super();
			
			this.color = color;
			this.x = x;
			this.y = y;
			this.z = z;
		}
	}
}