/**

	Author: Gustav Buchholtz (gustav.buchholtz@gmail.com), http://www.grod.se/
	
	* ----------------------------------------------------------------------------
	* "THE BEER-WARE LICENSE" (Revision 42):
	* Gustav Buchholtz wrote this file. As long as you retain this notice you
	* can do whatever you want with this stuff. If we meet some day, and you think
	* this stuff is worth it, you can buy me a beer in return.
	* ---------------------------------------------------------------------------- 
*/


package se.grod.grod3d.core
{	
	import se.grod.grod3d.core.objects.Object3D;
	import se.grod.grod3d.core.objects.ObjectContainer3D;
	import se.grod.grod3d.lights.Light;
	
	public class Scene3D extends ObjectContainer3D
	{
		private var _lights : Vector.<Light>;
		
		public function Scene3D()
		{
			super();
		}
		
		public function addLight( light : Light ) : void
		{
			if (!_lights)
				_lights = new Vector.<Light>();
				
			_lights.push(light);
		}
		
		public function get lights() : Vector.<Light>
		{
			return _lights;
		}
		
	}
}