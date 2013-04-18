package elementalair.mobile.mobileText {
	
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	import elementalair.mobile.mobileText.MobileTextGroup;
	
	import caurina.transitions.Tweener;
	
	internal final class MobileTextGroupDisplayManager extends EventDispatcher {
		
		private var _stageTextGroup:MobileTextGroup;
		
		public function MobileTextGroupDisplayManager(p_stageTextGroup:MobileTextGroup) {
			this._stageTextGroup = p_stageTextGroup;
		}
		
		internal function positionGroupToSoftKeyboard(p_stageTextObject:MobileTextObject):void {
			var keyboardRect:Rectangle = p_stageTextObject['stageText'].stage.softKeyboardRect;
			
			trace(this + ' positionGroupToSoftKeyboard() : ' + p_stageTextObject['name']);
			trace(p_stageTextObject['name'] + ' keyboardRect: ' + keyboardRect);
		}
		
		internal function resetGroupPosition():void {
			// Tween group back to orginal position
		}
		
	}
}