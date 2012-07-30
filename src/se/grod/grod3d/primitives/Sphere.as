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
	import se.grod.grod3d.core.math.MathConstants;
	import se.grod.grod3d.materials.Material;
	import se.grod.grod3d.core.base.Geometry;
	public class Sphere extends Mesh
	{
		protected var _radius : Number;
		protected var _segmentsW : uint;
		protected var _segmentsH : uint;
		
		public function Sphere( material : Material, radius : Number = 1, segmentsW:uint = 20, segmentsH:uint = 12 ) : void
		{
			_radius = radius;
			_segmentsW = segmentsW;
			_segmentsH = segmentsH;
			
			super( material );
			buildGeometry();
		}
		
		protected function buildGeometry() : void
		{
			_geometry = new Geometry();
			
			var i : uint = 0;
			var j : uint = 0;
			var triIndex : uint = 0;
			var numVerts : uint = 0;
			
			for ( j = 0 ; j <= _segmentsH; ++j )
			{
				var horizAngle 	: Number = MathConstants.PI * j / _segmentsH;
				var pZ 			: Number = _radius * Math.cos( horizAngle );
				var ringRadius 	: Number = _radius * Math.sin( horizAngle );
				
				for ( i = 0; i <= _segmentsW; ++i )
				{
					var vertAngle : Number = 2*Math.PI * i / _segmentsW;
					var pX : Number = ringRadius * Math.cos( vertAngle );
					var pY : Number = ringRadius * Math.sin( vertAngle );
					var normLen : Number = 1 / Math.sqrt( pX * pX + pY * pY + pZ * pZ );
					var tanLen : Number = Math.sqrt( pY * pY + pX * pX );
					
					_geometry.normals.push( pX * normLen );
					_geometry.vertices.push( pX );
					_geometry.normals.push( -pZ * normLen );
					_geometry.vertices.push( -pZ );
					_geometry.normals.push( pY * normLen );
					_geometry.vertices.push( pY );
					
					if (i > 0 && j > 0)
					{
						var a : int = (_segmentsW + 1) * j + i;
						var b : int = (_segmentsW + 1) * j + i - 1;
						var c : int = (_segmentsW + 1) * (j - 1) + i - 1;
						var d : int = (_segmentsW + 1) * (j - 1) + i;
						
						if (j == _segmentsH)
						{
							_geometry.indices.push( a );
							_geometry.indices.push( c );
							_geometry.indices.push( d );
						}                   
						else if (j == 1)    
						{                   
							_geometry.indices.push( a );
							_geometry.indices.push( b );
							_geometry.indices.push( c );
						}                   
						else                
						{                   
							_geometry.indices.push( a );
							_geometry.indices.push( b );
							_geometry.indices.push( c );
							
							_geometry.indices.push( a );
							_geometry.indices.push( c );
							_geometry.indices.push( d );
						}
					}
				}
			}
			
			var numUvs : uint = 0;
			for (j = 0; j <= _segmentsH; ++j)
			{
				for (i = 0; i <= _segmentsW; ++i)
				{
					_geometry.uvs.push( 1 - i / _segmentsW );
					_geometry.uvs.push( 1 - j / _segmentsH );
				}
			}
			
		}
	}
}