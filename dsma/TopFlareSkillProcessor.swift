import Foundation

class TopFlareSkillProcessor {
    
    static func processTopFlareSkills(playerId: String, mScoreList: [Int32: MusicScore], musicDataMap: [Int32: MusicData]) -> String {
        var categorizedScores: [String: [String: [PlayerScore]]] = [:]
        for category in ["CLASSIC", "WHITE", "GOLD"] {
            categorizedScores[category] = ["SP": [], "DP": []]
        }

        for (songId, musicScore) in mScoreList {
            guard let musicData = musicDataMap[songId] else { continue }
            let category = getCategoryForSeries(musicData.SeriesTitle_)

            processChartTypes(categorizedScores: &categorizedScores, songId: songId, musicScore: musicScore, musicData: musicData, category: category, chartTypes: ["bSP", "BSP", "DSP", "ESP", "CSP"], playStyle: "SP")
            processChartTypes(categorizedScores: &categorizedScores, songId: songId, musicScore: musicScore, musicData: musicData, category: category, chartTypes: ["BDP", "DDP", "EDP", "CDP"], playStyle: "DP")
        }

        var totalFlareSkillSp = 0
        var totalFlareSkillDp = 0
        var allTopScores: [PlayerScore] = []

        for categoryScores in categorizedScores.values {
            for (playStyle, scores) in categoryScores {
                let top30Scores = getTop30Scores(scores)
                let sum = top30Scores.sorted { $0.flareSkill > $1.flareSkill }
                    .prefix(30)
                    .reduce(0) { $0 + $1.flareSkill }
                
                if playStyle == "SP" {
                    totalFlareSkillSp += sum
                } else {
                    totalFlareSkillDp += sum
                }
                allTopScores.append(contentsOf: top30Scores)
            }
        }

        let response = TopFlareSkillResponse(playerId: playerId, scores: allTopScores, totalFlareSkillSp: totalFlareSkillSp, totalFlareSkillDp: totalFlareSkillDp)
        
        do {
            let jsonData = try JSONEncoder().encode(response)
            return String(data: jsonData, encoding: .utf8) ?? "{}"
        } catch {
            print("Error encoding JSON: \(error)")
            return "{}"
        }
    }

    private static func processChartTypes(categorizedScores: inout [String: [String: [PlayerScore]]], songId: Int32, musicScore: MusicScore, musicData: MusicData, category: String, chartTypes: [String], playStyle: String) {
        for chartType in chartTypes {
            let scoreData = getScoreDataForChartType(musicScore: musicScore, chartType: chartType)
            if scoreData.flareSkill > 0 {
                categorizedScores[category]?[playStyle]?.append(PlayerScore(
                    songId: Int(songId),
                    chartType: chartType,
                    score: Int(scoreData.Score),
                    flareRank: String(scoreData.flareRank),
                    flareSkill: Int(scoreData.flareSkill),
                    songName: musicData.Name,
                    category: category,
                    playStyle: playStyle
                ))
            }
        }
    }

    private static func getTop30Scores(_ scores: [PlayerScore]) -> [PlayerScore] {
        let sortedScores = scores.sorted { $0.flareSkill > $1.flareSkill }
        if sortedScores.count <= 30 {
            return sortedScores
        }
        let thresholdFlareSkill = sortedScores[29].flareSkill
        return sortedScores.filter { $0.flareSkill >= thresholdFlareSkill }
    }

    private static func getCategoryForSeries(_ seriesTitle: SeriesTitle) -> String {
        switch seriesTitle {
        case ._1st, ._2nd, ._3rd, ._4th, ._5th, .MAX, .MAX2, .EXTREME, .SuperNOVA, .SuperNOVA2, .X, .X2, .X3, .X3_2ndMix:
            return "CLASSIC"
        case ._2013, ._2014, .A:
            return "WHITE"
        default:
            return "GOLD"
        }
    }

    private static func getScoreDataForChartType(musicScore: MusicScore, chartType: String) -> ScoreData {
        switch chartType {
        case "bSP": return musicScore.bSP
        case "BSP": return musicScore.BSP
        case "DSP": return musicScore.DSP
        case "ESP": return musicScore.ESP
        case "CSP": return musicScore.CSP
        case "BDP": return musicScore.BDP
        case "DDP": return musicScore.DDP
        case "EDP": return musicScore.EDP
        case "CDP": return musicScore.CDP
        default:
            fatalError("Invalid chart type: \(chartType)")
        }
    }
}

struct TopFlareSkillResponse: Codable {
    let playerId: String
    let scores: [PlayerScore]
    let totalFlareSkillSp: Int
    let totalFlareSkillDp: Int
    
    enum CodingKeys: String, CodingKey {
        case playerId
        case totalFlareSkillSp
        case totalFlareSkillDp
        case scores
    }
}

struct PlayerScore: Codable {
    let songId: Int
    let chartType: String
    let score: Int
    let flareRank: String
    let flareSkill: Int
    let songName: String
    let category: String
    let playStyle: String
}
