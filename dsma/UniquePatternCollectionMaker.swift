//
//  UniquePatternCollectionMaker.swift
//  dsm
//
//  Created by LinaNfinE on 6/9/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit

struct UniquePatternCollectionMaker{
    static func create(_ filter: MusicFilter, webMusicIds: [Int32 : WebMusicId], musics: [Int32 : MusicData], scores: inout [Int32 : MusicScore], rivalName: String, rivalScores: inout [Int32 : MusicScore]) ->([UniquePattern]){
        var ups: [UniquePattern] = []
        for mdn in musics {
            var ms: MusicScore? = scores[mdn.0]
            if ms == nil {
                scores[mdn.0] = MusicScore()
                ms = MusicScore()
            }
            var rs: MusicScore? = rivalScores[mdn.0]
            if rs == nil {
                rivalScores[mdn.0] = MusicScore()
                rs = MusicScore()
            }
            let webIds: WebMusicId? = webMusicIds[mdn.0]
            var webId: WebMusicId
            if webIds != nil {
                webId = webIds!
            }
            else {
                webId = WebMusicId()
            }
            var up: UniquePattern = UniquePattern()
            up.MusicId = mdn.0
            //up.musics = musics
            up.RivalName = rivalName
            //up.rivalScores = rivalScores
            //up.scores = scores
            
            if mdn.1.Difficulty_bSP != 0 {
                up.Pattern = PatternType.bSP
                //up.Comment = ""
                if(filter.checkFilter(webId, music: mdn.1, pattern: PatternType.bSP, score: ms!, rivalScore: rs!)) {
                    ups.append(up)
                }
            }
            if mdn.1.Difficulty_BSP != 0 {
                up.Pattern = PatternType.BSP
                //up.Comment = ""
                if(filter.checkFilter(webId, music: mdn.1, pattern: PatternType.BSP, score: ms!, rivalScore: rs!)) {
                    ups.append(up)
                }
            }
            if mdn.1.Difficulty_DSP != 0 {
                up.Pattern = PatternType.DSP
                //up.Comment = ""
                if(filter.checkFilter(webId, music: mdn.1, pattern: PatternType.DSP, score: ms!, rivalScore: rs!)) {
                    ups.append(up)
                }
            }
            if mdn.1.Difficulty_ESP != 0 {
                up.Pattern = PatternType.ESP
                //up.Comment = ""
                if(filter.checkFilter(webId, music: mdn.1, pattern: PatternType.ESP, score: ms!, rivalScore: rs!)) {
                    ups.append(up)
                }
            }
            if mdn.1.Difficulty_CSP != 0 {
                up.Pattern = PatternType.CSP
                //up.Comment = ""
                if(filter.checkFilter(webId, music: mdn.1, pattern: PatternType.CSP, score: ms!, rivalScore: rs!)) {
                    ups.append(up)
                }
            }
            if mdn.1.Difficulty_BDP != 0 {
                up.Pattern = PatternType.BDP
                //up.Comment = ""
                if(filter.checkFilter(webId, music: mdn.1, pattern: PatternType.BDP, score: ms!, rivalScore: rs!)) {
                    ups.append(up)
                }
            }
            if mdn.1.Difficulty_DDP != 0 {
                up.Pattern = PatternType.DDP
                //up.Comment = ""
                if(filter.checkFilter(webId, music: mdn.1, pattern: PatternType.DDP, score: ms!, rivalScore: rs!)) {
                    ups.append(up)
                }
            }
            if mdn.1.Difficulty_EDP != 0 {
                up.Pattern = PatternType.EDP
                //up.Comment = ""
                if(filter.checkFilter(webId, music: mdn.1, pattern: PatternType.EDP, score: ms!, rivalScore: rs!)) {
                    ups.append(up)
                }
            }
            if mdn.1.Difficulty_CDP != 0 {
                up.Pattern = PatternType.CDP
                //up.Comment = ""
                if(filter.checkFilter(webId, music: mdn.1, pattern: PatternType.CDP, score: ms!, rivalScore: rs!)) {
                    ups.append(up)
                }
            }
        }
        return ups
    }
}
