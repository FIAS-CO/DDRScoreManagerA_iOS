//
//  MusicSortType.swift
//  dsm
//
//  Created by LinaNfinE on 6/9/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

enum MusicSortType: String {
    case None = "None"
    case Recent = "Recent"
    case MusicName = "MusicName"
    case Score = "Score"
    case Rank = "Rank"
    case FullComboType = "FullComboType"
    case ComboCount = "ComboCount"
    case PlayCount = "PlayCount"
    case ClearCount = "ClearCount"
    case Difficulty = "Difficulty"
    case Pattern = "Pattern"
    case SPDP = "SPDP"
    case ID = "ID"
    case RivalScore = "RivalScore"
    case RivalRank = "RivalRank"
    case RivalFullComboType = "RivalFullComboType"
    case RivalComboCount = "RivalComboCount"
    //case RivalPlayCount = "RivalPlayCount"
    //case RivalClearCount = "RivalClearCount"
    case RivalScoreDifference = "RivalScoreDifference"
    case RivalScoreDifferenceAbs = "RivalScoreDifferenceAbs"
    case BpmMax = "BpmMax"
    case BpmMin = "BpmMin"
    case BpmAve = "BpmAve"
    case SeriesTitle = "SeriesTitle"
}

struct MusicSortTypeLister {
    
    static func getString(_ no: Int) -> (String) {
        switch no {
        //case 0 : return NSLocalizedString("None", comment: "MusicSortTypeLister")
        //case 1 : return NSLocalizedString("Recent", comment: "MusicSortTypeLister")
        case 0 : return NSLocalizedString("ABC", comment: "MusicSortTypeLister")
        case 1 : return NSLocalizedString("Score", comment: "MusicSortTypeLister")
        case 2 : return NSLocalizedString("Rank", comment: "MusicSortTypeLister")
        case 3 : return NSLocalizedString("Full Combo Type", comment: "MusicSortTypeLister")
        case 17 : return NSLocalizedString("Combo Count", comment: "MusicSortTypeLister")
        case 18 : return NSLocalizedString("Play Count", comment: "MusicSortTypeLister")
        case 19 : return NSLocalizedString("Clear Count", comment: "MusicSortTypeLister")
        case 4 : return NSLocalizedString("Difficulty", comment: "MusicSortTypeLister")
        case 5 : return NSLocalizedString("Pattern", comment: "MusicSortTypeLister")
        case 6 : return NSLocalizedString("SP/DP", comment: "MusicSortTypeLister")
        case 7 : return NSLocalizedString("ID", comment: "MusicSortTypeLister")
        case 8 : return NSLocalizedString("Rival Score", comment: "MusicSortTypeLister")
        case 9 : return NSLocalizedString("Rival Rank", comment: "MusicSortTypeLister")
        case 10 : return NSLocalizedString("Rival Full Combo Type", comment: "MusicSortTypeLister")
        case 20 : return NSLocalizedString("Rival Combo Count", comment: "MusicSortTypeLister")
        //case 21 : return NSLocalizedString("Rival Play Count", comment: "MusicSortTypeLister")
        //case 22 : return NSLocalizedString("Rival Clear Count", comment: "MusicSortTypeLister")
        case 11 : return NSLocalizedString("Rival Score Difference", comment: "MusicSortTypeLister")
        case 12 : return NSLocalizedString("Rival Score DifferenceAbs", comment: "MusicSortTypeLister")
        case 13 : return NSLocalizedString("Max BPM", comment: "MusicSortTypeLister")
        case 14 : return NSLocalizedString("Min BPM", comment: "MusicSortTypeLister")
        case 15 : return NSLocalizedString("Average BPM", comment: "MusicSortTypeLister")
        case 16 : return NSLocalizedString("Series Title", comment: "MusicSortTypeLister")
        default:
            return ""
        }
    }
    
    static func getCount() -> (Int) {
        return 21
    }
    
    static func getSortTypeNum(_ sorttype: MusicSortType) -> (Int32)
    {
        return Int32(
            sorttype == MusicSortType.MusicName ? 0 :
                sorttype == MusicSortType.Score ? 1 :
                sorttype == MusicSortType.Rank ? 2 :
                sorttype == MusicSortType.FullComboType ? 3 :
                sorttype == MusicSortType.Difficulty ? 4 :
                sorttype == MusicSortType.Pattern ? 5 :
                sorttype == MusicSortType.SPDP ? 6 :
                sorttype == MusicSortType.ID ? 7 :
                sorttype == MusicSortType.RivalScore ? 8 :
                sorttype == MusicSortType.RivalRank ? 9 :
                sorttype == MusicSortType.RivalFullComboType ? 10 :
                sorttype == MusicSortType.RivalScoreDifference ? 11 :
                sorttype == MusicSortType.RivalScoreDifferenceAbs ? 12 :
                sorttype == MusicSortType.BpmMax ? 13 :
                sorttype == MusicSortType.BpmMin ? 14 :
                sorttype == MusicSortType.BpmAve ? 15 :
                sorttype == MusicSortType.SeriesTitle ? 16 :
                sorttype == MusicSortType.ComboCount ? 17 :
                sorttype == MusicSortType.PlayCount ? 18 :
                sorttype == MusicSortType.ClearCount ? 19 :
                sorttype == MusicSortType.RivalComboCount ? 20 :
                //sorttype == MusicSortType.RivalPlayCount ? 21 :
                //sorttype == MusicSortType.RivalClearCount ? 22 :
            0);
    }
    
    static func getSortType(_ typenum: Int32) -> (MusicSortType)
    {
        return
            typenum == 0 ? MusicSortType.MusicName :
                typenum == 1 ? MusicSortType.Score :
                typenum == 2 ? MusicSortType.Rank :
                typenum == 3 ? MusicSortType.FullComboType :
                typenum == 4 ? MusicSortType.Difficulty :
                typenum == 5 ? MusicSortType.Pattern :
                typenum == 6 ? MusicSortType.SPDP :
                typenum == 7 ? MusicSortType.ID :
                typenum == 8 ? MusicSortType.RivalScore :
                typenum == 9 ? MusicSortType.RivalRank :
                typenum == 10 ? MusicSortType.RivalFullComboType :
                typenum == 11 ? MusicSortType.RivalScoreDifference :
                typenum == 12 ? MusicSortType.RivalScoreDifferenceAbs :
                typenum == 13 ? MusicSortType.BpmMax :
                typenum == 14 ? MusicSortType.BpmMin :
                typenum == 15 ? MusicSortType.BpmAve :
                typenum == 16 ? MusicSortType.SeriesTitle :
                typenum == 17 ? MusicSortType.ComboCount :
                typenum == 18 ? MusicSortType.PlayCount :
                typenum == 19 ? MusicSortType.ClearCount :
                typenum == 20 ? MusicSortType.RivalComboCount :
                //typenum == 21 ? MusicSortType.RivalPlayCount :
                //typenum == 22 ? MusicSortType.RivalClearCount :
                MusicSortType.MusicName;
    }
    
}
