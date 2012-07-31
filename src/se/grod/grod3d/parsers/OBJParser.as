/**

	Author: Gustav Buchholtz (gustav.buchholtz@gmail.com), http://www.grod.se/
	
	* ----------------------------------------------------------------------------
	* "THE BEER-WARE LICENSE" (Revision 42):
	* Gustav Buchholtz wrote this file. As long as you retain this notice you
	* can do whatever you want with this stuff. If we meet some day, and you think
	* this stuff is worth it, you can buy me a beer in return.
	* ---------------------------------------------------------------------------- 
*/


package se.grod.grod3d.parsers
{	
	import se.grod.grod3d.core.base.Geometry;
	import se.grod.grod3d.core.objects.Mesh;
	
	public class OBJParser extends Mesh
	{
		private var _rawData	: String;
		private var _vertices	: Vector.<Number>;
		private var _uvs		: Vector.<Number>;
		private var _normals	: Vector.<Number>;
		private var _indices	: Vector.<uint>;
		
		private var _vertexBuffer	: Vector.<Number>;
		private var _indexBuffer	: Vector.<uint>;
		
		private var _faceIndex : uint;
		
		private var _inverted : Boolean = false; // Inverted x / z (3d studio max)
		
		private var _modelScale : Number = 1;
		
		public function OBJParser( mScale : Number = 1, inverted : Boolean = false)
		{
			_inverted = inverted;
			_modelScale = mScale;
			super();
		}
		
		public function build( rawData:String ) : void
		{
			log("i Building Mesh");
			_rawData = rawData;
			_vertices 	= new Vector.<Number>();
			_uvs 		= new Vector.<Number>();
			_normals 	= new Vector.<Number>();
			_indices 	= new Vector.<uint>();
			_faceIndex = 0;
			
			_vertexBuffer = new Vector.<Number>();
			_indexBuffer = new Vector.<uint>();
			
			_geometry = new Geometry();
			
			var lines:Array = _rawData.split('\n');
			for (var i : int = 0; i < lines.length; i++)
			{
				parseLine( lines[i] );
			}
			log("i Done building... create mesh.");
		}
		
		private function parseLine( line : String ) : void
		{
			while (line.indexOf("  ") > -1)
				line = line.replace("  ", " ");
			while (line.indexOf("//") > -1)
				line = line.replace("//", "/");
				
			var words:Array = line.split(" ");
			var data:Array = words.slice(1);
			var type:String = words[0];
			switch ( type )
			{
				case 'g': // break
				break;
				
				case 'v': // vertex
					parseVertex(data);
				break;
				
				case 'vt': // UV
					parseUV(data);
				break;
				
				case 'vn':
					parseVertexNormal(data);
				break;
				
				case 'f': // face
				case 'fo':
					parseIndex(data);
				break;
			}
		}
		
		private function parseVertex( data : Array ) : void
		{
			_vertices.push(data[0] * _modelScale);
			_vertices.push(data[1] * _modelScale);
			_vertices.push(data[2] * _modelScale);
		}
		
		private function parseUV( data : Array ) : void
		{
			_uvs.push(data[0]);
			_uvs.push(data[1]);
		}
		
		private function parseVertexNormal( data : Array ) : void
		{
			_normals.push(data[0]);
			_normals.push(data[1]);
			_normals.push(data[2]);
		}

		private function parseIndex( data : Array ) : void
		{
			for (var i : int = 0; i < data.length; i++)
			{
				var sData:Array = data[i].split("/");
				var vertInd : 	int = int(sData[0]) - 1;
				var uvInd : 	int = -1;
				var normInd : 	int = -1;
				
				if (sData.length == 2)
				{
					normInd = int(sData[1]) - 1;
				}
				if (sData.length >= 3)
				{
					uvInd = int(sData[1]) - 1;
					normInd = int(sData[2]) - 1;
				}
				
				var index:uint = 0;
				
				// Vertex
				index = vertInd * 3;
				if (vertInd > -1)
					addVertex(_vertices[index], _vertices[index+1], _vertices[index+2]);
				
				// Color
				addColor(1, 1, 1);
				
				// Normal
				index = normInd * 3;
				if (normInd > -1)
					addNormal(_normals[index], _normals[index+1], _normals[index+2]);
				
				// UV
				index = uvInd * 2;
				if (uvInd > -1 && _uvs.length >= index+1)
					addUv( _uvs[index], -_uvs[index+1])
			}
			
			_geometry.indices.push(_faceIndex, _faceIndex + 1, _faceIndex + 2);
			_faceIndex += 3;
		}
		
		private function addColor(r:Number, g:Number, b:Number) : void
		{
			_geometry.colors.push(r,g,b);
		}
		
		private function addVertex(x:Number, y:Number, z:Number) : void
		{
			if (_inverted)
				_geometry.vertices.push(z,y,x);
			else
				_geometry.vertices.push(x,y,z);
		}
		
		private function addNormal(x:Number, y:Number, z:Number) : void
		{
			if (_inverted)
				_geometry.normals.push(z,y,x);
			else
				_geometry.normals.push(x,y,z);
		}
		
		private function addUv(u:Number, v:Number) : void
		{
			_geometry.uvs.push(u,v);
		}
	}
}