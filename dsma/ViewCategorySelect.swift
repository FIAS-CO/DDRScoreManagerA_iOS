//
//  ViewCategorySelect.swift
//  dsm
//
//  Created by LinaNfinE on 6/4/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

class ViewCategorySelect: UIViewController, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate {
    
    var sparam_ParentCategory: String!
    var sparam_Category: String!
    
    var processPool: WKProcessPool!
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var musicListVersionLabel: UILabel!
    
    // セルに表示するテキスト
    let texts = [
        "All Musics",
        "Series Title",
        "ABC",
        "Difficulty",
        "Dance Level",
        "Full Combo Type",
        "My List",
        "Rival",
        "Recent"
    ]
    
    var mIsFirstCheck = true
    var mVersionAlert: MessageAlertView!
    func refresh() {
        
        let infoDictionary = Bundle.main.infoDictionary! as Dictionary
        let appVersion = (infoDictionary["CFBundleShortVersionString"]! as! String) + "." + (infoDictionary["CFBundleVersion"]! as! String)
        let lastAppVer = FileReader.readLastAppVersion()
        FileReader.saveLastAppVersion()
        var waitNext = false
        
        OperationQueue().addOperation({ () -> Void in
            
            if appVersion != lastAppVer {
                waitNext = true
                DispatchQueue.main.async(execute: {
                    self.mVersionAlert = MessageAlertView(title: NSLocalizedString("Version Info", comment: "ViewCategorySelect"), message: "Version: " + appVersion + "\n" + NSLocalizedString("----- Version Information Main Text-----", comment: "ViewCategorySelect"), okAction: MessageAlertViewAction(method: {()->Void in
                        waitNext = false
                    }), cancelAction: nil)
                    self.mVersionAlert.show(self)
                })
            }
            while waitNext {
                usleep(100000)
            }
            DispatchQueue.main.async(execute: {
                var mlExists = false
                self.appVersionLabel.text = appVersion
                self.musicListVersionLabel.text = "Not Exists!"
                let libraryDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
                if let savedNS = try? NSString(contentsOfFile: (libraryDirPath as NSString).appendingPathComponent("MusicListVersion.txt"), encoding: String.Encoding.utf8.rawValue) {
                    let saved: String = savedNS as String
                    mlExists = true
                    self.musicListVersionLabel.text = saved
                }
                
                if self.mIsFirstCheck {
                    self.mIsFirstCheck = false
                    if !mlExists || appVersion != lastAppVer || Date().timeIntervalSince(FileReader.readLastBootTime() as Date) > 24*60*60 {
                        self.present(ViewMusicListUpdate.checkOut(self), animated: true, completion: nil)
                    }
                }
                else {
                    if !mlExists {
                        self.mVersionAlert = MessageAlertView(title: NSLocalizedString("Network error!", comment: "ViewCategorySelect"), message: NSLocalizedString("DDR Score Manager needs to access internet to download music list file on 1st launch. Press OK to retry.", comment: "ViewCategorySelect"), okAction: MessageAlertViewAction(method: {()->Void in
                            self.present(ViewMusicListUpdate.checkOut(self), animated: true, completion: nil)
                        }), cancelAction: nil)
                        self.mVersionAlert.show(self)
                    }
                }
                ///////////// TODO
            })
            
        })
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40 * mMag
    }
    
    // セルの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }
    
