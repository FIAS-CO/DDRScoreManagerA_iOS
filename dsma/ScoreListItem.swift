//
//  ScoreListItem.swift
//  dsm
//
//  Created by LinaNfinE on 6/4/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit

class ScoreListItem: UITableViewCell{
    
    var mLabelDifficulty: UILabel!
    var mLabelSPDP: UILabel!
    var mLabelTitle: UILabel!
    var mLabelClear: UILabel!
    var mLabelSlashCP: UILabel!
    var mLabelPlay: UILabel!
    var mLabelDanceLevel: UILabel!
    var mLabelDanceLevelPM: UILabel!
    var mLabelFC: UILabel!
    var mLabelScore: UILabel!
    var mLabelSlashSC: UILabel!
    var mLabelCombo: UILabel!
    
    var mLabelRivalDifference: UILabel!
    var mLabelRivalName: UILabel!
    var mLabelRivalColon: UILabel!
    var mLabelRivalClear: UILabel!
    var mLabelRivalSlashCP: UILabel!
    var mLabelRivalPlay: UILabel!
    var mLabelRivalDanceLevel: UILabel!
    var mLabelRivalDanceLevelPM: UILabel!
    var mLabelRivalFC: UILabel!
    var mLabelRivalScore: UILabel!
    var mLabelRivalSlashSC: UILabel!
    var mLabelRivalCombo: UILabel!
    
    var mRivalView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let device: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom
        var mag: Double = 1
        if device == UIUserInterfaceIdiom.pad {
            mag = 1.5
        }
        let _18: CGFloat = CGFloat(mag*18)
        let _20: CGFloat = CGFloat(mag*20)
        let _12: CGFloat = CGFloat(mag*12)
        let _17: CGFloat = CGFloat(mag*17)
        let _10: CGFloat = CGFloat(mag*10)
        let _25: CGFloat = CGFloat(mag*25)
        let _11: CGFloat = CGFloat(mag*11)
        let _5: CGFloat = CGFloat(mag*5)
        let _27: CGFloat = CGFloat(mag*27)
        let _30: CGFloat = CGFloat(mag*30)
        let _35: CGFloat = CGFloat(mag*35)
        let _3: CGFloat = CGFloat(mag*3)
        let _60: CGFloat = CGFloat(mag*60)
        let _70: CGFloat = CGFloat(mag*70)
        
        self.backgroundColor = UIColor(white: 0, alpha: 0.01)
        self.contentView.backgroundColor = UIColor.clear
        
        let upperView: UIView = UIView(frame: CGRect.zero)
        upperView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(upperView)
        
        let lowerView: UIView = UIView(frame: CGRect.zero)
        lowerView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(lowerView)
        
        mRivalView = lowerView
        
        mLabelDifficulty = UILabel(frame: CGRect.zero)
        mLabelDifficulty.textColor = UIColor.white
        mLabelDifficulty.font = UIFont(name: "Helvetica", size: _18)
        mLabelDifficulty.textAlignment = NSTextAlignment.right
        mLabelDifficulty.translatesAutoresizingMaskIntoConstraints = false
        upperView.addSubview(mLabelDifficulty)
        
        mLabelSPDP = UILabel(frame: CGRect.zero)
        mLabelSPDP.textColor = UIColor.white
        mLabelSPDP.font = UIFont(name: "Helvetica Bold", size: _20)
        mLabelSPDP.textAlignment = NSTextAlignment.left
        mLabelSPDP.translatesAutoresizingMaskIntoConstraints = false
        upperView.addSubview(mLabelSPDP)
        
        mLabelTitle = UILabel(frame: CGRect.zero)
        mLabelTitle.textColor = UIColor.white
        mLabelTitle.font = UIFont(name: "Hiragino Kaku Gothic ProN W6", size: _12)
        mLabelTitle.textAlignment = NSTextAlignment.left
        mLabelTitle.adjustsFontSizeToFitWidth = true
        mLabelTitle.minimumScaleFactor = 0.5
        mLabelTitle.translatesAutoresizingMaskIntoConstraints = false
        upperView.addSubview(mLabelTitle)
        
