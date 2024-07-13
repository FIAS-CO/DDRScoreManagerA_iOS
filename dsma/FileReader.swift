//
//  FileReader.swift
//  dsm
//
//  Created by LinaNfinE on 6/8/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit

struct FileReader{
    
    static func saveLastAppVersion() {
        let infoDictionary = Bundle.main.infoDictionary! as Dictionary
        let appVersion = (infoDictionary["CFBundleShortVersionString"]! as! String) + "." + (infoDictionary["CFBundleVersion"]! as! String)
        let sfm: SettingFileManager = SettingFileManager(fileName: "VersionInfo.txt", force: true)
        sfm.putString("AppVersion", value: appVersion)
        sfm.save()
    }
    
    static func readLastAppVersion() -> (String) {
        if let sfm: SettingFileManager = SettingFileManager(fileName: "VersionInfo.txt") {
            return sfm.getString("AppVersion", def: "")
        }
        return ""
    }
    
    static func setBooted() -> (Bool) {
        let sfm: SettingFileManager = SettingFileManager(fileName: "VersionInfo.txt", force: true)
        let firstBoot = sfm.getBool("FirstBoot", def: true)
        sfm.putBool("FirstBoot", value: false)
        sfm.save()
        return firstBoot
    }
    
    static func checkAdTapExpired() -> (Bool) {
        let date = Date()
        if Int(NSInteger(date.timeIntervalSince1970 - readLastAdTapTime().timeIntervalSince1970)) > 86400 {
            return true
        }
        return false
    }
    
    static func readLastAdTapTime() -> (Date) {
        if let sfm: SettingFileManager = SettingFileManager(fileName: "AdInfo.txt") {
            if let tm = sfm.getInt32("LastTapTime") {
                return Date(timeIntervalSince1970: TimeInterval(tm))
            }
        }
        return Date(timeIntervalSince1970: TimeInterval(0))
    }
    
    static func saveLastAdTapTime() {
        let sfm: SettingFileManager = SettingFileManager(fileName: "AdInfo.txt", force: true)
        let date = Date()
        sfm.putInt("LastTapTime", value: Int(NSInteger(date.timeIntervalSince1970)))
        sfm.save()
    }
    
    static func readCopyFormats() -> ([String]) {
        var ret: [String] = [
            "%t% %p:b:B:D:E:C%%y:SP:DP% %s0,%",
            "%t% %p:b:B:D:E:C%%y:SP:DP% %l:AAA:AA+:AA:AA-:A+:A:A-:B+:B:B-:C+:C:C-:D+:D:E:-%",
            "%t% %p:b:B:D:E:C%%y:SP:DP% (%d0%) %l:AAA:AA+:AA:AA-:A+:A:A-:B+:B:B-:C+:C:C-:D+:D:E:-% %s0,%/%c0% %f:MFC:PFC:FC:GFC:Life4:NoFC% (%e0%/%a0%)",
        ]
        if let sfm: SettingFileManager = SettingFileManager(fileName: "CopyFormats.txt") {
            if let fmt = sfm.getString("Format0") {
                ret[0] = fmt
            }
            if let fmt = sfm.getString("Format1") {
                ret[1] = fmt
            }
            if let fmt = sfm.getString("Format2") {
                ret[2] = fmt
            }
        }
        return ret
    }
    
    static func saveCopyFormats(_ formats: [String]) {
        let sfm: SettingFileManager = SettingFileManager(fileName: "CopyFormats.txt", force: true)
        sfm.putString("Format0", value: formats[0])
        sfm.putString("Format1", value: formats[1])
        sfm.putString("Format2", value: formats[2])
        sfm.save()
    }
    
    static func savePreferences (_ pref: Preferences) {
        let sfm: SettingFileManager = SettingFileManager(fileName: "Preferences.txt", force: true)
        sfm.putBool("VisibleItems_MaxCombo", value: pref.VisibleItems_MaxCombo)
        sfm.putBool("VisibleItems_Score", value: pref.VisibleItems_Score)
        sfm.putBool("VisibleItems_DanceLevel", value: pref.VisibleItems_DanceLevel)
        sfm.putBool("VisibleItems_PlayCount", value: pref.VisibleItems_PlayCount)
        sfm.putBool("VisibleItems_ClearCount", value: pref.VisibleItems_ClearCount)
        sfm.putBool("VisibleItems_FlareRank", value: pref.VisibleItems_FlareRank)
        sfm.putBool("VisibleItems_FlareSkill", value: pref.VisibleItems_FlareSkill)
        
        sfm.putBool("Gate_LoadFromA3", value: pref.Gate_LoadFromA3)
        sfm.putInt32("Gate_SetPfcScore", value: pref.Gate_SetPfcScore)
        sfm.putBool("Gate_OverWriteLife4", value: pref.Gate_OverWriteLife4)
        sfm.putBool("Gate_OverWriteLowerScores", value: pref.Gate_OverWriteLowerScores)
        sfm.putBool("Gate_OverWriteFullCombo", value: pref.Gate_OverWriteFullCombo)
        sfm.save()
    }
    
    static func readPreferences() -> (Preferences) {
        var pref: Preferences = Preferences()
        if let sfm: SettingFileManager = SettingFileManager(fileName: "Preferences.txt") {
            pref.VisibleItems_MaxCombo = sfm.getBool("VisibleItems_MaxCombo", def: false)
            pref.VisibleItems_Score = sfm.getBool("VisibleItems_Score", def: true)
            pref.VisibleItems_DanceLevel = sfm.getBool("VisibleItems_DanceLevel", def: true)
            pref.VisibleItems_PlayCount = sfm.getBool("VisibleItems_PlayCount", def: false)
            pref.VisibleItems_ClearCount = sfm.getBool("VisibleItems_ClearCount", def: false)
            pref.VisibleItems_FlareRank = true //sfm.getBool("VisibleItems_FlareRank", def: false)
            pref.VisibleItems_FlareSkill = false //sfm.getBool("VisibleItems_FlareSkill", def: false)
            
            pref.Gate_LoadFromA3 = sfm.getBool("Gate_LoadFromA3", def: true)
            pref.Gate_SetPfcScore = sfm.getInt32("Gate_SetPfcScore", def: 999990)
            pref.Gate_OverWriteLife4 = sfm.getBool("Gate_OverWriteLife4", def: false)
            pref.Gate_OverWriteLowerScores = sfm.getBool("Gate_OverWriteLowerScores", def: true)
            pref.Gate_OverWriteFullCombo = sfm.getBool("Gate_OverWriteFullCombo", def: true)
        }
        return pref
    }
    
    static func savePlayerStatus (_ data: PlayerStatus) {
        let sfm: SettingFileManager = SettingFileManager(fileName: "PlayerStatus.txt", force: true)
        sfm.putInt32("SingleMgrStream", value: data.SingleMgrStream)
        sfm.putInt32("SingleMgrVoltage", value: data.SingleMgrVoltage)
        sfm.putInt32("SingleMgrAir", value: data.SingleMgrAir)
        sfm.putInt32("SingleMgrFreeze", value: data.SingleMgrFreeze)
        sfm.putInt32("SingleMgrChaos", value: data.SingleMgrChaos)
        sfm.putInt32("DoubleMgrStream", value: data.DoubleMgrStream)
        sfm.putInt32("DoubleMgrVoltage", value: data.DoubleMgrVoltage)
        sfm.putInt32("DoubleMgrAir", value: data.DoubleMgrAir)
        sfm.putInt32("DoubleMgrFreeze", value: data.DoubleMgrFreeze)
        sfm.putInt32("DoubleMgrChaos", value: data.DoubleMgrChaos)
        sfm.putString("DancerName", value: data.DancerName)
        sfm.putString("DdrCode", value: data.DdrCode)
        sfm.putString("Todofuken", value: data.Todofuken)
        sfm.putInt32("EnjoyLevel", value: data.EnjoyLevel)
        sfm.putInt32("EnjoyLevelNextExp", value: data.EnjoyLevelNextExp)
        sfm.putInt32("PlayCount", value: data.PlayCount)
        sfm.putString("LastPlay", value: data.LastPlay)
        sfm.putString("SingleShougou", value: data.SingleShougou)
        sfm.putInt32("SinglePlayCount", value: data.SinglePlayCount)
        sfm.putString("SingleLastPlay", value: data.SingleLastPlay)
        sfm.putString("DoubleShougou", value: data.DoubleShougou)
        sfm.putInt32("DoublePlayCount", value: data.DoublePlayCount)
        sfm.putString("DoubleLastPlay", value: data.DoubleLastPlay)
        sfm.save()
    }
    
    static func readPlayerStatus() -> (PlayerStatus) {
        var ret: PlayerStatus = PlayerStatus()
        if let sfm: SettingFileManager = SettingFileManager(fileName: "PlayerStatus.txt") {
            ret.SingleMgrStream = sfm.getInt32("SingleMgrStream", def: 0)
            ret.SingleMgrVoltage = sfm.getInt32("SingleMgrVoltage", def: 0)
            ret.SingleMgrAir = sfm.getInt32("SingleMgrAir", def: 0)
            ret.SingleMgrFreeze = sfm.getInt32("SingleMgrFreeze", def: 0)
            ret.SingleMgrChaos = sfm.getInt32("SingleMgrChaos", def: 0)
            ret.DoubleMgrStream = sfm.getInt32("DoubleMgrStream", def: 0)
            ret.DoubleMgrVoltage = sfm.getInt32("DoubleMgrVoltage", def: 0)
            ret.DoubleMgrAir = sfm.getInt32("DoubleMgrAir", def: 0)
            ret.DoubleMgrFreeze = sfm.getInt32("DoubleMgrFreeze", def: 0)
            ret.DoubleMgrChaos = sfm.getInt32("DoubleMgrChaos", def: 0)
            ret.DancerName = sfm.getString("DancerName", def: "")
            ret.DdrCode = sfm.getString("DdrCode", def: "")
            ret.Todofuken = sfm.getString("Todofuken", def: "")
            ret.EnjoyLevel = sfm.getInt32("EnjoyLevel", def: 0)
            ret.EnjoyLevelNextExp = sfm.getInt32("EnjoyLevelNextExp", def: 0)
            ret.PlayCount = sfm.getInt32("PlayCount", def: 0)
            ret.LastPlay = sfm.getString("LastPlay", def: "")
            ret.SingleShougou = sfm.getString("SingleShougou", def: "")
            ret.SinglePlayCount = sfm.getInt32("SinglePlayCount", def: 0)
            ret.SingleLastPlay = sfm.getString("SingleLastPlay", def: "")
            ret.DoubleShougou = sfm.getString("DoubleShougou", def: "")
            ret.DoublePlayCount = sfm.getInt32("DoublePlayCount", def: 0)
            ret.DoubleLastPlay = sfm.getString("DoubleLastPlay", def: "")
        }
        return ret
    }
    
    static func saveDdrSaAuthentication (_ ddrCode: String, encryptedPassword: String) {
        let sfm: SettingFileManager = SettingFileManager(fileName: "DdrSaAuthentication.txt", force: true)
        sfm.putString("DdrCode", value: ddrCode)
        sfm.putString("EncryptedPassword", value: encryptedPassword)
        sfm.save()
    }
    
    static func readDdrSaAuthentication() -> ([String]?) {
        if let sfm: SettingFileManager = SettingFileManager(fileName: "DdrSaAuthentication.txt") {
            var ret: [String] = [String]()
            ret.append(sfm.getString("DdrCode", def: ""))
            ret.append(sfm.getString("EncryptedPassword", def: ""))
            if ret[0] == "" || ret[1] == "" {
                return nil
            }
            return ret
        }
        return nil
    }
    
