//
//  HtmlParseUtilTest.swift
//  DDR SM ATests
//
//  Created by apple on 2024/08/09.
//  Copyright © 2024 LinaNfinE. All rights reserved.
//

import Foundation
import XCTest
@testable import dsma // あなたのアプリのモジュール名に置き換えてください

class HtmlParseUtilTests: XCTestCase {
    
    var htmlContentSingle: String!
    var htmlContentDouble: String!
    var htmlContentDetail: String!
    var htmlContentDetail2: String!
    var htmlContentDetail3: String!
    var htmlContentDetail4: String!
    var htmlContentDetail5: String!
    var htmlContentDetail6: String!
    
    override func setUp() {
        super.setUp()
        htmlContentSingle = loadHTMLContent(fileName: "WorldSiteDataSingle")
        htmlContentDouble = loadHTMLContent(fileName: "WorldSiteDataDouble")
        htmlContentDetail = loadHTMLContent(fileName: "WorldSiteDataDetail")
        htmlContentDetail2 = loadHTMLContent(fileName: "WorldSiteDataDetail_AAp_GFC_NoRank")
        htmlContentDetail3 = loadHTMLContent(fileName: "WorldSiteDataDetail_AA_LIFE4_FlareIX")
        htmlContentDetail4 = loadHTMLContent(fileName: "WorldSiteDataDetail_Noplay")
        htmlContentDetail5 = loadHTMLContent(fileName: "WorldSiteDataDetail_Ap_GdFc_FlareEX")
        htmlContentDetail6 = loadHTMLContent(fileName: "WorldSiteDataDetail_E")
    }
    
    func testParseMusicListSingle() {
        let (gameMode, result) = tryParseMusicList(src: htmlContentSingle)
        
        XCTAssertFalse(result.isEmpty, "Result should not be empty")
        
        XCTAssertEqual(gameMode, .single)
        
        // 特定の曲のテスト
        testSpecificSongs(in: result)
        
        // フレアランクのバリエーションをチェック
        checkFlareRanks(in: result)
        
        // フルコンボタイプのバリエーションをチェック
        checkFullComboTypes(in: result)
    }
    
