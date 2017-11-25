//
// Created by Kasper T on 09/11/2017.
// Copyright (c) 2017 commonsense. All rights reserved.
//

import Foundation
import csenseSwift
import csenseIosBase


public extension UIViewController {

    public func dismissAnimated() {
        dismiss(animated: true, completion: nil)
    }

    public func present(_ viewController: UIViewController?) {
        guard let viewController = viewController else {
            logFatal(message: "ViewController to present was nil.")
            return
        }
        present(viewController, animated: true, completion: nil)
    }

    public func showQuestionAlert(title: String,
                                  message: String,
                                  yesTitle: String,
                                  noTitle: String,
                                  onYes: @escaping EmptyFunction,
                                  onNo: @escaping EmptyFunction) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: yesTitle, style: .default) { _ in
            onYes()
        })
        controller.addAction(UIAlertAction(title: noTitle, style: .default) { _ in
            onNo()
        })
        present(controller)
    }

    public func animateView(duration: CGFloat = UINavigationControllerHideShowBarDuration,
                            action: @escaping EmptyFunction) {
        if isVisible {
            UIView.animate(withDuration: TimeInterval(duration), animations: action)
        }
    }

    /**
     * An estimate, cannot tell special cases.
     */
    public var isVisible: Bool {
        return self.isViewLoaded && (self.view.window != nil)
    }

}