        mLabelClear = UILabel(frame: CGRect.zero)
        mLabelClear.textColor = UIColor.gray
        mLabelClear.font = UIFont(name: "Helvetica", size: _12)
        mLabelClear.textAlignment = NSTextAlignment.right
        mLabelClear.translatesAutoresizingMaskIntoConstraints = false
        upperView.addSubview(mLabelClear)
        
        mLabelSlashCP = UILabel(frame: CGRect.zero)
        mLabelSlashCP.textColor = UIColor.gray
        mLabelSlashCP.font = UIFont(name: "Helvetica", size: _12)
        mLabelSlashCP.textAlignment = NSTextAlignment.right
        mLabelSlashCP.text = "/"
        mLabelSlashCP.translatesAutoresizingMaskIntoConstraints = false
        upperView.addSubview(mLabelSlashCP)
        
        mLabelPlay = UILabel(frame: CGRect.zero)
        mLabelPlay.textColor = UIColor.gray
        mLabelPlay.font = UIFont(name: "Helvetica", size: _12)
        mLabelPlay.textAlignment = NSTextAlignment.right
        mLabelPlay.translatesAutoresizingMaskIntoConstraints = false
        upperView.addSubview(mLabelPlay)
        
        mLabelDanceLevel = UILabel(frame: CGRect.zero)
        mLabelDanceLevel.textColor = UIColor.white
        mLabelDanceLevel.font = UIFont(name: "Helvetica", size: _17)
        mLabelDanceLevel.textAlignment = NSTextAlignment.right
        mLabelDanceLevel.translatesAutoresizingMaskIntoConstraints = false
        upperView.addSubview(mLabelDanceLevel)
        
        mLabelDanceLevelPM = UILabel(frame: CGRect.zero)
        mLabelDanceLevelPM.textColor = UIColor.white
        mLabelDanceLevelPM.font = UIFont(name: "Helvetica", size: _17)
        mLabelDanceLevelPM.textAlignment = NSTextAlignment.left
        mLabelDanceLevelPM.translatesAutoresizingMaskIntoConstraints = false
        upperView.addSubview(mLabelDanceLevelPM)
        
        mLabelFC = UILabel(frame: CGRect.zero)
        mLabelFC.textColor = UIColor.white
        mLabelFC.font = UIFont(name: "Helvetica Bold", size: _10)
        mLabelFC.textAlignment = NSTextAlignment.right
        mLabelFC.text = "o"
        mLabelFC.translatesAutoresizingMaskIntoConstraints = false
        upperView.addSubview(mLabelFC)
        
        mLabelScore = UILabel(frame: CGRect.zero)
        mLabelScore.textColor = UIColor.white
        mLabelScore.font = UIFont(name: "Helvetica", size: _12)
        mLabelScore.textAlignment = NSTextAlignment.right
        mLabelScore.translatesAutoresizingMaskIntoConstraints = false
        upperView.addSubview(mLabelScore)
        
        mLabelSlashSC = UILabel(frame: CGRect.zero)
        mLabelSlashSC.textColor = UIColor.gray
        mLabelSlashSC.font = UIFont(name: "Helvetica", size: _12)
        mLabelSlashSC.textAlignment = NSTextAlignment.right
        mLabelSlashSC.text = "/"
        mLabelSlashSC.translatesAutoresizingMaskIntoConstraints = false
        upperView.addSubview(mLabelSlashSC)
        
        mLabelCombo = UILabel(frame: CGRect.zero)
        mLabelCombo.textColor = UIColor.gray
        mLabelCombo.font = UIFont(name: "Helvetica", size: _12)
        mLabelCombo.textAlignment = NSTextAlignment.right
        mLabelCombo.translatesAutoresizingMaskIntoConstraints = false
        upperView.addSubview(mLabelCombo)
        
