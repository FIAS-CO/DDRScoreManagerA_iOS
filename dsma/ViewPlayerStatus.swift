//
//  ViewPlayerStatus.swift
//  dsm
//
//  Created by LinaNfinE on 9/10/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds

class ViewPlayerStatus: UIViewController, UINavigationBarDelegate, UIBarPositioningDelegate, GADBannerViewDelegate {
    
    static func checkOut(_ processPool: WKProcessPool) -> (ViewPlayerStatus) {
        let storyboard = UIStoryboard(name: "ViewPlayerStatus", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! ViewPlayerStatus
        ret.rparam_ProcessPool = processPool
        return ret
    }
    
    var rparam_ProcessPool: WKProcessPool!

    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    //@IBOutlet weak var viewMgr: MgrView!
    
    @IBOutlet weak var labelPlayerName: UILabel!
    @IBOutlet weak var labelDdrCode: UILabel!
    @IBOutlet weak var labelArea: UILabel!
    //@IBOutlet weak var labelEnjoyLevel: UILabel!
    //@IBOutlet weak var labelEnjoyLevelNext: UILabel!
    @IBOutlet weak var labelPlayCount: UILabel!
    @IBOutlet weak var labelLastPlay: UILabel!
    @IBOutlet weak var labelSpClass: UILabel!
    @IBOutlet weak var labelSpPlayCount: UILabel!
    @IBOutlet weak var labelSpLastPlay: UILabel!
    @IBOutlet weak var labelDpClass: UILabel!
    @IBOutlet weak var labelDpPlayCount: UILabel!
    @IBOutlet weak var labelDpLastPlay: UILabel!
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    func setPlayerStatus() {
        let ps = FileReader.readPlayerStatus()
        //viewMgr.setData(ps)
        labelPlayerName.text = ps.DancerName
        labelDdrCode.text = ps.DdrCode
        labelArea.text = ps.Todofuken
        //labelEnjoyLevel.text = ps.EnjoyLevel.description
        //labelEnjoyLevelNext.text = "(Next: "+ps.EnjoyLevelNextExp.description+")"
        labelPlayCount.text = ps.PlayCount.description
        labelLastPlay.text = ps.LastPlay
        //labelSpClass.text = ps.SingleShougou
        labelSpPlayCount.text = ps.SinglePlayCount.description
        labelSpLastPlay.text = ps.SingleLastPlay
        //labelDpClass.text = ps.DoubleShougou
        labelDpPlayCount.text = ps.DoublePlayCount.description
        labelDpLastPlay.text = ps.DoubleLastPlay
    }
    
    @objc internal func stopButtonTouched(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc internal func refreshButtonTouched(_ sender: UIButton) {
        present(ViewFromGatePlayerStatus.checkOut(self.rparam_ProcessPool), animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setPlayerStatus()
        let bl = [UIBarButtonItem](arrayLiteral: buttonStop)
        navigationBar.topItem?.leftBarButtonItems = bl
        let bb = [UIBarButtonItem](arrayLiteral: buttonRefresh)
        navigationBar.topItem?.rightBarButtonItems = bb
        Admob.shAdView(adHeight)
    }
    
    var buttonStop: UIBarButtonItem!
    var buttonRefresh: UIBarButtonItem!
    
    @objc func applicationWillEnterForeground() {
        Admob.shAdView(adHeight)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let notifc: NotificationCenter = NotificationCenter.default
        notifc.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        
        buttonStop = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(ViewPlayerStatus.stopButtonTouched(_:)))
        buttonRefresh = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(ViewPlayerStatus.refreshButtonTouched(_:)))

        self.title = "Player Status"
        adView.addSubview(Admob.getAdBannerView(self))
        
        let nvFrame: CGRect = navigationBar.frame;
        scrollView.contentInset = UIEdgeInsets(top: nvFrame.origin.y, left: 0, bottom: 0, right: 0)
        navigationBar.delegate = self
        
        scrollView.indicatorStyle = UIScrollView.IndicatorStyle.white
        scrollView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        
        setPlayerStatus()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

