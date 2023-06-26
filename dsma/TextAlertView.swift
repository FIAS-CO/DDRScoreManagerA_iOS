//
//  TextAlertView.swift
//  dsm
//
//  Created by LinaNfinE on 7/28/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit

class TextAlertView: NSObject, UIAlertViewDelegate {
    
    var mDevice: UIUserInterfaceIdiom
    var mOS: Int
    var mAlertView: AnyObject!
    var mOkAction: TextAlertViewAction!
    var mCancelAction: TextAlertViewAction!
    
    init(title: String, message: String, placeholder: String?, defaultText: String, kbd: UIKeyboardType, okAction: TextAlertViewAction?, cancelAction: TextAlertViewAction?) {
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
            alertController.addTextField(configurationHandler: {(textField: UITextField)->Void in
                textField.placeholder = placeholder
                textField.text = defaultText
                textField.keyboardType = kbd
            })
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler:  { (alertAction) -> Void in
                cancelAction?.Method(alertController.textFields![0].text!)
            }))
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:  { (alertAction) -> Void in
                okAction?.Method(alertController.textFields![0].text!)
            }))
        }
        else {
            mAlertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
            let alertView: UIAlertView = mAlertView as! UIAlertView
            alertView.cancelButtonIndex = 0
            alertView.alertViewStyle = UIAlertViewStyle.plainTextInput
            alertView.textField(at: 0)?.keyboardType = kbd
            alertView.textField(at: 0)?.placeholder = placeholder
            alertView.textField(at: 0)?.text = defaultText
            mCancelAction = cancelAction
            mOkAction = okAction
        }
    }
    /*
    @available(iOS 8.0, *)
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            mCancelAction?.Method(alertView.textField(at: 0)!.text!)
        default:
            mOkAction?.Method(alertView.textField(at: 0)!.text!)
        }
    }
    */
    func show(_ viewController: UIViewController) {
        if #available(iOS 8.0, *) {
            let alertController: UIAlertController = mAlertView as! UIAlertController
            viewController.present(alertController, animated: true, completion: nil)
        }
        else {
            let alertView = mAlertView as! UIAlertView
            alertView.show()
        }
    }
    
}

class TextAlertViewAction {
    var Method: ((String)->Void)
    init(method: @escaping ((String)->Void)) {
        Method = method
    }
}
