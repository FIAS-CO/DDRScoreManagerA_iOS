//
//  ActionSheet.swift
//  dsm
//
//  Created by LinaNfinE on 7/28/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit

class ActionSheet: NSObject, UIActionSheetDelegate {
    
    var mDevice: UIUserInterfaceIdiom
    var mOS: Int
    var mActionSheet: AnyObject!
    var mActions: [ActionSheetAction]
    var mCancelAction: (()->Void)?
    
    init(title: String?, cancelAction: (()->Void)?) {
        mActions = [ActionSheetAction]()
        mCancelAction = cancelAction
        mDevice = UIDevice.current.userInterfaceIdiom
        if objc_getClass("UIAlertController") == nil {
            mOS = 7
        }
        else {
            mOS = 8
        }
        super.init()
        if #available(iOS 8.0, *) {
            mActionSheet = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        }
        else {
            mActionSheet = UIActionSheet(title: title, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil)
        }
    }
    
    func addAction(_ action: ActionSheetAction) {
        if #available(iOS 8.0, *) {
            let alertController: UIAlertController = mActionSheet as! UIAlertController
            alertController.addAction(UIAlertAction(title: action.Title, style: UIAlertAction.Style.default, handler:  { (alertAction) -> Void in
                action.Method()
            }))
        }
        else {
            mActions.append(action)
            let actionSheet: UIActionSheet = mActionSheet as! UIActionSheet
            actionSheet.addButton(withTitle: action.Title)
        }
    }
    /*
    @available(iOS 8.0, *)
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex >= mActions.count {
            mCancelAction?()
            return
        }
        mActions[buttonIndex].Method()
    }
    */
    func show(_ viewController: UIViewController, barButtonItem: UIBarButtonItem) {
        if #available(iOS 8.0, *) {
            let alertController: UIAlertController = mActionSheet as! UIAlertController
            alertController.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.cancel, handler:  { (alertAction) -> Void in }))
            alertController.popoverPresentationController?.barButtonItem = barButtonItem
            viewController.present(alertController, animated: true, completion: nil)
        }
        else {
            let actionSheet: UIActionSheet = mActionSheet as! UIActionSheet
            actionSheet.addButton(withTitle: "Close")
            actionSheet.cancelButtonIndex = mActions.count
            actionSheet.actionSheetStyle = UIActionSheetStyle.blackTranslucent
            actionSheet.show(from: barButtonItem, animated: true)
        }
    }
    
    func show(_ viewController: UIViewController, sourceView: UIView, sourceRect: CGRect) {
        if #available(iOS 8.0, *) {
            let alertController: UIAlertController = mActionSheet as! UIAlertController
            alertController.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.cancel, handler:  { (alertAction) -> Void in self.mCancelAction?()}))
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceRect
            viewController.present(alertController, animated: true, completion: nil)
        }
        else {
            let actionSheet: UIActionSheet = mActionSheet as! UIActionSheet
            actionSheet.addButton(withTitle: "Close")
            actionSheet.cancelButtonIndex = mActions.count
            actionSheet.actionSheetStyle = UIActionSheetStyle.blackTranslucent
            actionSheet.show(from: sourceRect, in: sourceView, animated: true)
        }
    }

}

class ActionSheetAction {
    var Title: String
    var Method: (()->Void)
    init(title: String, method: @escaping (()->Void)) {
        Title = title
        Method = method
    }
}