    static func readWebMusicIds() -> ([Int32 : WebMusicId]) {
        var ret: [Int32 : WebMusicId] = [Int32 : WebMusicId]();
        let libraryDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        if let dataNS = try? NSString(contentsOfFile: (libraryDirPath as NSString).appendingPathComponent("WebMusicIds.txt"), encoding: String.Encoding.utf8.rawValue) {
            
            let data: String = dataNS as String
            
            data.enumerateLines{
                line, stop in
                let sp = line.components(separatedBy: "\t")
                var id: Int32 = -1
                let wmi = WebMusicId()
                for (index, spd) in sp.enumerated() {
                    switch index{
                    case 0:
                        id = Int32(Int(spd)!)
                    case 1:
                        wmi.idOnWebPage = spd
                    case 2:
                        wmi.titleOnWebPage = spd
                    case 3:
                        wmi.isDeleted = spd != "0"
                    default:
                        break
                    }
                }
                ret[id] = wmi
            }
        }
        
        return ret;
    }
    
    static func readWebTitleToLocalIdList() -> ([String : Int32]) {
        var ret: [String : Int32] = [String : Int32]();
        let libraryDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        if let dataNS = try? NSString(contentsOfFile: (libraryDirPath as NSString).appendingPathComponent("WebMusicIds.txt"), encoding: String.Encoding.utf8.rawValue) {
            
            let data: String = dataNS as String
            
            data.enumerateLines{
                line, stop in
                let sp = line.components(separatedBy: "\t")
                var id: Int32 = -1
                var title = ""
                for (index, spd) in sp.enumerated() {
                    switch index{
                    case 0:
                        id = Int32(Int(spd)!)
                    case 1:
                        break
                    case 2:
                        title = spd
                    default:
                        break
                    }
                }
                ret[title] = id
            }
        }
        
        return ret;
    }
    
    static func readWebIdToLocalIdList() -> ([String : Int32]) {
        var ret: [String : Int32] = [String : Int32]();
        let libraryDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        if let dataNS = try? NSString(contentsOfFile: (libraryDirPath as NSString).appendingPathComponent("WebMusicIds.txt"), encoding: String.Encoding.utf8.rawValue) {
            
            let data: String = dataNS as String
            
            data.enumerateLines{
                line, stop in
                let sp = line.components(separatedBy: "\t")
                var id: Int32 = -1
                var idWeb: String = ""
                for (index, spd) in sp.enumerated() {
                    switch index{
                    case 0:
                        id = Int32(Int(spd)!)
                    case 1:
                        idWeb = spd
                    case 2:
                        break
                    default:
                        break
                    }
                }
                ret[idWeb] = id
            }
        }
        
        return ret;
    }
    
    static func readShockArrowExists() -> ([Int32 : BooleanPair]) {
        var ret: [Int32 : BooleanPair] = [:]
        let libraryDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        if let dataNS = try? NSString(contentsOfFile: (libraryDirPath as NSString).appendingPathComponent("ShockArrowExists.txt"), encoding: String.Encoding.utf8.rawValue) {
            
            let data: String = dataNS as String
            
            data.enumerateLines{
                line, stop in
                let sp = line.components(separatedBy: "\t")
                var id: Int32 = -1
                var se: BooleanPair = BooleanPair()
                for (index, spd) in sp.enumerated() {
                    switch index{
                    case 0:
                        id = Int32(Int(spd)!)
                    case 1:
                        if (spd as NSString).length < 2 {
                            break
                        }
                        se.b1 = spd[spd.startIndex..<spd.index(spd.startIndex, offsetBy: 1)] == "1"
                        se.b2 = spd[spd.index(spd.startIndex, offsetBy: 1)...] == "1"
                    default:
                        break
                    }
                }
                ret[id] = se
            }
        }
        return ret
    }
    
    static func readMusicList() ->([Int32 : MusicData]){
        var ret: [Int32 : MusicData] = [:]
        let shockArrows: [Int32 : BooleanPair] = readShockArrowExists()
        
        let libraryDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        if let dataNS = try? NSString(contentsOfFile: (libraryDirPath as NSString).appendingPathComponent("MusicNames.txt"), encoding: String.Encoding.utf8.rawValue) {
            
            let data: String = dataNS as String
            
            data.enumerateLines{
                line, stop in
                let sp = line.components(separatedBy: "\t")
                var md: MusicData = MusicData()
                md.ShockArrowExists = shockArrows
                for (index, spd) in sp.enumerated() {
                    switch index{
                    case 0:
                        md.Id = Int32(Int(spd)!)
                    case 1:
                        md.Name = spd
                    case 2:
                        md.Ruby = spd
                    case 3:
                        md.SeriesTitle_ = (
                            spd=="1st" ? SeriesTitle._1st :
                                spd=="2nd" ? SeriesTitle._2nd :
                                spd=="3rd" ? SeriesTitle._3rd :
                                spd=="4th" ? SeriesTitle._4th :
                                spd=="5th" ? SeriesTitle._5th :
                                spd=="MAX" ? SeriesTitle.MAX :
                                spd=="MAX2" ? SeriesTitle.MAX2 :
                                spd=="EXTREME" ? SeriesTitle.EXTREME :
                                spd=="Super Nova" ? SeriesTitle.SuperNOVA :
                                spd=="Super Nova2" ? SeriesTitle.SuperNOVA2 :
                                spd=="X" ? SeriesTitle.X :
                                spd=="X2" ? SeriesTitle.X2 :
                                spd=="X3" ? SeriesTitle.X3 :
                                spd=="X3(2nd Mix)" ? SeriesTitle.X3_2ndMix :
                                spd=="2013" ? SeriesTitle._2013 :
                                spd=="2014" ? SeriesTitle._2014 :
                                spd=="A" ? SeriesTitle.A :
                                spd=="A20" ? SeriesTitle.A20 :
                                spd=="A20 PLUS" ? SeriesTitle.A20PLUS :
                                spd=="A3" ? SeriesTitle.A3 :
                                SeriesTitle.WORLD
                        );
                    case 4:
                        md.MinBPM = "?"==spd ? 0 : Int32(Int(spd)!)
                    case 5:
                        md.MaxBPM = "?"==spd ? 0 : Int32(Int(spd)!)
                    case 6:
                        md.Difficulty_bSP = "?"==spd ? -1 : Int32(Int(spd)!)
                    case 7:
                        md.Difficulty_BSP = "?"==spd ? -1 : Int32(Int(spd)!)
                    case 8:
                        md.Difficulty_DSP = "?"==spd ? -1 : Int32(Int(spd)!)
                    case 9:
                        md.Difficulty_ESP = "?"==spd ? -1 : Int32(Int(spd)!)
                    case 10:
                        md.Difficulty_CSP = "?"==spd ? -1 : Int32(Int(spd)!)
                    case 11:
                        md.Difficulty_BDP = "?"==spd ? -1 : Int32(Int(spd)!)
                    case 12:
                        md.Difficulty_DDP = "?"==spd ? -1 : Int32(Int(spd)!)
                    case 13:
                        md.Difficulty_EDP = "?"==spd ? -1 : Int32(Int(spd)!)
                    case 14:
                        md.Difficulty_CDP = "?"==spd ? -1 : Int32(Int(spd)!)
                    default:
                        break
                    }
                }
                ret[md.Id] = md;
            }
        }
        
        return ret
    }
    
    static func readRecentList() -> ([RecentData]) {
        var ret: [RecentData] = []
        
        let libraryDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        if let dataNS = try? NSString(contentsOfFile: (libraryDirPath as NSString).appendingPathComponent("Recent.txt"), encoding: String.Encoding.utf8.rawValue) {
            
            let data: String = dataNS as String
            
            data.enumerateLines{
                line, stop in
                let sp = line.components(separatedBy: "\t")
                ret.append(RecentData(Id: Int32(Int(sp[0])!), PatternType_: PatternTypeLister.getPatternType(Int32(Int(sp[1])!))))
            }
        }
        
        
        return ret
    }
    
    static func saveRecentList(_ list: [RecentData]) {
        let libraryDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        let filePath: String = (libraryDirPath as NSString).appendingPathComponent("Recent.txt")
        
        var wr: String = ""
        for data in list {
            let str: String = data.Id.description + "\t" + PatternTypeLister.getPatternTypeNum(data.PatternType_).description + "\n";
            wr = wr + str
        }
        do {
            try wr.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        } catch _ {
        }
    }
    
    static func readRivalList() -> ([RivalData]) {
        var ret: [RivalData] = []
        
        let libraryDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        if let dataNS = try? NSString(contentsOfFile: (libraryDirPath as NSString).appendingPathComponent("RivalList.txt"), encoding: String.Encoding.utf8.rawValue) {
            
            let data: String = dataNS as String
            
            data.enumerateLines{
                line, stop in
                let sp = line.components(separatedBy: "\t")
                ret.append(RivalData(Id: sp[0], Name: sp[1]))
            }
        }
        
        
        if ret.count < 1 {
            ret.append(RivalData(Id: "",Name: ""))
            ret.append(RivalData(Id: "00000000",Name: "DDR2014"))
        }
        
        ret[0] = RivalData(Id: "", Name: "")
        ret[1] = RivalData(Id: "00000000", Name: "DDR2014")
        
        return ret
    }
    
    static func saveRivalList(_ list: [RivalData]) {
        let libraryDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        let filePath: String = (libraryDirPath as NSString).appendingPathComponent("RivalList.txt")
        
        var wr: String = ""
        for rival in list {
            let str: String = rival.Id + "\t" + rival.Name + "\n";
            wr = wr + str
        }
        do {
            try wr.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        } catch _ {
        }
    }
    
    static func readActiveRivalNo() -> (Int) {
        if let sfm: SettingFileManager = SettingFileManager(fileName: "RivalSettings.txt") {
            return sfm.getInt("ActiveRivalNo", def: 0)
        }
        return 0
    }
    
    static func saveActiveRivalNo(_ no: Int) {
        let sfm: SettingFileManager = SettingFileManager(fileName: "RivalSettings.txt", force: true)
        sfm.putInt("ActiveRivalNo", value: no)
        sfm.save()
    }
    
