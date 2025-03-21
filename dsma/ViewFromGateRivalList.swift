//
//  ViewFromGateRivalList.swift
//  dsm
//
//  Created by LinaNfinE on 7/21/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds

class ViewFromGateRivalList: UIViewController, UINavigationBarDelegate, UIBarPositioningDelegate, UIWebViewDelegate, WKNavigationDelegate, UITableViewDataSource, UITableViewDelegate, LoginViewOpener, GADBannerViewDelegate {
    
    static func checkOut(_ parentView: ViewManageRivals, processPool: WKProcessPool) -> (ViewFromGateRivalList) {
        let storyboard = UIStoryboard(name: "ViewFromGateRivalList", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! ViewFromGateRivalList
        ret.rparam_ParentView = parentView
        ret.rparam_ProcessPool = processPool
        return ret
    }
    
    var rparam_ParentView: ViewManageRivals!
    var rparam_ProcessPool: WKProcessPool!
    
    var mPreferences: Preferences
    var mRequestUri: String!
    var mLocalIds: [String : Int32]!
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    var wkWebView: WKWebView!
    
    required init?(coder aDecoder: NSCoder) {
        mPreferences = FileReader.readPreferences()
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        mPreferences = FileReader.readPreferences()
        super.init(nibName: nil, bundle: nil)
    }
    
    func resume() {
        mPause = false
    }
    
    func retry() {
        addLog(NSLocalizedString("Logged in.", comment: "ViewFromGateRivalList"))
        mRetry = true
        resume()
    }
    
    func cancel() {
        addLog(NSLocalizedString("Canceling...", comment: "ViewFromGateRivalList"))
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
        addLog(NSLocalizedString("Canceling...", comment: "ViewFromGateRecent"))
        mCancel = true
        buttonCancel.isEnabled = false
        let bl = [UIBarButtonItem](arrayLiteral: buttonCancel)
        navigationBar.topItem?.leftBarButtonItems = bl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        buttonCancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(ViewFromGateRivalList.cancelButtonTouched(_:)))
        let bl = [UIBarButtonItem](arrayLiteral: buttonCancel)
        navigationBar.topItem?.leftBarButtonItems = bl
    }
    
    var buttonCancel: UIBarButtonItem!
    
    func analyzeRivalList(_ src: String) -> (Bool) {
        let idSearchText = "/rival/rival_status.html?rival_id=";
        let nameSearchText = "\">";
        
        var parsingText = src;
        
        var rivals = FileReader.readRivalList()
        
        var dataExists = false
        while let rs = parsingText.range(of: idSearchText) {
            parsingText = String(parsingText[rs.upperBound...])
            let idText: String = String(parsingText[parsingText.startIndex..<parsingText.index(parsingText.startIndex, offsetBy: 8)])
            if let _ = Int(idText) {
                if let rs = parsingText.range(of: nameSearchText) {
                    parsingText = String(parsingText[rs.upperBound...])
                    if let rs = parsingText.range(of: "<") {
                        let nameText: String = parsingText[..<rs.lowerBound].trimmingCharacters(in: CharacterSet.whitespaces)
                        dataExists = true
                        var exists = false
                        for i in 2 ..< rivals.count {
                            if rivals[i].Id == idText {
                                exists = true
                                rivals[i].Name = nameText
                                break
                            }
                        }
                        if !exists {
                            rivals.append(RivalData(Id: idText, Name: nameText))
                        }
                    }
                }
            }
        }
        
        if(!dataExists) {
            return false;
        }
        
        FileReader.saveRivalList(rivals)
        
        return true
    }
    
    func didFinishLoad(_ url: String, html: String) {
        let res = analyzeRivalList(html)
        if res || mCancel {
            DispatchQueue.main.async(execute: {
                self.addLog(NSLocalizedString("Done.", comment: "ViewFromGateRivalList"))
            })
            self.mPause = false
            self.mRetryCount = 3
            self.mRetry = false
        }
        else {
            switch StringUtil.checkLoggedIn(html) {
            case 1:
                DispatchQueue.main.async(execute: {
                    self.addLog(NSLocalizedString("Opening login form...", comment: "ViewFromGateRivalList"))
                    self.present(ViewGateLogin.checkOut(self, errorCheck: true, processPool: self.rparam_ProcessPool), animated: true, completion: nil)
                })
                return
            default:
                DispatchQueue.main.async(execute: {
                    self.addLog(NSLocalizedString("ERROR!!! : Retrying...", comment: "ViewFromGateRivalList"))
                })
                self.mPause = false
                self.mRetry = true
                return
            }
        }
    }
    
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
        
        addLog(NSLocalizedString("Loading rival list started.", comment: "ViewFromGateRivalList"))
        
        let versionName: String
        switch(self.mPreferences.Gate_LoadFrom) {
        case .world:
            versionName = "WORLD"
        case .a3:
            versionName = "A3"
        case .a20plus:
            versionName = "A20PLUS"
        }
        addLog(NSLocalizedString("Version: ", comment: "ViewFromGateList") + versionName)
        
        mLocalIds = FileReader.readWebTitleToLocalIdList()
        
        OperationQueue().addOperation({ () -> Void in
            
            sleep(3)
            
            self.mRetryCount = self.mRetryCount + 1
            repeat {
                self.mRetryCount = self.mRetryCount - 1
                self.mPause = true
                DispatchQueue.main.async(execute: {
                    self.addLog(NSLocalizedString("Loading rival list page.", comment: "ViewFromGateRivalList"))
                    self.mRequestUri = "https://p.eagate.573.jp/game/ddr/"
                    switch(self.mPreferences.Gate_LoadFrom) {
                    case .world:
                        self.mRequestUri += "ddrworld/rival/index.html"
                    case .a3:
                        self.mRequestUri += "ddra3/p/rival/index.html"
                    case .a20plus:
                        self.mRequestUri += "ddra20/p/rival/index.html"
                    }
                    let url: URL = URL(string: (self.mRequestUri))!
                    let request: URLRequest = URLRequest(url: url)
                    self.wkWebView.load(request)
                })
                while self.mPause && !self.mCancel {
                    sleep(1)
                }
                sleep(3)
                if self.mCancel {
                    DispatchQueue.main.async(execute: {
                        self.addLog(NSLocalizedString("Canceled.", comment: "ViewFromGateRivalList"))
                    })
                    break
                }
            } while self.mRetry && self.mRetryCount > 0
            if self.mRetryCount == 0 {
                DispatchQueue.main.async(execute: {
                    self.addLog(NSLocalizedString("Canceled in 3 time errors.", comment: "ViewFromGateRivalList"))
                })
            }
            if self.mCancel {
                DispatchQueue.main.async(execute: {
                    self.rparam_ParentView?.refreshAll()
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                })
                return
            }
            
            DispatchQueue.main.async(execute: {
                self.addLog(NSLocalizedString("Finished.", comment: "ViewFromGateRivalList"))
            })
            sleep(3)
            DispatchQueue.main.async(execute: {
                self.rparam_ParentView?.refreshAll()
                self.presentingViewController?.dismiss(animated: true, completion: nil)
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
