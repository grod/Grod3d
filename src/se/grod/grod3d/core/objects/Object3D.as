/**

	Author: Gustav Buchholtz (gustav.buchholtz@gmail.com), http://www.grod.se/
	
	* ----------------------------------------------------------------------------
	* "THE BEER-WARE LICENSE" (Revision 42):
	* Gustav Buchholtz wrote this file. As long as you retain this notice you
	* can do whatever you want with this stuff. If we meet some day, and you think
	* this stuff is worth it, you can buy me a beer in return.
	* ---------------------------------------------------------------------------- 
*/


package se.grod.grod3d.core.objects
{	
	import se.grod.grod3d.core.objects.Object3D;
	import se.grod.grod3d.core.base.Geometry;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	
	import flash.utils.getQualifiedClassName;
	import se.grod.grod3d.core.math.MathConstants;
	
	public class Object3D
	{
		private static var NUM_OBJECTS : int = 0;
		
		protected var _name 		: String 	= 'object';
		protected var _renderable 	: Boolean 	= false;
		
		protected var _transform	: Matrix3D;
		protected var _position		: Vector3D;
		protected var _rotation		: Vector3D;
		protected var _scale		: Vector3D;
		
		protected var _transformNeedUpdate : Boolean = true;
		
		private var _visible		: Boolean = true;
		
		public function Object3D( name : String = null )
		{
			super();
			if(name === null)
				_name += String(NUM_OBJECTS);
			else
				_name = name;
			NUM_OBJECTS++;
			
			_transform 	= new Matrix3D();
			_position 	= new Vector3D();
			_rotation 	= new Vector3D();
			_scale 		= new Vector3D(1,1,1);
		}
		
		protected function formatToString( ...args ):String
		{
			var result : String = '[' + getQualifiedClassName(this).substr(getQualifiedClassName(this).lastIndexOf('::')+2);
			for each (var key:String in args)
			{
				if(this[key] is String)
					result += ' ' + key + '="' + this[key] +'"';
				else if(this[key] is Function)
					result += ' ' + key + '=#' + this[key];
				else
					result += ' ' + key + '=' + this[key];
			}
			return result+']';
		}
		
		public function get x( ):Number { return _position.x }
		public function set x( value:Number ):void
		{
			_position.x = value;
			_transformNeedUpdate = true;
		}
		
		public function get y( ):Number { return _position.y }
		public function set y( value:Number ):void
		{
			_position.y = value;
			_transformNeedUpdate = true;
		}
		
		public function get z( ):Number { return _position.z }
		public function set z( value:Number ):void
		{
			_position.z = value;
			_transformNeedUpdate = true;
		}
		
		public function get position( ):Vector3D { return _position }
		public function set position( value:Vector3D ):void
		{
			_position = value;
			_transformNeedUpdate = true;
		}
		
		public function get rotationX() : Number { return _rotation.x  }
		public function set rotationX( value : Number ) : void
		{
			_rotation.x = value;
			_transformNeedUpdate = true;
		}
		
		public function get rotationY() : Number { return _rotation.y  }
		public function set rotationY( value : Number ) : void
		{
			_rotation.y = value;
			_transformNeedUpdate = true;
		}
		
		public function get rotationZ() : Number { return _rotation.z }
		public function set rotationZ( value : Number ) : void
		{
			_rotation.z = value;
			_transformNeedUpdate = true;
		}
		
		public function get rotation() : Vector3D { return _rotation }
		public function set rotation( value : Vector3D ) : void
		{
			_rotation = value;
			_transformNeedUpdate = true;
		}
		
		public function get scaleX() : Number { return _scale.x }
		public function set scaleX( value : Number ) : void
		{
			_scale.x = value;
			_transformNeedUpdate = true;
		}
		
		public function get scaleY() : Number { return _scale.y }
		public function set scaleY( value : Number ) : void
		{
			_scale.y = value;
			_transformNeedUpdate = true;
		}
		
		public function get scaleZ() : Number { return _scale.z }
		public function set scaleZ( value : Number ) : void
		{
			_scale.z = value;
			_transformNeedUpdate = true;
		}
		
		public function get scale() : Vector3D { return _scale }
		public function set scale( value : Vector3D ) : void
		{
			_scale = value;
			_transformNeedUpdate = true;
		}
		
		public function get visible() : Boolean { return _visible }
		public function set visible( value : Boolean ) : void
		{
			_visible = value;
		}
		
		public function get transform() : Matrix3D { return _transform }
		
		public function get reducedTransform() : Matrix3D
		{
			var raw:Vector.<Number> = transform.rawData;
			raw[3] = 0;
			raw[7] = 0;
			raw[11] = 0;
			raw[15] = 1;
			raw[12] = 0;
			raw[13] = 0;
			raw[14] = 0;
			var reducedTransform:Matrix3D = new Matrix3D();
			reducedTransform.copyRawDataFrom(raw);
			return reducedTransform;
		}
		
		public function get inverseTransform () : Matrix3D
		{
			var invTransform : Matrix3D = transform.clone();
			invTransform.invert();
			return invTransform;
		}
		
		public function get name( ):String
		{
			return _name;
		}
		
		public function get renderable( ):Boolean
		{
			return _renderable;
		}
		
		public function toString( ):String
		{
			return formatToString(_name);
		}
		
		public function lookAt( targetPosition : Vector3D ) : void
		{	
			updateTransform();
		}
		
		public function update() : void
		{
			if (_transformNeedUpdate)
				updateTransform();
		}
		
		protected function updateTransform() : void
		{
			_transform.identity();
			
			_transform.appendRotation( _rotation.x, Vector3D.X_AXIS );
			_transform.appendRotation( _rotation.y, Vector3D.Y_AXIS );
			_transform.appendRotation( _rotation.z, Vector3D.Z_AXIS );
			
			_transform.appendScale( _scale.x, _scale.y, _scale.z );
			_transform.appendTranslation( _position.x, _position.y, _position.z );
			
			_transformNeedUpdate = false;
		}
	}
}