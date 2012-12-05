////////////////////////////////////////////////////////////////////////////////
//
//  © 2011 Valentin Simonov
//
////////////////////////////////////////////////////////////////////////////////
package ru.valyard.osc.connection
{
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	import ru.valyard.osc.IOSCMessageFactory;
	import ru.valyard.osc.OSCMessageFactory;
	import ru.valyard.osc.data.OSCBundle;
	import ru.valyard.osc.data.OSCMessage;
	import ru.valyard.osc.data.OSCPacket;
	
	/**
	 * @author					valyard
	 */
	public class AbstractOSCConnection extends EventDispatcher {
		
		public function AbstractOSCConnection(factory:IOSCMessageFactory = null) {
			if ( !factory ) factory = new OSCMessageFactory();
			this._factory = factory;
		}
		
		//--------------------------------------------------------------------------
		//
		// Private variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private const _listeners:Vector.<IOSCConnectionListener> = new Vector.<IOSCConnectionListener>()
		
		/**
		 * @private
		 */
		private var _listenersNum:uint;
			
		//--------------------------------------------------------------------------
		//
		// Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var _factory:IOSCMessageFactory;
		
		/**
		 * @inheritDoc
		 */
		public function get factory():IOSCMessageFactory {
			return this._factory;
		}
		
		//--------------------------------------------------------------------------
		//
		// Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function addListener(listener:IOSCConnectionListener):void {
			if ( this._listeners.indexOf( listener ) > -1 ) return;
			this._listeners.push( listener );
			this._listenersNum += 1;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeListener(listener:IOSCConnectionListener):void {
			var index:int = this._listeners.indexOf( listener );
			if ( index == -1 ) return;
			
			this._listeners.splice( index, 1 );
			this._listenersNum -= 1;
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
		protected function dispatchData(bytes:ByteArray):void {
			while ( bytes.bytesAvailable ) {
				var packet:OSCPacket = this._factory.readOSCPacket( bytes );
				if ( packet is OSCMessage ) {
					this.dispatchMessage( packet as OSCMessage );
				} else if ( packet is OSCBundle ) {
					var l:uint = packet.length;
					for ( var i:uint; i < l; i++ ) {
						this.dispatchMessage( packet[i] as OSCMessage );
					}
				}
				
				if ( packet != null ) {
					this._factory.returnOSCPacket( packet );
				} else {
					bytes.length = 0;
				}
			}
		}
		
		/**
		 * @private
		 */
		private function dispatchMessage(message:OSCMessage):void {
			for ( var i:uint = 0; i < this._listenersNum; i++ ) {
				this._listeners[i].receiveOSCMessage( message );
			} 
		}
		
		//--------------------------------------------------------------------------
		//
		// Event handlers
		//
		//--------------------------------------------------------------------------
		
	}
}