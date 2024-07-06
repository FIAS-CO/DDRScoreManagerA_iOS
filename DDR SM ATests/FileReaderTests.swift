import XCTest
import Foundation
@testable import dsma

class FileReaderTests: XCTestCase {
    
    var oldTSVContent: String!
    var newTSVContent: String!
    var newTSVFlareContent: String!
    
    override func setUp() {
        super.setUp()
        
        // テストデータファイルを読み込む
        let bundle = Bundle(for: type(of: self))
        if let oldPath = bundle.path(forResource: "OldScoreData", ofType: "txt"),
           let newPath = bundle.path(forResource: "NewScoreData", ofType: "txt"),
           let flarePath = bundle.path(forResource: "NewScoreDataFlare", ofType: "txt") {
            oldTSVContent = try? String(contentsOfFile: oldPath, encoding: .utf8)
            newTSVContent = try? String(contentsOfFile: newPath, encoding: .utf8)
            newTSVFlareContent = try? String(contentsOfFile: flarePath, encoding: .utf8)
        } else {
            XCTFail("テストデータファイルが見つかりません")
        }
    }
    
    func testParseScoreData() {
        guard let newTSVFlareContent = newTSVFlareContent else {
            XCTFail("テストデータの読み込みに失敗しました")
            return
        }
        
        // 3. 新メソッド（新TSV）
        let scores = FileReader.parseScoreData(newTSVFlareContent)
        
        // 項目数のチェック
        XCTAssertEqual(scores.count, 1155, "スコアの項目数が1155ではありません")
        
        // 特定の2行のチェック
        let score233 = scores[233]
        XCTAssertNotNil(score233, "ID 233 のスコアが存在しません")
        if let score = score233 {
            XCTAssertEqual(score.ESP.Rank, .AAA)
            XCTAssertEqual(score.ESP.Score, 999660)
            XCTAssertEqual(score.ESP.FullComboType_, .PerfectFullCombo)
            XCTAssertEqual(score.EDP.Rank, .AA)
            XCTAssertEqual(score.EDP.Score, 944400)
            XCTAssertEqual(score.EDP.FullComboType_, .None)
            XCTAssertEqual(score.bSP.flareRank, 10)
            XCTAssertEqual(score.BSP.flareRank, 7)
            XCTAssertEqual(score.DSP.flareRank, 6)
            XCTAssertEqual(score.ESP.flareRank, 5)
            XCTAssertEqual(score.CSP.flareRank, 4)
            XCTAssertEqual(score.BDP.flareRank, 3)
            XCTAssertEqual(score.DDP.flareRank, 2)
            XCTAssertEqual(score.EDP.flareRank, 1)
            XCTAssertEqual(score.CDP.flareRank, 0)
        }
        
        let score453 = scores[453]
        XCTAssertNotNil(score453, "ID 453 のスコアが存在しません")
        if let score = score453 {
            XCTAssertEqual(score.ESP.Rank, .AAA)
            XCTAssertEqual(score.ESP.Score, 996710)
            XCTAssertEqual(score.ESP.FullComboType_, .FullCombo)
            XCTAssertEqual(score.CSP.Rank, .AAA)
            XCTAssertEqual(score.CSP.Score, 999860)
            XCTAssertEqual(score.CSP.FullComboType_, .PerfectFullCombo)
            XCTAssertEqual(score.DDP.Rank, .A)
            XCTAssertEqual(score.DDP.Score, 811160)
            XCTAssertEqual(score.DDP.FullComboType_, .None)
            XCTAssertEqual(score.CDP.Rank, .AAm)
            XCTAssertEqual(score.CDP.Score, 898950)
            XCTAssertEqual(score.CDP.FullComboType_, .None)
            XCTAssertEqual(score.EDP.flareRank, 8)
            XCTAssertEqual(score.CDP.flareRank, 9)
        }
    }
    
