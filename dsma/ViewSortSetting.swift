//
//  ViewSortSetting.swift
//  dsm
//
//  Created by LinaNfinE on 6/17/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewSortSetting: UIViewController, GADBannerViewDelegate {
    
    static func checkOut(_ parentView: ViewSortList?, sortId: Int32) -> (ViewSortSetting) {
        let storyboard = UIStoryboard(name: "ViewSortSetting", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! ViewSortSetting
        ret.rparam_ParentView = parentView
        ret.rparam_SortId = sortId
        return ret
    }
    
    var rparam_ParentView: ViewSortList!
    var rparam_SortId: Int32!
    
    //var typeShowing: Bool = false
    //var sparam_ParentView: SortSettingView!
    var sparam_SortId: Int32!
    var sparam_TypeNo: Int32!
    
    var mSortName: String!
    var mSort: MusicSort!
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var type1st: UIButton!
    @IBOutlet weak var type2nd: UIButton!
    @IBOutlet weak var type3rd: UIButton!
    @IBOutlet weak var type4th: UIButton!
    @IBOutlet weak var type5th: UIButton!
    @IBOutlet weak var order1st: UISegmentedControl!
    @IBOutlet weak var order2nd: UISegmentedControl!
    @IBOutlet weak var order3rd: UISegmentedControl!
    @IBOutlet weak var order4th: UISegmentedControl!
    @IBOutlet weak var order5th: UISegmentedControl!
    
    func changeSortData(_ id: Int32, type: Int32) {
        switch id {
        case 1: mSort._1stType = MusicSortTypeLister.getSortType(type)
        case 2: mSort._2ndType = MusicSortTypeLister.getSortType(type)
        case 3: mSort._3rdType = MusicSortTypeLister.getSortType(type)
        case 4: mSort._4thType = MusicSortTypeLister.getSortType(type)
        case 5: mSort._5thType = MusicSortTypeLister.getSortType(type)
        default: break
        }
        setSortData()
    }
    
    func setSortData() {
        type1st.setTitle(MusicSortTypeLister.getString(Int(MusicSortTypeLister.getSortTypeNum(mSort._1stType))), for: UIControl.State())
        type2nd.setTitle(MusicSortTypeLister.getString(Int(MusicSortTypeLister.getSortTypeNum(mSort._2ndType))), for: UIControl.State())
        type3rd.setTitle(MusicSortTypeLister.getString(Int(MusicSortTypeLister.getSortTypeNum(mSort._3rdType))), for: UIControl.State())
        type4th.setTitle(MusicSortTypeLister.getString(Int(MusicSortTypeLister.getSortTypeNum(mSort._4thType))), for: UIControl.State())
        type5th.setTitle(MusicSortTypeLister.getString(Int(MusicSortTypeLister.getSortTypeNum(mSort._5thType))), for: UIControl.State())
        order1st.selectedSegmentIndex = mSort._1stOrder == SortOrder.Ascending ? 0 : 1
        order2nd.selectedSegmentIndex = mSort._2ndOrder == SortOrder.Ascending ? 0 : 1
        order3rd.selectedSegmentIndex = mSort._3rdOrder == SortOrder.Ascending ? 0 : 1
        order4th.selectedSegmentIndex = mSort._4thOrder == SortOrder.Ascending ? 0 : 1
        order5th.selectedSegmentIndex = mSort._5thOrder == SortOrder.Ascending ? 0 : 1
    }
    
    var mTextAlertView: TextAlertView!
    @IBAction func editSortName(_ sender: AnyObject) {
        mTextAlertView = TextAlertView(title: NSLocalizedString("Sort Name", comment: "ViewSortSetting"), message: NSLocalizedString("Input sort name and press OK.", comment: "ViewSortSetting"), placeholder: "Sort Name", defaultText: mSortName, kbd: UIKeyboardType.default, okAction: TextAlertViewAction(method: {(text)->Void in
            self.mSortName = text
            if self.mSortName.count == 0 {
                let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewSortSetting"), message: NSLocalizedString("Sort Name is empty.", comment: "ViewSortSetting"))
                alert.show(self)
                return
            }
            FileReader.saveSortName(self.rparam_SortId, name: self.mSortName)
            self.title = self.mSortName
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }
    @IBAction func order1stValueChanged(_ sender: AnyObject) {
        mSort._1stOrder = (sender as! UISegmentedControl).selectedSegmentIndex == 0 ? SortOrder.Ascending : SortOrder.Desending
    }
    @IBAction func order2ndValueChanged(_ sender: AnyObject) {
        mSort._2ndOrder = (sender as! UISegmentedControl).selectedSegmentIndex == 0 ? SortOrder.Ascending : SortOrder.Desending
    }
    @IBAction func order3rdValueChanged(_ sender: AnyObject) {
        mSort._3rdOrder = (sender as! UISegmentedControl).selectedSegmentIndex == 0 ? SortOrder.Ascending : SortOrder.Desending
    }
    @IBAction func order4thValueChanged(_ sender: AnyObject) {
        mSort._4thOrder = (sender as! UISegmentedControl).selectedSegmentIndex == 0 ? SortOrder.Ascending : SortOrder.Desending
    }
    @IBAction func order5thValueChanged(_ sender: AnyObject) {
        mSort._5thOrder = (sender as! UISegmentedControl).selectedSegmentIndex == 0 ? SortOrder.Ascending : SortOrder.Desending
    }
    @IBAction func type1stTouchUpInside(_ sender: AnyObject) {
        present(ViewSortTypeSetting.checkOut(self, sortId: rparam_SortId, typeNo: 1, typeId: MusicSortTypeLister.getSortTypeNum(mSort._1stType)), animated: true, completion: nil)
    }
    @IBAction func type2ndTouchUpInside(_ sender: AnyObject) {
        present(ViewSortTypeSetting.checkOut(self, sortId: rparam_SortId, typeNo: 2, typeId: MusicSortTypeLister.getSortTypeNum(mSort._2ndType)), animated: true, completion: nil)
    }
    @IBAction func type3rdTouchUpInside(_ sender: AnyObject) {
        present(ViewSortTypeSetting.checkOut(self, sortId: rparam_SortId, typeNo: 3, typeId: MusicSortTypeLister.getSortTypeNum(mSort._3rdType)), animated: true, completion: nil)
    }
    @IBAction func type4thTouchUpInside(_ sender: AnyObject) {
        present(ViewSortTypeSetting.checkOut(self, sortId: rparam_SortId, typeNo: 4, typeId: MusicSortTypeLister.getSortTypeNum(mSort._4thType)), animated: true, completion: nil)
    }
    @IBAction func type5thTouchUpInside(_ sender: AnyObject) {
        present(ViewSortTypeSetting.checkOut(self, sortId: rparam_SortId, typeNo: 5, typeId: MusicSortTypeLister.getSortTypeNum(mSort._5thType)), animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //navigationController?.navigationBarHidden = false
        Admob.shAdView(adHeight)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //navigationController?.navigationBarHidden = true
    }
    
    override func didMove(toParent parent: UIViewController?) {
        FileReader.saveSort(rparam_SortId, sort: mSort)
        rparam_ParentView.refreshAll()
    }
    
    @objc func applicationWillEnterForeground() {
        Admob.shAdView(adHeight)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let notifc: NotificationCenter = NotificationCenter.default
        notifc.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        
        if let name = FileReader.readSortName(rparam_SortId) {
            mSortName = name
        }
        else {
            let _ = navigationController?.popViewController(animated: true)
            return
        }
        
        if let sort = FileReader.readSort(MusicSort(musics: [Int32 : MusicData](), scores: [Int32 : MusicScore](), rivalScores: [Int32 : MusicScore](), webMusicIds: [Int32 : WebMusicId]()), id: rparam_SortId) {
            mSort = sort
        }
        else {
            let _ = navigationController?.popViewController(animated: true)
            return
        }
        
        setSortData()
        
        self.title = mSortName
        adView.addSubview(Admob.getAdBannerView(self))

        scrollView.indicatorStyle = UIScrollView.IndicatorStyle.white
        scrollView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