        mLabelRivalDifference = UILabel(frame: CGRect.zero)
        mLabelRivalDifference.textColor = UIColor.white
        mLabelRivalDifference.font = UIFont(name: "Helvetica", size: _12)
        mLabelRivalDifference.textAlignment = NSTextAlignment.right
        mLabelRivalDifference.translatesAutoresizingMaskIntoConstraints = false
        lowerView.addSubview(mLabelRivalDifference)
        
        mLabelRivalName = UILabel(frame: CGRect.zero)
        mLabelRivalName.textColor = UIColor.darkGray
        mLabelRivalName.font = UIFont(name: "Helvetica", size: _12)
        mLabelRivalName.textAlignment = NSTextAlignment.right
        mLabelRivalName.adjustsFontSizeToFitWidth = true
        mLabelRivalName.minimumScaleFactor = 0.5
        mLabelRivalName.translatesAutoresizingMaskIntoConstraints = false
        lowerView.addSubview(mLabelRivalName)
        
        mLabelRivalColon = UILabel(frame: CGRect.zero)
        mLabelRivalColon.textColor = UIColor.darkGray
        mLabelRivalColon.font = UIFont(name: "Helvetica", size: _12)
        mLabelRivalColon.textAlignment = NSTextAlignment.left
        mLabelRivalColon.text = ":"
        mLabelRivalColon.translatesAutoresizingMaskIntoConstraints = false
        lowerView.addSubview(mLabelRivalColon)
        
        mLabelRivalClear = UILabel(frame: CGRect.zero)
        mLabelRivalClear.textColor = UIColor.gray
        mLabelRivalClear.font = UIFont(name: "Helvetica", size: _12)
        mLabelRivalClear.textAlignment = NSTextAlignment.right
        mLabelRivalClear.translatesAutoresizingMaskIntoConstraints = false
        lowerView.addSubview(mLabelRivalClear)
        
        mLabelRivalSlashCP = UILabel(frame: CGRect.zero)
        mLabelRivalSlashCP.textColor = UIColor.gray
        mLabelRivalSlashCP.font = UIFont(name: "Helvetica", size: _12)
        mLabelRivalSlashCP.textAlignment = NSTextAlignment.right
        mLabelRivalSlashCP.text = "/"
        mLabelRivalSlashCP.translatesAutoresizingMaskIntoConstraints = false
        lowerView.addSubview(mLabelRivalSlashCP)
        
        mLabelRivalPlay = UILabel(frame: CGRect.zero)
        mLabelRivalPlay.textColor = UIColor.gray
        mLabelRivalPlay.font = UIFont(name: "Helvetica", size: _12)
        mLabelRivalPlay.textAlignment = NSTextAlignment.right
        mLabelRivalPlay.translatesAutoresizingMaskIntoConstraints = false
        lowerView.addSubview(mLabelRivalPlay)
        
        mLabelRivalDanceLevel = UILabel(frame: CGRect.zero)
        mLabelRivalDanceLevel.textColor = UIColor.white
        mLabelRivalDanceLevel.font = UIFont(name: "Helvetica", size: _17)
        mLabelRivalDanceLevel.textAlignment = NSTextAlignment.right
        mLabelRivalDanceLevel.translatesAutoresizingMaskIntoConstraints = false
        lowerView.addSubview(mLabelRivalDanceLevel)
        
        mLabelRivalDanceLevelPM = UILabel(frame: CGRect.zero)
        mLabelRivalDanceLevelPM.textColor = UIColor.white
        mLabelRivalDanceLevelPM.font = UIFont(name: "Helvetica", size: _17)
        mLabelRivalDanceLevelPM.textAlignment = NSTextAlignment.left
        mLabelRivalDanceLevelPM.translatesAutoresizingMaskIntoConstraints = false
        lowerView.addSubview(mLabelRivalDanceLevelPM)
        
