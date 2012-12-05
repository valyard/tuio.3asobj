////////////////////////////////////////////////////////////////////////////////
//
//  © 2010 Valentin Simonov
//
////////////////////////////////////////////////////////////////////////////////
package ru.valyard.osc
{
	import flash.utils.ByteArray;
	
	import ru.valyard.osc.data.OSCMessage;
	import ru.valyard.osc.data.OSCPacket;
	
	/**
	 * @author					valyard
	 */
	public interface IOSCMessageFactory
	{
		/**
		 * Reads an OSC packet from bytes
		 * @param bytes		ByteArray containing encoded OSCPacket
		 * @return			an instance of OSCPacket
		 */
		function readOSCPacket(bytes:ByteArray):OSCPacket;
		
		/**
		 * Writes an OSC packet into ByteArray
		 * @param packet	OSCPacket to write
		 * @return			ByteArray with encoded packet
		 */
		function writeOSCPacket(packet:OSCPacket):ByteArray;
		
		/**
		 * Created an empty OSCMessage. This is a better way of creating them through factory.
		 * @return	newly created OSCMessage
		 */
		function getEmptyOSCMessage():OSCMessage;
		
		/**
		 * Returns an OSCPacket to factory's packets pool for later use.
		 * It is recommended to clean and return used packets.
		 */
		function returnOSCPacket(packet:OSCPacket):void;
	}
}