    private func testSpecificSongs(in result: [MusicEntry]) {
        if let songEntry = result.first(where: { $0.musicName == "とこにゃつ☆トロピカル" }) {
            XCTAssertEqual(songEntry.scores.count, 5, "Should have 5 difficulty scores")
            
            if let difficultScore = songEntry.scores.first(where: { $0.difficultyId == "basic" }) {
                XCTAssertEqual(difficultScore.score, 0)
                XCTAssertEqual(difficultScore.rank, .Noplay)
                XCTAssertEqual(difficultScore.fullComboType, .None)
                XCTAssertEqual(difficultScore.flareRank, -1) // フレアランクなし
            } else {
                XCTFail("DIFFICULT score for 'とこにゃつ☆トロピカル' not found")
            }
        } else {
            XCTFail("Song 'とこにゃつ☆トロピカル' not found")
        }
        
        // "晴天Bon Voyage"のテスト
        if let songEntry = result.first(where: { $0.musicName == "晴天Bon Voyage" }) {
            XCTAssertEqual(songEntry.scores.count, 5, "Should have 5 difficulty scores")
            
            if let difficultScore = songEntry.scores.first(where: { $0.difficultyId == "difficult" }) {
                XCTAssertEqual(difficultScore.score, 999580)
                XCTAssertEqual(difficultScore.rank, .AAA)
                XCTAssertEqual(difficultScore.fullComboType, .PerfectFullCombo)
                XCTAssertEqual(difficultScore.flareRank, -1) // フレアランクなし
            } else {
                XCTFail("DIFFICULT score for '晴天Bon Voyage' not found")
            }
            
            if let expertScore = songEntry.scores.first(where: { $0.difficultyId == "expert" }) {
                XCTAssertEqual(expertScore.score, 991320)
                XCTAssertEqual(expertScore.rank, .AAA)
                XCTAssertEqual(expertScore.fullComboType, .FullCombo)
                XCTAssertEqual(expertScore.flareRank, -1) // フレアランクなし
            } else {
                XCTFail("EXPERT score for '晴天Bon Voyage' not found")
            }
        } else {
            XCTFail("Song '晴天Bon Voyage' not found")
        }
        
        // "零 - ZERO -"のテスト（EXフレアランクの確認）
        if let songEntry = result.first(where: { $0.musicName == "零 - ZERO -" }) {
            if let expertScore = songEntry.scores.first(where: { $0.difficultyId == "beginner" }) {
                XCTAssertEqual(expertScore.score, 1000000)
                XCTAssertEqual(expertScore.rank, .AAA)
                XCTAssertEqual(expertScore.fullComboType, .MarvelousFullCombo)
                XCTAssertEqual(expertScore.flareRank, 2)
            } else {
                XCTFail("EXPERT score for '零 - ZERO -' not found")
            }
            
            if let expertScore = songEntry.scores.first(where: { $0.difficultyId == "expert" }) {
                XCTAssertEqual(expertScore.score, 999550)
                XCTAssertEqual(expertScore.rank, .AAA)
                XCTAssertEqual(expertScore.fullComboType, .PerfectFullCombo)
                XCTAssertEqual(expertScore.flareRank, 10) // EXランク
            } else {
                XCTFail("EXPERT score for '零 - ZERO -' not found")
            }
        } else {
            XCTFail("Song '零 - ZERO -' not found")
        }
        
        // "打打打打打打打打打打"のテスト（フレアランク9の確認）
        if let songEntry = result.first(where: { $0.musicName == "打打打打打打打打打打" }) {
            if let expertScore = songEntry.scores.first(where: { $0.difficultyId == "expert" }) {
                XCTAssertEqual(expertScore.score, 997570)
                XCTAssertEqual(expertScore.rank, .AAA)
                XCTAssertEqual(expertScore.fullComboType, .FullCombo)
                XCTAssertEqual(expertScore.flareRank, 10)
            } else {
                XCTFail("EXPERT score for '打打打打打打打打打打' not found")
            }
            
            if let challengeScore = songEntry.scores.first(where: { $0.difficultyId == "challenge" }) {
                XCTAssertEqual(challengeScore.score, 985140)
                XCTAssertEqual(challengeScore.rank, .AAp)
                XCTAssertEqual(challengeScore.fullComboType, .FullCombo)
                XCTAssertEqual(challengeScore.flareRank, 9) // フレアランク9
            } else {
                XCTFail("CHALLENGE score for '打打打打打打打打打打' not found")
            }
        } else {
            XCTFail("Song '打打打打打打打打打打' not found")
        }
        
        // "嘆きの樹"のテスト（フレアランク1の確認とクリアランクApの確認）
        if let songEntry = result.first(where: { $0.musicName == "嘆きの樹" }) {
            if let expertScore = songEntry.scores.first(where: { $0.difficultyId == "expert" }) {
                XCTAssertEqual(expertScore.score, 940000)
                XCTAssertEqual(expertScore.rank, .AA)
                XCTAssertEqual(expertScore.fullComboType, .None)
                XCTAssertEqual(expertScore.flareRank, 1) // フレアランク1
            } else {
                XCTFail("EXPERT score for '嘆きの樹' not found")
            }
            
            if let challengeScore = songEntry.scores.first(where: { $0.difficultyId == "challenge" }) {
                XCTAssertEqual(challengeScore.score, 860550)
                XCTAssertEqual(challengeScore.rank, .Ap)
                XCTAssertEqual(challengeScore.fullComboType, .None)
                XCTAssertEqual(challengeScore.flareRank, -1) // フレアランクなし
            } else {
                XCTFail("CHALLENGE score for '嘆きの樹' not found")
            }
        } else {
            XCTFail("Song '嘆きの樹' not found")
        }
        
        // "ちくわパフェだよ☆ＣＫＰ"のテスト（GoodFullComboの確認）
        if let songEntry = result.first(where: { $0.musicName == "ちくわパフェだよ☆ＣＫＰ" }) {
            if let expertScore = songEntry.scores.first(where: { $0.difficultyId == "expert" }) {
                XCTAssertEqual(expertScore.score, 996090)
                XCTAssertEqual(expertScore.rank, .AAA)
                XCTAssertEqual(expertScore.fullComboType, .FullCombo)
                XCTAssertEqual(expertScore.flareRank, -1) // フレアランクなし
            } else {
                XCTFail("EXPERT score for 'ちくわパフェだよ☆ＣＫＰ' not found")
            }
            
            if let challengeScore = songEntry.scores.first(where: { $0.difficultyId == "challenge" }) {
                XCTAssertEqual(challengeScore.score, 991030)
                XCTAssertEqual(challengeScore.rank, .AAA)
                XCTAssertEqual(challengeScore.fullComboType, .FullCombo)
                XCTAssertEqual(challengeScore.flareRank, 9) // フレアランク9
            } else {
                XCTFail("CHALLENGE score for 'ちくわパフェだよ☆ＣＫＰ' not found")
            }
        } else {
            XCTFail("Song 'ちくわパフェだよ☆ＣＫＰ' not found")
        }
        
        if let songEntry = result.first(where: { $0.musicName == "伐折羅-vajra-" }) {
            if let expertScore = songEntry.scores.first(where: { $0.difficultyId == "expert" }) {
                XCTAssertEqual(expertScore.score, 925780)
                XCTAssertEqual(expertScore.rank, .AA)
                XCTAssertEqual(expertScore.fullComboType, .None)
                XCTAssertEqual(expertScore.flareRank, -1) // フレアランクなし
            } else {
                XCTFail("EXPERT score for '伐折羅-vajra-' not found")
            }
            
            if let challengeScore = songEntry.scores.first(where: { $0.difficultyId == "challenge" }) {
                XCTAssertEqual(challengeScore.score, 741330)
                XCTAssertEqual(challengeScore.rank, .B)
                XCTAssertEqual(challengeScore.fullComboType, .None)
                XCTAssertEqual(challengeScore.flareRank, -1) // フレアランクなし
            } else {
                XCTFail("CHALLENGE score for '伐折羅-vajra-' not found")
            }
        } else {
            XCTFail("Song '伐折羅-vajra-' not found")
        }
        
        if let songEntry = result.first(where: { $0.musicName == "パーフェクトイーター" }) {
            if let expertScore = songEntry.scores.first(where: { $0.difficultyId == "expert" }) {
                XCTAssertEqual(expertScore.score, 969480)
                XCTAssertEqual(expertScore.rank, .AAp)
                XCTAssertEqual(expertScore.fullComboType, .Life4)
                XCTAssertEqual(expertScore.flareRank, -1) // フレアランクなし
            } else {
                XCTFail("EXPERT score for 'パーフェクトイーター' not found")
            }
        } else {
            XCTFail("Song 'パーフェクトイーター' not found")
        }
        
        if let songEntry = result.first(where: { $0.musicName == "春を告げる" }) {
            if let expertScore = songEntry.scores.first(where: { $0.difficultyId == "expert" }) {
                XCTAssertEqual(expertScore.score, 735190)
                XCTAssertEqual(expertScore.rank, .E)
                XCTAssertEqual(expertScore.fullComboType, .None)
                XCTAssertEqual(expertScore.flareRank, -1) // フレアランクなし
            } else {
                XCTFail("EXPERT score for '春を告げる' not found")
            }
        } else {
            XCTFail("Song '春を告げる' not found")
        }
        
        //Afterimage d'automne シングルクォーテーションのテスト
        
        if let songEntry = result.first(where: { $0.musicName == "Afterimage d'automne" }) {
            if let expertScore = songEntry.scores.first(where: { $0.difficultyId == "expert" }) {
                XCTAssertEqual(expertScore.score, 980370)
                XCTAssertEqual(expertScore.rank, .AAp)
                XCTAssertEqual(expertScore.fullComboType, .FullCombo)
                XCTAssertEqual(expertScore.flareRank, -1) // フレアランクなし
            } else {
                XCTFail("EXPERT score for 'Afterimage d'automne' not found")
            }
        } else {
            XCTFail("Song 'Afterimage d'automne' not found")
        }
        
        if let songEntry = result.first(where: { $0.musicName == "蒼が消えるとき" }) {
            if let score = songEntry.scores.first(where: { $0.difficultyId == "difficult" }) {
                XCTAssertEqual(score.score, 999640)
                XCTAssertEqual(score.rank, .AAA)
                XCTAssertEqual(score.fullComboType, .PerfectFullCombo)
                XCTAssertEqual(score.flareRank, 0) // フレアランクなし
            } else {
                XCTFail("EXPERT score for 'Afterimage d'automne' not found")
            }
        } else {
            XCTFail("Song 'Afterimage d'automne' not found")
        }
    }
    
