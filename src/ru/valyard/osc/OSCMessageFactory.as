////////////////////////////////////////////////////////////////////////////////
//
//  © 2010 Valentin Simonov
//
////////////////////////////////////////////////////////////////////////////////
package ru.valyard.osc
{
	import flash.errors.EOFError;
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	
	import ru.valyard.osc.data.OSCBundle;
	import ru.valyard.osc.data.OSCMessage;
	import ru.valyard.osc.data.OSCPacket;
	import ru.valyard.osc.data.OSCTime;
	
	/**
	 * Factory which handles parsing OSC data.
	 * @author					valyard
	 */
	public class OSCMessageFactory implements IOSCMessageFactory
	{
		public function OSCMessageFactory() {}
		
		//--------------------------------------------------------------------------
		//
		// Private variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private const _bundles:Vector.<OSCBundle> = new Vector.<OSCBundle>();
		
		/**
		 * @private
		 */
		private const _messages:Vector.<OSCMessage> = new Vector.<OSCMessage>()
			
		/**
		 * @private
		 */
		private const _timeAssets:Vector.<OSCTime> = new Vector.<OSCTime>()
		
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
		
		/**
		 * @inheritDoc
		 */
		public function readOSCPacket(bytes:ByteArray):OSCPacket {
			if ( !bytes || !bytes.length ) return null;
			
			// <inline getPacketType>
			var type:uint;
			if ( bytes.bytesAvailable >= 8 ) {
				var header:String = bytes.readUTFBytes( 8 );
				bytes.position -= 8;
				if (header == "#bundle") type = OSCPacket.OSC_BUNDLE;
			}
			if ( !type ) {
				header = bytes.readUTFBytes(1);
				bytes.position -= 1;
				if (header == "/") type = OSCPacket.OSC_MESSAGE;
			}
			// </inline getPacketType>
			
			switch ( type ) {
				case OSCPacket.OSC_BUNDLE:
					if ( this._bundles.length ) {
						bundle = this._bundles.pop();
					} else {
						var bundle:OSCBundle = new OSCBundle();
					}
					try {
						bytes.readUTFBytes( 8 );
						bundle.time = this.readTime( bytes );
						
						while ( bytes.bytesAvailable > 0 ) {
							bytes.readInt();
							bundle.push( this.readOSCPacket( bytes ) );
						}
					} catch ( e:EOFError ) {
						bundle = null;
					}
					return bundle;
					
				case OSCPacket.OSC_MESSAGE:
					if ( this._messages.length ) {
						message = this._messages.pop();
					} else {
						var message:OSCMessage = new OSCMessage();
					}
					try {
						message.address = this.readString(bytes);
					
						var pattern:String = this.readString(bytes);
						var array:Array = message;
						var l:int = pattern.length;
					
						for( var i:uint = 0; i < l; i++ ){
							switch ( pattern.charAt(i) ){
								case "r": 
									array.push(bytes.readUnsignedInt()); 
									break;
								case "i": 
									array.push(bytes.readInt()); 
									break;
								case "f": 
									array.push(bytes.readFloat()); 
									break;
								case "d": 
									array.push(bytes.readDouble()); 
									break;
								case "h": 
									array.push(this.read64BInt(bytes)); 
									break;
								case "S": 
								case "s":
									array.push(this.readString(bytes)); 
									break;
								case "b": 
									array.push(this.readBlob(bytes)); 
									break;
								case "t": 
									array.push(this.readTime(bytes)); 
									break;
								case "c": 
									array.push(bytes.readMultiByte(4, "US-ASCII")); 
									break;
								case "N": 
									array.push(null); 
									break;
								case "T": 
									array.push(true); 
									break;
								case "F": 
									array.push(false); 
									break;
								case "I": 
									array.push(Infinity); 
									break;
								case "[": 
									array = new Array(); 
									break;
								case "]": 
									message.push(array); 
									array = message; 
									break;
								default: 
									break;
							}
						}
					} catch ( e:Error ) {
						message = null;
					}
					
					return message;
			}
			
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function writeOSCPacket(packet:OSCPacket):ByteArray {
			var bytes:ByteArray = new ByteArray();
			
			if ( packet is OSCBundle ) {
				throw new IllegalOperationError( "Not implemented!" );
			} else if ( packet is OSCMessage ) {
				var message:OSCMessage = packet as OSCMessage;
				this.writeString( message.address, bytes );
				var pattern:String = ",";
				var dataBytes:ByteArray = new ByteArray();
				
				var l:uint = message.length;
				for ( var i:uint; i < l; i++ ) {
					var data:Object = message[i];
					if ( data is String ) {
						pattern += "s";
						this.writeString( data as String, dataBytes );
					} else if ( data is int ) {
						pattern += "i";
						dataBytes.writeInt( data as int );
					} else if ( data is uint ) {
						pattern += "r";
						dataBytes.writeUnsignedInt( data as uint );
					} else if ( data is Number ) {
						if ( data == Number.POSITIVE_INFINITY || data == Number.NEGATIVE_INFINITY ) {
							pattern += "I";
						} else {
							pattern += "d";
							dataBytes.writeDouble( data as Number );
						}
					} else if ( data is Boolean ) {
						if ( data ) {
							pattern += "T";
						} else {
							pattern += "F";
						}
					} else if ( data is Array ) {
						throw new IllegalOperationError( "Not implemented!" );
					} else if ( data == null ) {
						pattern += "N";
					}
				}
				this.writeString( pattern, bytes );
				bytes.writeBytes( dataBytes );
				
			} else {
				throw new ArgumentError( "Packet must be of type OSCBundle or OSCMessage!" );
			}
			
			return bytes;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getEmptyOSCMessage():OSCMessage {
			if ( this._messages.length ) {
				message = this._messages.pop();
			} else {
				var message:OSCMessage = new OSCMessage();
			}
			return message;
		}
		
		/**
		 * @inheritDoc
		 */
		public function returnOSCPacket(packet:OSCPacket):void {
			if ( packet is OSCBundle ) {
				var bundle:OSCBundle = packet as OSCBundle;
				while ( bundle.length ) this.returnOSCPacket( bundle.pop() );
				this._bundles.push( bundle );
				this._timeAssets.push( bundle.time );
				bundle.time = null;
			} else if ( packet is OSCMessage ) {
				packet.length = 0;
				this._messages.push( packet );
			}
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
		
		/**
		 * @private
		 */
		private function readString(bytes:ByteArray):String {
			var result:String = "";
			while ( bytes.bytesAvailable > 0 ){
				var substr:String = bytes.readUTFBytes(4);
				result += substr;
				if ( substr.length < 4 ) break;
			}
			return result;
		}
		
		/**
		 * @private
		 */
		private function writeString(value:String, bytes:ByteArray):void {
			bytes.writeUTFBytes( value );
			var zeroBytes:int = 4 - (value.length % 4);
			while ( zeroBytes-- > 0 ) bytes.writeByte( 0 );
		}
		
		/**
		 * @private
		 */
		private function readTime(bytes:ByteArray):OSCTime {
			var seconds:uint = bytes.readUnsignedInt();
			var picoseconds:uint = bytes.readUnsignedInt();
			
			if ( this._timeAssets.length ) {
				tag = this._timeAssets.pop();
				tag.seconds = seconds;
				tag.picoseconds = picoseconds;
			} else {
				var tag:OSCTime = new OSCTime(seconds, picoseconds);
			}
			return tag;
		}
		
		/**
		 * @private
		 */
		private function readBlob(bytes:ByteArray):ByteArray {
			var length:int = bytes.readInt();
			var blob:ByteArray = new ByteArray();
			bytes.readBytes( blob, 0, length );
			
			var bits:int = (length + 1) * 8;
			while ( (bits % 32) != 0 ){
				bytes.position += 1;
				bits += 8;
			}
			
			return blob;
		}
		
		/**
		 * @private
		 */
		private function read64BInt(bytes:ByteArray):ByteArray {
			var bigInt:ByteArray = new ByteArray();
			bytes.readBytes(bigInt, 0, 8);
			return bigInt;
		}
		
		//--------------------------------------------------------------------------
		//
		// Event handlers
		//
		//--------------------------------------------------------------------------
		
	}
}