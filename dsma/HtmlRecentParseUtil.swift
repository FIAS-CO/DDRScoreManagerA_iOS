//
//  HtmlRecentParseUtil.swift
//  dsma
//
//  Created by apple on 2024/08/19.
//  Copyright © 2024 LinaNfinE. All rights reserved.
//

import SwiftSoup

func parseRecentHTML(_ src: String, localIds: [String: Int32]) -> [RecentData] {
    var recent = [RecentData]()
    
    do {
        let doc = try SwiftSoup.parse(src)
        let rows = try doc.select("table#data_tbl tr")
        
        for row in rows.dropFirst() { // Skip header row
            if let recentData = parseRow(row, localIds: localIds) {
                recent.append(recentData)
            }
        }
    } catch {
        print("Error parsing HTML: \(error)")
    }
    
    return recent
}

private func parseRow(_ row: Element, localIds: [String: Int32]) -> RecentData? {
    do {
        let cells = try row.select("td")
        if cells.count >= 2 {
            let linkElement = try cells[0].select("a").first()
            if let href = try linkElement?.attr("href") {
                let components = href.components(separatedBy: ["?", "&"])
                var webId: String?
                var style: String?
                var difficulty: String?
                
                for component in components {
                    let parts = component.split(separator: "=")
                    if parts.count == 2 {
                        switch parts[0] {
                        case "index": webId = String(parts[1])
                        case "style": style = String(parts[1])
                        case "difficulty": difficulty = String(parts[1])
                        default: break
                        }
                    }
                }
                
                if let webId = webId, let style = style, let difficulty = difficulty,
                   let id = localIds[webId],
                   let patternType = getPatternType(style: style, difficulty: difficulty) {
                    return RecentData(Id: id, PatternType_: patternType)
                }
            }
        }
    } catch {
        print("Error parsing row: \(error)")
    }
    return nil
}

private func getPatternType(style: String, difficulty: String) -> PatternType? {
    switch (style, difficulty) {
    case ("0", "0"): return .bSP
    case ("0", "1"): return .BSP
    case ("0", "2"): return .DSP
    case ("0", "3"): return .ESP
    case ("0", "4"): return .CSP
    case ("1", "1"): return .BDP
    case ("1", "2"): return .DDP
    case ("1", "3"): return .EDP
    case ("1", "4"): return .CDP
    default: return nil
    }
}

