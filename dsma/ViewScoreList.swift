//
//  ViewScoreList.swift
//  dsm
//
//  Created by LinaNfinE on 6/4/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds

class ViewScoreList: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate, UIBarPositioningDelegate, GADBannerViewDelegate, UIScrollViewDelegate, UIActionSheetDelegate {
    
    static func checkOut(_ parentCategory: String, category: String, targets: [UniquePattern]?, parentScoreList: ViewScoreList?, processPool: WKProcessPool) -> (ViewScoreList) {
        switch parentCategory {
            case "Display All Pattern":
            let storyboard = UIStoryboard(name: "ViewScoreList_SameTitle", bundle: nil)
            let ret = storyboard.instantiateInitialViewController() as! ViewScoreList
            ret.rparam_ParentCategory = parentCategory
            ret.rparam_Category = category
            ret.rparam_ParentScoreListView = parentScoreList
            ret.rparam_ProcessPool = processPool
            return ret
        case "Random Pickup":
            let storyboard = UIStoryboard(name: "ViewScoreList_SameTitle", bundle: nil)
            let ret = storyboard.instantiateInitialViewController() as! ViewScoreList
            ret.rparam_ParentCategory = parentCategory
            ret.rparam_Category = category
            ret.rparam_Targets = targets
            ret.rparam_ParentScoreListView = parentScoreList
            ret.rparam_ProcessPool = processPool
            return ret
        default:
            let storyboard = UIStoryboard(name: "ViewScoreList_Standard", bundle: nil)
            let ret = storyboard.instantiateInitialViewController() as! ViewScoreList
            ret.rparam_ParentCategory = parentCategory
            ret.rparam_Category = category
            ret.rparam_ProcessPool = processPool
            return ret
        }
    }
    
    //var filterListShowing: Bool = false
    //var sortListShowing: Bool = false
    //var menuMusicSelectedShowing: Bool = false
    
    var rparam_ParentCategory: String = ""
    var rparam_Category: String = ""
    var rparam_Targets: [UniquePattern]!
    var rparam_ParentScoreListView: ViewScoreList!
    var rparam_ProcessPool: WKProcessPool!

    var mTitle: String = ""
    var mFilterName: String = ""
    
    var mMusicData: [Int32 : MusicData]!
    var mScoreData: [Int32 : MusicScore]!
    var mRivalScoreData: [Int32 : MusicScore]!
    var mWebMusicIds: [Int32 : WebMusicId]!
    
    var mActiveRival: RivalData = RivalData(Id: "",Name: "")
    var mCellReuseId: String = "ScoreListItemCell"
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var naviTitle: UINavigationItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var sortLabel: UILabel!
    
