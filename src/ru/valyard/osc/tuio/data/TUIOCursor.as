////////////////////////////////////////////////////////////////////////////////
//
//  © 2010 Valentin Simonov
//
////////////////////////////////////////////////////////////////////////////////
package ru.valyard.osc.tuio.data
{
	/**
	 * @author					valyard
	 */
	public class TUIOCursor extends AbstractTUIOObject {
		
		public function TUIOCursor(type:String, sessionID:Number, x:Number, y:Number, z:Number, X:Number, Y:Number, Z:Number, m:Number, frameID:uint)	{
			super(type, sessionID, x, y, z, X, Y, Z, m, frameID);
		}
		
		//--------------------------------------------------------------------------
		//
		// Private variables
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		// Public properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		// Public methods
		//
		//--------------------------------------------------------------------------
		
		public function update(x:Number, y:Number, z:Number, X:Number, Y:Number, Z:Number, m:Number, frameID:uint):void {
			super.x = x;
			super.y = y;
			super.z = z;
			super.X = X;
			super.Y = Y;
			super.Z = Z;
			super.m = m;
			super.frameID = frameID;
		}
		
		public function toString():String {
			return "[TuioCursor " + this.type + " " + this.sessionID + " x: " + this.x + ", y: " + this.y + ", z: " + this.z + ", X: " + this.X +
				", Y: " + this.Y + ", Z: " + this.Z + ", m: " + this.m + 
				"]";
		}
		
		//--------------------------------------------------------------------------
		//
		// Overriden methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		// Private functions
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		// Event handlers
		//
		//--------------------------------------------------------------------------
		
	}
}