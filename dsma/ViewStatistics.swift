//
//  ViewStatistics.swift
//  dsm
//
//  Created by LinaNfinE on 7/9/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewStatistics: UIViewController, UINavigationBarDelegate, UIBarPositioningDelegate, GADBannerViewDelegate {
    
    static func checkOut(_ title: String, scores: [Int32 : MusicScore], rivalScores: [Int32 : MusicScore], musics: [Int32 : MusicData], webMusicIds: [Int32 : WebMusicId], targets: [UniquePattern]) -> (ViewStatistics) {
        let storyboard = UIStoryboard(name: "ViewStatistics", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! ViewStatistics
        ret.rparam_Title = title
        ret.rparam_Targets = targets
        ret.rparam_Scores = scores
        ret.rparam_RivalScores = rivalScores
        ret.rparam_WebMusicIds = webMusicIds
        ret.rparam_MusicData = musics
        return ret
    }
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var naviTitle: UINavigationItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var scoreMax: UILabel!
    @IBOutlet weak var scoreMin: UILabel!
    @IBOutlet weak var scoreMedian: UILabel!
    @IBOutlet weak var scoreAverage: UILabel!
    @IBOutlet weak var scoreVariance: UILabel!
    
    @IBOutlet weak var danceLevelAAA: UILabel!
    @IBOutlet weak var danceLevelAAp: UILabel!
    @IBOutlet weak var danceLevelAA: UILabel!
    @IBOutlet weak var danceLevelAAm: UILabel!
    @IBOutlet weak var danceLevelAp: UILabel!
    @IBOutlet weak var danceLevelA: UILabel!
    @IBOutlet weak var danceLevelAm: UILabel!
    @IBOutlet weak var danceLevelBp: UILabel!
    @IBOutlet weak var danceLevelB: UILabel!
    @IBOutlet weak var danceLevelBm: UILabel!
    @IBOutlet weak var danceLevelCp: UILabel!
    @IBOutlet weak var danceLevelC: UILabel!
    @IBOutlet weak var danceLevelCm: UILabel!
    @IBOutlet weak var danceLevelDp: UILabel!
    @IBOutlet weak var danceLevelD: UILabel!
    @IBOutlet weak var danceLevelE: UILabel!
    @IBOutlet weak var danceLevelNoPlay: UILabel!
    
    @IBOutlet weak var fcMFC: UILabel!
    @IBOutlet weak var fcPFC: UILabel!
    @IBOutlet weak var fcGFC: UILabel!
    @IBOutlet weak var fcFC: UILabel!
    @IBOutlet weak var fcLife4: UILabel!
    @IBOutlet weak var fcNoFC: UILabel!
    
    @IBOutlet weak var diff1: UILabel!
    @IBOutlet weak var diff2: UILabel!
    @IBOutlet weak var diff3: UILabel!
    @IBOutlet weak var diff4: UILabel!
    @IBOutlet weak var diff5: UILabel!
    @IBOutlet weak var diff6: UILabel!
    @IBOutlet weak var diff7: UILabel!
    @IBOutlet weak var diff8: UILabel!
    @IBOutlet weak var diff9: UILabel!
    @IBOutlet weak var diff10: UILabel!
    @IBOutlet weak var diff11: UILabel!
    @IBOutlet weak var diff12: UILabel!
    @IBOutlet weak var diff13: UILabel!
    @IBOutlet weak var diff14: UILabel!
    @IBOutlet weak var diff15: UILabel!
    @IBOutlet weak var diff16: UILabel!
    @IBOutlet weak var diff17: UILabel!
    @IBOutlet weak var diff18: UILabel!
    @IBOutlet weak var diff19: UILabel!
    
    @IBOutlet weak var patbSP: UILabel!
    @IBOutlet weak var patBSP: UILabel!
    @IBOutlet weak var patDSP: UILabel!
    @IBOutlet weak var patESP: UILabel!
    @IBOutlet weak var patCSP: UILabel!
    @IBOutlet weak var patBDP: UILabel!
    @IBOutlet weak var patDDP: UILabel!
    @IBOutlet weak var patEDP: UILabel!
    @IBOutlet weak var patCDP: UILabel!
    
    @IBOutlet weak var ser1st: UILabel!
    @IBOutlet weak var ser2nd: UILabel!
    @IBOutlet weak var ser3rd: UILabel!
    @IBOutlet weak var ser4th: UILabel!
    @IBOutlet weak var ser5th: UILabel!
    @IBOutlet weak var serMAX: UILabel!
    @IBOutlet weak var serMAX2: UILabel!
    @IBOutlet weak var serEXTREME: UILabel!
    @IBOutlet weak var serSuperNOVA: UILabel!
    @IBOutlet weak var serSuperNOVA2: UILabel!
    @IBOutlet weak var serX: UILabel!
    @IBOutlet weak var serX2: UILabel!
    @IBOutlet weak var serX3: UILabel!
    @IBOutlet weak var ser2013: UILabel!
    @IBOutlet weak var ser2014: UILabel!
    @IBOutlet weak var serA: UILabel!
    @IBOutlet weak var serA20: UILabel!
    @IBOutlet weak var serA20PLUS: UILabel!
    @IBOutlet weak var serA3: UILabel!
    @IBOutlet weak var serWORLD: UILabel!
    
    @IBOutlet weak var serFlareRankEX: UILabel!
    @IBOutlet weak var serFlareRankIX: UILabel!
    @IBOutlet weak var serFlareRankVIII: UILabel!
    @IBOutlet weak var serFlareRankVII: UILabel!
    @IBOutlet weak var serFlareRankVI: UILabel!
    @IBOutlet weak var serFlareRankV: UILabel!
    @IBOutlet weak var serFlareRankIV: UILabel!
    @IBOutlet weak var serFlareRankIII: UILabel!
    @IBOutlet weak var serFlareRankII: UILabel!
    @IBOutlet weak var serFlareRankI: UILabel!
    @IBOutlet weak var serFlareRank0: UILabel!
    @IBOutlet weak var serFlareRankNoRank: UILabel!
    
    var rparam_Title: String!
    var rparam_Targets: [UniquePattern] = [UniquePattern]()
    var rparam_Scores: [Int32 : MusicScore]!
    var rparam_RivalScores: [Int32 : MusicScore]!
    var rparam_WebMusicIds: [Int32 : WebMusicId]!
    var rparam_MusicData: [Int32 : MusicData]!
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    @objc internal func stopButtonTouched(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        buttonStop = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(ViewStatistics.stopButtonTouched(_:)))
        let bl = [UIBarButtonItem](arrayLiteral: buttonStop)
        navigationBar.topItem?.leftBarButtonItems = bl
        Admob.shAdView(adHeight)
    }
    
    var buttonStop: UIBarButtonItem!
    
    @objc func applicationWillEnterForeground() {
        Admob.shAdView(adHeight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.setContentOffset(CGPoint(x:0, y:-scrollView.contentInset.top*2), animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let notifc: NotificationCenter = NotificationCenter.default
        notifc.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        
        naviTitle.title = rparam_Title
        adView.addSubview(Admob.getAdBannerView(self))

        navigationBar.delegate = self
        
        scrollView.indicatorStyle = UIScrollView.IndicatorStyle.white
        scrollView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        
        OperationQueue().addOperation({ () -> Void in
            
            var _scoreTotal: Int64 = 0
            var _scoreMax: Int32 = 0
            var _scoreMin: Int32 = 1000000
            var _danceLevelAAA: Int = 0
            var _danceLevelAAp: Int = 0
            var _danceLevelAA: Int = 0
            var _danceLevelAAm: Int = 0
            var _danceLevelAp: Int = 0
            var _danceLevelA: Int = 0
            var _danceLevelAm: Int = 0
            var _danceLevelBp: Int = 0
            var _danceLevelB: Int = 0
            var _danceLevelBm: Int = 0
            var _danceLevelCp: Int = 0
            var _danceLevelC: Int = 0
            var _danceLevelCm: Int = 0
            var _danceLevelDp: Int = 0
            var _danceLevelD: Int = 0
            var _danceLevelE: Int = 0
            var _danceLevelNoPlay: Int = 0
            var _fcTypeMFC: Int = 0
            var _fcTypePFC: Int = 0
            var _fcTypeGFC: Int = 0
            var _fcTypeFC: Int = 0
            var _fcTypeLife4: Int = 0
            var _fcTypeNoFC: Int = 0
            var _difficultides: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            var _patbSP: Int = 0
            var _patBSP: Int = 0
            var _patDSP: Int = 0
            var _patESP: Int = 0
            var _patCSP: Int = 0
            var _patBDP: Int = 0
            var _patDDP: Int = 0
            var _patEDP: Int = 0
            var _patCDP: Int = 0
            var _ser1st: Int = 0
            var _ser2nd: Int = 0
            var _ser3rd: Int = 0
            var _ser4th: Int = 0
            var _ser5th: Int = 0
            var _serMAX: Int = 0
            var _serMAX2: Int = 0
            var _serEXTREME: Int = 0
            var _serSuperNOVA: Int = 0
            var _serSuperNOVA2: Int = 0
            var _serX: Int = 0
            var _serX2: Int = 0
            var _serX3: Int = 0
            var _ser2013: Int = 0
            var _ser2014: Int = 0
            var _serA: Int = 0
            var _serA20: Int = 0
            var _serA20PLUS: Int = 0;
            var _serA3: Int = 0;
            var _serWORLD: Int = 0;
            
            var _flareRankCounts: [Int: Int] = [:]
            for i in -1...10 {
                _flareRankCounts[i] = 0
            }
            
            for target in self.rparam_Targets {
                if let pat = self.rparam_Scores[target.MusicId] {
                    if let mus = self.rparam_MusicData[target.MusicId] {
                        let score = PatternTypeLister.getScoreDataByPattern(pat, pattern: target.Pattern)
                        if score.Score > _scoreMax {
                            _scoreMax = score.Score
                        }
                        if score.Score < _scoreMin {
                            _scoreMin = score.Score
                        }
                        _scoreTotal += Int64(score.Score)
                        switch(score.Rank) {
                        case MusicRank.AAA:_danceLevelAAA += 1;break;
                        case MusicRank.AAp:_danceLevelAAp += 1;break;
                        case MusicRank.AA:_danceLevelAA += 1;break;
                        case MusicRank.AAm:_danceLevelAAm += 1;break;
                        case MusicRank.Ap:_danceLevelAp += 1;break;
                        case MusicRank.A:_danceLevelA += 1;break;
                        case MusicRank.Am:_danceLevelAm += 1;break;
                        case MusicRank.Bp:_danceLevelBp += 1;break;
                        case MusicRank.B:_danceLevelB += 1;break;
                        case MusicRank.Bm:_danceLevelBm += 1;break;
                        case MusicRank.Cp:_danceLevelCp += 1;break;
                        case MusicRank.C:_danceLevelC += 1;break;
                        case MusicRank.Cm:_danceLevelCm += 1;break;
                        case MusicRank.Dp:_danceLevelDp += 1;break;
                        case MusicRank.D:_danceLevelD += 1;break;
                        case MusicRank.E:_danceLevelE += 1;break;
                        case MusicRank.Noplay:_danceLevelNoPlay += 1;break;
                        }
                        switch(score.FullComboType_) {
                        case FullComboType.MarvelousFullCombo:_fcTypeMFC += 1;break;
                        case FullComboType.PerfectFullCombo:_fcTypePFC += 1;break;
                        case FullComboType.FullCombo:_fcTypeGFC += 1;break;
                        case FullComboType.GoodFullCombo:_fcTypeFC += 1;break;
                        case FullComboType.Life4:_fcTypeLife4 += 1;break;
                        case FullComboType.None:_fcTypeNoFC += 1;break;
                        }
                        _difficultides[Int(PatternTypeLister.getDifficultyDataByPattern(mus, pattern: target.Pattern))] += 1
                        switch(target.Pattern) {
                        case PatternType.bSP:_patbSP += 1
                        case PatternType.BSP:_patBSP += 1
                        case PatternType.DSP:_patDSP += 1
                        case PatternType.ESP:_patESP += 1
                        case PatternType.CSP:_patCSP += 1
                        case PatternType.BDP:_patBDP += 1
                        case PatternType.DDP:_patDDP += 1
                        case PatternType.EDP:_patEDP += 1
                        case PatternType.CDP:_patCDP += 1
                        }
                        switch(mus.SeriesTitle_) {
                        case SeriesTitle._1st:_ser1st += 1
                        case SeriesTitle._2nd:_ser2nd += 1
                        case SeriesTitle._3rd:_ser3rd += 1
                        case SeriesTitle._4th:_ser4th += 1
                        case SeriesTitle._5th:_ser5th += 1
                        case SeriesTitle.MAX:_serMAX += 1
                        case SeriesTitle.MAX2:_serMAX2 += 1
                        case SeriesTitle.EXTREME:_serEXTREME += 1
                        case SeriesTitle.SuperNOVA:_serSuperNOVA += 1
                        case SeriesTitle.SuperNOVA2:_serSuperNOVA2 += 1
                        case SeriesTitle.X:_serX += 1
                        case SeriesTitle.X2:_serX2 += 1
                        case SeriesTitle.X3:_serX3 += 1
                        case SeriesTitle._2013:_ser2013 += 1
                        case SeriesTitle._2014:_ser2014 += 1
                        case SeriesTitle.A:_serA += 1
                        case SeriesTitle.A20:_serA20 += 1
                        case SeriesTitle.A20PLUS:_serA20PLUS += 1
                        case SeriesTitle.A3:_serA3 += 1
                        case SeriesTitle.WORLD: _serWORLD += 1
                        default:break
                        }
                        _flareRankCounts[Int(score.flareRank), default: 0] += 1
                    }
                }
            }
            
            let ms = MusicSort(musics: self.rparam_MusicData, scores: self.rparam_Scores, rivalScores: self.rparam_RivalScores, webMusicIds: self.rparam_WebMusicIds)
            ms._1stType = MusicSortType.Score
            self.rparam_Targets.sort { m, p in return ms.compare(m, plusUniquePattern: p) }
            
            let average = Double(_scoreTotal)/Double(self.rparam_Targets.count)
            
            var median: Int32 = 0
            let target = self.rparam_Targets[self.rparam_Targets.count/2]
            if let pat = self.rparam_Scores[target.MusicId] {
                median = PatternTypeLister.getScoreDataByPattern(pat, pattern: target.Pattern).Score
            }
            var varTotal: Double = 0
            for target in self.rparam_Targets {
                if let pat = self.rparam_Scores[target.MusicId] {
                    let score = PatternTypeLister.getScoreDataByPattern(pat, pattern: target.Pattern)
                    let sub = Double(score.Score)-average
                    varTotal += pow(sub, 2.0)
                }
            }
            let variance = sqrt(varTotal/Double(self.rparam_Targets.count))
            
            DispatchQueue.main.async(execute: {
                
                self.scoreMax.text = StringUtil.toCommaFormattedString(_scoreMax)
                self.scoreMin.text = StringUtil.toCommaFormattedString(_scoreMin)
                self.scoreAverage.text = StringUtil.toCommaFormattedString(Int32(average))
                self.scoreMedian.text = StringUtil.toCommaFormattedString(median)
                self.scoreVariance.text = StringUtil.toCommaFormattedString(Int32(variance))
                
                self.danceLevelAAA.text = _danceLevelAAA.description
                self.danceLevelAAp.text = _danceLevelAAp.description
                self.danceLevelAA.text = _danceLevelAA.description
                self.danceLevelAAm.text = _danceLevelAAm.description
                self.danceLevelAp.text = _danceLevelAp.description
                self.danceLevelA.text = _danceLevelA.description
                self.danceLevelAm.text = _danceLevelAm.description
                self.danceLevelBp.text = _danceLevelBp.description
                self.danceLevelB.text = _danceLevelB.description
                self.danceLevelBm.text = _danceLevelBm.description
                self.danceLevelCp.text = _danceLevelCp.description
                self.danceLevelC.text = _danceLevelC.description
                self.danceLevelCm.text = _danceLevelCm.description
                self.danceLevelDp.text = _danceLevelDp.description
                self.danceLevelD.text = _danceLevelD.description
                self.danceLevelE.text = _danceLevelE.description
                self.danceLevelNoPlay.text = _danceLevelNoPlay.description
                
                self.fcMFC.text = _fcTypeMFC.description
                self.fcPFC.text = _fcTypePFC.description
                self.fcGFC.text = _fcTypeGFC.description
                self.fcFC.text = _fcTypeFC.description
                self.fcLife4.text = _fcTypeLife4.description
                self.fcNoFC.text = _fcTypeNoFC.description
                
                self.diff1.text = _difficultides[1].description
                self.diff2.text = _difficultides[2].description
                self.diff3.text = _difficultides[3].description
                self.diff4.text = _difficultides[4].description
                self.diff5.text = _difficultides[5].description
                self.diff6.text = _difficultides[6].description
                self.diff7.text = _difficultides[7].description
                self.diff8.text = _difficultides[8].description
                self.diff9.text = _difficultides[9].description
                self.diff10.text = _difficultides[10].description
                self.diff11.text = _difficultides[11].description
                self.diff12.text = _difficultides[12].description
                self.diff13.text = _difficultides[13].description
                self.diff14.text = _difficultides[14].description
                self.diff15.text = _difficultides[15].description
                self.diff16.text = _difficultides[16].description
                self.diff17.text = _difficultides[17].description
                self.diff18.text = _difficultides[18].description
                self.diff19.text = _difficultides[19].description
                
                self.patbSP.text = _patbSP.description
                self.patBSP.text = _patBSP.description
                self.patDSP.text = _patDSP.description
                self.patESP.text = _patESP.description
                self.patCSP.text = _patCSP.description
                self.patBDP.text = _patBDP.description
                self.patDDP.text = _patDDP.description
                self.patEDP.text = _patEDP.description
                self.patCDP.text = _patCDP.description
                
                self.ser1st.text = _ser1st.description
                self.ser2nd.text = _ser2nd.description
                self.ser3rd.text = _ser3rd.description
                self.ser4th.text = _ser4th.description
                self.ser5th.text = _ser5th.description
                self.serMAX.text = _serMAX.description
                self.serMAX2.text = _serMAX2.description
                self.serEXTREME.text = _serEXTREME.description
                self.serSuperNOVA.text = _serSuperNOVA.description
                self.serSuperNOVA2.text = _serSuperNOVA2.description
                self.serX.text = _serX.description
                self.serX2.text = _serX2.description
                self.serX3.text = _serX3.description
                self.ser2013.text = _ser2013.description
                self.ser2014.text = _ser2014.description
                self.serA.text = _serA.description
                self.serA20.text = _serA20.description
                self.serA20PLUS.text = _serA20PLUS.description
                self.serA3.text = _serA3.description
                self.serWORLD.text = _serWORLD.description
                
                self.serFlareRankEX.text = _flareRankCounts[10]?.description ?? "0"
                self.serFlareRankIX.text = _flareRankCounts[9]?.description ?? "0"
                self.serFlareRankVIII.text = _flareRankCounts[8]?.description ?? "0"
                self.serFlareRankVII.text = _flareRankCounts[7]?.description ?? "0"
                self.serFlareRankVI.text = _flareRankCounts[6]?.description ?? "0"
                self.serFlareRankV.text = _flareRankCounts[5]?.description ?? "0"
                self.serFlareRankIV.text = _flareRankCounts[4]?.description ?? "0"
                self.serFlareRankIII.text = _flareRankCounts[3]?.description ?? "0"
                self.serFlareRankII.text = _flareRankCounts[2]?.description ?? "0"
                self.serFlareRankI.text = _flareRankCounts[1]?.description ?? "0"
                self.serFlareRank0.text = _flareRankCounts[0]?.description ?? "0"
                self.serFlareRankNoRank.text = _flareRankCounts[-1]?.description ?? "0"
                
                self.indicator.stopAnimating()
            })
        })
    }
}
