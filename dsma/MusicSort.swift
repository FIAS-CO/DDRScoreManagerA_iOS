//
//  MusicSort.swift
//  dsm
//
//  Created by LinaNfinE on 6/9/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

// ID sort mijissou

import UIKit

class MusicSort{
    
    var mMusicData: [Int32 : MusicData]
    var mScoreData: [Int32 : MusicScore]
    var mRivalScoreData: [Int32 : MusicScore]
    var mWebMusicIds: [Int32 : WebMusicId]
    
    var _1stType: MusicSortType = MusicSortType.None
    var _1stOrder: SortOrder = SortOrder.Ascending
    var _2ndType: MusicSortType = MusicSortType.None
    var _2ndOrder: SortOrder = SortOrder.Ascending
    var _3rdType: MusicSortType = MusicSortType.None
    var _3rdOrder: SortOrder = SortOrder.Ascending
    var _4thType: MusicSortType = MusicSortType.None
    var _4thOrder: SortOrder = SortOrder.Ascending
    var _5thType: MusicSortType = MusicSortType.None
    var _5thOrder: SortOrder = SortOrder.Ascending
    
    init (musics: [Int32 : MusicData], scores: [Int32 : MusicScore], rivalScores: [Int32 : MusicScore], webMusicIds: [Int32 : WebMusicId]) {
        mMusicData = musics
        mScoreData = scores
        mRivalScoreData = rivalScores
        mWebMusicIds = webMusicIds
    }

    func compare<T>(_ minusUniquePattern: T, plusUniquePattern: T) -> (Bool) {
        let m: UniquePattern = minusUniquePattern as! UniquePattern
        let p: UniquePattern = plusUniquePattern as! UniquePattern
        if(p.MusicId < 0) {
            if(m.MusicId < 0) {
                return false;
            }
            else {
                return true;
            }
        }
        else if(m.MusicId < 0) {
            return false;
        }
        return compare(m, p: p, section: 1)
    }
    
