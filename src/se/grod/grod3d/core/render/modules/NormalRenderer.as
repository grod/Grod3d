package se.grod.grod3d.core.render.modules
{	
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	
	import se.grod.grod3d.core.objects.Mesh;
	import se.grod.grod3d.core.Scene3D;
	import se.grod.grod3d.cameras.Camera3D;
	import se.grod.grod3d.core.base.Geometry;
	
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Context3DTextureFormat;
	import com.adobe.utils.AGALMiniAssembler;
	
	public class NormalRenderer extends EventDispatcher
	{
		private var _program : Program3D;
		private var _projectionMatrix : Matrix3D;
		
		public function NormalRenderer()
		{
			_projectionMatrix = new Matrix3D();
			super();
		}
		
		public function draw( mesh : Mesh, context:Context3D, scene : Scene3D, camera : Camera3D ) : void
		{
			var geom : Geometry = mesh.geometry;
			context.setProgram( getProgram( context ) );
			_projectionMatrix.identity();
			_projectionMatrix.append( mesh.transform );
			_projectionMatrix.append( camera.projectionMatrix );
			
			if ( mesh.material.normalMap == null && mesh.material.normalMapData != null)
			{
				mesh.material.normalMap = context.createTexture( mesh.material.normalMapData.width, mesh.material.normalMapData.height, Context3DTextureFormat.BGRA, false );
				mesh.material.normalMap.uploadFromBitmapData( mesh.material.normalMapData );
			}
			context.setTextureAt(0, mesh.material.normalMap);
			
			context.setVertexBufferAt( 0, geom.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3 ); // va0 vertice pos
			context.setVertexBufferAt( 1, geom.normalBuffer, 0, Context3DVertexBufferFormat.FLOAT_3); // va1 normal data
			context.setVertexBufferAt( 2, geom.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2); // va2 uv data
			
			context.setProgramConstantsFromMatrix( Context3DProgramType.VERTEX, 0, _projectionMatrix, true ); 	// vc0 model view projection
			//context.setProgramConstantsFromMatrix( Context3DProgramType.VERTEX, 4, mesh.transform, true );		// vc4 mesh transform
			context.setProgramConstantsFromMatrix( Context3DProgramType.VERTEX, 4, mesh.reducedTransform, true );// vc8 reduced transform
			
			context.drawTriangles( geom.indexBuffer ); 
			
			clearContext(context);
		}
		
		private function clearContext( context : Context3D ) : void
		{
			context.setVertexBufferAt( 0, null ); // va0 vertice pos
			context.setVertexBufferAt( 1, null); // va1 uv data
			context.setVertexBufferAt( 2, null); // va1 uv data
			context.setTextureAt(0, null);
		}
		
		private function getProgram( context : Context3D ) : Program3D
		{
			if (_program)
				return _program;
				
			var vShader : AGALMiniAssembler = new AGALMiniAssembler();
			var fShader : AGALMiniAssembler = new AGALMiniAssembler();
			var vArr : Array = [];
			var fArr : Array = [];
			
				// Vertex program
				vArr.push(	"m44 vt0, va0, vc0");
				vArr.push(	"mov op, vt0");
				vArr.push(  "m44 v0, va1, vc4" );	// Normal
				vArr.push(	"mov v1, va2");	// UVs
				
			vShader.assemble( Context3DProgramType.VERTEX, vArr.join("\n") );
			
				// Fragment program
				fArr.push(	"nrm ft1.xyz, v0");
				fArr.push(	"tex ft0, v1, fs0<2d, mipnone, linear, repeat>");
				fArr.push(	"neg ft1.z, ft1.z");
				fArr.push(	"add ft1.xyz, ft1.xyz, ft0.xyz");
				fArr.push(	"nrm ft1.xyz, ft1.xyz");
				fArr.push(	"mov oc, ft1.xyz"	);
			fShader.assemble( Context3DProgramType.FRAGMENT, fArr.join("\n") );
			
			_program = context.createProgram();
			_program.upload( vShader.agalcode, fShader.agalcode );
			
			return _program;
		}

	}
}