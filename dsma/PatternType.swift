//
//  PatternType.swift
//  dsm
//
//  Created by LinaNfinE on 6/5/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

enum PatternType: String{
    case bSP = "bSP"
    case BSP = "BSP"
    case DSP = "DSP"
    case ESP = "ESP"
    case CSP = "CSP"
    case BDP = "BDP"
    case DDP = "DDP"
    case EDP = "EDP"
    case CDP = "CDP"
}

struct PatternTypeLister {
    
    static func getPatternType(_ patnum: Int32) -> (PatternType)
    {
        return
            (patnum == 0) ? PatternType.bSP :
                (patnum == 1) ? PatternType.BSP :
                (patnum == 2) ? PatternType.DSP :
                (patnum == 3) ? PatternType.ESP :
                (patnum == 4) ? PatternType.CSP :
                (patnum == 5) ? PatternType.BDP :
                (patnum == 6) ? PatternType.DDP :
                (patnum == 7) ? PatternType.EDP :
                (patnum == 8) ? PatternType.CDP :
                PatternType.bSP;
    }
    
    static func getPatternTypeNum(_ type: PatternType) -> (Int32)
    {
        return
            type == PatternType.bSP ? 0 :
                type == PatternType.BSP ? 1 :
                type == PatternType.DSP ? 2 :
                type == PatternType.ESP ? 3 :
                type == PatternType.CSP ? 4 :
                type == PatternType.BDP ? 5 :
                type == PatternType.DDP ? 6 :
                type == PatternType.EDP ? 7 :
                type == PatternType.CDP ? 8 :
        0;
    }
    
    static func getScoreDataByPattern(_ ms: MusicScore, pattern: PatternType) -> (ScoreData) {
        switch pattern {
        case PatternType.bSP:
            return ms.bSP
        case PatternType.BSP:
            return ms.BSP
        case PatternType.DSP:
            return ms.DSP
        case PatternType.ESP:
            return ms.ESP
        case PatternType.CSP:
            return ms.CSP
        case PatternType.BDP:
            return ms.BDP
        case PatternType.DDP:
            return ms.DDP
        case PatternType.EDP:
            return ms.EDP
        case PatternType.CDP:
            return ms.CDP
        }
    }
    
    static func getDifficultyDataByPattern(_ md: MusicData, pattern: PatternType) -> (Int32) {
        switch pattern {
        case PatternType.bSP:
            return md.Difficulty_bSP
        case PatternType.BSP:
            return md.Difficulty_BSP
        case PatternType.DSP:
            return md.Difficulty_DSP
        case PatternType.ESP:
            return md.Difficulty_ESP
        case PatternType.CSP:
            return md.Difficulty_CSP
        case PatternType.BDP:
            return md.Difficulty_BDP
        case PatternType.DDP:
            return md.Difficulty_DDP
        case PatternType.EDP:
            return md.Difficulty_EDP
        case PatternType.CDP:
            return md.Difficulty_CDP
        }
    }
    
}
