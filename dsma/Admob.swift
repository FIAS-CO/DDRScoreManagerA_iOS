//
//  Admob.swift
//  dsm
//
//  Created by LinaNfinE on 7/14/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AppTrackingTransparency

class Admob: NSObject, GADBannerViewDelegate {
    
    class var Instance: Admob {
        struct Static {
            static let inst: Admob = Admob()
        }
        return Static.inst
    }
    
    static func getAdBannerView(_ viewController: UIViewController) -> GADBannerView {
        let bannerView: GADBannerView = GADBannerView(adSize:GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-8151928728657048/4727276862"
        
        bannerView.frame.origin = CGPoint(x: 0, y: 0)
        bannerView.frame.size = CGSize(width: 325, height: 50)
        bannerView.delegate = Instance
        
        bannerView.rootViewController = viewController
        let request:GADRequest = GADRequest()
        
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: {status in
                DispatchQueue.main.async {
                    print("ATTステータス: \(status.rawValue)") // ATTのステータスログ
                    switch status {
                    case .authorized:
                        print("ユーザーが追跡を許可しました。")
                        bannerView.load(request)
                    case .denied:
                        print("ユーザーが追跡を拒否しました。")
                        bannerView.load(request)
                    case .notDetermined:
                        print("ユーザーが追跡許可をまだ選択していません。")
                        bannerView.load(request)
                    case .restricted:
                        print("ユーザーが追跡を制限しています。")
                        bannerView.load(request)
                    @unknown default:
                        print("未知のATTステータス")
                        break
                    }
                }
            })
        } else {
            print("iOS 14未満です。ATTフレームワークは利用できません。")

            bannerView.load(request)
        }
        return bannerView
    }
    
    static func shAdView(_ adHeight: NSLayoutConstraint) {
        if FileReader.checkAdTapExpired() {
            adHeight.constant = 50
        }
        else {
            adHeight.constant = 0
        }
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("広告のロードに成功しました。")
    }
    
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        FileReader.saveLastAdTapTime()
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("広告のロードに失敗しました: \(error.localizedDescription)")
    }
}
