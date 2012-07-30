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
	
	public class ObjectContainer3D extends Object3D
	{
		
		private var _children : Vector.<Object3D>;
		
		public function ObjectContainer3D()
		{
			super();
			_children = new Vector.<Object3D>();
		}
		
		public function addChild( object:Object3D ):Object3D
		{
			_children.push(object);
			return object;
		}
		
		public function addChildAt( object:Object3D, index:int = -1):Object3D
		{
			index>-1?_children.splice(index,0,object):_children.push(object);
			return object;
		}
		
		public function removeChild( object:Object3D ):Object3D
		{
			return removeChildAt( _children.indexOf(object) );
		}
		
		public function removeChildAt( index:int ):Object3D
		{
			return _children.splice(index,1)[0] || null;
		}
		
		public function get children() : Vector.<Object3D>
		{
			return _children;
		}
		
	}
}

