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
	import com.adobe.utils.AGALMiniAssembler;
	import flash.geom.Matrix3D;
	import com.adobe.utils.PerspectiveMatrix3D;
	import se.grod.grod3d.core.base.Geometry;
	
	public class NormalMaterial extends Material
	{
		public function NormalMaterial()
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
			
			context.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3); // va0 pos
			context.setVertexBufferAt(1, normalBuffer, 0, Context3DVertexBufferFormat.FLOAT_3); // va1 normals
			
			var projection:PerspectiveMatrix3D = new PerspectiveMatrix3D();
			projection.perspectiveFieldOfViewRH( 45, 800/600, 1, 1000 ); 
			
			var transform:Matrix3D = new Matrix3D();
			transform.identity();
			transform.append( mesh.transform.clone() )  // Model view matrix
			transform.append( camera.transform ) // Camera view
			transform.append( projection ); // Projection matrix

			var invTrans:Matrix3D = transform.clone();
			invTrans.transpose();
			invTrans.invert();
			
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, transform, true); // vc0
			
			context.drawTriangles( indexBuffer );
		}
		
		private function getProgram( context:Context3D ) : Program3D
		{
			if (_program)
				return _program;
			var vShader : AGALMiniAssembler = new AGALMiniAssembler();
			vShader.assemble ( 	Context3DProgramType.VERTEX,
								"m44 op, va0, vc0\n"+ // transform vertices
								"m44 v0, va1, vc0"	// transform and copy normal
								);
			var fShader : AGALMiniAssembler = new AGALMiniAssembler();
			fShader.assemble(	Context3DProgramType.FRAGMENT,
								"mov ft0, v0\n"+
								"nrm ft0.xyz, v0\n"+ // normalize
								"mov oc, ft0" // set color
							);
			
			_program = context.createProgram();
			_program.upload( vShader.agalcode, fShader.agalcode );
			return _program;
		}
	}
}