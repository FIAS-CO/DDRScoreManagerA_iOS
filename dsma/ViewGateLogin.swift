//
//  ViewGateLogin.swift
//  dsm
//
//  Created by LinaNfinE on 7/1/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds

class ViewGateLogin: UIViewController, UINavigationBarDelegate, UIBarPositioningDelegate, UIWebViewDelegate, WKNavigationDelegate, GADBannerViewDelegate {
    
    static func checkOut(_ parentView: LoginViewOpener?, errorCheck: Bool, processPool: WKProcessPool) -> (ViewGateLogin) {
        let storyboard = UIStoryboard(name: "ViewGateLogin", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! ViewGateLogin
        ret.rparam_ParentView = parentView
        ret.rparam_ErrorCheck = errorCheck
        ret.rparam_ProcessPool = processPool
        return ret
    }
    
    var rparam_ParentView: LoginViewOpener!
    var rparam_ErrorCheck: Bool!
    var rparam_ProcessPool: WKProcessPool!
 
    var mRequestUri: String!
    
    var mLoginFormShown: Bool = false
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    //@IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var message: UILabel!
    
    var wkWebView: WKWebView!
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    @objc internal func cancelButtonTouched(_ sender: UIButton) {
        rparam_ParentView.cancel()
        //presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc internal func stopButtonTouched(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let nvFrame: CGRect = navigationBar.frame;
        //webView.scrollView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height, left: 0, bottom: 0, right: 0)
        let bl = [UIBarButtonItem](arrayLiteral: rparam_ErrorCheck! ? buttonCancel : buttonStop)
        wkWebView.scrollView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height, left: 0, bottom: 0, right: 0)
        navigationBar.topItem?.leftBarButtonItems = bl
    }
    
    var buttonStop: UIBarButtonItem!
    var buttonCancel: UIBarButtonItem!
    
    func didFinishLoad(_ url: String, html: String) {
        print("----- Login Did Finish Load")
        print(url)
        //print(html)
        if !rparam_ErrorCheck {
            if !url.contains("my1.konami.net") && !url.contains("p.eagate.573.jp") && !url.contains("account.konami.net") {
                print(html)
                let url: URL = URL(string: (self.mRequestUri))!
                let request: URLRequest = URLRequest(url: url)
                //if #available(iOS 8.0, *) {
                    self.wkWebView.load(request)
                /*}
                else {
                    self.webView.loadRequest(request)
                }*/
            }
            return
        }
        
        // ログイン検出
        if StringUtil.checkLoggedIn(html) == 0 {
            print("Already logged in");
            if mLoginFormShown {
                //正常終了
                rparam_ParentView.retry()
                presentingViewController?.dismiss(animated: true, completion: nil)
            }
            else {
                //ログイン済みなのに変
                rparam_ParentView.cancel()
                presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
        else if !rparam_ErrorCheck && !StringUtil.isLoginForm(html) {
            print("No login form");
            //let url: URL = URL(string: (self.mRequestUri))!
            //let request: URLRequest = URLRequest(url: url)
            //if #available(iOS 8.0, *) {
                //self.wkWebView.load(request)
            /*}
            else {
                self.webView.loadRequest(request)
            }*/
        }
        else {
            print("Login form shown")
            mLoginFormShown = true
        }
    }
    
    /*func webViewDidFinishLoad(_ webView: UIWebView) {
        let url = webView.stringByEvaluatingJavaScript(from: "document.URL")
        let html = webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('html')[0].outerHTML")
        //print(url)
        //print(html)
        didFinishLoad(url!, html: html!)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        //Admob.shAdView(adHeight)
    }
    
    @objc func applicationWillEnterForeground() {
        //Admob.shAdView(adHeight)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let notifc: NotificationCenter = NotificationCenter.default
        notifc.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        
        buttonStop = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(ViewGateLogin.stopButtonTouched(_:)))
        buttonCancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(ViewGateLogin.cancelButtonTouched(_:)))
        
        if !rparam_ErrorCheck {
            message.text = NSLocalizedString("Manual login to GATE server. This operation is not automaticaly close. When you detect logged in, close the login window manualy.", comment: "ViewPreferences")
        }

        //self.title = "Preferences"
        //adView.addSubview(Admob.getAdBannerView(self))

        let nvFrame: CGRect = navigationBar.frame;
        //webView.scrollView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height, left: 0, bottom: 0, right: 0)
        navigationBar.delegate = self
        /*
        webView.delegate = self
        webView.scrollView.indicatorStyle = UIScrollView.IndicatorStyle.white
        webView.scrollView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        */
        mRequestUri = "https://p.eagate.573.jp/gate/p/login.html"
        //mRequestUri = "https://www.google.com/"
        
        let url: URL = URL(string: (self.mRequestUri))!
        let request: URLRequest = URLRequest(url: url)
        
        //if #available(iOS 8.0, *) {
        let configuration = WKWebViewConfiguration()
        configuration.processPool = rparam_ProcessPool
        wkWebView = WKWebView(frame: mainView.frame, configuration: configuration)
        wkWebView.navigationDelegate = self
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        wkWebView.scrollView.indicatorStyle = UIScrollView.IndicatorStyle.white
        wkWebView.scrollView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        wkWebView.scrollView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height, left: 0, bottom: 0, right: 0)
        navigationBar.delegate = self
        self.view.addSubview(wkWebView)
        self.view.bringSubviewToFront(navigationBar)
        
        let views: [String : UIView] = [
            "wkwebview": wkWebView,
            "message": message,
            "adview": adView,
        ]
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[wkwebview]|", options: [], metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[wkwebview]-0-[message]-0-[adview]|", options: [], metrics: nil, views: views))
        
        wkWebView.load(request)
        /*}
        else {
            self.webView.loadRequest(request)
        }*/

    }
    
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        wkWebView.evaluateJavaScript("document.getElementsByTagName('html')[0].outerHTML", completionHandler: {(html, error) -> Void in
            //print("FinishNavigation-----------------------------------")
            //print(html)
            self.didFinishLoad(String(describing: self.wkWebView.url), html: String(describing: html))
        })
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        //print("Redirect-----------------------------------")
    }
    
}
