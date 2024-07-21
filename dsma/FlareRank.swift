//
//  FlareRank.swift
//  dsma
//
//  Created by apple on 2024/07/11.
//  Copyright © 2024 LinaNfinE. All rights reserved.
//

enum FlareRank: Int, CaseIterable {
    case rank10 = 10
    case rank9 = 9
    case rank8 = 8
    case rank7 = 7
    case rank6 = 6
    case rank5 = 5
    case rank4 = 4
    case rank3 = 3
    case rank2 = 2
    case rank1 = 1
    case rank0 = 0
    case noRank = -1
    
    var description: String {
        switch self {
        case .noRank: return "ー"
        case .rank0: return "0"
        case .rank1: return "Ⅰ"
        case .rank2: return "Ⅱ"
        case .rank3: return "Ⅲ"
        case .rank4: return "Ⅳ"
        case .rank5: return "Ⅴ"
        case .rank6: return "Ⅵ"
        case .rank7: return "Ⅶ"
        case .rank8: return "Ⅷ"
        case .rank9: return "Ⅸ"
        case .rank10: return "EX"
        }
    }
    
    var displayText: String {
        switch self {
        case .noRank:
            return "No Rank"
        default:
            return "Rank \(self.description)"
        }
    }
}
