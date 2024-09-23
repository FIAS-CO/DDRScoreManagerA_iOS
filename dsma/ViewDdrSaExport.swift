//
//  ViewDdrSaExport.swift
//  dsm
//
//  Created by LinaNfinE on 7/6/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewDdrSaExport: UIViewController, URLSessionDataDelegate, UINavigationBarDelegate, UIBarPositioningDelegate, UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate {
    
    static func checkOut(_ saUri: String?) -> (ViewDdrSaExport) {
        let storyboard = UIStoryboard(name: "ViewDdrSaExport", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! ViewDdrSaExport
        ret.rparam_SaUri = saUri
        return ret
    }
    
    var rparam_SaUri: String!
    
    let sRequestUri = "ddr_score_manager_score_import.php";
    
    var mPostQuery = "";
    
    var mDefaultConfiguration: URLSessionConfiguration!
    var mSession: Foundation.URLSession!
    var mRequest: NSMutableURLRequest!
    
    var mScoreList: [Int32 : MusicScore]!
    var mWebMusicIds: [Int32 : WebMusicId]!
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
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
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc internal func doneButtonTouched(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func errorHandle() {
        self.addLog(NSLocalizedString("Network error occured.", comment: "ViewDdrSaExport"))
        self.addLog(NSLocalizedString("Export failed.", comment: "ViewDdrSaExport"))
        self.addLog(NSLocalizedString("Wait a while...", comment: "ViewDdrSaExport"))
        OperationQueue().addOperation({ () -> Void in
            sleep(5)
            DispatchQueue.main.async(execute: {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        buttonCancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(ViewDdrSaExport.cancelButtonTouched(_:)))
        let bl = [UIBarButtonItem](arrayLiteral: buttonCancel)
        navigationBar.topItem?.leftBarButtonItems = bl
        
        OperationQueue().addOperation({ () -> Void in
            sleep(1)
            if let saad = FileReader.readDdrSaAuthentication() {
                self.mPostQuery = "data=" + saad[0] + "\t" + saad[1] + "\tUTF-8\n";
            }
            else {
                DispatchQueue.main.async(execute: {
                    self.addLog(NSLocalizedString("Data load failure.", comment: "ViewDdrSaExport"))
                })
                sleep(3)
                DispatchQueue.main.async(execute: {
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                })
                return
            }
            self.mWebMusicIds = FileReader.readWebMusicIds()
            self.mScoreList = FileReader.readScoreList(nil)
            let allowedCharacterSet = NSMutableCharacterSet.alphanumeric()
            allowedCharacterSet.addCharacters(in: "-._~")
            for sk in self.mScoreList.keys {
                if let wmi = self.mWebMusicIds[sk] {
                    self.mPostQuery = self.mPostQuery + StringUtil.getSaExportText(sk, scores: self.mScoreList)
                    self.mPostQuery = self.mPostQuery + "\t"
                    self.mPostQuery = self.mPostQuery + wmi.idOnWebPage
                    self.mPostQuery = self.mPostQuery + "\t"
                    self.mPostQuery = self.mPostQuery + HtmlEntityConverter.escapeWebMusicTitle(src: wmi.titleOnWebPage).addingPercentEncoding(withAllowedCharacters: allowedCharacterSet as CharacterSet)!
                    self.mPostQuery = self.mPostQuery + "\n"
                }
            }
            
            var data: Data!
            
            data = NetworkUtil.sessionSyncRequestPOST(self.rparam_SaUri + self.sRequestUri, postQuery: self.mPostQuery)
            
            if (data == nil ) {
                return
            }
            else {
                if let dataNS = NSString(data: data, encoding: String.Encoding.shiftJIS.rawValue) {
                    var src: String = dataNS as String
                    if let rs = src.range(of: "</pre>") {
                        src = String(src[..<rs.lowerBound])
                        if let rs = src.range(of: "<pre>") {
                            src = src[rs.upperBound...].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        }
                    }
                    if src[src.startIndex..<src.index(src.startIndex, offsetBy: "Authentication Failure".count)] == "Authentication Failure" {
                        self.addLog(NSLocalizedString("Authentication failure. Retry after reauthenticate.", comment: "ViewDdrSaExport"))
                    }
                    else {
                        let fctype = ["   ", "FC ", "PFC", "MFC"]
                        var expCount = 0
                        var failCount = 0
                        var s = 0
                        var str = ""
                        src.enumerateLines{
                            line, stop in
                            if line.count == 0 {
                                
                            }
                            else if line.count >= "[Failure]".count && line[line.startIndex..<line.index(line.startIndex, offsetBy: "[Failure]".count)] == "[Failure]" {
                                failCount = Int(line[line.index(line.startIndex, offsetBy: 9)...])!
                                s = 2
                                self.addLog("\r\n")
                            }
                            else if line.count >= "[Success]".count && line[line.startIndex..<line.index(line.startIndex, offsetBy: "[Success]".count)] == "[Success]" {
                                expCount = Int(line[line.index(line.startIndex, offsetBy: 9)...])!
                                s = 1
                                self.addLog("\r\n")
                            }
                            else if line.count >= "[ProcessTime]".count && line[line.startIndex..<line.index(line.startIndex, offsetBy: "[ProcessTime]".count)] == "[ProcessTime]" {
                                s = 3
                                self.addLog("\r\n")
                            }
                            else if s == 1 {
                                let sp = line.components(separatedBy: "\t")
                                if sp.count > 4 {
                                    str = str + sp[1]
                                    str = str + "\t"
                                    str = str + sp[2]
                                    str = str + "\t"
                                    str = str + fctype[Int(sp[3])!]
                                    str = str + "\t"
                                    str = str + sp[4]
                                    str = str + "\r\n"
                                }
                                self.addLog(str)
                                str = ""
                            }
                            else if s == 2 {
                                let sp = line.components(separatedBy: "\t")
                                if sp.count > 2 {
                                    var text = "Err: " + String(sp[0]) + " / "
                                    text = text + String(sp[sp.count-2]) + " - "
                                    text = String(sp[sp.count-1]) + "\r\n"
                                    self.addLog(text)
                                }
                                else {
                                    self.addLog("Err: " + line + "\r\n")
                                }
                            }
                        }
                        self.addLog(NSLocalizedString("Exported ", comment: "ViewDdrSaExport") + expCount.description + NSLocalizedString(" items.", comment: "ViewDdrSaExport"))
                        self.addLog(failCount.description + NSLocalizedString(" errors occured.", comment: "ViewDdrSaExport"))
                    }
                    self.addLog(NSLocalizedString("Done.", comment: "ViewDdrSaExport"))
                    DispatchQueue.main.async(execute: {
                        let bl = [UIBarButtonItem]()
                        self.navigationBar.topItem?.leftBarButtonItems = bl
                        self.buttonDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(ViewDdrSaExport.doneButtonTouched(_:)))
                        let bb = [UIBarButtonItem](arrayLiteral: self.buttonDone)
                        self.navigationBar.topItem?.rightBarButtonItems = bb
                    })
                }
            }
        })
    }
    
    var buttonCancel: UIBarButtonItem!
    var buttonDone: UIBarButtonItem!
    
    @objc func applicationWillEnterForeground() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let notifc: NotificationCenter = NotificationCenter.default
        notifc.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        
        self.title = "DDR SA Export"
        
        let nvFrame: CGRect = navigationBar.frame;
        tableView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height, left: 0, bottom: 0, right: 0)
        navigationBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.indicatorStyle = UIScrollView.IndicatorStyle.white
        tableView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        
        addLog(NSLocalizedString("Exporting scoredata started.", comment: "ViewDdrSaExport"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