        mLabelRivalFC = UILabel(frame: CGRect.zero)
        mLabelRivalFC.textColor = UIColor.white
        mLabelRivalFC.font = UIFont(name: "Helvetica Bold", size: _10)
        mLabelRivalFC.textAlignment = NSTextAlignment.right
        mLabelRivalFC.text = "o"
        mLabelRivalFC.translatesAutoresizingMaskIntoConstraints = false
        lowerView.addSubview(mLabelRivalFC)
        
        mLabelRivalScore = UILabel(frame: CGRect.zero)
        mLabelRivalScore.textColor = UIColor.white
        mLabelRivalScore.font = UIFont(name: "Helvetica", size: _12)
        mLabelRivalScore.textAlignment = NSTextAlignment.right
        mLabelRivalScore.translatesAutoresizingMaskIntoConstraints = false
        lowerView.addSubview(mLabelRivalScore)
        
        mLabelRivalSlashSC = UILabel(frame: CGRect.zero)
        mLabelRivalSlashSC.textColor = UIColor.gray
        mLabelRivalSlashSC.font = UIFont(name: "Helvetica", size: _12)
        mLabelRivalSlashSC.textAlignment = NSTextAlignment.right
        mLabelRivalSlashSC.text = "/"
        mLabelRivalSlashSC.translatesAutoresizingMaskIntoConstraints = false
        lowerView.addSubview(mLabelRivalSlashSC)
        
        mLabelRivalCombo = UILabel(frame: CGRect.zero)
        mLabelRivalCombo.textColor = UIColor.gray
        mLabelRivalCombo.font = UIFont(name: "Helvetica", size: _12)
        mLabelRivalCombo.textAlignment = NSTextAlignment.right
        mLabelRivalCombo.translatesAutoresizingMaskIntoConstraints = false
        lowerView.addSubview(mLabelRivalCombo)
        
        let views: [String : UIView] = [
            "upperview": upperView,
            "lowerview": lowerView,
            "difficulty": mLabelDifficulty,
            "spdp": mLabelSPDP,
            "title": mLabelTitle,
            "clear": mLabelClear,
            "slashCP": mLabelSlashCP,
            "play": mLabelPlay,
            "dancelevel": mLabelDanceLevel,
            "dancelevelpm": mLabelDanceLevelPM,
            "fullcombo": mLabelFC,
            "score": mLabelScore,
            "slashSC": mLabelSlashSC,
            "combo": mLabelCombo,
            "rivaldiff": mLabelRivalDifference,
            "rivalname": mLabelRivalName,
            "rivalcolon": mLabelRivalColon,
            "rivalclear": mLabelRivalClear,
            "rivalslashCP": mLabelRivalSlashCP,
            "rivalplay": mLabelRivalPlay,
            "rivaldancelevel": mLabelRivalDanceLevel,
            "rivaldancelevelpm": mLabelRivalDanceLevelPM,
            "rivalfullcombo": mLabelRivalFC,
            "rivalscore": mLabelRivalScore,
            "rivalslashSC": mLabelRivalSlashSC,
            "rivalcombo": mLabelRivalCombo,
        ]
        
        let pref: Preferences = FileReader.readPreferences()
        
        if reuseIdentifier.range(of: "Rival") == nil {
            lowerView.isHidden = true
        }
        
        // This method will be deprecated in a future release.
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[upperview]|", options: [], metrics: nil, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[lowerview]|", options: [], metrics: nil, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[upperview"+(reuseIdentifier.range(of: "Rival") == nil ? "" : "(=="+_20.description+")][lowerview")+"]|", options: [], metrics: nil, views: views))
        
