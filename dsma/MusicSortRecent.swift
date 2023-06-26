//
//  MusicSortRecent.swift
//  dsm
//
//  Created by LinaNfinE on 7/9/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit

class MusicSortRecent: MusicSort {
    var mRecent: [RecentData]
    
    init(base: MusicSort, recent: [RecentData]) {
        mRecent = recent
        super.init(musics: base.mMusicData, scores: base.mScoreData, rivalScores: base.mRivalScoreData, webMusicIds: base.mWebMusicIds)
        super._1stType = MusicSortType.Recent
        super._2ndType = MusicSortType.SPDP
        super._3rdType = MusicSortType.Pattern
    }
    
    override func compare(_ m: UniquePattern, p: UniquePattern, section: Int32) -> (Bool) {
        var type: MusicSortType;
        //var order: SortOrder;
        if(section == 1)
        {
            type = _1stType;
            //order = _1stOrder;
        }
        else if(section == 2)
        {
            type = _2ndType;
            //order = _2ndOrder;
        }
        else if(section == 3){
            type = _3rdType;
            //order = _3rdOrder;
        }
        else if(section == 4){
            type = _4thType;
            //order = _4thOrder;
        }
        else if(section == 5){
            type = _5thType;
            //order = _5thOrder;
        }
        else
        {
            return false;
        }
        if type != MusicSortType.Recent {
            return super.compare(m, p: p, section: section)
        }
        if let pi = mRecent.firstIndex(of: RecentData(Id: p.MusicId, PatternType_: p.Pattern)) {
            if let mi = mRecent.firstIndex(of: RecentData(Id: m.MusicId, PatternType_: m.Pattern)) {
                return pi == mi ? compare(m, p: p, section: section+1) : pi > mi
            }
        }
        return false
    }
}
