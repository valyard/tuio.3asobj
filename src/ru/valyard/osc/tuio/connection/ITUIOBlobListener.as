////////////////////////////////////////////////////////////////////////////////
//
//  © 2011 Valentin Simonov
//
////////////////////////////////////////////////////////////////////////////////
package ru.valyard.osc.tuio.connection
{
	import ru.valyard.osc.tuio.data.TUIOBlob;

	/**
	 * @author					valyard
	 */
	public interface ITUIOBlobListener extends ITUIOConnectionListener {
		
		/**
		 * Callback for adding TUIO blobs
		 * @param object	TUIOBlob instance
		 */
		function addTUIOBlob(blob:TUIOBlob):void;
		
		/**
		 * Callback for updating TUIO blobs
		 * @param object	TUIOBlob instance
		 */
		function updateTUIOBlob(blob:TUIOBlob):void;
		
		/**
		 * Callback for removing TUIO blobs
		 * @param object	TUIOBlob instance
		 */
		function removeTUIOBlob(blob:TUIOBlob):void;
	}
}