    static func scoreFromScoreDb(_ scoreDbText: String) ->([Int32 : MusicScore]){
        var ret: [Int32 : MusicScore] = [:]
        
        
        let data: String = scoreDbText
        
        data.enumerateLines{
            line, stop in
            let sp = line.components(separatedBy: "\t")
            if sp.count < 37 {
                return
            }
            var ms: MusicScore = MusicScore()
            var id: Int32 = 0
            for (index, spd) in sp.enumerated() {
                switch index{
                case 0:
                    id = Int32(Int(spd)!)
                case 1:
                    ms.bSP.Rank =
                    spd == "AAA" ? MusicRank.AAA :
                    spd == "AA+" ? MusicRank.AAp :
                    spd == "AA" ? MusicRank.AA :
                    spd == "AA-" ? MusicRank.AAm :
                    spd == "A+" ? MusicRank.Ap :
                    spd == "A" ? MusicRank.A :
                    spd == "A-" ? MusicRank.Am :
                    spd == "B+" ? MusicRank.Bp :
                    spd == "B" ? MusicRank.B :
                    spd == "B-" ? MusicRank.Bm :
                    spd == "C+" ? MusicRank.Cp :
                    spd == "C" ? MusicRank.C :
                    spd == "C-" ? MusicRank.Cm :
                    spd == "D+" ? MusicRank.Dp :
                    spd == "D" ? MusicRank.D :
                    spd == "E" ? MusicRank.E :
                    MusicRank.Noplay;
                case 2:
                    ms.bSP.Score = Int32(Int(spd)!);
                case 3:
                    ms.bSP.FullComboType_ =
                    spd == "MerverousFullCombo" ? FullComboType.MarvelousFullCombo :
                    spd == "PerfectFullCombo" ? FullComboType.PerfectFullCombo :
                    spd == "FullCombo" ? FullComboType.FullCombo :
                    spd == "GoodFullCombo" ? FullComboType.GoodFullCombo :
                    spd == "Life4" ? FullComboType.Life4 :
                    FullComboType.None;
                case 4:
                    ms.bSP.MaxCombo = Int32(Int(spd)!);
                case 5:
                    ms.BSP.Rank =
                    spd == "AAA" ? MusicRank.AAA :
                    spd == "AA+" ? MusicRank.AAp :
                    spd == "AA" ? MusicRank.AA :
                    spd == "AA-" ? MusicRank.AAm :
                    spd == "A+" ? MusicRank.Ap :
                    spd == "A" ? MusicRank.A :
                    spd == "A-" ? MusicRank.Am :
                    spd == "B+" ? MusicRank.Bp :
                    spd == "B" ? MusicRank.B :
                    spd == "B-" ? MusicRank.Bm :
                    spd == "C+" ? MusicRank.Cp :
                    spd == "C" ? MusicRank.C :
                    spd == "C-" ? MusicRank.Cm :
                    spd == "D+" ? MusicRank.Dp :
                    spd == "D" ? MusicRank.D :
                    spd == "E" ? MusicRank.E :
                    MusicRank.Noplay;
                case 6:
                    ms.BSP.Score = Int32(Int(spd)!);
                case 7:
                    ms.BSP.FullComboType_ =
                    spd == "MerverousFullCombo" ? FullComboType.MarvelousFullCombo :
                    spd == "PerfectFullCombo" ? FullComboType.PerfectFullCombo :
                    spd == "FullCombo" ? FullComboType.FullCombo :
                    spd == "GoodFullCombo" ? FullComboType.GoodFullCombo :
                    spd == "Life4" ? FullComboType.Life4 :
                    FullComboType.None;
                case 8:
                    ms.BSP.MaxCombo = Int32(Int(spd)!);
                case 9:
                    ms.DSP.Rank =
                    spd == "AAA" ? MusicRank.AAA :
                    spd == "AA+" ? MusicRank.AAp :
                    spd == "AA" ? MusicRank.AA :
                    spd == "AA-" ? MusicRank.AAm :
                    spd == "A+" ? MusicRank.Ap :
                    spd == "A" ? MusicRank.A :
                    spd == "A-" ? MusicRank.Am :
                    spd == "B+" ? MusicRank.Bp :
                    spd == "B" ? MusicRank.B :
                    spd == "B-" ? MusicRank.Bm :
                    spd == "C+" ? MusicRank.Cp :
                    spd == "C" ? MusicRank.C :
                    spd == "C-" ? MusicRank.Cm :
                    spd == "D+" ? MusicRank.Dp :
                    spd == "D" ? MusicRank.D :
                    spd == "E" ? MusicRank.E :
                    MusicRank.Noplay;
                case 10:
                    ms.DSP.Score = Int32(Int(spd)!);
                case 11:
                    ms.DSP.FullComboType_ =
                    spd == "MerverousFullCombo" ? FullComboType.MarvelousFullCombo :
                    spd == "PerfectFullCombo" ? FullComboType.PerfectFullCombo :
                    spd == "FullCombo" ? FullComboType.FullCombo :
                    spd == "GoodFullCombo" ? FullComboType.GoodFullCombo :
                    spd == "Life4" ? FullComboType.Life4 :
                    FullComboType.None;
                case 12:
                    ms.DSP.MaxCombo = Int32(Int(spd)!);
                case 13:
                    ms.ESP.Rank =
                    spd == "AAA" ? MusicRank.AAA :
                    spd == "AA+" ? MusicRank.AAp :
                    spd == "AA" ? MusicRank.AA :
                    spd == "AA-" ? MusicRank.AAm :
                    spd == "A+" ? MusicRank.Ap :
                    spd == "A" ? MusicRank.A :
                    spd == "A-" ? MusicRank.Am :
                    spd == "B+" ? MusicRank.Bp :
                    spd == "B" ? MusicRank.B :
                    spd == "B-" ? MusicRank.Bm :
                    spd == "C+" ? MusicRank.Cp :
                    spd == "C" ? MusicRank.C :
                    spd == "C-" ? MusicRank.Cm :
                    spd == "D+" ? MusicRank.Dp :
                    spd == "D" ? MusicRank.D :
                    spd == "E" ? MusicRank.E :
                    MusicRank.Noplay;
                case 14:
                    ms.ESP.Score = Int32(Int(spd)!);
                case 15:
                    ms.ESP.FullComboType_ =
                    spd == "MerverousFullCombo" ? FullComboType.MarvelousFullCombo :
                    spd == "PerfectFullCombo" ? FullComboType.PerfectFullCombo :
                    spd == "FullCombo" ? FullComboType.FullCombo :
                    spd == "GoodFullCombo" ? FullComboType.GoodFullCombo :
                    spd == "Life4" ? FullComboType.Life4 :
                    FullComboType.None;
                case 16:
                    ms.ESP.MaxCombo = Int32(Int(spd)!);
                case 17:
                    ms.CSP.Rank =
                    spd == "AAA" ? MusicRank.AAA :
                    spd == "AA+" ? MusicRank.AAp :
                    spd == "AA" ? MusicRank.AA :
                    spd == "AA-" ? MusicRank.AAm :
                    spd == "A+" ? MusicRank.Ap :
                    spd == "A" ? MusicRank.A :
                    spd == "A-" ? MusicRank.Am :
                    spd == "B+" ? MusicRank.Bp :
                    spd == "B" ? MusicRank.B :
                    spd == "B-" ? MusicRank.Bm :
                    spd == "C+" ? MusicRank.Cp :
                    spd == "C" ? MusicRank.C :
                    spd == "C-" ? MusicRank.Cm :
                    spd == "D+" ? MusicRank.Dp :
                    spd == "D" ? MusicRank.D :
                    spd == "E" ? MusicRank.E :
                    MusicRank.Noplay;
                case 18:
                    ms.CSP.Score = Int32(Int(spd)!);
                case 19:
                    ms.CSP.FullComboType_ =
                    spd == "MerverousFullCombo" ? FullComboType.MarvelousFullCombo :
                    spd == "PerfectFullCombo" ? FullComboType.PerfectFullCombo :
                    spd == "FullCombo" ? FullComboType.FullCombo :
                    spd == "GoodFullCombo" ? FullComboType.GoodFullCombo :
                    spd == "Life4" ? FullComboType.Life4 :
                    FullComboType.None;
                case 20:
                    ms.CSP.MaxCombo = Int32(Int(spd)!);
                case 21:
                    ms.BDP.Rank =
                    spd == "AAA" ? MusicRank.AAA :
                    spd == "AA+" ? MusicRank.AAp :
                    spd == "AA" ? MusicRank.AA :
                    spd == "AA-" ? MusicRank.AAm :
                    spd == "A+" ? MusicRank.Ap :
                    spd == "A" ? MusicRank.A :
                    spd == "A-" ? MusicRank.Am :
                    spd == "B+" ? MusicRank.Bp :
                    spd == "B" ? MusicRank.B :
                    spd == "B-" ? MusicRank.Bm :
                    spd == "C+" ? MusicRank.Cp :
                    spd == "C" ? MusicRank.C :
                    spd == "C-" ? MusicRank.Cm :
                    spd == "D+" ? MusicRank.Dp :
                    spd == "D" ? MusicRank.D :
                    spd == "E" ? MusicRank.E :
                    MusicRank.Noplay;
                case 22:
                    ms.BDP.Score = Int32(Int(spd)!);
                case 23:
                    ms.BDP.FullComboType_ =
                    spd == "MerverousFullCombo" ? FullComboType.MarvelousFullCombo :
                    spd == "PerfectFullCombo" ? FullComboType.PerfectFullCombo :
                    spd == "FullCombo" ? FullComboType.FullCombo :
                    spd == "GoodFullCombo" ? FullComboType.GoodFullCombo :
                    spd == "Life4" ? FullComboType.Life4 :
                    FullComboType.None;
                case 24:
                    ms.BDP.MaxCombo = Int32(Int(spd)!);
                case 25:
                    ms.DDP.Rank =
                    spd == "AAA" ? MusicRank.AAA :
                    spd == "AA+" ? MusicRank.AAp :
                    spd == "AA" ? MusicRank.AA :
                    spd == "AA-" ? MusicRank.AAm :
                    spd == "A+" ? MusicRank.Ap :
                    spd == "A" ? MusicRank.A :
                    spd == "A-" ? MusicRank.Am :
                    spd == "B+" ? MusicRank.Bp :
                    spd == "B" ? MusicRank.B :
                    spd == "B-" ? MusicRank.Bm :
                    spd == "C+" ? MusicRank.Cp :
                    spd == "C" ? MusicRank.C :
                    spd == "C-" ? MusicRank.Cm :
                    spd == "D+" ? MusicRank.Dp :
                    spd == "D" ? MusicRank.D :
                    spd == "E" ? MusicRank.E :
                    MusicRank.Noplay;
                case 26:
                    ms.DDP.Score = Int32(Int(spd)!);
                case 27:
                    ms.DDP.FullComboType_ =
                    spd == "MerverousFullCombo" ? FullComboType.MarvelousFullCombo :
                    spd == "PerfectFullCombo" ? FullComboType.PerfectFullCombo :
                    spd == "FullCombo" ? FullComboType.FullCombo :
                    spd == "GoodFullCombo" ? FullComboType.GoodFullCombo :
                    spd == "Life4" ? FullComboType.Life4 :
                    FullComboType.None;
                case 28:
                    ms.DDP.MaxCombo = Int32(Int(spd)!);
                case 29:
                    ms.EDP.Rank =
                    spd == "AAA" ? MusicRank.AAA :
                    spd == "AA+" ? MusicRank.AAp :
                    spd == "AA" ? MusicRank.AA :
                    spd == "AA-" ? MusicRank.AAm :
                    spd == "A+" ? MusicRank.Ap :
                    spd == "A" ? MusicRank.A :
                    spd == "A-" ? MusicRank.Am :
                    spd == "B+" ? MusicRank.Bp :
                    spd == "B" ? MusicRank.B :
                    spd == "B-" ? MusicRank.Bm :
                    spd == "C+" ? MusicRank.Cp :
                    spd == "C" ? MusicRank.C :
                    spd == "C-" ? MusicRank.Cm :
                    spd == "D+" ? MusicRank.Dp :
                    spd == "D" ? MusicRank.D :
                    spd == "E" ? MusicRank.E :
                    MusicRank.Noplay;
                case 30:
                    ms.EDP.Score = Int32(Int(spd)!);
                case 31:
                    ms.EDP.FullComboType_ =
                    spd == "MerverousFullCombo" ? FullComboType.MarvelousFullCombo :
                    spd == "PerfectFullCombo" ? FullComboType.PerfectFullCombo :
                    spd == "FullCombo" ? FullComboType.FullCombo :
                    spd == "GoodFullCombo" ? FullComboType.GoodFullCombo :
                    spd == "Life4" ? FullComboType.Life4 :
                    FullComboType.None;
                case 32:
                    ms.EDP.MaxCombo = Int32(Int(spd)!);
                case 33:
                    ms.CDP.Rank =
                    spd == "AAA" ? MusicRank.AAA :
                    spd == "AA+" ? MusicRank.AAp :
                    spd == "AA" ? MusicRank.AA :
                    spd == "AA-" ? MusicRank.AAm :
                    spd == "A+" ? MusicRank.Ap :
                    spd == "A" ? MusicRank.A :
                    spd == "A-" ? MusicRank.Am :
                    spd == "B+" ? MusicRank.Bp :
                    spd == "B" ? MusicRank.B :
                    spd == "B-" ? MusicRank.Bm :
                    spd == "C+" ? MusicRank.Cp :
                    spd == "C" ? MusicRank.C :
                    spd == "C-" ? MusicRank.Cm :
                    spd == "D+" ? MusicRank.Dp :
                    spd == "D" ? MusicRank.D :
                    spd == "E" ? MusicRank.E :
                    MusicRank.Noplay;
                case 34:
                    ms.CDP.Score = Int32(Int(spd)!);
                case 35:
                    ms.CDP.FullComboType_ =
                    spd == "MerverousFullCombo" ? FullComboType.MarvelousFullCombo :
                    spd == "PerfectFullCombo" ? FullComboType.PerfectFullCombo :
                    spd == "FullCombo" ? FullComboType.FullCombo :
                    spd == "GoodFullCombo" ? FullComboType.GoodFullCombo :
                    spd == "Life4" ? FullComboType.Life4 :
                    FullComboType.None;
                default:
                    break
                }
            }
            ret[id] = ms
        }
        
        
        return ret;
    }
    