    @IBAction func longPressGestureAction(_ sender: UILongPressGestureRecognizer) {
        let pt = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: pt) {
            switch sender.state {
            case UIGestureRecognizer.State.possible:
                break
            case UIGestureRecognizer.State.began:
                let pat = mListItems[(indexPath as NSIndexPath).row]
                present(ViewScoreList.checkOut("Display All Pattern", category: mMusicData[pat.MusicId]!.Name, targets: nil, parentScoreList: self, processPool: self.rparam_ProcessPool), animated: true, completion: nil)
            case UIGestureRecognizer.State.changed:
                break
            case UIGestureRecognizer.State.ended:
                break
            case UIGestureRecognizer.State.cancelled:
                break
            case UIGestureRecognizer.State.failed:
                break
            @unknown default:
                break
            }
        }
    }
    @IBAction func sortButtonTouchUpInside(_ sender: AnyObject) {
        present(ViewSortList.checkOut(self), animated: true, completion: nil)
    }
    @IBAction func filterButtonTouchUpInside(_ sender: AnyObject) {
        present(ViewFilterList.checkOut(self), animated: true, completion: nil)
    }
    
    let sParentCategoyText = ["Series Title", "ABC", "Difficulty", "Dance Level", "Full Combo Type"]
    
    let sCategoryText = [
        "Series Title" : ["A3", "A20 PLUS", "A20", "A", "2014", "2013", "X3", "X2", "X", "Super NOVA2", "Super NOVA", "EXTREME", "MAX2", "MAX", "5th", "4th", "3rd", "2nd", "1st"],
        "ABC" : ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"],
        "Difficulty" : ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19"],
        "Dance Level" : ["AAA", "AA+", "AA", "AA-", "A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "E", "NoPlay"],
        "Full Combo Type" : ["MFC", "PFC", "FC", "GFC", "Life4", "NoFC", "Failed", "NoPlay"],
    ]
    
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
    
    //var reloadOnReturn: Bool = false
    //func setReloadOnReturn() {
    //    reloadOnReturn = true
    //}
    
    // セルに表示するテキスト
    //let texts = ["sukoarisuto", "tesuto"]
    var mListItems: [UniquePattern] = [UniquePattern]()
    
    // セルの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mListItems.count == 0 ? 1 : mListItems.count
    }
    
    // セルの内容を変更
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        //cell.textLabel?.text = texts[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: mCellReuseId) as? ScoreListItem
        // セルが作成されていないか?
        if cell == nil { // yes
            // セルを作成
            cell = ScoreListItem(style: UITableViewCell.CellStyle.default, reuseIdentifier: mCellReuseId)
        }
        let cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor = UIColor.blue
        cell?.selectedBackgroundView = cellSelectedBgView
        if mListItems.count == 0 {
            if indicator.isAnimating {
                cell?.mLabelTitle.text = ""
            }
            else {
                cell?.mLabelTitle.text = "No match."
            }
            cell?.mLabelDifficulty.text = ""
            cell?.mLabelSPDP.text = ""
            cell?.mLabelClear.text = ""
            cell?.mLabelPlay.text = ""
            cell?.mLabelDanceLevel.text = ""
            cell?.mLabelDanceLevelPM.text = ""
            cell?.mLabelScore.text = ""
            cell?.mLabelCombo.text = ""
            cell?.mLabelFC.textColor = UIColor.clear
            cell?.mLabelRivalDifference.text = ""
            cell?.mLabelRivalName.text = ""
            cell?.mLabelRivalClear.text = ""
            cell?.mLabelRivalPlay.text = ""
            cell?.mLabelRivalDanceLevel.text = ""
            cell?.mLabelRivalDanceLevelPM.text = ""
            cell?.mLabelRivalScore.text = ""
            cell?.mLabelRivalCombo.text = ""
            cell?.mLabelRivalFC.textColor = UIColor.clear
            return cell!
        }
        let pat: UniquePattern = mListItems[(indexPath as NSIndexPath).row]
        let md: MusicData? = mMusicData[pat.MusicId]
        if md != nil {
            let ms: MusicScore? = mScoreData[pat.MusicId]
            if ms != nil {
                let msr: MusicScore? = pat.RivalName == "" ? MusicScore() : mRivalScoreData[pat.MusicId]
                if msr != nil {
                    var diff: Int32
                    var diffColor: UIColor
                    var isDP: Bool
                    var sd: ScoreData
                    var sdr: ScoreData
                    switch pat.Pattern{
                    case PatternType.bSP:
                        diff = md!.Difficulty_bSP
                        diffColor = UIColor.cyan
                        isDP = false
                        sd = ms!.bSP
                        sdr = msr!.bSP
                    case PatternType.BSP:
                        diff = md!.Difficulty_BSP
                        diffColor = UIColor.orange
                        isDP = false
                        sd = ms!.BSP
                        sdr = msr!.BSP
                    case PatternType.DSP:
                        diff = md!.Difficulty_DSP
                        diffColor = UIColor.red
                        isDP = false
                        sd = ms!.DSP
                        sdr = msr!.DSP
                    case PatternType.ESP:
                        diff = md!.Difficulty_ESP
                        diffColor = UIColor.green
                        isDP = false
                        sd = ms!.ESP
                        sdr = msr!.ESP
                    case PatternType.CSP:
                        diff = md!.Difficulty_CSP
                        diffColor = UIColor.magenta
                        isDP = false
                        sd = ms!.CSP
                        sdr = msr!.CSP
                    case PatternType.BDP:
                        diff = md!.Difficulty_BDP
                        diffColor = UIColor.orange
                        isDP = true
                        sd = ms!.BDP
                        sdr = msr!.BDP
                    case PatternType.DDP:
                        diff = md!.Difficulty_DDP
                        diffColor = UIColor.red
                        isDP = true
                        sd = ms!.DDP
                        sdr = msr!.DDP
                    case PatternType.EDP:
                        diff = md!.Difficulty_EDP
                        diffColor = UIColor.green
                        isDP = true
                        sd = ms!.EDP
                        sdr = msr!.EDP
                    case PatternType.CDP:
                        diff = md!.Difficulty_CDP
                        diffColor = UIColor.magenta
                        isDP = true
                        sd = ms!.CDP
                        sdr = msr!.CDP
                    //default:
                    //    diff = 0
                    //    diffColor = UIColor.clearColor()
                    //    isDP = false
                    //    sd = ScoreData(Rank: MusicRank.Noplay, Score: 0, MaxCombo: 0, FullComboType_: FullComboType.None, PlayCount: 0, ClearCount: 0)
                    //    break
                    }
                    var rankColor: UIColor
                    switch sd.Rank{
                    case MusicRank.AAA:
                        rankColor = UIColor.white
                    case MusicRank.AAp: fallthrough
                    case MusicRank.AAm: fallthrough
                    case MusicRank.AA:
                        rankColor = UIColor(red: 1, green: 1, blue: 0.5, alpha: 1)
                    case MusicRank.Ap: fallthrough
                    case MusicRank.Am: fallthrough
                    case MusicRank.A:
                        rankColor = UIColor.yellow
                    case MusicRank.Bp: fallthrough
                    case MusicRank.Bm: fallthrough
                    case MusicRank.B:
                        rankColor = UIColor(red: 0.3, green: 0.3, blue: 1, alpha: 1)
                    case MusicRank.Cp: fallthrough
                    case MusicRank.Cm: fallthrough
                    case MusicRank.C:
                        rankColor = UIColor.magenta
                    case MusicRank.Dp: fallthrough
                    case MusicRank.D:
                        rankColor = UIColor.red
                    case MusicRank.E:
                        rankColor = UIColor.gray
                    default:
                        rankColor = UIColor.darkGray
                    }
                    var rivalRankColor: UIColor
                    switch sdr.Rank{
                    case MusicRank.AAA:
                        rivalRankColor = UIColor.white
                    case MusicRank.AAp: fallthrough
                    case MusicRank.AAm: fallthrough
                    case MusicRank.AA:
                        rivalRankColor = UIColor(red: 1, green: 1, blue: 0.5, alpha: 1)
                    case MusicRank.Ap: fallthrough
                    case MusicRank.Am: fallthrough
                    case MusicRank.A:
                        rivalRankColor = UIColor.yellow
                    case MusicRank.Bp: fallthrough
                    case MusicRank.Bm: fallthrough
                    case MusicRank.B:
                        rivalRankColor = UIColor(red: 0.3, green: 0.3, blue: 1, alpha: 1)
                    case MusicRank.Cp: fallthrough
                    case MusicRank.Cm: fallthrough
                    case MusicRank.C:
                        rivalRankColor = UIColor.magenta
                    case MusicRank.Dp: fallthrough
                    case MusicRank.D:
                        rivalRankColor = UIColor.red
                    case MusicRank.E:
                        rivalRankColor = UIColor.gray
                    default:
                        rivalRankColor = UIColor.darkGray
                    }
                    var fcColor: UIColor
                    switch sd.FullComboType_{
                    case FullComboType.MarvelousFullCombo:
                        fcColor = UIColor.white
                    case FullComboType.PerfectFullCombo:
                        fcColor = UIColor.yellow
                    case FullComboType.FullCombo:
                        fcColor = UIColor.green
                    case FullComboType.GoodFullCombo:
                        fcColor = UIColor(red: 0.3, green: 0.3, blue: 1, alpha: 1)
                    case FullComboType.Life4:
                        fcColor = UIColor.red
                    default:
                        fcColor = UIColor.clear
                    }
                    var rivalFcColor: UIColor
                    switch sdr.FullComboType_{
                    case FullComboType.MarvelousFullCombo:
                        rivalFcColor = UIColor.white
                    case FullComboType.PerfectFullCombo:
                        rivalFcColor = UIColor.yellow
                    case FullComboType.FullCombo:
                        rivalFcColor = UIColor.green
                    case FullComboType.GoodFullCombo:
                        rivalFcColor = UIColor(red: 0.3, green: 0.3, blue: 1, alpha: 1)
                    case FullComboType.Life4:
                        rivalFcColor = UIColor.red
                    default:
                        rivalFcColor = UIColor.clear
                    }
                    let trimset = CharacterSet(charactersIn: "+-")
                    cell?.mLabelDifficulty.textColor = diffColor
                    cell?.mLabelDifficulty.text = diff.description
                    cell?.mLabelSPDP.textColor = diffColor
                    cell?.mLabelSPDP.text = isDP ? "\"" : "\'"
                    cell?.mLabelTitle.text = md!.Name
                    cell?.mLabelClear.text = sd.ClearCount.description
                    cell?.mLabelPlay.text = sd.PlayCount.description
                    cell?.mLabelDanceLevel.text = sd.Rank == MusicRank.Noplay ? "-" : sd.Rank.rawValue.trimmingCharacters(in: trimset)
                    cell?.mLabelDanceLevelPM.text = sd.Rank == MusicRank.Noplay ? "" : String(sd.Rank.rawValue[cell!.mLabelDanceLevel.text!.endIndex...])
                    cell?.mLabelDanceLevel.textColor = rankColor
                    cell?.mLabelDanceLevelPM.textColor = rankColor
                    cell?.mLabelFC.textColor = fcColor
                    cell?.mLabelScore.text = StringUtil.toCommaFormattedString(sd.Score)
                    cell?.mLabelCombo.text = sd.MaxCombo.description
                    let scd = sd.Score - sdr.Score
                    cell?.mLabelRivalDifference.textColor = scd > 0 ? UIColor.cyan : scd < 0 ? UIColor.red : UIColor.white
                    cell?.mLabelRivalDifference.text = (scd >= 0 ? "+" : "") + StringUtil.toCommaFormattedString(scd)
                    cell?.mLabelRivalName.text = pat.RivalName
                    cell?.mLabelRivalClear.text = sdr.ClearCount.description
                    cell?.mLabelRivalPlay.text = sdr.PlayCount.description
                    cell?.mLabelRivalDanceLevel.text = sdr.Rank == MusicRank.Noplay ? "-" : sdr.Rank.rawValue.trimmingCharacters(in: trimset)
                    cell?.mLabelRivalDanceLevelPM.text = sdr.Rank == MusicRank.Noplay ? "" : String(sdr.Rank.rawValue[cell!.mLabelRivalDanceLevel.text!.endIndex...])
                    cell?.mLabelRivalDanceLevel.textColor = rivalRankColor
                    cell?.mLabelRivalDanceLevelPM.textColor = rivalRankColor
                    cell?.mLabelRivalFC.textColor = rivalFcColor
                    cell?.mLabelRivalScore.text = StringUtil.toCommaFormattedString(sdr.Score)
                    cell?.mLabelRivalCombo.text = sdr.MaxCombo.description
                }
            }
        }
        return cell!
    }
    
    let actionSheetTextsMusicSelectedA = [
        NSLocalizedString("Copy to clipboard", comment: "ViewScoreList"),
        NSLocalizedString("from GATE", comment: "ViewScoreList"),
        NSLocalizedString("Direct Edit", comment: "ViewScoreList"),
        NSLocalizedString("Add to MyList", comment: "ViewScoreList"),
        NSLocalizedString("Display all pattern", comment: "ViewScoreList"),
        NSLocalizedString("Memo", comment: "ViewScoreList"),
    ]
    let actionSheetTextsMusicSelectedC = [
        NSLocalizedString("Copy to clipboard", comment: "ViewScoreList"),
        NSLocalizedString("from GATE", comment: "ViewScoreList"),
        NSLocalizedString("Direct Edit", comment: "ViewScoreList"),
        NSLocalizedString("Add to MyList", comment: "ViewScoreList"),
        NSLocalizedString("Remove From This MyList", comment: "ViewScoreList"),
        NSLocalizedString("Display all pattern", comment: "ViewScoreList"),
        NSLocalizedString("Memo", comment: "ViewScoreList"),
    ]
    
    let actionSheetTextsSystemA = [
        NSLocalizedString("Preferences", comment: "ViewScoreList"),
        NSLocalizedString("Player Status", comment: "ViewScoreList"),
        NSLocalizedString("Statistics", comment: "ViewScoreList"),
        NSLocalizedString("Copy to clipboard", comment: "ViewScoreList"),
        NSLocalizedString("from GATE (simple)", comment: "ViewScoreList"),
        NSLocalizedString("from GATE (detail)", comment: "ViewScoreList"),
        NSLocalizedString("DDR SA", comment: "ViewScoreList"),
        NSLocalizedString("Random Pickup", comment: "ViewScoreList"),
        NSLocalizedString("Manage Rivals", comment: "ViewScoreList"),
    ]
    let actionSheetTextsSystemB = [
        NSLocalizedString("Preferences", comment: "ViewScoreList"),
        NSLocalizedString("Player Status", comment: "ViewScoreList"),
        NSLocalizedString("Copy to clipboard", comment: "ViewScoreList"),
        NSLocalizedString("from GATE (simple)", comment: "ViewScoreList"),
        NSLocalizedString("DDR SA", comment: "ViewScoreList"),
        NSLocalizedString("Manage Rivals", comment: "ViewScoreList"),
    ]

    var mSelectedIndexForActionSheet = 0
    internal func cellTapAction(_ tableView: UITableView, indexPath: IndexPath) {
        if mListItems.count == 0 {
            return
        }
        //sparam_ParentView = self
        //sparam_UniquePattern = mListItems[indexPath.row]
        //sparam_ParentCategory = rparam_ParentCategory
        //sparam_Category = rparam_Category
        //performSegueWithIdentifier("modalMenuMusicSelected", sender: nil)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.none)
        mSelectedIndexForActionSheet = (indexPath as NSIndexPath).row
        let mi = mListItems[mSelectedIndexForActionSheet]
        let mid = mi.MusicId
        let music = mMusicData[mid]
        let title = music!.Name + " (" + mi.Pattern.rawValue + ")"
        var texts: [String]
        switch rparam_ParentCategory {
        case "My List":
            texts = actionSheetTextsMusicSelectedC
        default:
            texts = actionSheetTextsMusicSelectedA
        }
        if mActiveRival.Id != "" {
            texts.insert(NSLocalizedString("Rival Score", comment: "ViewScoreList"), at: 3)
        }
        /*var actionSheet = UIActionSheet(title: title, delegate: self, cancelButtonTitle: "Close", destructiveButtonTitle: nil)
        for text in texts {
            actionSheet.addButtonWithTitle(text)
        }
        actionSheet.tag = sActionSheetIdMusicSelected
        actionSheet.actionSheetStyle = UIActionSheetStyle.BlackTranslucent
        actionSheet.showInView(self.view)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)*/
        mActionSheet = ActionSheet(title: title, cancelAction: { ()->Void in self.tableView.deselectRow(at: indexPath, animated: true) })
        for text in texts {
            var action: (()->Void)
            switch text {
            case NSLocalizedString("Copy to clipboard", comment: "ViewScoreList"):
                action = { ()->Void in
                    let targetPattern = self.mListItems[self.mSelectedIndexForActionSheet]
                    let targetMusicData = self.mMusicData[targetPattern.MusicId]!
                    let targetScoreData = self.mScoreData[targetPattern.MusicId]!.getScoreData(targetPattern.Pattern)
                    let formats: [String] = FileReader.readCopyFormats()
                    let formated: [String] = [
                        StringUtil.textFromCopyFormat(formats[0], targetPattern: targetPattern, targetMusicData: targetMusicData, targetScoreData: targetScoreData),
                        StringUtil.textFromCopyFormat(formats[1], targetPattern: targetPattern, targetMusicData: targetMusicData, targetScoreData: targetScoreData),
                        StringUtil.textFromCopyFormat(formats[2], targetPattern: targetPattern, targetMusicData: targetMusicData, targetScoreData: targetScoreData),
                        ]
                    self.mActionSheet = ActionSheet(title: NSLocalizedString("Select format", comment: "ViewScoreList"), cancelAction: { ()->Void in self.tableView.deselectRow(at: indexPath, animated: true) })
                    for i in 0 ..< formats.count {
                        self.mActionSheet.addAction(ActionSheetAction(title: formated[i], method: { () -> Void in
                            let clip = UIPasteboard.general
                            clip.setValue(formated[i], forPasteboardType: "public.utf8-plain-text")
                            self.mMessageAlertView = MessageAlertView(title: "", message: NSLocalizedString("Scoredata has been copied to clipboard.", comment: "ViewScoreList"), okAction: MessageAlertViewAction(method: {()->Void in }), cancelAction: nil)
                            self.mMessageAlertView.show(self)
                            self.tableView.deselectRow(at: indexPath, animated: true)
                        }))
                    }
                    self.mActionSheet.addAction(ActionSheetAction(title: NSLocalizedString("Edit copy formats...", comment: "ViewScoreList"), method: { () -> Void in
                        self.present(ViewCopyFormatList.checkOut(self, targetPattern: nil, targetMusicData: nil, targetScoreData: nil), animated: true, completion: nil)
                    }))
                    self.mActionSheet.show(self, sourceView: self.view, sourceRect: tableView.convert(tableView.rectForRow(at: IndexPath(row: self.mSelectedIndexForActionSheet, section: 0)), to: tableView.superview))
                }
            case NSLocalizedString("from GATE", comment: "ViewScoreList"):
                action = { ()->Void in
                    var targets = [UniquePattern]()
                targets.append(self.mListItems[self.mSelectedIndexForActionSheet])
                    self.present(ViewFromGate.checkOut(self, musics: self.mMusicData, targets: targets, rivalId: nil, rivalName: nil, processPool: self.rparam_ProcessPool), animated: true, completion: nil) }
            case NSLocalizedString("Direct Edit", comment: "ViewScoreList"):
                action = { ()->Void in self.present(ViewDirectEdit.checkOut(self, musics: self.mMusicData, target: self.mListItems[self.mSelectedIndexForActionSheet], rivalData: FileReader.readRivalList()[FileReader.readActiveRivalNo()]), animated: true, completion: nil) }
            case NSLocalizedString("Rival Score", comment: "ViewScoreList"):
                action = { ()->Void in
                    self.mActionSheet = ActionSheet(title: title, cancelAction: { ()->Void in self.tableView.deselectRow(at: indexPath, animated: true) })
                    
                    self.mActionSheet.addAction(ActionSheetAction(title: NSLocalizedString("from GATE", comment: "ViewScoreList"), method: { ()->Void in
                        var targets = [UniquePattern]()
                        targets.append(self.mListItems[self.mSelectedIndexForActionSheet])
                        self.present(ViewFromGate.checkOut(self, musics: self.mMusicData, targets: targets, rivalId: self.mActiveRival.Id, rivalName: self.mActiveRival.Name, processPool: self.rparam_ProcessPool), animated: true, completion: nil) }))
                    
                    self.mActionSheet.show(self, sourceView: self.view, sourceRect: tableView.convert(tableView.rectForRow(at: IndexPath(row: self.mSelectedIndexForActionSheet, section: 0)), to: tableView.superview))
                }
            case NSLocalizedString("Display all pattern", comment: "ViewScoreList"):
                action = { ()->Void in self.present(ViewScoreList.checkOut("Display All Pattern", category: self.mMusicData[self.mListItems[self.mSelectedIndexForActionSheet].MusicId]!.Name, targets: nil, parentScoreList: self, processPool: self.rparam_ProcessPool), animated: true, completion: nil) }
            case NSLocalizedString("Add to MyList", comment: "ViewScoreList"):
                action = { ()->Void in self.present(ViewMyList.checkOut(self.mListItems[self.mSelectedIndexForActionSheet], processPool: self.rparam_ProcessPool), animated: true, completion: nil) }
            case NSLocalizedString("Remove From This MyList", comment: "ViewScoreList"):
                action = { ()->Void in
                    let mylist = FileReader.readMyList(Int32(Int(self.rparam_Category)!))
                var mylistSv = [UniquePattern]()
                for pt in mylist {
                    if pt.equals(self.mListItems[self.mSelectedIndexForActionSheet]) {
                        continue
                    }
                    mylistSv.append(pt)
                }
                FileReader.saveMyList(Int32(Int(self.rparam_Category)!), list: mylistSv)
                self.refreshAll()
                }
            default:
                action = { ()->Void in }
            }
            mActionSheet.addAction(ActionSheetAction(title: text, method: action))
        }
        mActionSheet.show(self, sourceView: self.view, sourceRect: tableView.convert(tableView.rectForRow(at: IndexPath(row: self.mSelectedIndexForActionSheet, section: 0)), to: tableView.superview))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }*/
    
    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        let pt = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: pt) {
            //tableView.deselectRowAtIndexPath(indexPath, animated: true)
            cellTapAction(tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (mActiveRival.Id  == "" ? 20 : 40) * mMag
    }
    
    var mCloseRefeshFlag = false
    func refreshAll() {
        mCloseRefeshFlag = true
        refreshAllInternal()
    }
    
    var mThreadIds: [String] = []
    
    internal func refreshAllInternal() {
        
        self.indicator.startAnimating()
        
        self.buttonMenu.isEnabled = false
        self.buttonRefresh.isEnabled = false
        switch self.rparam_ParentCategory {
        case "Recent":
            let bb = [UIBarButtonItem](arrayLiteral: self.buttonMenu, self.buttonRefresh)
            self.navigationController?.navigationBar.topItem?.rightBarButtonItems = bb
        case "Display All Pattern":
            let bb = [UIBarButtonItem](arrayLiteral: self.buttonMenu)
            self.navigationBar.topItem?.rightBarButtonItems = bb
        case "Random Pickup":
            let bb = [UIBarButtonItem](arrayLiteral: self.buttonMenu, self.buttonRefresh)
            self.navigationBar.topItem?.rightBarButtonItems = bb
        default:
            let bb = [UIBarButtonItem](arrayLiteral: self.buttonMenu)
            self.navigationController?.navigationBar.topItem?.rightBarButtonItems = bb
        }

        mActiveRival = FileReader.readRivalList()[FileReader.readActiveRivalNo()]
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let dateStr = formatter.string(from: now)
        self.mCellReuseId = "ScoreListItemCell" + (mActiveRival.Id == "" ? "" : "Rival") + dateStr
        
        mTitle = rparam_Category
        
        let activeFilterId: Int32 = FileReader.readActiveFilterId()
        let activeSortId: Int32 = FileReader.readActiveSortId()
        
        self.mFilterName = FileReader.readFilterName(activeFilterId)!
        
        switch self.rparam_ParentCategory {
        case "Random Pickup": fallthrough
        case "Display All Pattern":
            self.naviTitle.title = self.mTitle
        default:
            self.filterButton.setTitle(self.mFilterName, for: UIControl.State())
            self.sortButton.setTitle(FileReader.readSortName(activeSortId), for: UIControl.State())
        }
        
        OperationQueue().addOperation({ () -> Void in
            
            let threadId = dateStr
            self.mThreadIds.insert(threadId, at: 0)
            
            self.mMusicData = FileReader.readMusicList()
            self.mScoreData = FileReader.readScoreList(nil)
            self.mRivalScoreData = FileReader.readScoreList(self.mActiveRival.Id)
            self.mWebMusicIds = FileReader.readWebMusicIds()
            
            var musicSort = MusicSort(musics: self.mMusicData, scores: self.mScoreData, rivalScores: self.mRivalScoreData, webMusicIds: self.mWebMusicIds)
            var musicFilter = MusicFilter()
            
            if(self.rparam_ParentCategory == "Display All Pattern") {
                musicFilter.Title = self.rparam_Category
                musicSort._1stType = MusicSortType.SPDP
                musicSort._1stOrder = SortOrder.Ascending
                musicSort._2ndType = MusicSortType.Pattern
                musicSort._2ndOrder = SortOrder.Ascending
            }
            else if(self.rparam_ParentCategory == "Random Pickup") {
                if self.rparam_Targets.count > 0 {
                let no = Int(arc4random())%self.rparam_Targets.count
                var cn = 0
                var pat: UniquePattern?
                for target in self.rparam_Targets {
                    if cn == no {
                        pat = target
                        break
                    }
                    cn += 1
                }
                if pat != nil {
                    musicFilter.Title = self.mMusicData[pat!.MusicId]!.Name
                    musicFilter.bSP = false
                    musicFilter.BSP = false
                    musicFilter.DSP = false
                    musicFilter.ESP = false
                    musicFilter.CSP = false
                    musicFilter.BDP = false
                    musicFilter.DDP = false
                    musicFilter.EDP = false
                    musicFilter.CDP = false
                    switch pat!.Pattern {
                    case PatternType.bSP:
                        musicFilter.bSP = true
                    case PatternType.BSP:
                        musicFilter.BSP = true
                    case PatternType.DSP:
                        musicFilter.DSP = true
                    case PatternType.ESP:
                        musicFilter.ESP = true
                    case PatternType.CSP:
                        musicFilter.CSP = true
                    case PatternType.BDP:
                        musicFilter.BDP = true
                    case PatternType.DDP:
                        musicFilter.DDP = true
                    case PatternType.EDP:
                        musicFilter.EDP = true
                    case PatternType.CDP:
                        musicFilter.CDP = true
                    }
                    musicSort._1stType = MusicSortType.SPDP
                    musicSort._1stOrder = SortOrder.Ascending
                    musicSort._2ndType = MusicSortType.Pattern
                    musicSort._2ndOrder = SortOrder.Ascending
                }
                }
                else {
                    musicFilter.Title = ""
                }
            }
            else {
                
                if let tf = FileReader.readFilter(activeFilterId){
                    musicFilter = tf
                }
                else {
                    let _ = FileReader.readFilterCount()
                    musicFilter = FileReader.readFilter(activeFilterId)!
                }
                
                //self.mFilterName = FileReader.readFilterName(activeFilterId)!
                //self.filterButton.setTitle(self.mFilterName, forState: UIControlState.Normal)
                
                if let tf = FileReader.readSort(musicSort, id: activeSortId){
                    musicSort = tf
                }
                else {
                    let _ = FileReader.readSortCount()
                    musicSort = FileReader.readSort(musicSort, id: activeSortId)!
                }
                
                //self.sortButton.setTitle(FileReader.readSortName(activeSortId), forState: UIControlState.Normal)
                
                
                switch self.rparam_ParentCategory {
                case "Series Title":
                    if self.rparam_Category == "A3" { self.mTitle = "DDR A3" }
                    if self.rparam_Category == "A20 PLUS" { self.mTitle = "DDR A20 PLUS" }
                    if self.rparam_Category == "A20" { self.mTitle = "DDR A20" }
                    if self.rparam_Category == "A" { self.mTitle = "DDR A" }
                    if self.rparam_Category == "2014" { self.mTitle = "DDR 2014" }
                    if self.rparam_Category == "2013" { self.mTitle = "DDR 2013" }
                    
                    if self.rparam_Category != "A3" { musicFilter.SerA3 = false }
                    if self.rparam_Category != "A20 PLUS" { musicFilter.SerA20PLUS = false }
                    if self.rparam_Category != "A20" { musicFilter.SerA20 = false }
                    if self.rparam_Category != "A" { musicFilter.SerA = false }
                    if self.rparam_Category != "2014" { musicFilter.Ser2014 = false }
                    if self.rparam_Category != "2013" { musicFilter.Ser2013 = false }
                    if self.rparam_Category != "X3" { musicFilter.SerX3 = false }
                    if self.rparam_Category != "vs 2nd MIX" { musicFilter.SerX3vs2ndMIX = false }
                    if self.rparam_Category != "X2" { musicFilter.SerX2 = false }
                    if self.rparam_Category != "X" { musicFilter.SerX = false }
                    if self.rparam_Category != "Super NOVA2" { musicFilter.SerSuperNova2 = false }
                    if self.rparam_Category != "Super NOVA" { musicFilter.SerSuperNova = false }
                    if self.rparam_Category != "EXTREME" { musicFilter.SerEXTREME = false }
                    if self.rparam_Category != "MAX2" { musicFilter.SerMAX2 = false }
                    if self.rparam_Category != "MAX" { musicFilter.SerMAX = false }
                    if self.rparam_Category != "5th" { musicFilter.Ser5th = false }
                    if self.rparam_Category != "4th" { musicFilter.Ser4th = false }
                    if self.rparam_Category != "3rd" { musicFilter.Ser3rd = false }
                    if self.rparam_Category != "2nd" { musicFilter.Ser2nd = false }
                    if self.rparam_Category != "1st" { musicFilter.Ser1st = false }
                case "ABC":
                    musicFilter.StartsWith = self.rparam_Category
                case "Difficulty":
                    if self.rparam_Category != "1" { musicFilter.Dif1 = false }
                    if self.rparam_Category != "2" { musicFilter.Dif2 = false }
                    if self.rparam_Category != "3" { musicFilter.Dif3 = false }
                    if self.rparam_Category != "4" { musicFilter.Dif4 = false }
                    if self.rparam_Category != "5" { musicFilter.Dif5 = false }
                    if self.rparam_Category != "6" { musicFilter.Dif6 = false }
                    if self.rparam_Category != "7" { musicFilter.Dif7 = false }
                    if self.rparam_Category != "8" { musicFilter.Dif8 = false }
                    if self.rparam_Category != "9" { musicFilter.Dif9 = false }
                    if self.rparam_Category != "10" { musicFilter.Dif10 = false }
                    if self.rparam_Category != "11" { musicFilter.Dif11 = false }
                    if self.rparam_Category != "12" { musicFilter.Dif12 = false }
                    if self.rparam_Category != "13" { musicFilter.Dif13 = false }
                    if self.rparam_Category != "14" { musicFilter.Dif14 = false }
                    if self.rparam_Category != "15" { musicFilter.Dif15 = false }
                    if self.rparam_Category != "16" { musicFilter.Dif16 = false }
                    if self.rparam_Category != "17" { musicFilter.Dif17 = false }
                    if self.rparam_Category != "18" { musicFilter.Dif18 = false }
                    if self.rparam_Category != "19" { musicFilter.Dif19 = false }
                    //if self.rparam_Category != "20" { musicFilter.Dif20 = false }
                case "Dance Level":
                    if self.rparam_Category != "AAA" { musicFilter.RankAAA = false }
                    if self.rparam_Category != "AA+" { musicFilter.RankAAp = false }
                    if self.rparam_Category != "AA" { musicFilter.RankAA = false }
                    if self.rparam_Category != "AA-" { musicFilter.RankAAm = false }
                    if self.rparam_Category != "A+" { musicFilter.RankAp = false }
                    if self.rparam_Category != "A" { musicFilter.RankA = false }
                    if self.rparam_Category != "A-" { musicFilter.RankAm = false }
                    if self.rparam_Category != "B+" { musicFilter.RankBp = false }
                    if self.rparam_Category != "B" { musicFilter.RankB = false }
                    if self.rparam_Category != "B-" { musicFilter.RankBm = false }
                    if self.rparam_Category != "C+" { musicFilter.RankCp = false }
                    if self.rparam_Category != "C" { musicFilter.RankC = false }
                    if self.rparam_Category != "C-" { musicFilter.RankCm = false }
                    if self.rparam_Category != "D+" { musicFilter.RankDp = false }
                    if self.rparam_Category != "D" { musicFilter.RankD = false }
                    if self.rparam_Category != "E" { musicFilter.RankE = false }
                    if self.rparam_Category != "NoPlay" { musicFilter.RankNoPlay = false }
                case "Full Combo Type":
                    if self.rparam_Category == "Failed"
                    {
                        musicFilter.RankAAA = false;
                        musicFilter.RankAAp = false;
                        musicFilter.RankAA = false;
                        musicFilter.RankAAm = false;
                        musicFilter.RankAp = false;
                        musicFilter.RankA = false;
                        musicFilter.RankAm = false;
                        musicFilter.RankBp = false;
                        musicFilter.RankB = false;
                        musicFilter.RankBm = false;
                        musicFilter.RankCp = false;
                        musicFilter.RankC = false;
                        musicFilter.RankCm = false;
                        musicFilter.RankDp = false;
                        musicFilter.RankD = false;
                        musicFilter.RankE = true;
                        musicFilter.RankNoPlay = false;
                        musicFilter.ClearCountMax = 0;
                    }
                    else if self.rparam_Category == "NoPlay"
                    {
                        musicFilter.RankAAA = false;
                        musicFilter.RankAAp = false;
                        musicFilter.RankAA = false;
                        musicFilter.RankAAm = false;
                        musicFilter.RankAp = false;
                        musicFilter.RankA = false;
                        musicFilter.RankAm = false;
                        musicFilter.RankBp = false;
                        musicFilter.RankB = false;
                        musicFilter.RankBm = false;
                        musicFilter.RankCp = false;
                        musicFilter.RankC = false;
                        musicFilter.RankCm = false;
                        musicFilter.RankDp = false;
                        musicFilter.RankD = false;
                        musicFilter.RankE = false;
                        musicFilter.RankNoPlay = true;
                    }
                    else if self.rparam_Category == "NoFC"
                    {
                        musicFilter.FcMFC = false;
                        musicFilter.FcPFC = false;
                        musicFilter.FcFC = false;
                        musicFilter.FcGFC = false;
                        musicFilter.RankNoPlay = false;
                    }
                    else
                    {
                        if self.rparam_Category != "MFC" { musicFilter.FcMFC = false }
                        if self.rparam_Category != "PFC" { musicFilter.FcPFC = false }
                        if self.rparam_Category != "FC" { musicFilter.FcFC = false }
                        if self.rparam_Category != "GFC" { musicFilter.FcGFC = false }
                        if self.rparam_Category != "Life4" { musicFilter.FcLife4 = false }
                        if self.rparam_Category != "NoFC" { musicFilter.FcNoFC = false }
                        if self.rparam_Category == "NoFC"
                        {
                            musicFilter.FcMFC = false;
                            musicFilter.FcPFC = false;
                            musicFilter.FcFC = false;
                            musicFilter.FcGFC = false;
                            musicFilter.RankNoPlay = false;
                        }
                    }
                case "Rival Dance Level":
                    self.mTitle = "Rival " + self.mTitle
                    if self.rparam_Category != "AAA" { musicFilter.RankAAArival = false }
                    if self.rparam_Category != "AA+" { musicFilter.RankAAprival = false }
                    if self.rparam_Category != "AA" { musicFilter.RankAArival = false }
                    if self.rparam_Category != "AA-" { musicFilter.RankAAmrival = false }
                    if self.rparam_Category != "A+" { musicFilter.RankAprival = false }
                    if self.rparam_Category != "A" { musicFilter.RankArival = false }
                    if self.rparam_Category != "A-" { musicFilter.RankAmrival = false }
                    if self.rparam_Category != "B+" { musicFilter.RankBprival = false }
                    if self.rparam_Category != "B" { musicFilter.RankBrival = false }
                    if self.rparam_Category != "B-" { musicFilter.RankBmrival = false }
                    if self.rparam_Category != "C+" { musicFilter.RankCprival = false }
                    if self.rparam_Category != "C-" { musicFilter.RankCrival = false }
                    if self.rparam_Category != "C" { musicFilter.RankCmrival = false }
                    if self.rparam_Category != "D+" { musicFilter.RankDprival = false }
                    if self.rparam_Category != "D" { musicFilter.RankDrival = false }
                    if self.rparam_Category != "E" { musicFilter.RankErival = false }
                    if self.rparam_Category != "NoPlay" { musicFilter.RankNoPlayrival = false }
                case "Rival Full Combo Type":
                    self.mTitle = "Rival " + self.mTitle
                    if self.rparam_Category == "Failed"
                    {
                        musicFilter.RankAAArival = false;
                        musicFilter.RankAAprival = false;
                        musicFilter.RankAArival = false;
                        musicFilter.RankAAmrival = false;
                        musicFilter.RankAprival = false;
                        musicFilter.RankArival = false;
                        musicFilter.RankAmrival = false;
                        musicFilter.RankBprival = false;
                        musicFilter.RankBrival = false;
                        musicFilter.RankBmrival = false;
                        musicFilter.RankCprival = false;
                        musicFilter.RankCrival = false;
                        musicFilter.RankCmrival = false;
                        musicFilter.RankDprival = false;
                        musicFilter.RankDrival = false;
                        musicFilter.RankErival = true;
                        musicFilter.RankNoPlayrival = false;
                    }
                    else if self.rparam_Category == "FcNoPlay"
                    {
                        musicFilter.RankAAArival = false;
                        musicFilter.RankAAprival = false;
                        musicFilter.RankAArival = false;
                        musicFilter.RankAAmrival = false;
                        musicFilter.RankAprival = false;
                        musicFilter.RankArival = false;
                        musicFilter.RankAmrival = false;
                        musicFilter.RankBprival = false;
                        musicFilter.RankBrival = false;
                        musicFilter.RankBmrival = false;
                        musicFilter.RankCprival = false;
                        musicFilter.RankCrival = false;
                        musicFilter.RankCmrival = false;
                        musicFilter.RankDprival = false;
                        musicFilter.RankDrival = false;
                        musicFilter.RankErival = true;
                        musicFilter.RankNoPlayrival = false;
                    }
                    else
                    {
                        if self.rparam_Category != "MFC" { musicFilter.FcMFCrival = false }
                        if self.rparam_Category != "PFC" { musicFilter.FcPFCrival = false }
                        if self.rparam_Category != "FC" { musicFilter.FcFCrival = false }
                        if self.rparam_Category != "GFC" { musicFilter.FcGFCrival = false }
                        if self.rparam_Category != "Life4" { musicFilter.FcLife4rival = false }
                        if self.rparam_Category != "NoFC" { musicFilter.FcNoFCrival = false }
                    }
                case "Rival Win/Lose":
                    self.mTitle = "Rival " + self.mTitle
                    switch self.rparam_Category {
                    case "Win": fallthrough
                    case "Lose": fallthrough
                    case "Draw":
                        if self.rparam_Category != "Win" { musicFilter.RivalWin = false; }
                        if self.rparam_Category != "Lose" { musicFilter.RivalLose = false; }
                        if self.rparam_Category != "Draw" { musicFilter.RivalDraw = false; }
                    case "Win (Close)":
                        musicFilter.RivalLose = false;
                        musicFilter.RivalDraw = false;
                        musicFilter.ScoreDifferencePlusMax = min(musicFilter.ScoreDifferencePlusMax, 1000);
                        musicFilter.ScoreDifferenceMinusMax = 0;
                        musicFilter.ScoreDifferenceMinusMin = 0;
                    case "Lose (Close)":
                        musicFilter.RivalWin = false;
                        musicFilter.RivalDraw = false;
                        musicFilter.ScoreDifferenceMinusMax = max(musicFilter.ScoreDifferenceMinusMax, -1000);
                        musicFilter.ScoreDifferencePlusMax = 0;
                        musicFilter.ScoreDifferencePlusMin = 0;
                    case "Draw (Played)":
                        musicFilter.RivalWin = false;
                        musicFilter.RivalLose = false;
                        musicFilter.RankNoPlay = false;
                        musicFilter.RankNoPlayrival = false;
                    case "Win (Rival NoPlay)":
                        musicFilter.RivalLose = false;
                        musicFilter.RivalDraw = false;
                        musicFilter.RankAAArival = false;
                        musicFilter.RankAAprival = false;
                        musicFilter.RankAArival = false;
                        musicFilter.RankAAmrival = false;
                        musicFilter.RankAprival = false;
                        musicFilter.RankArival = false;
                        musicFilter.RankAmrival = false;
                        musicFilter.RankBprival = false;
                        musicFilter.RankBrival = false;
                        musicFilter.RankBmrival = false;
                        musicFilter.RankCprival = false;
                        musicFilter.RankCrival = false;
                        musicFilter.RankCmrival = false;
                        musicFilter.RankDprival = false;
                        musicFilter.RankDrival = false;
                        musicFilter.RankErival = true;
                    case "Lose (Player NoPlay)":
                        musicFilter.RivalWin = false;
                        musicFilter.RivalDraw = false;
                        musicFilter.RankAAA = false;
                        musicFilter.RankAAp = false;
                        musicFilter.RankAA = false;
                        musicFilter.RankAAm = false;
                        musicFilter.RankAp = false;
                        musicFilter.RankA = false;
                        musicFilter.RankAm = false;
                        musicFilter.RankBp = false;
                        musicFilter.RankB = false;
                        musicFilter.RankBm = false;
                        musicFilter.RankCp = false;
                        musicFilter.RankC = false;
                        musicFilter.RankCm = false;
                        musicFilter.RankDp = false;
                        musicFilter.RankD = false;
                        musicFilter.RankE = true;
                    case "Draw (NoPlay)":
                        musicFilter.RivalWin = false;
                        musicFilter.RivalLose = false;
                        musicFilter.RankAAA = false;
                        musicFilter.RankAAp = false;
                        musicFilter.RankAA = false;
                        musicFilter.RankAAm = false;
                        musicFilter.RankAp = false;
                        musicFilter.RankA = false;
                        musicFilter.RankAm = false;
                        musicFilter.RankBp = false;
                        musicFilter.RankB = false;
                        musicFilter.RankBm = false;
                        musicFilter.RankCp = false;
                        musicFilter.RankC = false;
                        musicFilter.RankCm = false;
                        musicFilter.RankDp = false;
                        musicFilter.RankD = false;
                        musicFilter.RankE = true;
                        musicFilter.RankAAArival = false;
                        musicFilter.RankAAprival = false;
                        musicFilter.RankAArival = false;
                        musicFilter.RankAAmrival = false;
                        musicFilter.RankAprival = false;
                        musicFilter.RankArival = false;
                        musicFilter.RankAmrival = false;
                        musicFilter.RankBprival = false;
                        musicFilter.RankBrival = false;
                        musicFilter.RankBmrival = false;
                        musicFilter.RankCprival = false;
                        musicFilter.RankCrival = false;
                        musicFilter.RankCmrival = false;
                        musicFilter.RankDprival = false;
                        musicFilter.RankDrival = false;
                        musicFilter.RankErival = true;
                    default:
                        break
                    }
                case "My List":
                    self.mTitle = FileReader.readMyListName(Int32(Int(self.rparam_Category)!))!
                    let pats: [UniquePattern] = FileReader.readMyList(Int32(Int(self.rparam_Category)!));
                    musicFilter.MusicIdList = [Int32]();
                    musicFilter.MusicPatternList = [PatternType]();
                    let count: Int = pats.count;
                    for i: Int in 0 ..< count {
                        let pat: UniquePattern = pats[i];
                        musicFilter.MusicIdList?.append(pat.MusicId);
                        musicFilter.MusicPatternList?.append(pat.Pattern);
                    }
                case "Recent":
                    let pats: [RecentData] = FileReader.readRecentList()
                    musicFilter.MusicIdList = [Int32]();
                    musicFilter.MusicPatternList = [PatternType]();
                    let count: Int = pats.count;
                    for i: Int in 0 ..< count {
                        musicFilter.MusicIdList?.append(pats[i].Id);
                        musicFilter.MusicPatternList?.append(pats[i].PatternType_);
                    }
                    musicSort = MusicSortRecent(base: musicSort, recent: pats)
                default:
                    break
                }
                
            }
            
            self.mListItems = UniquePatternCollectionMaker.create(musicFilter, webMusicIds: self.mWebMusicIds, musics: self.mMusicData, scores: &self.mScoreData!, rivalName: self.mActiveRival.Name, rivalScores: &self.mRivalScoreData!)
            //self.mListItems = [UniquePattern]()
            
            //self.mTitle = self.mTitle + " (" + self.mListItems.count.description + ")"
            
            //mListItems.sort{ (m, p) in return m.MusicId < p.MusicId }
            //self.mListItems.sort(musicSort.compare)  /////////////////// EXC_BAD_ACCESS occured on Release Build.
            self.mListItems.sort { m, p in return musicSort.compare(m, plusUniquePattern: p) }
            //sleep(20)
            
            objc_sync_enter(self.mThreadIds)
            var noc = 0
            for no in 0 ..< self.mThreadIds.count {
                noc = no
                if self.mThreadIds[no] == threadId {
                    break
                }
            }
            if noc == 0 {
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    
                    switch self.rparam_ParentCategory {
                    case "Display All Pattern": fallthrough
                    case "Random Pickup":
                        self.naviTitle.title = self.mTitle + " (" + self.mListItems.count.description + ")"
                    default:
                        self.title = self.mTitle + " (" + self.mListItems.count.description + ")"
                    }
                    
                    self.indicator.stopAnimating()
                    
                    self.buttonMenu.isEnabled = true
                    self.buttonRefresh.isEnabled = true
                    switch self.rparam_ParentCategory {
                    case "Recent":
                        let bb = [UIBarButtonItem](arrayLiteral: self.buttonMenu, self.buttonRefresh)
                        self.navigationController?.navigationBar.topItem?.rightBarButtonItems = bb
                    case "Display All Pattern":
                        let bb = [UIBarButtonItem](arrayLiteral: self.buttonMenu)
                        self.navigationBar.topItem?.rightBarButtonItems = bb
                    case "Random Pickup":
                        let bb = [UIBarButtonItem](arrayLiteral: self.buttonMenu, self.buttonRefresh)
                        self.navigationBar.topItem?.rightBarButtonItems = bb
                    default:
                        let bb = [UIBarButtonItem](arrayLiteral: self.buttonMenu)
                        self.navigationController?.navigationBar.topItem?.rightBarButtonItems = bb
                    }
                    
                })
            }
            if noc < self.mThreadIds.count {
                self.mThreadIds.remove(at: noc)
            }
            objc_sync_exit(self.mThreadIds)

        })
        /*
        var musics: [Int32 : MusicData] = FileReader.readMusicList()
        var scores: [Int32 : MusicScore] = FileReader.readScoreList()
        var rivalScores: [Int32 : MusicScore] = [:]
        
        mListItems = UniquePatternCollectionMaker.create(musicFilter, musics: musics, scores: &scores, rivalScores: &rivalScores)
        
        if rparam_ParentCategory == "Display All Pattern" {
            naviTitle.title = rparam_Category + " (" + mListItems.count.description + ")"
        }
        else {
            self.title = rparam_Category + " (" + mListItems.count.description + ")"
        }
        
        //mListItems.sort{ (m, p) in return m.MusicId < p.MusicId }
        mListItems.sort(musicSort.compare)
        
        tableView.reloadData()
        
        self.title = category
        */
    }
    
    @objc internal func refreshButtonTouched(_ sender: UIButton) {
        switch rparam_ParentCategory {
        case "Recent":
            present(ViewFromGateRecent.checkOut(self, processPool: self.rparam_ProcessPool), animated: true, completion: nil)
        case "Random Pickup":
            refreshAll()
        default:
            break
        }
    }
    
    var mActionSheet: ActionSheet!
    var mMessageAlertView: MessageAlertView!
    @objc internal func menuButtonTouched(_ sender: UIBarButtonItem) {
        //sparam_ParentView = self
        //sparam_ListItems = mListItems
        //performSegueWithIdentifier("modalMenuSystem", sender: nil)
        var texts: [String]
        switch rparam_ParentCategory {
        case "Random Pickup":
            texts = actionSheetTextsSystemB
        default:
            texts = actionSheetTextsSystemA
        }
        /*if objc_getClass("UIAlertController") == nil {
            let device = UIDevice.currentDevice().userInterfaceIdiom
            if device == UIUserInterfaceIdiom.Pad {
                var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil)
                var count = 0
                for text in texts {
                    actionSheet.addButtonWithTitle(text)
                    ++count
                }
                actionSheet.addButtonWithTitle("Cancel")
                actionSheet.cancelButtonIndex = count
                actionSheet.tag = sActionSheetIdSystem
                actionSheet.actionSheetStyle = UIActionSheetStyle.BlackTranslucent
                switch rparam_ParentCategory {
                case "Random Pickup": fallthrough
                case "Display All Pattern":
                    actionSheet.showFromBarButtonItem(navigationBar.topItem?.rightBarButtonItem, animated: true)
                default:
                    actionSheet.showFromBarButtonItem(navigationController?.navigationBar.topItem?.rightBarButtonItem, animated: true)
                }
            }
            else {
                var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Close", destructiveButtonTitle: nil)
                for text in texts {
                    actionSheet.addButtonWithTitle(text)
                }
                actionSheet.tag = sActionSheetIdSystem
                actionSheet.actionSheetStyle = UIActionSheetStyle.BlackTranslucent
                actionSheet.showInView(self.view)
            }
        }
        else {
            let device = UIDevice.currentDevice().userInterfaceIdiom
            if device == UIUserInterfaceIdiom.Pad {
                var alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
                //alertController.popoverPresentationController!.sourceView = self.view;
                //alertController.popoverPresentationController!.sourceRect = CGRectMake(0, 0, 0, 0);
                alertController.popoverPresentationController!.barButtonItem = sender
                alertController.addAction(UIAlertAction(title: "test", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    self.presentViewController(ViewPreferences.checkOut(self), animated: true, completion: nil)
                }))
                presentViewController(alertController, animated: true, completion: nil)
            }
            else {
            }
        }*/
        mActionSheet = ActionSheet(title: nil, cancelAction: nil)
        for text in texts {
            var action: (()->Void)
            switch text {
            case NSLocalizedString("Preferences", comment: "ViewScoreList"):
                action = { ()->Void in self.present(ViewPreferences.checkOut(self, processPool: self.rparam_ProcessPool), animated: true, completion: nil) }
            case NSLocalizedString("Player Status", comment: "ViewScoreList"):
                action = { ()->Void in self.present(ViewPlayerStatus.checkOut(self.rparam_ProcessPool), animated: true, completion: nil) }
            case NSLocalizedString("Statistics", comment: "ViewScoreList"):
                action = { ()->Void in self.present(ViewStatistics.checkOut(self.mTitle + " (" + self.mFilterName + ")", scores: self.mScoreData, rivalScores: self.mRivalScoreData, musics: self.mMusicData, webMusicIds: self.mWebMusicIds, targets: self.mListItems), animated: true, completion: nil) }
            case NSLocalizedString("Copy to clipboard", comment: "ViewScoreList"):
                action = { ()->Void in
                    if self.mListItems.count < 0 {
                        return
                    }
                    let targetPattern = self.mListItems[0]
                    let targetMusicData = self.mMusicData[targetPattern.MusicId]!
                    let targetScoreData = self.mScoreData[targetPattern.MusicId]!.getScoreData(targetPattern.Pattern)
                    let formats: [String] = FileReader.readCopyFormats()
                    let formated: [String] = [
                        StringUtil.textFromCopyFormat(formats[0], targetPattern: targetPattern, targetMusicData: targetMusicData, targetScoreData: targetScoreData),
                        StringUtil.textFromCopyFormat(formats[1], targetPattern: targetPattern, targetMusicData: targetMusicData, targetScoreData: targetScoreData),
                        StringUtil.textFromCopyFormat(formats[2], targetPattern: targetPattern, targetMusicData: targetMusicData, targetScoreData: targetScoreData),
                        ]
                    self.mActionSheet = ActionSheet(title: NSLocalizedString("Select format", comment: "ViewScoreList"), cancelAction: { ()->Void in  })
                    for i in 0 ..< formats.count {
                        self.mActionSheet.addAction(ActionSheetAction(title: formated[i], method: { () -> Void in
                            var copyText = ""
                                for it in 0 ..< self.mListItems.count {
                                    let targetPattern = self.mListItems[it]
                                    let targetMusicData = self.mMusicData[targetPattern.MusicId]!
                                    let targetScoreData = self.mScoreData[targetPattern.MusicId]!.getScoreData(targetPattern.Pattern)
                                    copyText = copyText + StringUtil.textFromCopyFormat(formats[i], targetPattern: targetPattern, targetMusicData: targetMusicData, targetScoreData: targetScoreData) + "\n"
                                }
                            let clip = UIPasteboard.general
                            clip.setValue(copyText, forPasteboardType: "public.utf8-plain-text")
                            self.mMessageAlertView = MessageAlertView(title: "", message: NSLocalizedString("Scoredata has been copied to clipboard.", comment: "ViewScoreList"), okAction: MessageAlertViewAction(method: {()->Void in }), cancelAction: nil)
                            self.mMessageAlertView.show(self)
                        }))
                    }
                    self.mActionSheet.addAction(ActionSheetAction(title: NSLocalizedString("Edit copy formats...", comment: "ViewScoreList"), method: { () -> Void in
                        self.present(ViewCopyFormatList.checkOut(self, targetPattern: nil, targetMusicData: nil, targetScoreData: nil), animated: true, completion: nil)
                    }))
                    self.mActionSheet.show(self, barButtonItem: self.buttonMenu)
                }
            case NSLocalizedString("from GATE (simple)", comment: "ViewScoreList"):
                action = { ()->Void in
                    self.mMessageAlertView = MessageAlertView(title: NSLocalizedString("from GATE (simple)", comment: "ViewScoreList"), message: NSLocalizedString("Load all scores from GATE with no detail data.", comment: "ViewScoreList"), okAction: MessageAlertViewAction(method: {()->Void in
                        self.present(ViewFromGateList.checkOut(self, rivalId: nil, rivalName: nil, processPool: self.rparam_ProcessPool), animated: true, completion: nil)
                    }), cancelAction: MessageAlertViewAction(method: {()->Void in }))
                    self.mMessageAlertView.show(self)
                }
            case NSLocalizedString("from GATE (detail)", comment: "ViewScoreList"):
                action = { ()->Void in
                    self.mMessageAlertView = MessageAlertView(title: NSLocalizedString("from GATE (detail)", comment: "ViewScoreList"), message: NSLocalizedString("Load scores listed from GATE with detail data.", comment: "ViewScoreList"), okAction: MessageAlertViewAction(method: {()->Void in
                        self.present(ViewFromGate.checkOut(self, musics: self.mMusicData, targets: self.mListItems, rivalId: nil, rivalName: nil, processPool: self.rparam_ProcessPool), animated: true, completion: nil)
                    }), cancelAction: MessageAlertViewAction(method: {()->Void in }))
                    self.mMessageAlertView.show(self)
                }
            case NSLocalizedString("DDR SA", comment: "ViewScoreList"):
                action = { ()->Void in self.present(ViewDdrSa.checkOut(), animated: true, completion: nil) }
            case NSLocalizedString("Random Pickup", comment: "ViewScoreList"):
                action = { ()->Void in self.present(ViewScoreList.checkOut("Random Pickup", category: "Random Pickup", targets: self.mListItems, parentScoreList: self, processPool: self.rparam_ProcessPool), animated: true, completion: nil) }
            case NSLocalizedString("Manage Rivals", comment: "ViewScoreList"):
                action = { ()->Void in self.present(ViewManageRivals.checkOut(self, listItems: self.mListItems, fromMenu: true, processPool: self.rparam_ProcessPool), animated: true, completion: nil) }
            default:
                action = { ()->Void in }
            }
            mActionSheet.addAction(ActionSheetAction(title: text, method: action))
        }
        mActionSheet.show(self, barButtonItem: buttonMenu)
        //presentViewController(ViewMenuSystem.checkOut(self, scores: mScoreData, rivalScores: mRivalScoreData, musics: mMusicData, webMusicIds: mWebMusicIds, listItems: mListItems), animated: true, completion: nil)
    }
    
    @objc internal func stopButtonTouched(_ sender: UIButton) {
        if mCloseRefeshFlag {
            rparam_ParentScoreListView?.refreshAll()
        }
        //presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch rparam_ParentCategory {
        case "Recent":
            sortButton.isHidden = true
            sortLabel.isHidden = true
        case "Display All Pattern":
            let bl = [UIBarButtonItem](arrayLiteral: buttonStop)
            navigationBar.topItem?.leftBarButtonItems = bl
            let bb = [UIBarButtonItem](arrayLiteral: buttonMenu)
            navigationBar.topItem?.rightBarButtonItems = bb
        case "Random Pickup":
            let bl = [UIBarButtonItem](arrayLiteral: buttonStop)
            navigationBar.topItem?.leftBarButtonItems = bl
            let bb = [UIBarButtonItem](arrayLiteral: buttonMenu, buttonRefresh)
            navigationBar.topItem?.rightBarButtonItems = bb
        default:
            break
        }
        if let indexPathes = tableView.indexPathsForSelectedRows {
            if let indexPath = indexPathes.first as IndexPath? {
                tableView.deselectRow(at: indexPath, animated: false)
            }
        }
        Admob.shAdView(adHeight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        switch rparam_ParentCategory {
        //case "Random Pickup":
            //let nvFrame: CGRect = navigationBar.frame;
            //tableView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height, left: 0, bottom: 0, right: 0)
            //tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        case "Recent":
            let bb = [UIBarButtonItem](arrayLiteral: buttonMenu, buttonRefresh)
            navigationController?.navigationBar.topItem?.rightBarButtonItems = bb
        //case "Display All Pattern":
            //let nvFrame: CGRect = navigationBar.frame;
            //tableView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height, left: 0, bottom: 0, right: 0)
            //tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        default:
            let bb = [UIBarButtonItem](arrayLiteral: buttonMenu)
            navigationController?.navigationBar.topItem?.rightBarButtonItems = bb
        }
    }
    
    var buttonRefresh: UIBarButtonItem!
    var buttonMenu: UIBarButtonItem!
    var buttonStop: UIBarButtonItem!
    
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
        
        buttonMenu = UIBarButtonItem(title: "☰", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ViewScoreList.menuButtonTouched(_:)))
        buttonMenu.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24)], for: UIControl.State())
        buttonMenu.isEnabled = false
        buttonRefresh = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(ViewScoreList.refreshButtonTouched(_:)))
        buttonRefresh.isEnabled = false
        buttonStop = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(ViewScoreList.stopButtonTouched(_:)))

        switch rparam_ParentCategory {
        case "Display All Pattern": fallthrough
        case "Random Pickup":
            naviTitle.title = ""
            let nvFrame: CGRect = navigationBar.frame;
            tableView.contentInset = UIEdgeInsets(top: nvFrame.origin.y + nvFrame.height, left: 0, bottom: 0, right: 0)
            navigationBar.delegate = self
        default:
            let filterBtnLabel = filterButton.titleLabel
            filterBtnLabel?.adjustsFontSizeToFitWidth = true
            filterBtnLabel?.minimumScaleFactor = 0.5
            let sortBtnLabel = sortButton.titleLabel
            sortBtnLabel?.adjustsFontSizeToFitWidth = true
            sortBtnLabel?.minimumScaleFactor = 0.5
        }
        adView.addSubview(Admob.getAdBannerView(self))

        tableView.indicatorStyle = UIScrollView.IndicatorStyle.white
        tableView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshAllInternal()

        //var nib  = UINib(nibName: "ScoreListItem", bundle: nil)
        //tableView.registerNib(nib, forCellReuseIdentifier: "ScoreListItemCell")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
