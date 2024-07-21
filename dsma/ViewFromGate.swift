//
//  ViewFromGate.swift
//  dsm
//
//  Created by LinaNfinE on 6/29/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds

class ViewFromGate: UIViewController, UINavigationBarDelegate, UIBarPositioningDelegate, UIWebViewDelegate, WKNavigationDelegate, UITableViewDataSource, UITableViewDelegate, LoginViewOpener, GADBannerViewDelegate {
    
    static func checkOut(_ parentView: ViewScoreList?, musics: [Int32 : MusicData], targets: [UniquePattern]?, rivalId: String?, rivalName: String?, processPool: WKProcessPool) -> (ViewFromGate) {
        let storyboard = UIStoryboard(name: "ViewFromGate", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! ViewFromGate
        ret.rparam_ParentView = parentView
        ret.rparam_MusicData = musics
        ret.rparam_Targets = targets
        ret.rparam_RivalId = rivalId
        ret.rparam_RivalName = rivalName
        ret.rparam_ProcessPool = processPool
        return ret
    }
    
    var rparam_ParentView: ViewScoreList!
    var rparam_MusicData: [Int32 : MusicData]!
    var rparam_Targets: [UniquePattern]!
    var rparam_RivalId: String!
    var rparam_RivalName: String!
    var rparam_ProcessPool: WKProcessPool!
    
    var sparam_ParentView: LoginViewOpener!
    
    var mPreferences: Preferences       /////// When using "!", mPreferences set nil. Why????
    var mRequestUri: String!
    var mWebMusicIds: [Int32 : WebMusicId]!
    var mScoreList: [Int32 : MusicScore]!
    
    var mTarget: UniquePattern!
    
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
    
    func resume() {
        mWait = false
    }
    
    func retry() {
        addLog(NSLocalizedString("Logged in.", comment: "ViewFromGate"))
        mRetry = true
        resume()
    }
    
    func cancel() {
        addLog(NSLocalizedString("Canceling...", comment: "ViewFromGate"))
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 12
    }
    
    @objc internal func cancelButtonTouched(_ sender: UIButton) {
        self.addLog(NSLocalizedString("Canceling...", comment: "ViewFromGate"))
        mCancel = true
        mWait = false
        mPause = false
        buttonCancel.isEnabled = false
        let bl = [UIBarButtonItem](arrayLiteral: buttonCancel)
        navigationBar.topItem?.leftBarButtonItems = bl
        buttonResume.isEnabled = false
        let bb = [UIBarButtonItem](arrayLiteral: buttonResume)
        navigationBar.topItem?.rightBarButtonItems = bb
    }
    
    @objc internal func doneButtonTouched(_ sender: UIButton) {
        self.rparam_ParentView?.refreshAll()
        if self.rparam_RivalId == nil || self.rparam_RivalId == "" {
        }
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc internal func pauseButtonTouched(_ sender: UIButton) {
        mPause = true
        let bb = [UIBarButtonItem](arrayLiteral: buttonResume)
        navigationBar.topItem?.rightBarButtonItems = bb
        addLog(NSLocalizedString("Paused.", comment: "ViewFromGate"))
    }
    
    @objc internal func resumeButtonTouched(_ sender: UIButton) {
        mPause = false
        let bb = [UIBarButtonItem](arrayLiteral: buttonPause)
        navigationBar.topItem?.rightBarButtonItems = bb
        addLog(NSLocalizedString("Resumed.", comment: "ViewFromGate"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        buttonCancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(self.cancelButtonTouched(_:)))
        buttonPause = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.pause, target: self, action: #selector(self.pauseButtonTouched(_:)))
        buttonResume = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.play, target: self, action: #selector(self.resumeButtonTouched(_:)))
        buttonDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneButtonTouched(_:)))
        let bl = [UIBarButtonItem](arrayLiteral: buttonCancel)
        navigationBar.topItem?.leftBarButtonItems = bl
        let bb = [UIBarButtonItem](arrayLiteral: buttonPause)
        navigationBar.topItem?.rightBarButtonItems = bb
    }
    
    var buttonCancel: UIBarButtonItem!
    var buttonDone: UIBarButtonItem!
    var buttonPause: UIBarButtonItem!
    var buttonResume: UIBarButtonItem!
    
    func analyzeScore(_ srcHtml: String) -> (Bool) {
        var sd = ScoreData();
        let src = srcHtml;
        var cmp: String = "0\"></td>  <td>";
        if let rs = src.range(of: cmp) {
            var dr = String(src[rs.upperBound...])
            cmp = "<br>";
            if let rs = dr.range(of: cmp) {
                dr = String(dr[..<rs.lowerBound]).trimmingCharacters(in: CharacterSet.whitespaces)
                dr = StringUtilLng.escapeWebMusicTitle(src: dr)
                if dr != mWebMusicId.titleOnWebPage {
                    self.addLog(NSLocalizedString("Music ID is different on GATE server.", comment: "ViewFromGate"))
                    self.addLog(NSLocalizedString("Please report to us.", comment: "ViewFromGate"))
                    self.addLog(mWebMusicId.titleOnWebPage)
                    self.addLog("↓")
                    self.addLog(dr)
                    self.addLog(NSLocalizedString("Skipped.", comment: "ViewFromGate"))
                    return true;
                }
            }
            else {
                return false;
            }
        }
        else {
            return false;
        }
        cmp = "NO PLAY...";
        print("1")
        if src.range(of: cmp) == nil {
            if(self.mPreferences.Gate_LoadFromA3)
            {
                cmp = "<th>ハイスコア時のランク</th><td>";
            }
            else {
                if rparam_RivalId == nil {
                    cmp = "<th>ハイスコア時のダンスレベル</th><td>";
                }
                else {
                    cmp = "<th>最高ダンスレベル</th><td>";
                }
            }
            print("2")
            if let rs = src.range(of: cmp) {
                print("2.5")
                var dr = String(src[rs.upperBound...])
                cmp = "</td>";
                if let rs = dr.range(of: cmp) {
                    print("2.6")
                    dr = String(dr[..<rs.lowerBound])
                    if dr == "AAA" {
                        sd.Rank = MusicRank.AAA;
                    }
                    else if dr == "AA+" {
                        sd.Rank = MusicRank.AAp;
                    }
                    else if dr == "AA" {
                        sd.Rank = MusicRank.AA;
                    }
                    else if dr == "AA-" {
                        sd.Rank = MusicRank.AAm;
                    }
                    else if dr == "A+" {
                        sd.Rank = MusicRank.Ap;
                    }
                    else if dr == "A" {
                        sd.Rank = MusicRank.A;
                    }
                    else if dr == "A-" {
                        sd.Rank = MusicRank.Am;
                    }
                    else if dr == "B+" {
                        sd.Rank = MusicRank.Bp;
                    }
                    else if dr == "B" {
                        sd.Rank = MusicRank.B;
                    }
                    else if dr == "B-" {
                        sd.Rank = MusicRank.Bm;
                    }
                    else if dr == "C+" {
                        sd.Rank = MusicRank.Cp;
                    }
                    else if dr == "C" {
                        sd.Rank = MusicRank.C;
                    }
                    else if dr == "C-" {
                        sd.Rank = MusicRank.Cm;
                    }
                    else if dr == "D+" {
                        sd.Rank = MusicRank.Dp;
                    }
                    else if dr == "D" {
                        sd.Rank = MusicRank.D;
                    }
                    else if dr == "E" {
                        sd.Rank = MusicRank.E;
                    }
                    else
                    {
                        sd.Rank = MusicRank.Noplay;
                    }
                }
                else
                {
                    return false;
                }
            }
            else {
                return false
            }
            print("5")
            cmp = "<th>ハイスコア</th><td>";
            if let rs = src.range(of: cmp) {
                var dr = String(src[rs.upperBound...])
                cmp = "</td>";
                if let rs = dr.range(of: cmp) {
                    dr = String(dr[..<rs.lowerBound])
                    if let di = Int(dr) {
                        sd.Score = Int32(di);
                    }
                    else {
                        return false
                    }
                }
                else {
                    return false
                }
            }
            else {
                return false
            }
            print("4")
            cmp = "<th>最大コンボ数</th><td>";
            if let rs = src.range(of: cmp) {
                var dr = String(src[rs.upperBound...])
                cmp = "</td>";
                if let rs = dr.range(of: cmp) {
                    dr = String(dr[..<rs.lowerBound])
                    if let di = Int(dr) {
                        sd.MaxCombo = Int32(di);
                    }
                    else {
                        return false
                    }
                }
                else {
                    return false
                }
            }
            else {
                return false
            }
            print("3")
            if(rparam_RivalId == nil)
            {
                cmp = "<th>フルコンボ種別</th><td>";
                if let rs = src.range(of: cmp) {
                    var dr = String(src[rs.upperBound...])
                    cmp = "</td>";
                    if let rs = dr.range(of: cmp) {
                        dr = String(dr[..<rs.lowerBound])
                        if dr == "グッドフルコンボ" {
                            sd.FullComboType_ = FullComboType.GoodFullCombo;
                        }
                        else if dr == "グレートフルコンボ" {
                            sd.FullComboType_ = FullComboType.FullCombo;
                        }
                        else if dr == "パーフェクトフルコンボ" {
                            sd.FullComboType_ = FullComboType.PerfectFullCombo;
                        }
                        else if dr == "マーベラスフルコンボ" {
                            sd.FullComboType_ = FullComboType.MarvelousFullCombo;
                        }
                        else {
                            sd.FullComboType_ = FullComboType.None;
                        }
                    }
                    else {
                        return false;
                    }
                }
                else {
                    return false;
                }
                cmp = "<th>プレー回数</th><td>";
                if let rs = src.range(of: cmp) {
                    var dr = String(src[rs.upperBound...])
                    cmp = "</td>";
                    if let rs = dr.range(of: cmp) {
                        dr = String(dr[..<rs.lowerBound])
                        if let di = Int(dr) {
                            sd.PlayCount = Int32(di);
                        }
                        else {
                            return false
                        }
                    }
                    else {
                        return false
                    }
                }
                else {
                    return false
                }
                cmp = "<th>クリア回数</th><td>";
                if let rs = src.range(of: cmp) {
                    var dr = String(src[rs.upperBound...])
                    cmp = "</td>";
                    if let rs = dr.range(of: cmp) {
                        dr = String(dr[..<rs.lowerBound])
                        if let di = Int(dr) {
                            sd.ClearCount = Int32(di);
                        }
                        else {
                            return false
                        }
                    }
                    else {
                        return false
                    }
                }
                else {
                    return false
                }
            }
            else{
                cmp = "<th>フルコンボ種別</th><td>";
                if let rs = src.range(of: cmp) {
                    var dr = String(src[rs.upperBound...])
                    cmp = "</td>";
                    if let rs = dr.range(of: cmp) {
                        dr = String(dr[..<rs.lowerBound])
                        if dr == "グッドフルコンボ" {
                            sd.FullComboType_ = FullComboType.GoodFullCombo;
                        }
                        else if dr == "グレートフルコンボ" {
                            sd.FullComboType_ = FullComboType.FullCombo;
                        }
                        else if dr == "パーフェクトフルコンボ" {
                            sd.FullComboType_ = FullComboType.PerfectFullCombo;
                        }
                        else if dr == "マーベラスフルコンボ" {
                            sd.FullComboType_ = FullComboType.MarvelousFullCombo;
                        }
                        else {
                            sd.FullComboType_ = FullComboType.None;
                        }
                    }
                    else {
                        return false;
                    }
                }
                else {
                    return false;
                }
            }
        }
        var ms: MusicScore;
        if let m = mScoreList[mTarget.MusicId] {
            ms = m;
        }
        else {
            ms = MusicScore();
        }
        var msd: ScoreData;
        switch mTarget.Pattern {
        case PatternType.bSP:
            msd = ms.bSP;
            break;
        case PatternType.BSP:
            msd = ms.BSP;
            break;
        case PatternType.DSP:
            msd = ms.DSP;
            break;
        case PatternType.ESP:
            msd = ms.ESP;
            break;
        case PatternType.CSP:
            msd = ms.CSP;
            break;
        case PatternType.BDP:
            msd = ms.BDP;
            break;
        case PatternType.DDP:
            msd = ms.DDP;
            break;
        case PatternType.EDP:
            msd = ms.EDP;
            break;
        case PatternType.CDP:
            msd = ms.CDP;
            break;
        }
        
        // msd : 元の値
        // sd  : 取得した値
        // 取得した値に元の値を上書きすることによって元の値を維持する
        
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
        
        // フレアランク関連
        if msd.flareRank > sd.flareRank {
            sd.flareRank = msd.flareRank
        }
        
        switch(mTarget.Pattern) {
        case PatternType.bSP:
            ms.bSP = sd;
            break;
        case PatternType.BSP:
            ms.BSP = sd;
            break;
        case PatternType.DSP:
            ms.DSP = sd;
            break;
        case PatternType.ESP:
            ms.ESP = sd;
            break;
        case PatternType.CSP:
            ms.CSP = sd;
            break;
        case PatternType.BDP:
            ms.BDP = sd;
            break;
        case PatternType.DDP:
            ms.DDP = sd;
            break;
        case PatternType.EDP:
            ms.EDP = sd;
            break;
        case PatternType.CDP:
            ms.CDP = sd;
            break;
        }
        mScoreList[mTarget.MusicId] = ms;
        let _ = FileReader.saveScoreList(rparam_RivalId, scores: mScoreList);
        return true;
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
    
    func didFinishLoad(_ url: String, html: String) {
        let res = analyzeScore(html)
        DispatchQueue.main.async(execute: {
            if res || self.mCancel {
                self.mRetry = false
                self.mRetryCount = 3
                self.mWait = false
                self.addLog(NSLocalizedString("Done.", comment: "ViewFromGate"))
            }
            else {
                switch StringUtil.checkLoggedIn(html) {
                case 0:
                    self.mRetry = false
                    self.mRetryCount = 3
                    self.mWait = false
                    self.addLog(NSLocalizedString("Done.", comment: "ViewFromGate"))
                case 1:
                    DispatchQueue.main.async(execute: {
                        self.addLog(NSLocalizedString("Opening login form...", comment: "ViewFromGate"))
                        self.present(ViewGateLogin.checkOut(self, errorCheck: true, processPool: self.rparam_ProcessPool), animated: true, completion: nil)
                    })
                    return
                default:
                    DispatchQueue.main.async(execute: {
                        self.addLog(NSLocalizedString("ERROR!!! : Retrying...", comment: "ViewFromGate"))
                    })
                    self.mRetry = true
                    self.mWait = false
                    return
                }
            }
        })
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
        
        mPreferences = FileReader.readPreferences()
        mWebMusicIds = FileReader.readWebMusicIds()
        mScoreList = FileReader.readScoreList(rparam_RivalId)
        
        addLog(NSLocalizedString("Target: ", comment: "ViewFromGate") + (rparam_RivalId == nil ? NSLocalizedString("My scores.", comment: "ViewFromGate") : (rparam_RivalName + " (" + rparam_RivalId + ")" )))
        addLog(NSLocalizedString("Loading scores started.", comment: "ViewFromGate"))
        
        OperationQueue().addOperation({ () -> Void in
            
            sleep(3)
            var current: Int = 0
            let count: Int = self.rparam_Targets.count
            
            for target in self.rparam_Targets {
                
                self.mTarget = target
                current += 1
                
                repeat {
                    self.mWait = true
                    DispatchQueue.main.async(execute: {
                        self.addLog(" (" + current.description + "/" + count.description + ") " + self.mTarget.Pattern.rawValue + " : " + self.rparam_MusicData[self.mTarget.MusicId]!.Name + "\r\n")
                        if let wid = self.mWebMusicIds[self.mTarget.MusicId] {
                            self.mWebMusicId = wid
                            let patternInt: Int32 =
                            self.mTarget.Pattern == PatternType.bSP ? 0 :
                            self.mTarget.Pattern == PatternType.BSP ? 1 :
                            self.mTarget.Pattern == PatternType.DSP ? 2 :
                            self.mTarget.Pattern == PatternType.ESP ? 3 :
                            self.mTarget.Pattern == PatternType.CSP ? 4 :
                            self.mTarget.Pattern == PatternType.BDP ? 5 :
                            self.mTarget.Pattern == PatternType.DDP ? 6 :
                            self.mTarget.Pattern == PatternType.EDP ? 7 :
                            self.mTarget.Pattern == PatternType.CDP ? 8 :
                            0;
                            self.mRequestUri = "https://p.eagate.573.jp/game/ddr/"
                            if(self.mPreferences.Gate_LoadFromA3)
                            {
                                self.mRequestUri += "ddra3/p/"
                            }
                            else{
                                self.mRequestUri += "ddra20/p/"
                            }
                            if(self.rparam_RivalId == nil)
                            {
                                self.mRequestUri += "playdata/music_detail.html?index="+wid.idOnWebPage+"&diff="+patternInt.description;
                            }
                            else
                            {
                                self.mRequestUri = "rival/music_detail.html?index="+wid.idOnWebPage+"&diff="+patternInt.description+"&rival_id="+self.rparam_RivalId;
                            }
                            print(self.mRequestUri as Any)
                            let url: URL = URL(string: (self.mRequestUri))!
                            let request: URLRequest = URLRequest(url: url)
                            self.wkWebView.load(request)
                        }
                        else {
                            self.addLog(NSLocalizedString("ERROR!!! : No valid WEB music ID found.", comment: "ViewFromGate"))
                        }
                    })
                    while (self.mWait || self.mPause) && !self.mCancel {
                        sleep(1)
                    }
                    sleep(3)
                    self.mRetryCount = self.mRetryCount - 1
                    if self.mRetryCount <= 0 {
                        self.mPause = true
                        DispatchQueue.main.async(execute: {
                            self.addLog(NSLocalizedString("Paused in 3 time errors.", comment: "ViewFromGate"))
                            let bb = [UIBarButtonItem](arrayLiteral: self.buttonResume)
                            self.navigationBar.topItem?.rightBarButtonItems = bb
                        })
                        while self.mPause {
                            sleep(1)
                        }
                        self.mRetryCount = 3
                    }
                    if self.mCancel {
                        DispatchQueue.main.async(execute: {
                            self.addLog(NSLocalizedString("Canceled.", comment: "ViewFromGate"))
                        })
                        break
                    }
                } while self.mRetry
                self.mRetryCount = 3
                if self.mCancel {
                    sleep(3)
                    DispatchQueue.main.async(execute: {
                        self.rparam_ParentView.refreshAll()
                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                    })
                    return
                }
            }
            DispatchQueue.main.async(execute: {
                self.addLog(NSLocalizedString("Finished.", comment: "ViewFromGate"))
            })
            if self.rparam_Targets.count > 1 {
                DispatchQueue.main.async(execute: {
                    let bl = [UIBarButtonItem]()
                    self.navigationBar.topItem?.leftBarButtonItems = bl
                    let bb = [UIBarButtonItem](arrayLiteral: self.buttonDone)
                    self.navigationBar.topItem?.rightBarButtonItems = bb
                })
            }
            else {
                sleep(3)
                DispatchQueue.main.async(execute: {
                    self.rparam_ParentView.refreshAll()
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                })
            }
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
