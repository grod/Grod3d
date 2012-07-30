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
	public class Face
	{
		private var _indices : Array;
		
		public function Face( indices : Array ) : void
		{
			_indices = indices.slice();
		}
		
		public function get indices() : Array
		{
			return _indices;
		}
	}
}