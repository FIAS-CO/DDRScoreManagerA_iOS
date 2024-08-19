//
//  ViewMusicListUpdate.swift
//  dsm
//
//  Created by LinaNfinE on 6/8/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewMusicListUpdate: UIViewController, URLSessionDownloadDelegate, UINavigationBarDelegate, UIBarPositioningDelegate, UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate {
    
    static func checkOut(_ parentView: ViewCategorySelect?) -> (ViewMusicListUpdate) {
        let storyboard = UIStoryboard(name: "ViewMusicListUpdate", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! ViewMusicListUpdate
        ret.rparam_ParentView = parentView
        return ret
    }
    
    let sMusicListVersionTxt: String = "https://docs.google.com/spreadsheets/d/1HA8RH2ozKQTPvvq2BVcVoOSEMVIldRw89tFtNg8Z4V8/export?format=tsv&gid=334969595"
    let sMusicNamesTxt: String = "https://docs.google.com/spreadsheets/d/1HA8RH2ozKQTPvvq2BVcVoOSEMVIldRw89tFtNg8Z4V8/export?format=tsv&gid=0";
    let sShockArrowExistsTxt: String = "https://docs.google.com/spreadsheets/d/1HA8RH2ozKQTPvvq2BVcVoOSEMVIldRw89tFtNg8Z4V8/export?format=tsv&gid=1975740187";
    let sWebMusicIdsTxt: String = "https://docs.google.com/spreadsheets/d/1HA8RH2ozKQTPvvq2BVcVoOSEMVIldRw89tFtNg8Z4V8/export?format=tsv&gid=1376903169";
    
    var rparam_ParentView: ViewCategorySelect!
    
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
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        //switch logText[indexPath.row] {
        //default:
        //}
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 12
    }
    
    @objc internal func stopButtonTouched(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        buttonStop = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(ViewMusicListUpdate.stopButtonTouched(_:)))
        //var bl = [AnyObject](arrayLiteral: buttonStop)
        //navigationBar.topItem?.leftBarButtonItems = bl
        Admob.shAdView(adHeight)
    }
    
    var buttonStop: UIBarButtonItem!
    
    let sSessionIdentifier: String = "jp.linanfine.dsm.DlSession"
    var mBackgroundConfiguration: URLSessionConfiguration!
    var mSession: Foundation.URLSession!
    var mRequest: URLRequest!
    
    func errorHandle() {
        self.addLog(NSLocalizedString("Network error occured.", comment: "ViewMusicListUpdate"))
        self.addLog(NSLocalizedString("Music list download failed.", comment: "ViewMusicListUpdate"))
        self.addLog(NSLocalizedString("Wait a while...", comment: "ViewMusicListUpdate"))
        OperationQueue().addOperation({ () -> Void in
            sleep(5)
            DispatchQueue.main.async(execute: {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    func errorHandle2() {
        self.addLog(NSLocalizedString("Media error occured.", comment: "ViewMusicListUpdate"))
        self.addLog(NSLocalizedString("Music list download failed.", comment: "ViewMusicListUpdate"))
        self.addLog(NSLocalizedString("Wait a while...", comment: "ViewMusicListUpdate"))
        OperationQueue().addOperation({ () -> Void in
            sleep(5)
            DispatchQueue.main.async(execute: {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    @objc func applicationWillEnterForeground() {
        Admob.shAdView(adHeight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let notifc: NotificationCenter = NotificationCenter.default
        notifc.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        
        self.title = "Updating Music List..."
        adView.addSubview(Admob.getAdBannerView(self))
        
        let nvFrame: CGRect = navigationBar.frame;
        tableView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height, left: 0, bottom: 0, right: 0)
        navigationBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.indicatorStyle = UIScrollView.IndicatorStyle.white
        tableView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        
        //errorHandle()
        
        OperationQueue().addOperation({ () -> Void in
            
            let libraryDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
            let cacheDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
            
            var data: Data!
            
            self.addLog(NSLocalizedString("Checking for update...", comment: "ViewMusicListUpdate"))
            data = NetworkUtil.sessionSyncRequestGET(self.sMusicListVersionTxt)
            
            if (data == nil ) {
                return
            }
            else {
                if let dataNS = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
                    let dataString: String = dataNS as String
                    if "edit" == dataString {
                        self.addLog(NSLocalizedString("Update file is now editing.", comment: "ViewMusicListUpdate"))
                        self.addLog(NSLocalizedString("Wait a while...", comment: "ViewMusicListUpdate"))
                        
                        OperationQueue().addOperation({ () -> Void in
                            sleep(3)
                            DispatchQueue.main.async(execute: {
                                self.presentingViewController?.dismiss(animated: true, completion: nil)
                            })
                        })
                        return
                    }
                    if let savedNS = try? NSString(contentsOfFile: (libraryDirPath as NSString).appendingPathComponent("MusicListVersion.txt"), encoding: String.Encoding.utf8.rawValue) {
                        let saved: String = savedNS as String
                        self.addLog(NSLocalizedString("Done.", comment: "ViewMusicListUpdate"))
                        if saved == dataString {
                            self.addLog(NSLocalizedString("No Updates are found.", comment: "ViewMusicListUpdate"))
                            self.addLog(NSLocalizedString("Wait a while...", comment: "ViewMusicListUpdate"))
                            FileReader.saveLastAppVersion()
                            FileReader.saveLastBootTime()
                            OperationQueue().addOperation({ () -> Void in
                                sleep(3)
                                DispatchQueue.main.async(execute: {
                                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                                })
                            })
                            return
                        }
                    }
                    do {
                        try dataString.write(toFile: (cacheDirPath as NSString).appendingPathComponent("MusicListVersion.txt"), atomically: true, encoding: String.Encoding.utf8)
                    } catch _ {
                    }
                }
            }
            self.addLog(NSLocalizedString("Downloading Music Information File...", comment: "ViewMusicListUpdate"))
            data = NetworkUtil.sessionSyncRequestGET(self.sMusicNamesTxt)
            
            if (data == nil ) {
                return
            }
            else {
                if let dataNS = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
                    let dataString: String = dataNS as String
                    self.addLog(NSLocalizedString("Done.", comment: "ViewMusicListUpdate"))
                    do {
                        try dataString.write(toFile: (cacheDirPath as NSString).appendingPathComponent("MusicNames.txt"), atomically: true, encoding: String.Encoding.utf8)
                    } catch _ {
                    }
                }
            }
            
            self.addLog(NSLocalizedString("Downloading Shock Arrow Information File...", comment: "ViewMusicListUpdate"))
            data = NetworkUtil.sessionSyncRequestGET(self.sShockArrowExistsTxt)
            
            if (data == nil ) {
                return
            }
            else {
                if let dataNS = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
                    let dataString: String = dataNS as String
                    self.addLog(NSLocalizedString("Done.", comment: "ViewMusicListUpdate"))
                    do {
                        try dataString.write(toFile: (cacheDirPath as NSString).appendingPathComponent("ShockArrowExists.txt"), atomically: true, encoding: String.Encoding.utf8)
                    } catch _ {
                    }
                }
            }
            
            
            self.addLog(NSLocalizedString("Downloading Music ID Information File...", comment: "ViewMusicListUpdate"))
            data = NetworkUtil.sessionSyncRequestGET(self.sWebMusicIdsTxt)
            
            if (data == nil ) {
                return
            }
            else {
                if let dataNS = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
                    let dataString: String = dataNS as String
                    self.addLog(NSLocalizedString("Done.", comment: "ViewMusicListUpdate"))
                    do {
                        try dataString.write(toFile: (cacheDirPath as NSString).appendingPathComponent("WebMusicIds.txt"), atomically: true, encoding: String.Encoding.utf8)
                    } catch _ {
                    }
                }
            }
            
            if let lvns: NSString = try? NSString(contentsOfFile: (cacheDirPath as NSString).appendingPathComponent("MusicListVersion.txt"), encoding: String.Encoding.utf8.rawValue) {
                if let mnns: NSString = try? NSString(contentsOfFile: (cacheDirPath as NSString).appendingPathComponent("MusicNames.txt"), encoding: String.Encoding.utf8.rawValue) {
                    if let sans: NSString = try? NSString(contentsOfFile: (cacheDirPath as NSString).appendingPathComponent("ShockArrowExists.txt"), encoding: String.Encoding.utf8.rawValue) {
                        if let wmns: NSString = try? NSString(contentsOfFile: (cacheDirPath as NSString).appendingPathComponent("WebMusicIds.txt"), encoding: String.Encoding.utf8.rawValue) {
                            var mnn = 0
                            var san = 0
                            var wmn = 0
                            (mnns as String).enumerateLines {
                                line, stop in
                                mnn += 1
                            }
                            (sans as String).enumerateLines {
                                line, stop in
                                san += 1
                            }
                            (wmns as String).enumerateLines {
                                line, stop in
                                wmn += 1
                            }
                            if mnn != san || san != wmn || wmn != mnn {
                                self.errorHandle2()
                                return
                            }
                            do {
                                try lvns.write(toFile: (libraryDirPath as NSString).appendingPathComponent("MusicListVersion.txt"), atomically: true, encoding: String.Encoding.utf8.rawValue)
                            } catch _ {
                            }
                            do {
                                try mnns.write(toFile: (libraryDirPath as NSString).appendingPathComponent("MusicNames.txt"), atomically: true, encoding: String.Encoding.utf8.rawValue)
                            } catch _ {
                            }
                            do {
                                try sans.write(toFile: (libraryDirPath as NSString).appendingPathComponent("ShockArrowExists.txt"), atomically: true, encoding: String.Encoding.utf8.rawValue)
                            } catch _ {
                            }
                            do {
                                try wmns.write(toFile: (libraryDirPath as NSString).appendingPathComponent("WebMusicIds.txt"), atomically: true, encoding: String.Encoding.utf8.rawValue)
                            } catch _ {
                            }
                        }
                        else {
                            self.errorHandle2()
                            return
                        }
                    }
                    else {
                        self.errorHandle2()
                        return
                    }
                }
                else {
                    self.errorHandle2()
                    return
                }
            }
            else {
                self.errorHandle2()
                return
            }
            
            FileReader.saveLastBootTime()
            
            self.addLog(NSLocalizedString("Wait a while...", comment: "ViewMusicListUpdate"))
            OperationQueue().addOperation({ () -> Void in
                sleep(3)
                DispatchQueue.main.async(execute: {
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                })
            })
            
        })
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        //self.addLog(statusText.text! + "."
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
    }
    
    var mUpdateAvailable: Bool = true
    
    /*
     ダウンロード終了時に呼び出されるデリゲート.
     */
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        let libraryDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        if let data: Data = try? Data(contentsOf: location, options: NSData.ReadingOptions.alwaysMapped) {
            if let dataNS = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                let dataString: String = dataNS as String
                if let url = mRequest.url {
                    switch url {
                    case URL(string: sMusicListVersionTxt)!:
                        if let savedNS = try? NSString(contentsOfFile: (libraryDirPath as NSString).appendingPathComponent("MusicListVersion.txt"), encoding: String.Encoding.utf8.rawValue) {
                            let saved: String = savedNS as String
                            if saved == dataString {
                                mUpdateAvailable = false
                                break
                            }
                        }
                        do {
                            try dataString.write(toFile: (libraryDirPath as NSString).appendingPathComponent("MusicListVersion.txt"), atomically: true, encoding: String.Encoding.utf8)
                        } catch _ {
                        }
                    case URL(string: sMusicNamesTxt)!:
                        do {
                            try dataString.write(toFile: (libraryDirPath as NSString).appendingPathComponent("MusicNames.txt"), atomically: true, encoding: String.Encoding.utf8)
                        } catch _ {
                        }
                    case URL(string: sShockArrowExistsTxt)!:
                        do {
                            try dataString.write(toFile: (libraryDirPath as NSString).appendingPathComponent("ShockArrowExists.txt"), atomically: true, encoding: String.Encoding.utf8)
                        } catch _ {
                        }
                    case URL(string: sWebMusicIdsTxt)!:
                        do {
                            try dataString.write(toFile: (libraryDirPath as NSString).appendingPathComponent("WebMusicIds.txt"), atomically: true, encoding: String.Encoding.utf8)
                        } catch _ {
                        }
                    default:
                        break
                    }
                }
            }
        }
    }
    
    /*
     タスク終了時に呼び出されるデリゲート.
     */
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if error == nil {
        } else {
            mSession.finishTasksAndInvalidate()
            return
        }
        
        if let url = mRequest.url {
            
            switch url {
            case URL(string: sMusicListVersionTxt)!:
                self.addLog(NSLocalizedString("Done.", comment: "ViewMusicListUpdate"))
                if mUpdateAvailable {
                    self.addLog(NSLocalizedString("Downloading Music Information File...", comment: "ViewMusicListUpdate"))
                    mRequest = URLRequest(url: URL(string: sMusicNamesTxt)!)
                    let task: URLSessionDownloadTask = mSession.downloadTask(with: mRequest)
                    task.resume()
                }
                else {
                    self.addLog(NSLocalizedString("No Updates are found.", comment: "ViewMusicListUpdate"))
                    self.addLog(NSLocalizedString("Wait a while...", comment: "ViewMusicListUpdate"))
                    mSession.finishTasksAndInvalidate()
                    OperationQueue().addOperation({ () -> Void in
                        sleep(3)
                        DispatchQueue.main.async(execute: {
                            self.presentingViewController?.dismiss(animated: true, completion: nil)
                        })
                    })
                }
            case URL(string: sMusicNamesTxt)!:
                self.addLog(NSLocalizedString("Done.", comment: "ViewMusicListUpdate"))
                self.addLog(NSLocalizedString("Downloading Shock Arrow Information File...", comment: "ViewMusicListUpdate"))
                mRequest = URLRequest(url: URL(string: sShockArrowExistsTxt)!)
                let task: URLSessionDownloadTask = mSession.downloadTask(with: mRequest)
                task.resume()
            case URL(string: sShockArrowExistsTxt)!:
                self.addLog(NSLocalizedString("Done.", comment: "ViewMusicListUpdate"))
                self.addLog(NSLocalizedString("Downloading Music ID Information File...", comment: "ViewMusicListUpdate"))
                mRequest = URLRequest(url: URL(string: sWebMusicIdsTxt)!)
                let task: URLSessionDownloadTask = mSession.downloadTask(with: mRequest)
                task.resume()
            case URL(string: sWebMusicIdsTxt)!:
                self.addLog(NSLocalizedString("Done.", comment: "ViewMusicListUpdate"))
                self.addLog(NSLocalizedString("Finished.", comment: "ViewMusicListUpdate"))
                mSession.finishTasksAndInvalidate()
                OperationQueue().addOperation({ () -> Void in
                    sleep(3)
                    DispatchQueue.main.async(execute: {
                        self.rparam_ParentView?.refresh()
                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                    })
                })
            default:
                break
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