    func testParseMusicListDouble() {
        let (gameMode, result) = tryParseMusicList(src: htmlContentDouble)
        
        XCTAssertFalse(result.isEmpty, "Result should not be empty")
        
        XCTAssertEqual(gameMode, .double)
        
        // 特定の曲のテスト
        testSpecificSongsDouble(in: result)
    }
    
    func testParseMusicDetailForWorld_PFC_AAA_FlareEX() {
        do {
            let webMusicId = WebMusicId()
            webMusicId.titleOnWebPage = "星座が恋した瞬間を。"
            webMusicId.idOnWebPage = "ld8lOqloqD6lOl880ldDo819bDb9q1Qi"
            
            let scoreData = try HtmlParseUtil.parseMusicDetailForWorld(src: htmlContentDetail, webMusicId: webMusicId)
            
            XCTAssertEqual(scoreData.Rank, .AAA)
            XCTAssertEqual(scoreData.Score, 999500)
            XCTAssertEqual(scoreData.MaxCombo, 462)
            XCTAssertEqual(scoreData.FullComboType_, .PerfectFullCombo)
            XCTAssertEqual(scoreData.PlayCount, 22)
            XCTAssertEqual(scoreData.ClearCount, 21)
            XCTAssertEqual(scoreData.flareRank, 10) // EX rank
        } catch {
            XCTFail("Failed to parse music detail: \(error)")
        }
    }
    
