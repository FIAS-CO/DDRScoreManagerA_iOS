//
//  ViewSongMemo.swift
//  dsma
//
//  Created by apple on 2024/04/07.
//  Copyright © 2024 LinaNfinE. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds

class ViewSongMemo: UIViewController, UINavigationBarDelegate, UIBarPositioningDelegate {
    
    @IBOutlet weak var adView: UIView!
    
    @IBOutlet weak var naviTitle: UINavigationItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var buttonDone: UIBarButtonItem!
    var buttonCancel: UIBarButtonItem!
    
    var rparam_AddTarget: UniquePattern!
    
    var mMag: CGFloat = 1 // Padの場合のサイズを変更？
    
    static func checkOut(_ target: UniquePattern?) -> (ViewSongMemo) {
        if target == nil {
            let storyboard = UIStoryboard(name: "ViewSongMemo", bundle: nil)
            let ret = storyboard.instantiateInitialViewController() as! ViewSongMemo
            return ret
        }
        else {
            let storyboard = UIStoryboard(name: "ViewSongMemo", bundle: nil)
            let ret = storyboard.instantiateInitialViewController() as! ViewSongMemo
            ret.rparam_AddTarget = target
            return ret
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkDeviceIsPad()
        
        buttonDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(ViewMyList.doneButtonTouched(_:)))
        buttonCancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(ViewMyList.cancelButtonTouched(_:)))
        
        let bl = [UIBarButtonItem](arrayLiteral: buttonCancel)
        navigationBar.topItem?.leftBarButtonItems = bl
        
        if rparam_AddTarget == nil {
            self.title = "My List"
        }
        else {
            naviTitle.title = NSLocalizedString("Select My List", comment: "ViewMyList")
            let nvFrame: CGRect = navigationBar.frame;
            //            tableView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height, left: 0, bottom: 0, right: 0)
            navigationBar.delegate = self
        }
        adView.addSubview(Admob.getAdBannerView(self))
    }
    
    // UIBarPositioningDelegate
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    fileprivate func checkDeviceIsPad() {
        let device = UIDevice.current.userInterfaceIdiom
        if device == UIUserInterfaceIdiom.pad {
            mMag = 1.5
        }
    }
}
