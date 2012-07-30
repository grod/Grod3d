/**

	Author: Gustav Buchholtz (gustav.buchholtz@gmail.com), http://www.grod.se/
	
	* ----------------------------------------------------------------------------
	* "THE BEER-WARE LICENSE" (Revision 42):
	* Gustav Buchholtz wrote this file. As long as you retain this notice you
	* can do whatever you want with this stuff. If we meet some day, and you think
	* this stuff is worth it, you can buy me a beer in return.
	* ---------------------------------------------------------------------------- 
*/


package se.grod.grod3d.core.render
{	
	import se.grod.grod3d.core.render.Renderer;
	import se.grod.grod3d.core.objects.Object3D;
	import se.grod.grod3d.core.objects.Mesh;
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Program3D;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.events.Event;
	import se.grod.grod3d.core.Viewport3D;
	import se.grod.grod3d.core.Scene3D;
	import se.grod.grod3d.cameras.Camera3D;
	import se.grod.grod3d.core.base.Geometry;
	import com.adobe.utils.AGALMiniAssembler;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	import flash.utils.getTimer;
	import com.adobe.utils.PerspectiveMatrix3D;
	import flash.display.BitmapData;
	import se.grod.grod3d.materials.Material;
	import se.grod.grod3d.lights.Light;
	
	public class Stage3DRenderer extends Renderer
	{
		public static const ANTIALIAS_NONE : uint = 0;
		public static const ANTIALIAS_MINIMAL : uint = 2;
		public static const ANTIALIAS_HIGH_QUALITY : uint = 4;
		public static const ANTIALIAS_VERY_HIGH_QUALITY : uint = 16;
		protected var _antialias : uint;
		
		protected var _stage3D 	: Stage3D;
		protected var _context3D 	: Context3D;
		protected var _viewport3D	: Viewport3D;
		protected var _currentProgram : Program3D;
		protected var _currentMaterial : Material;
		
		
		public function Stage3DRenderer( viewport : Viewport3D, antialias : uint = ANTIALIAS_HIGH_QUALITY )
		{
			super();
			
			_antialias = antialias;
			_viewport3D = viewport;
			
			requestStage3D( viewport.stage );
		}
		
		override public function draw( scene:Scene3D, camera:Camera3D ) : Boolean
		{
			// make sure the context is available before render.
			if ( !available ) return false;
				
			var renderables : Vector.<Object3D> = scene.children;
			var numRenderables : uint = renderables.length;
			var renderable : Object3D;
			
			var lights : Vector.<Light> = scene.lights;
			var numLights:uint = lights.length;
			var light:Light;
			
			onBeforeDraw();
			
			camera.update();
					
			for (var i : int = 0; i < numRenderables; i++)
			{
				renderable = renderables[i];
				renderable.update();
				if (renderable is Mesh && renderable.visible)
				{
					/*
						TODO 	Sort Meshes by material and render. Avoid material switching for better performance.
								Find a better way to update and build geometry. Pre-render loop?
					*/
					Mesh( renderable ).geometry.update( _context3D );
					if ( _currentMaterial && _currentMaterial != Mesh( renderable ).material )
					{
						// Clear material
					}
					_currentMaterial = Mesh( renderable ).material;
					if ( _currentMaterial.doubleSided )
						context.setCulling( Context3DTriangleFace.NONE );
					else
						context.setCulling( Context3DTriangleFace.BACK );
						
					_currentMaterial.drawMesh( Mesh(renderable), context, camera, lights );
					
				}
			}
				
			onAfterDraw();
			
			return true;
		}
		
		protected function onBeforeDraw() : void
		{
			/* Update geometries */
			
			context.clear(0,0,0,1);
		}
		
		protected function onAfterDraw() : void
		{
			context.present();
		}
		
		private function requestStage3D( stage : Stage, layer : uint = 0 ) : void
		{
			stage.stage3Ds[ layer ].addEventListener( Event.CONTEXT3D_CREATE, onContext3DCreate );
			stage.stage3Ds[ layer ].requestContext3D( );
		}
		
		private function onContext3DCreate( e:Event ) : void
		{
			_stage3D 	= Stage3D( e.target );
			_context3D 	= _stage3D.context3D;
			context.configureBackBuffer(
									_viewport3D.width, 
									_viewport3D.height, 
									ANTIALIAS_HIGH_QUALITY, 	// Antialiasing. 0 = No Antialias, 2 = Minimal Antialias, 4 = High Quality, 16 = Very High quality
									true // Enable Depth and Stencil Buffer
									);
			context.setCulling( Context3DTriangleFace.BACK );
			
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		protected function get context() : Context3D
		{
			return _context3D;
		}
		
		public function get available( ):Boolean
		{
			return _context3D!=null;
		}
	}
}