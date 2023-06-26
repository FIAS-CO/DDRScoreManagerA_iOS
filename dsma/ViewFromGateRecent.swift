//
//  ViewFromGateRecent.swift
//  dsm
//
//  Created by LinaNfinE on 7/9/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds

class ViewFromGateRecent: UIViewController, UINavigationBarDelegate, UIBarPositioningDelegate, UIWebViewDelegate, WKNavigationDelegate, UITableViewDataSource, UITableViewDelegate, LoginViewOpener, GADBannerViewDelegate {
    
    static func checkOut(_ parentView: ViewScoreList?, processPool: WKProcessPool) -> (ViewFromGateRecent) {
        let storyboard = UIStoryboard(name: "ViewFromGateRecent", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! ViewFromGateRecent
        ret.rparam_ParentView = parentView
        ret.rparam_ProcessPool = processPool
        return ret
    }
    
    var rparam_ParentView: ViewScoreList!
    var rparam_ProcessPool: WKProcessPool!
    
    var mPreferences: Preferences
    var mRequestUri: String!
    var mLocalIds: [String : Int32]!
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    //@IBOutlet weak var webView: UIWebView!
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
    
    func resume() {
        mPause = false
    }
    
    func retry() {
        addLog(NSLocalizedString("Logged in.", comment: "ViewFromGateRecent"))
        mRetry = true
        resume()
    }
    
    func cancel() {
        addLog(NSLocalizedString("Canceling...", comment: "ViewFromGateRecent"))
        mCancel = true
        resume()
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
                //let cp = CGPoint(x: 0, y: (lh < th - tcit ? 0 - tcit : lh - th))
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
        //cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
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
        //presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        //presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        addLog(NSLocalizedString("Canceling...", comment: "ViewFromGateRecent"))
        mCancel = true
        buttonCancel.isEnabled = false
        let bl = [UIBarButtonItem](arrayLiteral: buttonCancel)
        navigationBar.topItem?.leftBarButtonItems = bl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        buttonCancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(ViewFromGateRecent.cancelButtonTouched(_:)))
        let bl = [UIBarButtonItem](arrayLiteral: buttonCancel)
        navigationBar.topItem?.leftBarButtonItems = bl
    }
    
    var buttonCancel: UIBarButtonItem!
    
    func analyzeRecent(_ src: String) -> (Bool) {
        
        let musicDetailLinkStartText = "/p/playdata/music_detail.html?index="
        let musicDetailLinkEndText = "&amp;"
        let patternTypeNumberStartText = "diff="
        let patternTypeNumberEndText = "\" class="
        
        var parsingText = src;
        
        var recent = [RecentData]()
        
        var dataExists = false
        while let rs = parsingText.range(of: musicDetailLinkStartText) {
            parsingText = String(parsingText[rs.upperBound...])
            if let rs = parsingText.range(of: musicDetailLinkEndText) {
                let webId = String(parsingText[..<rs.lowerBound])
                var patternTypeText: String = ""
                if let rs = parsingText.range(of: patternTypeNumberStartText) {
                    parsingText = String(parsingText[rs.upperBound...])
                    if let rs = parsingText.range(of: patternTypeNumberEndText) {
                        patternTypeText = String(parsingText[..<rs.lowerBound])
                    }
                }
                var patternType: PatternType! = nil
                switch(patternTypeText){
                case "0": patternType = PatternType.bSP
                case "1": patternType = PatternType.BSP
                case "2": patternType = PatternType.DSP
                case "3": patternType = PatternType.ESP
                case "4": patternType = PatternType.CSP
                case "5": patternType = PatternType.BDP
                case "6": patternType = PatternType.DDP
                case "7": patternType = PatternType.EDP
                case "8": patternType = PatternType.CDP
                default: break
                }
                if let id = mLocalIds[webId] {
                    if patternType != nil {
                        recent.append(RecentData(Id: id,PatternType_: patternType))
                    }
                }
                dataExists = true
            }
        }
        
        if(!dataExists) {
            return false;
        }
        
        FileReader.saveRecentList(recent)
        
        return true
    }
    
