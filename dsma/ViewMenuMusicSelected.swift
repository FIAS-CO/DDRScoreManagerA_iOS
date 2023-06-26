//
//  ViewMenuMusicSelected.swift
//  dsm
//
//  Created by LinaNfinE on 6/21/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

// ViewMenuMusicSelected is Deprecated!!

import UIKit
import WebKit
import GoogleMobileAds

class ViewMenuMusicSelected: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate, UIBarPositioningDelegate, GADBannerViewDelegate, UIScrollViewDelegate {
    
    static func checkOut(_ parentView: ViewScoreList?, musics: [Int32 : MusicData], uniquePattern: UniquePattern?, parentCategory: String?, category: String?, processPool: WKProcessPool) -> (ViewMenuMusicSelected) {
        let storyboard = UIStoryboard(name: "ViewMenuMusicSelected", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! ViewMenuMusicSelected
        ret.rparam_ParentView = parentView
        ret.rparam_MusicData = musics
        ret.rparam_UniquePattern = uniquePattern
        ret.rparam_ParentCategory = parentCategory
        ret.rparam_Category = category
        ret.rparam_ProcessPool = processPool
        return ret
    }
    
    var rparam_ParentView: ViewScoreList!
    var rparam_MusicData: [Int32 : MusicData]!
    var rparam_UniquePattern: UniquePattern!
    var rparam_ParentCategory: String!
    var rparam_Category: String!
    var rparam_ProcessPool: WKProcessPool!
    
    var sparam_ParentCategory: String!
    var sparam_Category: String!
    var sparam_ParentView: ViewScoreList!
    var sparam_AddTarget: UniquePattern!
    var sparam_Target: UniquePattern!
    var sparam_Targets: [UniquePattern]!
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    
    @IBOutlet weak var naviTitle: UINavigationItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    var mScrollDecelerating = false
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        mScrollDecelerating = true
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        mScrollDecelerating = false
    }
    
