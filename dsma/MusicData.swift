//
//  MusicData.swift
//  dsm
//
//  Created by LinaNfinE on 6/5/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

struct MusicData {
    var Id: Int32 = 0
    var Name: String = ""
    var Ruby: String = ""
    var SeriesTitle_: SeriesTitle = SeriesTitle._1st
    var MinBPM: Int32 = 0
    var MaxBPM: Int32 = 999
    var Difficulty_bSP: Int32 = 0
    var Difficulty_BSP: Int32 = 0
    var Difficulty_DSP: Int32 = 0
    var Difficulty_ESP: Int32 = 0
    var Difficulty_CSP: Int32 = 0
    var Difficulty_BDP: Int32 = 0
    var Difficulty_DDP: Int32 = 0
    var Difficulty_EDP: Int32 = 0
    var Difficulty_CDP: Int32 = 0
    var ShockArrowExists: [Int32 : BooleanPair] = [:]
    
    func getDifficulty(_ pattern: PatternType) -> Int32 {
        switch(pattern) {
        case PatternType.bSP:
            return Difficulty_bSP
        case PatternType.BSP:
            return Difficulty_BSP
        case PatternType.DSP:
            return Difficulty_DSP
        case PatternType.ESP:
            return Difficulty_ESP
        case PatternType.CSP:
            return Difficulty_CSP
        case PatternType.BDP:
            return Difficulty_BDP
        case PatternType.DDP:
            return Difficulty_DDP
        case PatternType.EDP:
            return Difficulty_EDP
        case PatternType.CDP:
            return Difficulty_CDP
        }
    }
}
