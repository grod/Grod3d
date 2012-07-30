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
	import se.grod.grod3d.materials.Material;
	import se.grod.grod3d.core.objects.Mesh;
	import se.grod.grod3d.cameras.Camera3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import com.adobe.utils.AGALMiniAssembler;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import com.adobe.utils.PerspectiveMatrix3D;
	import se.grod.grod3d.core.base.Geometry;
	import se.grod.grod3d.utils.ColorUtils;
	import flash.display.BitmapData;
	
	public class PhongNormalSpecularMaterial extends Material
	{
		private var _texture		: BitmapData;
		private var _normalMap		: BitmapData;
		private var _specularMap	: BitmapData;
		private var _diffuseColor 	: uint;
		private var _specularColor 	: uint;
		private var _ambientAmount 	: Number;
		private var _diffuseAmount 	: Number;
		private var _specularAmount : Number;
		private var _glossiness		: Number;
		
		public function PhongNormalSpecularMaterial( texture:BitmapData, normalMap:BitmapData, specularMap:BitmapData, diffuseColor:uint = 0xFFFFFF, specularColor:uint = 0xFFFFFF, ambientAmount:Number = 0.0, diffuseAmount:Number = 0.7, specularAmount:Number = 0.3, glossiness:Number = 100 )
		{
			super();
			
			_texture 		= texture;
			_normalMap 		= normalMap;
			_specularMap 	= specularMap;
			_diffuseColor 	= diffuseColor;
			_specularColor 	= specularColor;
			_ambientAmount 	= ambientAmount;
			_diffuseAmount 	= diffuseAmount;
			_specularAmount = specularAmount;
			_glossiness 	= glossiness;
		}
		
		override public function drawMesh( mesh : Mesh, context:Context3D, camera:Camera3D ) : void
		{
			var g : Geometry = mesh.geometry;
			
			context.setProgram( getProgram( context ) );
			
			var vertexBuffer : VertexBuffer3D = context.createVertexBuffer( g.vertices.length / 3, 3 );
			var normalBuffer : VertexBuffer3D = context.createVertexBuffer( g.normals.length / 3, 3);
			var uvBuffer 	 : VertexBuffer3D = context.createVertexBuffer( g.uvs.length / 2, 2);
			var indexBuffer  : IndexBuffer3D  = context.createIndexBuffer( g.indices.length );
			
			vertexBuffer.uploadFromVector( 	g.vertices, 	0, g.vertices.length / 3 );
			normalBuffer.uploadFromVector( 	g.normals, 		0, g.normals.length / 3 );
			uvBuffer.uploadFromVector( 		g.uvs,			0, g.uvs.length / 2 )
			indexBuffer.uploadFromVector( 	g.indices , 	0, g.indices.length );
			
			var projection:PerspectiveMatrix3D = new PerspectiveMatrix3D();
			projection.perspectiveFieldOfViewRH( 45, 800/600, 1, 1000 ); 
			
			var transform:Matrix3D = new Matrix3D();
			transform.identity();
			transform.append( mesh.transform.clone() )  // Model view matrix
			
			transform.append( camera.transform.clone() ) // Camera view
			//transform.append( camera.projectionMatrix );
			transform.append( projection ); // Projection matrix
			
			var texture:Texture = context.createTexture(_texture.width, _texture.height, Context3DTextureFormat.BGRA, false);
			texture.uploadFromBitmapData( _texture );
			context.setTextureAt(0, texture);
			
			context.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3); // va0 pos
			context.setVertexBufferAt(1, normalBuffer, 0, Context3DVertexBufferFormat.FLOAT_3); // va1 normals
			context.setVertexBufferAt(2, uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2); // va2 uvs
			
		
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, transform, true) // vc0 model view projection matrix
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, mesh.transform.clone(), true); // vc4 mesh transform
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, mesh.reducedTransform.clone(), true); // vc8 Reduced transform
			
			context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 12, Vector.<Number>([camera.x, camera.y, camera.z, 1])); // vc12
			context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 13, Vector.<Number>([0, 200, 30, 1])); // vc13 LIGHT POSITION
			
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, ColorUtils.hexToVector4(_diffuseColor)); // fc0 Diffuse color
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, ColorUtils.hexToVector4(_specularColor)); // fc1, specular color
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, Vector.<Number>([	_ambientAmount, // Ambient amount
																				 						_diffuseAmount, // Diffuse amount
																										_specularAmount, // Specular amount
																					 					_glossiness
																									] // Glossiness
																									)); // fc2, light properties
			
			context.drawTriangles( indexBuffer );
			
		}
		
		private function getProgram( context:Context3D ) : Program3D
		{
			if (_program)
				return _program;
				
			var vShader : AGALMiniAssembler = new AGALMiniAssembler();
			var fShader : AGALMiniAssembler = new AGALMiniAssembler();
			
			vShader.assemble( Context3DProgramType.VERTEX,
				"m44 vt0, va0, vc4\n"+ // calculate vertex positions in scene space
				"sub v0, vc12, vt0\n"+ // interpolate direction to light
				"sub v1, vc13, vt0\n"+ // interpolate direction to camera
				"m44 v2, va1, vc8\n"+ // interpolate normal positions in scene space (ignoring position)
				"mov v3, va2 \n"+ // Move UV to v3
				"m44 op, va0, vc0" // output position to clip space
				
			);
			
			// Implementation from example at http://en.wikipedia.org/wiki/Blinn–Phong_shading_model#Code_sample
			
			fShader.assemble( Context3DProgramType.FRAGMENT,
				"nrm ft0.xyz, v0\n"+ // normalize dir to light
				"nrm ft1.xyz, v1\n"+ // normalize dir to camera
				"nrm ft2.xyz, v2\n"+ // normalize normals
				"tex ft3, v3, fs0<2d, mipnone, linear, repeat>\n"+ // Sample texture
				"dp3 ft4.x, ft2.xyz, ft0.xyz\n"+ // find projection of direction to light on normal
				"sat ft4.x, ft4.x\n"+ // ignore negative values
				"mul ft4.x, ft4.x, fc2.y\n"+ // multiply projection of direction to light on normal with light's diffuse amoun
				"add ft4.x, ft4.x, fc2.x\n"+ // add light's ambient amount
				"mul ft4.xyz, ft4.xxx, ft3.xyz\n"+ // multiply by material's diffuse color
				"add ft5.xyz, ft0.xyz, ft1.xyz\n"+ // evaluate half vector
				"nrm ft5.xyz, ft5.xyz\n"+ // normalize half vector
				"dp3 ft5.x, ft2.xyz, ft5.xyz\n"+ // find projection of half vector on normal
				"sat ft5.x, ft5.x\n"+ // ignore negative values
				"pow ft5.x, ft5.x, fc2.w\n"+ // apply gloss
				"mul ft5.x, ft5.x, fc2.z\n"+ // multiply with specular amount
				"mul ft5.xyz, ft5.xxx, fc1\n"+ // multiply with specular color
				"add ft6.xyz, ft4.xyz, ft5.xyz\n"+ // combine diffuse + specular
				"mov oc, ft6.xyz"
			);
			
			_program = context.createProgram();
			_program.upload( vShader.agalcode, fShader.agalcode );
			return _program;
		}
	}
}