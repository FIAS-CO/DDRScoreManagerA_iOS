//
//  ViewSortList.swift
//  dsm
//
//  Created by LinaNfinE on 6/17/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewSortList: UIViewController, UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate, UIScrollViewDelegate {
    
    static func checkOut(_ parentView: ViewScoreList?) -> (UINavigationController) {
        let storyboard = UIStoryboard(name: "ViewSortList", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! UINavigationController
        let target = ret.visibleViewController as! ViewSortList
        target.rparam_ParentView = parentView
        return ret
    }
    
    var rparam_ParentView: ViewScoreList!
    
    //var sortShowing: Bool = false
    //var sparam_SortId: Int32!
    
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
    
    // セルに表示するテキスト
    //let texts = ["All Musics", "Series Title", "ABC", "Difficulty", "Dance Level", "Full Combo Type", "My List", "Rival", "Recent"]
    var mSortNames: [String] = []
    var mActiveSortId: Int32!
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40 * mMag
    }

    // セルの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mSortNames.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath as NSIndexPath).row == 0 {
            return false
        }
        return true
    }
    
    // セルの内容を変更
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        cell.editingAccessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        if Int(mActiveSortId) == (indexPath as NSIndexPath).row {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        cell.backgroundColor = UIColor(white: 0, alpha: 0.01)
        cell.textLabel?.font = UIFont.systemFont(ofSize: cell.textLabel!.font.pointSize * mMag)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = mSortNames[(indexPath as NSIndexPath).row]
        let cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor = UIColor.blue
        cell.selectedBackgroundView = cellSelectedBgView
        return cell
    }
    
    internal func cellTapAction(_ tableView: UITableView, indexPath: IndexPath) {
        if tableView.isEditing {
            if (indexPath as NSIndexPath).row != 0 {
                //sortShowing = true
                //sparam_SortId = Int32(indexPath.row)
                //var btn: UIBarButtonItem = UIBarButtonItem()
                //btn.title = "Sorts"
                //navigationItem.backBarButtonItem = btn
                //performSegueWithIdentifier("showSortSetting",sender: nil)
                self.navigationController?.pushViewController(ViewSortSetting.checkOut(self, sortId: Int32((indexPath as NSIndexPath).row)), animated: true)
            }
        }
        else {
            FileReader.saveActiveSortId(Int32((indexPath as NSIndexPath).row))
            refreshAll()
            rparam_ParentView?.refreshAll()
            //presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            presentingViewController?.dismiss(animated: true, completion: nil)
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
            if tableView.isEditing && (indexPath as NSIndexPath).row != 0 {
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
            FileReader.deleteSort(Int32((indexPath as NSIndexPath).row))
            mSortNames.remove(at: (indexPath as NSIndexPath).row)
            tableView.reloadData()
        default:
            return
        }
    }
    
    @objc internal func editButtonTouched(_ sender: UIButton) {
        let bb = [UIBarButtonItem](arrayLiteral: buttonDone, buttonAdd)
        navigationController?.navigationBar.topItem?.rightBarButtonItems = bb
        tableView.setEditing(true, animated: true)
    }
    
    @objc internal func doneButtonTouched(_ sender: UIButton) {
        let bb = [UIBarButtonItem](arrayLiteral: buttonEdit)
        navigationController?.navigationBar.topItem?.rightBarButtonItems = bb
        tableView.setEditing(false, animated: true)
    }
    
    @objc internal func addButtonTouched(_ sender: UIButton) {
        let id: Int32 = Int32(mSortNames.count)
        FileReader.saveSortCount(id+1)
        FileReader.saveSortName(id, name: "Sort_"+id.description)
        FileReader.saveSort(id, sort: MusicSort(musics: [Int32 : MusicData](), scores: [Int32 : MusicScore](), rivalScores: [Int32 : MusicScore](), webMusicIds: [Int32 : WebMusicId]()))
        mSortNames.append("Sort_"+id.description)
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: mSortNames.count-1, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    var mMag: CGFloat = 1

    func refreshAll() {
        mSortNames.removeAll(keepingCapacity: true)
        let count = FileReader.readSortCount()
        mActiveSortId = FileReader.readActiveSortId()
        for i: Int32 in 0 ..< count {
            mSortNames.append(FileReader.readSortName(i)!)
        }
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
        
        //addButton.hidden = true
        
        let device = UIDevice.current.userInterfaceIdiom
        if device == UIUserInterfaceIdiom.pad {
            mMag = 1.5
        }

        self.title = "Sorts"
        adView.addSubview(Admob.getAdBannerView(self))

        //navigationController?.setNavigationBarHidden(true, animated: true)
        buttonEdit = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(ViewSortList.editButtonTouched(_:)))
        buttonDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(ViewSortList.doneButtonTouched(_:)))
        buttonAdd = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(ViewSortList.addButtonTouched(_:)))
        let bb = [UIBarButtonItem](arrayLiteral: buttonEdit)
        navigationController?.navigationBar.topItem?.rightBarButtonItems = bb
        
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