    static func readScoreList(_ rivalId: String?) ->([Int32 : MusicScore]){
        var ret: [Int32: MusicScore] = [:]
        
        let libraryDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        let path = "ScoreData" + (rivalId == nil ? "" : "_" + rivalId!) + ".txt"
        if let dataNS = try? NSString(contentsOfFile: (libraryDirPath as NSString).appendingPathComponent(path), encoding: String.Encoding.utf8.rawValue) {
            
            let data: String = dataNS as String
            ret = parseScoreData(data)
        }
        
        migrateScoreDataIfNeeded(ret, rivalId)
        
        return ret
    }
    
    static func parseScoreData(_ data: String) ->([Int32 : MusicScore]) {
        var ret: [Int32 : MusicScore] = [:]
        
        data.enumerateLines { line, stop in
            let sp = line.components(separatedBy: "\t")
            var ms = MusicScore()
            var id: Int32 = 0
            
            func parseRank(_ spd: String) -> MusicRank {
                switch spd {
                case "AAA": return .AAA
                case "AA+": return .AAp
                case "AA": return .AA
                case "AA-": return .AAm
                case "A+": return .Ap
                case "A": return .A
                case "A-": return .Am
                case "B+": return .Bp
                case "B": return .B
                case "B-": return .Bm
                case "C+": return .Cp
                case "C": return .C
                case "C-": return .Cm
                case "D+": return .Dp
                case "D": return .D
                case "E": return .E
                default: return .Noplay
                }
            }
            
            func parseFullComboType(_ spd: String) -> FullComboType {
                switch spd {
                case "MerverousFullCombo": return .MarvelousFullCombo
                case "PerfectFullCombo": return .PerfectFullCombo
                case "FullCombo": return .FullCombo
                case "GoodFullCombo": return .GoodFullCombo
                case "Life4": return .Life4
                default: return .None
                }
            }
            
            
            func parseScoreData(_ index: Int, _ spd: String, _ difficulty: inout ScoreData) {
                switch (index - 1) % 4 {
                case 0: difficulty.Rank = parseRank(spd)
                case 1: difficulty.Score = Int32(Int(spd)!)
                case 2: difficulty.FullComboType_ = parseFullComboType(spd)
                case 3: difficulty.MaxCombo = Int32(Int(spd)!)
                default: break
                }
            }
            
            var difficulties: [ScoreData] = [ms.bSP, ms.BSP, ms.DSP, ms.ESP, ms.CSP, ms.BDP, ms.DDP, ms.EDP, ms.CDP]
            
            // Initialize flareRank to -1 for all difficulties
            difficulties.indices.forEach { difficulties[$0].flareRank = -1 }
            
            for (index, spd) in sp.enumerated() {
                switch index {
                case 0: id = Int32(Int(spd)!)
                case 1...36: parseScoreData(index, spd, &difficulties[(index - 1) / 4])
                case 37...54:
                    let difficultyIndex = (index - 37) / 2
                    if index % 2 == 1 {
                        difficulties[difficultyIndex].PlayCount = Int32(Int(spd)!)
                    } else {
                        difficulties[difficultyIndex].ClearCount = Int32(Int(spd)!)
                    }
                case 55...63:
                    difficulties[index - 55].flareRank = Int32(Int(spd) ?? -1)
                default: break
                }
            }
            
            // Assign back the updated ScoreData structs
            ms.bSP = difficulties[0]
            ms.BSP = difficulties[1]
            ms.DSP = difficulties[2]
            ms.ESP = difficulties[3]
            ms.CSP = difficulties[4]
            ms.BDP = difficulties[5]
            ms.DDP = difficulties[6]
            ms.EDP = difficulties[7]
            ms.CDP = difficulties[8]
            
            ret[id] = ms
        }
        
        return ret
    }
    
    static func migrateScoreDataIfNeeded(_ musicScores: [Int32 : MusicScore], _ rivalId: String?) {
        let key = "FlareSkillMigrationCompleted_" + (rivalId ?? "self")
        if !UserDefaults.standard.bool(forKey: key) {
            // Save the data (which now includes flareSkill fields, even if they're all 0)
            if saveScoreList(rivalId, scores: musicScores) {
                UserDefaults.standard.set(true, forKey: key)
                print("Score data migration completed successfully for \(rivalId ?? "self").")
            } else {
                print("Failed to migrate score data for \(rivalId ?? "self").")
            }
        }
    }
    
    // TODO 後で消す
    static func readScoreListOld(_ rivalId: String?) ->([Int32 : MusicScore]){
        var ret: [Int32 : MusicScore] = [:]
        
        let libraryDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        let path = "ScoreData" + (rivalId == nil ? "" : "_" + rivalId!) + ".txt"
        if let dataNS = try? NSString(contentsOfFile: (libraryDirPath as NSString).appendingPathComponent(path), encoding: String.Encoding.utf8.rawValue) {
            
            let data: String = dataNS as String
            
            ret = parseOld(data)
        }
        
        return ret;
    }
    