    func testParseMusicDetailForWorld_GFC_AAp_NoFlare() {
        do {
            let webMusicId = WebMusicId()
            webMusicId.titleOnWebPage = "アルストロメリア (walk with you remix)"
            webMusicId.idOnWebPage = "8bQQ0lP96186D8Ibo8IoOd6o16qioiIo"
            
            let scoreData = try HtmlParseUtil.parseMusicDetailForWorld(src: htmlContentDetail2, webMusicId: webMusicId)
            
            XCTAssertEqual(scoreData.Rank, .AAp)
            XCTAssertEqual(scoreData.Score, 989460)
            XCTAssertEqual(scoreData.MaxCombo, 425)
            XCTAssertEqual(scoreData.FullComboType_, .FullCombo)
            XCTAssertEqual(scoreData.PlayCount, 7)
            XCTAssertEqual(scoreData.ClearCount, 4)
            XCTAssertEqual(scoreData.flareRank, -1)
        } catch {
            XCTFail("Failed to parse music detail: \(error)")
        }
    }
    
    func testParseMusicDetailForWorld_LIFE4_AA_FlareIX() {
        do {
            let webMusicId = WebMusicId()
            webMusicId.titleOnWebPage = "イノセントバイブル"
            webMusicId.idOnWebPage = "dummy"
            
            let scoreData = try HtmlParseUtil.parseMusicDetailForWorld(src: htmlContentDetail3, webMusicId: webMusicId)
            
            XCTAssertEqual(scoreData.Rank, .AA)
            XCTAssertEqual(scoreData.Score, 947070)
            XCTAssertEqual(scoreData.MaxCombo, 147)
            XCTAssertEqual(scoreData.FullComboType_, .Life4)
            XCTAssertEqual(scoreData.PlayCount, 1)
            XCTAssertEqual(scoreData.ClearCount, 1)
            XCTAssertEqual(scoreData.flareRank, 9)
        } catch {
            XCTFail("Failed to parse music detail: \(error)")
        }
    }
    
