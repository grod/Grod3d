/**

	Author: Gustav Buchholtz (gustav.buchholtz@gmail.com), http://www.grod.se/
	
	* ----------------------------------------------------------------------------
	* "THE BEER-WARE LICENSE" (Revision 42):
	* Gustav Buchholtz wrote this file. As long as you retain this notice you
	* can do whatever you want with this stuff. If we meet some day, and you think
	* this stuff is worth it, you can buy me a beer in return.
	* ---------------------------------------------------------------------------- 
*/


package se.grod.grod3d.core.objects
{	
	import se.grod.grod3d.core.objects.ObjectContainer3D;
	import se.grod.grod3d.core.base.Geometry;
	import se.grod.grod3d.materials.Material;
	
	public class Mesh extends ObjectContainer3D
	{
		protected var _geometry:Geometry;
		private var _material:Material;
		
		public function Mesh( material:Material = null )
		{
			super();
			_material = material;
		}
		
		public function get material() : Material {return _material}
		public function set material( value : Material ) : void
		{
			_material = value;
		}
		
		public function get geometry() : Geometry {return _geometry}
		public function set geometry( geom : Geometry ) : void
		{
			_geometry = geom;
		}
	}
}