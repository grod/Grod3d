package se.grod.grod3d.agal
{	
	public class Register
	{
		private var _type : String;
		private var _index : uint;
		
		public function Register( type : String, index : uint )
		{
			_type = type;
			_index = index;
		}
		
		public function getIndex() : uint
		{
			return _index;
		}
		
		public function getType() : String
		{
			return _type;
		}
		
		public function getValue() : String
		{
			return String(_type + _index);
		}
	}
}