    func didFinishLoad(_ url: String, html: String) {
        let res = analyzeRecent(html)
        if res || mCancel {
            DispatchQueue.main.async(execute: {
                self.addLog(NSLocalizedString("Done.", comment: "ViewFromGateRecent"))
            })
            self.mPause = false
            self.mRetryCount = 3
            self.mRetry = false
        }
        else {
            switch StringUtil.checkLoggedIn(html) {
            case 1:
                DispatchQueue.main.async(execute: {
                    self.addLog(NSLocalizedString("Opening login form...", comment: "ViewFromGateRecent"))
                    //self.sparam_ParentView = self
                    //self.performSegueWithIdentifier("modalGateLogin",sender: nil)
                    self.self.present(ViewGateLogin.checkOut(self, errorCheck: true, processPool: self.rparam_ProcessPool), animated: true, completion: nil)
                })
                return
            default:
                DispatchQueue.main.async(execute: {
                    self.addLog(NSLocalizedString("ERROR!!! : Retrying...", comment: "ViewFromGateRecent"))
                })
                self.mPause = false
                self.mRetry = true
                return
            }
        }
    }
    
    /*func webViewDidFinishLoad(_ webView: UIWebView) {
        let url = webView.stringByEvaluatingJavaScript(from: "document.URL")
        let html = webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('html')[0].outerHTML")
        didFinishLoad(url!, html: html!)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        Admob.shAdView(adHeight)
    }
    
    var mRetryCount: Int = 3
    var mRetry: Bool = false
    var mPause: Bool = false
    var mCancel: Bool = false
    
    @objc func applicationWillEnterForeground() {
        Admob.shAdView(adHeight)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let notifc: NotificationCenter = NotificationCenter.default
        notifc.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        
        //self.title = "Preferences"
        adView.addSubview(Admob.getAdBannerView(self))
        
        let nvFrame: CGRect = navigationBar.frame;
        //webView.scrollView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height, left: 0, bottom: 0, right: 0)
        tableView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height, left: 0, bottom: 0, right: 0)
        navigationBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        /*
        webView.delegate = self
        webView.scrollView.indicatorStyle = UIScrollView.IndicatorStyle.white
        webView.scrollView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        */
        tableView.indicatorStyle = UIScrollView.IndicatorStyle.white
        tableView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        
        //if #available(iOS 8.0, *) {
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
            //self.view.bringSubviewToFront(navigationBar)
        //}
        
        mPreferences = FileReader.readPreferences()
        
        addLog(NSLocalizedString("Loading recent started.", comment: "ViewFromGateRecent"))
        
        mLocalIds = FileReader.readWebIdToLocalIdList()
        
        OperationQueue().addOperation({ () -> Void in
            
            sleep(3)
            
                repeat {
                    self.mPause = true
                    DispatchQueue.main.async(execute: {
                        self.addLog(NSLocalizedString("Loading recent page.", comment: "ViewFromGateRecent"))
                        self.mRequestUri = "https://p.eagate.573.jp/game/ddr/"
                        if self.mPreferences.Gate_LoadFromA3{
                            self.mRequestUri += "ddra3/p/playdata/music_recent.html"
                        }
                        else{
                            self.mRequestUri += "ddra20/p/playdata/music_recent.html"
                        }
                        print(self.mPreferences.Gate_LoadFromA3)
                        let url: URL = URL(string: (self.mRequestUri))!
                        let request: URLRequest = URLRequest(url: url)
                        //if #available(iOS 8.0, *) {
                            self.wkWebView.load(request)
                        /*}
                        else {
                            self.webView.loadRequest(request)
                        }*/
                    })
                    while self.mPause && !self.mCancel {
                        sleep(1)
                    }
                    sleep(3)
                    if self.mCancel {
                        DispatchQueue.main.async(execute: {
                            self.addLog(NSLocalizedString("Canceled.", comment: "ViewFromGateRecent"))
                        })
                        break
                    }
                    self.mRetryCount -= 1
                    if self.mRetryCount <= 0 {
                        self.mPause = true
                        DispatchQueue.main.async(execute: {
                            self.addLog(NSLocalizedString("Canceled in 3 time errors.", comment: "ViewFromGateRecent"))
                        })
                        break
                    }
                } while self.mRetry
                if self.mCancel {
                    DispatchQueue.main.async(execute: {
                        self.rparam_ParentView?.refreshAll()
                        //self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                    })
                    return
                }

            DispatchQueue.main.async(execute: {
                self.addLog(NSLocalizedString("Finished.", comment: "ViewFromGateRecent"))
            })
            sleep(3)
            DispatchQueue.main.async(execute: {
                self.rparam_ParentView?.refreshAll()
                //self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })
        })
        
    }
    
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        wkWebView.evaluateJavaScript("document.getElementsByTagName('html')[0].outerHTML", completionHandler: {(html, error) -> Void in
            //print(html)
            self.didFinishLoad(String(describing: self.wkWebView.url), html: String(describing: html))
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
