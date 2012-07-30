package se.grod.grod3d.core.render.modules
{	
	import flash.events.EventDispatcher;
	import se.grod.grod3d.core.objects.Mesh;
	import se.grod.grod3d.core.Scene3D;
	import se.grod.grod3d.cameras.Camera3D;
	import se.grod.grod3d.core.base.Geometry;
	
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
	import com.adobe.utils.AGALMiniAssembler;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	public class DepthRenderer extends EventDispatcher
	{
		private var _program : Program3D;
		private var _projectionMatrix : Matrix3D;
		
		public function DepthRenderer()
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
			
			context.setVertexBufferAt( 0, geom.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3 ); // va0 vertice pos
			
			context.setProgramConstantsFromMatrix( Context3DProgramType.VERTEX, 0, _projectionMatrix, true ); 	// vc0 model view projection
			
			context.setProgramConstantsFromVector( Context3DProgramType.FRAGMENT, 0, Vector.<Number>([1, 100, 1/100, 1]) );
			
			context.drawTriangles( geom.indexBuffer ); 
			
			clearContext(context);
		}
		
		private function clearContext( context : Context3D ) : void
		{
			context.setVertexBufferAt( 0, null ); // va0 vertice pos
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
				vArr.push(	"m44 vt0, va0, vc0"); // To scene space
				vArr.push(	"mov op, vt0");
				vArr.push(	"mov v0, vt0");
				
			vShader.assemble( Context3DProgramType.VERTEX, vArr.join("\n") );
			
				// Fragment program
				fArr.push(	"mul ft0.z, v0.z, fc0.z");	// depth value * inverted far plane
				fArr.push(	"sub ft0.z, fc0.x, ft0.z");	// 1 - depth value
				fArr.push(	"mov oc, ft0.z"	);
			fShader.assemble( Context3DProgramType.FRAGMENT, fArr.join("\n") );
			
			_program = context.createProgram();
			_program.upload( vShader.agalcode, fShader.agalcode );
			
			return _program;
		}

	}
}