//
//  ViewDirectEdit.swift
//  dsm
//
//  Created by LinaNfinE on 6/26/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewDirectEdit: UIViewController, UIAlertViewDelegate, UINavigationBarDelegate, UIBarPositioningDelegate, GADBannerViewDelegate {
    
    static func checkOut(_ parentView: ViewScoreList, musics: [Int32 : MusicData], target: UniquePattern, rivalData: RivalData?) -> (ViewDirectEdit) {
        let storyboard = UIStoryboard(name: "ViewDirectEdit", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! ViewDirectEdit
        ret.rparam_ParentView = parentView
        ret.rparam_MusicData = musics
        ret.rparam_Target = target
        if rivalData != nil {
            ret.rparam_RivalData = rivalData!.Id == "" || rivalData!.Id == "00000000" ? nil : rivalData
        }
        return ret
    }
    
    var rparam_Target: UniquePattern!
    var rparam_RivalData: RivalData!
    var rparam_MusicData: [Int32 : MusicData]!
    var rparam_ParentView: ViewScoreList!
    
    var mMusicData: MusicData!
    var mScoreData: ScoreData        /////// When using "!", mScoreData receive "nil" value from MusicScore. Why????
    var mRivalScoreData: ScoreData        /////// When using "!", mScoreData receive "nil" value from MusicScore. Why????
    
    var currentDifficulty: Int32 = 0
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelPattern: UILabel!
    @IBOutlet weak var lineHorizontal: UIView!
    @IBOutlet weak var lineSP: UIView!
    @IBOutlet weak var lineDP1: UIView!
    @IBOutlet weak var lineDP2: UIView!
    
    @IBOutlet weak var rivalView: UIView!
    @IBOutlet weak var rivalName: UILabel!
    @IBOutlet weak var btnRivalState: UIButton!
    @IBOutlet weak var labelRivalScore: UILabel!
    @IBOutlet weak var labelRivalCombo: UILabel!
    @IBOutlet weak var labelRivalPlay: UILabel!
    @IBOutlet weak var labelRivalClear: UILabel!
    
    @IBOutlet weak var btnState: UIButton!
    @IBOutlet weak var btnFlareRank: UIButton!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var labelCombo: UILabel!
    @IBOutlet weak var labelPlay: UILabel!
    @IBOutlet weak var labelClear: UILabel!
    
    func setRank() {
        var dataRank: MusicRank;
        let dataScore = mScoreData.Score;
        if(dataScore < 550000)
        {
            dataRank = MusicRank.D;
        }
        else if(dataScore < 590000)
        {
            dataRank = MusicRank.Dp;
        }
        else if(dataScore < 600000)
        {
            dataRank = MusicRank.Cm;
        }
        else if(dataScore < 650000)
        {
            dataRank = MusicRank.C;
        }
        else if(dataScore < 690000)
        {
            dataRank = MusicRank.Cp;
        }
        else if(dataScore < 700000)
        {
            dataRank = MusicRank.Bm;
        }
        else if(dataScore < 750000)
        {
            dataRank = MusicRank.B;
        }
        else if(dataScore < 790000)
        {
            dataRank = MusicRank.Bp;
        }
        else if(dataScore < 800000)
        {
            dataRank = MusicRank.Am;
        }
        else if(dataScore < 850000)
        {
            dataRank = MusicRank.A;
        }
        else if(dataScore < 890000)
        {
            dataRank = MusicRank.Ap;
        }
        else if(dataScore < 900000)
        {
            dataRank = MusicRank.AAm;
        }
        else if(dataScore < 950000)
        {
            dataRank = MusicRank.AA;
        }
        else if(dataScore < 990000)
        {
            dataRank = MusicRank.AAp;
        }
        else
        {
            dataRank = MusicRank.AAA;
        }
        mScoreData.Rank = dataRank
    }
    
    func setRivalRank() {
        var dataRank: MusicRank;
        let dataScore = mRivalScoreData.Score;
        if(dataScore < 550000)
        {
            dataRank = MusicRank.D;
        }
        else if(dataScore < 590000)
        {
            dataRank = MusicRank.Dp;
        }
        else if(dataScore < 600000)
        {
            dataRank = MusicRank.Cm;
        }
        else if(dataScore < 650000)
        {
            dataRank = MusicRank.C;
        }
        else if(dataScore < 690000)
        {
            dataRank = MusicRank.Cp;
        }
        else if(dataScore < 700000)
        {
            dataRank = MusicRank.Bm;
        }
        else if(dataScore < 750000)
        {
            dataRank = MusicRank.B;
        }
        else if(dataScore < 790000)
        {
            dataRank = MusicRank.Bp;
        }
        else if(dataScore < 800000)
        {
            dataRank = MusicRank.Am;
        }
        else if(dataScore < 850000)
        {
            dataRank = MusicRank.A;
        }
        else if(dataScore < 890000)
        {
            dataRank = MusicRank.Ap;
        }
        else if(dataScore < 900000)
        {
            dataRank = MusicRank.AAm;
        }
        else if(dataScore < 950000)
        {
            dataRank = MusicRank.AA;
        }
        else if(dataScore < 990000)
        {
            dataRank = MusicRank.AAp;
        }
        else
        {
            dataRank = MusicRank.AAA;
        }
        mRivalScoreData.Rank = dataRank
    }
    
    func setState(_ stateNo: Int) {
        switch stateNo {
        case 0:
            mScoreData.FullComboType_ = FullComboType.MarvelousFullCombo
            setRank()
            btnState.setTitle("Marvelous Full Combo", for: UIControl.State())
        case 1:
            mScoreData.FullComboType_ = FullComboType.PerfectFullCombo
            setRank()
            btnState.setTitle("Perfect Full Combo", for: UIControl.State())
        case 2:
            mScoreData.FullComboType_ = FullComboType.FullCombo
            setRank()
            btnState.setTitle("Full Combo", for: UIControl.State())
        case 3:
            mScoreData.FullComboType_ = FullComboType.GoodFullCombo
            setRank()
            btnState.setTitle("Good Full Combo", for: UIControl.State())
        case 4:
            mScoreData.FullComboType_ = FullComboType.Life4
            setRank()
            btnState.setTitle("Life4 Clear", for: UIControl.State())
        case 5:
            mScoreData.FullComboType_ = FullComboType.None
            setRank()
            btnState.setTitle("Clear", for: UIControl.State())
        case 6:
            mScoreData.FullComboType_ = FullComboType.None
            mScoreData.Rank = MusicRank.E
            btnState.setTitle("RankE", for: UIControl.State())
        case 7:
            mScoreData.FullComboType_ = FullComboType.None
            mScoreData.Rank = MusicRank.Noplay
            btnState.setTitle("NoPlay", for: UIControl.State())
        default:
            break
        }
    }
    
    func setRivalState(_ stateNo: Int) {
        switch stateNo {
        case 0:
            mRivalScoreData.FullComboType_ = FullComboType.MarvelousFullCombo
            setRivalRank()
            btnRivalState.setTitle("Marvelous Full Combo", for: UIControl.State())
        case 1:
            mRivalScoreData.FullComboType_ = FullComboType.PerfectFullCombo
            setRivalRank()
            btnRivalState.setTitle("Perfect Full Combo", for: UIControl.State())
        case 2:
            mRivalScoreData.FullComboType_ = FullComboType.FullCombo
            setRivalRank()
            btnRivalState.setTitle("Full Combo", for: UIControl.State())
        case 3:
            mRivalScoreData.FullComboType_ = FullComboType.GoodFullCombo
            setRivalRank()
            btnRivalState.setTitle("Good Full Combo", for: UIControl.State())
        case 4:
            mRivalScoreData.FullComboType_ = FullComboType.Life4
            setRivalRank()
            btnRivalState.setTitle("Life4 Clear", for: UIControl.State())
        case 5:
            mRivalScoreData.FullComboType_ = FullComboType.None
            setRivalRank()
            btnRivalState.setTitle("Clear", for: UIControl.State())
        case 6:
            mRivalScoreData.FullComboType_ = FullComboType.None
            mRivalScoreData.Rank = MusicRank.E
            btnRivalState.setTitle("RankE", for: UIControl.State())
        case 7:
            mRivalScoreData.FullComboType_ = FullComboType.None
            mRivalScoreData.Rank = MusicRank.Noplay
            btnRivalState.setTitle("NoPlay", for: UIControl.State())
        default:
            break
        }
    }
    
    @IBAction func stateTouchUpInside(_ sender: AnyObject) {
        var ccs = 7
        if(mScoreData.FullComboType_ == FullComboType.MarvelousFullCombo)
        {
            ccs = 0
        }
        else if(mScoreData.FullComboType_ == FullComboType.PerfectFullCombo)
        {
            ccs = 1
        }
        else if(mScoreData.FullComboType_ == FullComboType.FullCombo)
        {
            ccs = 2
        }
        else if(mScoreData.FullComboType_ == FullComboType.GoodFullCombo)
        {
            ccs = 3
        }
        else if(mScoreData.FullComboType_ == FullComboType.Life4)
        {
            ccs = 4
        }
        else if(mScoreData.FullComboType_ == FullComboType.None)
        {
            if(mScoreData.Rank == MusicRank.Noplay)
            {
                ccs = 7
            }
            else if(mScoreData.Rank == MusicRank.E)
            {
                ccs = 6
            }
            else
            {
                ccs = 5
            }
        }
        present(ViewClearStateList.checkOut(self, currentClearState: ccs, isRival: false), animated: true, completion: nil)
    }
    
    @IBAction func flareRankTouchUpInside(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Select Flare Rank", message: nil, preferredStyle: .actionSheet)
        
        for rank in FlareRank.allCases {
            alert.addAction(UIAlertAction(title: rank.displayText, style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.mScoreData.flareRank = Int32(rank.rawValue)
                self.updateFlareSkill()  // フレアランク変更時にフレアスキルを更新
                self.setScoreData()  // UI更新
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    var mTextAlertView: TextAlertView!
    @IBAction func scoreTouchUpInside(_ sender: AnyObject) {
        mTextAlertView = TextAlertView(title: NSLocalizedString("Score", comment: "ViewDirectEdit"), message: NSLocalizedString("Input score and press OK.", comment: "ViewDirectEdit"), placeholder: "1000000",defaultText: mScoreData.Score.description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
            if let num = Int(text) {
                self.mScoreData.Score = Int32(min(1000000, max(0, num)))
                self.setScoreData()
            }
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }
    @IBAction func comboTouchUpInside(_ sender: AnyObject) {
        mTextAlertView = TextAlertView(title: NSLocalizedString("Max Combo", comment: "ViewDirectEdit"), message: NSLocalizedString("Input max combo and press OK.", comment: "ViewDirectEdit"), placeholder: "123",defaultText: mScoreData.MaxCombo.description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
            if let num = Int(text) {
                self.mScoreData.MaxCombo = Int32(min(9999, max(0, num)))
                self.setScoreData()
            }
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }
    @IBAction func playOutchUpInside(_ sender: AnyObject) {
        mTextAlertView = TextAlertView(title: NSLocalizedString("Play Count", comment: "ViewDirectEdit"), message: NSLocalizedString("Input play count and press OK.", comment: "ViewDirectEdit"), placeholder: "123",defaultText: mScoreData.PlayCount.description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
            if let num = Int(text) {
                self.mScoreData.PlayCount = Int32(min(9999, max(0, num)))
                self.setScoreData()
            }
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }
    @IBAction func clearTouchUpInside(_ sender: AnyObject) {
        mTextAlertView = TextAlertView(title: NSLocalizedString("Clear Count", comment: "ViewDirectEdit"), message: NSLocalizedString("Input clear count and press OK.", comment: "ViewDirectEdit"), placeholder: "123",defaultText: mScoreData.ClearCount.description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
            if let num = Int(text) {
                self.mScoreData.ClearCount = Int32(min(9999, max(0, num)))
                self.setScoreData()
            }
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }
    @IBAction func resetTouchUpInside(_ sender: AnyObject) {
        mScoreData = ScoreData()
        setScoreData()
    }
    
    @IBAction func stateRivalTouchUpInside(_ sender: AnyObject) {
        var ccs = 7
        if(mRivalScoreData.FullComboType_ == FullComboType.MarvelousFullCombo)
        {
            ccs = 0
        }
        else if(mRivalScoreData.FullComboType_ == FullComboType.PerfectFullCombo)
        {
            ccs = 1
        }
        else if(mRivalScoreData.FullComboType_ == FullComboType.FullCombo)
        {
            ccs = 2
        }
        else if(mRivalScoreData.FullComboType_ == FullComboType.GoodFullCombo)
        {
            ccs = 3
        }
        else if(mRivalScoreData.FullComboType_ == FullComboType.Life4)
        {
            ccs = 4
        }
        else if(mRivalScoreData.FullComboType_ == FullComboType.None)
        {
            if(mRivalScoreData.Rank == MusicRank.Noplay)
            {
                ccs = 7
            }
            else if(mRivalScoreData.Rank == MusicRank.E)
            {
                ccs = 6
            }
            else
            {
                ccs = 5
            }
        }
        present(ViewClearStateList.checkOut(self, currentClearState: ccs, isRival: true), animated: true, completion: nil)
    }
    @IBAction func scoreRivalTouchUpInside(_ sender: AnyObject) {
        mTextAlertView = TextAlertView(title: NSLocalizedString("Score", comment: "ViewDirectEdit"), message: NSLocalizedString("Input rival score and press OK.", comment: "ViewDirectEdit"), placeholder: "1000000",defaultText: mRivalScoreData.Score.description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
            if let num = Int(text) {
                self.mRivalScoreData.Score = Int32(min(1000000, max(0, num)))
                self.setScoreData()
            }
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }
    @IBAction func comboRivalTouchUpInside(_ sender: AnyObject) {
        mTextAlertView = TextAlertView(title: NSLocalizedString("Max Combo", comment: "ViewDirectEdit"), message: NSLocalizedString("Input rival max combo and press OK.", comment: "ViewDirectEdit"), placeholder: "123",defaultText: mRivalScoreData.MaxCombo.description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
            if let num = Int(text) {
                self.mRivalScoreData.MaxCombo = Int32(min(9999, max(0, num)))
                self.setScoreData()
            }
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }
    @IBAction func playRivalOutchUpInside(_ sender: AnyObject) {
        mTextAlertView = TextAlertView(title: NSLocalizedString("Play Count", comment: "ViewDirectEdit"), message: NSLocalizedString("Input rival play count and press OK.", comment: "ViewDirectEdit"), placeholder: "123",defaultText: mRivalScoreData.PlayCount.description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
            if let num = Int(text) {
                self.mRivalScoreData.PlayCount = Int32(min(9999, max(0, num)))
                self.setScoreData()
            }
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }
    @IBAction func clearRivalTouchUpInside(_ sender: AnyObject) {
        mTextAlertView = TextAlertView(title: NSLocalizedString("Clear Count", comment: "ViewDirectEdit"), message: NSLocalizedString("Input rival clear count and press OK.", comment: "ViewDirectEdit"), placeholder: "123",defaultText: mRivalScoreData.ClearCount.description, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
            if let num = Int(text) {
                self.mRivalScoreData.ClearCount = Int32(min(9999, max(0, num)))
                self.setScoreData()
            }
        }), cancelAction: nil)
        mTextAlertView.show(self)
    }
    @IBAction func resetRivalTouchUpInside(_ sender: AnyObject) {
        mRivalScoreData = ScoreData()
        setScoreData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        mScoreData = ScoreData()
        mRivalScoreData = ScoreData()
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        mScoreData = ScoreData()
        mRivalScoreData = ScoreData()
        super.init(nibName: nil, bundle: nil)
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    func setScoreData() {
        labelScore.text = StringUtil.toCommaFormattedString(mScoreData.Score)
        labelCombo.text = mScoreData.MaxCombo.description
        labelPlay.text = mScoreData.PlayCount.description
        labelClear.text = mScoreData.ClearCount.description
        var state = 7
        if(mScoreData.FullComboType_ == FullComboType.MarvelousFullCombo)
        {
            state = 0
        }
        else if(mScoreData.FullComboType_ == FullComboType.PerfectFullCombo)
        {
            state = 1
        }
        else if(mScoreData.FullComboType_ == FullComboType.FullCombo)
        {
            state = 2
        }
        else if(mScoreData.FullComboType_ == FullComboType.GoodFullCombo)
        {
            state = 3
        }
        else if(mScoreData.FullComboType_ == FullComboType.Life4)
        {
            state = 4
        }
        else if(mScoreData.FullComboType_ == FullComboType.None)
        {
            if(mScoreData.Rank == MusicRank.Noplay)
            {
                state = 7
            }
            else if(mScoreData.Rank == MusicRank.E)
            {
                state = 6
            }
            else
            {
                state = 5
            }
        }
        setState(state)
        
        let flareRank = FlareRank(rawValue: Int(mScoreData.flareRank)) ?? .noRank
        btnFlareRank.setTitle(flareRank.displayText, for: .normal)
        
        rivalName.text = rparam_RivalData?.Name
        labelRivalScore.text = StringUtil.toCommaFormattedString(mRivalScoreData.Score)
        labelRivalCombo.text = mRivalScoreData.MaxCombo.description
        labelRivalPlay.text = mRivalScoreData.PlayCount.description
        labelRivalClear.text = mRivalScoreData.ClearCount.description
        var rstate = 7
        if(mRivalScoreData.FullComboType_ == FullComboType.MarvelousFullCombo)
        {
            rstate = 0
        }
        else if(mRivalScoreData.FullComboType_ == FullComboType.PerfectFullCombo)
        {
            rstate = 1
        }
        else if(mRivalScoreData.FullComboType_ == FullComboType.FullCombo)
        {
            rstate = 2
        }
        else if(mRivalScoreData.FullComboType_ == FullComboType.GoodFullCombo)
        {
            rstate = 3
        }
        else if(mRivalScoreData.FullComboType_ == FullComboType.Life4)
        {
            rstate = 4
        }
        else if(mRivalScoreData.FullComboType_ == FullComboType.None)
        {
            if(mRivalScoreData.Rank == MusicRank.Noplay)
            {
                rstate = 7
            }
            else if(mRivalScoreData.Rank == MusicRank.E)
            {
                rstate = 6
            }
            else
            {
                rstate = 5
            }
        }
        setRivalState(rstate)
        
        labelTitle.text = mMusicData.Name
        switch rparam_Target.Pattern {
        case PatternType.bSP:
            labelPattern.text = "SINGLE BEGINNER"
            lineHorizontal.backgroundColor = UIColor.cyan
            lineSP.backgroundColor = UIColor.cyan
            lineDP1.backgroundColor = UIColor.clear
            lineDP2.backgroundColor = UIColor.clear
        case PatternType.BSP:
            labelPattern.text = "SINGLE BASIC"
            lineHorizontal.backgroundColor = UIColor.orange
            lineSP.backgroundColor = UIColor.orange
            lineDP1.backgroundColor = UIColor.clear
            lineDP2.backgroundColor = UIColor.clear
        case PatternType.DSP:
            labelPattern.text = "SINGLE DIFFICULT"
            lineHorizontal.backgroundColor = UIColor.red
            lineSP.backgroundColor = UIColor.red
            lineDP1.backgroundColor = UIColor.clear
            lineDP2.backgroundColor = UIColor.clear
        case PatternType.ESP:
            labelPattern.text = "SINGLE EXPERT"
            lineHorizontal.backgroundColor = UIColor.green
            lineSP.backgroundColor = UIColor.green
            lineDP1.backgroundColor = UIColor.clear
            lineDP2.backgroundColor = UIColor.clear
        case PatternType.CSP:
            labelPattern.text = "SINGLE CHALLENGE"
            lineHorizontal.backgroundColor = UIColor.magenta
            lineSP.backgroundColor = UIColor.magenta
            lineDP1.backgroundColor = UIColor.clear
            lineDP2.backgroundColor = UIColor.clear
        case PatternType.BDP:
            labelPattern.text = "DOUBLE BASIC"
            lineHorizontal.backgroundColor = UIColor.orange
            lineSP.backgroundColor = UIColor.clear
            lineDP1.backgroundColor = UIColor.orange
            lineDP2.backgroundColor = UIColor.orange
        case PatternType.DDP:
            labelPattern.text = "DOUBLE DIFFICULT"
            lineHorizontal.backgroundColor = UIColor.red
            lineSP.backgroundColor = UIColor.clear
            lineDP1.backgroundColor = UIColor.red
            lineDP2.backgroundColor = UIColor.red
        case PatternType.EDP:
            labelPattern.text = "DOUBLE EXPERT"
            lineHorizontal.backgroundColor = UIColor.green
            lineSP.backgroundColor = UIColor.clear
            lineDP1.backgroundColor = UIColor.green
            lineDP2.backgroundColor = UIColor.green
        case PatternType.CDP:
            labelPattern.text = "DOUBLE CHALLENGE"
            lineHorizontal.backgroundColor = UIColor.magenta
            lineSP.backgroundColor = UIColor.clear
            lineDP1.backgroundColor = UIColor.magenta
            lineDP2.backgroundColor = UIColor.magenta
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let bb = [UIBarButtonItem](arrayLiteral: buttonSave)
        navigationBar.topItem?.rightBarButtonItems = bb
        let bl = [UIBarButtonItem](arrayLiteral: buttonCancel)
        navigationBar.topItem?.leftBarButtonItems = bl
        Admob.shAdView(adHeight)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    @objc internal func saveButtonTouched(_ sender: UIButton) {
        var sl = FileReader.readScoreList(nil)
        var ms: MusicScore
        if let m = sl[rparam_Target.MusicId] {
            ms = m
        }
        else {
            ms = MusicScore()
        }
        switch rparam_Target.Pattern {
        case PatternType.bSP:
            ms.bSP = mScoreData
        case PatternType.BSP:
            ms.BSP = mScoreData
        case PatternType.DSP:
            ms.DSP = mScoreData
        case PatternType.ESP:
            ms.ESP = mScoreData
        case PatternType.CSP:
            ms.CSP = mScoreData
        case PatternType.BDP:
            ms.BDP = mScoreData
        case PatternType.DDP:
            ms.DDP = mScoreData
        case PatternType.EDP:
            ms.EDP = mScoreData
        case PatternType.CDP:
            ms.CDP = mScoreData
        }
        sl[rparam_Target.MusicId] = ms
        let _ = FileReader.saveScoreList(nil, scores: sl)
        if rparam_RivalData != nil {
            var slr = FileReader.readScoreList(rparam_RivalData.Id)
            var ms: MusicScore
            if let m = slr[rparam_Target.MusicId] {
                ms = m
            }
            else {
                ms = MusicScore()
            }
            switch rparam_Target.Pattern {
            case PatternType.bSP:
                ms.bSP = mRivalScoreData
            case PatternType.BSP:
                ms.BSP = mRivalScoreData
            case PatternType.DSP:
                ms.DSP = mRivalScoreData
            case PatternType.ESP:
                ms.ESP = mRivalScoreData
            case PatternType.CSP:
                ms.CSP = mRivalScoreData
            case PatternType.BDP:
                ms.BDP = mRivalScoreData
            case PatternType.DDP:
                ms.DDP = mRivalScoreData
            case PatternType.EDP:
                ms.EDP = mRivalScoreData
            case PatternType.CDP:
                ms.CDP = mRivalScoreData
            }
            slr[rparam_Target.MusicId] = ms
            let _ = FileReader.saveScoreList(rparam_RivalData.Id, scores: slr)
        }
        rparam_ParentView.refreshAll()
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc internal func cancelButtonTouched(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    var buttonSave: UIBarButtonItem!
    var buttonCancel: UIBarButtonItem!
    
    @objc func applicationWillEnterForeground() {
        Admob.shAdView(adHeight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let notifc: NotificationCenter = NotificationCenter.default
        notifc.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        
        buttonSave = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(ViewDirectEdit.saveButtonTouched(_:)))
        buttonCancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(ViewDirectEdit.cancelButtonTouched(_:)))
        
        self.title = "Direct Edit"
        adView.addSubview(Admob.getAdBannerView(self))
        
        let nvFrame: CGRect = navigationBar.frame;
        var sai = CGFloat(0)
        if #available(iOS 11.0, *) {
            sai = view.safeAreaInsets.top
        }
        scrollView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height + sai, left: 0, bottom: 0, right: 0)
        navigationBar.delegate = self
        
        scrollView.indicatorStyle = UIScrollView.IndicatorStyle.white
        scrollView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        
        mMusicData = rparam_MusicData[rparam_Target.MusicId]
        let sl = FileReader.readScoreList(nil)
        if let score = sl[rparam_Target.MusicId] {
            switch rparam_Target.Pattern {
            case PatternType.bSP:
                mScoreData = score.bSP
            case PatternType.BSP:
                mScoreData = score.BSP
            case PatternType.DSP:
                mScoreData = score.DSP
            case PatternType.ESP:
                mScoreData = score.ESP
            case PatternType.CSP:
                mScoreData = score.CSP
            case PatternType.BDP:
                mScoreData = score.BDP
            case PatternType.DDP:
                mScoreData = score.DDP
            case PatternType.EDP:
                mScoreData = score.EDP
            case PatternType.CDP:
                mScoreData = score.CDP
            }
        }
        else {
            mScoreData = ScoreData()
        }
        if rparam_RivalData != nil {
            let slr = FileReader.readScoreList(rparam_RivalData.Id)
            if let score = slr[rparam_Target.MusicId] {
                switch rparam_Target.Pattern {
                case PatternType.bSP:
                    mRivalScoreData = score.bSP
                case PatternType.BSP:
                    mRivalScoreData = score.BSP
                case PatternType.DSP:
                    mRivalScoreData = score.DSP
                case PatternType.ESP:
                    mRivalScoreData = score.ESP
                case PatternType.CSP:
                    mRivalScoreData = score.CSP
                case PatternType.BDP:
                    mRivalScoreData = score.BDP
                case PatternType.DDP:
                    mRivalScoreData = score.DDP
                case PatternType.EDP:
                    mRivalScoreData = score.EDP
                case PatternType.CDP:
                    mRivalScoreData = score.CDP
                }
            }
            else {
                mRivalScoreData = ScoreData()
            }
        }
        else {
            rivalView.isHidden = true
        }
        
        setScoreData()
        setCurrentDifficulty()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCurrentDifficulty() {
        switch rparam_Target.Pattern {
        case .bSP: currentDifficulty = mMusicData.Difficulty_bSP
        case .BSP: currentDifficulty = mMusicData.Difficulty_BSP
        case .DSP: currentDifficulty = mMusicData.Difficulty_DSP
        case .ESP: currentDifficulty = mMusicData.Difficulty_ESP
        case .CSP: currentDifficulty = mMusicData.Difficulty_CSP
        case .BDP: currentDifficulty = mMusicData.Difficulty_BDP
        case .DDP: currentDifficulty = mMusicData.Difficulty_DDP
        case .EDP: currentDifficulty = mMusicData.Difficulty_EDP
        case .CDP: currentDifficulty = mMusicData.Difficulty_CDP
        }
    }
    
    private func updateFlareSkill() {
        mScoreData.updateFlareSkill(songDifficulty: currentDifficulty)
    }
}