    static func parseOld(_ data: String) ->([Int32 : MusicScore]) {
        var ret: [Int32 : MusicScore] = [:]
        
        data.enumerateLines{
            line, stop in
            let sp = line.components(separatedBy: "\t")
            var ms: MusicScore = MusicScore()
            var id: Int32 = 0
            for (index, spd) in sp.enumerated() {
                switch index{
                case 0:
                    id = Int32(Int(spd)!)
                case 1:
                    ms.bSP.Rank =
                    spd == "AAA" ? MusicRank.AAA :
                    spd == "AA+" ? MusicRank.AAp :
                    spd == "AA" ? MusicRank.AA :
                    spd == "AA-" ? MusicRank.AAm :
                    spd == "A+" ? MusicRank.Ap :
                    spd == "A" ? MusicRank.A :
                    spd == "A-" ? MusicRank.Am :
                    spd == "B+" ? MusicRank.Bp :
                    spd == "B" ? MusicRank.B :
                    spd == "B-" ? MusicRank.Bm :
                    spd == "C+" ? MusicRank.Cp :
                    spd == "C" ? MusicRank.C :
                    spd == "C-" ? MusicRank.Cm :
                    spd == "D+" ? MusicRank.Dp :
                    spd == "D" ? MusicRank.D :
                    spd == "E" ? MusicRank.E :
                    MusicRank.Noplay;
                case 2:
                    ms.bSP.Score = Int32(Int(spd)!);
                case 3:
                    ms.bSP.FullComboType_ =
                    spd == "MerverousFullCombo" ? FullComboType.MarvelousFullCombo :
                    spd == "PerfectFullCombo" ? FullComboType.PerfectFullCombo :
                    spd == "FullCombo" ? FullComboType.FullCombo :
                    spd == "GoodFullCombo" ? FullComboType.GoodFullCombo :
                    spd == "Life4" ? FullComboType.Life4 :
                    FullComboType.None;
                case 4:
                    ms.bSP.MaxCombo = Int32(Int(spd)!);
                case 5:
                    ms.BSP.Rank =
                    spd == "AAA" ? MusicRank.AAA :
                    spd == "AA+" ? MusicRank.AAp :
                    spd == "AA" ? MusicRank.AA :
                    spd == "AA-" ? MusicRank.AAm :
                    spd == "A+" ? MusicRank.Ap :
                    spd == "A" ? MusicRank.A :
                    spd == "A-" ? MusicRank.Am :
                    spd == "B+" ? MusicRank.Bp :
                    spd == "B" ? MusicRank.B :
                    spd == "B-" ? MusicRank.Bm :
                    spd == "C+" ? MusicRank.Cp :
                    spd == "C" ? MusicRank.C :
                    spd == "C-" ? MusicRank.Cm :
                    spd == "D+" ? MusicRank.Dp :
                    spd == "D" ? MusicRank.D :
                    spd == "E" ? MusicRank.E :
                    MusicRank.Noplay;
                case 6:
                    ms.BSP.Score = Int32(Int(spd)!);
                case 7:
                    ms.BSP.FullComboType_ =
                    spd == "MerverousFullCombo" ? FullComboType.MarvelousFullCombo :
                    spd == "PerfectFullCombo" ? FullComboType.PerfectFullCombo :
                    spd == "FullCombo" ? FullComboType.FullCombo :
                    spd == "GoodFullCombo" ? FullComboType.GoodFullCombo :
                    spd == "Life4" ? FullComboType.Life4 :
                    FullComboType.None;
                case 8:
                    ms.BSP.MaxCombo = Int32(Int(spd)!);
                case 9:
                    ms.DSP.Rank =
                    spd == "AAA" ? MusicRank.AAA :
                    spd == "AA+" ? MusicRank.AAp :
                    spd == "AA" ? MusicRank.AA :
                    spd == "AA-" ? MusicRank.AAm :
                    spd == "A+" ? MusicRank.Ap :
                    spd == "A" ? MusicRank.A :
                    spd == "A-" ? MusicRank.Am :
                    spd == "B+" ? MusicRank.Bp :
                    spd == "B" ? MusicRank.B :
                    spd == "B-" ? MusicRank.Bm :
                    spd == "C+" ? MusicRank.Cp :
                    spd == "C" ? MusicRank.C :
                    spd == "C-" ? MusicRank.Cm :
                    spd == "D+" ? MusicRank.Dp :
                    spd == "D" ? MusicRank.D :
                    spd == "E" ? MusicRank.E :
                    MusicRank.Noplay;
                case 10:
                    ms.DSP.Score = Int32(Int(spd)!);
                case 11:
                    ms.DSP.FullComboType_ =
                    spd == "MerverousFullCombo" ? FullComboType.MarvelousFullCombo :
                    spd == "PerfectFullCombo" ? FullComboType.PerfectFullCombo :
                    spd == "FullCombo" ? FullComboType.FullCombo :
                    spd == "GoodFullCombo" ? FullComboType.GoodFullCombo :
                    spd == "Life4" ? FullComboType.Life4 :
                    FullComboType.None;
                case 12:
                    ms.DSP.MaxCombo = Int32(Int(spd)!);
                case 13:
                    ms.ESP.Rank =
                    spd == "AAA" ? MusicRank.AAA :
                    spd == "AA+" ? MusicRank.AAp :
                    spd == "AA" ? MusicRank.AA :
                    spd == "AA-" ? MusicRank.AAm :
                    spd == "A+" ? MusicRank.Ap :
                    spd == "A" ? MusicRank.A :
                    spd == "A-" ? MusicRank.Am :
                    spd == "B+" ? MusicRank.Bp :
                    spd == "B" ? MusicRank.B :
                    spd == "B-" ? MusicRank.Bm :
                    spd == "C+" ? MusicRank.Cp :
                    spd == "C" ? MusicRank.C :
                    spd == "C-" ? MusicRank.Cm :
                    spd == "D+" ? MusicRank.Dp :
                    spd == "D" ? MusicRank.D :
                    spd == "E" ? MusicRank.E :
                    MusicRank.Noplay;
                case 14:
                    ms.ESP.Score = Int32(Int(spd)!);
                case 15:
                    ms.ESP.FullComboType_ =
                    spd == "MerverousFullCombo" ? FullComboType.MarvelousFullCombo :
                    spd == "PerfectFullCombo" ? FullComboType.PerfectFullCombo :
                    spd == "FullCombo" ? FullComboType.FullCombo :
                    spd == "GoodFullCombo" ? FullComboType.GoodFullCombo :
                    spd == "Life4" ? FullComboType.Life4 :
                    FullComboType.None;
                case 16:
                    ms.ESP.MaxCombo = Int32(Int(spd)!);
                case 17:
                    ms.CSP.Rank =
                    spd == "AAA" ? MusicRank.AAA :
                    spd == "AA+" ? MusicRank.AAp :
                    spd == "AA" ? MusicRank.AA :
                    spd == "AA-" ? MusicRank.AAm :
                    spd == "A+" ? MusicRank.Ap :
                    spd == "A" ? MusicRank.A :
                    spd == "A-" ? MusicRank.Am :
                    spd == "B+" ? MusicRank.Bp :
                    spd == "B" ? MusicRank.B :
                    spd == "B-" ? MusicRank.Bm :
                    spd == "C+" ? MusicRank.Cp :
                    spd == "C" ? MusicRank.C :
                    spd == "C-" ? MusicRank.Cm :
                    spd == "D+" ? MusicRank.Dp :
                    spd == "D" ? MusicRank.D :
                    spd == "E" ? MusicRank.E :
                    MusicRank.Noplay;
                case 18:
                    ms.CSP.Score = Int32(Int(spd)!);
                case 19:
                    ms.CSP.FullComboType_ =
                    spd == "MerverousFullCombo" ? FullComboType.MarvelousFullCombo :
                    spd == "PerfectFullCombo" ? FullComboType.PerfectFullCombo :
                    spd == "FullCombo" ? FullComboType.FullCombo :
                    spd == "GoodFullCombo" ? FullComboType.GoodFullCombo :
                    spd == "Life4" ? FullComboType.Life4 :
                    FullComboType.None;
                case 20:
                    ms.CSP.MaxCombo = Int32(Int(spd)!);
                case 21:
                    ms.BDP.Rank =
                    spd == "AAA" ? MusicRank.AAA :
                    spd == "AA+" ? MusicRank.AAp :
                    spd == "AA" ? MusicRank.AA :
                    spd == "AA-" ? MusicRank.AAm :
                    spd == "A+" ? MusicRank.Ap :
                    spd == "A" ? MusicRank.A :
                    spd == "A-" ? MusicRank.Am :
                    spd == "B+" ? MusicRank.Bp :
                    spd == "B" ? MusicRank.B :
                    spd == "B-" ? MusicRank.Bm :
                    spd == "C+" ? MusicRank.Cp :
                    spd == "C" ? MusicRank.C :
                    spd == "C-" ? MusicRank.Cm :
                    spd == "D+" ? MusicRank.Dp :
                    spd == "D" ? MusicRank.D :
                    spd == "E" ? MusicRank.E :
                    MusicRank.Noplay;
                case 22:
                    ms.BDP.Score = Int32(Int(spd)!);
                case 23:
                    ms.BDP.FullComboType_ =
                    spd == "MerverousFullCombo" ? FullComboType.MarvelousFullCombo :
                    spd == "PerfectFullCombo" ? FullComboType.PerfectFullCombo :
                    spd == "FullCombo" ? FullComboType.FullCombo :
                    spd == "GoodFullCombo" ? FullComboType.GoodFullCombo :
                    spd == "Life4" ? FullComboType.Life4 :
                    FullComboType.None;
                case 24:
                    ms.BDP.MaxCombo = Int32(Int(spd)!);
                case 25:
                    ms.DDP.Rank =
                    spd == "AAA" ? MusicRank.AAA :
                    spd == "AA+" ? MusicRank.AAp :
                    spd == "AA" ? MusicRank.AA :
                    spd == "AA-" ? MusicRank.AAm :
                    spd == "A+" ? MusicRank.Ap :
                    spd == "A" ? MusicRank.A :
                    spd == "A-" ? MusicRank.Am :
                    spd == "B+" ? MusicRank.Bp :
                    spd == "B" ? MusicRank.B :
                    spd == "B-" ? MusicRank.Bm :
                    spd == "C+" ? MusicRank.Cp :
                    spd == "C" ? MusicRank.C :
                    spd == "C-" ? MusicRank.Cm :
                    spd == "D+" ? MusicRank.Dp :
                    spd == "D" ? MusicRank.D :
                    spd == "E" ? MusicRank.E :
                    MusicRank.Noplay;
                case 26:
                    ms.DDP.Score = Int32(Int(spd)!);
                case 27:
                    ms.DDP.FullComboType_ =
                    spd == "MerverousFullCombo" ? FullComboType.MarvelousFullCombo :
                    spd == "PerfectFullCombo" ? FullComboType.PerfectFullCombo :
                    spd == "FullCombo" ? FullComboType.FullCombo :
                    spd == "GoodFullCombo" ? FullComboType.GoodFullCombo :
                    spd == "Life4" ? FullComboType.Life4 :
                    FullComboType.None;
                case 28:
                    ms.DDP.MaxCombo = Int32(Int(spd)!);
                case 29:
                    ms.EDP.Rank =
                    spd == "AAA" ? MusicRank.AAA :
                    spd == "AA+" ? MusicRank.AAp :
                    spd == "AA" ? MusicRank.AA :
                    spd == "AA-" ? MusicRank.AAm :
                    spd == "A+" ? MusicRank.Ap :
                    spd == "A" ? MusicRank.A :
                    spd == "A-" ? MusicRank.Am :
                    spd == "B+" ? MusicRank.Bp :
                    spd == "B" ? MusicRank.B :
                    spd == "B-" ? MusicRank.Bm :
                    spd == "C+" ? MusicRank.Cp :
                    spd == "C" ? MusicRank.C :
                    spd == "C-" ? MusicRank.Cm :
                    spd == "D+" ? MusicRank.Dp :
                    spd == "D" ? MusicRank.D :
                    spd == "E" ? MusicRank.E :
                    MusicRank.Noplay;
                case 30:
                    ms.EDP.Score = Int32(Int(spd)!);
                case 31:
                    ms.EDP.FullComboType_ =
                    spd == "MerverousFullCombo" ? FullComboType.MarvelousFullCombo :
                    spd == "PerfectFullCombo" ? FullComboType.PerfectFullCombo :
                    spd == "FullCombo" ? FullComboType.FullCombo :
                    spd == "GoodFullCombo" ? FullComboType.GoodFullCombo :
                    spd == "Life4" ? FullComboType.Life4 :
                    FullComboType.None;
                case 32:
                    ms.EDP.MaxCombo = Int32(Int(spd)!);
                case 33:
                    ms.CDP.Rank =
                    spd == "AAA" ? MusicRank.AAA :
                    spd == "AA+" ? MusicRank.AAp :
                    spd == "AA" ? MusicRank.AA :
                    spd == "AA-" ? MusicRank.AAm :
                    spd == "A+" ? MusicRank.Ap :
                    spd == "A" ? MusicRank.A :
                    spd == "A-" ? MusicRank.Am :
                    spd == "B+" ? MusicRank.Bp :
                    spd == "B" ? MusicRank.B :
                    spd == "B-" ? MusicRank.Bm :
                    spd == "C+" ? MusicRank.Cp :
                    spd == "C" ? MusicRank.C :
                    spd == "C-" ? MusicRank.Cm :
                    spd == "D+" ? MusicRank.Dp :
                    spd == "D" ? MusicRank.D :
                    spd == "E" ? MusicRank.E :
                    MusicRank.Noplay;
                case 34:
                    ms.CDP.Score = Int32(Int(spd)!);
                case 35:
                    ms.CDP.FullComboType_ =
                    spd == "MerverousFullCombo" ? FullComboType.MarvelousFullCombo :
                    spd == "PerfectFullCombo" ? FullComboType.PerfectFullCombo :
                    spd == "FullCombo" ? FullComboType.FullCombo :
                    spd == "GoodFullCombo" ? FullComboType.GoodFullCombo :
                    spd == "Life4" ? FullComboType.Life4 :
                    FullComboType.None;
                case 36:
                    ms.CDP.MaxCombo = Int32(Int(spd)!);
                case 37:
                    ms.bSP.PlayCount = Int32(Int(spd)!);
                case 38:
                    ms.bSP.ClearCount = Int32(Int(spd)!);
                case 39:
                    ms.BSP.PlayCount = Int32(Int(spd)!);
                case 40:
                    ms.BSP.ClearCount = Int32(Int(spd)!);
                case 41:
                    ms.DSP.PlayCount = Int32(Int(spd)!);
                case 42:
                    ms.DSP.ClearCount = Int32(Int(spd)!);
                case 43:
                    ms.ESP.PlayCount = Int32(Int(spd)!);
                case 44:
                    ms.ESP.ClearCount = Int32(Int(spd)!);
                case 45:
                    ms.CSP.PlayCount = Int32(Int(spd)!);
                case 46:
                    ms.CSP.ClearCount = Int32(Int(spd)!);
                case 47:
                    ms.BDP.PlayCount = Int32(Int(spd)!);
                case 48:
                    ms.BDP.ClearCount = Int32(Int(spd)!);
                case 49:
                    ms.DDP.PlayCount = Int32(Int(spd)!);
                case 50:
                    ms.DDP.ClearCount = Int32(Int(spd)!);
                case 51:
                    ms.EDP.PlayCount = Int32(Int(spd)!);
                case 52:
                    ms.EDP.ClearCount = Int32(Int(spd)!);
                case 53:
                    ms.CDP.PlayCount = Int32(Int(spd)!);
                case 54:
                    ms.CDP.ClearCount = Int32(Int(spd)!);
                default:
                    break
                }
            }
            ret[id] = ms
        }
        
        return ret
    }
    
    static func saveScoreList(_ rivalId: String?, scores: [Int32 : MusicScore]) -> (Bool) {
        let libraryDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        let path = "ScoreData" + (rivalId == nil ? "" : "_" + rivalId!) + ".txt"
        let filePath: String = (libraryDirPath as NSString).appendingPathComponent(path)
        
        var wr: String = ""
        for (id, _) in scores {
            let str: String = StringUtil.getScoreBackupText(id, scores: scores)+"\n";
            wr = wr + str
        }
        do {
            try wr.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        } catch _ {
        }
        
        return true;
    }
    
    static func readLastBootTime() -> (Date) {
        if let sfm: SettingFileManager = SettingFileManager(fileName: "VersionInfo.txt") {
            if let tm = sfm.getInt32("LastBootTime") {
                return Date(timeIntervalSince1970: TimeInterval(tm))
            }
        }
        return Date(timeIntervalSince1970: TimeInterval(0))
    }
    
    static func saveLastBootTime() {
        let sfm: SettingFileManager = SettingFileManager(fileName: "VersionInfo.txt", force: true)
        let date = Date()
        sfm.putInt("LastBootTime", value: Int(NSInteger(date.timeIntervalSince1970)))
        sfm.save()
    }
    
    static func readActiveFilterId() -> (Int32) {
        if let sfm: SettingFileManager = SettingFileManager(fileName: "FilterSetting.txt") {
            return sfm.getInt32("ActiveFilter", def: 0)
        }
        return 0
    }
    
