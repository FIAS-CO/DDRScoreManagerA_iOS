//
//  ScoreData.swift
//  dsm
//
//  Created by LinaNfinE on 6/5/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

struct ScoreData {
    var Rank: MusicRank = MusicRank.Noplay
    var Score: Int32 = 0
    var MaxCombo: Int32 = 0
    var FullComboType_: FullComboType = FullComboType.None
    var PlayCount: Int32 = 0
    var ClearCount: Int32 = 0
    var flareRank: Int32 = -1
    var flareSkill: Int32 = 0
    
    mutating func updateFlareSkill(songDifficulty: Int32) {
        if flareRank == -1 {
            flareSkill = 0
        } else {
            flareSkill = flareRank - songDifficulty
        }
    }
}
