//
//  FlareSkillUpdater.swift
//  dsma
//
//  Created by apple on 2024/07/14.
//  Copyright © 2024 LinaNfinE. All rights reserved.
//

class FlareSkillUpdater {
    static func updateAllFlareSkills(musicData: [Int32: MusicData], scoreData: inout [Int32: MusicScore]) {
        for (musicId, musicData) in musicData {
            if var musicScore = scoreData[musicId] {
                // SPパターン
                updateFlareSkillForPattern(&musicScore.bSP, difficulty: musicData.Difficulty_bSP)
                updateFlareSkillForPattern(&musicScore.BSP, difficulty: musicData.Difficulty_BSP)
                updateFlareSkillForPattern(&musicScore.DSP, difficulty: musicData.Difficulty_DSP)
                updateFlareSkillForPattern(&musicScore.ESP, difficulty: musicData.Difficulty_ESP)
                updateFlareSkillForPattern(&musicScore.CSP, difficulty: musicData.Difficulty_CSP)
                
                // DPパターン
                updateFlareSkillForPattern(&musicScore.BDP, difficulty: musicData.Difficulty_BDP)
                updateFlareSkillForPattern(&musicScore.DDP, difficulty: musicData.Difficulty_DDP)
                updateFlareSkillForPattern(&musicScore.EDP, difficulty: musicData.Difficulty_EDP)
                updateFlareSkillForPattern(&musicScore.CDP, difficulty: musicData.Difficulty_CDP)
                
                // 更新されたMusicScoreを保存
                scoreData[musicId] = musicScore
            }
        }
    }
    
    private static func updateFlareSkillForPattern(_ scoreData: inout ScoreData, difficulty: Int32) {
        scoreData.updateFlareSkill(songDifficulty: difficulty)
    }
}
