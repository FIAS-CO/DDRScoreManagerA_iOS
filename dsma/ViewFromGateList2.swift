//
//  ViewFromGateList2.swift
//  dsma
//
//  Created by apple on 2024/11/03.
//  Copyright © 2024 LinaNfinE. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds

class ViewFromGateList2: UIViewController, UINavigationBarDelegate, UIBarPositioningDelegate, UIWebViewDelegate, WKNavigationDelegate, UITableViewDataSource, UITableViewDelegate, LoginViewOpener, GADBannerViewDelegate {
    
    enum PlayStyle {
        case sp
        case dp
        case all
    }
    
    static func checkOut(_ parentView: ViewScoreList?, playStyle: PlayStyle, rivalId: String?, rivalName: String?, processPool: WKProcessPool) -> (ViewFromGateList2) {
        let storyboard = UIStoryboard(name: "ViewFromGateList2", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! ViewFromGateList2
        ret.rparam_ParentView = parentView
        ret.rparam_PlayStyle = playStyle
        ret.rparam_RivalId = rivalId
        ret.rparam_RivalName = rivalName
        ret.rparam_ProcessPool = processPool
        return ret
    }
    
    var rparam_PlayStyle: PlayStyle!
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
        addLog(NSLocalizedString("Logged in.", comment: "ViewFromGateList2"))
        mRetry = true
        resume()
    }
    
    func cancel() {
        addLog(NSLocalizedString("Canceling...", comment: "ViewFromGateList2"))
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
        addLog(NSLocalizedString("Canceling...", comment: "ViewFromGateList2"))
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
        addLog(NSLocalizedString("Paused.", comment: "ViewFromGateList2"))
    }
    
    @objc internal func resumeButtonTouched(_ sender: UIButton) {
        mPause = false
        let bb = [UIBarButtonItem](arrayLiteral: buttonPause)
        navigationBar.topItem?.rightBarButtonItems = bb
        addLog(NSLocalizedString("Resumed.", comment: "ViewFromGateList2"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        buttonCancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(ViewFromGateList2.cancelButtonTouched(_:)))
        buttonResume = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.play, target: self, action: #selector(ViewFromGateList2.resumeButtonTouched(_:)))
        buttonPause = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.pause, target: self, action: #selector(ViewFromGateList2.pauseButtonTouched(_:)))
        buttonDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(ViewFromGateList2.doneButtonTouched(_:)))
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
        if (self.mPreferences.Gate_LoadFrom == .world) {
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
                        self.addLog(NSLocalizedString("Opening login form...", comment: "ViewFromGateList2"))
                        self.present(ViewGateLogin.checkOut(self, errorCheck: true, processPool: self.rparam_ProcessPool), animated: true, completion: nil)
                    })
                    return
                default:
                    DispatchQueue.main.async(execute: {
                        self.addLog(NSLocalizedString("ERROR!!! : Retrying...", comment: "ViewFromGateList2"))
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
                self.addLog(NSLocalizedString("Done.", comment: "ViewFromGateList2"))
            })
            self.mWait = false
            self.mRetryCount = 3
            self.mRetry = false
        }
        else {
            DispatchQueue.main.async(execute: {
                self.addLog(NSLocalizedString("ERROR!!! : Retrying...", comment: "ViewFromGateList2"))
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
        
        addLog(NSLocalizedString("Target: ", comment: "ViewFromGateList2") + (rparam_RivalId == nil ? NSLocalizedString("My scores.", comment: "ViewFromGateList2") : (rparam_RivalName + " (" + rparam_RivalId + ")" )))
        
        mPreferences = FileReader.readPreferences()
        mWebMusicIds = FileReader.readWebMusicIds()
        mScoreList = FileReader.readScoreList(rparam_RivalId)
        mLocalIds = FileReader.readWebTitleToLocalIdList()
        
        let versionName = "WORLD"
        
        addLog(NSLocalizedString("Version: ", comment: "ViewFromGateList2") + versionName)
        addLog(NSLocalizedString("Loading scores started.", comment: "ViewFromGateList2"))
        
        OperationQueue().addOperation({ () -> Void in
            
            sleep(3)
            if (self.rparam_PlayStyle == .sp || self.rparam_PlayStyle == .all) {
                self.updateScore(isSingle: true)
            }
            if (self.rparam_PlayStyle == .dp || self.rparam_PlayStyle == .all) {
                self.updateScore(isSingle: false)
            }
            
            DispatchQueue.main.async(execute: {
                self.addLog(NSLocalizedString("Finished.", comment: "ViewFromGateList2"))
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
    
    fileprivate func updateScore(isSingle: Bool) {
        let logLabel = isSingle ? "SP" : "DP";
        let playStyle = isSingle ? "single" : "double"
        self.mPageCount = 1
        for i in 0 ..< 1000000 {
            
            repeat {
                self.mWait = true
                DispatchQueue.main.async(execute: {
                    self.addLog("\(logLabel) : " + (i+1).description + " / " + (self.mPageCount == 1 ? "?" : self.mPageCount.description) + "\r\n")
                    self.mUriH = "https://p.eagate.573.jp/game/ddr/ddrworld/"
                    
                    
                    if self.rparam_RivalId == nil {
                        self.mUriH += "playdata/music_data_\(playStyle).html?offset=";
                        self.mUriF = "";
                    }
                    else {
                        self.mUriH += "rival/music_data_\(playStyle).html?offset=";
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
                        self.addLog(NSLocalizedString("Canceled.", comment: "ViewFromGateList2"))
                    })
                    break
                }
                self.mRetryCount -= 1
                if self.mRetryCount <= 0 {
                    DispatchQueue.main.async(execute: {
                        self.addLog(NSLocalizedString("Paused in 3 time errors.", comment: "ViewFromGateList2"))
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
                        self.addLog(NSLocalizedString("Canceled.", comment: "ViewFromGateList2"))
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
    }
    
}