    // セルに表示するテキスト
    let textsA = [
        NSLocalizedString("from GATE", comment: "ViewMenuMusicSelected"),
        NSLocalizedString("Direct Edit", comment: "ViewMenuMusicSelected"),
        NSLocalizedString("Add to MyList", comment: "ViewMenuMusicSelected"),
        NSLocalizedString("Display all pattern", comment: "ViewMenuMusicSelected"),
    ]
    let textsB = [
        NSLocalizedString("from GATE", comment: "ViewMenuMusicSelected"),
        NSLocalizedString("Direct Edit", comment: "ViewMenuMusicSelected"),
        NSLocalizedString("Add to MyList", comment: "ViewMenuMusicSelected"),
    ]
    let textsC = [
        NSLocalizedString("from GATE", comment: "ViewMenuMusicSelected"),
        NSLocalizedString("Direct Edit", comment: "ViewMenuMusicSelected"),
        NSLocalizedString("Add to MyList", comment: "ViewMenuMusicSelected"),
        NSLocalizedString("Remove From This MyList", comment: "ViewMenuMusicSelected"),
        NSLocalizedString("Display all pattern", comment: "ViewMenuMusicSelected"),
    ]
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    // セルの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch rparam_ParentCategory {
        case "Display All Pattern":
            return textsB.count
        case "My List":
            return textsC.count
        default:
            return textsA.count
        }
    }
    
    // セルの内容を変更
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        cell.backgroundColor = UIColor(white: 0, alpha: 0.01)
        //cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.textColor = UIColor.white
        switch rparam_ParentCategory {
        case "Display All Pattern":
            cell.textLabel?.text = textsB[(indexPath as NSIndexPath).row]
        case "My List":
            cell.textLabel?.text = textsC[(indexPath as NSIndexPath).row]
        default:
            cell.textLabel?.text = textsA[(indexPath as NSIndexPath).row]
        }
        //if cell.textLabel?.text == "Remove From This MyList" {
        //    cell.accessoryType = UITableViewCellAccessoryType.None
        //}
        let cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor = UIColor.blue
        cell.selectedBackgroundView = cellSelectedBgView
        return cell
    }
    
    internal func cellTapAction(_ tableView: UITableView, indexPath: IndexPath) {
        var texts: [String]
        switch rparam_ParentCategory {
        case "Display All Pattern":
            texts = textsB
        case "My List":
            texts = textsC
        default:
            texts = textsA
        }
        switch texts[(indexPath as NSIndexPath).row] {
        case NSLocalizedString("from GATE", comment: "ViewMenuMusicSelected"):
            var targets = [UniquePattern]()
            targets.append(rparam_UniquePattern)
            present(ViewFromGate.checkOut(rparam_ParentView, musics: rparam_MusicData, targets: targets, rivalId: nil, rivalName: nil, processPool: self.rparam_ProcessPool), animated: true, completion: nil)
        //case NSLocalizedString("Direct Edit", comment: "ViewMenuMusicSelected"):
            //presentViewController(ViewDirectEdit.checkOut(rparam_ParentView, musics: rparam_MusicData, target: rparam_UniquePattern), animated: true, completion: nil)
        case NSLocalizedString("Display all pattern", comment: "ViewMenuMusicSelected"):
            present(ViewScoreList.checkOut("Display All Pattern", category: rparam_MusicData[rparam_UniquePattern.MusicId]!.Name, targets: nil, parentScoreList: rparam_ParentView, processPool: self.rparam_ProcessPool), animated: true, completion: nil)
        case NSLocalizedString("Add to MyList", comment: "ViewMenuMusicSelected"):
            present(ViewMyList.checkOut(rparam_UniquePattern, processPool: self.rparam_ProcessPool), animated: true, completion: nil)
        case NSLocalizedString("Remove From This MyList", comment: "ViewMenuMusicSelected"):
            let mylist = FileReader.readMyList(Int32(Int(rparam_Category)!))
            var mylistSv = [UniquePattern]()
            for pt in mylist {
                if pt.equals(rparam_UniquePattern) {
                    continue
                }
                mylistSv.append(pt)
            }
            FileReader.saveMyList(Int32(Int(rparam_Category)!), list: mylistSv)
            rparam_ParentView.refreshAll()
            presentingViewController?.dismiss(animated: true, completion: nil)
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
    
    @objc internal func stopButtonTouched(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let bl = [UIBarButtonItem](arrayLiteral: buttonStop)
        navigationBar.topItem?.leftBarButtonItems = bl
        if let indexPathes = tableView.indexPathsForSelectedRows {
            if let indexPath = indexPathes.first as IndexPath? {
                tableView.deselectRow(at: indexPath, animated: false)
            }
        }
        Admob.shAdView(adHeight)
    }
    
    var buttonStop: UIBarButtonItem!
    
    override func viewDidAppear(_ animated: Bool) {
        let nvFrame: CGRect = navigationBar.frame;
        tableView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height, left: 0, bottom: 0, right: 0)
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
    }
    
    @objc func applicationWillEnterForeground() {
        Admob.shAdView(adHeight)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let notifc: NotificationCenter = NotificationCenter.default
        notifc.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        
        buttonStop = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(ViewMenuMusicSelected.stopButtonTouched(_:)))

        naviTitle.title = rparam_UniquePattern.Pattern.rawValue + ": " + rparam_MusicData[rparam_UniquePattern.MusicId]!.Name
        adView.addSubview(Admob.getAdBannerView(self))

        let nvFrame: CGRect = navigationBar.frame;
        tableView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height, left: 0, bottom: 0, right: 0)
        navigationBar.delegate = self
        
        tableView.indicatorStyle = UIScrollView.IndicatorStyle.white
        tableView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        tableView.delegate = self
        tableView.dataSource = self
        
        //performSegueWithIdentifier("modalMusicListUpdate",sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
