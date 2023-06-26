//
//  ViewMenuSystem.swift
//  dsm
//
//  Created by LinaNfinE on 6/25/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

// ViewMenuSystem is Deprecated!!

import UIKit
import WebKit
import GoogleMobileAds

class ViewMenuSystem: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate, UIBarPositioningDelegate, GADBannerViewDelegate {
    
    static func checkOut(_ parentView: ViewScoreList?, scores: [Int32 : MusicScore]?, rivalScores: [Int32 : MusicScore]?, musics: [Int32 : MusicData]?, webMusicIds: [Int32 : WebMusicId]?, listItems: [UniquePattern]?, processPool: WKProcessPool) -> (ViewMenuSystem) {
        let storyboard = UIStoryboard(name: "ViewMenuSystem", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! ViewMenuSystem
        ret.rparam_ParentView = parentView
        ret.rparam_ScoreData = scores
        ret.rparam_RivalScoreData = rivalScores
        ret.rparam_MusicData = musics
        ret.rparam_WebMusicIds = webMusicIds
        ret.rparam_ListItems = listItems
        ret.rparam_ProcessPool = processPool
        return ret
    }
    
    var rparam_ParentView: ViewScoreList!
    var rparam_ScoreData: [Int32 : MusicScore]!
    var rparam_RivalScoreData: [Int32 : MusicScore]!
    var rparam_MusicData: [Int32 : MusicData]!
    var rparam_WebMusicIds: [Int32 : WebMusicId]!
    var rparam_ListItems: [UniquePattern]!
    var sparam_ParentView: ViewScoreList!
    var sparam_ListItems: [UniquePattern]!
    var rparam_ProcessPool: WKProcessPool!
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    // セルに表示するテキスト
    let textsA = [
        NSLocalizedString("Preferences", comment: "ViewMenuSystem"),
        NSLocalizedString("Statistics", comment: "ViewMenuSystem"),
        NSLocalizedString("from GATE (simple)", comment: "ViewMenuSystem"),
        NSLocalizedString("from GATE (detail)", comment: "ViewMenuSystem"),
        NSLocalizedString("DDR SA", comment: "ViewMenuSystem"),
        NSLocalizedString("Random Pickup", comment: "ViewMenuSystem"),
        NSLocalizedString("Manage Rivals", comment: "ViewMenuSystem"),
    ]
    let detailTextsA = [
        "",
        "",
        NSLocalizedString("Get all scores with no detail data.", comment: "ViewMenuSystem"),
        NSLocalizedString("Get listed item scores from GATE", comment: "ViewMenuSystem"),
        NSLocalizedString("Export scores to DDR Skill Attack.", comment: "ViewMenuSystem"),
        "",
        "",
    ]
    let textsB = [
        NSLocalizedString("Preferences", comment: "ViewMenuSystem"),
        NSLocalizedString("from GATE (simple)", comment: "ViewMenuSystem"),
        NSLocalizedString("DDR SA", comment: "ViewMenuSystem"),
        NSLocalizedString("Manage Rivals", comment: "ViewMenuSystem"),
    ]
    let detailTextsB = [
        "",
        NSLocalizedString("Get all scores with no detail data.", comment: "ViewMenuSystem"),
        NSLocalizedString("Export scores to DDR Skill Attack.", comment: "ViewMenuSystem"),
        "",
    ]
    
    // セルの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if rparam_ParentView == nil {
            return textsB.count
        }
        else {
            return textsA.count
        }
    }
    
    // セルの内容を変更
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var texts: [String]
        var detailTexts: [String]
        if rparam_ParentView == nil {
            texts = textsB
            detailTexts = detailTextsB
        }
        else {
            texts = textsA
            detailTexts = detailTextsA
        }
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        cell.backgroundColor = UIColor(white: 0, alpha: 0.01)
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
        var texts: [String]
        //var detailTexts: [String]
        if rparam_ParentView == nil {
            texts = textsB
            //detailTexts = detailTextsB
        }
        else {
            texts = textsA
            //detailTexts = detailTextsA
        }
        switch texts[(indexPath as NSIndexPath).row] {
        case NSLocalizedString("Preferences", comment: "ViewMenuSystem"):
            present(ViewPreferences.checkOut(rparam_ParentView, processPool: self.rparam_ProcessPool), animated: true, completion: nil)
        case NSLocalizedString("Statistics", comment: "ViewMenuSystem"):
            present(ViewStatistics.checkOut(rparam_ParentView.mTitle + " (" + rparam_ParentView.mFilterName + ")", scores: rparam_ScoreData, rivalScores: rparam_RivalScoreData, musics: rparam_MusicData, webMusicIds: rparam_WebMusicIds, targets: rparam_ListItems), animated: true, completion: nil)
        case NSLocalizedString("from GATE (simple)", comment: "ViewMenuSystem"):
            present(ViewFromGateList.checkOut(rparam_ParentView, rivalId: nil, rivalName: nil, processPool: self.rparam_ProcessPool), animated: true, completion: nil)
        case NSLocalizedString("from GATE (detail)", comment: "ViewMenuSystem"):
            present(ViewFromGate.checkOut(rparam_ParentView, musics: rparam_MusicData, targets: rparam_ListItems, rivalId: nil, rivalName: nil, processPool: self.rparam_ProcessPool), animated: true, completion: nil)
        case NSLocalizedString("DDR SA", comment: "ViewMenuSystem"):
            present(ViewDdrSa.checkOut(), animated: true, completion: nil)
        case NSLocalizedString("Random Pickup", comment: "ViewMenuSystem"):
            present(ViewScoreList.checkOut("Random Pickup", category: texts[(indexPath as NSIndexPath).row], targets: rparam_ListItems, parentScoreList: rparam_ParentView, processPool: self.rparam_ProcessPool), animated: true, completion: nil)
        case NSLocalizedString("Manage Rivals", comment: "ViewMenuSystem"):
            present(ViewManageRivals.checkOut(rparam_ParentView, listItems: rparam_ListItems, fromMenu: true, processPool: self.rparam_ProcessPool), animated: true, completion: nil)
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
        //navigationController?.navigationBarHidden = false
        //setFilterData()
        buttonStop = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(ViewMenuSystem.stopButtonTouched(_:)))
        let bl = [UIBarButtonItem](arrayLiteral: buttonStop)
        navigationBar.topItem?.leftBarButtonItems = bl
        if let indexPathes = tableView.indexPathsForSelectedRows {
            if let indexPath = indexPathes.first as IndexPath? {
                tableView.deselectRow(at: indexPath, animated: false)
            }
        }
        Admob.shAdView(adHeight)
    }
    
    @objc internal func stopButtonTouched(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let nvFrame: CGRect = navigationBar.frame;
        tableView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height, left: 0, bottom: 0, right: 0)
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
    }
    
    var buttonStop: UIBarButtonItem!
    
    @objc func applicationWillEnterForeground() {
        Admob.shAdView(adHeight)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let notifc: NotificationCenter = NotificationCenter.default
        notifc.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        
        self.title = "System Menu"
        adView.addSubview(Admob.getAdBannerView(self))
        
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