    // 何かあった時に使う
    func testCompareScoreListMethods() {
        guard let oldTSVContent = oldTSVContent, let newTSVContent = newTSVContent else {
            XCTFail("テストデータの読み込みに失敗しました")
            return
        }
        
        // 1. 旧メソッド（旧TSV）
        let oldScoresFromOldMethod = FileReader.parseOld(oldTSVContent)
        
        // 2. 新メソッド（旧TSV）
        let oldScoresFromNewMethod = FileReader.parseScoreData(oldTSVContent)
        
        // 3. 新メソッド（新TSV）
        let newScoresFromNewMethod = FileReader.parseScoreData(newTSVContent)
        
        // 結果の比較
        XCTAssertEqual(oldScoresFromOldMethod.count, oldScoresFromNewMethod.count, "旧TSVの結果数が一致しません")
        XCTAssertEqual(oldScoresFromOldMethod.count, newScoresFromNewMethod.count, "新旧TSVの結果数が一致しません")
        
        for (id, oldScore) in oldScoresFromOldMethod {
            // 新メソッド（旧TSV）との比較
            XCTAssertNotNil(oldScoresFromNewMethod[id], "ID \(id) が新メソッド（旧TSV）の結果に存在しません")
            if let newScore = oldScoresFromNewMethod[id] {
                XCTAssertEqual(oldScore, newScore, "ID \(id) のスコアが一致しません（旧TSV）")
                
            }
            
            // 新メソッド（新TSV）との比較
            XCTAssertNotNil(newScoresFromNewMethod[id], "ID \(id) が新メソッド（新TSV）の結果に存在しません")
            if let newScore = newScoresFromNewMethod[id] {
                // 既存のフィールドの比較
                XCTAssertEqual(oldScore.bSP, newScore.bSP, "ID \(id) の bSP スコアが一致しません")
                XCTAssertEqual(oldScore.BSP, newScore.BSP, "ID \(id) の BSP スコアが一致しません")
                XCTAssertEqual(oldScore.DSP, newScore.DSP, "ID \(id) の DSP スコアが一致しません")
                XCTAssertEqual(oldScore.ESP, newScore.ESP, "ID \(id) の ESP スコアが一致しません")
                XCTAssertEqual(oldScore.CSP, newScore.CSP, "ID \(id) の CSP スコアが一致しません")
                XCTAssertEqual(oldScore.BDP, newScore.BDP, "ID \(id) の BDP スコアが一致しません")
                XCTAssertEqual(oldScore.DDP, newScore.DDP, "ID \(id) の DDP スコアが一致しません")
                XCTAssertEqual(oldScore.EDP, newScore.EDP, "ID \(id) の EDP スコアが一致しません")
                XCTAssertEqual(oldScore.CDP, newScore.CDP, "ID \(id) の CDP スコアが一致しません")
            }
        }
    }
}

extension MusicScore: Equatable {
    public static func == (lhs: MusicScore, rhs: MusicScore) -> Bool {
        return lhs.bSP == rhs.bSP &&
        lhs.BSP == rhs.BSP &&
        lhs.DSP == rhs.DSP &&
        lhs.ESP == rhs.ESP &&
        lhs.CSP == rhs.CSP &&
        lhs.BDP == rhs.BDP &&
        lhs.DDP == rhs.DDP &&
        lhs.EDP == rhs.EDP &&
        lhs.CDP == rhs.CDP
    }
}

extension ScoreData: Equatable {
    public static func == (lhs: ScoreData, rhs: ScoreData) -> Bool {
        return lhs.Rank == rhs.Rank &&
        lhs.Score == rhs.Score &&
        lhs.MaxCombo == rhs.MaxCombo &&
        lhs.FullComboType_ == rhs.FullComboType_ &&
        lhs.PlayCount == rhs.PlayCount &&
        lhs.ClearCount == rhs.ClearCount &&
        lhs.flareRank == rhs.flareRank
    }
}