    static func saveActiveFilterId(_ id: Int32) {
        let sfm: SettingFileManager = SettingFileManager(fileName: "FilterSetting.txt", force: true)
        sfm.putInt32("ActiveFilter", value: id)
        sfm.save()
    }
    
    static func readFilterCount() -> (Int32) {
        if let sfm: SettingFileManager = SettingFileManager(fileName: "FilterSetting.txt") {
            if let count = sfm.getInt32("FilterCount") {
                if count > 0 {
                    return count
                }
            }
        }
        saveFilterCount(1)
        return 1
    }
    
    static func saveFilterCount(_ count: Int32) {
        let sfm: SettingFileManager = SettingFileManager(fileName: "FilterSetting.txt", force: true)
        sfm.putInt32("FilterCount", value: count)
        sfm.save()
    }
    
    static func readFilterName(_ id: Int32) -> (String?) {
        if id == 0 {
            return "Default"
        }
        if let sfm: SettingFileManager = SettingFileManager(fileName: "FilterSetting.txt") {
            if let name = sfm.getString("FilterName"+id.description) {
                return name
            }
        }
        return nil
    }
    
    static func saveFilterName(_ id: Int32, name: String) {
        let sfm: SettingFileManager = SettingFileManager(fileName: "FilterSetting.txt", force: true)
        sfm.putString("FilterName"+id.description, value: name)
        sfm.save()
    }
    
    static func readFilter(_ id: Int32) -> (MusicFilter?) {
        if id == 0 {
            return MusicFilter()
        }
        if let sfm: SettingFileManager = SettingFileManager(fileName: "Filter_"+id.description+".txt") {
            let ret: MusicFilter = MusicFilter()
            ret.bSP = sfm.getBool("bSP", def: true);
            ret.BSP = sfm.getBool("BSP", def: true);
            ret.DSP = sfm.getBool("DSP", def: true);
            ret.ESP = sfm.getBool("ESP", def: true);
            ret.CSP = sfm.getBool("CSP", def: true);
            ret.BDP = sfm.getBool("BDP", def: true);
            ret.DDP = sfm.getBool("DDP", def: true);
            ret.EDP = sfm.getBool("EDP", def: true);
            ret.CDP = sfm.getBool("CDP", def: true);
            ret.AllowOnlyChallenge = sfm.getBool("AllowOnlyChallenge", def: true);
            ret.AllowExpertWhenNoChallenge = sfm.getBool("AllowExpertWhenNoChallenge", def: true);
            var shock: Int32;
            shock = sfm.getInt32("ShockArrowSP", def: 1);
            ret.ShockArrowSP = shock == 0 ? ShockArrowInclude.Only : shock == 1 ? ShockArrowInclude.Include : ShockArrowInclude.Exclude;
            shock = sfm.getInt32("ShockArrowDP", def: 1);
            ret.ShockArrowDP = shock == 0 ? ShockArrowInclude.Only : shock == 1 ? ShockArrowInclude.Include : ShockArrowInclude.Exclude;
            ret.Dif1 = sfm.getBool("Dif1", def: true);
            ret.Dif2 = sfm.getBool("Dif2", def: true);
            ret.Dif3 = sfm.getBool("Dif3", def: true);
            ret.Dif4 = sfm.getBool("Dif4", def: true);
            ret.Dif5 = sfm.getBool("Dif5", def: true);
            ret.Dif6 = sfm.getBool("Dif6", def: true);
            ret.Dif7 = sfm.getBool("Dif7", def: true);
            ret.Dif8 = sfm.getBool("Dif8", def: true);
            ret.Dif9 = sfm.getBool("Dif9", def: true);
            ret.Dif10 = sfm.getBool("Dif10", def: true);
            ret.Dif11 = sfm.getBool("Dif11", def: true);
            ret.Dif12 = sfm.getBool("Dif12", def: true);
            ret.Dif13 = sfm.getBool("Dif13", def: true);
            ret.Dif14 = sfm.getBool("Dif14", def: true);
            ret.Dif15 = sfm.getBool("Dif15", def: true);
            ret.Dif16 = sfm.getBool("Dif16", def: true);
            ret.Dif17 = sfm.getBool("Dif17", def: true);
            ret.Dif18 = sfm.getBool("Dif18", def: true);
            ret.Dif19 = sfm.getBool("Dif19", def: true);
            ret.RankAAA = sfm.getBool("RankAAA", def: true);
            ret.RankAAp = sfm.getBool("RankAA+", def: true);
            ret.RankAA = sfm.getBool("RankAA", def: true);
            ret.RankAAm = sfm.getBool("RankAA-", def: true);
            ret.RankAp = sfm.getBool("RankA+", def: true);
            ret.RankA = sfm.getBool("RankA", def: true);
            ret.RankAm = sfm.getBool("RankA-", def: true);
            ret.RankBp  = sfm.getBool("RankB+", def: true);
            ret.RankB  = sfm.getBool("RankB", def: true);
            ret.RankBm  = sfm.getBool("RankB-", def: true);
            ret.RankCp = sfm.getBool("RankC+", def: true);
            ret.RankC = sfm.getBool("RankC", def: true);
            ret.RankCm = sfm.getBool("RankC-", def: true);
            ret.RankDp = sfm.getBool("RankD+", def: true);
            ret.RankD = sfm.getBool("RankD", def: true);
            ret.RankE = sfm.getBool("RankE", def: true);
            ret.RankNoPlay = sfm.getBool("RankNoPlay", def: true);
            ret.FcMFC = sfm.getBool("FcMFC", def: true);
            ret.FcPFC = sfm.getBool("FcPFC", def: true);
            ret.FcFC = sfm.getBool("FcFC", def: true);
            ret.FcGFC = sfm.getBool("FcGFC", def: true);
            ret.FcLife4 = sfm.getBool("FcLife4", def: true);
            ret.FcNoFC = sfm.getBool("FcNoFC", def: true);
            
            ret.FlareRankEX = sfm.getBool("FlareRankEX", def: true);
            ret.FlareRankIX = sfm.getBool("FlareRankIX", def: true);
            ret.FlareRankVIII = sfm.getBool("FlareRankVIII", def: true);
            ret.FlareRankVII = sfm.getBool("FlareRankVII", def: true);
            ret.FlareRankVI = sfm.getBool("FlareRankVI", def: true);
            ret.FlareRankV = sfm.getBool("FlareRankV", def: true);
            ret.FlareRankIV = sfm.getBool("FlareRankIV", def: true);
            ret.FlareRankIII = sfm.getBool("FlareRankIII", def: true);
            ret.FlareRankII = sfm.getBool("FlareRankII", def: true);
            ret.FlareRankI = sfm.getBool("FlareRankI", def: true);
            ret.FlareRank0 = sfm.getBool("FlareRank0", def: true);
            ret.FlareRankNoRank = sfm.getBool("FlareRankNoRank", def: true);
            
            ret.RankAAArival = sfm.getBool("RankAAArival", def: true);
            ret.RankAAprival = sfm.getBool("RankAA+rival", def: true);
            ret.RankAArival = sfm.getBool("RankAArival", def: true);
            ret.RankAAmrival = sfm.getBool("RankAA-rival", def: true);
            ret.RankAprival = sfm.getBool("RankA+rival", def: true);
            ret.RankArival = sfm.getBool("RankArival", def: true);
            ret.RankAmrival = sfm.getBool("RankA-rival", def: true);
            ret.RankBprival  = sfm.getBool("RankB+rival", def: true);
            ret.RankBrival  = sfm.getBool("RankBrival", def: true);
            ret.RankBmrival  = sfm.getBool("RankB-rival", def: true);
            ret.RankCprival = sfm.getBool("RankC+rival", def: true);
            ret.RankCrival = sfm.getBool("RankCrival", def: true);
            ret.RankCmrival = sfm.getBool("RankC-rival", def: true);
            ret.RankDprival = sfm.getBool("RankD+rival", def: true);
            ret.RankDrival = sfm.getBool("RankDrival", def: true);
            ret.RankErival = sfm.getBool("RankErival", def: true);
            ret.RankNoPlayrival = sfm.getBool("RankNoPlayrival", def: true);
            ret.RivalWin = sfm.getBool("RivalWin", def: true);
            ret.RivalLose = sfm.getBool("RivalLose", def: true);
            ret.RivalDraw = sfm.getBool("RivalDraw", def: true);
            ret.FcMFCrival = sfm.getBool("FcMFCrival", def: true);
            ret.FcPFCrival = sfm.getBool("FcPFCrival", def: true);
            ret.FcFCrival = sfm.getBool("FcFCrival", def: true);
            ret.FcGFCrival = sfm.getBool("FcGFCrival", def: true);
            ret.FcLife4rival = sfm.getBool("FcLife4rival", def: true);
            ret.FcNoFCrival = sfm.getBool("FcNoFCrival", def: true);
            ret.ScoreMin = sfm.getInt32("ScoreMin", def: 0);
            ret.ScoreMax = sfm.getInt32("ScoreMax", def: 1000000);
            ret.ScoreMinRival = sfm.getInt32("ScoreMinRival", def: 0);
            ret.ScoreMaxRival = sfm.getInt32("ScoreMaxRival", def: 1000000);
            ret.MaxComboMin = sfm.getInt32("MaxComboMin", def: 0);
            ret.MaxComboMax = sfm.getInt32("MaxComboMax", def: Int32.max);
            ret.MaxComboMinRival = sfm.getInt32("MaxComboMinRival", def: 0);
            ret.MaxComboMaxRival = sfm.getInt32("MaxComboMaxRival", def: Int32.max);
            ret.PlayCountMin = sfm.getInt32("PlayCountMin", def: 0);
            ret.PlayCountMax = sfm.getInt32("PlayCountMax", def: Int32.max);
            ret.PlayCountMinRival = sfm.getInt32("PlayCountMinRival", def: 0);
            ret.PlayCountMaxRival = sfm.getInt32("PlayCountMaxRival", def: Int32.max);
            ret.ClearCountMin = sfm.getInt32("ClearCountMin", def: 0);
            ret.ClearCountMax = sfm.getInt32("ClearCountMax", def: Int32.max);
            ret.ClearCountMinRival = sfm.getInt32("ClearCountMinRival", def: 0);
            ret.ClearCountMaxRival = sfm.getInt32("ClearCountMaxRival", def: Int32.max);
            ret.ScoreDifferenceMinusMin = sfm.getInt32("ScoreDifferenceMinusMin", def: 0);
            ret.ScoreDifferenceMinusMax = sfm.getInt32("ScoreDifferenceMinusMax", def: -1000000);
            ret.ScoreDifferencePlusMin = sfm.getInt32("ScoreDifferencePlusMin", def: 0);
            ret.ScoreDifferencePlusMax = sfm.getInt32("ScoreDifferencePlusMax", def: 1000000);
            ret.MaxComboDifferenceMinusMin = sfm.getInt32("MaxComboDifferenceMinusMin", def: 0);
            ret.MaxComboDifferenceMinusMax = sfm.getInt32("MaxComboDifferenceMinusMax", def: Int32.min);
            ret.MaxComboDifferencePlusMin = sfm.getInt32("MaxComboDifferencePlusMin", def: 0);
            ret.MaxComboDifferencePlusMax = sfm.getInt32("MaxComboDifferencePlusMax", def: Int32.max);
            ret.PlayCountDifferenceMinusMin = sfm.getInt32("PlayCountDifferenceMinusMin", def: 0);
            ret.PlayCountDifferenceMinusMax = sfm.getInt32("PlayCountDifferenceMinusMax", def: Int32.min);
            ret.PlayCountDifferencePlusMin = sfm.getInt32("PlayCountDifferencePlusMin", def: 0);
            ret.PlayCountDifferencePlusMax = sfm.getInt32("PlayCountDifferencePlusMax", def: Int32.max);
            ret.ClearCountDifferenceMinusMin = sfm.getInt32("ClearCountDifferenceMinusMin", def: 0);
            ret.ClearCountDifferenceMinusMax = sfm.getInt32("ClearCountDifferenceMinusMax", def: Int32.min);
            ret.ClearCountDifferencePlusMin = sfm.getInt32("ClearCountDifferencePlusMin", def: 0);
            ret.ClearCountDifferencePlusMax = sfm.getInt32("ClearCountDifferencePlusMax", def: Int32.max);
            ret.SerWORLD = sfm.getBool("SerWORLD", def: true);
            ret.SerA3 = sfm.getBool("SerA3", def: true);
            ret.SerA20PLUS = sfm.getBool("SerA20PLUS", def: true);
            ret.SerA20 = sfm.getBool("SerA20", def: true);
            ret.SerA = sfm.getBool("SerA", def: true);
            ret.Ser2014 = sfm.getBool("Ser2014", def: true);
            ret.Ser2013 = sfm.getBool("Ser2013", def: true);
            ret.SerX3 = sfm.getBool("SerX3", def: true);
            ret.SerX3vs2ndMIX = sfm.getBool("SerX3vs2ndMIX", def: true);
            ret.SerX2 = sfm.getBool("SerX2", def: true);
            ret.SerX = sfm.getBool("SerX", def: true);
            ret.SerSuperNova2 = sfm.getBool("SerSuperNova2", def: true);
            ret.SerSuperNova = sfm.getBool("SerSuperNova", def: true);
            ret.SerEXTREME = sfm.getBool("SerEXTREME", def: true);
            ret.SerMAX2 = sfm.getBool("SerMAX2", def: true);
            ret.SerMAX = sfm.getBool("SerMAX", def: true);
            ret.Ser5th = sfm.getBool("Ser5th", def: true);
            ret.Ser4th = sfm.getBool("Ser4th", def: true);
            ret.Ser3rd = sfm.getBool("Ser3rd", def: true);
            ret.Ser2nd = sfm.getBool("Ser2nd", def: true);
            ret.Ser1st = sfm.getBool("Ser1st", def: true);
            ret.OthersDeleted = sfm.getBool("OthersDeleted", def: true);
            return ret
        }
        return nil
    }
    
