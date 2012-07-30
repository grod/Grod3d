/**

	Author: Gustav Buchholtz (gustav.buchholtz@gmail.com), http://www.grod.se/
	
	* ----------------------------------------------------------------------------
	* "THE BEER-WARE LICENSE" (Revision 42):
	* Gustav Buchholtz wrote this file. As long as you retain this notice you
	* can do whatever you want with this stuff. If we meet some day, and you think
	* this stuff is worth it, you can buy me a beer in return.
	* ---------------------------------------------------------------------------- 
*/


package se.grod.grod3d.core.render
{	
	import se.grod.grod3d.core.Scene3D;
	import se.grod.grod3d.cameras.Camera3D;
	import flash.events.EventDispatcher;
	
	public class Renderer extends EventDispatcher
	{
		public function Renderer() : void
		{
			super();
			log("Renderer Base init");
		}
		
		public function draw( scene:Scene3D, camera:Camera3D ) : Boolean
		{
			//Abstract
			return false;
		}
	}
}