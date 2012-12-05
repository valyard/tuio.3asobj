////////////////////////////////////////////////////////////////////////////////
//
//  © 2011 Valentin Simonov
//
////////////////////////////////////////////////////////////////////////////////
package ru.valyard.osc.tuio.data
{
	/**
	 * @author					valyard
	 */
	public class TUIOObject extends AbstractTUIOObject {
		
		public function TUIOObject(type:String, sessionID:Number, i:Number, x:Number, y:Number, z:Number, a:Number, b:Number, c:Number, 
			X:Number, Y:Number, Z:Number, A:Number, B:Number, C:Number, m:Number, r:Number, frameID:uint) 
		{
			super(type, sessionID, x, y, z, X, Y, Z, m, frameID);
			
			this.id = i;
			this.a = a;
			this.b = b;
			this.c = c;
			this.A = A;
			this.B = B;
			this.C = C;
			this.r = r;
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
		
		/**
		 * Marker id
		 */
		public var id:uint;
		
		/**
		 * Object angle
		 */
		public var a:Number;
		
		/**
		 * Object angle
		 */
		public var b:Number;
		
		/**
		 * Object angle
		 */
		public var c:Number;
		
		/**
		 * Blob rotational velocity
		 */
		public var A:Number;
		
		/**
		 * Blob rotational velocity
		 */
		public var B:Number;
		
		/**
		 * Blob rotational velocity
		 */
		public var C:Number;
		
		/**
		 * Blob rotational acceleration
		 */
		public var r:Number;
		
		//--------------------------------------------------------------------------
		//
		// Public methods
		//
		//--------------------------------------------------------------------------
		
		public function update(x:Number, y:Number, z:Number, a:Number, b:Number, c:Number, X:Number, Y:Number, Z:Number, A:Number, B:Number, C:Number, m:Number, r:Number, frameID:uint):void {
			this.x = x;
			this.y = y;
			this.z = z;
			this.X = X;
			this.Y = Y;
			this.Z = Z;
			this.m = m;
			
			this.a = a;
			this.b = b;
			this.c = c;
			this.A = A;
			this.B = B;
			this.C = C;
			this.r = r;
			
			this.frameID = frameID;
		}
		
		public function toString():String {
			return "[TuioBlob " + this.type + " " + this.sessionID + " x: " + this.x + ", y: " + this.y + ", z: " + this.z + ", a: " + this.a +
				", b: " + this.b + ", c: " + this.c + ", X: " + this.X + ", Y: " + this.Y + ", Z: " + this.Z + ", A: " + this.A + ", B: " + this.B + 
				", C: " + this.C + ", m: " + this.m + ", r: " + this.r +
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