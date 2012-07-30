/**

	Author: Gustav Buchholtz (gustav.buchholtz@gmail.com), http://www.grod.se/
	
	* ----------------------------------------------------------------------------
	* "THE BEER-WARE LICENSE" (Revision 42):
	* Gustav Buchholtz wrote this file. As long as you retain this notice you
	* can do whatever you want with this stuff. If we meet some day, and you think
	* this stuff is worth it, you can buy me a beer in return.
	* ---------------------------------------------------------------------------- 
*/


package se.grod.grod3d.materials
{	
    import com.adobe.utils.AGALMiniAssembler;

    import flash.display3D.Context3DProgramType;
    import flash.display3D.Program3D;
	import flash.display3D.textures.Texture;
	import flash.utils.ByteArray;
	import se.grod.grod3d.core.objects.Mesh;
	import se.grod.grod3d.cameras.Camera3D;
	import flash.display3D.Context3D;
	import flash.geom.Vector3D;
	import se.grod.grod3d.lights.Light;
	import flash.display.BitmapData;
	
	public class Material
	{
		protected var _program			: Program3D;
		protected var _vertexShader 	: String;
		protected var _fragmentShader 	: String;
		
		protected var _vertexAssembly	:AGALMiniAssembler;
		protected var _fragmentAssembly	:AGALMiniAssembler;
		
		protected var _lights			: Array;
		protected var _doubleSided		: Boolean = false;
		
		protected var _texture			: Texture;
		protected var _textureData		: BitmapData;
		protected var _normalMap		: Texture;
		protected var _normalMapData	: BitmapData;
		
		public function Material( lights : Array = null ) : void
		{
			_lights = lights;
			_vertexAssembly		= new AGALMiniAssembler();
			_fragmentAssembly 	= new AGALMiniAssembler();
		}
		
		public function compileShaders() : void
		{
			_vertexAssembly.assemble( 	Context3DProgramType.VERTEX, _vertexShader, false );
			_fragmentAssembly.assemble( Context3DProgramType.FRAGMENT, _fragmentShader, false );
		}
		
		public function drawMesh( mesh : Mesh, context:Context3D, camera:Camera3D, lights:Vector.<Light> ) : void
		{
			// Abstract
		}
		
		public function clear() : void
		{
			// Abstract
		}
		
		public function get vertex_agal():ByteArray		{ return _vertexAssembly.agalcode;   }
		public function get fragment_agal():ByteArray	{ return _fragmentAssembly.agalcode; }
		
		public function get doubleSided() : Boolean {return _doubleSided}
		public function set doubleSided(value : Boolean) : void
		{
			_doubleSided = value;
		}
		
		public function get texture() : Texture {return _texture}
		public function set texture( value : Texture ) : void
		{
			_texture = value;
		}
		public function get textureData() : BitmapData {return _textureData}
		
		public function get normalMap() : Texture {return _normalMap}
		public function set normalMap( value : Texture ) : void
		{
			_normalMap = value;
		}
		public function get normalMapData() : BitmapData {return _normalMapData}
	}
}