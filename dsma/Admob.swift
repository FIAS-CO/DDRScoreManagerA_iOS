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
        var bannerView: GADBannerView = GADBannerView()
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: {status in
                bannerView = GADBannerView(adSize:kGADAdSizeBanner)
                bannerView.frame.origin = CGPoint(x: 0, y: 0)
                bannerView.frame.size = CGSize(width: 325, height: 50)
                bannerView.adUnitID = "ca-app-pub-3940256099942544~1458002511" // Enter Ad's ID here
                bannerView.delegate = Instance
                bannerView.rootViewController = viewController
                
                let request:GADRequest = GADRequest()
                //request.testDevices = [kGADSimulatorID, "e6cfec14a364685bacbcf949bb123f5a", "5890ffced044af1d8f8aa98ae704c77f"]
                //request.testDevices = [ kGADSimulatorID as! String, "9740bf7fbe1b3f0f7d7649a2d7a585b6" ];
                GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ kGADSimulatorID as! String, "" ];
                bannerView.load(request)
            })
        } else {
            bannerView = GADBannerView(adSize:kGADAdSizeBanner)
            bannerView.frame.origin = CGPoint(x: 0, y: 0)
            bannerView.frame.size = CGSize(width: 325, height: 50)
            bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111" // Enter Ad's ID here
            bannerView.delegate = Instance
            bannerView.rootViewController = viewController
            
            let request:GADRequest = GADRequest()
            //request.testDevices = [kGADSimulatorID, "e6cfec14a364685bacbcf949bb123f5a", "5890ffced044af1d8f8aa98ae704c77f"]
            //request.testDevices = [ kGADSimulatorID as! String, "9740bf7fbe1b3f0f7d7649a2d7a585b6" ];
            GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ kGADSimulatorID as! String, "" ];
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

    }
    
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        FileReader.saveLastAdTapTime()
    }
}