    static func saveFilter(_ id: Int32, filter: MusicFilter) {
        let sfm: SettingFileManager = SettingFileManager(fileName: "Filter_"+id.description+".txt", force: true)
        sfm.putBool("bSP", value: filter.bSP);
        sfm.putBool("BSP", value: filter.BSP);
        sfm.putBool("DSP", value: filter.DSP);
        sfm.putBool("ESP", value: filter.ESP);
        sfm.putBool("CSP", value: filter.CSP);
        sfm.putBool("BDP", value: filter.BDP);
        sfm.putBool("DDP", value: filter.DDP);
        sfm.putBool("EDP", value: filter.EDP);
        sfm.putBool("CDP", value: filter.CDP);
        sfm.putBool("AllowOnlyChallenge", value: filter.AllowOnlyChallenge);
        sfm.putBool("AllowExpertWhenNoChallenge", value: filter.AllowExpertWhenNoChallenge);
        sfm.putInt32("ShockArrowSP", value: filter.ShockArrowSP == ShockArrowInclude.Only ? 0 : filter.ShockArrowSP == ShockArrowInclude.Include ? 1 : 2);
        sfm.putInt32("ShockArrowDP", value: filter.ShockArrowDP == ShockArrowInclude.Only ? 0 : filter.ShockArrowDP == ShockArrowInclude.Include ? 1 : 2);
        sfm.putBool("Dif1", value: filter.Dif1);
        sfm.putBool("Dif2", value: filter.Dif2);
        sfm.putBool("Dif3", value: filter.Dif3);
        sfm.putBool("Dif4", value: filter.Dif4);
        sfm.putBool("Dif5", value: filter.Dif5);
        sfm.putBool("Dif6", value: filter.Dif6);
        sfm.putBool("Dif7", value: filter.Dif7);
        sfm.putBool("Dif8", value: filter.Dif8);
        sfm.putBool("Dif9", value: filter.Dif9);
        sfm.putBool("Dif10", value: filter.Dif10);
        sfm.putBool("Dif11", value: filter.Dif11);
        sfm.putBool("Dif12", value: filter.Dif12);
        sfm.putBool("Dif13", value: filter.Dif13);
        sfm.putBool("Dif14", value: filter.Dif14);
        sfm.putBool("Dif15", value: filter.Dif15);
        sfm.putBool("Dif16", value: filter.Dif16);
        sfm.putBool("Dif17", value: filter.Dif17);
        sfm.putBool("Dif18", value: filter.Dif18);
        sfm.putBool("Dif19", value: filter.Dif19);
        sfm.putBool("RankAAA", value: filter.RankAAA);
        sfm.putBool("RankAA+", value: filter.RankAAp);
        sfm.putBool("RankAA", value: filter.RankAA);
        sfm.putBool("RankAA-", value: filter.RankAAm);
        sfm.putBool("RankA+", value: filter.RankAp);
        sfm.putBool("RankA", value: filter.RankA);
        sfm.putBool("RankA-", value: filter.RankAm);
        sfm.putBool("RankB+", value: filter.RankBp);
        sfm.putBool("RankB", value: filter.RankB);
        sfm.putBool("RankB-", value: filter.RankBm);
        sfm.putBool("RankC+", value: filter.RankCp);
        sfm.putBool("RankC", value: filter.RankC);
        sfm.putBool("RankC-", value: filter.RankCm);
        sfm.putBool("RankD+", value: filter.RankDp);
        sfm.putBool("RankD", value: filter.RankD);
        sfm.putBool("RankE", value: filter.RankE);
        sfm.putBool("RankNoPlay", value: filter.RankNoPlay);
        sfm.putBool("FcMFC", value: filter.FcMFC);
        sfm.putBool("FcPFC", value: filter.FcPFC);
        sfm.putBool("FcFC", value: filter.FcFC);
        sfm.putBool("FcGFC", value: filter.FcGFC);
        sfm.putBool("FcLife4", value: filter.FcLife4);
        sfm.putBool("FcNoFC", value: filter.FcNoFC);
        
        sfm.putBool("FlareRankEX", value: filter.FlareRankEX);
        sfm.putBool("FlareRankIX", value: filter.FlareRankIX);
        sfm.putBool("FlareRankVIII", value: filter.FlareRankVIII);
        sfm.putBool("FlareRankVII", value: filter.FlareRankVII);
        sfm.putBool("FlareRankVI", value: filter.FlareRankVI);
        sfm.putBool("FlareRankV", value: filter.FlareRankV);
        sfm.putBool("FlareRankIV", value: filter.FlareRankIV);
        sfm.putBool("FlareRankIII", value: filter.FlareRankIII);
        sfm.putBool("FlareRankII", value: filter.FlareRankII);
        sfm.putBool("FlareRankI", value: filter.FlareRankI);
        sfm.putBool("FlareRank0", value: filter.FlareRank0);
        sfm.putBool("FlareRankNoRank", value: filter.FlareRankNoRank);
        
        sfm.putBool("RankAAArival", value: filter.RankAAArival);
        sfm.putBool("RankAA+rival", value: filter.RankAAprival);
        sfm.putBool("RankAArival", value: filter.RankAArival);
        sfm.putBool("RankAA-rival", value: filter.RankAAmrival);
        sfm.putBool("RankA+rival", value: filter.RankAprival);
        sfm.putBool("RankArival", value: filter.RankArival);
        sfm.putBool("RankA-rival", value: filter.RankAmrival);
        sfm.putBool("RankB+rival", value: filter.RankBprival);
        sfm.putBool("RankBrival", value: filter.RankBrival);
        sfm.putBool("RankB-rival", value: filter.RankBmrival);
        sfm.putBool("RankC+rival", value: filter.RankCprival);
        sfm.putBool("RankCrival", value: filter.RankCrival);
        sfm.putBool("RankC-rival", value: filter.RankCmrival);
        sfm.putBool("RankD+rival", value: filter.RankDprival);
        sfm.putBool("RankDrival", value: filter.RankDrival);
        sfm.putBool("RankErival", value: filter.RankErival);
        sfm.putBool("RankNoPlayrival", value: filter.RankNoPlayrival);
        sfm.putBool("FcMFCrival", value: filter.FcMFCrival);
        sfm.putBool("FcPFCrival", value: filter.FcPFCrival);
        sfm.putBool("FcFCrival", value: filter.FcFCrival);
        sfm.putBool("FcGFCrival", value: filter.FcGFCrival);
        sfm.putBool("FcLife4rival", value: filter.FcLife4rival);
        sfm.putBool("FcNoFCrival", value: filter.FcNoFCrival);
        sfm.putBool("RivalWin", value: filter.RivalWin);
        sfm.putBool("RivalLose", value: filter.RivalLose);
        sfm.putBool("RivalDraw", value: filter.RivalDraw);
        sfm.putInt32("ScoreMin", value: filter.ScoreMin);
        sfm.putInt32("ScoreMax", value: filter.ScoreMax);
        sfm.putInt32("ScoreMinRival", value: filter.ScoreMinRival);
        sfm.putInt32("ScoreMaxRival", value: filter.ScoreMaxRival);
        sfm.putInt32("MaxComboMin", value: filter.MaxComboMin);
        sfm.putInt32("MaxComboMax", value: filter.MaxComboMax);
        sfm.putInt32("MaxComboMinRival", value: filter.MaxComboMinRival);
        sfm.putInt32("MaxComboMaxRival", value: filter.MaxComboMaxRival);
        sfm.putInt32("PlayCountMin", value: filter.PlayCountMin);
        sfm.putInt32("PlayCountMax", value: filter.PlayCountMax);
        sfm.putInt32("PlayCountMinRival", value: filter.PlayCountMinRival);
        sfm.putInt32("PlayCountMaxRival", value: filter.PlayCountMaxRival);
        sfm.putInt32("ClearCountMin", value: filter.ClearCountMin);
        sfm.putInt32("ClearCountMax", value: filter.ClearCountMax);
        sfm.putInt32("ClearCountMinRival", value: filter.ClearCountMinRival);
        sfm.putInt32("ClearCountMaxRival", value: filter.ClearCountMaxRival);
        sfm.putInt32("ScoreDifferenceMinusMin", value: filter.ScoreDifferenceMinusMin);
        sfm.putInt32("ScoreDifferenceMinusMax", value: filter.ScoreDifferenceMinusMax);
        sfm.putInt32("ScoreDifferencePlusMin", value: filter.ScoreDifferencePlusMin);
        sfm.putInt32("ScoreDifferencePlusMax", value: filter.ScoreDifferencePlusMax);
        sfm.putInt32("MaxComboDifferenceMinusMin", value: filter.MaxComboDifferenceMinusMin);
        sfm.putInt32("MaxComboDifferenceMinusMax", value: filter.MaxComboDifferenceMinusMax);
        sfm.putInt32("MaxComboDifferencePlusMin", value: filter.MaxComboDifferencePlusMin);
        sfm.putInt32("MaxComboDifferencePlusMax", value: filter.MaxComboDifferencePlusMax);
        sfm.putInt32("PlayCountDifferenceMinusMin", value: filter.PlayCountDifferenceMinusMin);
        sfm.putInt32("PlayCountDifferenceMinusMax", value: filter.PlayCountDifferenceMinusMax);
        sfm.putInt32("PlayCountDifferencePlusMin", value: filter.PlayCountDifferencePlusMin);
        sfm.putInt32("PlayCountDifferencePlusMax", value: filter.PlayCountDifferencePlusMax);
        sfm.putInt32("ClearCountDifferenceMinusMin", value: filter.ClearCountDifferenceMinusMin);
        sfm.putInt32("ClearCountDifferenceMinusMax", value: filter.ClearCountDifferenceMinusMax);
        sfm.putInt32("ClearCountDifferencePlusMin", value: filter.ClearCountDifferencePlusMin);
        sfm.putInt32("ClearCountDifferencePlusMax", value: filter.ClearCountDifferencePlusMax);
        sfm.putBool("SerWORLD", value: filter.SerWORLD);
        sfm.putBool("SerA3", value: filter.SerA3);
        sfm.putBool("SerA20PLUS", value: filter.SerA20PLUS);
        sfm.putBool("SerA20", value: filter.SerA20);
        sfm.putBool("SerA", value: filter.SerA);
        sfm.putBool("Ser2014", value: filter.Ser2014);
        sfm.putBool("Ser2013", value: filter.Ser2013);
        sfm.putBool("SerX3", value: filter.SerX3);
        sfm.putBool("SerX3vs2ndMIX", value: filter.SerX3vs2ndMIX);
        sfm.putBool("SerX2", value: filter.SerX2);
        sfm.putBool("SerX", value: filter.SerX);
        sfm.putBool("SerSuperNova2", value: filter.SerSuperNova2);
        sfm.putBool("SerSuperNova", value: filter.SerSuperNova);
        sfm.putBool("SerEXTREME", value: filter.SerEXTREME);
        sfm.putBool("SerMAX2", value: filter.SerMAX2);
        sfm.putBool("SerMAX", value: filter.SerMAX);
        sfm.putBool("Ser5th", value: filter.Ser5th);
        sfm.putBool("Ser4th", value: filter.Ser4th);
        sfm.putBool("Ser3rd", value: filter.Ser3rd);
        sfm.putBool("Ser2nd", value: filter.Ser2nd);
        sfm.putBool("Ser1st", value: filter.Ser1st);
        sfm.putBool("OthersDeleted", value: filter.OthersDeleted);
        sfm.save()
    }
    
