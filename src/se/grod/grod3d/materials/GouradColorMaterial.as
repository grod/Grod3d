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
	
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.IndexBuffer3D;
	
	import com.adobe.utils.AGALMiniAssembler;
	import com.adobe.utils.PerspectiveMatrix3D;
	import flash.geom.Matrix3D;

	public class GouradColorMaterial extends Material
	{
		public function GouradColorMaterial()
		{
			super();
		}
		
		override public function drawMesh( mesh : Mesh, context:Context3D, camera:Camera3D ) : void
		{
			var g : Geometry = mesh.geometry;
			
			context.setProgram( getProgram( context ) );
			
			var vertexBuffer : VertexBuffer3D = context.createVertexBuffer( g.vertices.length / 3, 3 );
			var normalBuffer : VertexBuffer3D = context.createVertexBuffer( g.normals.length / 3, 3);
			var indexBuffer  : IndexBuffer3D  = context.createIndexBuffer( g.indices.length );
			
			vertexBuffer.uploadFromVector( 	g.vertices, 	0, g.vertices.length / 3 );
			normalBuffer.uploadFromVector( 	g.normals, 		0, g.normals.length / 3 );
			indexBuffer.uploadFromVector( 	g.indices , 	0, g.indices.length );
			
			var projection:PerspectiveMatrix3D = new PerspectiveMatrix3D();
			projection.perspectiveFieldOfViewRH( 45, 800/600, 1, 1000 ); 
			
			var transform:Matrix3D = new Matrix3D();
			transform.identity();
			transform.append( mesh.transform.clone() )  // Model view matrix
			
			transform.append( camera.transform.clone() ) // Camera view
			//transform.append( camera.projectionMatrix );
			transform.append( projection ); // Projection matrix
			
			context.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3); // va0 pos
			context.setVertexBufferAt(1, normalBuffer, 0, Context3DVertexBufferFormat.FLOAT_3); // va1 normals
			
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, transform, true) // vc0 model view projection matrix
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, mesh.transform.clone(), true); // vc4 mesh transform
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, mesh.reducedTransform.clone(), true); // vc8 Reduced transform
			
			context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 12, Vector.<Number>([camera.x, camera.y, camera.z, 1])); // vc12
			context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 13, Vector.<Number>([0, 0, -30, 1])); // vc13
			
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([	 0.5,0.5,0.5,1])); // fc0 Diffuse color
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([	 1, 1, 1, 1])); // fc1, specular color
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, Vector.<Number>([	.2, // Ambient amount
																				 						.8, // Diffuse amount
																										.8, // Specular amount
																					 					40] // Glossiness
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
				"m44 op, va0, vc0" // output position to clip space
				
			);
			
			// Implementation from example at http://en.wikipedia.org/wiki/Blinn–Phong_shading_model#Code_sample
			
			fShader.assemble( Context3DProgramType.FRAGMENT,
				"nrm ft0.xyz, v0\n"+ // normalize dir to light
				"nrm ft1.xyz, v1\n"+ // normalize dir to camera
				"nrm ft2.xyz, v2\n"+ // normalize normals
				"dp3 ft3.x, ft2.xyz, ft0.xyz\n"+ // find projection of direction to light on normal
				"sat ft3.x, ft3.x\n"+ // ignore negative values
				"mul ft3.x, ft3.x, fc2.y\n"+ // multiply projection of direction to light on normal with light's diffuse amoun
				"add ft3.x, ft3.x, fc2.x\n"+ // add light's ambient amount
				"mul ft3.xyz, ft3.xxx, fc0.xyz\n"+ // multiply by material's diffuse color
				"add ft4.xyz, ft0.xyz, ft1.xyz\n"+ // evaluate half vector
				"nrm ft4.xyz, ft4.xyz\n"+ // normalize half vector
				"dp3 ft4.x, ft2.xyz, ft4.xyz\n"+ // find projection of half vector on normal
				"sat ft4.x, ft4.x\n"+ // ignore negative values
				"pow ft4.x, ft4.x, fc2.w\n"+ // apply gloss
				"mul ft4.x, ft4.x, fc2.z\n"+ // multiply with specular amount
				"mul ft4.xyz, ft4.xxx, fc1\n"+ // multiply with specular color
				"add ft5.xyz, ft3.xyz, ft4.xyz\n"+ // combine diffuse + specular
				"mov oc, ft5.xyz"
			);
			
			_program = context.createProgram();
			_program.upload( vShader.agalcode, fShader.agalcode );
			return _program;
		}
	}
}