package se.grod.grod3d.core.render
{	
	import se.grod.grod3d.core.Scene3D;
	import se.grod.grod3d.core.render.modules.NormalRenderer;
	import se.grod.grod3d.core.render.modules.LightRenderer;
	import se.grod.grod3d.core.render.Stage3DRenderer;
	import se.grod.grod3d.core.objects.Object3D;
	import se.grod.grod3d.core.objects.Mesh;
	import se.grod.grod3d.core.render.modules.DepthRenderer;
	import se.grod.grod3d.core.render.modules.DiffuseRenderer;
	import se.grod.grod3d.core.Viewport3D;
	import se.grod.grod3d.cameras.Camera3D;
	import se.grod.grod3d.lights.Light;
	
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.textures.Texture;
	
	public class DeferredRenderer extends Stage3DRenderer
	{
		private var _depthRenderer : DepthRenderer;
		private var _diffuseRenderer : DiffuseRenderer;
		private var _normalRenderer : NormalRenderer;
		private var _lightRenderer : LightRenderer;
		
		private var _depthTexture : Texture;
		private var _diffuseTexture : Texture;
		private var _normalTexture : Texture;
		private var _lightTexture : Texture;
		
		public function DeferredRenderer( viewport : Viewport3D, antialias : uint = ANTIALIAS_HIGH_QUALITY ) : void
		{
			_depthRenderer = new DepthRenderer();
			_diffuseRenderer = new DiffuseRenderer();
			_normalRenderer = new NormalRenderer();
			_lightRenderer = new LightRenderer();
			super(viewport, antialias);
		}
		
		override public function draw( scene:Scene3D, camera:Camera3D ) : Boolean
		{
			if ( !available ) return false;
			
			if (!_depthTexture)
				_depthTexture = _context3D.createTexture( 1024, 1024, Context3DTextureFormat.BGRA, true );
			if (!_diffuseTexture)
				_diffuseTexture = _context3D.createTexture( 1024, 1024, Context3DTextureFormat.BGRA, true );
			if (!_normalTexture)
			 	_normalTexture = _context3D.createTexture( 1024, 1024, Context3DTextureFormat.BGRA, true );
			if (!_lightTexture)
			 	_lightTexture = _context3D.createTexture( 1024, 1024, Context3DTextureFormat.BGRA, true );
			
			
			var renderables : Vector.<Object3D> = scene.children;
			var numRenderables : uint = renderables.length;
			
			var lights : Vector.<Light> = scene.lights;
			var numLights:uint = lights.length;
			context.setCulling( Context3DTriangleFace.NONE );
			
			camera.update();
			
			for (var i : int = 0; i < numRenderables; i++)
			{
				renderables[i].update();
				if (renderables[i] is Mesh)
					Mesh( renderables[i] ).geometry.update( _context3D );
			}
			
			// Draw
			
			// Depth pass
			_context3D.setRenderToTexture( _depthTexture, true, _antialias );
			_context3D.clear(.1,.1,.1,1);
			renderDepth( scene, camera, renderables );
			
			// Diffuse pass
			_context3D.setRenderToTexture( _diffuseTexture, true, _antialias );
			_context3D.clear(.1,.1,.1,1);
			renderDiffuse(scene, camera, renderables );
			
			// Normal pass
			_context3D.setRenderToTexture( _normalTexture, true, _antialias );
			_context3D.clear(.1,.1,.1,1);
			renderNormal(scene, camera, renderables);
			
			// Lighting pass
			for (var j : int = 0; j < lights.length; j++)
			{
				_context3D.setRenderToBackBuffer();
				_context3D.clear(.1,.1,.1,1);
				_context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
				if (j > 0)
					_context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE);
				renderLights(scene, camera, lights[j]);
				
				//else
				//	_context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			}
			
			_context3D.present();
									
			return true;
		}
		
		private function renderDepth(scene:Scene3D, camera:Camera3D, renderables : Vector.<Object3D> ) : void
		{
			var renderable : Object3D;
			for (var i : int = 0; i < renderables.length; i++)
			{
				renderable = renderables[i];
				if (renderable is Mesh && renderable.visible)
				{
					_depthRenderer.draw( renderable as Mesh, _context3D, scene, camera );
				}
			}
		}
		
		private function renderDiffuse(scene:Scene3D, camera:Camera3D, renderables : Vector.<Object3D> ) : void
		{
			var renderable : Object3D;
			for (var i : int = 0; i < renderables.length; i++)
			{
				renderable = renderables[i];
				if (renderable is Mesh && renderable.visible)
				{
					_diffuseRenderer.draw( renderable as Mesh, _context3D, scene, camera );
				}
			}
		}
		
		private function renderNormal(scene:Scene3D, camera:Camera3D, renderables : Vector.<Object3D>) : void
		{
			var renderable : Object3D;
			for (var i : int = 0; i < renderables.length; i++)
			{
				renderable = renderables[i];
				if (renderable is Mesh && renderable.visible)
				{
					_normalRenderer.draw( renderable as Mesh, _context3D, scene, camera );
				}
			}
		}
		
		private function renderLights(scene:Scene3D, camera:Camera3D, light:Light) : void
		{
			_lightRenderer.draw(_context3D, scene, camera, light, _depthTexture, _diffuseTexture, _normalTexture);
		}
	}
}