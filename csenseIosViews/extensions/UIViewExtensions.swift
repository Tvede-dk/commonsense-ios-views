//
// Created by Kasper T on 06/11/2017.
// Copyright (c) 2017 commonsense. All rights reserved.
//
import csenseSwift
import csenseIosBase
import Foundation
public extension UIView {
    
    public func animateAlpha(alphaValue : CGFloat){
        if(alphaValue > 1 || alphaValue < 0 ){
            logWarning(message: "Skipping animation, alpha value is out of range (should be [0;1] but is \(alphaValue)")
            return
        }
        animateView{ [weak self ] in
            self?.alpha = alphaValue
            self?.setNeedsDisplay()
        }
    }
    
    public func animateView(duration: CGFloat = UINavigationControllerHideShowBarDuration,
                            action: @escaping EmptyFunction) {
            UIView.animate(withDuration: TimeInterval(duration), animations: action)
    }
    
    
}
