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
	public class UV
	{
		private var _s : Number;
		private var _t : Number;
		
		public function UV(s:Number, t:Number) : void
		{
			_s = s;
			_t = t;
		}
		
		public function get s () : Number
		{
			return _s;
		}
		
		public function get t () : Number
		{
			return _t;
		}
 	}
}