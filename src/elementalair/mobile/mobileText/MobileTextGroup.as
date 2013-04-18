package elementalair.mobile.mobileText {
	
	import flash.display.Sprite;
	import flash.events.SoftKeyboardEvent;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.text.StageText;
	import flash.geom.Rectangle;
	
	import elementalair.mobile.mobileText.MobileTextObject;
	import elementalair.mobile.events.MobileTextEvent;
	import elementalair.mobile.mobileText.MobileTextGroupDisplayManager;
	
	public class MobileTextGroup extends Sprite {
		
		// Store all StageTextObjects in group in Dicitonary for easy ref to each objecvt.
		private var _stageTextList:Dictionary;
		
		// Display object containing UI for form
		private var _formDisplay:Sprite;
		
		private var _groupDisplayManager:MobileTextGroupDisplayManager;
		
		public function MobileTextGroup() {
			super();
			this._stageTextList = new Dictionary();
			this.addEventListener(Event.ADDED_TO_STAGE, this.init);
		}
		
		/**
		 * Add all StageTextObjects to display. StageTextObjects will finish initializing once
		 * they are added to the display.
		 */
		public function init(evt:Event = null):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, this.init);
			
			// Add StageTextObject to display list.
			for (var stObj:String in this._stageTextList)
				this.addChild(this._stageTextList[stObj]);
			
			this._groupDisplayManager = new MobileTextGroupDisplayManager(this);
		}
		
		/**
		 * Create new StageTextObject, store in list and return to caller.
		 */
		public function getNewStageText(p_name:String):MobileTextObject {
			this._stageTextList[p_name] = new MobileTextObject();
			this._stageTextList[p_name].addEventListener(MobileTextEvent.KEYBOARD_ACTIVATE, 	 this.softKeyboardEventHandler);
			this._stageTextList[p_name].addEventListener(MobileTextEvent.KEYBOARD_ACTIVATING, this.softKeyboardEventHandler);
			this._stageTextList[p_name].addEventListener(MobileTextEvent.KEYBOARD_DEACTIVATE, this.softKeyboardEventHandler);
			this._stageTextList[p_name]['name'] = p_name;
			
			return this._stageTextList[p_name];
		}
		
		/** StageText object event handlers **/
		
		/**
		 * Listen for when SoftKeyboard is activated to target StageText object above SoftkeyBoard.
		 * @param
		 */
		private function softKeyboardEventHandler(evt:MobileTextEvent):void {
			switch (evt.type) {
				case MobileTextEvent.KEYBOARD_ACTIVATE:
					this.positionGroupToSoftKeyboard(evt.target as MobileTextObject);
					break;
				case MobileTextEvent.KEYBOARD_DEACTIVATE:
					this.resetGroupPosition(evt.target as MobileTextObject);
			}

		}
		
		/**
		 * Position form group so current StageText object is above SoftKeyboard.
		 */
		private function positionGroupToSoftKeyboard(p_stageTextObject:MobileTextObject):void {
			this._groupDisplayManager.positionGroupToSoftKeyboard(p_stageTextObject);
		}
		
		/**
		 * Reset group position back to orginal layout;
		 */
		private function resetGroupPosition(p_stageTextObject:MobileTextObject):void {
			this._groupDisplayManager.resetGroupPosition();
		}
		
		/**
		 * Display all StageText objects on local display liost as Bitmap copies.
		 */
		public function displayLocal():void {
			for (var stObj:String in this._stageTextList)
				this._stageTextList[stObj].displayLocal();
		}
		
		/**
		 * Render all StageText objects back as Native text fields on device os.
		 */
		public function displayNative():void {
			for (var stObj:String in this._stageTextList)
				this._stageTextList[stObj].displayNative();
		}
		
		/**
		 * Form display object container.
		 */
		public function get formDisplay():Sprite {
			return this._formDisplay;
		}
		
		public function set formDisplay(p_formDisplay:Sprite):void {
			this._formDisplay = p_formDisplay;
		}
		
		/**
		 * Clear all StageTextObjects
		 */
		public function clearGroup():void {
			for (var stObj:String in this._stageTextList) {
				this._stageTextList[stObj].remove();
				this._stageTextList[stObj] = null;
			}
		}
		
	}
}