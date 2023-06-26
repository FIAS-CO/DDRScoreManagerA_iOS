//
//  MessageAlertView.swift
//  dsm
//
//  Created by LinaNfinE on 7/28/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit

class MessageAlertView: NSObject, UIAlertViewDelegate {
    
    var mDevice: UIUserInterfaceIdiom
    var mOS: Int
    var mAlertView: AnyObject!
    var mOkAction: MessageAlertViewAction?
    var mCancelAction: MessageAlertViewAction?
    
    init(title: String, message: String) {
        mDevice = UIDevice.current.userInterfaceIdiom
        if objc_getClass("UIAlertController") == nil {
            mOS = 7
        }
        else {
            mOS = 8
        }
        super.init()
        if #available(iOS 8.0, *) {
            mAlertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let alertController: UIAlertController = mAlertView as! UIAlertController
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:  { (alertAction) -> Void in }))
        }
        else {
            mAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
            let alertView: UIAlertView = mAlertView as! UIAlertView
            alertView.alertViewStyle = UIAlertViewStyle.default
        }
    }
    init(title: String, message: String, okAction: MessageAlertViewAction?, cancelAction: MessageAlertViewAction?) {
        mDevice = UIDevice.current.userInterfaceIdiom
        if objc_getClass("UIAlertController") == nil {
            mOS = 7
        }
        else {
            mOS = 8
        }
        super.init()
        if #available(iOS 8.0, *) {
            mAlertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let alertController: UIAlertController = mAlertView as! UIAlertController
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:  { (alertAction) -> Void in okAction?.Method()}))
            if cancelAction != nil {
                alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler:  { (alertAction) -> Void in cancelAction?.Method()}))
            }
        }
        else {
            mAlertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: nil, otherButtonTitles: "OK")
            let alertView: UIAlertView = mAlertView as! UIAlertView
            if cancelAction != nil {
                alertView.addButton(withTitle: "Cancel")
                alertView.cancelButtonIndex = 1
            }
            alertView.alertViewStyle = UIAlertViewStyle.default
            mOkAction = okAction
            mCancelAction = cancelAction
        }
    }
    /*
    @available(iOS 8.0, *)
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 0 {
            mOkAction?.Method()
        }
        else {
            mCancelAction?.Method()
        }
    }
    */
    func show(_ viewController: UIViewController) {
        if #available(iOS 8.0, *) {
            let alertController: UIAlertController = mAlertView as! UIAlertController
            viewController.present(alertController, animated: true, completion: nil)
        }
        else {
            let alertView: UIAlertView = mAlertView as! UIAlertView
            alertView.show()
        }
    }
    
}

class MessageAlertViewAction {
    var Method: (()->Void)
    init(method: @escaping (()->Void)) {
        Method = method
    }
}