    static func deleteFilter(_ id: Int32) {
        let count: Int32 = readFilterCount();
        for i in id+1 ..< count {
            let idx: Int32 = Int32(i)
            let pagerName: String = readFilterName(idx)!;
            let filter: MusicFilter = readFilter(idx)!;
            saveFilterName(idx-1, name: pagerName);
            saveFilter(idx-1, filter: filter);
        }
        saveFilterName(count-1, name: "");
        saveFilter(count-1, filter: MusicFilter());
        saveFilterCount(count-1);
    }
    
    static func saveActiveSortId(_ id: Int32) {
        let sfm: SettingFileManager = SettingFileManager(fileName: "SortSetting.txt", force: true)
        sfm.putInt32("ActiveSort", value: id)
        sfm.save()
    }
    
    static func readActiveSortId() -> (Int32) {
        if let sfm: SettingFileManager = SettingFileManager(fileName: "SortSetting.txt") {
            return sfm.getInt32("ActiveSort", def: 0);
        }
        return 0
    }
    
    static func saveSortCount(_ pagerCount: Int32) {
        let sfm: SettingFileManager = SettingFileManager(fileName: "SortSetting.txt", force: true)
        sfm.putInt32("SortCount", value: pagerCount)
        sfm.save()
    }
    
    static func readSortCount() -> (Int32) {
        if let sfm: SettingFileManager = SettingFileManager(fileName: "SortSetting.txt") {
            if let count = sfm.getInt32("SortCount") {
                if count > 0 {
                    return count
                }
            }
        }
        saveSortCount(1)
        return 1
    }
    
    static func deleteSort(_ id: Int32) {
        let count: Int32 = readSortCount();
        for i in id+1 ..< count {
            let idx: Int32 = Int32(i)
            let pagerName: String = readSortName(idx)!;
            let sort: MusicSort = readSort(MusicSort(musics: [Int32 : MusicData](), scores: [Int32 : MusicScore](), rivalScores: [Int32 : MusicScore](), webMusicIds: [Int32 : WebMusicId]()), id: idx)!;
            saveSortName(idx-1, name: pagerName);
            saveSort(idx-1, sort: sort);
        }
        saveSortName(count-1, name: "");
        saveSort(count-1, sort: MusicSort(musics: [Int32 : MusicData](), scores: [Int32 : MusicScore](), rivalScores: [Int32 : MusicScore](), webMusicIds: [Int32 : WebMusicId]()));
        saveSortCount(count-1);
    }
    
    static func saveSortName(_ id: Int32, name: String) {
        let sfm: SettingFileManager = SettingFileManager(fileName: "SortSetting.txt", force: true)
        sfm.putString("SortName"+id.description, value: name)
        sfm.save()
    }
    
    static func readSortName(_ id: Int32) -> (String?) {
        if id == 0 {
            return "Default"
        }
        if let sfm: SettingFileManager = SettingFileManager(fileName: "SortSetting.txt") {
            if let name = sfm.getString("SortName"+id.description) {
                return name
            }
        }
        return nil
    }
    
    static func saveSort(_ id: Int32, sort: MusicSort) {
        let sfm: SettingFileManager = SettingFileManager(fileName: "Sort_"+id.description+".txt", force: true)
        var typenum: Int32;
        typenum = MusicSortTypeLister.getSortTypeNum(sort._1stType);
        sfm.putInt32("1stType", value: typenum);
        sfm.putBool("1stOrder", value: sort._1stOrder==SortOrder.Ascending);
        typenum = MusicSortTypeLister.getSortTypeNum(sort._2ndType);
        sfm.putInt32("2ndType", value: typenum);
        sfm.putBool("2ndOrder", value: sort._2ndOrder==SortOrder.Ascending);
        typenum = MusicSortTypeLister.getSortTypeNum(sort._3rdType);
        sfm.putInt32("3rdType", value: typenum);
        sfm.putBool("3rdOrder", value: sort._3rdOrder==SortOrder.Ascending);
        typenum = MusicSortTypeLister.getSortTypeNum(sort._4thType);
        sfm.putInt32("4thType", value: typenum);
        sfm.putBool("4thOrder", value: sort._4thOrder==SortOrder.Ascending);
        typenum = MusicSortTypeLister.getSortTypeNum(sort._5thType);
        sfm.putInt32("5thType", value: typenum);
        sfm.putBool("5thOrder", value: sort._5thOrder==SortOrder.Ascending);
        sfm.save();
    }
    
    static func readSort(_ base: MusicSort, id: Int32) -> (MusicSort?) {
        if id == 0 {
            let ret: MusicSort = MusicSort(musics: base.mMusicData, scores: base.mScoreData, rivalScores: base.mRivalScoreData, webMusicIds: base.mWebMusicIds);
            ret._1stType = MusicSortType.MusicName
            ret._2ndType = MusicSortType.SPDP
            ret._3rdType = MusicSortType.Pattern
            return ret
        }
        if let sfm: SettingFileManager = SettingFileManager(fileName: "Sort_"+id.description+".txt") {
            let ret: MusicSort = MusicSort(musics: base.mMusicData, scores: base.mScoreData, rivalScores: base.mRivalScoreData, webMusicIds: base.mWebMusicIds);
            var typenum: Int32;
            typenum = sfm.getInt32("1stType", def: 0);
            ret._1stType = MusicSortTypeLister.getSortType(typenum);
            ret._1stOrder = sfm.getBool("1stOrder", def: true) ? SortOrder.Ascending : SortOrder.Desending;
            typenum = sfm.getInt32("2ndType", def: 0);
            ret._2ndType = MusicSortTypeLister.getSortType(typenum);
            ret._2ndOrder = sfm.getBool("2ndOrder", def: true) ? SortOrder.Ascending : SortOrder.Desending;
            typenum = sfm.getInt32("3rdType", def: 0);
            ret._3rdType = MusicSortTypeLister.getSortType(typenum);
            ret._3rdOrder = sfm.getBool("3rdOrder", def: true) ? SortOrder.Ascending : SortOrder.Desending;
            typenum = sfm.getInt32("4thType", def: 0);
            ret._4thType = MusicSortTypeLister.getSortType(typenum);
            ret._4thOrder = sfm.getBool("4thOrder", def: true) ? SortOrder.Ascending : SortOrder.Desending;
            typenum = sfm.getInt32("5thType", def: 0);
            ret._5thType = MusicSortTypeLister.getSortType(typenum);
            ret._5thOrder = sfm.getBool("5thOrder", def: true) ? SortOrder.Ascending : SortOrder.Desending;
            return ret;
        }
        return nil
    }
    
    static func readMyListCount() -> (Int32) {
        if let sfm: SettingFileManager = SettingFileManager(fileName: "MyListSetting.txt") {
            return sfm.getInt32("MyListCount", def: 0);
        }
        return 0
    }
    
    static func saveMyListCount(_ myListCount: Int32) {
        let sfm: SettingFileManager = SettingFileManager(fileName: "MyListSetting.txt", force: true)
        sfm.putInt32("MyListCount", value: myListCount)
        sfm.save()
    }
    
    static func saveMyListName(_ id: Int32, name: String) {
        let sfm: SettingFileManager = SettingFileManager(fileName: "MyListSetting.txt", force: true)
        sfm.putString("MyListName"+id.description, value: name)
        sfm.save()
    }
    
    static func readMyListName(_ id: Int32) -> (String?) {
        if let sfm: SettingFileManager = SettingFileManager(fileName: "MyListSetting.txt") {
            if let name = sfm.getString("MyListName"+id.description) {
                return name
            }
        }
        return nil
    }
    
    static func deleteMyList(_ id: Int32) {
        let count: Int32 = readMyListCount();
        for i in id+1 ..< count {
            let idx: Int32 = Int32(i)
            let myListName: String = readMyListName(idx)!;
            let myList: [UniquePattern] = readMyList(idx);
            saveMyListName(idx-1, name: myListName);
            saveMyList(idx-1, list: myList);
        }
        saveMyListName(count-1, name: "");
        saveMyList(count-1, list: [UniquePattern]());
        saveMyListCount(count-1);
    }
    
    static func readMyList(_ id: Int32) -> ([UniquePattern]) {
        var ret: [UniquePattern] = [UniquePattern]();
        if let sfm: SettingFileManager = SettingFileManager(fileName: "MyList_"+id.description+".txt") {
            let count: Int32 = sfm.getInt32("PatternCount", def: 0);
            for i: Int32 in 0 ..< count {
                let idx: Int32 = Int32(i)
                let musicId: Int32 = sfm.getInt32("Id"+idx.description, def: 0);
                let patnum: Int32 = sfm.getInt32("Pattern"+idx.description, def: 0);
                let patternType: PatternType = PatternTypeLister.getPatternType(patnum);
                var pat: UniquePattern = UniquePattern();
                pat.MusicId = musicId;
                pat.Pattern = patternType;
                ret.append(pat);
            }
            return ret;
        }
        return ret
    }
    
    static func saveMyList(_ id: Int32, list: [UniquePattern]) {
        let sfm: SettingFileManager = SettingFileManager(fileName: "MyList_"+id.description+".txt", force: true)
        let count: Int32 = Int32(list.count);
        sfm.putInt32("PatternCount", value: count);
        for i: Int32 in 0 ..< count {
            let up: UniquePattern = list[Int(i)];
            sfm.putInt32("Id"+i.description, value: up.MusicId);
            let patnum: Int32 = PatternTypeLister.getPatternTypeNum(up.Pattern);
            sfm.putInt32("Pattern"+i.description, value: patnum);
        }
        sfm.save()
    }
}