    // セルの内容を変更
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        cell.backgroundColor = UIColor(white: 0, alpha: 0.01)
        cell.textLabel?.font = UIFont.systemFont(ofSize: cell.textLabel!.font.pointSize * mMag)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = texts[(indexPath as NSIndexPath).row]
        let cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor = UIColor.blue
        cell.selectedBackgroundView = cellSelectedBgView
        return cell
    }
    
    internal func cellTapAction(_ tableView: UITableView, indexPath: IndexPath) {
        switch texts[(indexPath as NSIndexPath).row] {
        case "All Musics": fallthrough
        case "Recent":
            navigationController?.pushViewController(ViewScoreList.checkOut(texts[(indexPath as NSIndexPath).row], category: texts[(indexPath as NSIndexPath).row], targets: nil, parentScoreList: nil, processPool: self.processPool), animated: true)
        case "My List":
            navigationController?.pushViewController(ViewMyList.checkOut(nil, processPool: self.processPool), animated: true)
        default:
            navigationController?.pushViewController(ViewSubCategorySelect.checkOut(texts[(indexPath as NSIndexPath).row], processPool: self.processPool), animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
    }
    
    let actionSheetTextsSystemB = [
        NSLocalizedString("Preferences", comment: "ViewCategorySelect"),
        NSLocalizedString("Player Status", comment: "ViewCategorySelect"),
        NSLocalizedString("from GATE (simple)", comment: "ViewCategorySelect"),
        NSLocalizedString("DDR SA", comment: "ViewCategorySelect"),
        NSLocalizedString("Manage Rivals", comment: "ViewCategorySelect"),
    ]
    
    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        let pt = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: pt) {
            cellTapAction(tableView, indexPath: indexPath)
        }
    }
    
    var mActionSheet: ActionSheet!
    var mMessageAlertView: MessageAlertView!
    @objc internal func menuButtonTouched(_ sender: UIButton) {
        var texts: [String]
        texts = actionSheetTextsSystemB
        mActionSheet = ActionSheet(title: nil, cancelAction: nil)
        for text in texts {
            var action: (()->Void)
            switch text {
            case NSLocalizedString("Preferences", comment: "ViewCategorySelect"):
                action = { ()->Void in self.present(ViewPreferences.checkOut(nil, processPool: self.processPool), animated: true, completion: nil) }
            case NSLocalizedString("Player Status", comment: "ViewCategorySelect"):
                action = { ()->Void in self.present(ViewPlayerStatus.checkOut(self.processPool), animated: true, completion: nil) }
            case NSLocalizedString("from GATE (simple)", comment: "ViewCategorySelect"):
                action = { ()->Void in
                    self.mMessageAlertView = MessageAlertView(title: NSLocalizedString("from GATE (simple)", comment: "ViewCategorySelect"), message: NSLocalizedString("Load all scores from GATE with no detail data.", comment: "ViewCategorySelect"), okAction: MessageAlertViewAction(method: {()->Void in
                        self.present(ViewFromGateList.checkOut(nil, rivalId: nil, rivalName: nil, processPool: self.processPool), animated: true, completion: nil)
                    }), cancelAction: MessageAlertViewAction(method: {()->Void in }))
                    self.mMessageAlertView.show(self)
                }
            case NSLocalizedString("DDR SA", comment: "ViewCategorySelect"):
                action = { ()->Void in self.present(ViewDdrSa.checkOut(), animated: true, completion: nil) }
            case NSLocalizedString("Manage Rivals", comment: "ViewCategorySelect"):
                action = { ()->Void in self.present(ViewManageRivals.checkOut(nil, listItems: nil, fromMenu: true, processPool: self.processPool), animated: true, completion: nil) }
            default:
                action = { ()->Void in }
            }
            mActionSheet.addAction(ActionSheetAction(title: text, method: action))
        }
        mActionSheet.show(self, barButtonItem: buttonMenu)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPathes = tableView.indexPathsForSelectedRows {
            if let indexPath = indexPathes.first as IndexPath? {
                tableView.deselectRow(at: indexPath, animated: false)
            }
        }
        Admob.shAdView(adHeight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let bb = [UIBarButtonItem](arrayLiteral: buttonMenu)
        navigationController?.navigationBar.topItem?.rightBarButtonItems = bb
        
        refresh()
        
    }
    
    var buttonMenu: UIBarButtonItem!
    
    var mMag: CGFloat = 1
    
    @objc func applicationWillEnterForeground() {
        Admob.shAdView(adHeight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if #available(iOS 8.0, *) {
            processPool = WKProcessPool()
        }
        
        let notifc: NotificationCenter = NotificationCenter.default
        notifc.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        
        let device = UIDevice.current.userInterfaceIdiom
        if device == UIUserInterfaceIdiom.pad {
            mMag = 1.5
        }
        
        buttonMenu = UIBarButtonItem(title: "☰", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ViewCategorySelect.menuButtonTouched(_:)))
        buttonMenu.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24)], for: UIControl.State())
        self.title = "DDR Score Manager A"
        
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            })
        }
        
        adView.addSubview(Admob.getAdBannerView(self))
        
        tableView.indicatorStyle = UIScrollView.IndicatorStyle.white
        tableView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
