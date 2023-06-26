//
//  ViewDdrSaAuthenticate.swift
//  dsm
//
//  Created by LinaNfinE on 7/6/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewDdrSaAuthenticate: UIViewController, URLSessionDataDelegate, UINavigationBarDelegate, UIBarPositioningDelegate, UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate {
    
    static func checkOut(_ saUri: String?) -> (ViewDdrSaAuthenticate) {
        let storyboard = UIStoryboard(name: "ViewDdrSaAuthenticate", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! ViewDdrSaAuthenticate
        ret.modalPresentationStyle = .fullScreen
        ret.rparam_SaUri = saUri
        return ret
    }
    
    var rparam_SaUri: String!
    
    let sPasswordEncryptionUri = "http://skillattack.com/sa4/sa4_encrypt.php";
    let sRequestUri = "ddr_score_manager_score_import.php";
    
    var mPostQuery = "";
    var mEncryptedPassword = "";
    
    var mDefaultConfiguration: URLSessionConfiguration!
    var mSession: Foundation.URLSession!
    var mRequest: NSMutableURLRequest!
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var buttonAuthenticate: UIButton!
    @IBOutlet weak var editId: UITextField!
    @IBOutlet weak var editPass: UITextField!
    
    @IBAction func buttonAuthenticateTouchUpInside(_ sender: AnyObject) {
        editId.isEnabled = false
        editPass.isEnabled = false
        buttonAuthenticate.isEnabled = false
        
        self.addLog(NSLocalizedString("Authenticating...", comment: "ViewDdrSaAuthenticate"))
        
        //var err: NSError?
        //var res: URLResponse?
        var data: Data!
        
        //mDefaultConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        //mSession = NSURLSession(configuration: mDefaultConfiguration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        //mRequest = NSMutableURLRequest(url: URL(string: sPasswordEncryptionUri)!)
        let allowedCharacterSet = NSMutableCharacterSet.alphanumeric()
        allowedCharacterSet.addCharacters(in: "-._~")
        mPostQuery = "plain=" + editPass.text!.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet as CharacterSet)!
        data = NetworkUtil.sessionSyncRequestPOST(sPasswordEncryptionUri, postQuery: mPostQuery)
        /*mRequest.httpMethod = "POST"
        mRequest.httpBody = mPostQuery.data(using: String.Encoding.utf8, allowLossyConversion: true)
        do {
            let data = try NSURLConnection.sendSynchronousRequest(self.mRequest as URLRequest, returning: &res)*/
            if (data == nil ) {
                return
            }
            else {
                if let dataNS = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
                    let src: String = dataNS as String
                    mEncryptedPassword = src
                }
            }
            /*else {
                self.errorHandle()
                return
            }
        } catch let error as NSError {
            err = error
            self.errorHandle()
            return
        }*/
        mPostQuery = "data=" + editId.text! + "\t" + mEncryptedPassword + "\n";
        addLog(NSLocalizedString("Checking...", comment: "ViewDdrSaAuthenticate"))
        data = NetworkUtil.sessionSyncRequestPOST(rparam_SaUri + sRequestUri, postQuery: mPostQuery)
        /*mRequest = NSMutableURLRequest(url: URL(string: rparam_SaUri + sRequestUri)!)
        mRequest.httpMethod = "POST"
        mRequest.httpBody = mPostQuery.data(using: String.Encoding.utf8, allowLossyConversion: true)
        do {
            let data = try NSURLConnection.sendSynchronousRequest(self.mRequest as URLRequest, returning: &res)*/
            if (data == nil ) {
                return
            }
            else {
                if let dataNS = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
                    var src: String = dataNS as String
                    if let srs = src.range(of: "<pre>"), let ers = src.range(of: "</pre>") {
                        src = src[srs.upperBound..<ers.lowerBound].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    }
                    if src[src.startIndex..<src.index(src.startIndex, offsetBy: "Authentication Failure".count)] == "Authentication Failure" {
                        addLog(NSLocalizedString("Authentication failure", comment: "ViewDdrSaAuthenticate"))
                        editId.isEnabled = true
                        editPass.isEnabled = true
                        buttonAuthenticate.isEnabled = true
                    }
                    else {
                        addLog(NSLocalizedString("Authentication succeed.", comment: "ViewDdrSaAuthenticate"))
                        FileReader.saveDdrSaAuthentication(editId.text!, encryptedPassword: mEncryptedPassword)
                        OperationQueue().addOperation({ () -> Void in
                            sleep(3)
                            DispatchQueue.main.async(execute: {
                                self.presentingViewController?.dismiss(animated: true, completion: nil)
                            })
                        })
                    }
                    addLog(NSLocalizedString("Done.", comment: "ViewDdrSaAuthenticate"))
                }
            }
            /*else {
                self.errorHandle()
                return
            }
        } catch let error as NSError {
            err = error
            self.errorHandle()
            return
        }*/
        //let task: NSURLSessionDataTask = mSession.dataTaskWithRequest(mRequest)
        //task.resume()
    
    }
    
    func errorHandle() {
        self.addLog(NSLocalizedString("Network error occured.", comment: "ViewDdrSaAuthenticate"))
        self.addLog(NSLocalizedString("Authentication failed.", comment: "ViewDdrSaAuthenticate"))
        self.addLog(NSLocalizedString("Wait a while...", comment: "ViewDdrSaAuthenticate"))
        OperationQueue().addOperation({ () -> Void in
            sleep(5)
            DispatchQueue.main.async(execute: {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })
        })
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
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        if let httpURLResponse = response as? HTTPURLResponse {
            let statuscode = httpURLResponse.statusCode
            if statuscode == 200{
                let disposition:Foundation.URLSession.ResponseDisposition = Foundation.URLSession.ResponseDisposition.allow
                completionHandler(disposition)
            }else{
            }
        }
    }
    
    var mRecvData = NSMutableData()
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        if let _ = mRequest.url {
            mRecvData.append(data)
        }

    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if error == nil {
        } else {
            mSession.finishTasksAndInvalidate()
            return
        }
        
        if let url = mRequest.url {
            
            var src = String(NSString(data: mRecvData as Data, encoding: String.Encoding.utf8.rawValue)!)
            
            switch url {
            case URL(string: sPasswordEncryptionUri)!:
                mEncryptedPassword = src
                mPostQuery = "data=" + editId.text! + "\t" + mEncryptedPassword + "\n";
                addLog(NSLocalizedString("Checking...", comment: "ViewDdrSaAuthenticate"))
                mRequest = NSMutableURLRequest(url: URL(string: rparam_SaUri + sRequestUri)!)
                mRequest.httpMethod = "POST"
                mRequest.httpBody = mPostQuery.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let task: URLSessionDataTask = mSession.dataTask(with: mRequest as URLRequest)
                task.resume()
            case URL(string: rparam_SaUri + sRequestUri)!:
                if let srs = src.range(of: "<pre>"), let ers = src.range(of: "</pre>") {
                    src = src[srs.upperBound..<ers.lowerBound].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                }
                if src[src.startIndex..<src.index(src.startIndex, offsetBy: "Authentication Failure".count)] == "Authentication Failure" {
                    addLog(NSLocalizedString("Authentication failure", comment: "ViewDdrSaAuthenticate"))
                    editId.isEnabled = true
                    editPass.isEnabled = true
                    buttonAuthenticate.isEnabled = true
                }
                else {
                    addLog(NSLocalizedString("Authentication succeed.", comment: "ViewDdrSaAuthenticate"))
                    FileReader.saveDdrSaAuthentication(editId.text!, encryptedPassword: mEncryptedPassword)
                    OperationQueue().addOperation({ () -> Void in
                        sleep(3)
                        DispatchQueue.main.async(execute: {
                            self.presentingViewController?.dismiss(animated: true, completion: nil)
                        })
                    })
                }
                addLog(NSLocalizedString("Done.", comment: "ViewDdrSaAuthenticate"))
                mSession.finishTasksAndInvalidate()
            default:
                break
            }
            
        }

    }
    
    @IBAction func editIdEditingChanged(_ sender: AnyObject) {
        setButtonActivation()
    }
    @IBAction func editPassEditingChanged(_ sender: AnyObject) {
        setButtonActivation()
    }
    
    func setButtonActivation() {
        if editId.text!.count == 0 || editPass.text!.count == 0 {
            buttonAuthenticate.isEnabled = false
        }
        else {
            buttonAuthenticate.isEnabled = true
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
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
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        //switch logText[indexPath.row] {
        //default:
        //}
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 12
    }
    
    @objc internal func cancelButtonTouched(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        chancelStop = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(ViewDdrSaAuthenticate.cancelButtonTouched(_:)))
        let bl = [UIBarButtonItem](arrayLiteral: chancelStop)
        navigationBar.topItem?.leftBarButtonItems = bl
        //Admob.shAdView(adHeight)
    }
    
    var chancelStop: UIBarButtonItem!
    
    var mPause: Bool = false
    
    @objc func applicationWillEnterForeground() {
        //Admob.shAdView(adHeight)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let notifc: NotificationCenter = NotificationCenter.default
        notifc.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        
        self.title = "DDR SA Authenticate"
        //adView.addSubview(Admob.getAdBannerView(self))

        //var nvFrame: CGRect = navigationBar.frame;
        //webView.scrollView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height, left: 0, bottom: 0, right: 0)
        //tableView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height, left: 0, bottom: 0, right: 0)
        navigationBar.delegate = self
        
        bgView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.indicatorStyle = UIScrollView.IndicatorStyle.white
        tableView.backgroundColor = UIColor(white: 0, alpha: 0.01)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
