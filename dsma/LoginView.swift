//
//  LoginView.swift
//  dsm
//
//  Created by LinaNfinE on 7/1/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit

class LoginView: UIViewController, UINavigationBarDelegate, UIBarPositioningDelegate, UIWebViewDelegate {
    
    var rparam_ParentView: LoginViewOpener!
 
    var mRequestUri: String!
    
    var mLoginFormShown: Bool = false

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var webView: UIWebView!
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    internal func cancelButtonTouched(sender: UIButton) {
        rparam_ParentView.cancel()
        //presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        buttonCancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelButtonTouched:")
        var bl = [AnyObject](arrayLiteral: buttonCancel)
        navigationBar.topItem?.leftBarButtonItems = bl
    }
    
    var buttonCancel: UIBarButtonItem!
    
    func isLoginForm(var src: String) -> (Bool) {
        var cmp: String = "<form method=\"post\" action=\"/gate/p/login.html\">";
        return src.rangeOfString(cmp) == nil ? false : true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        var url = webView.stringByEvaluatingJavaScriptFromString("document.URL")
        var html = webView.stringByEvaluatingJavaScriptFromString("document.getElementsByTagName('html')[0].outerHTML")
        //println(html)
        //println(url)
        
        if StringUtil.checkLoggedIn(html!) == 0 {
            if mLoginFormShown {
                rparam_ParentView.retry()
                presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
            else {
                rparam_ParentView.cancel()
                presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        else if !isLoginForm(html!) {
            let url: NSURL = NSURL(string: self.mRequestUri)!
            let request: NSURLRequest = NSURLRequest(URL: url)
            self.webView.loadRequest(request)
        }
        else {
            mLoginFormShown = true
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.title = "Preferences"
        
        var nvFrame: CGRect = navigationBar.frame;
        webView.scrollView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height, left: 0, bottom: 0, right: 0)
        navigationBar.delegate = self
        
        webView.delegate = self
        webView.scrollView.indicatorStyle = UIScrollViewIndicatorStyle.White
        webView.scrollView.backgroundColor = UIColor.blackColor()
        
        mRequestUri = "https://p.eagate.573.jp/gate/p/login.html"
        
        let url: NSURL = NSURL(string: self.mRequestUri)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        self.webView.loadRequest(request)
        
    }
    
}
