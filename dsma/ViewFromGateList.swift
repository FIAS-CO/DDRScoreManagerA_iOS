//
//  ViewFromGateList.swift
//  dsm
//
//  Created by LinaNfinE on 7/2/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds

class ViewFromGateList: UIViewController, UINavigationBarDelegate, UIBarPositioningDelegate, UIWebViewDelegate, WKNavigationDelegate, UITableViewDataSource, UITableViewDelegate, LoginViewOpener, GADBannerViewDelegate {
    
    static func checkOut(_ parentView: ViewScoreList?, rivalId: String?, rivalName: String?, processPool: WKProcessPool) -> (ViewFromGateList) {
        let storyboard = UIStoryboard(name: "ViewFromGateList", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! ViewFromGateList
        ret.rparam_ParentView = parentView
        ret.rparam_RivalId = rivalId
        ret.rparam_RivalName = rivalName
        ret.rparam_ProcessPool = processPool
        return ret
    }
    
    var rparam_ParentView: ViewScoreList!
    var rparam_RivalId: String!
    var rparam_RivalName: String!
    var rparam_ProcessPool: WKProcessPool!
    
    var sparam_ParentView: LoginViewOpener!
    
    var mPreferences: Preferences       /////// When using "!", mPreferences set nil. Why????
    var mUriH: String!
    var mUriF: String!
    var mWebMusicIds: [Int32 : WebMusicId]!
    var mScoreList: [Int32 : MusicScore]!
    var mLocalIds: [String : Int32]!
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    var wkWebView: WKWebView!
    
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
    
    func addLog(_ text: String) {
        logText.append(text)
        OperationQueue().addOperation({ () -> Void in
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
                // Why tableView.frame.height & tableView.contentInset.top not found????
                let lh = Double(self.logText.count * 12)
                let thr = self.tableView.frame
                let th = Double(thr.height)
                let tci = self.tableView.contentInset
                let tcit = Double(tci.top)
                var ths = Double(0)
                if #available(iOS 11.0, *) {
                    ths = Double(self.view.safeAreaInsets.top)
                }
                if lh > th - ths - tcit {
                    self.tableView.setContentOffset(CGPoint(x: 0, y:lh - th), animated: true)
                }
            })
        })
    }
    
    func resume() {
        mWait = false
    }
    
    func retry() {
        addLog(NSLocalizedString("Logged in.", comment: "ViewFromGateList"))
        mRetry = true
        resume()
    }
    
    func cancel() {
        addLog(NSLocalizedString("Canceling...", comment: "ViewFromGateList"))
        mCancel = true
        resume()
    }
    
    var logText: [String] = []
    
    // セルの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logText.count
    }
    
    // セルの内容を変更
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        cell.backgroundColor = UIColor(white: 0, alpha: 0.01)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell.textLabel?.minimumScaleFactor = 0.5
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = logText[(indexPath as NSIndexPath).row]
        let cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor = UIColor.blue
        cell.selectedBackgroundView = cellSelectedBgView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 12
    }
    
    @objc internal func cancelButtonTouched(_ sender: UIButton) {
        addLog(NSLocalizedString("Canceling...", comment: "ViewFromGateList"))
        mCancel = true
        mPause = false
        mWait = false
        buttonCancel.isEnabled = false
        let bl = [UIBarButtonItem](arrayLiteral: buttonCancel)
        navigationBar.topItem?.leftBarButtonItems = bl
        buttonResume.isEnabled = false
        let bb = [UIBarButtonItem](arrayLiteral: buttonResume)
        navigationBar.topItem?.rightBarButtonItems = bb
    }
    
    @objc internal func doneButtonTouched(_ sender: UIButton) {
        self.rparam_ParentView?.refreshAll()
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc internal func pauseButtonTouched(_ sender: UIButton) {
        mPause = true
        let bb = [UIBarButtonItem](arrayLiteral: buttonResume)
        navigationBar.topItem?.rightBarButtonItems = bb
        addLog(NSLocalizedString("Paused.", comment: "ViewFromGateList"))
    }
    
    @objc internal func resumeButtonTouched(_ sender: UIButton) {
        mPause = false
        let bb = [UIBarButtonItem](arrayLiteral: buttonPause)
        navigationBar.topItem?.rightBarButtonItems = bb
        addLog(NSLocalizedString("Resumed.", comment: "ViewFromGateList"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        buttonCancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(ViewFromGateList.cancelButtonTouched(_:)))
        buttonResume = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.play, target: self, action: #selector(ViewFromGateList.resumeButtonTouched(_:)))
        buttonPause = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.pause, target: self, action: #selector(ViewFromGateList.pauseButtonTouched(_:)))
        buttonDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(ViewFromGateList.doneButtonTouched(_:)))
        let bl = [UIBarButtonItem](arrayLiteral: buttonCancel)
        navigationBar.topItem?.leftBarButtonItems = bl
        let bb = [UIBarButtonItem](arrayLiteral: buttonPause)
        navigationBar.topItem?.rightBarButtonItems = bb
    }
    
    var buttonCancel: UIBarButtonItem!
    var buttonDone: UIBarButtonItem!
    var buttonPause: UIBarButtonItem!
    var buttonResume: UIBarButtonItem!
    
    func analyzeScore(_ src: String) -> (Bool) {
        if (self.mPreferences.Gate_LoadFromNewSite) {
            do {
                let (gameMode, musicEntries) = try HtmlParseUtil.parseMusicList(src: src)
                var scoreExists = false
                
                for entry in musicEntries {
                    guard let mi = mLocalIds[entry.musicName] else {
                        print(entry.musicName + "has no data")
                        continue
                    }
                    let musicIdSaved = mi
                    
                    var musicScore = mScoreList[musicIdSaved] ?? MusicScore()
                    
                    for score in entry.scores {
                        var newScoreData = ScoreData()
                        newScoreData.Score = Int32(score.score)
                        newScoreData.Rank = score.rank
                        newScoreData.FullComboType_ = score.fullComboType
                        newScoreData.flareRank = Int32(score.flareRank)
                        
                        let oldScoreData = getScoreDataForDifficulty(musicScore: musicScore, diffId: score.difficultyId, gameMode: gameMode)
                        updateScoreData(sd: &newScoreData, msd: oldScoreData)
                        
                        setScoreDataForDifficulty(musicScore: &musicScore, diffId: score.difficultyId, scoreData: newScoreData, gameMode: gameMode)
                        scoreExists = true
                    }
                    
                    mScoreList[musicIdSaved] = musicScore
                }
                
                if scoreExists {
                    let _ = FileReader.saveScoreList(rparam_RivalId, scores: mScoreList)
                }
                
                return true
            } catch {
                print("Error parsing HTML: \(error)")
                return false
            }
        } else {
            var idDiffEnd: String;
            if rparam_RivalId == nil {
                idDiffEnd = "\"";
            }
            else {
                idDiffEnd = "&";
            }
            let musicBlockStartText = "<tr class=\"data\">";
            let musicBlockEndText = "</tr>";
            var titleLinkText = "/p/playdata/music_detail.html?index=";
            if rparam_RivalId != nil {
                titleLinkText = "/p/rival/music_detail.html?index=";
            }
            let patternBlockStartText = "<td class=\"rank\" id=\"";
            let patternBlockEndText = "</td>";
            
            var parsingText = src;
            var scoreExists = false;
            while let rs = parsingText.range(of: musicBlockStartText) {
                parsingText = String(parsingText[rs.upperBound...])
                var musicBlock: String
                if let rs = parsingText.range(of: musicBlockEndText) {
                    musicBlock = String(parsingText[..<rs.lowerBound])
                    parsingText = String(parsingText[rs.upperBound...]);
                }
                else {
                    break
                }
                
                var idText: String
                var musicName: String
                
                if let rs = musicBlock.range(of: titleLinkText) {
                    idText = String(musicBlock[rs.upperBound...]);
                    musicBlock = String(musicBlock[rs.lowerBound...]);
                    if let rs = idText.range(of: idDiffEnd) {
                        idText = String(idText[..<rs.lowerBound]);
                    }
                    else {
                        continue
                    }
                }
                else {
                    continue
                }
                if let rs = musicBlock.range(of: ">") {
                    musicName = String(musicBlock[musicBlock.index(rs.lowerBound, offsetBy: 1)...]);
                    if let rs = musicName.range(of: "</") {
                        musicName = musicName[..<rs.lowerBound].trimmingCharacters(in: CharacterSet.whitespaces);
                    }
                    else {
                        continue
                    }
                }
                else {
                    continue
                }
                var musicIdSaved: Int32
                if let li = mLocalIds[musicName] {
                    musicIdSaved = li
                }
                else {
                    continue
                }
                
                var ms: MusicScore;
                if let sl = mScoreList[musicIdSaved] {
                    ms = sl;
                }
                else {
                    ms = MusicScore();
                }
                
                while let rs = musicBlock.range(of: patternBlockStartText) {
                    var sd = ScoreData();
                    var diff: Int32
                    
                    let patternLinkText = titleLinkText+idText+"&amp;diff=";
                    var patternBlock: String
                    
                    musicBlock = String(musicBlock[rs.lowerBound...]);
                    
                    if let rs = musicBlock.range(of: patternBlockEndText) {
                        patternBlock = String(musicBlock[..<rs.lowerBound]);
                        musicBlock = String(musicBlock[rs.lowerBound...]);
                    }
                    else {
                        break
                    }
                    
                    if let rs = patternBlock.range(of: patternLinkText) {
                        patternBlock = String(patternBlock[rs.upperBound...]);
                    }
                    else {
                        break
                    }
                    
                    var diffText: String
                    if let rs = patternBlock.range(of: idDiffEnd) {
                        diffText = String(patternBlock[..<rs.lowerBound]);
                        if let num = Int(diffText) {
                            diff = Int32(num);
                        }
                        else {
                            continue
                        }
                    }
                    else {
                        continue
                    }
                    
                    if let rs = patternBlock.range(of: ">") {
                        patternBlock = String(patternBlock[patternBlock.index(rs.lowerBound, offsetBy: 1)...])
                    }
                    if let _ = patternBlock.range(of: "full_none") {
                        sd.FullComboType_ = FullComboType.None;
                    }
                    else if let _ = patternBlock.range(of: "full_good") {
                        sd.FullComboType_ = FullComboType.GoodFullCombo;
                    }
                    else if let _ = patternBlock.range(of: "full_great") {
                        sd.FullComboType_ = FullComboType.FullCombo;
                    }
                    else if let _ = patternBlock.range(of: "full_perfect") {
                        sd.FullComboType_ = FullComboType.PerfectFullCombo;
                    }
                    else if let _ = patternBlock.range(of: "full_mar") {
                        sd.FullComboType_ = FullComboType.MarvelousFullCombo;
                    }
                    if let _ = patternBlock.range(of: "rank_s_none") {
                        sd.Score = 0;
                        sd.Rank = MusicRank.Noplay;
                    }
                    else {
                        let scoreText = patternBlock.replacingOccurrences(of: "<.*?>", with: "", options: NSString.CompareOptions.regularExpression, range: nil);
                        
                        if let num = Int(scoreText) {
                            sd.Score = Int32(num);
                        }
                        else {
                            continue
                        }
                        if let _ = patternBlock.range(of: "rank_s_e") {
                            sd.Rank = MusicRank.E;
                        }
                        else if(sd.Score < 550000) {
                            sd.Rank = MusicRank.D;
                        }
                        else if(sd.Score < 590000) {
                            sd.Rank = MusicRank.Dp;
                        }
                        else if(sd.Score < 600000) {
                            sd.Rank = MusicRank.Cm;
                        }
                        else if(sd.Score < 650000) {
                            sd.Rank = MusicRank.C;
                        }
                        else if(sd.Score < 690000) {
                            sd.Rank = MusicRank.Cp;
                        }
                        else if(sd.Score < 700000) {
                            sd.Rank = MusicRank.Bm;
                        }
                        else if(sd.Score < 750000) {
                            sd.Rank = MusicRank.B;
                        }
                        else if(sd.Score < 790000) {
                            sd.Rank = MusicRank.Bp;
                        }
                        else if(sd.Score < 800000) {
                            sd.Rank = MusicRank.Am;
                        }
                        else if(sd.Score < 850000) {
                            sd.Rank = MusicRank.A;
                        }
                        else if(sd.Score < 890000) {
                            sd.Rank = MusicRank.Ap;
                        }
                        else if(sd.Score < 900000) {
                            sd.Rank = MusicRank.AAm;
                        }
                        else if(sd.Score < 950000) {
                            sd.Rank = MusicRank.AA;
                        }
                        else if(sd.Score < 990000) {
                            sd.Rank = MusicRank.AAp;
                        }
                        else {
                            sd.Rank = MusicRank.AAA;
                        }
                    }
                    
                    var msd: ScoreData;
                    switch(diff) {
                    case 0:
                        msd = ms.bSP;
                    case 1:
                        msd = ms.BSP;
                    case 2:
                        msd = ms.DSP;
                    case 3:
                        msd = ms.ESP;
                    case 4:
                        msd = ms.CSP;
                    case 5:
                        msd = ms.BDP;
                    case 6:
                        msd = ms.DDP;
                    case 7:
                        msd = ms.EDP;
                    case 8:
                        msd = ms.CDP;
                    default:
                        msd = ScoreData();
                    }
                    sd.MaxCombo = msd.MaxCombo;
                    sd.ClearCount = msd.ClearCount;
                    sd.PlayCount = msd.PlayCount;
                    
                    // 「Life4 に未フルコンを上書きする」 が無効
                    if !mPreferences.Gate_OverWriteLife4 {
                        // 取得した値が未フルコン
                        if(sd.FullComboType_ == FullComboType.None) {
                            // 元の値が Life4
                            if(msd.FullComboType_ == FullComboType.Life4) {
                                // 元のフルコンタイプに戻す
                                sd.FullComboType_ = msd.FullComboType_;
                            }
                        }
                    }
                    // 「低いスコアを上書き」 が無効
                    if !mPreferences.Gate_OverWriteLowerScores {
                        // スコアが低かったら
                        if(sd.Score < msd.Score) {
                            // スコアを元に戻す
                            sd.Score = msd.Score;
                            sd.Rank = msd.Rank;
                        }
                        // コンボが低かったら
                        if(sd.MaxCombo < msd.MaxCombo) {
                            // コンボを元に戻す
                            sd.MaxCombo = msd.MaxCombo;
                        }
                        // 元の値がMFC
                        if(msd.FullComboType_ == FullComboType.MarvelousFullCombo)
                        {
                            // MFCにする
                            sd.FullComboType_ = msd.FullComboType_;
                        }
                        // 元の値がPFC
                        else if(msd.FullComboType_ == FullComboType.PerfectFullCombo)
                        {
                            // 取得した値がMFCでない
                            if(sd.FullComboType_ != FullComboType.MarvelousFullCombo)
                            {
                                // PFCにする
                                sd.FullComboType_ = msd.FullComboType_;
                            }
                        }
                        // 元の値がFC
                        else if(msd.FullComboType_ == FullComboType.FullCombo)
                        {
                            // 取得した値がMFCでもPFCでもない
                            if(sd.FullComboType_ != FullComboType.MarvelousFullCombo && sd.FullComboType_ != FullComboType.PerfectFullCombo)
                            {
                                // FCにする
                                sd.FullComboType_ = msd.FullComboType_;
                            }
                        }
                        // 元の値がGFC
                        else if(msd.FullComboType_ == FullComboType.GoodFullCombo)
                        {
                            // 取得した値がMFCでもPFCでもFCでもない
                            if(sd.FullComboType_ != FullComboType.MarvelousFullCombo && sd.FullComboType_ != FullComboType.PerfectFullCombo && sd.FullComboType_ != FullComboType.FullCombo)
                            {
                                // GFCにする
                                sd.FullComboType_ = msd.FullComboType_;
                            }
                        }
                        // 元の値がその他
                        else
                        {
                            // 取得した値がMFCでもPFCでもFCでもGFCでもない
                            if(sd.FullComboType_ != FullComboType.MarvelousFullCombo && sd.FullComboType_ != FullComboType.PerfectFullCombo && sd.FullComboType_ != FullComboType.FullCombo && sd.FullComboType_ != FullComboType.GoodFullCombo)
                            {
                                // 元の値にもどす
                                sd.FullComboType_ = msd.FullComboType_;
                            }
                        }
                    }
                    
                    // Revisit: 公式サイトからフレアランクが取得できるようになったら上に移動
                    // フレアランク関連
                    if msd.flareRank > sd.flareRank {
                        sd.flareRank = msd.flareRank
                    }
                    
                    switch(diff) {
                    case 0:
                        ms.bSP = sd;
                    case 1:
                        ms.BSP = sd;
                    case 2:
                        ms.DSP = sd;
                    case 3:
                        ms.ESP = sd;
                    case 4:
                        ms.CSP = sd;
                    case 5:
                        ms.BDP = sd;
                    case 6:
                        ms.DDP = sd;
                    case 7:
                        ms.EDP = sd;
                    case 8:
                        ms.CDP = sd;
                    default:
                        break
                    }
                    mScoreList[musicIdSaved] = ms;
                    scoreExists = true;
                    
                }
            }
            
            if(!scoreExists) {
                return true;
            }
            
            let _ = FileReader.saveScoreList(rparam_RivalId, scores: mScoreList)
            
            return true
        }
    }
    
    private func getScoreDataForDifficulty(musicScore: MusicScore, diffId: String, gameMode: GameMode) -> ScoreData {
        switch gameMode {
        case .single:
            switch diffId {
            case "beginner": return musicScore.bSP
            case "basic": return musicScore.BSP
            case "difficult": return musicScore.DSP
            case "expert": return musicScore.ESP
            case "challenge": return musicScore.CSP
            default: return ScoreData()
            }
        case .double:
            switch diffId {
            case "basic": return musicScore.BDP
            case "difficult": return musicScore.DDP
            case "expert": return musicScore.EDP
            case "challenge": return musicScore.CDP
            default: return ScoreData()
            }
        }
    }
    
    private func setScoreDataForDifficulty(musicScore: inout MusicScore, diffId: String, scoreData: ScoreData, gameMode: GameMode) {
        switch gameMode {
        case .single:
            switch diffId {
            case "beginner": musicScore.bSP = scoreData
            case "basic": musicScore.BSP = scoreData
            case "difficult": musicScore.DSP = scoreData
            case "expert": musicScore.ESP = scoreData
            case "challenge": musicScore.CSP = scoreData
            default: break
            }
        case .double:
            switch diffId {
            case "basic": musicScore.BDP = scoreData
            case "difficult": musicScore.DDP = scoreData
            case "expert": musicScore.EDP = scoreData
            case "challenge": musicScore.CDP = scoreData
            default: break
            }
        }
    }
    
    private func updateScoreData(sd: inout ScoreData, msd: ScoreData) {
        // 「Life4 に未フルコンを上書きする」 が無効
        if !mPreferences.Gate_OverWriteLife4 {
            if sd.FullComboType_ == .None && msd.FullComboType_ == .Life4 {
                sd.FullComboType_ = msd.FullComboType_
            }
        }
        
        // 「低いスコアを上書き」 が無効
        if !mPreferences.Gate_OverWriteLowerScores {
            if sd.Score < msd.Score {
                sd.Score = msd.Score
                sd.Rank = msd.Rank
            }
            if sd.MaxCombo < msd.MaxCombo {
                sd.MaxCombo = msd.MaxCombo
            }
            sd.FullComboType_ = maxFullComboType(sd.FullComboType_, msd.FullComboType_)
            
            // フレアランク関連
            if sd.flareRank < msd.flareRank {
                sd.flareRank = msd.flareRank
            }
        }
        
        sd.MaxCombo = msd.MaxCombo
        sd.ClearCount = msd.ClearCount
        sd.PlayCount = msd.PlayCount
    }
    
    private func maxFullComboType(_ a: FullComboType, _ b: FullComboType) -> FullComboType {
        let order: [FullComboType] = [.None, .Life4, .GoodFullCombo, .FullCombo, .PerfectFullCombo, .MarvelousFullCombo]
        if let indexA = order.firstIndex(of: a), let indexB = order.firstIndex(of: b) {
            return indexA >= indexB ? a : b
        }
        return a // デフォルトとして、最初の引数を返す
    }
    
    func countStringInString(_ target: String, searchWord: String) -> (Int) {
        return (target.count - target.replacingOccurrences(of: searchWord, with: "", options: [], range: nil).count) / searchWord.count;
    }
    
    func getPageCount(_ src: String) -> (Int) {
        let cmpStartPagerBox = "<div id=\"paging_box\">";
        let cmpEndPagerBox = "<div class=\"arrow\"";
        let cmpPangeNum = "<div class=\"page_num\"";
        
        if let rs = src.range(of: cmpStartPagerBox) {
            var dr = String(src[rs.upperBound...])
            if let rs = dr.range(of: cmpEndPagerBox) {
                dr = String(dr[..<rs.lowerBound])
                return countStringInString(dr, searchWord: cmpPangeNum);
            }
        }
        return 0;
    }
    
    func didFinishLoad(_ url: String, html: String) {
        if self.mCancel {
            return;
        }
        if self.mPageCount == 1 {
            self.mPageCount = self.getPageCount(html)
            if self.mPageCount == 0 {
                switch StringUtil.checkLoggedIn(html) {
                case 1:
                    self.mPageCount = 1
                    DispatchQueue.main.async(execute: {
                        self.addLog(NSLocalizedString("Opening login form...", comment: "ViewFromGateList"))
                        self.present(ViewGateLogin.checkOut(self, errorCheck: true, processPool: self.rparam_ProcessPool), animated: true, completion: nil)
                    })
                    return
                default:
                    DispatchQueue.main.async(execute: {
                        self.addLog(NSLocalizedString("ERROR!!! : Retrying...", comment: "ViewFromGateList"))
                    })
                    self.mPageCount = 1
                    self.mRetry = true
                    self.mWait = false
                    return
                }
            }
        }
        let res = analyzeScore(html)
        if res {
            DispatchQueue.main.async(execute: {
                self.addLog(NSLocalizedString("Done.", comment: "ViewFromGateList"))
            })
            self.mWait = false
            self.mRetryCount = 3
            self.mRetry = false
        }
        else {
            DispatchQueue.main.async(execute: {
                self.addLog(NSLocalizedString("ERROR!!! : Retrying...", comment: "ViewFromGateList"))
            })
            self.mWait = false
            self.mRetry = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Admob.shAdView(adHeight)
    }
    
    var mRetryCount: Int = 3
    var mRetry: Bool = false
    var mWait: Bool = false
    var mPause: Bool = false
    var mCancel: Bool = false
    var mWebMusicId: WebMusicId!
    var mPageCount = 1
    
    @objc func applicationWillEnterForeground() {
        Admob.shAdView(adHeight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let notifc: NotificationCenter = NotificationCenter.default
        notifc.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        
        adView.addSubview(Admob.getAdBannerView(self))
        
        let nvFrame: CGRect = navigationBar.frame;
        tableView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height, left: 0, bottom: 0, right: 0)
        navigationBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.indicatorStyle = UIScrollView.IndicatorStyle.white
        tableView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        
        let configuration = WKWebViewConfiguration()
        configuration.processPool = rparam_ProcessPool
        wkWebView = WKWebView(frame: CGRect.zero, configuration: configuration)
        wkWebView.navigationDelegate = self
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        wkWebView.scrollView.indicatorStyle = UIScrollView.IndicatorStyle.white
        wkWebView.scrollView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        wkWebView.scrollView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height, left: 0, bottom: 0, right: 0)
        navigationBar.delegate = self
        self.view.addSubview(wkWebView)
        
        addLog(NSLocalizedString("Target: ", comment: "ViewFromGateList") + (rparam_RivalId == nil ? NSLocalizedString("My scores.", comment: "ViewFromGateList") : (rparam_RivalName + " (" + rparam_RivalId + ")" )))
        
        mPreferences = FileReader.readPreferences()
        mWebMusicIds = FileReader.readWebMusicIds()
        mScoreList = FileReader.readScoreList(rparam_RivalId)
        mLocalIds = FileReader.readWebTitleToLocalIdList()
        
        let versionName = self.mPreferences.Gate_LoadFromNewSite ? " WORLD" : " A3"
        addLog(NSLocalizedString("Version: ", comment: "ViewFromGateList") + versionName)
        addLog(NSLocalizedString("Loading scores started.", comment: "ViewFromGateList"))
        
        OperationQueue().addOperation({ () -> Void in
            
            sleep(3)
            
            for i in 0 ..< 1000000 {
                
                repeat {
                    self.mWait = true
                    DispatchQueue.main.async(execute: {
                        self.addLog("SP : " + (i+1).description + " / " + (self.mPageCount == 1 ? "?" : self.mPageCount.description) + "\r\n")
                        self.mUriH = "https://p.eagate.573.jp/game/ddr/"
                        if self.mPreferences.Gate_LoadFromNewSite{
                            self.mUriH += "ddrworld/"
                        }
                        else{
                            self.mUriH += "ddra3/p/"
                        }
                        if self.rparam_RivalId == nil {
                            self.mUriH += "playdata/music_data_single.html?offset=";
                            self.mUriF = "";
                        }
                        else {
                            self.mUriH += "rival/rival_musicdata_single.html?offset=";
                            self.mUriF = "&rival_id=" + self.rparam_RivalId;
                        }
                        let url: URL = URL(string: (self.mUriH+i.description+self.mUriF))!
                        let request: URLRequest = URLRequest(url: url)
                        self.wkWebView.load(request)
                    })
                    while (self.mWait || self.mPause) && !self.mCancel {
                        sleep(1)
                    }
                    sleep(3)
                    if self.mCancel {
                        DispatchQueue.main.async(execute: {
                            self.addLog(NSLocalizedString("Canceled.", comment: "ViewFromGateList"))
                        })
                        break
                    }
                    self.mRetryCount -= 1
                    if self.mRetryCount <= 0 {
                        DispatchQueue.main.async(execute: {
                            self.addLog(NSLocalizedString("Paused in 3 time errors.", comment: "ViewFromGateList"))
                            let bb = [UIBarButtonItem](arrayLiteral: self.buttonResume)
                            self.navigationBar.topItem?.rightBarButtonItems = bb
                        })
                        self.mPause = true
                        while self.mPause {
                            sleep(1)
                        }
                        self.mRetryCount = 3
                    }
                    if self.mCancel {
                        DispatchQueue.main.async(execute: {
                            self.addLog(NSLocalizedString("Canceled.", comment: "ViewFromGateList"))
                        })
                        break
                    }
                } while self.mRetry
                self.mRetryCount = 3
                if self.mCancel {
                    DispatchQueue.main.async(execute: {
                        self.rparam_ParentView?.refreshAll()
                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                    })
                    return
                }
                if i + 1 >= self.mPageCount {
                    break
                }
            }
            
            self.mPageCount = 1
            for i in 0 ..< 1000000 {
                repeat {
                    self.mWait = true
                    DispatchQueue.main.async(execute: {
                        self.addLog("DP : " + (i+1).description + " / " + (self.mPageCount == 1 ? "?" : self.mPageCount.description) + "\r\n")
                        self.mUriH = "https://p.eagate.573.jp/game/ddr/"
                        if self.mPreferences.Gate_LoadFromNewSite{
                            self.mUriH += "ddrworld/"
                        }
                        else{
                            self.mUriH += "ddra3/p/"
                        }
                        if self.rparam_RivalId == nil {
                            self.mUriH += "playdata/music_data_double.html?offset=";
                            self.mUriF = "";
                        }
                        else {
                            self.mUriH += "rival/rival_musicdata_double.html?offset=";
                            self.mUriF = "&rival_id=" + self.rparam_RivalId;
                        }
                        let url: URL = URL(string: (self.mUriH+i.description+self.mUriF))!
                        let request: URLRequest = URLRequest(url: url)
                        self.wkWebView.load(request)
                    })
                    while (self.mWait || self.mPause)  && !self.mCancel {
                        sleep(1)
                    }
                    sleep(3)
                    self.mRetryCount -= 1
                    if self.mRetryCount <= 0 {
                        DispatchQueue.main.async(execute: {
                            self.addLog(NSLocalizedString("Paused in 3 time errors.", comment: "ViewFromGateList"))
                        })
                        self.mPause = true
                        let bb = [UIBarButtonItem](arrayLiteral: self.buttonResume)
                        self.navigationBar.topItem?.rightBarButtonItems = bb
                        while self.mPause {
                            sleep(1)
                        }
                        self.mRetryCount = 3
                    }
                    if self.mCancel {
                        DispatchQueue.main.async(execute: {
                            self.addLog(NSLocalizedString("Canceled.", comment: "ViewFromGateList"))
                        })
                        break
                    }
                } while self.mRetry
                if self.mCancel {
                    sleep(3)
                    DispatchQueue.main.async(execute: {
                        self.rparam_ParentView?.refreshAll()
                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                    })
                    return
                }
                if i + 1 >= self.mPageCount {
                    break
                }
            }
            DispatchQueue.main.async(execute: {
                self.addLog(NSLocalizedString("Finished.", comment: "ViewFromGateList"))
            })
            DispatchQueue.main.async(execute: {
                let bl = [UIBarButtonItem]()
                self.navigationBar.topItem?.leftBarButtonItems = bl
                let bb = [UIBarButtonItem](arrayLiteral: self.buttonDone)
                self.navigationBar.topItem?.rightBarButtonItems = bb
            })
        })
    }
    
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        wkWebView.evaluateJavaScript("document.getElementsByTagName('html')[0].outerHTML", completionHandler: {(html, error) -> Void in
            self.didFinishLoad(String(describing: self.wkWebView.url), html: String(describing: html))
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
