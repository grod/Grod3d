/**

	Author: Gustav Buchholtz (gustav.buchholtz@gmail.com), http://www.grod.se/
	
	* ----------------------------------------------------------------------------
	* "THE BEER-WARE LICENSE" (Revision 42):
	* Gustav Buchholtz wrote this file. As long as you retain this notice you
	* can do whatever you want with this stuff. If we meet some day, and you think
	* this stuff is worth it, you can buy me a beer in return.
	* ---------------------------------------------------------------------------- 
*/


package se.grod.grod3d.agal
{	
import se.grod.grod3d.agal.Register;
	/**
	* Helper class to cache agal registers, constants and variables
	* */
	
	
	public class RegisterPool
	{
		// Vertex
		private static const MAX_VERTEX_ATTRIBUTES : uint = 8; 				// va[n]
		private static const MAX_VERTEX_CONSTANT_REGISTERS : uint = 128;	// vc[n]
		private static const MAX_VERTEX_TEMPORARY_REGISTERS : uint = 8;		// vt[n]
		
		// Fragment
		private static const MAX_FRAGMENT_CONSTANT_REGISTERS : uint = 28;	// fc[n]
		private static const MAX_FRAGMENT_TEMPORARY_REGISTERS : uint = 8;	// ft[n]
		private static const MAX_FRAGMENT_SAMPLER : uint = 8;				// fs[n]
		
		// Varying registers for passing data from vertex to fragment
		private static const MAX_VARYING_REGISTERS : uint = 8;				// v[n]
		
		// also output registers for vertex and fragment (op and oc respectively)
		
		private var _usedValues : Array;
		
		public function RegisterPool()
		{
			super();
		}
		
		private function getFromPool( id : String, maxVal : uint, size : uint = 1 ) : Register
		{
			if (!_usedValues)
				_usedValues = [];
			
			for( var i : uint = 0; i < maxVal; i++ )
			{
				if ( _usedValues.indexOf(String(id + i)) == -1 )
				{
					var reg:Register = new Register(id, i);
					_usedValues.push( reg );
					// register more blocks if size is greater than 1.
					// TODO. Find a better way to do this, so freeing up can't result in breaking buffer limit
					if (size > 1)
						for (var j : uint = i; j < i+size; j++)
							_usedValues.push(new Register(id, j));
							
					return reg;
				}
			}
			
			// throw error
			throw new Error("No free registers in pool");
			
			return null;
		}
		
		public function getFreeVertexAttribute() : Register
		{
			return getFromPool( "va", MAX_VERTEX_ATTRIBUTES );
		}
		
		// size - Matrix4 uses 4. Vector4 uses 1
		public function getFreeVertexConstant( size : uint ) : Register
		{
			return getFromPool( "vc", MAX_VERTEX_CONSTANT_REGISTERS, size );
		}
		
		public function getFreeVertexTemp() : Register
		{
			return getFromPool( "vt", MAX_VERTEX_TEMPORARY_REGISTERS );
		}
		
		public function getFreeFragmentConstant() : Register
		{
			return getFromPool( "fc", MAX_FRAGMENT_CONSTANT_REGISTERS );
		}
		
		public function getFreeFragmentTemp() : Register
		{
			return getFromPool( "ft", MAX_FRAGMENT_TEMPORARY_REGISTERS );
		}
		
		public function getFreeFragmentSampler() : Register
		{
			return getFromPool( "fs", MAX_FRAGMENT_SAMPLER);
		}
		
		public function getFreeVar() : Register
		{
			return getFromPool( "v", MAX_VARYING_REGISTERS );
		}
		
		public function release( id : Register ) : void
		{
			//if (_usedValues && _usedValues.indexOf(id) > -1)
			//	_usedValues.splice(id, 1);
		}
		
		public function reset() : void
		{
			_usedValues = [];
		}

	}
}