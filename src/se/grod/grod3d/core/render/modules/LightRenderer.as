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
	import se.grod.grod3d.lights.Light;
	import se.grod.grod3d.utils.ColorUtils;
	
	public class LightRenderer extends EventDispatcher
	{
		private var _program : Program3D;
		private var _projectionMatrix : Matrix3D;
		
		private var _vertexBuffer : VertexBuffer3D;
		private var _indexBuffer : IndexBuffer3D;
		private var _uvBuffer : VertexBuffer3D;
		
		public function LightRenderer()
		{
			_projectionMatrix = new Matrix3D();
			super();
		}
		
		private function setupBuffers( context : Context3D ) : void
		{
			var vertices : Vector.<Number> = Vector.<Number>([
				-1, -1, 0,  // x, y, z
				-1, 1, 0, 
				1, 1, 0, 
				1, -1, 0,
			]);
			
			var uvs : Vector.<Number> = Vector.<Number>([
				0, 1, // u, v
				0, 0,
				1, 0,
				1, 1
			]);
			_vertexBuffer = context.createVertexBuffer( 4, 3 );
			_uvBuffer = context.createVertexBuffer(4, 2);
			_indexBuffer = context.createIndexBuffer( 6 );
			
			_uvBuffer.uploadFromVector( uvs, 0, 4 );
			_vertexBuffer.uploadFromVector( vertices, 0, 4 );
			_indexBuffer.uploadFromVector( Vector.<uint>([0, 1, 2, 2, 3, 0]), 0, 6 );
		}
		
		public function draw( context:Context3D, scene : Scene3D, camera : Camera3D, light : Light, depthMap : Texture, diffuseMap : Texture, normalMap : Texture ) : void
		{
			context.setProgram( getProgram( context ) );
			
			//_projectionMatrix.identity();
			//_projectionMatrix.append(	""	);
			
			if (!_vertexBuffer || !_indexBuffer)
				setupBuffers( context );
				
			context.setTextureAt(0, depthMap);
			context.setTextureAt(1, diffuseMap);
			context.setTextureAt(2, normalMap);
			
			context.setVertexBufferAt( 0, _vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3 ); // va0 vertice pos
			context.setVertexBufferAt( 1, _uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2 ); // va0 vertice pos
			_projectionMatrix.identity();
			context.setProgramConstantsFromVector( Context3DProgramType.VERTEX, 0, Vector.<Number>([camera.x, camera.y, camera.z, 1]) ); // vc0
			context.setProgramConstantsFromVector( Context3DProgramType.VERTEX, 1, Vector.<Number>([light.x, light.y, light.z, 1]) ); // vc4 light position
			context.setProgramConstantsFromVector( Context3DProgramType.FRAGMENT, 0, Vector.<Number>([
																									0.02, // Ambient amount
																									0.3, // Diffuse amount
																									3.6, // Specular amount
																									30 // Glossiness
																									]) );
																									
			context.setProgramConstantsFromVector( Context3DProgramType.FRAGMENT, 1, ColorUtils.hexToVector4(light.color) ); // Spec color

			context.drawTriangles( _indexBuffer );
			
			clearContext(context);
		}
		
		private function clearContext( context : Context3D ) : void
		{
			context.setVertexBufferAt( 0, null ); // va0 vertice pos
			context.setVertexBufferAt( 1, null); // va1 uv data
			context.setTextureAt(0, null);
			context.setTextureAt(1, null);
			context.setTextureAt(2, null);
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
				vArr.push(	"mov op, va0");
				vArr.push(  "mov v0, va1" );	// UV
				vArr.push(	"mov v1, vc0"	);	// Camera position
				vArr.push(	"mov v2, vc1");	// Light pos
				//vArr.push(	"m44 op, va0, vc0"	); 	// Vertex position in scene space
				//vArr.push(	"mov v0, vc4");
			vShader.assemble( Context3DProgramType.VERTEX, vArr.join("\n") );
			
				// Fragment program
				// http://www.codinglabs.net/tutorial_def_rendering_1.aspx
				
				fArr.push("mov ft0, v0");
				fArr.push("tex ft0, v0, fs0<2d, mipnone, linear, repeat>" ); // Depth
				fArr.push("tex ft1, v0, fs1<2d, mipnone, linear, repeat>" ); // Diffuse
				fArr.push("tex ft2, v0, fs2<2d, mipnone, linear, repeat>" ); // Normal
				fArr.push("mov ft0.xy, v0.xy"); // move xy values to depth value
				
				fArr.push("nrm ft2.xyz, ft2.xyz"); // Normalize normals
				fArr.push("neg ft2.z, ft2.z");
				
				fArr.push("sub ft3, v2, ft0");	// LightDir light - position
				fArr.push("nrm ft3.xyz, ft3.xyz");	// Normalize lightdir
				
				fArr.push("sub ft4, v1, ft0");	// Eye direction
				fArr.push("nrm ft4.xyz, ft4.xyz"); // normalize eye dir
				
				// DIFFUSE
				fArr.push("dp3 ft6.x, ft2.xyz, ft3.xyz"); // Find dot between normal & light direction
				fArr.push("sat ft6.x, ft6.x");
				fArr.push("mul ft6.x, ft6.x, fc0.y"); // Multiply by diffuse amount
				fArr.push("add ft6.x, ft6.x, fc0.x"); // add ambient amount
				fArr.push("mul ft6.xyz, ft6.xxx, ft1.xyz");	// Final diffuse value
				
				
				// SPECULAR
				fArr.push("add ft5.xyz, ft3.xyz, ft4.xyz"); // Half vector
				fArr.push("nrm ft5.xyz, ft5.xyz"); // Normalize half vector
				fArr.push("dp3 ft5.x, ft2.xyz, ft5.xyz"); // Dot between normal and halfvector
				
				fArr.push("pow ft5.x, ft5.x, fc0.w");	// Glossiness
				
				fArr.push("mul ft5.x, ft5.x, fc0.z");	// Spec amount
				fArr.push("mul ft5.xyz, ft5.xxx, fc1.xyz"); // multiply by spec color
				// Specular pow(   dot(normal,vHalfVector),9   )*10;
				
				fArr.push("sat ft5.xyx, ft5.xyz"); // Ignore negatives
				fArr.push("sat ft6.xyx, ft6.xyz"); // Ignore negatives
				fArr.push(	"add oc, ft5.xyz, ft6.xyz"	);
				
			fShader.assemble( Context3DProgramType.FRAGMENT, fArr.join("\n") );
			
			_program = context.createProgram();
			_program.upload( vShader.agalcode, fShader.agalcode );
			
			return _program;
		}

	}
}