/**

	Author: Gustav Buchholtz (gustav.buchholtz@gmail.com), http://www.grod.se/
	
	* ----------------------------------------------------------------------------
	* "THE BEER-WARE LICENSE" (Revision 42):
	* Gustav Buchholtz wrote this file. As long as you retain this notice you
	* can do whatever you want with this stuff. If we meet some day, and you think
	* this stuff is worth it, you can buy me a beer in return.
	* ---------------------------------------------------------------------------- 
*/


package se.grod.grod3d.primitives
{	
	import se.grod.grod3d.core.objects.Mesh;
	import se.grod.grod3d.materials.Material;
	import se.grod.grod3d.core.base.Geometry;
	
	public class Plane extends Mesh
	{
		private var _width : Number;
		private var _height : Number;
		private var _doubleSided : Boolean;

		public function Plane( material : Material, width:Number = 1, height:Number = 1, doubleSided:Boolean = true) : void
		{
			_width = width;
			_height = height;
			_doubleSided = doubleSided;
		
			super( material );
			buildGeometry();
		}
	
		protected function buildGeometry() : void
		{
			_geometry = new Geometry();
			
			var halfW : Number = _width * .5;
			var halfH : Number = _height * .5;
			
			_geometry.vertices.push(-halfW, -halfH, 0); // 0
			_geometry.vertices.push( halfW, -halfH, 0); // 1
			_geometry.vertices.push( halfW,  halfH, 0); // 2
			_geometry.vertices.push(-halfW,  halfH, 0); // 3

			_geometry.uvs.push(0, 1, 1, 1, 1, 0, 0, 0);

			_geometry.normals.push(0, 0, -1);
			_geometry.normals.push(0, 0, -1);
			_geometry.normals.push(0, 0, -1);
			_geometry.normals.push(0, 0, -1);

			_geometry.indices.push(0, 1, 2, 2, 3, 0);
			
			if (_doubleSided)
			{
				// Back side
				_geometry.vertices.push(-halfW, -halfH, 0);
				_geometry.vertices.push( halfW, -halfH, 0);
				_geometry.vertices.push( halfW,  halfH, 0);
				_geometry.vertices.push(-halfW,  halfH, 0);
				
				_geometry.uvs.push(1, 1, 0, 1, 0, 0, 1, 0);
				
				_geometry.normals.push(0, 0, 1);
				_geometry.normals.push(0, 0, 1);
				_geometry.normals.push(0, 0, 1);
				_geometry.normals.push(0, 0, 1);
				
				_geometry.indices.push(6, 5, 4, 7, 6, 4);
			}
		}
	}
}