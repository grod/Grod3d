/**

	Author: Gustav Buchholtz (gustav.buchholtz@gmail.com), http://www.grod.se/
	
	* ----------------------------------------------------------------------------
	* "THE BEER-WARE LICENSE" (Revision 42):
	* Gustav Buchholtz wrote this file. As long as you retain this notice you
	* can do whatever you want with this stuff. If we meet some day, and you think
	* this stuff is worth it, you can buy me a beer in return.
	* ---------------------------------------------------------------------------- 
*/


package
{		
	import com.nesium.logging.TrazzleLogger;

	import se.grod.grod3d.core.objects.Object3D;
	import se.grod.grod3d.core.Viewport3D;
	import se.grod.grod3d.core.render.Stage3DRenderer;
	import se.grod.grod3d.core.Scene3D;
	import se.grod.grod3d.cameras.Camera3D;
	import se.grod.grod3d.parsers.OBJParser;
	import se.grod.grod3d.primitives.Sphere;
	import se.grod.grod3d.materials.Material;
	import se.grod.grod3d.core.render.Renderer;
	import se.grod.grod3d.materials.PhongTextureMaterial;
	import se.grod.grod3d.textures.TextureUtils;
	import se.grod.grod3d.lights.PointLight;
	
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	
	
	[SWF(width='1024', height='768', backgroundColor='#666666', frameRate='60')]
	public class Main extends Sprite
	{	
		[Embed(source='../res/lee_perry_normal.jpg')]
		private var LeeNormal:Class;
		[Embed(source='../res/lee_perry_diffuse.jpg')]
		private var LeeDiffuse:Class;
		
		private var _viewport 	: Viewport3D;
		private var _renderer 	: Renderer;
		private var _scene 		: Scene3D;
		private var _camera		: Camera3D;
		
		private var _objs		: Array;
		
		public function Main( ) : void
		{
			super();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			TrazzleLogger.instance( ).setParams( this.stage, "Grod3D" );
			_viewport 	= new Viewport3D( stage.stageWidth, stage.stageHeight );
			addChild(_viewport);
			_camera 	= new Camera3D( 45, stage.stageWidth / stage.stageHeight, 1, 1000 );
			_camera.z = 0;
			_camera.rotationY = 180;
			_renderer 	= new Stage3DRenderer( _viewport );
			//_renderer = new DeferredRenderer( _viewport );
			_scene 		= new Scene3D( );
			
			var urlLoader:URLLoader = new URLLoader( );
				urlLoader.addEventListener( Event.COMPLETE, onLoadComplete );
				
			urlLoader.load(new URLRequest("res/lee_perry.obj"));
		}
		
		private function onLoadComplete( e : Event ) : void
		{
			_objs = new Array();
			
			log("i Model loaded. Parsing...");
			var obj:OBJParser = new OBJParser( 10, true);
			obj.build(  String(e.target.data) );
			obj.x = 0;
			obj.z = 50;
			obj.y = -10;

			obj.material = new PhongTextureMaterial(
									Bitmap(new LeeDiffuse() ).bitmapData,
									//TextureUtils.getDebugNormalMap(),
									Bitmap(new LeeNormal() ).bitmapData,
									0.03,  		// Ambient amount
									0.1, 		// Diffuse amount
									0.5, 		// Specular amount
									60			// Glossiness
								);
			_scene.addChild(obj);
			_objs.push(obj);
			
			var i:int = 0;
			for (i = 0; i < 5; i++)
			{	
				var mat:Material = new PhongTextureMaterial( 
						TextureUtils.getCheckerBoard(64, 1024, 1024, Math.random()*0xFFFFFF, Math.random()*0xFFFFFF), 
						TextureUtils.getDebugNormalMap(32),
						0.07,
						0.2,
						0.6,
						80
						);
				
				var o : Object3D;
				o = new Sphere(mat, Math.random()*5 + 5);
				o.x = Math.random() * 50 - 25;
				o.y = Math.random() * 50 - 25;
				o.z = 70;
				_scene.addChild(o);
				_objs.push(o);
			}
			
			/* Lights */
			var lght:PointLight = new PointLight(0xDF3E88, -200, -100, -200);
			_scene.addLight(lght);
			var lght2:PointLight = new PointLight(0x48FF1D, 200, 100, -350);
			_scene.addLight(lght2);
			var lght3:PointLight = new PointLight(0x6708FE, 0, 400, -230);
			_scene.addLight(lght3);
			
			_viewport.initialize( _scene, _camera, _renderer );
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame)
		}

		private var _count : Number = 0;
		
		private function onEnterFrame( e : Event ) : void
		{
			for (var i : int = 0; i < _objs.length; i++)
			{
				_objs[i].rotationY = stage.mouseX / stage.stageWidth * 360;
				//_objs[i].rotationX = 20;
				//_objs[i].transform.appendRotation(dX, new Vector3D(0,1,0), new Vector3D(_objs[i].x, _objs[i].y, _objs[i].z));
			}
			_count ++;
			//_camera.rotationY = 180+stage.mouseX / stage.stageWidth * 180;//180 + Math.sin(_count / 50) * 50;
			
			_viewport.render( _scene, _camera, _renderer );
		}
	}
}