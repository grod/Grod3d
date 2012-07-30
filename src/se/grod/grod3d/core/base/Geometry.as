/**

	Author: Gustav Buchholtz (gustav.buchholtz@gmail.com), http://www.grod.se/
	
	* ----------------------------------------------------------------------------
	* "THE BEER-WARE LICENSE" (Revision 42):
	* Gustav Buchholtz wrote this file. As long as you retain this notice you
	* can do whatever you want with this stuff. If we meet some day, and you think
	* this stuff is worth it, you can buy me a beer in return.
	* ---------------------------------------------------------------------------- 
*/


package se.grod.grod3d.core.base
{	
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Context3D;
	
	public class Geometry
	{
		protected var _vertices : Vector.<Number>;
		protected var _colors	: Vector.<Number>;
		protected var _uvs 		: Vector.<Number>;
		protected var _normals 	: Vector.<Number>;
		protected var _indices 	: Vector.<uint>;
		
		protected var _vertexBuffer : VertexBuffer3D;
		protected var _colorBuffer : VertexBuffer3D;
		protected var _uvBuffer : VertexBuffer3D;
		protected var _normalBuffer : VertexBuffer3D;
		protected var _indexBuffer : IndexBuffer3D;
		
		protected var _numVertices : uint;
		protected var _numIndices : uint;
		
		private var _geometryNeedsUpdate : Boolean = true;
		
		public function Geometry()
		{
			_vertices = new Vector.<Number>();
			_colors = new Vector.<Number>();
			_uvs = new Vector.<Number>();
			_normals = new Vector.<Number>();
			_indices = new Vector.<uint>();
		}
		
		public function transform(  ) : void
		{
			
		}
		
		public function update( context : Context3D ) : void
		{
			if (_geometryNeedsUpdate)
			{
				if ( _vertices && _vertices.length > 0 )
				{
					_vertexBuffer = _vertexBuffer || context.createVertexBuffer( _vertices.length / 3, 3 );
					_vertexBuffer.uploadFromVector( _vertices, 0, _vertices.length / 3 );
				}
				
				if ( _colors && _colors.length > 0 )
				{
					_colorBuffer = _colorBuffer || context.createVertexBuffer( _colors.length / 3, 3 );
					_colorBuffer.uploadFromVector( _colors, 0, _colors.length / 3 );
				}
				
				if ( _uvs && _uvs.length > 0 )
				{
					_uvBuffer = _uvBuffer || context.createVertexBuffer( _uvs.length / 2, 2 );
					_uvBuffer.uploadFromVector( _uvs, 0, _uvs.length / 2 )
				}
				
				if ( _normals && _normals.length > 0 )
				{
					_normalBuffer = _normalBuffer || context.createVertexBuffer( _normals.length / 3, 3 );
					_normalBuffer.uploadFromVector( _normals, 0, _normals.length / 3 );
				}
				
				if ( _indices && _indices.length > 0 )
				{
					_indexBuffer = _indexBuffer || context.createIndexBuffer( _indices.length );
					_indexBuffer.uploadFromVector( _indices, 0, _indices.length )
				}
				
				_geometryNeedsUpdate = false;
			}
		}
		
		public function get vertices() : Vector.<Number> {return _vertices}
		public function set vertices( value : Vector.<Number> ) : void
		{
			_vertices = value;
			_geometryNeedsUpdate = true;
		}
		
		public function get uvs() : Vector.<Number> {return _uvs}
		public function set uvs( value : Vector.<Number> ) : void
		{
			_uvs = value;
			_geometryNeedsUpdate = true;
		}
		
		public function get normals() : Vector.<Number> {return _normals}
		public function set normals( value : Vector.<Number> ) : void
		{
			_normals = value;
			_geometryNeedsUpdate = true;
		}
		
		public function get colors() : Vector.<Number>{return _colors}
		public function set colors(value : Vector.<Number>) : void
		{
			_colors = value;
			_geometryNeedsUpdate = true;
		}
		
		public function get indices() : Vector.<uint> {return _indices}
		public function set indices( value : Vector.<uint> ) : void
		{
			_indices = value;
			_geometryNeedsUpdate = true;
		}
		
		/* Stage 3D Buffers */
		public function get vertexBuffer() : VertexBuffer3D {return _vertexBuffer}
		public function set vertexBuffer( value : VertexBuffer3D ) : void
		{
			_vertexBuffer = value;
		}
		
		public function get uvBuffer() : VertexBuffer3D {return _uvBuffer}
		public function set uvBuffer ( value : VertexBuffer3D ) : void
		{
			_uvBuffer = value;
		}
		
		public function get normalBuffer() : VertexBuffer3D {return _normalBuffer}
		public function set normalBuffer ( value : VertexBuffer3D ) : void
		{
			_normalBuffer = value;
		}
		
		public function get colorBuffer() : VertexBuffer3D {return _colorBuffer}
		public function set colorBuffer ( value : VertexBuffer3D ) : void
		{
			_colorBuffer = value;
		}
		
		public function get indexBuffer() : IndexBuffer3D {return _indexBuffer}
		public function set indexBuffer ( value : IndexBuffer3D ) : void
		{
			_indexBuffer = value;
		}
		
	}
}