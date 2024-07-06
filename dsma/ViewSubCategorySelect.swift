//
//  ViewSubCategorySelect.swift
//  dsm
//
//  Created by LinaNfinE on 6/19/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds

class ViewSubCategorySelect: UIViewController, UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate, UIScrollViewDelegate {
    
    static func checkOut(_ parentCategory: String?, processPool: WKProcessPool) -> (ViewSubCategorySelect) {
        let storyboard = UIStoryboard(name: "ViewSubCategorySelect", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! ViewSubCategorySelect
        ret.rparam_ParentCategory = parentCategory
        ret.rparam_ProcessPool = processPool
        return ret
    }
    
    var rparam_ParentCategory: String!
    var rparam_ProcessPool: WKProcessPool!
    
    var sparam_ParentCategory: String!
    var sparam_Category: String!
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    // セルに表示するテキスト
    
    let texts = [
        "Series Title" : ["WORLD(Coming Soon)", "A3", "A20 PLUS", "A20", "A", "2014", "2013", "X3", "X2", "X", "Super NOVA2", "Super NOVA", "EXTREME", "MAX2", "MAX", "5th", "4th", "3rd", "2nd", "1st"],
        "ABC" : ["NUM", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"],
        "Difficulty" : ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19"],
        "Dance Level" : ["AAA", "AA+", "AA", "AA-", "A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "E", "NoPlay"],
        "Full Combo Type" : ["MFC", "PFC", "FC", "GFC", "Life4", "NoFC", "Failed", "NoPlay"],
        "Rival" : [NSLocalizedString("Manage Rivals", comment: "ViewSubCategorySelect"), "Win/Lose", "Dance Level", "Full Combo Type"],
        "Rival Win/Lose" : ["Win", "Lose", "Draw", "Win (Close)", "Lose (Close)", "Draw (Played)", "Win (Rival NoPlay)", "Lose (Player NoPlay)", "Draw (NoPlay)"],
        "Rival Dance Level" : ["AAA", "AA+", "AA", "AA-", "A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "E", "NoPlay"],
        "Rival Full Combo Type" : ["MFC", "PFC", "FC", "GFC", "Life4", "NoFC", "Failed"],
    ]
    
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
        return texts[rparam_ParentCategory]!.count
    }
    
    // セルの内容を変更
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        cell.backgroundColor = UIColor(white: 0, alpha: 0.01)
        cell.textLabel?.font = UIFont.systemFont(ofSize: cell.textLabel!.font.pointSize * mMag)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = texts[rparam_ParentCategory]![(indexPath as NSIndexPath).row]
        let cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor = UIColor.blue
        cell.selectedBackgroundView = cellSelectedBgView
        return cell
    }
    
    let actionSheetTextsSystemB = [
        NSLocalizedString("Preferences", comment: "ViewSubCategorySelect"),
        NSLocalizedString("Player Status", comment: "ViewSubCategorySelect"),
        NSLocalizedString("from GATE (simple)", comment: "ViewSubCategorySelect"),
        NSLocalizedString("DDR SA", comment: "ViewSubCategorySelect"),
        NSLocalizedString("Manage Rivals", comment: "ViewSubCategorySelect"),
    ]
    
    internal func cellTapAction(_ tableView: UITableView, indexPath: IndexPath) {
        if rparam_ParentCategory == "Rival" {
            if texts[rparam_ParentCategory]![(indexPath as NSIndexPath).row] == NSLocalizedString("Manage Rivals", comment: "ViewSubCategorySelect") {
                present(ViewManageRivals.checkOut(nil, listItems: nil, fromMenu: false, processPool: self.rparam_ProcessPool), animated: true, completion: nil)
            }
            else {
                navigationController?.pushViewController(ViewSubCategorySelect.checkOut("Rival " + texts[rparam_ParentCategory]![(indexPath as NSIndexPath).row], processPool: self.rparam_ProcessPool), animated: true)
            }
        }
        else {
            navigationController?.pushViewController(ViewScoreList.checkOut(rparam_ParentCategory, category: texts[rparam_ParentCategory]![(indexPath as NSIndexPath).row], targets: nil, parentScoreList: nil, processPool: self.rparam_ProcessPool), animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
    }
    
    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        let pt = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: pt) {
            cellTapAction(tableView, indexPath: indexPath)
        }
    }
    
    var mActionSheet: ActionSheet!
    @objc internal func menuButtonTouched(_ sender: UIButton) {
        var texts: [String]
        texts = actionSheetTextsSystemB
        mActionSheet = ActionSheet(title: nil, cancelAction: nil)
        for text in texts {
            var action: (()->Void)
            switch text {
            case NSLocalizedString("Preferences", comment: "ViewSubCategorySelect"):
                action = { ()->Void in self.present(ViewPreferences.checkOut(nil, processPool: self.rparam_ProcessPool), animated: true, completion: nil) }
            case NSLocalizedString("Player Status", comment: "ViewSubCategorySelect"):
                action = { ()->Void in self.present(ViewPlayerStatus.checkOut(self.rparam_ProcessPool), animated: true, completion: nil) }
            case NSLocalizedString("from GATE (simple)", comment: "ViewSubCategorySelect"):
                action = { ()->Void in self.present(ViewFromGateList.checkOut(nil, rivalId: nil, rivalName: nil, processPool: self.rparam_ProcessPool), animated: true, completion: nil) }
            case NSLocalizedString("DDR SA", comment: "ViewSubCategorySelect"):
                action = { ()->Void in self.present(ViewDdrSa.checkOut(), animated: true, completion: nil) }
            case NSLocalizedString("Manage Rivals", comment: "ViewSubCategorySelect"):
                action = { ()->Void in self.present(ViewManageRivals.checkOut(nil, listItems: nil, fromMenu: true, processPool: self.rparam_ProcessPool), animated: true, completion: nil) }
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
    }
    
    var buttonMenu: UIBarButtonItem!
    
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

        buttonMenu = UIBarButtonItem(title: "☰", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ViewSubCategorySelect.menuButtonTouched(_:)))
        buttonMenu.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24)], for: UIControl.State())
        self.title = rparam_ParentCategory
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
