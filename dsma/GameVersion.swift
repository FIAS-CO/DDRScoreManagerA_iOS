//
//  GameVersion.swift
//  dsma
//
//  Created by apple on 2024/08/22.
//  Copyright © 2024 LinaNfinE. All rights reserved.
//

enum GameVersion: String, CaseIterable {
    case world = "WORLD"
    case a3 = "A3"
    case a20plus = "A20PLUS"
    
    static func fromString(_ string: String) -> GameVersion {
        switch string.lowercased() {
        case "world":
            return .world
        case "a3":
            return .a3
        case "a20plus", "a20 plus", "a20+":
            return .a20plus
        default:
            return .world
        }
    }
}
