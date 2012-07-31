/**

	Author: Gustav Buchholtz (gustav.buchholtz@gmail.com), http://www.grod.se/
	
	* ----------------------------------------------------------------------------
	* "THE BEER-WARE LICENSE" (Revision 42):
	* Gustav Buchholtz wrote this file. As long as you retain this notice you
	* can do whatever you want with this stuff. If we meet some day, and you think
	* this stuff is worth it, you can buy me a beer in return.
	* ---------------------------------------------------------------------------- 
*/


package se.grod.grod3d.core
{	
	import flash.display.Sprite;
	import se.grod.grod3d.cameras.Camera3D;
	import se.grod.grod3d.core.Scene3D;
	import se.grod.grod3d.core.render.Renderer;
	
	public class Viewport3D extends Sprite
	{
		private var _width 		: Number;
		private var _height 	: Number;
		private var _camera		: Camera3D;
		private var _scene		: Scene3D;
		private var _renderer	: Renderer;
		
		public function Viewport3D( width : Number = 800, height : Number = 600 ) : void
		{
			super();
			_width	= width;
			_height = height;
		}
		
		public function initialize( scene : Scene3D = null, camera : Camera3D = null, renderer : Renderer = null ) : void
		{
			if( scene )
			{
				_scene = scene;
			}
			
			if( camera )
			{
				_camera = camera;
				_camera.updateProjectionMatrix( this );
			}
			
			if( renderer )
			{
				_renderer = renderer;
			}
		}
		
		public function render( scene : Scene3D = null, camera : Camera3D = null, renderer : Renderer = null ) : Boolean
		{
			// apply any changed items...
			initialize( scene, camera, renderer );
			
			// render
			_renderer.draw( scene, camera );
			
			return true;
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
	}
}