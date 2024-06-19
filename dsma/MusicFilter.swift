//
//  MusicFilter.swift
//  dsm
//
//  Created by LinaNfinE on 6/10/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit

class MusicFilter{
    
    var Title: String? = nil;
    var StartsWith: String? = nil;
    var MusicIdList: [Int32]? = nil;
    var MusicPatternList: [PatternType]? = nil;
    
    var ScoreMin: Int32 = 0;
    var ScoreMax: Int32 = 1000000;
    var ScoreMinRival: Int32 = 0;
    var ScoreMaxRival: Int32 = 1000000;
    
    var MaxComboMin: Int32 = 0;
    var MaxComboMax: Int32 = Int32.max;
    var MaxComboMinRival: Int32 = 0;
    var MaxComboMaxRival: Int32 = Int32.max;
    
    var PlayCountMin: Int32 = 0;
    var PlayCountMax: Int32 = Int32.max;
    var PlayCountMinRival: Int32 = 0;
    var PlayCountMaxRival: Int32 = Int32.max;
    
    var ClearCountMin: Int32 = 0;
    var ClearCountMax: Int32 = Int32.max;
    var ClearCountMinRival: Int32 = 0;
    var ClearCountMaxRival: Int32 = Int32.max;
    
    var RivalWin: Bool = true;
    var RivalLose: Bool = true;
    var RivalDraw: Bool = true;
    
    var ScoreDifferenceMinusMax: Int32 = -1000000;
    var ScoreDifferenceMinusMin: Int32 = 0;
    var ScoreDifferencePlusMax: Int32 = 1000000;
    var ScoreDifferencePlusMin: Int32 = 0;
    
    var MaxComboDifferenceMinusMax: Int32 = Int32.min;
    var MaxComboDifferenceMinusMin: Int32 = 0;
    var MaxComboDifferencePlusMax: Int32 = Int32.max;
    var MaxComboDifferencePlusMin: Int32 = 0;
    
    var PlayCountDifferenceMinusMax: Int32 = Int32.min;
    var PlayCountDifferenceMinusMin: Int32 = 0;
    var PlayCountDifferencePlusMax: Int32 = Int32.max;
    var PlayCountDifferencePlusMin: Int32 = 0;
    
    var ClearCountDifferenceMinusMax: Int32 = Int32.min;
    var ClearCountDifferenceMinusMin: Int32 = 0;
    var ClearCountDifferencePlusMax: Int32 = Int32.max;
    var ClearCountDifferencePlusMin: Int32 = 0;
    
    var bSP: Bool = true;
    var BSP: Bool = true;
    var DSP: Bool = true;
    var ESP: Bool = true;
    var CSP: Bool = true;
    var BDP: Bool = true;
    var DDP: Bool = true;
    var EDP: Bool = true;
    var CDP: Bool = true;
    var AllowOnlyChallenge: Bool = true;
    var AllowExpertWhenNoChallenge: Bool = true;
    var ShockArrowSP: ShockArrowInclude = ShockArrowInclude.Include;
    var ShockArrowDP: ShockArrowInclude = ShockArrowInclude.Include;
    
    var Dif1 : Bool = true;
    var Dif2 : Bool = true;
    var Dif3 : Bool = true;
    var Dif4 : Bool = true;
    var Dif5 : Bool = true;
    var Dif6 : Bool = true;
    var Dif7 : Bool = true;
    var Dif8 : Bool = true;
    var Dif9 : Bool = true;
    var Dif10: Bool  = true;
    var Dif11: Bool  = true;
    var Dif12: Bool  = true;
    var Dif13: Bool  = true;
    var Dif14: Bool  = true;
    var Dif15: Bool  = true;
    var Dif16: Bool  = true;
    var Dif17: Bool  = true;
    var Dif18: Bool  = true;
    var Dif19: Bool  = true;
    
