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
	
	public class Cube extends Mesh
	{
		private var _width : Number;
		private var _height : Number;
		private var _depth : Number;
		private var _flipNormals : Boolean;
		
		/*
			TODO Add segments?
		*/
		public function Cube( material : Material, width:Number = 1, height:Number = 1, depth:Number = 1, flipNormals:Boolean = false) : void
		{
			_width = width;
			_height = height;
			_depth = depth;
			_flipNormals = flipNormals;
		
			super( material );
			buildGeometry();
		}
	
		protected function buildGeometry() : void
		{
			_geometry = new Geometry();
			
			var halfW : Number = _width * .5;
			var halfH : Number = _height * .5;
			var halfD : Number = _depth * .5;
			
			_geometry.vertices.push(-halfW, -halfH, -halfD); // 0
			_geometry.vertices.push( halfW, -halfH, -halfD); // 1
			_geometry.vertices.push( halfW,  halfH, -halfD); // 2
			_geometry.vertices.push(-halfW,  halfH, -halfD); // 3
			_geometry.vertices.push(-halfW, -halfH,  halfD); // 4
			_geometry.vertices.push( halfW, -halfH,  halfD); // 5
			_geometry.vertices.push( halfW,  halfH,  halfD); // 6
			_geometry.vertices.push(-halfW,  halfH,  halfD); // 7
			_geometry.vertices.push(-halfW, -halfH, -halfD); // 0 + 8
			_geometry.vertices.push( halfW, -halfH, -halfD); // 1
			_geometry.vertices.push( halfW,  halfH, -halfD); // 2
			_geometry.vertices.push(-halfW,  halfH, -halfD); // 3
			_geometry.vertices.push(-halfW, -halfH,  halfD); // 4
			_geometry.vertices.push( halfW, -halfH,  halfD); // 5
			_geometry.vertices.push( halfW,  halfH,  halfD); // 6
			_geometry.vertices.push(-halfW,  halfH,  halfD); // 7
			_geometry.vertices.push(-halfW, -halfH, -halfD); // 0 + 16
			_geometry.vertices.push( halfW, -halfH, -halfD); // 1
			_geometry.vertices.push( halfW,  halfH, -halfD); // 2
			_geometry.vertices.push(-halfW,  halfH, -halfD); // 3
			_geometry.vertices.push(-halfW, -halfH,  halfD); // 4
			_geometry.vertices.push( halfW, -halfH,  halfD); // 5
			_geometry.vertices.push( halfW,  halfH,  halfD); // 6
			_geometry.vertices.push(-halfW,  halfH,  halfD); // 7

			_geometry.uvs.push(0, 1, 1, 1, 1, 0, 0, 0);
			_geometry.uvs.push(1, 1, 0, 1, 0, 0, 1, 0);
			_geometry.uvs.push(1, 1, 0, 1, 0, 0, 1, 0);
			_geometry.uvs.push(0, 1, 1, 1, 1, 0, 0, 0);
			_geometry.uvs.push(0, 0, 1, 0, 1, 1, 0, 1);
			_geometry.uvs.push(0, 1, 1, 1, 1, 0, 0, 0);
			
			var normalFlip : int = 1;
			if (_flipNormals)
				normalFlip = -1;
			_geometry.normals.push(0, 0, -normalFlip);
			_geometry.normals.push(0, 0, -normalFlip);
			_geometry.normals.push(0, 0, -normalFlip);
			_geometry.normals.push(0, 0, -normalFlip);
			_geometry.normals.push(0, 0, normalFlip);
			_geometry.normals.push(0, 0, normalFlip);
			_geometry.normals.push(0, 0, normalFlip);
			_geometry.normals.push(0, 0, normalFlip);
			_geometry.normals.push(-normalFlip, 0, 0);
			_geometry.normals.push(normalFlip, 0, 0);
			_geometry.normals.push(normalFlip, 0, 0);
			_geometry.normals.push(-normalFlip, 0, 0);
			_geometry.normals.push(-normalFlip, 0, 0);
			_geometry.normals.push(normalFlip, 0, 0);
			_geometry.normals.push(normalFlip, 0, 0);
			_geometry.normals.push(-normalFlip, 0, 0);
			_geometry.normals.push(0, -normalFlip, 0);
			_geometry.normals.push(0, -normalFlip, 0);
			_geometry.normals.push(0, normalFlip, 0);
			_geometry.normals.push(0, normalFlip, 0);
			_geometry.normals.push(0, -normalFlip, 0);
			_geometry.normals.push(0, -normalFlip, 0);
			_geometry.normals.push(0, normalFlip, 0);
			_geometry.normals.push(0, normalFlip, 0);
            
			_geometry.indices.push(0, 1, 2, 2, 3, 0); // Front.
			_geometry.indices.push(6, 5, 4, 7, 6, 4); // Back.
			var off:uint = 8;
			_geometry.indices.push(off + 5, off + 6, off + 1, off + 6, off + 2, off + 1); // Right.
			_geometry.indices.push(off + 0, off + 3, off + 4, off + 3, off + 7, off + 4); // Left.
			off = 16;
			_geometry.indices.push(off + 2, off + 6, off + 3, off + 6, off + 7, off + 3); // Top.
			_geometry.indices.push(off + 5, off + 1, off + 4, off + 1, off + 0, off + 4); // Bottom.
			
		}
	}
}