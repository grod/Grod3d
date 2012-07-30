/**

	Author: Gustav Buchholtz (gustav.buchholtz@gmail.com), http://www.grod.se/
	
	* ----------------------------------------------------------------------------
	* "THE BEER-WARE LICENSE" (Revision 42):
	* Gustav Buchholtz wrote this file. As long as you retain this notice you
	* can do whatever you want with this stuff. If we meet some day, and you think
	* this stuff is worth it, you can buy me a beer in return.
	* ---------------------------------------------------------------------------- 
*/


package se.grod.grod3d.cameras
{	
	import se.grod.grod3d.core.objects.Object3D;
	import se.grod.grod3d.core.math.Matrix3DUtils;
	import se.grod.grod3d.core.math.MathConstants;
	import se.grod.grod3d.core.Viewport3D;
	
	import flash.geom.Matrix3D;
	import com.adobe.utils.PerspectiveMatrix3D;
	
	public class Camera3D extends Object3D
	{
		private var _fieldOfView 		: Number;
		private var _aspectRatio		: Number;
		private var _near 				: Number;
		private var _far 				: Number;
		private var _viewport			: Viewport3D;
		private var _projectionMatrix 	: Matrix3D;
		
		public function Camera3D( fieldOfView : Number = 45, aspectRatio : Number = 1, near : Number = 0.1, far : Number = 2000 ) : void
		{
			super();
			
			_fieldOfView 		= fieldOfView;
			_aspectRatio		= aspectRatio;
			_near 				= near;
			_far 				= far;
			_projectionMatrix 	= new Matrix3D();
		}
		
		public function updateProjectionMatrix( viewport:Viewport3D = null ):void
		{
			// make sure we don't update matrix while unchanged premesis.
			if( _viewport && viewport ) return;
			
			// use previous or new viewport
			_viewport = viewport || _viewport;
			
			// halt if we lack viewport
			if( !_viewport ) return;
			
			var p : PerspectiveMatrix3D = new PerspectiveMatrix3D();
			p.perspectiveFieldOfViewRH( _fieldOfView, _aspectRatio, _near, _far );  
			
			_projectionMatrix.identity();
			_projectionMatrix.append( inverseTransform );
			_projectionMatrix.append( p );
		}
		
		override protected function updateTransform() : void
		{
			super.updateTransform();
			updateProjectionMatrix();
		}
		
		public function get projectionMatrix():Matrix3D
		{
			return _projectionMatrix;
		}
		
		public function get fieldOfView( ):Number { return _fieldOfView }
		public function set fieldOfView( value:Number ):void
		{
			_fieldOfView = value;
			updateProjectionMatrix();
		}
		
		public function get aspectRatio( ):Number { return _aspectRatio }
		public function set aspectRatio( value:Number ):void
		{
			_aspectRatio = value;
			updateProjectionMatrix();
		}
		
		public function get near( ):Number { return _near }
		public function set near( value:Number ):void
		{
			_near = value;
			updateProjectionMatrix();
		}
		
		public function get far( ):Number { return _far }
		public function set far( value:Number ):void
		{
			_far = value;
			updateProjectionMatrix();
		}
	}
}