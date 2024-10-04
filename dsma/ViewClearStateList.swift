//
//  ViewClearStateList.swift
//  dsm
//
//  Created by LinaNfinE on 6/28/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewClearStateList: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate, UIBarPositioningDelegate, GADBannerViewDelegate, UIScrollViewDelegate {
    
    static func checkOut(_ parentView: ViewDirectEdit?, currentClearState: Int?, isRival: Bool) -> (ViewClearStateList) {
        let storyboard = UIStoryboard(name: "ViewClearStateList", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! ViewClearStateList
        ret.rparam_ParentView = parentView
        ret.rparam_isRival = isRival
        ret.rparam_CurrentClearState = currentClearState
        return ret
    }
    
    var rparam_ParentView: ViewDirectEdit!
    var rparam_isRival: Bool!
    var rparam_CurrentClearState: Int!
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40 * mMag
    }

    // セルに表示するテキスト
    let texts = ["Marvelous Full Combo", "Perfect Full Combo", "Great Full Combo", "Good Full Combo", "Life4 Clear", "Clear", "RankE", "NoPlay"]
    
    // セルの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }
    
    // セルの内容を変更
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        cell.accessoryType = rparam_CurrentClearState == (indexPath as NSIndexPath).row ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
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
        let viewOver = tableView.contentSize.height-tableView.bounds.height
        if viewOver > 0 {
            // plus over scroll
            if tableView.contentOffset.y > viewOver {
                return
            }
        }
        else {
            // plus over scroll on content < scrollView
            if -tableView.contentOffset.y < tableView.contentInset.top {
                return
            }
        }
        if rparam_isRival! {
            rparam_ParentView.setRivalState((indexPath as NSIndexPath).row)
        }
        else {
            rparam_ParentView.setState((indexPath as NSIndexPath).row)
        }
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
        
        let device = UIDevice.current.userInterfaceIdiom
        if device == UIUserInterfaceIdiom.pad {
            mMag = 1.5
        }

        let nvFrame: CGRect = navigationBar.frame;
        var sai = CGFloat(0)
        if #available(iOS 11.0, *) {
            sai = view.safeAreaInsets.top
        }
        tableView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height + sai, left: 0, bottom: 0, right: 0)
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