    func testParseMusicDetailForWorld_Noplay() {
        do {
            let webMusicId = WebMusicId()
            webMusicId.titleOnWebPage = "蒼い衝動 ～for EXTREME～"
            webMusicId.idOnWebPage = "dummy"
            
            let scoreData = try HtmlParseUtil.parseMusicDetailForWorld(src: htmlContentDetail4, webMusicId: webMusicId)
            
            XCTAssertEqual(scoreData.Rank, .Noplay)
            XCTAssertEqual(scoreData.Score, 0)
            XCTAssertEqual(scoreData.MaxCombo, 0)
            XCTAssertEqual(scoreData.FullComboType_, .None)
            XCTAssertEqual(scoreData.PlayCount, 0)
            XCTAssertEqual(scoreData.ClearCount, 0)
            XCTAssertEqual(scoreData.flareRank, -1)
        } catch {
            XCTFail("Failed to parse music detail: \(error)")
        }
    }
    
    func testParseMusicDetailForWorld_Ap_GdFC_FlareEx() {
        do {
            let webMusicId = WebMusicId()
            webMusicId.titleOnWebPage = "阿波おどり -Awaodori- やっぱり踊りはやめられない"
            webMusicId.idOnWebPage = "dummy"
            
            let scoreData = try HtmlParseUtil.parseMusicDetailForWorld(src: htmlContentDetail5, webMusicId: webMusicId)
            
            XCTAssertEqual(scoreData.Rank, .Ap)
            XCTAssertEqual(scoreData.Score, 811110)
            XCTAssertEqual(scoreData.MaxCombo, 474)
            XCTAssertEqual(scoreData.FullComboType_, .GoodFullCombo)
            XCTAssertEqual(scoreData.PlayCount, 17)
            XCTAssertEqual(scoreData.ClearCount, 14)
            XCTAssertEqual(scoreData.flareRank, 10)
        } catch {
            XCTFail("Failed to parse music detail: \(error)")
        }
    }
    
    func testParseMusicDetailForWorld_E() {
        do {
            let webMusicId = WebMusicId()
            webMusicId.titleOnWebPage = "春を告げる"
            webMusicId.idOnWebPage = "dummy"
            
            let scoreData = try HtmlParseUtil.parseMusicDetailForWorld(src: htmlContentDetail6, webMusicId: webMusicId)
            
            XCTAssertEqual(scoreData.Rank, .E)
            XCTAssertEqual(scoreData.Score, 735190)
            XCTAssertEqual(scoreData.MaxCombo, 184)
            XCTAssertEqual(scoreData.FullComboType_, .None)
            XCTAssertEqual(scoreData.PlayCount, 1)
            XCTAssertEqual(scoreData.ClearCount, 0)
            XCTAssertEqual(scoreData.flareRank, -1)
        } catch {
            XCTFail("Failed to parse music detail: \(error)")
        }
    }
    
    func testParseMusicDetailForWorld_Rank0() {
        do {
            let webMusicId = WebMusicId()
            webMusicId.titleOnWebPage = "蒼が消えるとき"
            webMusicId.idOnWebPage = "dummy"
            
            let content = loadHTMLContent(fileName: "WorldSiteDataDetail_Rank0") ?? ""
            let scoreData = try HtmlParseUtil.parseMusicDetailForWorld(src: content, webMusicId: webMusicId)
            
            XCTAssertEqual(scoreData.Rank, .AAA)
            XCTAssertEqual(scoreData.Score, 999640)
            XCTAssertEqual(scoreData.MaxCombo, 323)
            XCTAssertEqual(scoreData.FullComboType_, .PerfectFullCombo)
            XCTAssertEqual(scoreData.PlayCount, 4)
            XCTAssertEqual(scoreData.ClearCount, 4)
            XCTAssertEqual(scoreData.flareRank, 0)
        } catch {
            XCTFail("Failed to parse music detail: \(error)")
        }
    }
    
