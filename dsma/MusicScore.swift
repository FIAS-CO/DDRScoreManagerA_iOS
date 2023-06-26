//
//  MusicScore.swift
//  dsm
//
//  Created by LinaNfinE on 6/5/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

struct MusicScore {
    var bSP: ScoreData = ScoreData()
    var BSP: ScoreData = ScoreData()
    var DSP: ScoreData = ScoreData()
    var ESP: ScoreData = ScoreData()
    var CSP: ScoreData = ScoreData()
    var BDP: ScoreData = ScoreData()
    var DDP: ScoreData = ScoreData()
    var EDP: ScoreData = ScoreData()
    var CDP: ScoreData = ScoreData()
    
    func getScoreData(_ pattern: PatternType) -> ScoreData {
        switch(pattern) {
        case PatternType.bSP:
            return bSP
        case PatternType.BSP:
            return BSP
        case PatternType.DSP:
            return DSP
        case PatternType.ESP:
            return ESP
        case PatternType.CSP:
            return CSP
        case PatternType.BDP:
            return BDP
        case PatternType.DDP:
            return DDP
        case PatternType.EDP:
            return EDP
        case PatternType.CDP:
            return CDP
        }
    }
}
