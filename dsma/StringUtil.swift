//
//  StringUtil.swift
//  dsm
//
//  Created by LinaNfinE on 6/6/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
import Foundation


struct StringUtil{
    
    // ０ならログイン済み
    static func checkLoggedIn(_ src: String) -> (Int) {
        let cmpNoLoginCheck: String = "<div class=\"name_str\">---</div>";
        //ログインせずにスコアページを表示のとき
        print(src.contains(cmpNoLoginCheck))
        print(isLoginForm(src))
        return src.contains(cmpNoLoginCheck) ? 1 : isLoginForm(src) ? 1 : 0;
    }
    
    static func isLoginForm(_ src: String) -> (Bool) {
        let cmpLoginForm: String = "otp.act.10";
        //print(src)
        return src.contains(cmpLoginForm)
    }
    
    static func textFromCopyFormat(_ format: String, targetPattern: UniquePattern, targetMusicData: MusicData, targetScoreData: ScoreData) -> String {
        var ret: String = ""
        let sps = format.components(separatedBy: "%")
        for index in 0 ..< sps.count {
            if index % 2 == 0 {
                ret = ret + sps[index]
            }
            else if index == sps.count - 1 {
                
            }
            else if sps[index].count == 0 {
                ret = ret + "%"
            }
            else {
                switch sps[index][sps[index].startIndex..<sps[index].index(sps[index].startIndex, offsetBy: 1)] {
                case "t": ret = ret + targetMusicData.Name; break;
                case "p":
                    let fms = sps[index].components(separatedBy: ":")
                    switch targetPattern.Pattern {
                    case .bSP: ret = ret + (fms.count > 1 ? fms[1] : "b"); break;
                    case .BSP: ret = ret + (fms.count > 2 ? fms[2] : "B"); break;
                    case .DSP: ret = ret + (fms.count > 3 ? fms[3] : "D"); break;
                    case .ESP: ret = ret + (fms.count > 4 ? fms[4] : "E"); break;
                    case .CSP: ret = ret + (fms.count > 5 ? fms[5] : "C"); break;
                    case .BDP: ret = ret + (fms.count > 2 ? fms[2] : "B"); break;
                    case .DDP: ret = ret + (fms.count > 3 ? fms[3] : "D"); break;
                    case .EDP: ret = ret + (fms.count > 4 ? fms[4] : "E"); break;
                    case .CDP: ret = ret + (fms.count > 5 ? fms[5] : "C"); break;
                    }
                    break;
                case "y":
                    let fms = sps[index].components(separatedBy: ":")
                    switch targetPattern.Pattern {
                    case .bSP: ret = ret + (fms.count > 1 ? fms[1] : "SP"); break;
                    case .BSP: ret = ret + (fms.count > 1 ? fms[1] : "SP"); break;
                    case .DSP: ret = ret + (fms.count > 1 ? fms[1] : "SP"); break;
                    case .ESP: ret = ret + (fms.count > 1 ? fms[1] : "SP"); break;
                    case .CSP: ret = ret + (fms.count > 1 ? fms[1] : "SP"); break;
                    case .BDP: ret = ret + (fms.count > 2 ? fms[2] : "DP"); break;
                    case .DDP: ret = ret + (fms.count > 2 ? fms[2] : "DP"); break;
                    case .EDP: ret = ret + (fms.count > 2 ? fms[2] : "DP"); break;
                    case .CDP: ret = ret + (fms.count > 2 ? fms[2] : "DP"); break;
                    }
                    break;
                case "s":
                    let zero = sps[index].contains("0")
                    let space = sps[index].contains(" ")
                    let comma = sps[index].contains(",")
                    var num = targetScoreData.Score
                    var tmp = ""
                    var keta = 0
                    repeat {
                        if comma && (keta == 3 || keta == 6) {
                            tmp = "," + tmp
                        }
                        keta = keta + 1
                        if num == 0 {
                            tmp = (space ? " " : zero ? "0" : "") + tmp
                        }
                        else {
                            tmp = (num % 10).description + tmp
                            num = num / 10
                        }
                    } while zero || space ? keta < 7 :  num > 0
                    ret = ret + tmp
                    break;
                case "d":
                    let zero = sps[index].contains("0")
                    let space = sps[index].contains(" ")
                    var num = targetMusicData.getDifficulty(targetPattern.Pattern)
                    var tmp = ""
                    var keta = 0
                    repeat {
                        keta = keta + 1
                        if num == 0 {
                            tmp = (space ? " " : zero ? "0" : "") + tmp
                        }
                        else {
                            tmp = (num % 10).description + tmp
                            num = num / 10
                        }
                    } while zero || space ? keta < 2 :  num > 0
                    ret = ret + tmp
                case "c":
                    let zero = sps[index].contains("0")
                    let space = sps[index].contains(" ")
                    var num = targetScoreData.MaxCombo
                    var tmp = ""
                    var keta = 0
                    repeat {
                        keta = keta + 1
                        if num == 0 {
                            tmp = (space ? " " : zero ? "0" : "") + tmp
                        }
                        else {
                            tmp = (num % 10).description + tmp
                            num = num / 10
                        }
                    } while zero || space ? keta < 3 :  num > 0
                    ret = ret + tmp
                    break;
                case "e":
                    let zero = sps[index].contains("0")
                    let space = sps[index].contains(" ")
                    var num = targetScoreData.ClearCount
                    var tmp = ""
                    var keta = 0
                    repeat {
                        keta = keta + 1
                        if num == 0 {
                            tmp = (space ? " " : zero ? "0" : "") + tmp
                        }
                        else {
                            tmp = (num % 10).description + tmp
                            num = num / 10
                        }
                    } while zero || space ? keta < 4 :  num > 0
                    ret = ret + tmp
                    break;
                case "a":
                    let zero = sps[index].contains("0")
                    let space = sps[index].contains(" ")
                    var num = targetScoreData.PlayCount
                    var tmp = ""
                    var keta = 0
                    repeat {
                        keta = keta + 1
                        if num == 0 {
                            tmp = (space ? " " : zero ? "0" : "") + tmp
                        }
                        else {
                            tmp = (num % 10).description + tmp
                            num = num / 10
                        }
                    } while zero || space ? keta < 4 :  num > 0
                    ret = ret + tmp
                    break;
                case "l":
                    let fms = sps[index].components(separatedBy: ":")
                    switch targetScoreData.Rank {
                    case .AAA: ret = ret + (fms.count > 1 ? fms[1] : "AAA"); break;
                    case .AAp: ret = ret + (fms.count > 2 ? fms[2] : "AA+"); break;
                    case .AA: ret = ret + (fms.count > 3 ? fms[3] : "AA"); break;
                    case .AAm: ret = ret + (fms.count > 4 ? fms[4] : "AA-"); break;
                    case .Ap: ret = ret + (fms.count > 5 ? fms[5] : "A+"); break;
                    case .A: ret = ret + (fms.count > 6 ? fms[6] : "A"); break;
                    case .Am: ret = ret + (fms.count > 7 ? fms[7] : "A-"); break;
                    case .Bp: ret = ret + (fms.count > 8 ? fms[8] : "B+"); break;
                    case .B: ret = ret + (fms.count > 9 ? fms[9] : "B"); break;
                    case .Bm: ret = ret + (fms.count > 10 ? fms[10] : "B-"); break;
                    case .Cp: ret = ret + (fms.count > 11 ? fms[11] : "C+"); break;
                    case .C: ret = ret + (fms.count > 12 ? fms[12] : "C"); break;
                    case .Cm: ret = ret + (fms.count > 13 ? fms[13] : "C-"); break;
                    case .Dp: ret = ret + (fms.count > 14 ? fms[14] : "D+"); break;
                    case .D: ret = ret + (fms.count > 15 ? fms[15] : "D"); break;
                    case .E: ret = ret + (fms.count > 16 ? fms[16] : "E"); break;
                    case .Noplay: ret = ret + (fms.count > 17 ? fms[17] : "-"); break;
                    }
                    break;
                case "f":
                    let fms = sps[index].components(separatedBy: ":")
                    switch targetScoreData.FullComboType_ {
                    case .MarvelousFullCombo: ret = ret + (fms.count > 1 ? fms[1] : "MFC"); break;
                    case .PerfectFullCombo: ret = ret + (fms.count > 2 ? fms[2] : "PFC"); break;
                    case .FullCombo: ret = ret + (fms.count > 3 ? fms[3] : "FC"); break;
                    case .GoodFullCombo: ret = ret + (fms.count > 4 ? fms[4] : "GFC"); break;
                    case .Life4: ret = ret + (fms.count > 5 ? fms[5] : "Life4"); break;
                    case .None: ret = ret + (fms.count > 6 ? fms[6] : "NoFC"); break;
                    }
                    break;
                default: break;
                }
            }
        }
        return ret
    }
    
