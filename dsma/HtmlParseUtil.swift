//
//  HtmlParseUtil.swift
//  dsma
//
//  Created by apple on 2024/08/09.
//  Copyright © 2024 LinaNfinE. All rights reserved.
//

import Foundation
import SwiftSoup

public class HtmlParseUtil {
    static func parseMusicList(src: String) throws -> (GameMode, [MusicEntry]) {
        let doc: Document = try SwiftSoup.parse(src)
        let gameMode = try determineGameMode(doc)
        let musicEntries = try parseMusicEntries(doc, mode: gameMode)
        return (gameMode, musicEntries)
    }
    
    private static func determineGameMode(_ doc: Document) throws -> GameMode {
        // URLからモードを判定
        if let urlElement = try doc.select("meta[property='og:url']").first(),
           let url = try? urlElement.attr("content") {
            if url.contains("music_data_single") {
                return .single
            } else if url.contains("music_data_double") {
                return .double
            }
        }
        
        // スタイルタブからモードを判定
        if let singleTab = try doc.select("#t_single a.select").first() {
            return .single
        } else if let doubleTab = try doc.select("#t_double a.select").first() {
            return .double
        }
        
        throw ParseError.unableToDetermineGameMode
    }

    private static func parseMusicEntries(_ doc: Document, mode: GameMode) throws -> [MusicEntry] {
        var musicEntries: [MusicEntry] = []
        let musicRows: Elements = try doc.select("tr.data")
        
        for row in musicRows {
            if let entry = try parseMusicEntry(row: row, mode: mode) {
                musicEntries.append(entry)
            }
        }
        
        return musicEntries
    }
    
    private static func parseMusicEntry(row: Element, mode: GameMode) throws -> MusicEntry? {
        // 既存のパース処理に加えて、モードを追加
        guard let titleLink = try row.select("td a").first() else { return nil }
        
        let musicName = try titleLink.text().trimmingCharacters(in: .whitespacesAndNewlines)
        let scores = try parseDifficultyScores(row: row, mode: mode)
        
        return MusicEntry(musicName: musicName, scores: scores, mode: mode)
    }

    private static func parseDifficultyScore(column: Element, index: Int, mode: GameMode) throws -> DifficultyScore? {
        let diffId = getDifficultyId(index: index, mode: mode)

        // スコア要素の存在を確認
        guard let scoreElement = try column.select("div.data_score").first() else {
            // スコア要素が存在しない場合は非表示の難易度として扱う
            return DifficultyScore(difficultyId: diffId, score: 0, rank: .Noplay, fullComboType: .None, flareRank: -1)
        }

        let scoreText = try scoreElement.text()
        if scoreText.isEmpty {
            // スコアが空の場合も非表示の難易度として扱う
            return DifficultyScore(difficultyId: diffId, score: 0, rank: .Noplay, fullComboType: .None, flareRank: -1)
        }

        // その他の要素を取得
        let rankElement = try column.select("div.data_rank img").first()
        let fullComboElement = try column.select("div.data_clearkind img").first()
        let flareRankElement = try column.select("div.data_flarerank img").first()
        let flareSkillElement = try column.select("div.data_flareskill").first()

        let score = scoreText == "---" ? 0 : Int(scoreText) ?? 0
        
        let fullComboType = getFullComboType(fullComboElement: fullComboElement)
        let flareRank = getFlareRank(flareRankElement: flareRankElement, flareSkillElement: flareSkillElement)
        let rank = getRank(rankElement: rankElement, score: score)
        
        return DifficultyScore(difficultyId: diffId, score: score, rank: rank, fullComboType: fullComboType, flareRank: flareRank)
    }
    
    private static func parseDifficultyScores(row: Element, mode: GameMode) throws -> [DifficultyScore] {
        var scores: [DifficultyScore] = []
        let difficultyColumns: Elements = try row.select("td.rank")
        
        for (index, column) in difficultyColumns.enumerated() {
            if let score = try parseDifficultyScore(column: column, index: index, mode: mode) {
                scores.append(score)
            }
        }
        
        return scores
    }

    private static func getDifficultyId(index: Int, mode: GameMode) -> String {
        switch mode {
        case .single:
            return ["beginner", "basic", "difficult", "expert", "challenge"][index]
        case .double:
            return ["basic", "difficult", "expert", "challenge"][index]
        }
    }
    
    private static func getFullComboType(fullComboElement: Element?) -> FullComboType {
        guard let fullComboElement = fullComboElement,
              let fullComboSrc = try? fullComboElement.attr("src") else {
            return .None
        }
        
        if fullComboSrc.contains("cl_marv") { return .MarvelousFullCombo }
        if fullComboSrc.contains("cl_perf") { return .PerfectFullCombo }
        if fullComboSrc.contains("cl_great") { return .FullCombo }
        if fullComboSrc.contains("cl_good") { return .GoodFullCombo }
        if fullComboSrc.contains("cl_li4clear") { return .Life4 }
        return .None
    }
    
    private static func getFlareRank(flareRankElement: Element?, flareSkillElement: Element?) -> Int {
        guard let flareRankElement = flareRankElement else {
            return -1  // フレアランク要素がない場合
        }

        let flareRankSrc = try? flareRankElement.attr("src")
        if flareRankSrc?.contains("flare_nodisp") == true { return -1 }
        if flareRankSrc?.contains("flare_none") == true { return -1 }
        if flareRankSrc?.contains("flare_1") == true { return 1 }
        if flareRankSrc?.contains("flare_2") == true { return 2 }
        if flareRankSrc?.contains("flare_3") == true { return 3 }
        if flareRankSrc?.contains("flare_4") == true { return 4 }
        if flareRankSrc?.contains("flare_5") == true { return 5 }
        if flareRankSrc?.contains("flare_6") == true { return 6 }
        if flareRankSrc?.contains("flare_7") == true { return 7 }
        if flareRankSrc?.contains("flare_8") == true { return 8 }
        if flareRankSrc?.contains("flare_9") == true { return 9 }
        if flareRankSrc?.contains("flare_ex") == true { return 10 }
        return 0
    }
    
    private static func getRank(rankElement: Element?, score: Int) -> MusicRank {
        // まずアイコンを確認してEランクかどうかを判断
        if let rankElement = rankElement,
           let rankSrc = try? rankElement.attr("src"),
           rankSrc.contains("rank_s_e") {
            return .E
        }
        
        // Eランクでない場合は、スコアに基づいてランクを計算
        return calculateRank(score: score)
    }
    
    private static func calculateRank(score: Int) -> MusicRank {
        if score == 0 {
            return .Noplay
        } else if score < 550000 {
            return .D
        } else if score < 590000 {
            return .Dp
        } else if score < 600000 {
            return .Cm
        } else if score < 650000 {
            return .C
        } else if score < 690000 {
            return .Cp
        } else if score < 700000 {
            return .Bm
        } else if score < 750000 {
            return .B
        } else if score < 790000 {
            return .Bp
        } else if score < 800000 {
            return .Am
        } else if score < 850000 {
            return .A
        } else if score < 890000 {
            return .Ap
        } else if score < 900000 {
            return .AAm
        } else if score < 950000 {
            return .AA
        } else if score < 990000 {
            return .AAp
        } else {
            return .AAA
        }
    }
    
    enum ParseError: Error {
        case unableToDetermineGameMode
    }
}
