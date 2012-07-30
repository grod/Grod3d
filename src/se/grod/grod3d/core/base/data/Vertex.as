/**

	Author: Gustav Buchholtz (gustav.buchholtz@gmail.com), http://www.grod.se/
	
	* ----------------------------------------------------------------------------
	* "THE BEER-WARE LICENSE" (Revision 42):
	* Gustav Buchholtz wrote this file. As long as you retain this notice you
	* can do whatever you want with this stuff. If we meet some day, and you think
	* this stuff is worth it, you can buy me a beer in return.
	* ---------------------------------------------------------------------------- 
*/


package se.grod.grod3d.core.base.data
{	
	import flash.geom.Vector3D;
	
	public class Vertex
	{
		private var _position : Vector3D;
		
		public function Vertex( position:Vector3D = null ) : void
		{
			_position = position || new Vector3D( 0, 0, 0 );
		}
		
		public function get x( ):Number { return _position.x }
		public function set x( value:Number ):void
		{
			_position.x = value;
		}
		
		public function get y( ):Number { return _position.y }
		public function set y( value:Number ):void
		{
			_position.y = value;
		}
		
		public function get z( ):Number { return _position.z }
		public function set z( value:Number ):void
		{
			_position.z = value;
		}
		
		public function get position( ):Vector3D { return _position }
		public function set position( value:Vector3D ):void
		{
			_position = value;
		}
		
	}
}