//
//  ViewSortTypeSetting.swift
//  dsm
//
//  Created by LinaNfinE on 6/19/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewSortTypeSetting: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate, UIBarPositioningDelegate, GADBannerViewDelegate, UIScrollViewDelegate {
    
    static func checkOut(_ parentView: ViewSortSetting, sortId: Int32, typeNo: Int32, typeId: Int32) -> (ViewSortTypeSetting) {
        let storyboard = UIStoryboard(name: "ViewSortTypeSetting", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! ViewSortTypeSetting
        ret.rparam_ParentView = parentView
        ret.rparam_SortId = sortId
        ret.rparam_TypeNo = typeNo
        ret.rparam_TypeId = typeId
        return ret
    }
    
    var rparam_ParentView: ViewSortSetting!
    var rparam_SortId: Int32!
    var rparam_TypeNo: Int32!
    var rparam_TypeId: Int32!
    
    //var mSort: MusicSort!
    //var mActive: Int32!
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var mScrollDecelerating = false
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        mScrollDecelerating = true
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        mScrollDecelerating = false
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40 * mMag
    }

    // セルの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MusicSortTypeLister.getCount()
    }
    
    // セルの内容を変更
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        cell.accessoryType = Int(rparam_TypeId) == (indexPath as NSIndexPath).row ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
        cell.editingAccessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.backgroundColor = UIColor(white: 0, alpha: 0.8)
        cell.textLabel?.font = UIFont.systemFont(ofSize: cell.textLabel!.font.pointSize * mMag)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = MusicSortTypeLister.getString((indexPath as NSIndexPath).row)
        let cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor = UIColor.blue
        cell.selectedBackgroundView = cellSelectedBgView
        return cell
    }
    
    internal func cellTapAction(_ tableView: UITableView, indexPath: IndexPath) {
        //switch rparam_TypeNo {
        //case 1: mSort._1stType = MusicSortTypeLister.getSortType(Int32(indexPath.row))
        //case 2: mSort._2ndType = MusicSortTypeLister.getSortType(Int32(indexPath.row))
        //case 3: mSort._3rdType = MusicSortTypeLister.getSortType(Int32(indexPath.row))
        //case 4: mSort._4thType = MusicSortTypeLister.getSortType(Int32(indexPath.row))
        //case 5: mSort._5thType = MusicSortTypeLister.getSortType(Int32(indexPath.row))
        //default: break
        //}
        //FileReader.saveSort(rparam_SortId, sort: mSort)
        rparam_ParentView.changeSortData(rparam_TypeNo, type: Int32((indexPath as NSIndexPath).row))
        presentingViewController?.dismiss(animated: true, completion: nil)
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
            //tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
    
    override func viewDidAppear(_ animated: Bool) {
        let nvFrame: CGRect = navigationBar.frame;
        tableView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height, left: 0, bottom: 0, right: 0)
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
    }
    
    var mMag: CGFloat = 1
    
    @objc func applicationWillEnterForeground() {
        Admob.shAdView(adHeight)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let notifc: NotificationCenter = NotificationCenter.default
        notifc.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        
        //self.title = "Sort Types"
        adView.addSubview(Admob.getAdBannerView(self))

        //if let sort = FileReader.readSort(MusicSort(musics: [Int32 : MusicData](), scores: [Int32 : MusicScore](), rivalScores: [Int32 : MusicScore](), webMusicIds: [Int32 : WebMusicId]()), id: rparam_SortId) {
        //    mSort = sort
        //}
        //else {
        //    presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        //    return
        //}
        
        /*switch rparam_TypeNo {
        case 1: mActive = MusicSortTypeLister.getSortTypeNum(mSort._1stType)
        case 2: mActive = MusicSortTypeLister.getSortTypeNum(mSort._2ndType)
        case 3: mActive = MusicSortTypeLister.getSortTypeNum(mSort._3rdType)
        case 4: mActive = MusicSortTypeLister.getSortTypeNum(mSort._4thType)
        case 5: mActive = MusicSortTypeLister.getSortTypeNum(mSort._5thType)
        default: break
        }*/
        
        let device = UIDevice.current.userInterfaceIdiom
        if device == UIUserInterfaceIdiom.pad {
            mMag = 1.5
        }

        let nvFrame: CGRect = navigationBar.frame;
        tableView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height, left: 0, bottom: 0, right: 0)
        navigationBar.delegate = self
        
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
