import XCTest
@testable import dsma

class TopFlareSkillProcessorTests: XCTestCase {
    
    var processor: TopFlareSkillProcessor!
    var mScoreList: [Int32: MusicScore]!
    var musicDataMap: [Int32: MusicData]!
    
    override func setUp() {
        super.setUp()
        processor = TopFlareSkillProcessor()
        mScoreList = [:]
        musicDataMap = [:]
        
        // テストデータのセットアップ
        setupTestData()
    }
    
    private func setupTestData() {
        // MusicScore と MusicData のテストデータを作成
        for i in 1...100 {
            var score = MusicScore()
            score.ESP = createScoreData(flareSkill: Int32(i))
            score.CDP = createScoreData(flareSkill: Int32(i + 1))
            
            var data = MusicData()
            data.Name = "Song \(i)"
            data.SeriesTitle_ = i <= 30 ? .X3_2ndMix :
                (i <= 60 ? .A : .A20)
            
            mScoreList[Int32(i)] = score
            musicDataMap[Int32(i)] = data
        }
    }
    
    private func createScoreData(flareSkill: Int32) -> ScoreData {
        var data = ScoreData()
        data.flareSkill = flareSkill
        data.Score = flareSkill * 100
        data.flareRank = 5
        return data
    }
    
    func testProcessTopFlareSkills() throws {
        let result = TopFlareSkillProcessor.processTopFlareSkills(playerId: "test", mScoreList: mScoreList, musicDataMap: musicDataMap)
        
        XCTAssertTrue(result.starts(with: "{\""))
        XCTAssertTrue(result.hasSuffix("}"))
        
        let jsonData = result.data(using: .utf8)!
        let response = try JSONDecoder().decode(TopFlareSkillResponse.self, from: jsonData)
        let scores = response.scores
        
        XCTAssertEqual(30, scores.filter { $0.category == "GOLD" && $0.playStyle == "SP" }.count)
        XCTAssertEqual(30, scores.filter { $0.category == "WHITE" && $0.playStyle == "SP" }.count)
        XCTAssertEqual(30, scores.filter { $0.category == "CLASSIC" && $0.playStyle == "SP" }.count)
        
        XCTAssertEqual(30, scores.filter { $0.category == "GOLD" && $0.playStyle == "DP" }.count)
        XCTAssertEqual(30, scores.filter { $0.category == "WHITE" && $0.playStyle == "DP" }.count)
        XCTAssertEqual(30, scores.filter { $0.category == "CLASSIC" && $0.playStyle == "DP" }.count)
        
        // カテゴリとプレイスタイルが正しく設定されていることを確認
        for score in scores {
            XCTAssertNotNil(score.category)
            XCTAssertTrue(["CLASSIC", "WHITE", "GOLD"].contains(score.category))
            XCTAssertTrue(["SP", "DP"].contains(score.playStyle))
        }
        
        XCTAssertEqual("test", response.playerId)
        XCTAssertEqual(4395, response.totalFlareSkillSp)
        XCTAssertEqual(4485, response.totalFlareSkillDp)
    }
    
    func testEmptyInput() throws {
        let result = TopFlareSkillProcessor.processTopFlareSkills(playerId: "test", mScoreList: [:], musicDataMap: [:])
        let jsonData = result.data(using: .utf8)!
        let response = try JSONDecoder().decode(TopFlareSkillResponse.self, from: jsonData)
        let scores = response.scores
        
        
        XCTAssertTrue(scores.isEmpty)
        XCTAssertEqual("test", response.playerId)
        XCTAssertEqual(0, response.totalFlareSkillSp)
        XCTAssertEqual(0, response.totalFlareSkillDp)
    }
    
    func testLessThan30Scores() throws {
        // 20曲のみのデータを準備
        var smallScoreList: [Int32: MusicScore] = [:]
        var smallMusicDataMap: [Int32: MusicData] = [:]
        
        for i in 1...20 {
            var score = MusicScore()
            score.ESP = createScoreData(flareSkill: Int32(i))
            
            var data = MusicData()
            data.Name = "Song \(i)"
            data.SeriesTitle_ = .X3_2ndMix
            
            smallScoreList[Int32(i)] = score
            smallMusicDataMap[Int32(i)] = data
        }
        
        let result = TopFlareSkillProcessor.processTopFlareSkills(playerId: "test", mScoreList: smallScoreList, musicDataMap: smallMusicDataMap)
        let jsonData = result.data(using: .utf8)!
        let response = try JSONDecoder().decode(TopFlareSkillResponse.self, from: jsonData)
        let scores = response.scores
        
        XCTAssertEqual(20, scores.count)
        XCTAssertEqual("test", response.playerId)
        XCTAssertEqual(210, response.totalFlareSkillSp)
        XCTAssertEqual(0, response.totalFlareSkillDp)
    }
    
    func testScoresWithTie() throws {
        // 30位と同じFlareSkillを持つ曲がある場合のテスト
        var tieScoreList: [Int32: MusicScore] = [:]
        var tieMusicDataMap: [Int32: MusicData] = [:]
        
        for i in 1...35 {
            var score = MusicScore()
            score.ESP = createScoreData(flareSkill: Int32(max(i, 30))) // 31-35番目の曲は30位と同じFlareSkill
            
            var data = MusicData()
            data.Name = "Song \(i)"
            data.SeriesTitle_ = .WORLD
            
            tieScoreList[Int32(i)] = score
            tieMusicDataMap[Int32(i)] = data
        }
        
        let result = TopFlareSkillProcessor.processTopFlareSkills(playerId: "test", mScoreList: tieScoreList, musicDataMap: tieMusicDataMap)
        let jsonData = result.data(using: .utf8)!
        let response = try JSONDecoder().decode(TopFlareSkillResponse.self, from: jsonData)
        let scores = response.scores
        
        XCTAssertEqual(35, scores.count)
        XCTAssertEqual("test", response.playerId)
        XCTAssertEqual(915, response.totalFlareSkillSp)
        XCTAssertEqual(0, response.totalFlareSkillDp)
    }
}
