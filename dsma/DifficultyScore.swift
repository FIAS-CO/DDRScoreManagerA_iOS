//
//  DifficultyScore.swift
//  dsma
//
//  Created by apple on 2024/08/10.
//  Copyright © 2024 LinaNfinE. All rights reserved.
//

struct DifficultyScore {
    var difficultyId: String
    var score: Int = 0
    var rank: MusicRank = .Noplay
    var fullComboType: FullComboType = .None
    var flareRank: Int = -1
}
