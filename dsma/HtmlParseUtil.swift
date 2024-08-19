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
    
    static func parseMusicDetailForWorld(src: String, webMusicId: WebMusicId) throws -> ScoreData {
        let doc: Document = try SwiftSoup.parse(src)
        var sd = ScoreData()
        
        // タイトルの確認
        if let titleElement = try doc.select("table#music_info td").last(),
           let titleNode = titleElement.childNode(0) as? TextNode {
            let title = titleNode.text().trimmingCharacters(in: .whitespacesAndNewlines)
            
            if title != webMusicId.titleOnWebPage {
                throw ParseError.musicNameMismatch(webTitle: webMusicId.titleOnWebPage, pageTitle: title)
            }
        } else {
            throw ParseError.parsingFailed(description: "Title element or text node not found.")
        }
        
        // "NO PLAY..." の確認
        if let noPlayElement = try? doc.select("body").text(), noPlayElement.contains("NO PLAY...") {
            return ScoreData()  // デフォルトの ScoreData を返す
        }
        
        // スコアデータのパース
        sd.Rank = try parseRank(doc)
        sd.Score = try parseScore(doc)
        sd.MaxCombo = try parseMaxCombo(doc)
        sd.FullComboType_ = try parseFullComboType(doc)
        sd.PlayCount = try parsePlayCount(doc)
        sd.ClearCount = try parseClearCount(doc)
        sd.flareRank = try parseFlareRank(doc)
        
        return sd
    }
    
    private static func parseRank(_ doc: Document) throws -> MusicRank {
        let rankElement = try doc.select("th:contains(ハイスコア時のランク) + td").first()
        let rankText = try rankElement?.text() ?? ""
        return MusicRank(rawValue: rankText) ?? .Noplay
    }
    
    private static func parseScore(_ doc: Document) throws -> Int32 {
        let thElements = try doc.select("th")
        
        for th in thElements {
            if try th.text().trimmingCharacters(in: .whitespacesAndNewlines) == "ハイスコア" {
                // 完全一致する th 要素が見つかった場合、その次の兄弟 td 要素を取得
                if let scoreElement = try th.nextElementSibling() {
                    let scoreText = try scoreElement.text()
                    print("Score Element Text: \(scoreText)")  // デバッグ用
                    return Int32(scoreText) ?? 0
                }
            }
        }
        
        print("Score Element not found")  // デバッグ用
        return 0
    }
    
    private static func parseMaxCombo(_ doc: Document) throws -> Int32 {
        let comboElement = try doc.select("th:contains(最大コンボ数) + td").first()
        let comboText = try comboElement?.text() ?? "0"
        return Int32(comboText) ?? 0
    }
    
    private static func parseFullComboType(_ doc: Document) throws -> FullComboType {
        // フルコンボ種別の解析
        let fcElements = try doc.select("#clear_detail_table tr[id^='fc_']")
        for element in fcElements {
            // 各行の <th> 要素のテキストと <td> 要素のテキストを取得
            let fcTypeText = try element.select("th").text().trimmingCharacters(in: .whitespacesAndNewlines)
            let fcCountText = try element.select("td").text().trimmingCharacters(in: .whitespacesAndNewlines)
            
            let fcCount = Int(fcCountText) ?? 0
            
            if fcCount > 0 {
                switch fcTypeText {
                case "マーベラスフルコンボ": return .MarvelousFullCombo
                case "パーフェクトフルコンボ": return .PerfectFullCombo
                case "グレートフルコンボ": return .FullCombo
                case "グッドフルコンボ": return .GoodFullCombo
                default: break
                }
            }
        }
        
        // LIFE4の解析
        let life4Element = try doc.select("#clear_detail_table tr#clear_life4")
        let life4CountText = try life4Element.select("td").text().trimmingCharacters(in: .whitespacesAndNewlines)
        let life4Count = Int(life4CountText) ?? 0
        
        if life4Count > 0 {
            return .Life4
        }
        
        return .None
    }
    
    private static func parsePlayCount(_ doc: Document) throws -> Int32 {
        let playCountElement = try doc.select("th:contains(プレー回数) + td").first()
        let playCountText = try playCountElement?.text() ?? "0"
        return Int32(playCountText) ?? 0
    }
    
    private static func parseClearCount(_ doc: Document) throws -> Int32 {
        let clearCountElement = try doc.select("th:contains(クリア回数) + td").first()
        let clearCountText = try clearCountElement?.text() ?? "0"
        return Int32(clearCountText) ?? 0
    }
    
    private static func parseFlareRank(_ doc: Document) throws -> Int32 {
        let flareRankElement = try doc.select("th:contains(フレアランク) + td").first()
        let flareRankText = try flareRankElement?.text() ?? ""
        switch flareRankText {
        case "EX": return 10
        case "IX": return 9
        case "VIII": return 8
        case "VII": return 7
        case "VI": return 6
        case "V": return 5
        case "IV": return 4
        case "III": return 3
        case "II": return 2
        case "I": return 1
        default: return -1
        }
    }
    enum ParseError: Error {
        case unableToDetermineGameMode
        
        case parsingFailed(description: String)
        case musicNameMismatch(webTitle: String, pageTitle: String)
        case elementNotFound(String)
        case invalidValue(String)
    }
}