    var SerWORLD: Bool = true;
    var SerA3: Bool = true;
    var SerA20PLUS: Bool = true;
    var SerA20: Bool = true;
    var SerA: Bool = true;
    var Ser2014: Bool = true;
    var Ser2013: Bool = true;
    var SerX3: Bool = true;
    var SerX3vs2ndMIX: Bool = true;
    var SerX2: Bool  = true;
    var SerX : Bool = true;
    var SerEXTREME: Bool = true;
    var SerMAX2: Bool  = true;
    var SerMAX : Bool = true;
    var SerSuperNova2: Bool  = true;
    var SerSuperNova : Bool = true;
    var Ser5th: Bool = true;
    var Ser4th: Bool = true;
    var Ser3rd: Bool = true;
    var Ser2nd: Bool = true;
    var Ser1st: Bool = true;
    
    var RankAAA: Bool  = true;
    var RankAAp : Bool = true;
    var RankAA : Bool = true;
    var RankAAm : Bool = true;
    var RankAp: Bool = true;
    var RankA: Bool = true;
    var RankAm: Bool = true;
    var RankBp: Bool = true;
    var RankB: Bool = true;
    var RankBm: Bool = true;
    var RankCp: Bool = true;
    var RankC: Bool = true;
    var RankCm: Bool = true;
    var RankDp: Bool = true;
    var RankD: Bool = true;
    var RankE: Bool = true;
    var RankNoPlay: Bool = true;
    
    var FcMFC: Bool  = true;
    var FcPFC: Bool  = true;
    var FcFC : Bool = true;
    var FcGFC: Bool  = true;
    var FcLife4: Bool  = true;
    var FcNoFC : Bool = true;
    
    var RankAAArival: Bool  = true;
    var RankAAprival : Bool = true;
    var RankAArival : Bool = true;
    var RankAAmrival : Bool = true;
    var RankAprival: Bool = true;
    var RankArival: Bool = true;
    var RankAmrival: Bool = true;
    var RankBprival: Bool = true;
    var RankBrival: Bool = true;
    var RankBmrival: Bool = true;
    var RankCprival: Bool = true;
    var RankCrival: Bool = true;
    var RankCmrival: Bool = true;
    var RankDprival: Bool = true;
    var RankDrival: Bool = true;
    var RankErival: Bool = true;
    var RankNoPlayrival: Bool = true;
    
    var FcMFCrival: Bool  = true;
    var FcPFCrival: Bool  = true;
    var FcFCrival : Bool = true;
    var FcGFCrival: Bool  = true;
    var FcLife4rival: Bool  = true;
    var FcNoFCrival : Bool = true;
    
    var OthersDeleted : Bool = true;
    