    private func testSpecificSongsDouble(in result: [MusicEntry]) {
        if let songEntry = result.first(where: { $0.musicName == "蒼い衝動 ～for EXTREME～" }) {
            XCTAssertEqual(songEntry.scores.count, 4, "Should have 4 difficulty scores")
            
            if let difficultScore = songEntry.scores.first(where: { $0.difficultyId == "expert" }) {
                XCTAssertEqual(difficultScore.score, 0)
                XCTAssertEqual(difficultScore.rank, .Noplay)
                XCTAssertEqual(difficultScore.fullComboType, .None)
                XCTAssertEqual(difficultScore.flareRank, -1) // フレアランクなし
            } else {
                XCTFail("DIFFICULT score for '蒼い衝動 ～for EXTREME～' not found")
            }
        } else {
            XCTFail("Song '蒼い衝動 ～for EXTREME～' not found")
        }
        
        // "晴天Bon Voyage"のテスト
        if let songEntry = result.first(where: { $0.musicName == "蒼が消えるとき" }) {
            XCTAssertEqual(songEntry.scores.count, 4, "Should have 4 difficulty scores")
            
            if let difficultScore = songEntry.scores.first(where: { $0.difficultyId == "difficult" }) {
                XCTAssertEqual(difficultScore.score, 971780)
                XCTAssertEqual(difficultScore.rank, .AAp)
                XCTAssertEqual(difficultScore.fullComboType, .GoodFullCombo)
                XCTAssertEqual(difficultScore.flareRank, -1) // フレアランクなし
            } else {
                XCTFail("DIFFICULT score for '蒼が消えるとき' not found")
            }
            
            if let expertScore = songEntry.scores.first(where: { $0.difficultyId == "expert" }) {
                XCTAssertEqual(expertScore.score, 896870)
                XCTAssertEqual(expertScore.rank, .AAm)
                XCTAssertEqual(expertScore.fullComboType, .None)
                XCTAssertEqual(expertScore.flareRank, -1) // フレアランクなし
            } else {
                XCTFail("EXPERT score for '蒼が消えるとき' not found")
            }
        } else {
            XCTFail("Song '蒼が消えるとき' not found")
        }
        
        if let songEntry = result.first(where: { $0.musicName == "天ノ弱" }) {
            XCTAssertEqual(songEntry.scores.count, 4, "Should have 4 difficulty scores")
            
            if let expertScore = songEntry.scores.first(where: { $0.difficultyId == "difficult" }) {
                XCTAssertEqual(expertScore.score, 867390)
                XCTAssertEqual(expertScore.rank, .Ap)
                XCTAssertEqual(expertScore.fullComboType, .None)
                XCTAssertEqual(expertScore.flareRank, -1) // EXランク
            } else {
                XCTFail("EXPERT score for '天ノ弱' not found")
            }
        } else {
            XCTFail("Song '天ノ弱' not found")
        }
        
        var musicName = "鋳鉄の檻"
        if let songEntry = result.first(where: { $0.musicName == musicName }) {
            XCTAssertEqual(songEntry.scores.count, 4, "Should have 4 difficulty scores")
            
            if let expertScore = songEntry.scores.first(where: { $0.difficultyId == "basic" }) {
                XCTAssertEqual(expertScore.score, 986070)
                XCTAssertEqual(expertScore.rank, .AAp)
                XCTAssertEqual(expertScore.fullComboType, .FullCombo)
                XCTAssertEqual(expertScore.flareRank, -1)
            } else {
                XCTFail("EXPERT score for \(musicName) not found")
            }
        } else {
            XCTFail("Song \(musicName) not found")
        }
        
        musicName = "イノセントバイブル"
        if let songEntry = result.first(where: { $0.musicName == musicName }) {
            XCTAssertEqual(songEntry.scores.count, 4, "Should have 4 difficulty scores")
            
            if let expertScore = songEntry.scores.first(where: { $0.difficultyId == "difficult" }) {
                XCTAssertEqual(expertScore.score, 937000)
                XCTAssertEqual(expertScore.rank, .AA)
                XCTAssertEqual(expertScore.fullComboType, .Life4)
                XCTAssertEqual(expertScore.flareRank, -1)
            } else {
                XCTFail("EXPERT score for \(musicName) not found")
            }
        } else {
            XCTFail("Song \(musicName) not found")
        }
        
        musicName = "梅雪夜"
        if let songEntry = result.first(where: { $0.musicName == musicName }) {
            XCTAssertEqual(songEntry.scores.count, 4, "Should have 4 difficulty scores")
            
            if let expertScore = songEntry.scores.first(where: { $0.difficultyId == "expert" }) {
                XCTAssertEqual(expertScore.score, 741400)
                XCTAssertEqual(expertScore.rank, .B)
                XCTAssertEqual(expertScore.fullComboType, .None)
                XCTAssertEqual(expertScore.flareRank, -1)
            } else {
                XCTFail("EXPERT score for \(musicName) not found")
            }
        } else {
            XCTFail("Song \(musicName) not found")
        }
        
        musicName = "カゲロウ"
        if let songEntry = result.first(where: { $0.musicName == musicName }) {
            XCTAssertEqual(songEntry.scores.count, 4, "Should have 4 difficulty scores")
            
            if let expertScore = songEntry.scores.first(where: { $0.difficultyId == "difficult" }) {
                XCTAssertEqual(expertScore.score, 827740)
                XCTAssertEqual(expertScore.rank, .A)
                XCTAssertEqual(expertScore.fullComboType, .None)
                XCTAssertEqual(expertScore.flareRank, -1)
            } else {
                XCTFail("EXPERT score for \(musicName) not found")
            }
        } else {
            XCTFail("Song \(musicName) not found")
        }
        
        musicName = "狂水一華"
        if let songEntry = result.first(where: { $0.musicName == musicName }) {
            XCTAssertEqual(songEntry.scores.count, 4, "Should have 4 difficulty scores")
            
            if let expertScore = songEntry.scores.first(where: { $0.difficultyId == "difficult" }) {
                XCTAssertEqual(expertScore.score, 705890)
                XCTAssertEqual(expertScore.rank, .E)
                XCTAssertEqual(expertScore.fullComboType, .None)
                XCTAssertEqual(expertScore.flareRank, -1)
            } else {
                XCTFail("EXPERT score for \(musicName) not found")
            }
        } else {
            XCTFail("Song \(musicName) not found")
        }
    }
    
