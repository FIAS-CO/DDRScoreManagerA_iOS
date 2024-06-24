//
//  ViewFilterSetting.swift
//  dsm
//
//  Created by LinaNfinE on 6/13/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewFilterSetting: UIViewController, UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate {
    
    static func checkOut(_ parentView: ViewFilterList?, filterId: Int32) -> (ViewFilterSetting) {
        let storyboard = UIStoryboard(name: "ViewFilterSetting", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! ViewFilterSetting
        ret.rparam_ParentView = parentView
        ret.rparam_FilterId = filterId
        return ret
    }
    
    var rparam_ParentView: ViewFilterList!
    var rparam_FilterId: Int32!
    
    var mFilterName: String!
    var mFilter: MusicFilter!

    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var shockArrowsExistsSP: UITableView!
    @IBOutlet weak var shockArrowsExistsDP: UITableView!
    @IBOutlet weak var shockViewSP: UIView!
    @IBOutlet weak var shockViewDP: UIView!
    @IBOutlet weak var dispCpatOnlyCpat: UIView!
    @IBOutlet weak var dispEpatNoCpat: UIView!
    
    @IBOutlet weak var textScoreRangeMin: UILabel!
    @IBOutlet weak var textScoreRangeMax: UILabel!
    @IBOutlet weak var textMaxComboRangeMin: UILabel!
    @IBOutlet weak var textMaxComboRangeMax: UILabel!
    @IBOutlet weak var textPlayCountRangeMin: UILabel!
    @IBOutlet weak var textPlayCountRangeMax: UILabel!
    @IBOutlet weak var textClearCountRangeMin: UILabel!
    @IBOutlet weak var textClearCountRangeMax: UILabel!
    @IBOutlet weak var textScoreRangeRivalMin: UILabel!
    @IBOutlet weak var textScoreRangeRivalMax: UILabel!
    @IBOutlet weak var textMaxComboRangeRivalMin: UILabel!
    @IBOutlet weak var textMaxComboRangeRivalMax: UILabel!
    //@IBOutlet weak var textPlayCountRangeRivalMin: UILabel!
    //@IBOutlet weak var textPlayCountRangeRivalMax: UILabel!
    //@IBOutlet weak var textClearCountRangeRivalMin: UILabel!
    //@IBOutlet weak var textClearCountRangeRivalMax: UILabel!
    @IBOutlet weak var textScoreDifferencePlusMin: UILabel!
    @IBOutlet weak var textScoreDifferencePlusMax: UILabel!
    @IBOutlet weak var textScoreDifferenceMinusMin: UILabel!
    @IBOutlet weak var textScoreDifferenceMinusMax: UILabel!
    @IBOutlet weak var textMaxComboDifferencePlusMin: UILabel!
    @IBOutlet weak var textMaxComboDifferencePlusMax: UILabel!
    @IBOutlet weak var textMaxComboDifferenceMinusMin: UILabel!
    @IBOutlet weak var textMaxComboDifferenceMinusMax: UILabel!
    //@IBOutlet weak var textPlayCountDifferencePlusMin: UILabel!
    //@IBOutlet weak var textPlayCountDifferencePlusMax: UILabel!
    //@IBOutlet weak var textPlayCountDifferenceMinusMin: UILabel!
    //@IBOutlet weak var textPlayCountDifferenceMinusMax: UILabel!
    //@IBOutlet weak var textClearCountDifferencePlusMin: UILabel!
    //@IBOutlet weak var textClearCountDifferencePlusMax: UILabel!
    //@IBOutlet weak var textClearCountDifferenceMinusMin: UILabel!
    //@IBOutlet weak var textClearCountDifferenceMinusMax: UILabel!
    
    @IBOutlet weak var swPatbSP: UISwitch!
    @IBOutlet weak var swPatBSP: UISwitch!
    @IBOutlet weak var swPatDSP: UISwitch!
    @IBOutlet weak var swPatESP: UISwitch!
    @IBOutlet weak var swPatCSP: UISwitch!
    @IBOutlet weak var swPatBDP: UISwitch!
    @IBOutlet weak var swPatDDP: UISwitch!
    @IBOutlet weak var swPatEDP: UISwitch!
    @IBOutlet weak var swPatCDP: UISwitch!
    @IBOutlet weak var swPatConlyC: UISwitch!
    @IBOutlet weak var swPatEnoC: UISwitch!
    @IBOutlet weak var swDif1: UISwitch!
    @IBOutlet weak var swDif2: UISwitch!
    @IBOutlet weak var swDif3: UISwitch!
    @IBOutlet weak var swDif4: UISwitch!
    @IBOutlet weak var swDif5: UISwitch!
    @IBOutlet weak var swDif6: UISwitch!
    @IBOutlet weak var swDif7: UISwitch!
    @IBOutlet weak var swDif8: UISwitch!
    @IBOutlet weak var swDif9: UISwitch!
    @IBOutlet weak var swDif10: UISwitch!
    @IBOutlet weak var swDif11: UISwitch!
    @IBOutlet weak var swDif12: UISwitch!
    @IBOutlet weak var swDif13: UISwitch!
    @IBOutlet weak var swDif14: UISwitch!
    @IBOutlet weak var swDif15: UISwitch!
    @IBOutlet weak var swDif16: UISwitch!
    @IBOutlet weak var swDif17: UISwitch!
    @IBOutlet weak var swDif18: UISwitch!
    @IBOutlet weak var swDif19: UISwitch!
    @IBOutlet weak var swSerWORLD: UISwitch!
    @IBOutlet weak var swSerA3: UISwitch!
    @IBOutlet weak var swSerA20PLUS: UISwitch!
    @IBOutlet weak var swSerA20: UISwitch!
    @IBOutlet weak var swSerA: UISwitch!
    @IBOutlet weak var swSer2014: UISwitch!
    @IBOutlet weak var swSer2013: UISwitch!
    @IBOutlet weak var swSerX3: UISwitch!
    @IBOutlet weak var swSerX2: UISwitch!
    @IBOutlet weak var swSerX: UISwitch!
    @IBOutlet weak var swSerSuperNOVA2: UISwitch!
    @IBOutlet weak var swSerSuperNOVA: UISwitch!
    @IBOutlet weak var swSerEXTREME: UISwitch!
    @IBOutlet weak var swSerMAX2: UISwitch!
    @IBOutlet weak var swSerMAX: UISwitch!
    @IBOutlet weak var swSer5th: UISwitch!
    @IBOutlet weak var swSer4th: UISwitch!
    @IBOutlet weak var swSer3rd: UISwitch!
    @IBOutlet weak var swSer2nd: UISwitch!
    @IBOutlet weak var swSer1st: UISwitch!
    @IBOutlet weak var swRankAAA: UISwitch!
    @IBOutlet weak var swRankAAp: UISwitch!
    @IBOutlet weak var swRankAA: UISwitch!
    @IBOutlet weak var swRankAAm: UISwitch!
    @IBOutlet weak var swRankAp: UISwitch!
    @IBOutlet weak var swRankA: UISwitch!
    @IBOutlet weak var swRankAm: UISwitch!
    @IBOutlet weak var swRankBp: UISwitch!
    @IBOutlet weak var swRankB: UISwitch!
    @IBOutlet weak var swRankBm: UISwitch!
    @IBOutlet weak var swRankCp: UISwitch!
    @IBOutlet weak var swRankC: UISwitch!
    @IBOutlet weak var swRankCm: UISwitch!
    @IBOutlet weak var swRankDp: UISwitch!
    @IBOutlet weak var swRankD: UISwitch!
    @IBOutlet weak var swRankE: UISwitch!
    @IBOutlet weak var swRankNoPlay: UISwitch!
    @IBOutlet weak var swFcMFC: UISwitch!
    @IBOutlet weak var swFcPFC: UISwitch!
    @IBOutlet weak var swFcFC: UISwitch!
    @IBOutlet weak var swFcGFC: UISwitch!
    @IBOutlet weak var swFcLife4: UISwitch!
    @IBOutlet weak var swFcNoFC: UISwitch!
    @IBOutlet weak var swRankAAARival: UISwitch!
    @IBOutlet weak var swRankAApRival: UISwitch!
    @IBOutlet weak var swRankAARival: UISwitch!
    @IBOutlet weak var swRankAAmRival: UISwitch!
    @IBOutlet weak var swRankApRival: UISwitch!
    @IBOutlet weak var swRankARival: UISwitch!
    @IBOutlet weak var swRankAmRival: UISwitch!
    @IBOutlet weak var swRankBpRival: UISwitch!
    @IBOutlet weak var swRankBRival: UISwitch!
    @IBOutlet weak var swRankBmRival: UISwitch!
    @IBOutlet weak var swRankCpRival: UISwitch!
    @IBOutlet weak var swRankCRival: UISwitch!
    @IBOutlet weak var swRankCmRival: UISwitch!
    @IBOutlet weak var swRankDpRival: UISwitch!
    @IBOutlet weak var swRankDRival: UISwitch!
    @IBOutlet weak var swRankERival: UISwitch!
    @IBOutlet weak var swRankNoPlayRival: UISwitch!
    @IBOutlet weak var swFcMFCRival: UISwitch!
    @IBOutlet weak var swFcPFCRival: UISwitch!
    @IBOutlet weak var swFcFCRival: UISwitch!
    @IBOutlet weak var swFcGFCRival: UISwitch!
    @IBOutlet weak var swFcLife4Rival: UISwitch!
    @IBOutlet weak var swFcNoFCRival: UISwitch!
    @IBOutlet weak var swWin: UISwitch!
    @IBOutlet weak var swLose: UISwitch!
    @IBOutlet weak var swDraw: UISwitch!
    @IBOutlet weak var swDeleted: UISwitch!
    
    func setFilterData() {
        textScoreRangeMin.text = mFilter.ScoreMin.description
        textScoreRangeMax.text = mFilter.ScoreMax.description
        textMaxComboRangeMin.text = mFilter.MaxComboMin.description
        textMaxComboRangeMax.text = mFilter.MaxComboMax == Int32.max ? "∞" : mFilter.MaxComboMax.description
        textPlayCountRangeMin.text = mFilter.PlayCountMin.description
        textPlayCountRangeMax.text = mFilter.PlayCountMax == Int32.max ? "∞" : mFilter.PlayCountMax.description
        textClearCountRangeMin.text = mFilter.ClearCountMin.description
        textClearCountRangeMax.text = mFilter.ClearCountMax == Int32.max ? "∞" : mFilter.ClearCountMax.description
        textScoreRangeRivalMin.text = mFilter.ScoreMinRival.description
        textScoreRangeRivalMax.text = mFilter.ScoreMaxRival.description
        textMaxComboRangeRivalMin.text = mFilter.MaxComboMinRival.description
        textMaxComboRangeRivalMax.text = mFilter.MaxComboMaxRival == Int32.max ? "∞" : mFilter.MaxComboMaxRival.description
        //textPlayCountRangeRivalMin.text = mFilter.PlayCountMinRival.description
        //textPlayCountRangeRivalMax.text = mFilter.PlayCountMaxRival == Int32.max ? "∞" : mFilter.PlayCountMaxRival.description
        //textClearCountRangeRivalMin.text = mFilter.ClearCountMinRival.description
        //textClearCountRangeRivalMax.text = mFilter.ClearCountMaxRival == Int32.max ? "∞" : mFilter.ClearCountMaxRival.description
        textScoreDifferencePlusMin.text = mFilter.ScoreDifferencePlusMin.description
        textScoreDifferencePlusMax.text = mFilter.ScoreDifferencePlusMax.description
        textScoreDifferenceMinusMin.text = (-mFilter.ScoreDifferenceMinusMin).description
        textScoreDifferenceMinusMax.text = (-mFilter.ScoreDifferenceMinusMax).description
        textMaxComboDifferencePlusMin.text = mFilter.MaxComboDifferencePlusMin.description
        textMaxComboDifferencePlusMax.text = mFilter.MaxComboDifferencePlusMax == Int32.max ? "∞" : mFilter.MaxComboDifferencePlusMax.description
        textMaxComboDifferenceMinusMin.text = (-mFilter.MaxComboDifferenceMinusMin).description
        textMaxComboDifferenceMinusMax.text = mFilter.MaxComboDifferenceMinusMax == Int32.min ? "∞" : (-mFilter.MaxComboDifferenceMinusMax).description
        //textPlayCountDifferencePlusMin.text = mFilter.PlayCountDifferencePlusMin.description
        //textPlayCountDifferencePlusMax.text = mFilter.PlayCountDifferencePlusMax == Int32.max ? "∞" : mFilter.PlayCountDifferencePlusMax.description
        ///textPlayCountDifferenceMinusMin.text = (-mFilter.PlayCountDifferenceMinusMin).description
        //textPlayCountDifferenceMinusMax.text = mFilter.PlayCountDifferenceMinusMax == Int32.min ? "∞" : (-mFilter.PlayCountDifferenceMinusMax).description
        //textClearCountDifferencePlusMin.text = mFilter.ClearCountDifferencePlusMin.description
        //textClearCountDifferencePlusMax.text = mFilter.ClearCountDifferencePlusMax == Int32.max ? "∞" : mFilter.ClearCountDifferencePlusMax.description
        //textClearCountDifferenceMinusMin.text = (-mFilter.ClearCountDifferenceMinusMin).description
        //textClearCountDifferenceMinusMax.text = mFilter.ClearCountDifferenceMinusMax == Int32.min ? "∞" : (-mFilter.ClearCountDifferenceMinusMax).description
        
        swPatbSP.isOn = mFilter.bSP
        swPatBSP.isOn = mFilter.BSP
        swPatDSP.isOn = mFilter.DSP
        swPatESP.isOn = mFilter.ESP
        swPatCSP.isOn = mFilter.CSP
        swPatBDP.isOn = mFilter.BDP
        swPatDDP.isOn = mFilter.DDP
        swPatEDP.isOn = mFilter.EDP
        swPatCDP.isOn = mFilter.CDP
        swPatConlyC.isOn = mFilter.AllowOnlyChallenge
        swPatEnoC.isOn = mFilter.AllowExpertWhenNoChallenge
        swDif1.isOn = mFilter.Dif1
        swDif2.isOn = mFilter.Dif2
        swDif3.isOn = mFilter.Dif3
        swDif4.isOn = mFilter.Dif4
        swDif5.isOn = mFilter.Dif5
        swDif6.isOn = mFilter.Dif6
        swDif7.isOn = mFilter.Dif7
        swDif8.isOn = mFilter.Dif8
        swDif9.isOn = mFilter.Dif9
        swDif10.isOn = mFilter.Dif10
        swDif11.isOn = mFilter.Dif11
        swDif12.isOn = mFilter.Dif12
        swDif13.isOn = mFilter.Dif13
        swDif14.isOn = mFilter.Dif14
        swDif15.isOn = mFilter.Dif15
        swDif16.isOn = mFilter.Dif16
        swDif17.isOn = mFilter.Dif17
        swDif18.isOn = mFilter.Dif18
        swDif19.isOn = mFilter.Dif19
        swSerWORLD.isOn = mFilter.SerWORLD
        swSerA3.isOn = mFilter.SerA3
        swSerA20PLUS.isOn = mFilter.SerA20PLUS
        swSerA20.isOn = mFilter.SerA20
        swSerA.isOn = mFilter.SerA
        swSer2014.isOn = mFilter.Ser2014
        swSer2013.isOn = mFilter.Ser2013
        swSerX3.isOn = mFilter.SerX3
        swSerX2.isOn = mFilter.SerX2
        swSerX.isOn = mFilter.SerX
        swSerSuperNOVA2.isOn = mFilter.SerSuperNova2
        swSerSuperNOVA.isOn = mFilter.SerSuperNova
        swSerEXTREME.isOn = mFilter.SerEXTREME
        swSerMAX2.isOn = mFilter.SerMAX2
        swSerMAX.isOn = mFilter.SerMAX
        swSer5th.isOn = mFilter.Ser5th
        swSer4th.isOn = mFilter.Ser4th
        swSer3rd.isOn = mFilter.Ser3rd
        swSer2nd.isOn = mFilter.Ser2nd
        swSer1st.isOn = mFilter.Ser1st
        swRankAAA.isOn = mFilter.RankAAA
        swRankAAp.isOn = mFilter.RankAAp
        swRankAA.isOn = mFilter.RankAA
        swRankAAm.isOn = mFilter.RankAAm
        swRankAp.isOn = mFilter.RankAp
        swRankA.isOn = mFilter.RankA
        swRankAm.isOn = mFilter.RankAm
        swRankBp.isOn = mFilter.RankBp
        swRankB.isOn = mFilter.RankB
        swRankBm.isOn = mFilter.RankBm
        swRankCp.isOn = mFilter.RankCp
        swRankC.isOn = mFilter.RankC
        swRankCm.isOn = mFilter.RankCm
        swRankDp.isOn = mFilter.RankDp
        swRankD.isOn = mFilter.RankD
        swRankE.isOn = mFilter.RankE
        swRankNoPlay.isOn = mFilter.RankNoPlay
        swFcMFC.isOn = mFilter.FcMFC
        swFcPFC.isOn = mFilter.FcPFC
        swFcFC.isOn = mFilter.FcFC
        swFcGFC.isOn = mFilter.FcGFC
        swFcLife4.isOn = mFilter.FcLife4
        swFcNoFC.isOn = mFilter.FcNoFC
        swRankAAARival.isOn = mFilter.RankAAArival
        swRankAApRival.isOn = mFilter.RankAAprival
        swRankAARival.isOn = mFilter.RankAArival
        swRankAAmRival.isOn = mFilter.RankAAmrival
        swRankApRival.isOn = mFilter.RankAprival
        swRankARival.isOn = mFilter.RankArival
        swRankAmRival.isOn = mFilter.RankAmrival
        swRankBpRival.isOn = mFilter.RankBprival
        swRankBRival.isOn = mFilter.RankBrival
        swRankBmRival.isOn = mFilter.RankBmrival
        swRankCpRival.isOn = mFilter.RankCprival
        swRankCRival.isOn = mFilter.RankCrival
        swRankCmRival.isOn = mFilter.RankCmrival
        swRankDpRival.isOn = mFilter.RankDprival
        swRankDRival.isOn = mFilter.RankDrival
        swRankERival.isOn = mFilter.RankErival
        swRankNoPlayRival.isOn = mFilter.RankNoPlayrival
        swFcMFCRival.isOn = mFilter.FcMFCrival
        swFcPFCRival.isOn = mFilter.FcPFCrival
        swFcFCRival.isOn = mFilter.FcFCrival
        swFcGFCRival.isOn = mFilter.FcGFCrival
        swFcLife4Rival.isOn = mFilter.FcLife4rival
        swFcNoFCRival.isOn = mFilter.FcNoFCrival
        swWin.isOn = mFilter.RivalWin
        swLose.isOn = mFilter.RivalLose
        swDraw.isOn = mFilter.RivalDraw
        swDeleted.isOn = mFilter.OthersDeleted
        
        shockArrowsExistsSP.isUserInteractionEnabled = mFilter.CSP || mFilter.AllowOnlyChallenge
        shockArrowsExistsSP.alpha = shockArrowsExistsSP.isUserInteractionEnabled ? 1 : 0.3
        shockArrowsExistsDP.isUserInteractionEnabled = mFilter.CDP || mFilter.AllowOnlyChallenge
        shockArrowsExistsDP.alpha = shockArrowsExistsDP.isUserInteractionEnabled ? 1 : 0.3

        filterDispCpat()
    }
    
    var mTextAlertView: TextAlertView!
    @IBAction func editFilterName(_ sender: AnyObject) {
        mTextAlertView = TextAlertView(title: NSLocalizedString("Filter Name", comment: "ViewFilterSetting"), message: NSLocalizedString("Input filter name and press OK.", comment: "ViewFilterSetting"), placeholder: "Filter Name",defaultText: mFilterName, kbd: UIKeyboardType.default, okAction: TextAlertViewAction(method: {(text)->Void in
            if text.count == 0 {
                let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Filter Name is empty.", comment: "ViewFilterSetting"))
                alert.show(self)
                return
            }
            self.mFilterName = text
            FileReader.saveFilterName(self.rparam_FilterId, name: self.mFilterName)
            self.title = self.mFilterName
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }
    @IBAction func editScoreRange(_ sender: AnyObject) {
        mTextAlertView = TextAlertView(title: NSLocalizedString("Score Range", comment: "ViewFilterSetting"), message: NSLocalizedString("1. Input FROM(minimum) score.", comment: "ViewFilterSetting"), placeholder: "0",defaultText: mFilter.ScoreMin.description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
            let prevStr = text
            if let no = Int(prevStr) {
                if no >= 0 && no <= 1000000 {
                    self.mTextAlertView = TextAlertView(title: NSLocalizedString("Score Range", comment: "ViewFilterSetting"), message: NSLocalizedString("2. Input TO(maximum) score.", comment: "ViewFilterSetting"), placeholder: "1000000",defaultText: self.mFilter.ScoreMax.description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
                        if let no = Int(text) {
                            let nom = Int(prevStr)!
                            if no >= nom && no <= 1000000 {
                                self.mFilter.ScoreMin = Int32(nom)
                                self.mFilter.ScoreMax = Int32(no)
                                self.setFilterData()
                                return
                            }
                        }
                        let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Max score required FROM to 1000000 number.", comment: "ViewFilterSetting"))
                        alert.show(self)
                    }), cancelAction: nil)
                    self.mTextAlertView.show(self)
                    return
                }
            }
            let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Min score required 0 to 1000000 number.", comment: "ViewFilterSetting"))
            alert.show(self)
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }
    @IBAction func editMaxComboRange(_ sender: AnyObject) { 
        mTextAlertView = TextAlertView(title: NSLocalizedString("Max Combo Range", comment: "ViewFilterSetting"), message: NSLocalizedString("1. Input FROM(minimum) combo.", comment: "ViewFilterSetting"), placeholder: "0",defaultText: mFilter.MaxComboMin.description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
            let prevStr = text
            if let no = Int(prevStr) {
                if no >= 0 {
                    self.mTextAlertView = TextAlertView(title: NSLocalizedString("Max Combo Range", comment: "ViewFilterSetting"), message: NSLocalizedString("2. Input TO(maximum) combo.", comment: "ViewFilterSetting"), placeholder: "9999",defaultText: min(9999, self.mFilter.MaxComboMax).description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
                        if let no = Int(text) {
                            let nom = Int(prevStr)!
                            if no >= nom {
                                self.mFilter.MaxComboMin = nom > 9999 ? 9999 : Int32(nom)
                                self.mFilter.MaxComboMax = no >= 9999 ? Int32.max : Int32(no)
                                self.setFilterData()
                                return
                            }
                        }
                        let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Max combo count required over than MIN number.", comment: "ViewFilterSetting"))
                        alert.show(self)
                    }), cancelAction: nil)
                    self.mTextAlertView.show(self)
                    return
                }
            }
            let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Min combo count required over than 0 number.", comment: "ViewFilterSetting"))
            alert.show(self)
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }
    @IBAction func editPlayCountRange(_ sender: AnyObject) { 
        mTextAlertView = TextAlertView(title: NSLocalizedString("Play Count Range", comment: "ViewFilterSetting"), message: NSLocalizedString("1. Input FROM(minimum) plays.", comment: "ViewFilterSetting"), placeholder: "0",defaultText: mFilter.PlayCountMin.description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
            let prevStr = text
            if let no = Int(prevStr) {
                if no >= 0 {
                    self.mTextAlertView = TextAlertView(title: NSLocalizedString("Play Count Range", comment: "ViewFilterSetting"), message: NSLocalizedString("2. Input TO(maximum) plays.", comment: "ViewFilterSetting"), placeholder: "9999",defaultText: min(9999, self.mFilter.PlayCountMax).description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
                        if let no = Int(text) {
                            let nom = Int(prevStr)!
                            if no >= nom {
                                self.mFilter.PlayCountMin = nom > 9999 ? 9999 : Int32(nom)
                                self.mFilter.PlayCountMax = no >= 9999 ? Int32.max : Int32(no)
                                self.setFilterData()
                                return
                            }
                        }
                        let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Max play count required over than MIN number.", comment: "ViewFilterSetting"))
                        alert.show(self)
                    }), cancelAction: nil)
                    self.mTextAlertView.show(self)
                    return
                }
            }
            let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Min play count required over than 0 number.", comment: "ViewFilterSetting"))
                        alert.show(self)

        }), cancelAction: nil)
        mTextAlertView.show(self)
    }
    
    // 全選択ボタンのアクション
    @IBAction func selectAllGoldButtonTapped(_ sender: UIButton) {
        setGoldSwitches(isOn: true)
    }

    // 全解除ボタンのアクション
    @IBAction func deselectAllGoldButtonTapped(_ sender: UIButton) {
        setGoldSwitches(isOn: false)
    }

    // GOLDカテゴリのスイッチを設定する関数
    private func setGoldSwitches(isOn: Bool) {
        swSerWORLD.setOn(isOn, animated: true)
        swSerA3.setOn(isOn, animated: true)
        swSerA20PLUS.setOn(isOn, animated: true)
        swSerA20.setOn(isOn, animated: true)
        
        // mFilterのプロパティを直接更新
        mFilter.SerWORLD = isOn
        mFilter.SerA3 = isOn
        mFilter.SerA20PLUS = isOn
        mFilter.SerA20 = isOn
        
        print("All GOLD switches set to: \(isOn)")
    }
    
    // WHITE カテゴリ
    @IBAction func selectAllWhiteButtonTapped(_ sender: UIButton) {
        setWhiteSwitches(isOn: true)
    }

    @IBAction func deselectAllWhiteButtonTapped(_ sender: UIButton) {
        setWhiteSwitches(isOn: false)
    }
    
    private func setWhiteSwitches(isOn: Bool) {
        [swSerA, swSer2014, swSer2013].forEach { $0?.setOn(isOn, animated: true) }
        
        mFilter.SerA = isOn
        mFilter.Ser2014 = isOn
        mFilter.Ser2013 = isOn
        
        print("All WHITE switches set to: \(isOn)")
    }

    // CLASSIC カテゴリ
    @IBAction func selectAllClassicButtonTapped(_ sender: UIButton) {
        setClassicSwitches(isOn: true)
    }

    @IBAction func deselectAllClassicButtonTapped(_ sender: UIButton) {
        setClassicSwitches(isOn: false)
    }

    private func setClassicSwitches(isOn: Bool) {
        [swSerX3, swSerX2, swSerX, swSerSuperNOVA2, swSerSuperNOVA, swSerEXTREME,
         swSerMAX2, swSerMAX, swSer5th, swSer4th, swSer3rd, swSer2nd, swSer1st].forEach { $0?.setOn(isOn, animated: true) }
        
        mFilter.SerX3 = isOn
        mFilter.SerX2 = isOn
        mFilter.SerX = isOn
        mFilter.SerSuperNova2 = isOn
        mFilter.SerSuperNova = isOn
        mFilter.SerEXTREME = isOn
        mFilter.SerMAX2 = isOn
        mFilter.SerMAX = isOn
        mFilter.Ser5th = isOn
        mFilter.Ser4th = isOn
        mFilter.Ser3rd = isOn
        mFilter.Ser2nd = isOn
        mFilter.Ser1st = isOn
        
        print("All CLASSIC switches set to: \(isOn)")
    }
    
    @IBAction func editClearCountRange(_ sender: AnyObject) {
        mTextAlertView = TextAlertView(title: NSLocalizedString("Clear Count Range", comment: "ViewFilterSetting"), message: NSLocalizedString("1. Input FROM(minimum) clears.", comment: "ViewFilterSetting"), placeholder: "0",defaultText: mFilter.ClearCountMin.description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
            let prevStr = text
            if let no = Int(prevStr) {
                if no >= 0 {
                    self.mTextAlertView = TextAlertView(title: NSLocalizedString("Clear Count Range", comment: "ViewFilterSetting"), message: NSLocalizedString("2. Input TO(maximum) clears.", comment: "ViewFilterSetting"), placeholder: "9999",defaultText: min(9999, self.mFilter.ClearCountMax).description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
                        if let no = Int(text) {
                            let nom = Int(prevStr)!
                            if no >= nom {
                                self.mFilter.ClearCountMin = nom > 9999 ? 9999 : Int32(nom)
                                self.mFilter.ClearCountMax = no >= 9999 ? Int32.max : Int32(no)
                                self.setFilterData()
                                return
                            }
                        }
                        let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Max clear count required over than MIN number.", comment: "ViewFilterSetting"))
                        alert.show(self)
                    }), cancelAction: nil)
                    self.mTextAlertView.show(self)
                    return
                }
            }
            let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Min clear count required over than 0 number.", comment: "ViewFilterSetting"))
                        alert.show(self)
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }
    @IBAction func editScoreRangeRival(_ sender: AnyObject) { 
        mTextAlertView = TextAlertView(title: NSLocalizedString("Rival Score Range", comment: "ViewFilterSetting"), message: NSLocalizedString("1. Input FROM(minimum) rival score.", comment: "ViewFilterSetting"), placeholder: "0",defaultText: mFilter.ScoreMinRival.description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
            let prevStr = text
            if let no = Int(prevStr) {
                if no >= 0 && no <= 1000000  {
                    self.mTextAlertView = TextAlertView(title: NSLocalizedString("Rival Score Range", comment: "ViewFilterSetting"), message: NSLocalizedString("2. Input TO(maximum) rival score.", comment: "ViewFilterSetting"), placeholder: "1000000",defaultText: self.mFilter.ScoreMaxRival.description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
                        if let no = Int(text) {
                            let nom = Int(prevStr)!
                            if no >= nom && no <= 1000000 {
                                self.mFilter.ScoreMinRival = Int32(nom)
                                self.mFilter.ScoreMaxRival = Int32(no)
                                self.setFilterData()
                                return
                            }
                        }
                        let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Max score required over than MIN number.", comment: "ViewFilterSetting"))
                        alert.show(self)
                    }), cancelAction: nil)
                    self.mTextAlertView.show(self)
                    return
                }
            }
            let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Min score required 0 to 1000000 number.", comment: "ViewFilterSetting"))
                        alert.show(self)
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }
    @IBAction func editMaxComboRangeRival(_ sender: AnyObject) { 
        mTextAlertView = TextAlertView(title: NSLocalizedString("Rival Max Combo Range", comment: "ViewFilterSetting"), message: NSLocalizedString("1. Input FROM(minimum) rival combo.", comment: "ViewFilterSetting"), placeholder: "0",defaultText: mFilter.MaxComboMinRival.description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
            let prevStr = text
            if let no = Int(prevStr) {              if no >= 0 {
                    self.mTextAlertView = TextAlertView(title: NSLocalizedString("Rival Max Combo Range", comment: "ViewFilterSetting"), message: NSLocalizedString("2. Input TO(maximum) rival combo.", comment: "ViewFilterSetting"), placeholder: "9999",defaultText: min(9999, self.mFilter.MaxComboMaxRival).description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
                        if let no = Int(text) {
                            let nom = Int(prevStr)!
                            if no >= nom {
                                self.mFilter.MaxComboMinRival = nom > 9999 ? 9999 : Int32(nom)
                                self.mFilter.MaxComboMaxRival = no >= 9999 ? Int32.max : Int32(no)
                                self.setFilterData()
                                return
                            }
                        }
                        let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Max combo count required over than MIN number.", comment: "ViewFilterSetting"))
                        alert.show(self)
                    }), cancelAction: nil)
                    self.mTextAlertView.show(self)
                    return
                }
            }
            let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Min combo count required over than 0 number.", comment: "ViewFilterSetting"))
                        alert.show(self)
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }
    /*@IBAction func editPlayCountRangeRival(sender: AnyObject) {
        mTextAlertView = TextAlertView(title: NSLocalizedString("Rival Play Count Range", comment: "ViewFilterSetting"), message: NSLocalizedString("1. Input FROM(minimum) rival plays.", comment: "ViewFilterSetting"), placeholder: "0",defaultText: mFilter.PlayCountMinRival.description, kbd: UIKeyboardType.NumberPad, okAction: TextAlertViewAction(method: {(text)->Void in
            let prevStr = text
            if let no = Int(prevStr) {
                if no >= 0 {
                    self.mTextAlertView = TextAlertView(title: NSLocalizedString("Rival Play Count Range", comment: "ViewFilterSetting"), message: NSLocalizedString("2. Input TO(maximum) rival plays.", comment: "ViewFilterSetting"), placeholder: "9999",defaultText: min(9999, self.mFilter.PlayCountMaxRival).description, kbd: UIKeyboardType.NumberPad, okAction: TextAlertViewAction(method: {(text)->Void in
                        if let no = Int(text) {
                            let nom = Int(prevStr)!
                            if no >= nom {
                                self.mFilter.PlayCountMinRival = nom > 9999 ? 9999 : Int32(nom)
                                self.mFilter.PlayCountMaxRival = no >= 9999 ? Int32.max : Int32(no)
                                self.setFilterData()
                                return
                            }
                        }
                        let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Max play count required over than MIN number.", comment: "ViewFilterSetting"))
                        alert.show(self)
                    }), cancelAction: nil)
                    self.mTextAlertView.show(self)
                    return
                }
            }
            let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Min play count required over than 0 number.", comment: "ViewFilterSetting"))
                        alert.show(self)
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }
    @IBAction func editClearCountRangeRival(sender: AnyObject) { 
        mTextAlertView = TextAlertView(title: NSLocalizedString("Rival Clear Count Range", comment: "ViewFilterSetting"), message: NSLocalizedString("1. Input FROM(minimum) rival clears.", comment: "ViewFilterSetting"), placeholder: "0",defaultText: mFilter.ClearCountMinRival.description, kbd: UIKeyboardType.NumberPad, okAction: TextAlertViewAction(method: {(text)->Void in
            let prevStr = text
            if let no = Int(prevStr) {
                if no >= 0 {
                    self.mTextAlertView = TextAlertView(title: NSLocalizedString("Rival Clear Count Range", comment: "ViewFilterSetting"), message: NSLocalizedString("2. Input TO(maximum) rival clears.", comment: "ViewFilterSetting"), placeholder: "9999",defaultText: min(9999, self.mFilter.ClearCountMaxRival).description, kbd: UIKeyboardType.NumberPad, okAction: TextAlertViewAction(method: {(text)->Void in
                        if let no = Int(text) {
                            let nom = Int(prevStr)!
                            if no >= nom {
                                self.mFilter.ClearCountMinRival = Int32(nom)
                                self.mFilter.ClearCountMaxRival = Int32(no)
                                self.setFilterData()
                                return
                            }
                        }
                        let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Max clear count required over than MIN number.", comment: "ViewFilterSetting"))
                        alert.show(self)
                    }), cancelAction: nil)
                    self.mTextAlertView.show(self)
                    return
                }
            }
            let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Min clear count required over than 0 number.", comment: "ViewFilterSetting"))
                        alert.show(self)
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }*/
    @IBAction func editScoreDifferencePlus(_ sender: AnyObject) { 
        mTextAlertView = TextAlertView(title: NSLocalizedString("Score Difference (Plus)", comment: "ViewFilterSetting"), message: NSLocalizedString("1. Input PLUS FROM(minimum) score difference.", comment: "ViewFilterSetting"), placeholder: "0",defaultText: mFilter.ScoreDifferencePlusMin.description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
            let prevStr = text
            if let no = Int(prevStr) {
                if no >= 0 && no <= 1000000 {
                    self.mTextAlertView = TextAlertView(title: NSLocalizedString("Score Difference (Plus)", comment: "ViewFilterSetting"), message: NSLocalizedString("2. Input PLUS TO(maximum) score difference.", comment: "ViewFilterSetting"), placeholder: "1000000",defaultText: self.mFilter.ScoreDifferencePlusMax.description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
                        if let no = Int(text) {
                            let nom = Int(prevStr)!
                            if no >= nom && no <= 1000000 {
                                self.mFilter.ScoreDifferencePlusMin = Int32(nom)
                                self.mFilter.ScoreDifferencePlusMax = Int32(no)
                                self.setFilterData()
                                return
                            }
                        }
                        let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Max score required FROM to 1000000 number.", comment: "ViewFilterSetting"))
                        alert.show(self)
                    }), cancelAction: nil)
                    self.mTextAlertView.show(self)
                    return
                }
            }
            let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Min score required 0 to 1000000 number.", comment: "ViewFilterSetting"))
                        alert.show(self)
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }
    @IBAction func editScoreDifferenceMinus(_ sender: AnyObject) { 
        mTextAlertView = TextAlertView(title: NSLocalizedString("Score Difference (Minus)", comment: "ViewFilterSetting"), message: NSLocalizedString("1. Input MINUS FROM(minimum) score difference.", comment: "ViewFilterSetting"), placeholder: "0",defaultText: (-self.mFilter.ScoreDifferenceMinusMin).description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
            let prevStr = text
            if let no = Int(prevStr) {
                if no >= 0 && no <= 1000000 {
                    self.mTextAlertView = TextAlertView(title: NSLocalizedString("Score Difference (Minus)", comment: "ViewFilterSetting"), message: NSLocalizedString("2. Input MINUS TO(maximum) score difference.", comment: "ViewFilterSetting"), placeholder: "1000000",defaultText: (-self.mFilter.ScoreDifferenceMinusMax).description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
                        if let no = Int(text) {
                            let nom = Int(prevStr)!
                            if no >= nom && no <= 1000000 {
                                self.mFilter.ScoreDifferenceMinusMin = Int32(-nom)
                                self.mFilter.ScoreDifferenceMinusMax = Int32(-no)
                                self.setFilterData()
                                return
                            }
                        }
                        let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Max score required FROM to 1000000 number.", comment: "ViewFilterSetting"))
                        alert.show(self)
                    }), cancelAction: nil)
                    self.mTextAlertView.show(self)
                    return
                }
            }
            let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Min score required 0 to 1000000 number.", comment: "ViewFilterSetting"))
                        alert.show(self)
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }
    @IBAction func editMaxComboDifferencePlus(_ sender: AnyObject) { 
        mTextAlertView = TextAlertView(title: NSLocalizedString("Max Combo Difference (Plus)", comment: "ViewFilterSetting"), message: NSLocalizedString("1. Input PLUS FROM(minimum) max combo difference.", comment: "ViewFilterSetting"), placeholder: "0",defaultText: self.mFilter.MaxComboDifferencePlusMin.description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
            let prevStr = text
            if let no = Int(prevStr) {
                if no >= 0 {
                    self.mTextAlertView = TextAlertView(title: NSLocalizedString("Max Combo Difference (Plus)", comment: "ViewFilterSetting"), message: NSLocalizedString("2. Input PLUS TO(maximum) max combo difference.", comment: "ViewFilterSetting"), placeholder: "9999",defaultText: min(9999, self.mFilter.MaxComboDifferencePlusMax).description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
                        if let no = Int(text) {
                            let nom = Int(prevStr)!
                            if no >= nom {
                                self.mFilter.MaxComboDifferencePlusMin = nom > 9999 ? 9999 : Int32(nom)
                                self.mFilter.MaxComboDifferencePlusMax = no >= 9999 ? Int32.max : Int32(no)
                                self.setFilterData()
                                return
                            }
                        }
                        let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Max combo count required over than MIN number.", comment: "ViewFilterSetting"))
                        alert.show(self)
                    }), cancelAction: nil)
                    self.mTextAlertView.show(self)
                    return
                }
            }
            let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Min combo count required over than 0 number.", comment: "ViewFilterSetting"))
                        alert.show(self)
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }
    @IBAction func editMaxComboDifferenceMinus(_ sender: AnyObject) { 
        mTextAlertView = TextAlertView(title: NSLocalizedString("Max Combo Difference (Minus)", comment: "ViewFilterSetting"), message: NSLocalizedString("1. Input MINUS FROM(minimum) max combo difference.", comment: "ViewFilterSetting"), placeholder: "0",defaultText: (-self.mFilter.MaxComboDifferenceMinusMin).description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
            let prevStr = text
            if let no = Int(prevStr) {
                if no >= 0 {
                    self.mTextAlertView = TextAlertView(title: NSLocalizedString("Max Combo Difference (Minus)", comment: "ViewFilterSetting"), message: NSLocalizedString("2. Input MINUS TO(maximum) max combo difference.", comment: "ViewFilterSetting"), placeholder: "9999",defaultText: (-max(-9999, self.mFilter.MaxComboDifferenceMinusMax)).description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
                        if let no = Int(text) {
                            let nom = Int(prevStr)!
                            if no >= nom {
                                self.mFilter.MaxComboDifferenceMinusMin = nom > 9999 ? -9999 : Int32(-nom)
                                self.mFilter.MaxComboDifferenceMinusMax = no >= 9999 ? Int32.min : Int32(-no)
                                self.setFilterData()
                                return
                            }
                        }
                        let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Max combo count required over than MIN number.", comment: "ViewFilterSetting"))
                        alert.show(self)
                    }), cancelAction: nil)
                    self.mTextAlertView.show(self)
                    return
                }
            }
            let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Min combo count required over than 0 number.", comment: "ViewFilterSetting"))
                        alert.show(self)
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }
    /*@IBAction func editPlayCountDifferencePlus(sender: AnyObject) {
        mTextAlertView = TextAlertView(title: NSLocalizedString("Play Count Difference (Plus)", comment: "ViewFilterSetting"), message: NSLocalizedString("1. Input PLUS FROM(minimum) play count difference.", comment: "ViewFilterSetting"), placeholder: "0",defaultText: self.mFilter.PlayCountDifferencePlusMin.description, kbd: UIKeyboardType.NumberPad, okAction: TextAlertViewAction(method: {(text)->Void in
            let prevStr = text
            if let no = Int(prevStr) {
                if no >= 0 {
                    self.mTextAlertView = TextAlertView(title: NSLocalizedString("Play Count Difference (Plus)", comment: "ViewFilterSetting"), message: NSLocalizedString("2. Input PLUS TO(maximum) play count difference.", comment: "ViewFilterSetting"), placeholder: "9999",defaultText: min(9999, self.mFilter.PlayCountDifferencePlusMax).description, kbd: UIKeyboardType.NumberPad, okAction: TextAlertViewAction(method: {(text)->Void in
                        if let no = Int(text) {
                            let nom = Int(prevStr)!
                            if no >= nom {
                                self.mFilter.PlayCountDifferencePlusMin = nom > 9999 ? 9999 : Int32(nom)
                                self.mFilter.PlayCountDifferencePlusMax = no >= 9999 ? Int32.max : Int32(no)
                                self.setFilterData()
                                return
                            }
                        }
                        let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Max play count required over than MIN number.", comment: "ViewFilterSetting"))
                        alert.show(self)
                    }), cancelAction: nil)
                    self.mTextAlertView.show(self)
                    return
                }
            }
            let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Min play count required over than 0 number.", comment: "ViewFilterSetting"))
                        alert.show(self)
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }
    @IBAction func editPlayCountDifferenceMinus(sender: AnyObject) { 
        mTextAlertView = TextAlertView(title: NSLocalizedString("Play Count Difference (Minus)", comment: "ViewFilterSetting"), message: NSLocalizedString("1. Input MINUS FROM(minimum) play count difference.", comment: "ViewFilterSetting"), placeholder: "0",defaultText: (-self.mFilter.PlayCountDifferenceMinusMin).description, kbd: UIKeyboardType.NumberPad, okAction: TextAlertViewAction(method: {(text)->Void in
            let prevStr = text
            if let no = Int(prevStr) {
                if no >= 0 {
                    self.mTextAlertView = TextAlertView(title: NSLocalizedString("Play Count Difference (Minus)", comment: "ViewFilterSetting"), message: NSLocalizedString("2. Input MINUS TO(maximum) play count difference.", comment: "ViewFilterSetting"), placeholder: "9999",defaultText: (-max(-9999, self.mFilter.PlayCountDifferenceMinusMax)).description, kbd: UIKeyboardType.NumberPad, okAction: TextAlertViewAction(method: {(text)->Void in
                        if let no = Int(text) {
                            let nom = Int(prevStr)!
                            if no >= nom {
                                self.mFilter.PlayCountDifferenceMinusMin = nom > 9999 ? 9999 : Int32(-nom)
                                self.mFilter.PlayCountDifferenceMinusMax = no >= 9999 ? Int32.min : Int32(-no)
                                self.setFilterData()
                                return
                            }
                        }
                        let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Max play count required over than MIN number.", comment: "ViewFilterSetting"))
                        alert.show(self)
                    }), cancelAction: nil)
                    self.mTextAlertView.show(self)
                    return
                }
            }
            let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Min play count required over than 0 number.", comment: "ViewFilterSetting"))
                        alert.show(self)
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }
    @IBAction func editClearCountDifferencePlus(sender: AnyObject) { 
        mTextAlertView = TextAlertView(title: NSLocalizedString("Clear Count Difference (Plus)", comment: "ViewFilterSetting"), message: NSLocalizedString("1. Input PLUS FROM(minimum) clear count difference.", comment: "ViewFilterSetting"), placeholder: "0",defaultText: mFilter.ClearCountDifferencePlusMin.description, kbd: UIKeyboardType.NumberPad, okAction: TextAlertViewAction(method: {(text)->Void in
            let prevStr = text
            if let no = Int(prevStr) {
                if no >= 0 {
                    self.mTextAlertView = TextAlertView(title: NSLocalizedString("Clear Count Difference (Plus)", comment: "ViewFilterSetting"), message: NSLocalizedString("2. Input PLUS TO(maximum) clear count difference.", comment: "ViewFilterSetting"), placeholder: "9999",defaultText: min(9999, self.mFilter.ClearCountDifferencePlusMax).description, kbd: UIKeyboardType.NumberPad, okAction: TextAlertViewAction(method: {(text)->Void in
                        if let no = Int(text) {
                            let nom = Int(prevStr)!
                            if no >= nom {
                                self.mFilter.ClearCountDifferencePlusMin = nom > 9999 ? 9999 : Int32(nom)
                                self.mFilter.ClearCountDifferencePlusMax = no >= 9999 ? Int32.max : Int32(no)
                                self.setFilterData()
                                return
                            }
                        }
                        let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Max clear count required over than MIN number.", comment: "ViewFilterSetting"))
                        alert.show(self)
                    }), cancelAction: nil)
                    self.mTextAlertView.show(self)
                    return
                }
            }
            let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Min clear count required over than 0 number.", comment: "ViewFilterSetting"))
                        alert.show(self)
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }
    @IBAction func editClearCountDifferenceMinus(sender: AnyObject) { 
        mTextAlertView = TextAlertView(title: NSLocalizedString("Clear Count Difference (Minus)", comment: "ViewFilterSetting"), message: NSLocalizedString("1. Input MINUS FROM(minimum) clear count difference.", comment: "ViewFilterSetting"), placeholder: "0",defaultText: (-self.mFilter.ClearCountDifferenceMinusMin).description, kbd: UIKeyboardType.NumberPad, okAction: TextAlertViewAction(method: {(text)->Void in
            let prevStr = text
            if let no = Int(prevStr) {
                if no >= 0 {
                    self.mTextAlertView = TextAlertView(title: NSLocalizedString("Clear Count Difference (Minus)", comment: "ViewFilterSetting"), message: NSLocalizedString("2. Input MINUS TO(maximum) clear count difference.", comment: "ViewFilterSetting"), placeholder: "9999",defaultText: (-max(-9999, self.mFilter.ClearCountDifferenceMinusMax)).description, kbd: UIKeyboardType.NumberPad, okAction: TextAlertViewAction(method: {(text)->Void in
                        if let no = Int(text) {
                            let nom = Int(prevStr)!
                            if no >= nom {
                                self.mFilter.ClearCountDifferenceMinusMin = nom > 9999 ? -9999 : Int32(-nom)
                                self.mFilter.ClearCountDifferenceMinusMax = no >= 9999 ? Int32.min : Int32(-no)
                                self.setFilterData()
                                return
                            }
                        }
                        let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Max clear count required over than MIN number.", comment: "ViewFilterSetting"))
                        alert.show(self)
                    }), cancelAction: nil)
                    self.mTextAlertView.show(self)
                    return
                }
            }
            let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewFilterSetting"), message: NSLocalizedString("Min clear count required over than 0 number.", comment: "ViewFilterSetting"))
                        alert.show(self)
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }*/
    
    func filterDispCpat() {
        if !mFilter.CSP && ( mFilter.bSP || mFilter.BSP || mFilter.DSP || mFilter.ESP ) {
            dispCpatOnlyCpat.isUserInteractionEnabled = true
            dispCpatOnlyCpat.alpha = 1
        }
        else if !mFilter.CDP && ( mFilter.BDP || mFilter.DDP || mFilter.EDP ) {
            dispCpatOnlyCpat.isUserInteractionEnabled = true
            dispCpatOnlyCpat.alpha = 1
        }
        else {
            dispCpatOnlyCpat.isUserInteractionEnabled = false
            dispCpatOnlyCpat.alpha = 0.3
        }
        if (mFilter.CSP && !mFilter.ESP) || (mFilter.CDP && !mFilter.EDP) {
            dispEpatNoCpat.isUserInteractionEnabled = true
            dispEpatNoCpat.alpha = 1
        }
        else {
            dispEpatNoCpat.isUserInteractionEnabled = false
            dispEpatNoCpat.alpha = 0.3
        }
    }
    
    @IBAction func patternTypebSP(_ sender: AnyObject) {
        mFilter.bSP = (sender as! UISwitch).isOn
        filterDispCpat()
    }
    @IBAction func patternTypeBSP(_ sender: AnyObject) {
        mFilter.BSP = (sender as! UISwitch).isOn
        filterDispCpat()
    }
    @IBAction func patternTypeDSP(_ sender: AnyObject) {
        mFilter.DSP = (sender as! UISwitch).isOn
        filterDispCpat()
    }
    @IBAction func patternTypeESP(_ sender: AnyObject) {
        mFilter.ESP = (sender as! UISwitch).isOn
        filterDispCpat()
    }
    @IBAction func patternTypeCSP(_ sender: AnyObject) {
        mFilter.CSP = (sender as! UISwitch).isOn
        shockArrowsExistsSP.isUserInteractionEnabled = (sender as! UISwitch).isOn || mFilter.AllowOnlyChallenge
        shockArrowsExistsSP.alpha = shockArrowsExistsSP.isUserInteractionEnabled ? 1 : 0.3
        filterDispCpat()
    }
    @IBAction func patternTypeBDP(_ sender: AnyObject) {
        mFilter.BDP = (sender as! UISwitch).isOn
        filterDispCpat()
    }
    @IBAction func patternTypeDDP(_ sender: AnyObject) {
        mFilter.DDP = (sender as! UISwitch).isOn
        filterDispCpat()
    }
    @IBAction func patternTypeEDP(_ sender: AnyObject) {
        mFilter.EDP = (sender as! UISwitch).isOn
        filterDispCpat()
    }
    @IBAction func patternTypeCDP(_ sender: AnyObject) {
        mFilter.CDP = (sender as! UISwitch).isOn
        shockArrowsExistsDP.isUserInteractionEnabled = (sender as! UISwitch).isOn || mFilter.AllowOnlyChallenge
        shockArrowsExistsDP.alpha = shockArrowsExistsDP.isUserInteractionEnabled ? 1 : 0.3
        filterDispCpat()
    }
    @IBAction func dispCpatOnlyCpatCheck(_ sender: AnyObject) {
        mFilter.AllowOnlyChallenge = (sender as! UISwitch).isOn
        shockArrowsExistsSP.isUserInteractionEnabled = mFilter.CSP || mFilter.AllowOnlyChallenge
        shockArrowsExistsSP.alpha = shockArrowsExistsSP.isUserInteractionEnabled ? 1 : 0.3
        shockArrowsExistsDP.isUserInteractionEnabled = mFilter.CDP || mFilter.AllowOnlyChallenge
        shockArrowsExistsDP.alpha = shockArrowsExistsDP.isUserInteractionEnabled ? 1 : 0.3
    }
    @IBAction func dispEpatNoCpatCheck(_ sender: AnyObject) {
        mFilter.AllowExpertWhenNoChallenge = (sender as! UISwitch).isOn
    }
    @IBAction func dif1(_ sender: AnyObject) { mFilter.Dif1 = (sender as! UISwitch).isOn }
    @IBAction func dif2(_ sender: AnyObject) { mFilter.Dif2 = (sender as! UISwitch).isOn }
    @IBAction func dif3(_ sender: AnyObject) { mFilter.Dif3 = (sender as! UISwitch).isOn }
    @IBAction func dif4(_ sender: AnyObject) { mFilter.Dif4 = (sender as! UISwitch).isOn }
    @IBAction func dif5(_ sender: AnyObject) { mFilter.Dif5 = (sender as! UISwitch).isOn }
    @IBAction func dif6(_ sender: AnyObject) { mFilter.Dif6 = (sender as! UISwitch).isOn }
    @IBAction func dif7(_ sender: AnyObject) { mFilter.Dif7 = (sender as! UISwitch).isOn }
    @IBAction func dif8(_ sender: AnyObject) { mFilter.Dif8 = (sender as! UISwitch).isOn }
    @IBAction func dif9(_ sender: AnyObject) { mFilter.Dif9 = (sender as! UISwitch).isOn }
    @IBAction func dif10(_ sender: AnyObject) { mFilter.Dif10 = (sender as! UISwitch).isOn }
    @IBAction func dif11(_ sender: AnyObject) { mFilter.Dif11 = (sender as! UISwitch).isOn }
    @IBAction func dif12(_ sender: AnyObject) { mFilter.Dif12 = (sender as! UISwitch).isOn }
    @IBAction func dif13(_ sender: AnyObject) { mFilter.Dif13 = (sender as! UISwitch).isOn }
    @IBAction func dif14(_ sender: AnyObject) { mFilter.Dif14 = (sender as! UISwitch).isOn }
    @IBAction func dif15(_ sender: AnyObject) { mFilter.Dif15 = (sender as! UISwitch).isOn }
    @IBAction func dif16(_ sender: AnyObject) { mFilter.Dif16 = (sender as! UISwitch).isOn }
    @IBAction func dif17(_ sender: AnyObject) { mFilter.Dif17 = (sender as! UISwitch).isOn }
    @IBAction func dif18(_ sender: AnyObject) { mFilter.Dif18 = (sender as! UISwitch).isOn }
    @IBAction func dif19(_ sender: AnyObject) { mFilter.Dif19 = (sender as! UISwitch).isOn }
    @IBAction func serWORLD(_ sender: AnyObject) { mFilter.SerWORLD = (sender as! UISwitch).isOn }
    @IBAction func serA3(_ sender: AnyObject) {mFilter.SerA3 = (sender as! UISwitch).isOn }
    @IBAction func serA20PLUS(_ sender: AnyObject) {mFilter.SerA20PLUS = (sender as! UISwitch).isOn }
    @IBAction func serA20(_ sender: AnyObject) {mFilter.SerA20 = (sender as! UISwitch).isOn }
    @IBAction func serA(_ sender: AnyObject) {mFilter.SerA = (sender as! UISwitch).isOn }
    @IBAction func ser2014(_ sender: AnyObject) { mFilter.Ser2014 = (sender as! UISwitch).isOn }
    @IBAction func ser2013(_ sender: AnyObject) { mFilter.Ser2013 = (sender as! UISwitch).isOn }
    @IBAction func serX3(_ sender: AnyObject) { mFilter.SerX3 = (sender as! UISwitch).isOn }
    @IBAction func serX2(_ sender: AnyObject) { mFilter.SerX2 = (sender as! UISwitch).isOn }
    @IBAction func serX(_ sender: AnyObject) { mFilter.SerX = (sender as! UISwitch).isOn }
    @IBAction func serSuperNOVA2(_ sender: AnyObject) { mFilter.SerSuperNova2 = (sender as! UISwitch).isOn }
    @IBAction func serSuperNOVA(_ sender: AnyObject) { mFilter.SerSuperNova = (sender as! UISwitch).isOn }
    @IBAction func serEXTREME(_ sender: AnyObject) { mFilter.SerEXTREME = (sender as! UISwitch).isOn }
    @IBAction func serMAX2(_ sender: AnyObject) { mFilter.SerMAX2 = (sender as! UISwitch).isOn }
    @IBAction func serMAX(_ sender: AnyObject) { mFilter.SerMAX = (sender as! UISwitch).isOn }
    @IBAction func ser5th(_ sender: AnyObject) { mFilter.Ser5th = (sender as! UISwitch).isOn }
    @IBAction func ser4th(_ sender: AnyObject) { mFilter.Ser4th = (sender as! UISwitch).isOn }
    @IBAction func ser3rd(_ sender: AnyObject) { mFilter.Ser3rd = (sender as! UISwitch).isOn }
    @IBAction func ser2nd(_ sender: AnyObject) { mFilter.Ser2nd = (sender as! UISwitch).isOn }
    @IBAction func ser1st(_ sender: AnyObject) { mFilter.Ser1st = (sender as! UISwitch).isOn }
    @IBAction func rankAAA(_ sender: AnyObject) { mFilter.RankAAA = (sender as! UISwitch).isOn }
    @IBAction func rankAAp(_ sender: AnyObject) {mFilter.RankAAp = (sender as! UISwitch).isOn }
    @IBAction func rankAA(_ sender: AnyObject) { mFilter.RankAA = (sender as! UISwitch).isOn }
    @IBAction func rankAAm(_ sender: AnyObject) {mFilter.RankAAm = (sender as! UISwitch).isOn }
    @IBAction func rankAp(_ sender: AnyObject) { mFilter.RankAp = (sender as! UISwitch).isOn }
    @IBAction func rankA(_ sender: AnyObject) { mFilter.RankA = (sender as! UISwitch).isOn }
    @IBAction func rankAm(_ sender: AnyObject) { mFilter.RankAm = (sender as! UISwitch).isOn }
    @IBAction func rankBp(_ sender: AnyObject) { mFilter.RankBp = (sender as! UISwitch).isOn }
    @IBAction func rankB(_ sender: AnyObject) { mFilter.RankB = (sender as! UISwitch).isOn }
    @IBAction func rankBm(_ sender: AnyObject) { mFilter.RankBm = (sender as! UISwitch).isOn }
    @IBAction func rankCp(_ sender: AnyObject) { mFilter.RankCp = (sender as! UISwitch).isOn }
    @IBAction func rankC(_ sender: AnyObject) { mFilter.RankC = (sender as! UISwitch).isOn }
    @IBAction func rankCm(_ sender: AnyObject) { mFilter.RankCm = (sender as! UISwitch).isOn }
    @IBAction func rankDp(_ sender: AnyObject) { mFilter.RankDp = (sender as! UISwitch).isOn }
    @IBAction func rankD(_ sender: AnyObject) { mFilter.RankD = (sender as! UISwitch).isOn }
    @IBAction func rankE(_ sender: AnyObject) { mFilter.RankE = (sender as! UISwitch).isOn }
    @IBAction func rankNoPlay(_ sender: AnyObject) { mFilter.RankNoPlay = (sender as! UISwitch).isOn }
    @IBAction func fcMFC(_ sender: AnyObject) { mFilter.FcMFC = (sender as! UISwitch).isOn }
    @IBAction func fcPFC(_ sender: AnyObject) { mFilter.FcPFC = (sender as! UISwitch).isOn }
    @IBAction func fcFC(_ sender: AnyObject) { mFilter.FcFC = (sender as! UISwitch).isOn }
    @IBAction func fcGFC(_ sender: AnyObject) { mFilter.FcGFC = (sender as! UISwitch).isOn }
    @IBAction func fcLife4(_ sender: AnyObject) { mFilter.FcLife4 = (sender as! UISwitch).isOn }
    @IBAction func fcNoFC(_ sender: AnyObject) { mFilter.FcNoFC = (sender as! UISwitch).isOn }
    @IBAction func rRankAAA(_ sender: AnyObject) { mFilter.RankAAArival = (sender as! UISwitch).isOn }
    @IBAction func rRankAAp(_ sender: AnyObject) { mFilter.RankAAprival = (sender as! UISwitch).isOn }
    @IBAction func rRankAA(_ sender: AnyObject) { mFilter.RankAArival = (sender as! UISwitch).isOn }
    @IBAction func rRankAAm(_ sender: AnyObject) { mFilter.RankAAmrival = (sender as! UISwitch).isOn }
    @IBAction func rRankAp(_ sender: AnyObject) { mFilter.RankAprival = (sender as! UISwitch).isOn }
    @IBAction func rRankA(_ sender: AnyObject) { mFilter.RankArival = (sender as! UISwitch).isOn }
    @IBAction func rRankAm(_ sender: AnyObject) { mFilter.RankAmrival = (sender as! UISwitch).isOn }
    @IBAction func rRankBp(_ sender: AnyObject) { mFilter.RankBprival = (sender as! UISwitch).isOn }
    @IBAction func rRankB(_ sender: AnyObject) { mFilter.RankBrival = (sender as! UISwitch).isOn }
    @IBAction func rRankBm(_ sender: AnyObject) { mFilter.RankBmrival = (sender as! UISwitch).isOn }
    @IBAction func rRankCp(_ sender: AnyObject) { mFilter.RankCprival = (sender as! UISwitch).isOn }
    @IBAction func rRankC(_ sender: AnyObject) { mFilter.RankCrival = (sender as! UISwitch).isOn }
    @IBAction func rRankCm(_ sender: AnyObject) { mFilter.RankCmrival = (sender as! UISwitch).isOn }
    @IBAction func rRankDp(_ sender: AnyObject) { mFilter.RankDprival = (sender as! UISwitch).isOn }
    @IBAction func rRankD(_ sender: AnyObject) { mFilter.RankDrival = (sender as! UISwitch).isOn }
    @IBAction func rRankE(_ sender: AnyObject) { mFilter.RankErival = (sender as! UISwitch).isOn }
    @IBAction func rRankNoPlay(_ sender: AnyObject) { mFilter.RankNoPlayrival = (sender as! UISwitch).isOn }
    @IBAction func rFcMFC(_ sender: AnyObject) { mFilter.FcMFCrival = (sender as! UISwitch).isOn }
    @IBAction func rFcPFC(_ sender: AnyObject) { mFilter.FcPFCrival = (sender as! UISwitch).isOn }
    @IBAction func rFcFC(_ sender: AnyObject) { mFilter.FcFCrival = (sender as! UISwitch).isOn }
    @IBAction func rFcGFC(_ sender: AnyObject) { mFilter.FcGFCrival = (sender as! UISwitch).isOn }
    @IBAction func rFcLife4(_ sender: AnyObject) { mFilter.FcLife4rival = (sender as! UISwitch).isOn }
    @IBAction func rFcNoFC(_ sender: AnyObject) { mFilter.FcNoFCrival = (sender as! UISwitch).isOn }
    @IBAction func rWin(_ sender: AnyObject) { mFilter.RivalWin = (sender as! UISwitch).isOn }
    @IBAction func rLose(_ sender: AnyObject) { mFilter.RivalLose = (sender as! UISwitch).isOn }
    @IBAction func rDraw(_ sender: AnyObject) { mFilter.RivalDraw = (sender as! UISwitch).isOn }
    @IBAction func rDeleted(_ sender: AnyObject) { mFilter.OthersDeleted = (sender as! UISwitch).isOn }

    // セルの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    //var mSPShockSelection: Int = 0
    //var mDPShockSelection: Int = 0
    
    // セルの内容を変更
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        cell.backgroundColor = UIColor(white: 0, alpha: 0.01)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = (indexPath as NSIndexPath).row == 0 ? NSLocalizedString("Only", comment: "ViewFilterSetting") : (indexPath as NSIndexPath).row == 1 ? NSLocalizedString("Include", comment: "ViewFilterSetting") : NSLocalizedString("Exclude", comment: "ViewFilterSetting")
        let cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor = UIColor.blue
        cell.selectedBackgroundView = cellSelectedBgView
        switch tableView {
        case shockArrowsExistsSP:
            let shock: Int = mFilter.ShockArrowSP == ShockArrowInclude.Only ? 0 : mFilter.ShockArrowSP == ShockArrowInclude.Include ? 1 : 2
            if shock == (indexPath as NSIndexPath).row {
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            }
            else {
                cell.accessoryType = UITableViewCell.AccessoryType.none
            }
        case shockArrowsExistsDP:
            let shock: Int = mFilter.ShockArrowDP == ShockArrowInclude.Only ? 0 : mFilter.ShockArrowDP == ShockArrowInclude.Include ? 1 : 2
            if shock == (indexPath as NSIndexPath).row {
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            }
            else {
                cell.accessoryType = UITableViewCell.AccessoryType.none
            }
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        switch tableView {
        case shockArrowsExistsSP:
            mFilter.ShockArrowSP = (indexPath as NSIndexPath).row == 0 ? ShockArrowInclude.Only : (indexPath as NSIndexPath).row == 1 ? ShockArrowInclude.Include : ShockArrowInclude.Exclude
        case shockArrowsExistsDP:
            mFilter.ShockArrowDP = (indexPath as NSIndexPath).row == 0 ? ShockArrowInclude.Only : (indexPath as NSIndexPath).row == 1 ? ShockArrowInclude.Include : ShockArrowInclude.Exclude
        default:
            break
        }
        if tableView == shockArrowsExistsSP || tableView == shockArrowsExistsDP {
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //navigationController?.navigationBarHidden = false
        setFilterData()
        Admob.shAdView(adHeight)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //navigationController?.navigationBarHidden = true
    }
    
    override func didMove(toParent parent: UIViewController?) {
        FileReader.saveFilter(rparam_FilterId, filter: mFilter)
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
        
        if let name = FileReader.readFilterName(rparam_FilterId) {
            mFilterName = name
        }
        else {
            let _ = navigationController?.popViewController(animated: true)
            return
        }
        
        if let filter = FileReader.readFilter(rparam_FilterId) {
            mFilter = filter
        }
        else {
            let _ = navigationController?.popViewController(animated: true)
            return
        }
        
        self.title = mFilterName
        adView.addSubview(Admob.getAdBannerView(self))

        scrollView.indicatorStyle = UIScrollView.IndicatorStyle.white
        scrollView.backgroundColor = UIColor(white: 0, alpha: 0.01)
        
        shockArrowsExistsSP.backgroundColor = UIColor(white: 0, alpha: 0.01)
        shockArrowsExistsSP.delegate = self
        shockArrowsExistsSP.dataSource = self
        
        shockArrowsExistsDP.backgroundColor = UIColor(white: 0, alpha: 0.01)
        shockArrowsExistsDP.delegate = self
        shockArrowsExistsDP.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
