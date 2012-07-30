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
	public class AgalShader
	{
		public var vertexAttribute : Array;
		public var vertexConstant : Array;
		public var vertexTemporary : Array;
		public var vertexOutput : Array;
		
		public var varying : Array;
		
		public var fragmentConstant : Array;
		public var fragmentTemporary : Array
		public var textureSampler : Array;
		public var fragmentOutput : Array;
		
		private var _shaderRaw : String;
		
		public function AgalShader()
		{
			super();
			_shaderRaw = "";
		}
		
		private function appendToShader( code : String ) : void
		{
			_shaderRaw += code + "\n";
		}
		
		public function getCode() : String
		{
			return _shaderRaw;
		}
		
		// MOV
		// Dest = Source
		public function move ( dest : String, source : String ) : void
		{
			appendToShader("MOV " + dest + ", " + source);
		}
		
		// ADD
		// Dest = Souce1 + Source2
		public function add ( dest : String, source1 : String, source2:String ) : void
		{
			appendToShader("ADD " + dest + ", " + source1 + ", " + source2);
		}
		
		// SUB
		// Dest = Source1 - Source2
		public function subtract ( dest : String, source1 : String, source2 : String ) : void
		{
			appendToShader("SUB " + dest + ", " + source1 + ", " + source2);
		}
		
		// MUL
		// Dest = Source1 * Source2
		public function multiply ( dest : String, source1 : String, source2 : String ) : void
		{
			appendToShader("MUL " + dest + ", " + source1 + ", " + source2);
		} 
		
		// DIV
		// Dest = Source1 / Source2
		public function divide ( dest : String, source1 : String, source2 : String ) : void
		{
			appendToShader("DIV " + dest + ", " + source1 + ", " + source2);
		}
		
		// RCP
		// Dest = 1 / Source
		public function reciprocal ( dest : String, source : String ) : void
		{
			appendToShader("RCP " + dest + ", " + source);
		}
		// MIN
		// Dest = Math.min( Source1, Source2 )
		public function min ( dest : String, source1 : String, source2 : String ) : void
		{
			appendToShader("MIN " + dest + ", " + source1 + ", " + source2);
		}
		
		// MAX
		// Dest = Math.max( source1, source2 )
		public function max ( dest : String, source1 : String, source2 : String ) : void
		{
			appendToShader("MAX " + dest + ", " + source1 + ", " + source2);
		}
		
		// FRC
		// Dest = source - Math.floor(source)
		// ex. 0.7 = 8.7 - 8.0
		public function fractional ( dest : String, source : String ) : void
		{
			appendToShader("FRC " + dest + ", " + source);
		}
		
		// SQT
		// Dest = sqrt(Source)
		public function sqrt ( dest : String, source : String ) : void
		{
			appendToShader("SQT " + dest + ", " + source);
		}
		
		// RSQ
		// Dest = 1 / sqrt(source)
		public function reciprocalSqrt ( dest : String, source : String ) : void
		{
			appendToShader("RSQ " + dest + ", " + source);
		}
		
		// POW
		// Dest = source1 ^ source2
		public function pow ( dest : String, source1 : String, source2 : String ) : void
		{
			appendToShader("POW " + dest + ", " + source1 + ", " + source2);
		}
		
		// LOG
		// Dest = log_2(source)
		public function log ( dest : String, source : String ) : void
		{
			appendToShader("LOG " + dest + ", " + source);
		}
		
		// EXP
		// Dest = 2 ^ source
		public function exp ( dest : String, source : String ) : void
		{
			appendToShader("EXP " + dest + ", " + source);
		}
		
		
		// NRM
		// Dest = normalize(source)
		public function normalize( dest : String, source : String ) : void
		{
			appendToShader("NRM " + dest + ", " + source);
		}
		
		// SIN
		// Dest = sin(source)
		public function sin ( dest : String, source : String ) : void
		{
			appendToShader("SIN " + dest + ", " + source);
		}
		
		// COS
		// Dest = cos(source)
		public function cos ( dest : String, source : String ) : void
		{
			appendToShader("COS " + dest + ", " + source);
		}
		
		// CRS
		// Dest = crossproduct( source1, source2 )
		public function crossProduct ( dest : String, source1 : String, source2 : String) : void
		{
			appendToShader("CRS " + dest + ", " + source1 + ", " + source2);
		}
		
		// DP3
		// Dot product 3 component (x, y, z)
		// Dest = source1 . source2
		public function dotProduct3 ( dest : String, source1 : String, source2 : String ) : void
		{
			appendToShader("DP3 " + dest + ", " + source1 + ", " + source2);
		}
		
		// DP4
		// Dot produce 4 component (x, y, z, w)
		public function dotProduct4 ( dest : String, source1 : String, source2 : String ) : void
		{
			appendToShader("DP4 " + dest + ", " + source1 + ", " + source2);
		}
		
		// ABS
		// Dest = |source|
		public function abs ( dest : String, source : String ) : void
		{
			appendToShader("ABS " + dest + ", " + source);
		}
		
		// NEG
		// Dest = - source
		public function negate ( dest : String, source : String ) : void
		{
			appendToShader("NEG " + dest + ", " + source);
		}
		
		// SAT
		// Dest = Math.max( Math.min( source, 1 ), 0 )
		// Cap 0 - 1
		public function saturate ( dest : String, source : String ) : void
		{
			appendToShader("SAT " + dest + ", " + source);
		}
		
		// M33
		// Matrix multiply
		// Multiply a 3-component vector with a 3x3 matrix
		public function multiply3x3 ( dest : String, source1:String, source2:String ) : void
		{
			appendToShader("M33 " + dest + ", " + source1 + ", " + source2);
		}
		
		// M44
		// Matrix multiply
		// Multiply a 4-component vector with a 4x4 matrix
		public function multiply4x4 ( dest : String, source1:String, source2:String ) : void
		{
			appendToShader("M44 " + dest + ", " + source1 + ", " + source2);
		}
		
		// M34
		// Matrix multiply
		// Multiply a 4-component vector with a 3x4 matrix
		public function multiply3x4 ( dest : String, source1:String, source2:String ) : void
		{
			appendToShader("M34 " + dest + ", " + source1 + ", " + source2);
		}
		
		// TEX
		// Dest = color sample 
		// Source1 = UV Coords
		// Source2 = Texture Sampler
		public function sampleTexture ( dest : String, source1 : String, source2 : String, flags : Array = null ) : void
		{
			var code : String = "TEX " + dest + ", " + source1 + ", " + source2;
			if (flags)
			{
				code += " <";
				for (var i : int = 0; i < flags.length; i++)
					code += flags[i] + ",";
				code = code.substr(0, code.length - 1) + ">";
			}
			appendToShader(code);
		}
		
		// KIL
		// Kill
		// Fragment shader specific - Kill fragment if source < 0
		public function killFragment ( dest : String, source : String ) : void
		{
			appendToShader("KIL " + dest + ", " + source);
		}
		
		// SGE
		// Dest = source1 > source2 ? 1 : 0
		public function setIfGreaterThan ( dest : String, source1 : String, source2 : String ) : void
		{
			appendToShader("SGE " + dest + ", " + source1 + ", " + source2);
		}
		
		//SLT
		// Dest = source1 < source2 ? 1 : 0
		public function setIfLessThan ( dest : String, source1 : String, source2 : String ) : void
		{
			appendToShader("SLT " + dest + ", " + source1 + ", " + source2);
		}
		
		//SEQ
		// Dest = source1 == source2 ? 1 : 0
		public function setIfEqual ( dest : String, source1 : String, source2 : String ) : void
		{
			appendToShader("SEQ " + dest + ", " + source1 + ", " + source2);
		}
		
		//SNE
		// Dest = source1 != source2 ? 1 : 0
		public function setIfNotEqual ( dest : String, source1 : String, source2 : String ) : void
		{
			appendToShader("SNE " + dest + ", " + source1 + ", " + source2);
		}
		
		public function toString (  ) : void
		{
			trace("-- SHADER RAW ASSEMBLY CODE --");
			trace(_shaderRaw);
		}
	}
}