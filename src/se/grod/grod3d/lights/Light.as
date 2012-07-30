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
	import se.grod.grod3d.core.objects.Object3D;
	
	public class Light extends Object3D
	{
		private var _color : uint = 0xFFFFFF;
		
		public function Light()
		{
			super();
			this.visible = false;
		}
		
		public function get color() : uint {return _color}
		public function set color(value : uint) : void
		{
			_color = value;
		}
	}
}