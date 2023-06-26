//
//  ViewMenuRival.swift
//  dsm
//
//  Created by LinaNfinE on 7/13/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

// ViewMenuRival is deprecated!!

import UIKit
import WebKit
import GoogleMobileAds

class ViewMenuRival: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, GADBannerViewDelegate, UIScrollViewDelegate {
    
    static func checkOut(_ parentView: ViewScoreList?, listItems: [UniquePattern]?, rivalNo: Int, processPool: WKProcessPool) -> (ViewMenuRival) {
        let storyboard = UIStoryboard(name: "ViewMenuRival", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! ViewMenuRival
        ret.rparam_ParentView = parentView
        ret.rparam_ListItems = listItems
        ret.rparam_RivalNo = rivalNo
        ret.rparam_ProcessPool = processPool
        return ret
    }
    
    var rparam_ParentView: ViewScoreList!
    var rparam_ListItems: [UniquePattern]!
    var rparam_RivalNo: Int!
    var rparam_ProcessPool: WKProcessPool!
    
    let sTagAlertEditRivalName = 1
    let sTagAlertEditRivalId = 2
    
    var mAlertTmpString: String = ""
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    var mScrollDecelerating = false
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        mScrollDecelerating = true
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        mScrollDecelerating = false
    }
    
    func showEditAlert(_ tag: Int, title: String, message: String, placeholder: String?, defaultText: String, kbd: UIKeyboardType) {
        /*
        let alert: UIAlertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
        alert.alertViewStyle = UIAlertViewStyle.plainTextInput
        alert.tag = tag
        alert.textField(at: 0)?.keyboardType = kbd
        alert.textField(at: 0)?.placeholder = placeholder
        alert.textField(at: 0)?.text = defaultText
        alert.show()
        */
        TextAlertView(title: title, message: message, placeholder: placeholder, defaultText: defaultText, kbd: kbd, okAction: TextAlertViewAction(method: {(text)->Void in
            self.mAlertTmpString = text
            if self.mAlertTmpString.count == 0 {
                MessageAlertView(title: NSLocalizedString("Error", comment: "ViewMenuRival"), message: NSLocalizedString("Rival Name is empty.", comment: "ViewMenuRival")).show(self)
                return
            }
            let list = FileReader.readRivalList()
            TextAlertView(title: NSLocalizedString("Rival DDR Code", comment: "ViewMenuRival"), message: NSLocalizedString("2. Input rival DDR Code (8 digit number).", comment: "ViewMenuRival"), placeholder: "000000000", defaultText: list[self.rparam_RivalNo].Id, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
                if text.count == 8 {
                    if let _ = Int(text) {
                        var list = FileReader.readRivalList()
                        list[self.rparam_RivalNo] = RivalData(Id: text, Name: self.mAlertTmpString)
                        FileReader.saveRivalList(list)
                        self.title = self.mAlertTmpString + " (" + text + ")"
                        return
                    }
                }
                MessageAlertView(title: NSLocalizedString("Error", comment: "ViewMenuRival"), message: NSLocalizedString("DDR Code requires 8 digit number.", comment: "ViewMenuRival")).show(self)
            }), cancelAction: nil).show(self)
        }), cancelAction: nil).show(self)
    }
    /*
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == alertView.cancelButtonIndex {
            return
        }
        switch alertView.tag {
        case sTagAlertEditRivalName:
            mAlertTmpString = alertView.textField(at: 0)!.text!
            if mAlertTmpString.count == 0 {
                let alert: UIAlertView = UIAlertView(title: NSLocalizedString("Error", comment: "ViewMenuRival"), message: NSLocalizedString("Rival Name is empty.", comment: "ViewMenuRival"), delegate: self, cancelButtonTitle: "OK")
                alert.alertViewStyle = UIAlertViewStyle.default
                alert.show()
                break
            }
            let list = FileReader.readRivalList()
            showEditAlert(sTagAlertEditRivalId, title: NSLocalizedString("Rival DDR Code", comment: "ViewMenuRival"), message: NSLocalizedString("2. Input rival DDR Code (8 digit number).", comment: "ViewMenuRival"), placeholder: "000000000", defaultText: list[rparam_RivalNo].Id, kbd: UIKeyboardType.numberPad)
        case sTagAlertEditRivalId:
            let text: String = alertView.textField(at: 0)!.text!
            if text.count == 8 {
                if let _ = Int(text) {
                    var list = FileReader.readRivalList()
                    list[rparam_RivalNo] = RivalData(Id: alertView.textField(at: 0)!.text!, Name: mAlertTmpString)
                    FileReader.saveRivalList(list)
                    self.title = mAlertTmpString + " (" + alertView.textField(at: 0)!.text! + ")"
                    break
                }
            }
            let alert: UIAlertView = UIAlertView(title: NSLocalizedString("Error", comment: "ViewMenuRival"), message: NSLocalizedString("DDR Code requires 8 digit number.", comment: "ViewMenuRival"), delegate: self, cancelButtonTitle: "OK")
            alert.alertViewStyle = UIAlertViewStyle.default
            alert.show()
        default:
            break
        }
    }
    */
    // セルに表示するテキスト
    let texts = [
        NSLocalizedString("from GATE (simple)", comment: "ViewMenuRival"),
        NSLocalizedString("from GATE (detail)", comment: "ViewMenuRival"),
        NSLocalizedString("Edit code & name", comment: "ViewMenuRival"),
    ]
    let detailTexts = [
        NSLocalizedString("Get all scores with no detail data.", comment: "ViewMenuRival"),
        NSLocalizedString("Get listed item scores from GATE", comment: "ViewMenuRival"),
        "",
    ]
    
    // セルの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }
    
    // セルの内容を変更
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        cell.backgroundColor = UIColor(white: 0, alpha: 0.01)
        //cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = texts[(indexPath as NSIndexPath).row]
        cell.detailTextLabel?.textColor = UIColor.lightGray
        cell.detailTextLabel?.text = detailTexts[(indexPath as NSIndexPath).row]
        let cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor = UIColor.blue
        cell.selectedBackgroundView = cellSelectedBgView
        return cell
    }
    
    internal func cellTapAction(_ tableView: UITableView, indexPath: IndexPath) {
        switch texts[(indexPath as NSIndexPath).row] {
        case NSLocalizedString("from GATE (simple)", comment: "ViewMenuRival"):
            let list = FileReader.readRivalList()
            present(ViewFromGateList.checkOut(rparam_ParentView, rivalId: list[rparam_RivalNo].Id, rivalName: list[rparam_RivalNo].Name, processPool: self.rparam_ProcessPool), animated: true, completion: nil)
        case NSLocalizedString("from GATE (detail)", comment: "ViewMenuRival"):
            let list = FileReader.readRivalList()
            let musics = FileReader.readMusicList()
            present(ViewFromGate.checkOut(rparam_ParentView, musics: musics, targets: rparam_ListItems, rivalId: list[rparam_RivalNo].Id, rivalName: list[rparam_RivalNo].Name, processPool: self.rparam_ProcessPool), animated: true, completion: nil)
        case NSLocalizedString("Edit code & name", comment: "ViewMenuRival"):
            let list = FileReader.readRivalList()
            showEditAlert(sTagAlertEditRivalName, title: NSLocalizedString("Rival Name", comment: "ViewMenuRival"), message: NSLocalizedString("1. Input rival Name.", comment: "ViewMenuRival"), placeholder: "Rival Name", defaultText: list[rparam_RivalNo].Name, kbd: UIKeyboardType.asciiCapable)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        let pt = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: pt) {
            cellTapAction(tableView, indexPath: indexPath)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPathes = tableView.indexPathsForSelectedRows {
            if let indexPath = indexPathes.first as IndexPath? {
                tableView.deselectRow(at: indexPath, animated: false)
            }
        }
        Admob.shAdView(adHeight)
    }
    
    @objc func applicationWillEnterForeground() {
        Admob.shAdView(adHeight)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let notifc: NotificationCenter = NotificationCenter.default
        notifc.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        
        let rv = FileReader.readRivalList()[rparam_RivalNo]
        self.title = rv.Name + " (" + rv.Id + ")"
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

