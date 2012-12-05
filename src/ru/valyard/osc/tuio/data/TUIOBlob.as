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
	public class TUIOBlob extends AbstractTUIOObject {
		
		public function TUIOBlob(type:String, sessionID:Number, x:Number, y:Number, z:Number, a:Number, b:Number, c:Number, w:Number, h:Number, d:Number, f:Number, v:Number, X:Number, Y:Number, Z:Number, A:Number, B:Number, C:Number, m:Number, r:Number, frameID:uint) {
			super(type, sessionID, x, y, z, X, Y, Z, m, frameID);
			
			this.a = a;
			this.b = b;
			this.c = c;
			this.w = w;
			this.h = h;
			this.d = d;
			this.f = f;
			this.v = v;
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
		 * Blob angle
		 */
		public var a:Number;
		
		/**
		 * Blob angle
		 */
		public var b:Number;
		
		/**
		 * Blob angle
		 */
		public var c:Number;
		
		/**
		 * Blob width
		 */
		public var w:Number;
		
		/**
		 * Blob height
		 */
		public var h:Number;
		
		/**
		 * Blob dimension
		 */
		public var d:Number;
		
		/**
		 * Blob area
		 */
		public var f:Number;
		
		/**
		 * Blob volume
		 */
		public var v:Number;
		
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
		
		public function update(x:Number, y:Number, z:Number, a:Number, b:Number, c:Number, w:Number, h:Number, d:Number, f:Number, v:Number, X:Number, Y:Number, Z:Number, A:Number, B:Number, C:Number, m:Number, r:Number, frameID:uint):void {
			this.x = x;
			this.y = y;
			this.z = z;
			this.a = a;
			this.b = b;
			this.c = c;
			this.w = w;
			this.h = h;
			this.d = d;
			this.f = f;
			this.v = v;
			this.X = X;
			this.Y = Y;
			this.Z = Z;
			this.A = A;
			this.B = B;
			this.C = C;
			this.m = m;
			this.r = r;
			
			this.frameID = frameID;
		}
		
		public function toString():String {
			return "[TuioBlob " + this.type + " " + this.sessionID + " x: " + this.x + ", y: " + this.y + ", z: " + this.z + ", a: " + this.a +
					", b: " + this.b + ", c: " + this.c + ", w: " + this.w + ", h: " + this.h + ", d: " + this.d + ", v: " + this.v + ", X: " + this.X +
					", Y: " + this.Y + ", Z: " + this.Z + ", A: " + this.A + ", B: " + this.B + ", C: " + this.C + ", m: " + this.m + ", r: " + this.r +
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