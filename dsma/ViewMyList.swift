//
//  ViewMyList.swift
//  dsm
//
//  Created by LinaNfinE on 6/22/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds

class ViewMyList: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate, UIBarPositioningDelegate, GADBannerViewDelegate, UIScrollViewDelegate {
    
    static func checkOut(_ target: UniquePattern?, processPool: WKProcessPool) -> (ViewMyList) {
        if target == nil {
            let storyboard = UIStoryboard(name: "ViewMyList_Select", bundle: nil)
            let ret = storyboard.instantiateInitialViewController() as! ViewMyList
            ret.rparam_ProcessPool = processPool
            return ret
        }
        else {
            let storyboard = UIStoryboard(name: "ViewMyList_Add", bundle: nil)
            let ret = storyboard.instantiateInitialViewController() as! ViewMyList
            ret.rparam_AddTarget = target
            ret.rparam_ProcessPool = processPool
            return ret
        }
    }
    
    var rparam_AddTarget: UniquePattern!
    var rparam_ProcessPool: WKProcessPool!
    
    var sparam_ParentCategory: String!
    var sparam_Category: String!
    
    var mEditingMyListId: Int32 = -1
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    
    @IBOutlet weak var naviTitle: UINavigationItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    // セルに表示するテキスト
    //let texts = ["All Musics", "Series Title", "ABC", "Difficulty", "Dance Level", "Full Combo Type", "My List", "Rival", "Recent"]
    var mMyListNames: [String] = []
    
