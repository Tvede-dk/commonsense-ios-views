//
// Created by Kasper T on 06/11/2017.
// Copyright (c) 2017 commonsense. All rights reserved.
//

import csenseSwift
import csenseIosBase
import Foundation

public extension UIView {

    public func animateAlpha(alphaValue: CGFloat) {
        if alphaValue > 1 || alphaValue < 0 {
            logWarning(message: "Skipping animation, alpha value is out of range (should be [0;1] but is \(alphaValue)")
            return
        }
        animate { [weak self] in
            self?.alpha = alphaValue
            self?.setNeedsDisplay()
        }
    }

    public func animate(duration: CGFloat = UINavigationControllerHideShowBarDuration,
                        action: @escaping EmptyFunction) {
        UIView.animate(withDuration: TimeInterval(duration), animations: action)
    }

    @IBInspectable
    public var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set(value) {
            self.layer.cornerRadius = value
        }
    }

    /**
     * makes the corner radius equal to half the height => a circle / round.
     * only works if the view is square.
     */
    public func makeRound() {
        logRoundingWarningIfNotSquare()
        isRound = true
    }

    /**
     * makes the corner radius equal to half the height => a circle / round.
     * only works if the view is square.
     */
    @IBInspectable
    public var isRound: Bool {
        get {
            return (cornerRadius.isEqual(to: frame.height / 2.0, withStrife: 1))
        }
        set(value) {
            logRoundingWarningIfNotSquare()
            cornerRadius = value.map(ifTrue: (frame.height / 2.0), ifFalse: 0)
        }
    }

    public func hide() {
        isHidden = true
    }

    public func visible() {
        isHidden = false
    }

    public func toggleVisibility() {
        isHidden = !isHidden
    }

    public var isViewSquare: Bool {
        return frame.width.isEqual(to: frame.height, withStrife: 1)
    }
}

//dealing with inline logging that would otherwise be very ugly in the working code.
private extension UIView {
    func logRoundingWarningIfNotSquare() {
        if !isViewSquare {
            logWarning(message: "potentially bad rounding of view, as the view is not square. (artifacts may occure)")
        }
    }
}
