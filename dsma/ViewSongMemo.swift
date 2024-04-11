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
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    
    @IBOutlet weak var naviTitle: UINavigationItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    var rparam_AddTarget: UniquePattern!
    
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
    
    // UIBarPositioningDelegate
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    
}
