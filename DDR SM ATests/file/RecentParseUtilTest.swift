import XCTest
@testable import dsma

class ViewFromGateRecentTests: XCTestCase {
    
    var localIds: [String: Int32]!
    
    override func setUp() {
        super.setUp()
        localIds = [
            "DdIo9DQ0ddDld99DQdiiqbPP06OI91I0": 1,
            "9dD6dlq01qd80loD6OOQb60ql6P6068O": 2,
            "l6d0ibbliQPQDdb1lP18D9qbPDi1698b": 3
        ]
    }
    
    override func tearDown() {
        localIds = nil
        super.tearDown()
    }
    
    func testParseRecentHTML() {
        let htmlContent = """
            <table id="data_tbl" cellspacing="0">
                <tr><th>楽曲名</th><th>スタイル<br>難易度</th><th>ランク</th><th style="min-width:50px;">スコア</th><th class="date">プレー日時</th></tr>
                <tr>
                    <td><img src="/game/ddr/ddrworld/images/binary_jk.html?img=DdIo9DQ0ddDld99DQdiiqbPP06OI91I0&ddrcode=11078354&kind=2" class="jk" width="30">
                        <a href="/game/ddr/ddrworld/playdata/music_detail.html?index=DdIo9DQ0ddDld99DQdiiqbPP06OI91I0&style=0&difficulty=3" class="music_info cboxelement" style="">New Era</a>
                    </td>
                    <td class="diff expert"><div class="style">SINGLE</div><div class="difficulty">EXPERT</div></td>
                    <td class="rank"><img src="/game/ddr/ddrworld/images/playdata/rank_s_aa_p.png"></td>
                    <td class="score">983240</td>
                    <td class="date">2024-08-18 20:50:09</td>
                </tr>
                <tr>
                    <td><img src="/game/ddr/ddrworld/images/binary_jk.html?img=9dD6dlq01qd80loD6OOQb60ql6P6068O&ddrcode=11078354&kind=2" class="jk" width="30">
                        <a href="/game/ddr/ddrworld/playdata/music_detail.html?index=9dD6dlq01qd80loD6OOQb60ql6P6068O&style=0&difficulty=3" class="music_info cboxelement" style="">Destination</a>
                    </td>
                    <td class="diff expert"><div class="style">SINGLE</div><div class="difficulty">EXPERT</div></td>
                    <td class="rank"><img src="/game/ddr/ddrworld/images/playdata/rank_s_aa_p.png"></td>
                    <td class="score">951540</td>
                    <td class="date">2024-08-18 20:42:18</td>
                </tr>
                <tr>
                    <td><img src="/game/ddr/ddrworld/images/binary_jk.html?img=l6d0ibbliQPQDdb1lP18D9qbPDi1698b&ddrcode=11078354&kind=2" class="jk" width="30">
                        <a href="/game/ddr/ddrworld/playdata/music_detail.html?index=l6d0ibbliQPQDdb1lP18D9qbPDi1698b&style=1&difficulty=4" class="music_info cboxelement" style="">ÆTHER</a>
                    </td>
                    <td class="diff challeange"><div class="style">DOUBLE</div><div class="difficulty">CHALLENGE</div></td>
                    <td class="rank"><img src="/game/ddr/ddrworld/images/playdata/rank_s_e.png"></td>
                    <td class="score">940980</td>
                    <td class="date">2024-08-18 20:38:50</td>
                </tr>
            </table>
            """
        
        let result = parseRecentHTML(htmlContent, localIds: localIds)
        
        XCTAssertEqual(result.count, 3, "3つのRecentDataオブジェクトが作成されるはずです")
        
        XCTAssertEqual(result[0].Id, 1)
        XCTAssertEqual(result[0].PatternType_, .ESP)
        
        XCTAssertEqual(result[1].Id, 2)
        XCTAssertEqual(result[1].PatternType_, .ESP)
        
        XCTAssertEqual(result[2].Id, 3)
        XCTAssertEqual(result[2].PatternType_, .CDP)
    }
    
    func testParseRecentHTMLWithEmptyData() {
        let emptyHtml = "<table id='data_tbl'><tr><th>Header</th></tr></table>"
        
        let result = parseRecentHTML(emptyHtml, localIds: localIds)
        
        XCTAssertTrue(result.isEmpty, "データが空の場合、空の配列を返すはずです")
    }
    
    func testParseRecentHTMLWithInvalidData() {
        let invalidHtml = "<table id='data_tbl'><tr><td>Invalid Data</td></tr></table>"
        
        let result = parseRecentHTML(invalidHtml, localIds: localIds)
        
        XCTAssertTrue(result.isEmpty, "無効なデータの場合、空の配列を返すはずです")
    }
}