    var mScrollDecelerating = false
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        mScrollDecelerating = true
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        mScrollDecelerating = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40 * mMag
    }
    
    // セルの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mMyListNames.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // セルの内容を変更
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        cell.editingAccessoryType = UITableViewCell.AccessoryType.none
        //cell.accessoryType = rparam_AddTarget != nil ? UITableViewCellAccessoryType.None : UITableViewCellAccessoryType.DisclosureIndicator
        cell.backgroundColor = UIColor(white: 0, alpha: 0.01)
        cell.textLabel?.font = UIFont.systemFont(ofSize: cell.textLabel!.font.pointSize * mMag)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = mMyListNames[(indexPath as NSIndexPath).row]
        let cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor = UIColor.blue
        cell.selectedBackgroundView = cellSelectedBgView
        return cell
    }
    
    var mTextAlertView: TextAlertView!
    internal func cellTapAction(_ tableView: UITableView, indexPath: IndexPath) {
        if tableView.isEditing {
            mEditingMyListId = Int32((indexPath as NSIndexPath).row)
            mTextAlertView = TextAlertView(title: NSLocalizedString("My List Name", comment: "ViewMyList"), message: NSLocalizedString("Input mylist name and press OK.", comment: "ViewMyList"), placeholder: "My List Name",defaultText: FileReader.readMyListName(mEditingMyListId)!, kbd: UIKeyboardType.default, okAction: TextAlertViewAction(method: {(text)->Void in
                FileReader.saveMyListName(self.mEditingMyListId, name: text)
                self.refreshAll()
            }), cancelAction: TextAlertViewAction(method: {(text)->Void in
                self.tableView.deselectRow(at: indexPath, animated: true)
            }))
            mTextAlertView.show(self)
        }
        else {
            if rparam_AddTarget != nil {
                var mylist = FileReader.readMyList(Int32((indexPath as NSIndexPath).row))
                mylist.append(rparam_AddTarget)
                FileReader.saveMyList(Int32((indexPath as NSIndexPath).row), list: mylist)
                //presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                presentingViewController?.dismiss(animated: true, completion: nil)
            }
            else {
                navigationController?.pushViewController(ViewScoreList.checkOut("My List", category: (indexPath as NSIndexPath).row.description, targets: nil, parentScoreList: nil, processPool: self.rparam_ProcessPool), animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        let pt = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: pt) {
            if tableView.isEditing && indexPath.row != 0 && pt.x < 47 {
                return
            }
            //tableView.deselectRowAtIndexPath(indexPath, animated: true)
            cellTapAction(tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            FileReader.deleteMyList(Int32((indexPath as NSIndexPath).row))
            mMyListNames.remove(at: (indexPath as NSIndexPath).row)
            tableView.reloadData()
        default:
            return
        }
    }
    
    @objc internal func editButtonTouched(_ sender: UIButton) {
        if rparam_AddTarget == nil {
            let bb = [UIBarButtonItem](arrayLiteral: buttonDone, buttonAdd)
            navigationController?.navigationBar.topItem?.rightBarButtonItems = bb
            tableView.setEditing(true, animated: true)
        }
        else {
            let bb = [UIBarButtonItem](arrayLiteral: buttonDone, buttonAdd)
            navigationBar.topItem?.rightBarButtonItems = bb
            tableView.setEditing(true, animated: true)
            let bl = [UIBarButtonItem]()
            navigationBar.topItem?.leftBarButtonItems = bl
        }
    }
    
    @objc internal func doneButtonTouched(_ sender: UIButton) {
        if rparam_AddTarget == nil {
            let bb = [UIBarButtonItem](arrayLiteral: buttonEdit)
            navigationController?.navigationBar.topItem?.rightBarButtonItems = bb
            tableView.setEditing(false, animated: true)
        }
        else {
            let bb = [UIBarButtonItem](arrayLiteral: buttonEdit)
            navigationBar.topItem?.rightBarButtonItems = bb
            tableView.setEditing(false, animated: true)
            let bl = [UIBarButtonItem](arrayLiteral: buttonCancel)
            navigationBar.topItem?.leftBarButtonItems = bl
        }
    }
    
    @objc internal func addButtonTouched(_ sender: UIButton) {
        let id: Int32 = Int32(mMyListNames.count)
        FileReader.saveMyListCount(id+1)
        FileReader.saveMyListName(id, name: "MyList_"+id.description)
        FileReader.saveMyList(id, list: [UniquePattern]())
        mMyListNames.append("MyList_"+id.description)
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: mMyListNames.count-1, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
    }
    
    @objc internal func cancelButtonTouched(_ sender: UIButton) {
        //presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func refreshAll() {
        
        let count = FileReader.readMyListCount()
        
        mMyListNames.removeAll(keepingCapacity: true)
        for i: Int32 in 0 ..< count {
            mMyListNames.append(FileReader.readMyListName(i)!)
        }
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        Admob.shAdView(adHeight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if rparam_AddTarget == nil {
            let bb = [UIBarButtonItem](arrayLiteral: buttonEdit)
            navigationController?.navigationBar.topItem?.rightBarButtonItems = bb
        }
        else {
            let bb = [UIBarButtonItem](arrayLiteral: buttonEdit)
            navigationBar.topItem?.rightBarButtonItems = bb
            let bl = [UIBarButtonItem](arrayLiteral: buttonCancel)
            navigationBar.topItem?.leftBarButtonItems = bl
            let nvFrame: CGRect = navigationBar.frame;
            tableView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height, left: 0, bottom: 0, right: 0)
        }
    }
    
    var buttonEdit: UIBarButtonItem!
    var buttonDone: UIBarButtonItem!
    var buttonAdd: UIBarButtonItem!
    var buttonCancel: UIBarButtonItem!
    
    var mMag: CGFloat = 1
    
    @objc func applicationWillEnterForeground() {
        Admob.shAdView(adHeight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let notifc: NotificationCenter = NotificationCenter.default
        notifc.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        
        let device = UIDevice.current.userInterfaceIdiom
        if device == UIUserInterfaceIdiom.pad {
            mMag = 1.5
        }
        
        buttonEdit = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(ViewMyList.editButtonTouched(_:)))
        buttonDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(ViewMyList.doneButtonTouched(_:)))
        buttonAdd = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(ViewMyList.addButtonTouched(_:)))
        buttonCancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(ViewMyList.cancelButtonTouched(_:)))
        if rparam_AddTarget == nil {
            self.title = "My List"
        }
        else {
            naviTitle.title = NSLocalizedString("Select My List", comment: "ViewMyList")
            let nvFrame: CGRect = navigationBar.frame;
            tableView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height, left: 0, bottom: 0, right: 0)
            navigationBar.delegate = self
        }
        adView.addSubview(Admob.getAdBannerView(self))
        
        refreshAll()
        
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