        upperView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[difficulty(=="+_25.description+")][spdp(=="+_11.description+")][title]-"+_5.description+"-[clear(==" + (pref.VisibleItems_ClearCount ? _30.description : "0" ) + ")][slashCP(==" + (pref.VisibleItems_ClearCount && pref.VisibleItems_PlayCount ? _5.description : "0" ) + ")][play(==" + (pref.VisibleItems_PlayCount ? _30.description : "0" ) + ")]-"+_5.description+"-[dancelevel(==" + (pref.VisibleItems_DanceLevel ? _35.description : "0" ) + ")]-(0)-[dancelevelpm(==" + (pref.VisibleItems_DanceLevel ? _11.description : "0" ) + ")]-" + (pref.VisibleItems_DanceLevel ? "(-"+_27.description+")-[fullcombo(=="+_20.description+")]-" : "0-[fullcombo(==0)]-") + "(-"+_3.description+")-[score(==" + (pref.VisibleItems_Score ? _60.description : "0" ) + ")][slashSC(==" + (pref.VisibleItems_Score && pref.VisibleItems_MaxCombo ? _5.description : "0" ) + ")][combo(==" + (pref.VisibleItems_MaxCombo ? _30.description : "0" ) + ")]|", options: [], metrics: nil, views: views))
        upperView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[difficulty]|", options: [], metrics: nil, views: views))
        upperView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[spdp]|", options: [], metrics: nil, views: views))
        upperView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[title]|", options: [], metrics: nil, views: views))
        upperView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[clear]|", options: [], metrics: nil, views: views))
        upperView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[slashCP]|", options: [], metrics: nil, views: views))
        upperView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[play]|", options: [], metrics: nil, views: views))
        upperView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dancelevel]|", options: [], metrics: nil, views: views))
        upperView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dancelevelpm]|", options: [], metrics: nil, views: views))
        upperView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(-"+_5.description+")-[fullcombo]-5-|", options: [], metrics: nil, views: views))
        upperView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[score]|", options: [], metrics: nil, views: views))
        upperView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[slashSC]|", options: [], metrics: nil, views: views))
        upperView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[combo]|", options: [], metrics: nil, views: views))
        
        lowerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[rivaldiff(=="+_70.description+")]-"+_5.description+"-[rivalname][rivalcolon(=="+_5.description+")][rivalclear(==" + (pref.VisibleItems_ClearCount ? "0" : "0" ) + ")][rivalslashCP(==" + (pref.VisibleItems_ClearCount && pref.VisibleItems_PlayCount ? "0" : "0" ) + ")][rivalplay(==" + (pref.VisibleItems_PlayCount ? "0" : "0" ) + ")]-"+_5.description+"-[rivaldancelevel(==" + (pref.VisibleItems_DanceLevel ? _35.description : "0" ) + ")]-(0)-[rivaldancelevelpm(==" + (pref.VisibleItems_DanceLevel ? _11.description : "0" ) + ")]-" + (pref.VisibleItems_DanceLevel ? "(-"+_27.description+")-[rivalfullcombo(=="+_20.description+")]-" : "0-[rivalfullcombo(==0)]-") + "(-"+_3.description+")-[rivalscore(==" + (pref.VisibleItems_Score ? _60.description : "0" ) + ")][rivalslashSC(==" + (pref.VisibleItems_Score && pref.VisibleItems_MaxCombo ? _5.description : "0" ) + ")][rivalcombo(==" + (pref.VisibleItems_MaxCombo ? _30.description : "0" ) + ")]|", options: [], metrics: nil, views: views))
        lowerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[rivaldiff]|", options: [], metrics: nil, views: views))
        lowerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[rivalname]|", options: [], metrics: nil, views: views))
        lowerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[rivalcolon]|", options: [], metrics: nil, views: views))
        lowerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[rivalclear]|", options: [], metrics: nil, views: views))
        lowerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[rivalslashCP]|", options: [], metrics: nil, views: views))
        lowerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[rivalplay]|", options: [], metrics: nil, views: views))
        lowerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[rivaldancelevel]|", options: [], metrics: nil, views: views))
        lowerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[rivaldancelevelpm]|", options: [], metrics: nil, views: views))
        lowerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(-"+_5.description+")-[rivalfullcombo]-5-|", options: [], metrics: nil, views: views))
        lowerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[rivalscore]|", options: [], metrics: nil, views: views))
        lowerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[rivalslashSC]|", options: [], metrics: nil, views: views))
        lowerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[rivalcombo]|", options: [], metrics: nil, views: views))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
