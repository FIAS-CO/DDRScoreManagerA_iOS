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
    
    private var isMobileAdsStartCalled = false
    private var isViewDidAppearCalled = false
    
    static func getAdBannerView(_ viewController: UIViewController) -> GADBannerView {
        
        GADMobileAds.sharedInstance().start()
        
        let bannerView: GADBannerView = GADBannerView(adSize:GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-8151928728657048/4727276862"
        bannerView.rootViewController = viewController
        bannerView.delegate = Instance
        
        GoogleMobileAdsConsentManager.shared.gatherConsent(from: viewController) {  (consentError) in
           
            
            if let consentError {
                // Consent gathering failed.
                print("Error: \(consentError.localizedDescription)")
            }
            
            if GoogleMobileAdsConsentManager.shared.canRequestAds {
                Instance.startGoogleMobileAdsSDK(bannerView)
            }
            
//            self.privacySettingsButton.isEnabled =
//            GoogleMobileAdsConsentManager.shared.isPrivacyOptionsRequired
        }
        
        // This sample attempts to load ads using consent obtained in the previous session.
        if GoogleMobileAdsConsentManager.shared.canRequestAds {
            Instance.startGoogleMobileAdsSDK(bannerView)
        }
        //        bannerView.translatesAutoresizingMaskIntoConstraints = false
        //
        //        bannerView.frame.origin = CGPoint(x: 0, y: 0)
        //        bannerView.frame.size = CGSize(width: 325, height: 50)
        //
        //
        //        if #available(iOS 14, *) {
        //            ATTrackingManager.requestTrackingAuthorization(completionHandler: {status in
        //                DispatchQueue.main.async {
        //                    print("ATTステータス: \(status.rawValue)") // ATTのステータスログ
        //                    switch status {
        //                    case .authorized:
        //                        print("ユーザーが追跡を許可しました。")
        //                        bannerView.load(GADRequest())
        //                    case .denied:
        //                        print("ユーザーが追跡を拒否しました。")
        //                        bannerView.load(GADRequest())
        //                    case .notDetermined:
        //                        print("ユーザーが追跡許可をまだ選択していません。")
        //                        bannerView.load(GADRequest())
        //                    case .restricted:
        //                        print("ユーザーが追跡を制限しています。")
        //                        bannerView.load(GADRequest())
        //                    @unknown default:
        //                        print("未知のATTステータス")
        //                        break
        //                    }
        //                }
        //            })
        //        } else {
        //            print("iOS 14未満です。ATTフレームワークは利用できません。")
        //
        //            bannerView.load(GADRequest())
        //        }
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
    
    private func startGoogleMobileAdsSDK(_ bannerView: GADBannerView) {
        DispatchQueue.main.async {
            guard !self.isMobileAdsStartCalled else { return }
            
            self.isMobileAdsStartCalled = true
            
            // Initialize the Google Mobile Ads SDK.
            GADMobileAds.sharedInstance().start()
            
//            if self.isViewDidAppearCalled {
                        bannerView.frame.origin = CGPoint(x: 0, y: 0)
                        bannerView.frame.size = CGSize(width: 325, height: 50)
            bannerView.load(GADRequest())
//            }
        }
    }
    
    func loadBannerAd() {
//        let viewWidth = view.frame.inset(by: view.safeAreaInsets).width
        
        // Here the current interface orientation is used. Use
        // GADLandscapeAnchoredAdaptiveBannerAdSizeWithWidth or
        // GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth if you prefer to load an ad of a
        // particular orientation
//        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        
        
    }
    
}
