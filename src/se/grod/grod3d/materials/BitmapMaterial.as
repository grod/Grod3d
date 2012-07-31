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
	import se.grod.grod3d.core.base.Geometry;
	import se.grod.grod3d.lights.Light;
	
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.display.BitmapData;
	
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import com.adobe.utils.AGALMiniAssembler;
	
	public class BitmapMaterial extends Material
	{
		private var _textureData	: BitmapData;
		private var _texture		: Texture;
		
		private var _projectionMatrix : Matrix3D;
		
		private var _buffersNeedUpdate : Boolean = true;
		
		public function BitmapMaterial( texture:BitmapData )
		{
			super();
			
			_textureData = texture;
			_projectionMatrix = new Matrix3D();
		}
		
		override public function drawMesh( mesh : Mesh, context:Context3D, camera:Camera3D, lights:Vector.<Light> ) : void
		{
			var g : Geometry = mesh.geometry;
			
			context.setProgram( getProgram( context ) );
			
			_projectionMatrix.identity();
			_projectionMatrix.append( mesh.transform )  // Model view matrix
			_projectionMatrix.append( camera.projectionMatrix );
			
			if (!_texture)
			{
				_texture = context.createTexture(_textureData.width, _textureData.height, Context3DTextureFormat.BGRA, false);
				_texture.uploadFromBitmapData( _textureData );
			}
			context.setTextureAt(0, _texture);
			
			context.setVertexBufferAt(0, g.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3); // va0 pos
			context.setVertexBufferAt(1, g.uvBuffer, 	0, Context3DVertexBufferFormat.FLOAT_2); // va1 uvs
			
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _projectionMatrix, true) // vc0 model view projection matrix
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, mesh.transform, true); // vc4 mesh transform
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, mesh.reducedTransform, true); // fc2 Reduced transform
			context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 12, Vector.<Number>([camera.x, camera.y, camera.z, 1])); // vc12
			
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([0, 1, 2, -1])); // fc0, just some useful values
			context.setProgramConstantsFromMatrix(Context3DProgramType.FRAGMENT, 2, mesh.reducedTransform, true); // fc2 Reduced transform
			
			context.drawTriangles( g.indexBuffer );
		}
		
		private function getProgram( context:Context3D ) : Program3D
		{
			if (_program)
				return _program;
				
			var vShader : AGALMiniAssembler = new AGALMiniAssembler();
			var fShader : AGALMiniAssembler = new AGALMiniAssembler();
			
			var i : int = 0;
			var vArr:Array = [];
			
				vArr.push(		"m44 vt0, va0, vc4"						); // calculate vertex positions in scene space
				vArr.push(		"sub v0, vc12, vt0"						); // interpolate direction to camera
				vArr.push(		"mov v1, va2"							); // Move UV to v2
				vArr.push(		"m44 op, va0, vc0"						); // output position to clip space
			
			vShader.assemble( Context3DProgramType.VERTEX, vArr.join("\n")	);
			
			var fArr:Array = [];			
			
			//fArr.push("nrm ft0.xyz, v1"								); // normalize normals
			fArr.push("tex ft1, v1, fs1<2d, mipnone, linear, repeat>");
			fArr.push("mov oc, ft1.xyz");	// output final render
			
			fShader.assemble( Context3DProgramType.FRAGMENT, fArr.join("\n"));
			
			_program = context.createProgram();
			_program.upload( vShader.agalcode, fShader.agalcode );
			return _program;
		}
	}
}