    // protected //
    internal func compare(_ m: UniquePattern, p: UniquePattern, section: Int32) -> (Bool) {
        var sub: Int32 = 0
        var type: MusicSortType;
        var order: SortOrder;
        if(section == 1)
        {
            type = _1stType;
            order = _1stOrder;
        }
        else if(section == 2)
        {
            type = _2ndType;
            order = _2ndOrder;
        }
        else if(section == 3){
            type = _3rdType;
            order = _3rdOrder;
        }
        else if(section == 4){
            type = _4thType;
            order = _4thOrder;
        }
        else if(section == 5){
            type = _5thType;
            order = _5thOrder;
        }
        else
        {
            return false;
        }
        if(type == MusicSortType.None)
        {
            //return false;
            type = MusicSortType.MusicName
        }
        var scoreP: ScoreData;
        if let scorep = mScoreData[p.MusicId]
        {
            switch(p.Pattern)
            {
            case PatternType.bSP:
                scoreP = scorep.bSP;
                break;
            case PatternType.BSP:
                scoreP = scorep.BSP;
                break;
            case PatternType.DSP:
                scoreP = scorep.DSP;
                break;
            case PatternType.ESP:
                scoreP = scorep.ESP;
                break;
            case PatternType.CSP:
                scoreP = scorep.CSP;
                break;
            case PatternType.BDP:
                scoreP = scorep.BDP;
                break;
            case PatternType.DDP:
                scoreP = scorep.DDP;
                break;
            case PatternType.EDP:
                scoreP = scorep.EDP;
                break;
            case PatternType.CDP:
                scoreP = scorep.CDP;
                break;
            //default:
            //    scoreP = ScoreData();
            //    break;
            }
        }
        else
        {
            scoreP = ScoreData();
        }
        var scoreM: ScoreData;
        if let scorem = mScoreData[m.MusicId]
        {
            switch(m.Pattern)
            {
            case PatternType.bSP:
                scoreM = scorem.bSP;
                break;
            case PatternType.BSP:
                scoreM = scorem.BSP;
                break;
            case PatternType.DSP:
                scoreM = scorem.DSP;
                break;
            case PatternType.ESP:
                scoreM = scorem.ESP;
                break;
            case PatternType.CSP:
                scoreM = scorem.CSP;
                break;
            case PatternType.BDP:
                scoreM = scorem.BDP;
                break;
            case PatternType.DDP:
                scoreM = scorem.DDP;
                break;
            case PatternType.EDP:
                scoreM = scorem.EDP;
                break;
            case PatternType.CDP:
                scoreM = scorem.CDP;
                break;
            //default:
            //    scoreM = ScoreData();
            //    break;
            }
        }
        else
        {
            scoreM = ScoreData();
        }
        var rivalP: ScoreData;
        var rivalM: ScoreData;
        switch(type)
        {
        case MusicSortType.RivalScore: fallthrough
        case MusicSortType.RivalRank: fallthrough
        case MusicSortType.RivalFullComboType: fallthrough
        case MusicSortType.RivalComboCount: fallthrough
        //case MusicSortType.RivalPlayCount: fallthrough
        //case MusicSortType.RivalClearCount: fallthrough
        case MusicSortType.RivalScoreDifference: fallthrough
        case MusicSortType.RivalScoreDifferenceAbs:
            //{
                if let rivalscorep: MusicScore = mRivalScoreData[p.MusicId]
                {
                    switch(p.Pattern)
                    {
                    case PatternType.bSP:
                        rivalP = rivalscorep.bSP;
                        break;
                    case PatternType.BSP:
                        rivalP = rivalscorep.BSP;
                        break;
                    case PatternType.DSP:
                        rivalP = rivalscorep.DSP;
                        break;
                    case PatternType.ESP:
                        rivalP = rivalscorep.ESP;
                        break;
                    case PatternType.CSP:
                        rivalP = rivalscorep.CSP;
                        break;
                    case PatternType.BDP:
                        rivalP = rivalscorep.BDP;
                        break;
                    case PatternType.DDP:
                        rivalP = rivalscorep.DDP;
                        break;
                    case PatternType.EDP:
                        rivalP = rivalscorep.EDP;
                        break;
                    case PatternType.CDP:
                        rivalP = rivalscorep.CDP;
                        break;
                    //default:
                    //    rivalP = ScoreData();
                    //    break;
                    }
                }
                else
                {
                    rivalP = ScoreData();
                }
                if let rivalscorem: MusicScore = mRivalScoreData[m.MusicId]
                {
                    switch(m.Pattern)
                    {
                    case PatternType.bSP:
                        rivalM = rivalscorem.bSP;
                        break;
                    case PatternType.BSP:
                        rivalM = rivalscorem.BSP;
                        break;
                    case PatternType.DSP:
                        rivalM = rivalscorem.DSP;
                        break;
                    case PatternType.ESP:
                        rivalM = rivalscorem.ESP;
                        break;
                    case PatternType.CSP:
                        rivalM = rivalscorem.CSP;
                        break;
                    case PatternType.BDP:
                        rivalM = rivalscorem.BDP;
                        break;
                    case PatternType.DDP:
                        rivalM = rivalscorem.DDP;
                        break;
                    case PatternType.EDP:
                        rivalM = rivalscorem.EDP;
                        break;
                    case PatternType.CDP:
                        rivalM = rivalscorem.CDP;
                        break;
                    //default:
                    //    rivalM = ScoreData();
                    //    break;
                    }
                }
                else
                {
                    rivalM = ScoreData();
                }
                
                break;
            //}
        default:
            //{
                rivalP = ScoreData();
                rivalM = ScoreData();
                break;
            //}
        }
        var cp: Int32 = 0;
        var cm: Int32 = 0;
        switch(type)
        {
        case MusicSortType.MusicName:
            sub = mMusicData[p.MusicId]!.Ruby == mMusicData[m.MusicId]!.Ruby ? 0 : mMusicData[p.MusicId]!.Ruby.lowercased() > mMusicData[m.MusicId]!.Ruby.lowercased() ? 1 : -1;
            break;
        case MusicSortType.Score:
            sub = scoreP.Score - scoreM.Score;
            break;
        case MusicSortType.RivalScore:
            sub = rivalP.Score - rivalM.Score;
            break;
        case MusicSortType.Rank:
            cp =
                scoreP.Rank == MusicRank.AAA ? 16 :
                scoreP.Rank == MusicRank.AAp ? 15 :
                scoreP.Rank == MusicRank.AA ? 14 :
                scoreP.Rank == MusicRank.AAm ? 13 :
                scoreP.Rank == MusicRank.Ap ? 12 :
                scoreP.Rank == MusicRank.A ? 11 :
                scoreP.Rank == MusicRank.Am ? 10 :
                scoreP.Rank == MusicRank.Bp ? 9 :
                scoreP.Rank == MusicRank.B ? 8 :
                scoreP.Rank == MusicRank.Bm ? 7 :
                scoreP.Rank == MusicRank.Cp ? 6 :
                scoreP.Rank == MusicRank.C ? 5 :
                scoreP.Rank == MusicRank.Cm ? 4 :
                scoreP.Rank == MusicRank.Dp ? 3 :
                scoreP.Rank == MusicRank.D ? 2 :
                scoreP.Rank == MusicRank.E ? 1 :
            0;
            cm =
                scoreM.Rank == MusicRank.AAA ? 16 :
                scoreM.Rank == MusicRank.AAp ? 15 :
                scoreM.Rank == MusicRank.AA ? 14 :
                scoreM.Rank == MusicRank.AAm ? 13 :
                scoreM.Rank == MusicRank.Ap ? 12 :
                scoreM.Rank == MusicRank.A ? 11 :
                scoreM.Rank == MusicRank.Am ? 10 :
                scoreM.Rank == MusicRank.Bp ? 9 :
                scoreM.Rank == MusicRank.B ? 8 :
                scoreM.Rank == MusicRank.Bm ? 7 :
                scoreM.Rank == MusicRank.Cp ? 6 :
                scoreM.Rank == MusicRank.C ? 5 :
                scoreM.Rank == MusicRank.Cm ? 4 :
                scoreM.Rank == MusicRank.Dp ? 3 :
                scoreM.Rank == MusicRank.D ? 2 :
                scoreM.Rank == MusicRank.E ? 1 :
            0;
            sub = cp - cm;
            break;
        case MusicSortType.RivalRank:
            cp =
                rivalP.Rank == MusicRank.AAA ? 16 :
                rivalP.Rank == MusicRank.AAp ? 15 :
                rivalP.Rank == MusicRank.AA ? 14 :
                rivalP.Rank == MusicRank.AAm ? 13 :
                rivalP.Rank == MusicRank.Ap ? 12 :
                rivalP.Rank == MusicRank.A ? 11 :
                rivalP.Rank == MusicRank.Am ? 10 :
                rivalP.Rank == MusicRank.Bp ? 9 :
                rivalP.Rank == MusicRank.B ? 8 :
                rivalP.Rank == MusicRank.Bm ? 7 :
                rivalP.Rank == MusicRank.Cp ? 6 :
                rivalP.Rank == MusicRank.C ? 5 :
                rivalP.Rank == MusicRank.Cm ? 4 :
                rivalP.Rank == MusicRank.Dp ? 3 :
                rivalP.Rank == MusicRank.D ? 2 :
                rivalP.Rank == MusicRank.E ? 1 :
            0;
            cm =
                rivalM.Rank == MusicRank.AAA ? 16 :
                rivalM.Rank == MusicRank.AAp ? 15 :
                rivalM.Rank == MusicRank.AA ? 14 :
                rivalM.Rank == MusicRank.AAm ? 13 :
                rivalM.Rank == MusicRank.Ap ? 12 :
                rivalM.Rank == MusicRank.A ? 11 :
                rivalM.Rank == MusicRank.Am ? 10 :
                rivalM.Rank == MusicRank.Bp ? 9 :
                rivalM.Rank == MusicRank.B ? 8 :
                rivalM.Rank == MusicRank.Bm ? 7 :
                rivalM.Rank == MusicRank.Cp ? 6 :
                rivalM.Rank == MusicRank.C ? 5 :
                rivalM.Rank == MusicRank.Cm ? 4 :
                rivalM.Rank == MusicRank.Dp ? 3 :
                rivalM.Rank == MusicRank.D ? 2 :
                rivalM.Rank == MusicRank.E ? 1 :
            0;
            sub = cp - cm;
            break;
        case MusicSortType.FullComboType:
            cp =
                scoreP.FullComboType_ == FullComboType.MarvelousFullCombo ? 5 :
                scoreP.FullComboType_ == FullComboType.PerfectFullCombo ? 4 :
                scoreP.FullComboType_ == FullComboType.FullCombo ? 3 :
                scoreP.FullComboType_ == FullComboType.GoodFullCombo ? 2 :
                scoreP.FullComboType_ == FullComboType.Life4 ? 1 :
            0;
            cm =
                scoreM.FullComboType_ == FullComboType.MarvelousFullCombo ? 5 :
                scoreM.FullComboType_ == FullComboType.PerfectFullCombo ? 4 :
                scoreM.FullComboType_ == FullComboType.FullCombo ? 3 :
                scoreM.FullComboType_ == FullComboType.GoodFullCombo ? 2 :
                scoreM.FullComboType_ == FullComboType.Life4 ? 1 :
            0;
            sub = cp - cm;
            break;
        case MusicSortType.RivalFullComboType:
            cp =
                rivalP.FullComboType_ == FullComboType.MarvelousFullCombo ? 5 :
                rivalP.FullComboType_ == FullComboType.PerfectFullCombo ? 4 :
                rivalP.FullComboType_ == FullComboType.FullCombo ? 3 :
                rivalP.FullComboType_ == FullComboType.GoodFullCombo ? 2 :
                rivalP.FullComboType_ == FullComboType.Life4 ? 1 :
            0;
            cm =
                rivalM.FullComboType_ == FullComboType.MarvelousFullCombo ? 5 :
                rivalM.FullComboType_ == FullComboType.PerfectFullCombo ? 4 :
                rivalM.FullComboType_ == FullComboType.FullCombo ? 3 :
                rivalM.FullComboType_ == FullComboType.GoodFullCombo ? 2 :
                rivalM.FullComboType_ == FullComboType.Life4 ? 1 :
            0;
            sub = cp - cm;
            break;
        case MusicSortType.ComboCount:
            sub = scoreP.MaxCombo - scoreM.MaxCombo;
            break;
        case MusicSortType.RivalComboCount:
            sub = rivalP.MaxCombo - rivalM.MaxCombo;
            break;
        case MusicSortType.PlayCount:
            sub = scoreP.PlayCount - scoreM.PlayCount;
            break;
        /*case MusicSortType.RivalPlayCount:
            sub = rivalP.PlayCount - rivalM.PlayCount;
            break;*/
        case MusicSortType.ClearCount:
            sub = scoreP.ClearCount - scoreM.ClearCount;
            break;
        /*case MusicSortType.RivalClearCount:
            sub = rivalP.ClearCount - rivalM.ClearCount;
            break;*/
        case MusicSortType.RivalScoreDifference:
            sub = (scoreP.Score-rivalP.Score) - (scoreM.Score-rivalM.Score);
            break;
        case MusicSortType.RivalScoreDifferenceAbs:
            sub = abs(scoreP.Score-rivalP.Score) - abs(scoreM.Score-rivalM.Score);
            break;
        case MusicSortType.Difficulty:
            switch(p.Pattern)
            {
            case PatternType.bSP:
                cp = mMusicData[p.MusicId]!.Difficulty_bSP;
                break;
            case PatternType.BSP:
                cp = mMusicData[p.MusicId]!.Difficulty_BSP;
                break;
            case PatternType.DSP:
                cp = mMusicData[p.MusicId]!.Difficulty_DSP;
                break;
            case PatternType.ESP:
                cp = mMusicData[p.MusicId]!.Difficulty_ESP;
                break;
            case PatternType.CSP:
                cp = mMusicData[p.MusicId]!.Difficulty_CSP;
                break;
            case PatternType.BDP:
                cp = mMusicData[p.MusicId]!.Difficulty_BDP;
                break;
            case PatternType.DDP:
                cp = mMusicData[p.MusicId]!.Difficulty_DDP;
                break;
            case PatternType.EDP:
                cp = mMusicData[p.MusicId]!.Difficulty_EDP;
                break;
            case PatternType.CDP:
                cp = mMusicData[p.MusicId]!.Difficulty_CDP;
                break;
            //default:
            //    cp = 0;
            //    break;
            }
            switch(m.Pattern)
            {
            case PatternType.bSP:
                cm = mMusicData[m.MusicId]!.Difficulty_bSP;
                break;
            case PatternType.BSP:
                cm = mMusicData[m.MusicId]!.Difficulty_BSP;
                break;
            case PatternType.DSP:
                cm = mMusicData[m.MusicId]!.Difficulty_DSP;
                break;
            case PatternType.ESP:
                cm = mMusicData[m.MusicId]!.Difficulty_ESP;
                break;
            case PatternType.CSP:
                cm = mMusicData[m.MusicId]!.Difficulty_CSP;
                break;
            case PatternType.BDP:
                cm = mMusicData[m.MusicId]!.Difficulty_BDP;
                break;
            case PatternType.DDP:
                cm = mMusicData[m.MusicId]!.Difficulty_DDP;
                break;
            case PatternType.EDP:
                cm = mMusicData[m.MusicId]!.Difficulty_EDP;
                break;
            case PatternType.CDP:
                cm = mMusicData[m.MusicId]!.Difficulty_CDP;
                break;
            //default:
            //    cm = 0;
            //    break;
            }
            sub = cp - cm;
            break;
        case MusicSortType.Pattern:
            cp =
                p.Pattern == PatternType.bSP ? 0 :
                p.Pattern == PatternType.BSP ? 1 :
                p.Pattern == PatternType.DSP ? 2 :
                p.Pattern == PatternType.ESP ? 3 :
                p.Pattern == PatternType.CSP ? 4 :
                p.Pattern == PatternType.BDP ? 1 :
                p.Pattern == PatternType.DDP ? 2 :
                p.Pattern == PatternType.EDP ? 3 :
                p.Pattern == PatternType.CDP ? 4 :
            0;
            cm = 
                m.Pattern == PatternType.bSP ? 0 :
                m.Pattern == PatternType.BSP ? 1 :
                m.Pattern == PatternType.DSP ? 2 :
                m.Pattern == PatternType.ESP ? 3 :
                m.Pattern == PatternType.CSP ? 4 :
                m.Pattern == PatternType.BDP ? 1 :
                m.Pattern == PatternType.DDP ? 2 :
                m.Pattern == PatternType.EDP ? 3 :
                m.Pattern == PatternType.CDP ? 4 :
            0;
            sub = cp - cm;
            break;
        case MusicSortType.SPDP:
            cp = 
                p.Pattern == PatternType.bSP ? 0 :
                p.Pattern == PatternType.BSP ? 0 :
                p.Pattern == PatternType.DSP ? 0 :
                p.Pattern == PatternType.ESP ? 0 :
                p.Pattern == PatternType.CSP ? 0 :
                p.Pattern == PatternType.BDP ? 1 :
                p.Pattern == PatternType.DDP ? 1 :
                p.Pattern == PatternType.EDP ? 1 :
                p.Pattern == PatternType.CDP ? 1 :
            0;
            cm = 
                m.Pattern == PatternType.bSP ? 0 :
                m.Pattern == PatternType.BSP ? 0 :
                m.Pattern == PatternType.DSP ? 0 :
                m.Pattern == PatternType.ESP ? 0 :
                m.Pattern == PatternType.CSP ? 0 :
                m.Pattern == PatternType.BDP ? 1 :
                m.Pattern == PatternType.DDP ? 1 :
                m.Pattern == PatternType.EDP ? 1 :
                m.Pattern == PatternType.CDP ? 1 :
            0;
            sub = cp - cm;
            break;
        case MusicSortType.ID:
            sub = mWebMusicIds[p.MusicId]!.idOnWebPage.lowercased() > mWebMusicIds[m.MusicId]!.idOnWebPage.lowercased() ? 1 : -1
            break;
        case MusicSortType.BpmMax:
            sub = mMusicData[p.MusicId]!.MaxBPM - mMusicData[m.MusicId]!.MaxBPM;
            break;
        case MusicSortType.BpmMin:
            sub = mMusicData[p.MusicId]!.MinBPM - mMusicData[m.MusicId]!.MinBPM;
            break;
        case MusicSortType.BpmAve:
            sub = (mMusicData[p.MusicId]!.MaxBPM+mMusicData[p.MusicId]!.MinBPM)/2 - (mMusicData[m.MusicId]!.MaxBPM+mMusicData[m.MusicId]!.MinBPM)/2;
            break;
        case MusicSortType.SeriesTitle:
            let pmd: MusicData = mMusicData[p.MusicId]!;
            let mmd: MusicData = mMusicData[m.MusicId]!;
            cp =
                pmd.SeriesTitle_ == SeriesTitle._1st ? 1 :
                pmd.SeriesTitle_ == SeriesTitle._2nd ? 2 :
                pmd.SeriesTitle_ == SeriesTitle._3rd ? 3 :
                pmd.SeriesTitle_ == SeriesTitle._4th ? 4 :
                pmd.SeriesTitle_ == SeriesTitle._5th ? 5 :
                pmd.SeriesTitle_ == SeriesTitle.MAX ? 6 :
                pmd.SeriesTitle_ == SeriesTitle.MAX2 ? 7 :
                pmd.SeriesTitle_ == SeriesTitle.EXTREME ? 8 :
                pmd.SeriesTitle_ == SeriesTitle.SuperNOVA ? 9 :
                pmd.SeriesTitle_ == SeriesTitle.SuperNOVA2 ? 10 :
                pmd.SeriesTitle_ == SeriesTitle.X ? 11 :
                pmd.SeriesTitle_ == SeriesTitle.X2 ? 12 :
                pmd.SeriesTitle_ == SeriesTitle.X3 ? 13 :
                pmd.SeriesTitle_ == SeriesTitle._2013 ? 14 :
                pmd.SeriesTitle_ == SeriesTitle._2014 ? 15 :
            0;
            cm = 
                mmd.SeriesTitle_ == SeriesTitle._1st ? 1 :
                mmd.SeriesTitle_ == SeriesTitle._2nd ? 2 :
                mmd.SeriesTitle_ == SeriesTitle._3rd ? 3 :
                mmd.SeriesTitle_ == SeriesTitle._4th ? 4 :
                mmd.SeriesTitle_ == SeriesTitle._5th ? 5 :
                mmd.SeriesTitle_ == SeriesTitle.MAX ? 6 :
                mmd.SeriesTitle_ == SeriesTitle.MAX2 ? 7 :
                mmd.SeriesTitle_ == SeriesTitle.EXTREME ? 8 :
                mmd.SeriesTitle_ == SeriesTitle.SuperNOVA ? 9 :
                mmd.SeriesTitle_ == SeriesTitle.SuperNOVA2 ? 10 :
                mmd.SeriesTitle_ == SeriesTitle.X ? 11 :
                mmd.SeriesTitle_ == SeriesTitle.X2 ? 12 :
                mmd.SeriesTitle_ == SeriesTitle.X3 ? 13 :
                mmd.SeriesTitle_ == SeriesTitle._2013 ? 14 :
                mmd.SeriesTitle_ == SeriesTitle._2014 ? 15 :
            0;
            sub = cp - cm;
            break;
        default:
            sub = 0;
            break;
        }
        sub = (order==SortOrder.Ascending ? 1 : -1)*sub;
        
        var ret: Bool;
        if(sub == 0)
        {
            ret = compare(m, p: p, section: section+1);
        }
        else
        {
            ret = sub > 0;
        }
        return ret;
    }

}
