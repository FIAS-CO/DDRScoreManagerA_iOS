//
//  ViewSortList.swift
//  dsm
//
//  Created by LinaNfinE on 6/17/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds

class ViewManageRivals: UIViewController, UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate, UIScrollViewDelegate {
    
    static func checkOut(_ parentView: ViewScoreList?, listItems: [UniquePattern]?, fromMenu: Bool, processPool: WKProcessPool) -> (UINavigationController) {
        let storyboard = UIStoryboard(name: "ViewManageRivals", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! UINavigationController
        let target = ret.visibleViewController as! ViewManageRivals
        target.rparam_ParentView = parentView
        target.rparam_ListItems = listItems
        target.rparam_FromMenu = fromMenu
        target.rparam_ProcessPool = processPool
        return ret
    }
    
    var rparam_ParentView: ViewScoreList!
    var rparam_ListItems: [UniquePattern]!
    var rparam_FromMenu: Bool!
    var rparam_ProcessPool: WKProcessPool!
    
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
    
    var mRivalList: [RivalData] = []
    var mActiveRivalNo: Int = 0
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40 * mMag
    }
    
    // セルの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mRivalList.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath as NSIndexPath).row < 2 {
            return false
        }
        return true
    }
    
    // セルの内容を変更
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        cell.editingAccessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        if mActiveRivalNo == (indexPath as NSIndexPath).row {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        cell.backgroundColor = UIColor(white: 0, alpha: 0.01)
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.systemFont(ofSize: cell.textLabel!.font.pointSize * mMag)
        cell.textLabel?.text = mRivalList[(indexPath as NSIndexPath).row].Name
        cell.detailTextLabel?.text = (indexPath as NSIndexPath).row < 2 ? "" : mRivalList[(indexPath as NSIndexPath).row].Id
        let cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor = UIColor.blue
        cell.selectedBackgroundView = cellSelectedBgView
        return cell
    }
    
    let actionSheetTextsRivalMenu = [
        NSLocalizedString("from GATE (simple)", comment: "ViewManageRivals"),
        NSLocalizedString("from GATE (detail)", comment: "ViewManageRivals"),
        NSLocalizedString("Edit code & name", comment: "ViewManageRivals"),
    ]
    let actionSheetTextsRivalMenuDetail = [
        NSLocalizedString("Get all scores with no detail data.", comment: "ViewManageRivals"),
        NSLocalizedString("Get listed item scores from GATE", comment: "ViewManageRivals"),
        "",
    ]
    
    let actionSheetTextsOldDdrSmScore = [
        NSLocalizedString("Read from clipboard", comment: "ViewManageRivals"),
    ]
    
    var mActionSheet: ActionSheet!
    var mTextAlertView: TextAlertView!
    var mMessageAlertView: MessageAlertView!
    internal func cellTapAction(_ tableView: UITableView, indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row != 0 {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.none)
        }
        if tableView.isEditing {
            if (indexPath as NSIndexPath).row > 1 {
                var texts: [String]
                texts = actionSheetTextsRivalMenu
                mActionSheet = ActionSheet(title: mRivalList[(indexPath as NSIndexPath).row].Name, cancelAction: {()->Void in self.tableView.deselectRow(at: indexPath, animated: true)})
                for text in texts {
                    var action: (()->Void)
                    switch text {
                    case NSLocalizedString("from GATE (simple)", comment: "ViewManageRivals"):
                        action = { ()->Void in
                            self.mMessageAlertView = MessageAlertView(title: NSLocalizedString("from GATE (simple)", comment: "ViewManageRivals"), message: NSLocalizedString("Load active rival's all scores from GATE with no detail data.", comment: "ViewManageRivals"), okAction: MessageAlertViewAction(method: {()->Void in
                                self.present(ViewFromGateList.checkOut(self.rparam_ParentView, rivalId: self.mRivalList[(indexPath as NSIndexPath).row].Id, rivalName: self.mRivalList[(indexPath as NSIndexPath).row].Name, processPool: self.rparam_ProcessPool), animated: true, completion: nil)
                            }), cancelAction: MessageAlertViewAction(method: {()->Void in self.tableView.deselectRow(at: indexPath, animated: true)}))
                            self.mMessageAlertView.show(self)
                        }
                    case NSLocalizedString("from GATE (detail)", comment: "ViewManageRivals"):
                        if self.rparam_ListItems == nil {
                            continue
                        }
                        action = { ()->Void in
                            self.mMessageAlertView = MessageAlertView(title: NSLocalizedString("from GATE (detail)", comment: "ViewManageRivals"), message: NSLocalizedString("Load active rival's scores listed from GATE with detail data.", comment: "ViewManageRivals"), okAction: MessageAlertViewAction(method: {()->Void in
                                let musics = FileReader.readMusicList()
                                self.present(ViewFromGate.checkOut(self.rparam_ParentView, musics: musics, targets: self.rparam_ListItems, rivalId: self.mRivalList[(indexPath as NSIndexPath).row].Id, rivalName: self.mRivalList[(indexPath as NSIndexPath).row].Name, processPool: self.rparam_ProcessPool), animated: true, completion: nil)
                            }), cancelAction: MessageAlertViewAction(method: {()->Void in self.tableView.deselectRow(at: indexPath, animated: true)}))
                            self.mMessageAlertView.show(self)
                        }
                    case NSLocalizedString("Edit code & name", comment: "ViewManageRivals"):
                        action = { ()->Void in
                            self.mTextAlertView = TextAlertView(title: NSLocalizedString("Rival Name", comment: "ViewMenuRival"), message: NSLocalizedString("1. Input rival Name.", comment: "ViewMenuRival"), placeholder: "Rival Name", defaultText: self.mRivalList[(indexPath as NSIndexPath).row].Name, kbd: UIKeyboardType.asciiCapable, okAction: TextAlertViewAction(method: {(text)->Void in
                                let prevStr = text
                                if prevStr.count == 0 {
                                    let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewManageRivals"), message: NSLocalizedString("Rival Name is empty.", comment: "ViewManageRivals"))
                                    alert.show(self)
                                    return
                                }
                                self.mTextAlertView = TextAlertView(title: NSLocalizedString("Rival DDR Code", comment: "ViewManageRivals"), message: NSLocalizedString("2. Input rival DDR Code (8 digit number).", comment: "ViewManageRivals"), placeholder: "000000000", defaultText: self.mRivalList[(indexPath as NSIndexPath).row].Id, kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
                                    if text.count == 8 {
                                        if let _ = Int(text) {
                                            self.mRivalList[(indexPath as NSIndexPath).row] = RivalData(Id: text, Name: prevStr)
                                            FileReader.saveRivalList(self.mRivalList)
                                            self.refreshAll()
                                            return
                                        }
                                    }
                                    let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewManageRivals"), message: NSLocalizedString("DDR Code requires 8 digit number.", comment: "ViewManageRivals"))
                                    alert.show(self)
                                }), cancelAction: TextAlertViewAction(method: {(text)->Void in
                                    self.tableView.deselectRow(at: indexPath, animated: true)
                                }))
                                self.mTextAlertView.show(self)
                            }), cancelAction: TextAlertViewAction(method: {(text)->Void in
                                self.tableView.deselectRow(at: indexPath, animated: true)
                            }))
                            self.mTextAlertView.show(self)
                        }
                    default:
                        action = { ()->Void in }
                    }
                    mActionSheet.addAction(ActionSheetAction(title: text, method: action))
                }
                mActionSheet.show(self, sourceView: self.view, sourceRect: tableView.convert(tableView.rectForRow(at: indexPath), to: tableView.superview))
            }
            else if (indexPath as NSIndexPath).row == 1 {
                var texts: [String]
                texts = actionSheetTextsOldDdrSmScore
                
                mActionSheet = ActionSheet(title: mRivalList[(indexPath as NSIndexPath).row].Name, cancelAction: {()->Void in self.tableView.deselectRow(at: indexPath, animated: true)})
                for text in texts {
                    var action: (()->Void)
                    switch text {
                    case NSLocalizedString("Read from clipboard", comment: "ViewManageRivals"):
                        action = { ()->Void in
                            self.mMessageAlertView = MessageAlertView(title: NSLocalizedString("Read from clipboard", comment: "ViewManageRivals"), message: NSLocalizedString("You can use scoredata from DDR Score Manager 2013 (old DDR SM version). On old score manager,\"Menu\"->\"Preferences\"->\"Import/Export\"->\"Copy score database\". And import on this menu.", comment: "ViewManageRivals"), okAction: MessageAlertViewAction(method: {()->Void in
                                let clip = UIPasteboard.general
                                let scoreText = clip.value(forPasteboardType: "public.utf8-plain-text") as! String
                                let scores = FileReader.scoreFromScoreDb(scoreText)
                                if scores.count > 0 {
                                    let _ = FileReader.saveScoreList("00000000", scores: scores)
                                    self.mMessageAlertView = MessageAlertView(title: NSLocalizedString("Succeed", comment: "ViewManageRivals"), message: NSLocalizedString("Import completed.", comment: "ViewManageRivals"), okAction: MessageAlertViewAction(method: {()->Void in }), cancelAction: nil)
                                    self.mMessageAlertView.show(self)
                                    FileReader.saveActiveRivalNo((indexPath as NSIndexPath).row)
                                }
                                else {
                                    self.mMessageAlertView = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewManageRivals"), message: NSLocalizedString("No scores detected from clipboard.", comment: "ViewManageRivals"), okAction: MessageAlertViewAction(method: {()->Void in }), cancelAction: nil)
                                    self.mMessageAlertView.show(self)
                                }
                                self.tableView.deselectRow(at: indexPath, animated: true)
                            }), cancelAction: MessageAlertViewAction(method: {()->Void in self.tableView.deselectRow(at: indexPath, animated: true)}))
                            self.mMessageAlertView.show(self)
                        }
                    default:
                        action = { ()->Void in }
                    }
                    mActionSheet.addAction(ActionSheetAction(title: text, method: action))
                }
                mActionSheet.show(self, sourceView: self.view, sourceRect: tableView.convert(tableView.rectForRow(at: indexPath), to: tableView.superview))
            }
        }
        else {
            if (indexPath as NSIndexPath).row == 1 {
                let scores = FileReader.readScoreList("00000000")
                if scores.count == 0 {
                    self.mMessageAlertView = MessageAlertView(title: NSLocalizedString("Read from clipboard", comment: "ViewManageRivals"), message: NSLocalizedString("You can use scoredata from DDR Score Manager 2013 (old DDR SM version). On old score manager,\"Menu\"->\"Preferences\"->\"Import/Export\"->\"Copy score database\". And import on this menu.", comment: "ViewManageRivals"), okAction: MessageAlertViewAction(method: {()->Void in
                        let clip = UIPasteboard.general
                        if let scoreText = clip.value(forPasteboardType: "public.utf8-plain-text") as? String {
                            let scores = FileReader.scoreFromScoreDb(scoreText)
                            if scores.count > 0 {
                                let _ = FileReader.saveScoreList("00000000", scores: scores)
                                self.mMessageAlertView = MessageAlertView(title: NSLocalizedString("Succeed", comment: "ViewManageRivals"), message: NSLocalizedString("Import completed.", comment: "ViewManageRivals"), okAction: MessageAlertViewAction(method: {()->Void in }), cancelAction: nil)
                                self.mMessageAlertView.show(self)
                                FileReader.saveActiveRivalNo((indexPath as NSIndexPath).row)
                            }
                            else {
                                self.mMessageAlertView = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewManageRivals"), message: NSLocalizedString("No scores detected from clipboard.", comment: "ViewManageRivals"), okAction: MessageAlertViewAction(method: {()->Void in }), cancelAction: nil)
                                self.mMessageAlertView.show(self)
                            }
                        }
                        else {
                            self.mMessageAlertView = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewManageRivals"), message: NSLocalizedString("No scores detected from clipboard.", comment: "ViewManageRivals"), okAction: MessageAlertViewAction(method: {()->Void in }), cancelAction: nil)
                            self.mMessageAlertView.show(self)
                        }
                        self.tableView.deselectRow(at: indexPath, animated: true)
                    }), cancelAction: MessageAlertViewAction(method: {()->Void in self.tableView.deselectRow(at: indexPath, animated: true)}))
                    self.mMessageAlertView.show(self)
                }
                else {
                    FileReader.saveActiveRivalNo((indexPath as NSIndexPath).row)
                    refreshAll()
                }
            }
            else {
                FileReader.saveActiveRivalNo((indexPath as NSIndexPath).row)
                refreshAll()
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    var mDeleteShow = false
    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        let pt = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: pt) {
            if tableView.isEditing && (indexPath as NSIndexPath).row > 1 {
                if pt.x < 47 {
                    mDeleteShow = true
                    return
                }
                if mDeleteShow {
                    mDeleteShow = false
                    return
                }
            }
            mDeleteShow = false
            cellTapAction(tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            mRivalList.remove(at: (indexPath as NSIndexPath).row)
            FileReader.saveRivalList(mRivalList)
            refreshAll()
        default:
            return
        }
    }
    
    @objc internal func editButtonTouched(_ sender: UIButton) {
        let bb = [UIBarButtonItem](arrayLiteral: buttonDone, buttonAdd, buttonRefresh)
        navigationController?.navigationBar.topItem?.rightBarButtonItems = bb
        let bl = [UIBarButtonItem]()
        navigationController?.navigationBar.topItem?.leftBarButtonItems = bl
        tableView.setEditing(true, animated: true)
    }
    
    @objc internal func doneButtonTouched(_ sender: UIButton) {
        let bb = [UIBarButtonItem](arrayLiteral: buttonEdit)
        navigationController?.navigationBar.topItem?.rightBarButtonItems = bb
        let bl = [UIBarButtonItem](arrayLiteral: buttonStop)
        navigationController?.navigationBar.topItem?.leftBarButtonItems = bl
        tableView.setEditing(false, animated: true)
    }
    
    @objc internal func addButtonTouched(_ sender: UIButton) {
        self.mTextAlertView = TextAlertView(title: NSLocalizedString("Rival Name", comment: "ViewMenuRival"), message: NSLocalizedString("1. Input rival Name.", comment: "ViewMenuRival"), placeholder: "Rival Name", defaultText: "", kbd: UIKeyboardType.asciiCapable, okAction: TextAlertViewAction(method: {(text)->Void in
            let prevStr = text
            if prevStr.count == 0 {
                let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewManageRivals"), message: NSLocalizedString("Rival Name is empty.", comment: "ViewManageRivals"))
                alert.show(self)
                return
            }
            self.mTextAlertView = TextAlertView(title: NSLocalizedString("Rival DDR Code", comment: "ViewManageRivals"), message: NSLocalizedString("2. Input rival DDR Code (8 digit number).", comment: "ViewManageRivals"), placeholder: "000000000", defaultText: "", kbd: UIKeyboardType.numberPad, okAction: TextAlertViewAction(method: {(text)->Void in
                if text.count == 8 {
                    if text == "00000000" {
                        let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewManageRivals"), message: NSLocalizedString("Invalid DDR Code.", comment: "ViewManageRivals"))
                        alert.show(self)
                        return
                    }
                    if let _ = Int(text) {
                        self.mRivalList.append(RivalData(Id: text, Name: prevStr))
                        FileReader.saveRivalList(self.mRivalList)
                        self.refreshAll()
                        return
                    }
                }
                let alert = MessageAlertView(title: NSLocalizedString("Error", comment: "ViewManageRivals"), message: NSLocalizedString("DDR Code requires 8 digit number.", comment: "ViewManageRivals"))
                alert.show(self)
            }), cancelAction: nil)
            self.mTextAlertView.show(self)
        }), cancelAction: nil)
        self.mTextAlertView.show(self)
    }
    
    @objc internal func refreshButtonTouched(_ sender: UIButton) {
        present(ViewFromGateRivalList.checkOut(self, processPool: self.rparam_ProcessPool), animated: true, completion: nil)
    }
    
    @objc internal func stopButtonTouched(_ sender: UIButton) {
        rparam_ParentView?.refreshAll()
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshAll()
        if !tableView.isEditing {
            let bb = [UIBarButtonItem](arrayLiteral: buttonEdit)
            navigationController?.navigationBar.topItem?.rightBarButtonItems = bb
            let bl = [UIBarButtonItem](arrayLiteral: buttonStop)
            navigationController?.navigationBar.topItem?.leftBarButtonItems = bl
        }
        if let indexPathes = tableView.indexPathsForSelectedRows {
            if let indexPath = indexPathes.first as IndexPath? {
                tableView.deselectRow(at: indexPath, animated: false)
            }
        }
        Admob.shAdView(adHeight)
    }
    
    var buttonEdit: UIBarButtonItem!
    var buttonDone: UIBarButtonItem!
    var buttonAdd: UIBarButtonItem!
    var buttonRefresh: UIBarButtonItem!
    var buttonStop: UIBarButtonItem!
    
    var mMag: CGFloat = 1
    
    func refreshAll() {
        mRivalList.removeAll(keepingCapacity: true)
        mActiveRivalNo = FileReader.readActiveRivalNo()
        mRivalList = FileReader.readRivalList()
        mRivalList[0].Name = NSLocalizedString("Display my scores only", comment: "ViewManageRivals")
        mRivalList[1].Name = NSLocalizedString("Scores from old DDR SM", comment: "ViewManageRivals")
        tableView.reloadData()
    }
    
    @objc func applicationWillEnterForeground() {
        Admob.shAdView(adHeight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let notifc: NotificationCenter = NotificationCenter.default
        notifc.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        
        buttonEdit = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(ViewManageRivals.editButtonTouched(_:)))
        buttonDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(ViewManageRivals.doneButtonTouched(_:)))
        buttonAdd = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(ViewManageRivals.addButtonTouched(_:)))
        buttonRefresh = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(ViewManageRivals.refreshButtonTouched(_:)))
        buttonStop = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(ViewManageRivals.stopButtonTouched(_:)))
        
        let device = UIDevice.current.userInterfaceIdiom
        if device == UIUserInterfaceIdiom.pad {
            mMag = 1.5
        }
        
        self.title = NSLocalizedString("Manage Rivals", comment: "ViewManageRivals")
        adView.addSubview(Admob.getAdBannerView(self))
        
        tableView.allowsSelectionDuringEditing = true
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
