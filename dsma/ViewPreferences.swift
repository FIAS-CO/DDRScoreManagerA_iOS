//
//  ViewPreferences.swift
//  dsm
//
//  Created by LinaNfinE on 6/25/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds

class ViewPreferences: UIViewController, UINavigationBarDelegate, UIBarPositioningDelegate, GADBannerViewDelegate {
    
    static func checkOut(_ parentView: ViewScoreList?, processPool: WKProcessPool) -> (ViewPreferences) {
        let storyboard = UIStoryboard(name: "ViewPreferences", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! ViewPreferences
        ret.rparam_ParentView = parentView
        ret.rparam_ProcessPool = processPool
        return ret
    }
    
    var rparam_ParentView: ViewScoreList!
    var rparam_ProcessPool: WKProcessPool!
    
    var mPreferences: Preferences       /////// When using "!", mPreferences set nil. Why????
    var mRefreshFlag: Bool = false
    
    var mMessageAlertView: MessageAlertView!
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var versionSelectControl: UISegmentedControl!
    @IBOutlet weak var gateLoadFromNewSite: UISwitch!
    @IBOutlet weak var gateOverWriteLowerScores: UISwitch!
    @IBOutlet weak var gateOverWriteLife4: UISwitch!
    
    @IBOutlet weak var visibleItemsMaxCombo: UISwitch!
    @IBOutlet weak var visibleItemsScore: UISwitch!
    @IBOutlet weak var visibleItemsDanceLevel: UISwitch!
    @IBOutlet weak var visibleItemsPlayCount: UISwitch!
    @IBOutlet weak var visibleItemsClearCount: UISwitch!
    @IBOutlet weak var visibleItemsFlareRank: UISwitch!
    @IBOutlet weak var visibleItemsFlaerSkill: UISwitch!
    
    @IBAction func musicListUpdateTouchUpInside(_ sender: AnyObject) {
        mRefreshFlag = true
        present(ViewMusicListUpdate.checkOut(nil), animated: true, completion: nil)
    }
    @IBAction func manualLoginTouchUpInside(_ sender: AnyObject) {
        self.mMessageAlertView = MessageAlertView(title: NSLocalizedString("Manual Gate Login", comment: "ViewPreferences"), message: NSLocalizedString("Manual login to GATE server. This operation is not automaticaly close. When you detect logged in, close the login window manualy.", comment: "ViewPreferences"), okAction: MessageAlertViewAction(method: {()->Void in
            self.present(ViewGateLogin.checkOut(nil, errorCheck: false, processPool: self.rparam_ProcessPool), animated: true, completion: nil)
        }), cancelAction: MessageAlertViewAction(method: {()->Void in }))
        self.mMessageAlertView.show(self)
    }
    @IBAction func visibleItemsMaxComboValueChanged(_ sender: AnyObject) {
        mRefreshFlag = true
        mPreferences.VisibleItems_MaxCombo = visibleItemsMaxCombo.isOn
    }
    @IBAction func visibleItemsScoreValueChanged(_ sender: AnyObject) {
        mRefreshFlag = true
        mPreferences.VisibleItems_Score = visibleItemsScore.isOn
    }
    @IBAction func visibleItemsDanceLevelValueChanged(_ sender: AnyObject) {
        mRefreshFlag = true
        mPreferences.VisibleItems_DanceLevel = visibleItemsDanceLevel.isOn
    }
    @IBAction func visibleItemsPlayCountValueChanged(_ sender: AnyObject) {
        mRefreshFlag = true
        mPreferences.VisibleItems_PlayCount = visibleItemsPlayCount.isOn
    }
    @IBAction func visibleItemsClearCountValueChanged(_ sender: AnyObject) {
        mRefreshFlag = true
        mPreferences.VisibleItems_ClearCount = visibleItemsClearCount.isOn
    }
    @IBAction func visibleItemsFlareRankValueChanged(_ sender: AnyObject) {
        mRefreshFlag = true
        mPreferences.VisibleItems_FlareRank = visibleItemsFlareRank.isOn
    }
    @IBAction func visibleItemsFlareSkillValueChanged(_ sender: AnyObject) {
        mRefreshFlag = true
        mPreferences.VisibleItems_FlareSkill = visibleItemsFlaerSkill.isOn
    }
    
    var mTextAlertView: TextAlertView!
    @IBAction func gateSaveAsPfcEdit(_ sender: AnyObject) {
        mTextAlertView = TextAlertView(title: NSLocalizedString("Save as PFC threshold", comment: "ViewPreferences"), message: NSLocalizedString("Input threshold score and press OK.", comment: "ViewPreferences"), placeholder: "999990", defaultText: mPreferences.Gate_SetPfcScore.description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
            if let no = Int(text) {
                self.mPreferences.Gate_SetPfcScore = Int32(no)
                self.setPreferenceData()
            }
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }
    @IBAction func gateLoadFromA3ValueChanged(_ sender: AnyObject) {
        mPreferences.Gate_LoadFromNewSite = gateLoadFromNewSite.isOn
    }
    @IBAction func gateOverWriteLowerScoresValueChanged(_ sender: AnyObject) {
        mPreferences.Gate_OverWriteLowerScores = gateOverWriteLowerScores.isOn
    }
    @IBAction func gateOverWriteLive4ValueChanged(_ sender: AnyObject) {
        mPreferences.Gate_OverWriteLife4 = gateOverWriteLife4.isOn
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if let selectedTitle = sender.titleForSegment(at: sender.selectedSegmentIndex),
           let selectedItem = GameVersion(rawValue: selectedTitle) {
            print("\(selectedItem.rawValue) selected")
            // ここで選択されたitemに応じた処理を行う
            mPreferences.Gate_LoadFrom = selectedItem
        } else {
            print("Unknown segment selected")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        mPreferences = Preferences()
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        mPreferences = Preferences()
        super.init(nibName: nil, bundle: nil)
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    func setPreferenceData() {
        //        gateLoadFromNewSite.isOn = mPreferences.Gate_LoadFromNewSite
        selectSegment(mPreferences.Gate_LoadFrom)
        gateOverWriteLowerScores.isOn = mPreferences.Gate_OverWriteLowerScores
        gateOverWriteLife4.isOn = mPreferences.Gate_OverWriteLife4
        visibleItemsMaxCombo.isOn = mPreferences.VisibleItems_MaxCombo
        visibleItemsScore.isOn = mPreferences.VisibleItems_Score
        visibleItemsDanceLevel.isOn = mPreferences.VisibleItems_DanceLevel
        visibleItemsPlayCount.isOn = mPreferences.VisibleItems_PlayCount
        visibleItemsClearCount.isOn = mPreferences.VisibleItems_ClearCount
        visibleItemsFlareRank.isOn = mPreferences.VisibleItems_FlareRank
        visibleItemsFlaerSkill.isOn = mPreferences.VisibleItems_FlareSkill
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mPreferences = FileReader.readPreferences()
        setPreferenceData()
        buttonDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(ViewPreferences.doneButtonTouched(_:)))
        let bb = [UIBarButtonItem](arrayLiteral: buttonDone)
        navigationBar.topItem?.rightBarButtonItems = bb
        Admob.shAdView(adHeight)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FileReader.savePreferences(mPreferences)
    }
    
    @objc internal func doneButtonTouched(_ sender: UIButton) {
        if mRefreshFlag {
            rparam_ParentView?.refreshAll()
        }
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    var buttonDone: UIBarButtonItem!
    
    @objc func applicationWillEnterForeground() {
        Admob.shAdView(adHeight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let notifc: NotificationCenter = NotificationCenter.default
        notifc.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        
        self.title = "Preferences"
        adView.addSubview(Admob.getAdBannerView(self))
        
        navigationBar.delegate = self
        
        scrollView.indicatorStyle = UIScrollView.IndicatorStyle.white
        scrollView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        
        setupSegmentedControl()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSegmentedControl() {
        versionSelectControl.removeAllSegments()
        
        for (index, item) in GameVersion.allCases.enumerated() {
            versionSelectControl.insertSegment(withTitle: item.rawValue, at: index, animated: false)
        }
        
        versionSelectControl.selectedSegmentIndex = 0
        //        selectedItem = .world  // デフォルト値を設定
        
        versionSelectControl.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        versionSelectControl.selectedSegmentTintColor = UIColor(red: 0.0, green: 0.4, blue: 0.8, alpha: 1.0)
        versionSelectControl.setTitleTextAttributes([.foregroundColor: UIColor(white: 0.8, alpha: 1.0)], for: .normal)
        versionSelectControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    
    func selectSegment(_ item: GameVersion) {
        if let index = GameVersion.allCases.firstIndex(of: item) {
            versionSelectControl.selectedSegmentIndex = index
            print("\(item.rawValue) selected programmatically")
            // ここで選択されたitemに応じた処理を行う
        } else {
            print("Failed to select \(item.rawValue)")
        }
    }
}

