/**

	Author: Gustav Buchholtz (gustav.buchholtz@gmail.com), http://www.grod.se/
	
	* ----------------------------------------------------------------------------
	* "THE BEER-WARE LICENSE" (Revision 42):
	* Gustav Buchholtz wrote this file. As long as you retain this notice you
	* can do whatever you want with this stuff. If we meet some day, and you think
	* this stuff is worth it, you can buy me a beer in return.
	* ---------------------------------------------------------------------------- 
*/


package se.grod.grod3d.textures
{	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	
	public class TextureUtils
	{
		public static function getCheckerBoard(cellSize:uint = 64, width:uint = 1024, height:uint = 1024, primaryColor:uint = 0xFFFFFF, secondaryColor:uint = 0x000000) : BitmapData
		{
			var pattern:BitmapData = new BitmapData(cellSize*2, cellSize*2, false);
			pattern.fillRect(new Rectangle(0,0,cellSize, cellSize), primaryColor);
			pattern.fillRect(new Rectangle(cellSize,0,cellSize, cellSize), secondaryColor);
			pattern.fillRect(new Rectangle(0,cellSize,cellSize, cellSize), secondaryColor);
			pattern.fillRect(new Rectangle(cellSize,cellSize,cellSize, cellSize), primaryColor);
			
			var board:Sprite = new Sprite();
			board.graphics.beginBitmapFill(pattern);
			board.graphics.drawRect(0,0,width,height);
			board.graphics.endFill();
			
			var bmp:BitmapData = new BitmapData(width, height, false, 0x000000);
			bmp.draw(board);
			return bmp;
		}
		
		public static function getSolidColor(color:uint = 0xAACCEE) : BitmapData
		{
			var bmp : BitmapData = new BitmapData(64, 64, false, color);
			return bmp;
		}
		
		public static function getDebugNormalMap(cellSize : uint = 64, width:uint = 1024, height:uint = 1024) : BitmapData
		{
			var sz:Number = cellSize;
			var neutral:uint = 0x8080FF;
			var pattern:BitmapData = new BitmapData(sz, sz, false, neutral);

			for (var py:int = 0; py < sz; py++)
			{
				for (var px:int = 0; px < sz; px++)
				{
					var dy:Number = sz/2 - py;
					var dx:Number = sz/2 - px;
					var dist:Number = Math.sqrt(dx*dx + dy*dy);
					if (dist <= sz/2)
					{
						var r:uint = 255 - (px/sz)*255;
						var g:uint = 255 - (py/sz)*255;
						var b:uint = 255 - dist/sz*255;
						pattern.setPixel(px, py, ( r << 16 ) | ( g << 8 ) | b);
					}
				}
			}
			
			var board:Sprite = new Sprite();
			board.graphics.beginBitmapFill(pattern);
			board.graphics.drawRect(0,0,width,height);
			board.graphics.endFill();
			
			var bmp:BitmapData = new BitmapData(width, height, false, 0x000000);
			bmp.draw(board);
			return bmp;
		}
	}
}