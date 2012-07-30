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
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.geom.Vector3D;
	import com.adobe.utils.AGALMiniAssembler;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import com.adobe.utils.PerspectiveMatrix3D;
	import se.grod.grod3d.core.base.Geometry;
	import se.grod.grod3d.utils.ColorUtils;
	import flash.display.BitmapData;
	import se.grod.grod3d.lights.Light;
	
	public class PhongTextureMaterial extends Material
	{	
		private var _ambientAmount 	: Number;
		private var _diffuseAmount 	: Number;
		private var _specularAmount : Number;
		private var _glossiness		: Number;
		
		private var _projectionMatrix : Matrix3D;
		
		private var _buffersNeedUpdate : Boolean = true;
		
		public function PhongTextureMaterial( texture:BitmapData, normalMap:BitmapData, ambientAmount:Number = 0.0, diffuseAmount:Number = 0.7, specularAmount:Number = 0.3, glossiness:Number = 100 )
		{
			super();
			
			_textureData = texture;
			_normalMapData = normalMap;
			_ambientAmount = ambientAmount;
			_diffuseAmount = diffuseAmount;
			_specularAmount = specularAmount;
			_glossiness = glossiness;
			_projectionMatrix = new Matrix3D();
		}
		
		override public function drawMesh( mesh : Mesh, context:Context3D, camera:Camera3D, lights:Vector.<Light> ) : void
		{
			var g : Geometry = mesh.geometry;
			
			context.setProgram( getProgram( context, lights.length ) );
			
			_projectionMatrix.identity();
			_projectionMatrix.append( mesh.transform )  // Model view matrix
			_projectionMatrix.append( camera.projectionMatrix );
			
			if (!_texture)
			{
				_texture = context.createTexture(_textureData.width, _textureData.height, Context3DTextureFormat.BGRA, false);
				_texture.uploadFromBitmapData( _textureData );
			}
			context.setTextureAt(0, _texture);
			
			if ( _normalMapData )
			{
				if (!_normalMap)
				{
					_normalMap = context.createTexture( _normalMapData.width, _normalMapData.height, Context3DTextureFormat.BGRA, false );
					_normalMap.uploadFromBitmapData( _normalMapData );
				}
				context.setTextureAt(1, _normalMap);
			}
			
			
			context.setVertexBufferAt(0, g.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3); // va0 pos
			context.setVertexBufferAt(1, g.normalBuffer, 0, Context3DVertexBufferFormat.FLOAT_3); // va1 normals
			context.setVertexBufferAt(2, g.uvBuffer, 	0, Context3DVertexBufferFormat.FLOAT_2); // va2 uvs
			
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _projectionMatrix, true) // vc0 model view projection matrix
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, mesh.transform, true); // vc4 mesh transform
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, mesh.reducedTransform, true); // fc2 Reduced transform
			context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 12, Vector.<Number>([camera.x, camera.y, camera.z, 1])); // vc12
			
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([0, 1, 2, -1])); // fc0, just some useful values
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([	
																										_ambientAmount, // Ambient amount
																				 						_diffuseAmount, // Diffuse amount
																										_specularAmount, // Specular amount
																					 					_glossiness // Glossiness
																									] 
																									));
			context.setProgramConstantsFromMatrix(Context3DProgramType.FRAGMENT, 2, mesh.reducedTransform, true); // fc2 Reduced transform
			
			var light:Light = lights[0];
			for (var i : int = 0; i < lights.length; i++)
			{
				context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 6 + i, ColorUtils.hexToVector4(lights[i].color)); // fc2, specular color
				context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 13 + i, Vector.<Number>([lights[i].x, lights[i].y, lights[i].z, 1])); // vc13 LIGHT POSITION
			}
			
			context.drawTriangles( g.indexBuffer );
		}
		
		private function getProgram( context:Context3D, len:int ) : Program3D
		{
			if (_program)
				return _program;
				
			var vShader : AGALMiniAssembler = new AGALMiniAssembler();
			var fShader : AGALMiniAssembler = new AGALMiniAssembler();
			
			var i : int = 0;
			var vArr:Array = [];
			
				vArr.push(		"m44 vt0, va0, vc4"						); // calculate vertex positions in scene space
				vArr.push(		"sub v0, vc12, vt0"						); // interpolate direction to camera
				vArr.push(		"m44 v1, va1, vc8"						); // interpolate normal positions in scene space (ignoring position)
				//vArr.push("mov v1, va1");
				vArr.push(		"mov v2, va2"							); // Move UV to v2
				for (i = 0; i < len; i++)
					vArr.push(	"sub v"+(3+i)+", vc"+(13+i)+", vt0"		); // interpolate direction to light 1
				vArr.push(		"m44 op, va0, vc0"						); // output position to clip space
			
			vShader.assemble( Context3DProgramType.VERTEX, vArr.join("\n")	);
			



			var fArr:Array = [];			
			
			fArr.push("nrm ft0.xyz, v1"								); // normalize normals
			fArr.push("tex ft1, v2, fs1<2d, mipnone, linear, repeat>");
			
			if ( _normalMapData )
			{
				fArr.push("mul ft1, ft1, fc0.z" );
				fArr.push("sub ft1, ft1, fc0.y" );
				fArr.push("neg ft1.z, ft1.z");
				fArr.push("add ft1.xyz, ft1.xyz, ft0.xyz");
				fArr.push("nrm ft1.xyz, ft1.xyz");
			}
			else
				fArr.push("mov ft1.xyz, ft0.xyz");
			
			fArr.push("tex ft2, v2, fs0<2d, mipnone, linear, repeat>"	); // Sample texture
			fArr.push("mov ft7.xyz, fc0.xxx"); // Final color. Starts at 0,0,0
			
			fArr.push("nrm ft0.xyz, v0"								); // normalize dir to camera
			for (i = 0; i < len; i++)  // Loop for lights
			{
				fArr.push("nrm ft3.xyz, v"+(3+i)); // Normalize direction to light
				
				// DIFFUSE
				
				fArr.push("dp3 ft4.x, ft1.xyz, ft3.xyz  ");		// find projection of direction to light on normal
				fArr.push("sat ft4.x, ft4.x");					// ignore negative values
				fArr.push("mul ft4.x, ft4.x, fc1.y");			// multiply with light's diffuse amount
				fArr.push("add ft4.x, ft4.x, fc1.x");			// add light's ambient amount
				fArr.push("mul ft4.xyz, ft4.xxx, ft2.xyz");		// multiply by material's diffuse color
				//fArr.push("mov oc, ft4.xyz");
				
				// SPECULAR
				
				
				fArr.push("add ft5.xyz, ft3.xyz, ft0.xyz");		// Evaluate half vector
				fArr.push("nrm ft5.xyz, ft5.xyz");				// normalize half vector
				fArr.push("dp3 ft5.x, ft1.xyz, ft5.xyz");		// find projection of half vector on normal
				fArr.push("sat ft5.x, ft5.x");					// ignore negative values
				fArr.push("pow ft5.x, ft5.x, fc1.w");			// apply gloss
				fArr.push("mul ft5.x, ft5.x, fc1.z");			// multiply with specular amount
				fArr.push("mul ft5.xyz, ft5.xxx, fc"+(6+i));	// multiply with specular color
				
				
				fArr.push("add ft6.xyz, ft4.xyz, ft5.xyz");		// Add to this lights final value
				fArr.push("add ft7.xyz, ft7.xyz, ft6.xyz");		// Add this light to final render
			}
			fArr.push("mov oc, ft7.xyz");	// output final render
			
			fShader.assemble( Context3DProgramType.FRAGMENT, fArr.join("\n"));
			
			_program = context.createProgram();
			_program.upload( vShader.agalcode, fShader.agalcode );
			return _program;
		}
	}
}