    func checkFilter(_ webId: WebMusicId, music: MusicData, pattern: PatternType, score: MusicScore, rivalScore: MusicScore) -> (Bool)
    {
        if !OthersDeleted && webId.isDeleted {
            return false
        }
        var diff: Int32;
        switch(pattern)
        {
        case PatternType.bSP:
            diff = music.Difficulty_bSP;
            break;
        case PatternType.BSP:
            diff = music.Difficulty_BSP;
            break;
        case PatternType.DSP:
            diff = music.Difficulty_DSP;
            break;
        case PatternType.ESP:
            diff = music.Difficulty_ESP;
            break;
        case PatternType.CSP:
            diff = music.Difficulty_CSP;
            break;
        case PatternType.BDP:
            diff = music.Difficulty_BDP;
            break;
        case PatternType.DDP:
            diff = music.Difficulty_DDP;
            break;
        case PatternType.EDP:
            diff = music.Difficulty_EDP;
            break;
        case PatternType.CDP:
            diff = music.Difficulty_CDP;
            break;
        //default:
        //    diff = 0;
        //    break;
        }
        if(diff == 0){ return false; }
        if(Title != nil && music.Name != Title){ return false; }
        if(StartsWith != nil)
        {
            if(StartsWith == "NUM")
            {
                let lc1: String = music.Ruby.lowercased();
                let str = (lc1 as NSString).substring(with: NSRange(location: 0, length: 1))
                if(str == "a"){ return false; }
                if(str == "b"){ return false; }
                if(str == "c"){ return false; }
                if(str == "d"){ return false; }
                if(str == "e"){ return false; }
                if(str == "f"){ return false; }
                if(str == "g"){ return false; }
                if(str == "h"){ return false; }
                if(str == "i"){ return false; }
                if(str == "j"){ return false; }
                if(str == "k"){ return false; }
                if(str == "l"){ return false; }
                if(str == "m"){ return false; }
                if(str == "n"){ return false; }
                if(str == "o"){ return false; }
                if(str == "p"){ return false; }
                if(str == "q"){ return false; }
                if(str == "r"){ return false; }
                if(str == "s"){ return false; }
                if(str == "t"){ return false; }
                if(str == "u"){ return false; }
                if(str == "v"){ return false; }
                if(str == "w"){ return false; }
                if(str == "x"){ return false; }
                if(str == "y"){ return false; }
                if(str == "z"){ return false; }
            }
            else if((music.Ruby.lowercased() as NSString).substring(with: NSRange(location: 0, length: (StartsWith! as NSString).length)) != StartsWith?.lowercased()){ return false; }
        }
        if(!bSP && pattern == PatternType.bSP){ return false; }
        if(!BSP && pattern == PatternType.BSP){ return false; }
        if(!DSP && pattern == PatternType.DSP){ return false; }
        if(!ESP && pattern == PatternType.ESP && !(AllowExpertWhenNoChallenge && (CSP && music.Difficulty_CSP==0))){ return false; }
        if(!CSP && pattern == PatternType.CSP && !(AllowOnlyChallenge && ((ESP && music.Difficulty_ESP==0)||(DSP && music.Difficulty_DSP==0)||(BSP && music.Difficulty_BSP==0)||(bSP && music.Difficulty_bSP==0)))){ return false; }
        if(!BDP && pattern == PatternType.BDP){ return false; }
        if(!DDP && pattern == PatternType.DDP){ return false; }
        if(!EDP && pattern == PatternType.EDP && !(AllowExpertWhenNoChallenge && (CDP && music.Difficulty_CDP==0))){ return false; }
        if(!CDP && pattern == PatternType.CDP && !(AllowOnlyChallenge && ((EDP && music.Difficulty_EDP==0)||(DDP && music.Difficulty_DDP==0)||(BDP && music.Difficulty_BDP==0)))){ return false; }
        
        if(pattern == PatternType.CSP)
        {
            let exists: Bool = music.ShockArrowExists[music.Id] != nil && music.ShockArrowExists[music.Id]!.b1;
            if(ShockArrowSP == ShockArrowInclude.Only && !exists){ return false; }
            if(ShockArrowSP == ShockArrowInclude.Exclude && exists){ return false; }
        }
        
        if(pattern == PatternType.CDP)
        {
            let exists: Bool = music.ShockArrowExists[music.Id] != nil && music.ShockArrowExists[music.Id]!.b2;
            if(ShockArrowDP == ShockArrowInclude.Only && !exists){ return false; }
            if(ShockArrowDP == ShockArrowInclude.Exclude && exists){ return false; }
        }
        
        var myscore: ScoreData;
        //{
            var scoreData: ScoreData;
            switch(pattern)
            {
            case PatternType.bSP:
                scoreData = score.bSP;
                break;
            case PatternType.BSP:
                scoreData = score.BSP;
                break;
            case PatternType.DSP:
                scoreData = score.DSP;
                break;
            case PatternType.ESP:
                scoreData = score.ESP;
                break;
            case PatternType.CSP:
                scoreData = score.CSP;
                break;
            case PatternType.BDP:
                scoreData = score.BDP;
                break;
            case PatternType.DDP:
                scoreData = score.DDP;
                break;
            case PatternType.EDP:
                scoreData = score.EDP;
                break;
            case PatternType.CDP:
                scoreData = score.CDP;
                break;
            //default:
            //    scoreData = ScoreData();
            //    break;
            }
        if(!Dif1 && diff == 1){ return false; }
        if(!Dif2 && diff == 2){ return false; }
        if(!Dif3 && diff == 3){ return false; }
        if(!Dif4 && diff == 4){ return false; }
        if(!Dif5 && diff == 5){ return false; }
        if(!Dif6 && diff == 6){ return false; }
        if(!Dif7 && diff == 7){ return false; }
        if(!Dif8 && diff == 8){ return false; }
        if(!Dif9 && diff == 9){ return false; }
        if(!Dif10 && diff == 10){ return false; }
        if(!Dif11 && diff == 11){ return false; }
        if(!Dif12 && diff == 12){ return false; }
        if(!Dif13 && diff == 13){ return false; }
        if(!Dif14 && diff == 14){ return false; }
        if(!Dif15 && diff == 15){ return false; }
        if(!Dif16 && diff == 16){ return false; }
        if(!Dif17 && diff == 17){ return false; }
        if(!Dif18 && diff == 18){ return false; }
        if(!Dif19 && diff == 19){ return false; }
        
        if(!RankAAA && scoreData.Rank == MusicRank.AAA){ return false; }
        if(!RankAAp && scoreData.Rank == MusicRank.AAp){ return false; }
        if(!RankAA && scoreData.Rank == MusicRank.AA){ return false; }
        if(!RankAAm && scoreData.Rank == MusicRank.AAm){ return false; }
        if(!RankAp && scoreData.Rank == MusicRank.Ap){ return false; }
        if(!RankA && scoreData.Rank == MusicRank.A){ return false; }
        if(!RankAm && scoreData.Rank == MusicRank.Am){ return false; }
        if(!RankBp && scoreData.Rank == MusicRank.Bp){ return false; }
        if(!RankB && scoreData.Rank == MusicRank.B){ return false; }
        if(!RankBm && scoreData.Rank == MusicRank.Bm){ return false; }
        if(!RankCp && scoreData.Rank == MusicRank.Cp){ return false; }
        if(!RankC && scoreData.Rank == MusicRank.C){ return false; }
        if(!RankCm && scoreData.Rank == MusicRank.Cm){ return false; }
        if(!RankDp && scoreData.Rank == MusicRank.Dp){ return false; }
        if(!RankD && scoreData.Rank == MusicRank.D){ return false; }
        if(!RankE && scoreData.Rank == MusicRank.E){ return false; }
        if(!RankNoPlay && scoreData.Rank == MusicRank.Noplay){ return false; }
        
        if(!FcMFC && scoreData.FullComboType_ == FullComboType.MarvelousFullCombo){ return false; }
        if(!FcPFC && scoreData.FullComboType_ == FullComboType.PerfectFullCombo){ return false; }
        if(!FcFC && scoreData.FullComboType_ == FullComboType.FullCombo){ return false; }
        if(!FcGFC && scoreData.FullComboType_ == FullComboType.GoodFullCombo){ return false; }
        if(!FcLife4 && scoreData.FullComboType_ == FullComboType.Life4){ return false; }
        if(!FcNoFC && scoreData.FullComboType_ == FullComboType.None){ return false; }
        
        if(scoreData.Score < ScoreMin || ScoreMax < scoreData.Score){ return false; }
        if(scoreData.MaxCombo < MaxComboMin || MaxComboMax < scoreData.MaxCombo){ return false; }
        if(scoreData.PlayCount < PlayCountMin || PlayCountMax < scoreData.PlayCount){ return false; }
        if(scoreData.ClearCount < ClearCountMin || ClearCountMax < scoreData.ClearCount){ return false; }
        
            myscore = scoreData;
        //}
        
        if(!SerWORLD && music.SeriesTitle_ == SeriesTitle.WORLD){ return false; }
        if(!SerA3 && music.SeriesTitle_ == SeriesTitle.A3){ return false; }
        if(!SerA20PLUS && music.SeriesTitle_ == SeriesTitle.A20PLUS){ return false; }
        if(!SerA20 && music.SeriesTitle_ == SeriesTitle.A20){ return false; }
        if(!SerA && music.SeriesTitle_ == SeriesTitle.A){ return false; }
        if(!Ser2014 && music.SeriesTitle_ == SeriesTitle._2014){ return false; }
        if(!Ser2013 && music.SeriesTitle_ == SeriesTitle._2013){ return false; }
        if(!SerX3 && music.SeriesTitle_ == SeriesTitle.X3){ return false; }
        if(!SerX3vs2ndMIX && music.SeriesTitle_ == SeriesTitle.X3_2ndMix){ return false; }
        if(!SerX2 && music.SeriesTitle_ == SeriesTitle.X2){ return false; }
        if(!SerX && music.SeriesTitle_ == SeriesTitle.X){ return false; }
        if(!SerSuperNova2 && music.SeriesTitle_ == SeriesTitle.SuperNOVA2){ return false; }
        if(!SerSuperNova && music.SeriesTitle_ == SeriesTitle.SuperNOVA){ return false; }
        if(!SerEXTREME && music.SeriesTitle_ == SeriesTitle.EXTREME){ return false; }
        if(!SerMAX2 && music.SeriesTitle_ == SeriesTitle.MAX2){ return false; }
        if(!SerMAX && music.SeriesTitle_ == SeriesTitle.MAX){ return false; }
        if(!Ser5th && music.SeriesTitle_ == SeriesTitle._5th){ return false; }
        if(!Ser4th && music.SeriesTitle_ == SeriesTitle._4th){ return false; }
        if(!Ser3rd && music.SeriesTitle_ == SeriesTitle._3rd){ return false; }
        if(!Ser2nd && music.SeriesTitle_ == SeriesTitle._2nd){ return false; }
        if(!Ser1st && music.SeriesTitle_ == SeriesTitle._1st){ return false; }
        
        if(!RankAAArival || !RankAAprival || !RankAArival || !RankAAmrival || !RankAprival || !RankArival || !RankAmrival || !RankBprival || !RankBrival || !RankBmrival || !RankCprival || !RankCrival || !RankCmrival || !RankDprival || !RankDrival || !RankErival || !RankNoPlayrival ||
            !FcMFCrival || !FcPFCrival || !FcFCrival || !FcGFCrival || !FcNoFCrival ||
            !RivalWin || !RivalLose || !RivalDraw || ScoreMinRival > 0 || ScoreMaxRival < 1000000 ||
            ScoreDifferenceMinusMax > -1000000 || ScoreDifferenceMinusMin < 0 || ScoreDifferencePlusMin > 0 || ScoreDifferencePlusMax < 1000000 ||
            MaxComboDifferenceMinusMax != Int32.min || MaxComboDifferenceMinusMin <= 0 || MaxComboDifferencePlusMin >= 0 || MaxComboDifferencePlusMax != Int32.max ||
            PlayCountDifferenceMinusMax != Int32.min || PlayCountDifferenceMinusMin <= 0 || PlayCountDifferencePlusMin >= 0 || PlayCountDifferencePlusMax != Int32.max ||
            ClearCountDifferenceMinusMax != Int32.min || ClearCountDifferenceMinusMin <= 0 || ClearCountDifferencePlusMin >= 0 || ClearCountDifferencePlusMax != Int32.max )
        {
            var scoreData: ScoreData;
            //if(rivalScore == nil)
            //{
            //    scoreData = ScoreData();
            //}
            //else
            //{
            switch(pattern)
            {
            case PatternType.bSP:
                scoreData = rivalScore.bSP;
                break;
            case PatternType.BSP:
                scoreData = rivalScore.BSP;
                break;
            case PatternType.DSP:
                scoreData = rivalScore.DSP;
                break;
            case PatternType.ESP:
                scoreData = rivalScore.ESP;
                break;
            case PatternType.CSP:
                scoreData = rivalScore.CSP;
                break;
            case PatternType.BDP:
                scoreData = rivalScore.BDP;
                break;
            case PatternType.DDP:
                scoreData = rivalScore.DDP;
                break;
            case PatternType.EDP:
                scoreData = rivalScore.EDP;
                break;
            case PatternType.CDP:
                scoreData = rivalScore.CDP;
                break;
            //default:
            //    scoreData = ScoreData();
            //    break;
            }
            //}
            
            if(!RankAAArival && scoreData.Rank == MusicRank.AAA){ return false; }
            if(!RankAAprival && scoreData.Rank == MusicRank.AAp){ return false; }
            if(!RankAArival && scoreData.Rank == MusicRank.AA){ return false; }
            if(!RankAAmrival && scoreData.Rank == MusicRank.AAm){ return false; }
            if(!RankAprival && scoreData.Rank == MusicRank.Ap){ return false; }
            if(!RankArival && scoreData.Rank == MusicRank.A){ return false; }
            if(!RankAmrival && scoreData.Rank == MusicRank.Am){ return false; }
            if(!RankBprival && scoreData.Rank == MusicRank.Bp){ return false; }
            if(!RankBrival && scoreData.Rank == MusicRank.B){ return false; }
            if(!RankBmrival && scoreData.Rank == MusicRank.Bm){ return false; }
            if(!RankCprival && scoreData.Rank == MusicRank.Cp){ return false; }
            if(!RankCrival && scoreData.Rank == MusicRank.C){ return false; }
            if(!RankCmrival && scoreData.Rank == MusicRank.Cm){ return false; }
            if(!RankDprival && scoreData.Rank == MusicRank.Dp){ return false; }
            if(!RankDrival && scoreData.Rank == MusicRank.D){ return false; }
            if(!RankErival && scoreData.Rank == MusicRank.E){ return false; }
            if(!RankNoPlayrival && scoreData.Rank == MusicRank.Noplay){ return false; }
            
            if(!FcMFCrival && scoreData.FullComboType_ == FullComboType.MarvelousFullCombo){ return false; }
            if(!FcPFCrival && scoreData.FullComboType_ == FullComboType.PerfectFullCombo){ return false; }
            if(!FcFCrival && scoreData.FullComboType_ == FullComboType.FullCombo){ return false; }
            if(!FcGFCrival && scoreData.FullComboType_ == FullComboType.GoodFullCombo){ return false; }
            if(!FcLife4rival && scoreData.FullComboType_ == FullComboType.Life4){ return false; }
            if(!FcNoFCrival && scoreData.FullComboType_ == FullComboType.None){ return false; }
            
            if(scoreData.Score < ScoreMinRival || ScoreMaxRival < scoreData.Score){ return false; }
            if(scoreData.MaxCombo < MaxComboMinRival || MaxComboMaxRival < scoreData.MaxCombo){ return false; }
            if(scoreData.PlayCount < PlayCountMinRival || PlayCountMaxRival < scoreData.PlayCount){ return false; }
            if(scoreData.ClearCount < ClearCountMinRival || ClearCountMaxRival < scoreData.ClearCount){ return false; }
            
            var dif: Int32 = myscore.Score-scoreData.Score;
            if(!RivalWin && dif > 0){ return false; }
            if(!RivalLose && dif < 0){ return false; }
            if(!RivalDraw && dif == 0){ return false; }
            if(dif < ScoreDifferenceMinusMax || (ScoreDifferenceMinusMin < dif && dif < ScoreDifferencePlusMin) || ScoreDifferencePlusMax < dif){ return false; }
            dif = myscore.MaxCombo - scoreData.MaxCombo;
            if(dif < MaxComboDifferenceMinusMax || (MaxComboDifferenceMinusMin < dif && dif < MaxComboDifferencePlusMin) || MaxComboDifferencePlusMax < dif){ return false; }
            dif = myscore.PlayCount - scoreData.PlayCount;
            if(dif < PlayCountDifferenceMinusMax || (PlayCountDifferenceMinusMin < dif && dif < PlayCountDifferencePlusMin) || PlayCountDifferencePlusMax < dif){ return false; }
            dif = myscore.ClearCount - scoreData.ClearCount;
            if(dif < ClearCountDifferenceMinusMax || (ClearCountDifferenceMinusMin < dif && dif < ClearCountDifferencePlusMin) || ClearCountDifferencePlusMax < dif){ return false; }
        }
        
        if(MusicIdList != nil && MusicPatternList != nil)
        {
            //var count = MusicIdList?.count
            var exists: Bool = false;
            if let ids = MusicIdList {
                let count = ids.count
            for i: Int in 0 ..< count {
                if(music.Id == MusicIdList![i] && pattern == MusicPatternList![i])
                {
                    exists = true;
                    break;
                }
            }
            if(!exists)
            {
                return false;
            }
            }
        }
        
        return true;
    }
}