    private func checkFlareRanks(in result: [MusicEntry]) {
        let expectedFlareRanks = [-1, 1, 9, 10] // -1はフレアランクなし、0はフレアスキルのみ、1-9は通常のランク、10はEX
        for rank in expectedFlareRanks {
            XCTAssertTrue(result.contains { song in
                song.scores.contains { $0.flareRank == rank }
            }, "Should find a song with flare rank \(rank)")
        }
    }
    
    private func checkFullComboTypes(in result: [MusicEntry]) {
        let fullComboTypes: [FullComboType] = [.None, .FullCombo, .FullCombo, .PerfectFullCombo, .Life4]
        for type in fullComboTypes {
            XCTAssertTrue(result.contains { song in
                song.scores.contains { $0.fullComboType == type }
            }, "Should find a song with \(type) full combo type")
        }
    }
    
    private func tryParseMusicList(src: String) -> (GameMode, [MusicEntry]) {
        do {
            return try HtmlParseUtil.parseMusicList(src: src)
        } catch {
            XCTFail("Failed to parse music list: \(error)")
            fatalError("Test failed due to parsing error") // テストを即座に終了
        }
    }
    
    private func loadHTMLContent(fileName: String, fileType: String = "html") -> String? {
        if let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: fileType) {
            do {
                let htmlContent = try String(contentsOfFile: path, encoding: .utf8)
                XCTAssertNotNil(htmlContent, "Test data should be loaded")
                return htmlContent
            } catch {
                XCTFail("Failed to load content from \(fileName).\(fileType): \(error)")
                return nil
            }
        } else {
            XCTFail("Path for resource \(fileName).\(fileType) should not be nil")
            return nil
        }
    }
}