    static func toCommaFormattedString(_ number: Int32) ->(String){
        let format: NumberFormatter = NumberFormatter()
        format.numberStyle = NumberFormatter.Style.decimal
        format.groupingSeparator = ","
        format.groupingSize = 3
        return format.string(for: NSNumber(value: number as Int32))!
    }
    
    static func getScoreBackupText(_ id: Int32, scores: [Int32 : MusicScore]) -> (String) {
        
        var ret: String = ""
        
        if let score: MusicScore = scores[id] {
            ret += id.description;
            ret += "\t";
            ret += score.bSP.Rank.rawValue;
            ret += "\t";
            ret += score.bSP.Score.description;
            ret += "\t";
            ret += score.bSP.FullComboType_.rawValue;
            ret += "\t";
            ret += score.bSP.MaxCombo.description;
            ret += "\t";
            ret += score.BSP.Rank.rawValue;
            ret += "\t";
            ret += score.BSP.Score.description;
            ret += "\t";
            ret += score.BSP.FullComboType_.rawValue;
            ret += "\t";
            ret += score.BSP.MaxCombo.description;
            ret += "\t";
            ret += score.DSP.Rank.rawValue;
            ret += "\t";
            ret += score.DSP.Score.description;
            ret += "\t";
            ret += score.DSP.FullComboType_.rawValue;
            ret += "\t";
            ret += score.DSP.MaxCombo.description;
            ret += "\t";
            ret += score.ESP.Rank.rawValue;
            ret += "\t";
            ret += score.ESP.Score.description;
            ret += "\t";
            ret += score.ESP.FullComboType_.rawValue;
            ret += "\t";
            ret += score.ESP.MaxCombo.description;
            ret += "\t";
            ret += score.CSP.Rank.rawValue;
            ret += "\t";
            ret += score.CSP.Score.description;
            ret += "\t";
            ret += score.CSP.FullComboType_.rawValue;
            ret += "\t";
            ret += score.CSP.MaxCombo.description;
            ret += "\t";
            ret += score.BDP.Rank.rawValue;
            ret += "\t";
            ret += score.BDP.Score.description;
            ret += "\t";
            ret += score.BDP.FullComboType_.rawValue;
            ret += "\t";
            ret += score.BDP.MaxCombo.description;
            ret += "\t";
            ret += score.DDP.Rank.rawValue;
            ret += "\t";
            ret += score.DDP.Score.description;
            ret += "\t";
            ret += score.DDP.FullComboType_.rawValue;
            ret += "\t";
            ret += score.DDP.MaxCombo.description;
            ret += "\t";
            ret += score.EDP.Rank.rawValue;
            ret += "\t";
            ret += score.EDP.Score.description;
            ret += "\t";
            ret += score.EDP.FullComboType_.rawValue;
            ret += "\t";
            ret += score.EDP.MaxCombo.description;
            ret += "\t";
            ret += score.CDP.Rank.rawValue;
            ret += "\t";
            ret += score.CDP.Score.description;
            ret += "\t";
            ret += score.CDP.FullComboType_.rawValue;
            ret += "\t";
            ret += score.CDP.MaxCombo.description;
            ret += "\t";
            ret += score.bSP.PlayCount.description;
            ret += "\t";
            ret += score.bSP.ClearCount.description;
            ret += "\t";
            ret += score.BSP.PlayCount.description;
            ret += "\t";
            ret += score.BSP.ClearCount.description;
            ret += "\t";
            ret += score.DSP.PlayCount.description;
            ret += "\t";
            ret += score.DSP.ClearCount.description;
            ret += "\t";
            ret += score.ESP.PlayCount.description;
            ret += "\t";
            ret += score.ESP.ClearCount.description;
            ret += "\t";
            ret += score.CSP.PlayCount.description;
            ret += "\t";
            ret += score.CSP.ClearCount.description;
            ret += "\t";
            ret += score.BDP.PlayCount.description;
            ret += "\t";
            ret += score.BDP.ClearCount.description;
            ret += "\t";
            ret += score.DDP.PlayCount.description;
            ret += "\t";
            ret += score.DDP.ClearCount.description;
            ret += "\t";
            ret += score.EDP.PlayCount.description;
            ret += "\t";
            ret += score.EDP.ClearCount.description;
            ret += "\t";
            ret += score.CDP.PlayCount.description;
            ret += "\t";
            ret += score.CDP.ClearCount.description;
        }
        
        return ret;
        
    }
    static func getSaExportText(_ id: Int32, scores: [Int32 : MusicScore]) -> (String) {
        
        var ret: String = ""
        
        ret = ret + id.description
        ret = ret + "\t"
        if let score: MusicScore = scores[id] {
            ret = ret + score.bSP.Rank.rawValue
            ret = ret + "\t"
            ret = ret + score.bSP.Score.description
            ret = ret + "\t"
            ret = ret + score.bSP.FullComboType_.rawValue
            ret = ret + "\t"
            ret = ret + score.bSP.MaxCombo.description
            ret = ret + "\t"
            ret = ret + score.BSP.Rank.rawValue
            ret = ret + "\t"
            ret = ret + score.BSP.Score.description
            ret = ret + "\t"
            ret = ret + score.BSP.FullComboType_.rawValue
            ret = ret + "\t"
            ret = ret + score.BSP.MaxCombo.description
            ret = ret + "\t"
            ret = ret + score.DSP.Rank.rawValue
            ret = ret + "\t"
            ret = ret + score.DSP.Score.description
            ret = ret + "\t"
            ret = ret + score.DSP.FullComboType_.rawValue
            ret = ret + "\t"
            ret = ret + score.DSP.MaxCombo.description
            ret = ret + "\t"
            ret = ret + score.ESP.Rank.rawValue
            ret = ret + "\t"
            ret = ret + score.ESP.Score.description
            ret = ret + "\t"
            ret = ret + score.ESP.FullComboType_.rawValue
            ret = ret + "\t"
            ret = ret + score.ESP.MaxCombo.description
            ret = ret + "\t"
            ret = ret + score.CSP.Rank.rawValue
            ret = ret + "\t"
            ret = ret + score.CSP.Score.description
            ret = ret + "\t"
            ret = ret + score.CSP.FullComboType_.rawValue
            ret = ret + "\t"
            ret = ret + score.CSP.MaxCombo.description
            ret = ret + "\t"
            ret = ret + score.BDP.Rank.rawValue
            ret = ret + "\t"
            ret = ret + score.BDP.Score.description
            ret = ret + "\t"
            ret = ret + score.BDP.FullComboType_.rawValue
            ret = ret + "\t"
            ret = ret + score.BDP.MaxCombo.description
            ret = ret + "\t"
            ret = ret + score.DDP.Rank.rawValue
            ret = ret + "\t"
            ret = ret + score.DDP.Score.description
            ret = ret + "\t"
            ret = ret + score.DDP.FullComboType_.rawValue
            ret = ret + "\t"
            ret = ret + score.DDP.MaxCombo.description
            ret = ret + "\t"
            ret = ret + score.EDP.Rank.rawValue
            ret = ret + "\t"
            ret = ret + score.EDP.Score.description
            ret = ret + "\t"
            ret = ret + score.EDP.FullComboType_.rawValue
            ret = ret + "\t"
            ret = ret + score.EDP.MaxCombo.description
            ret = ret + "\t"
            ret = ret + score.CDP.Rank.rawValue
            ret = ret + "\t"
            ret = ret + score.CDP.Score.description
            ret = ret + "\t"
            ret = ret + score.CDP.FullComboType_.rawValue
            ret = ret + "\t"
            ret = ret + score.CDP.MaxCombo.description
        }
        
        return ret
    }
}
