//
//  SettingFileManager.swift
//  dsm
//
//  Created by LinaNfinE on 6/11/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit

class SettingFileManager {
    fileprivate func escape(_ src: String) -> (String) {
        return src.replacingOccurrences(of: "%", with: "%%", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "=", with: "%(equals)", options: NSString.CompareOptions.literal, range: nil)
    }
    fileprivate func descape(_ src: String) -> (String) {
        return src.replacingOccurrences(of: "%(equals)", with: "=", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "%%", with: "%", options: NSString.CompareOptions.literal, range: nil)
    }
    let mLibraryDirPath: String
    let mFileName: String
    var mData: [String : String] = [:]
    init?(fileName: String) {
        mLibraryDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] 
        mFileName = fileName
        let nstr: NSString? = try? NSString(contentsOfFile: (mLibraryDirPath as NSString).appendingPathComponent(mFileName), encoding: String.Encoding.utf8.rawValue)
        if nstr == nil {
            return nil
        }
        let str: String = nstr! as String
        str.enumerateLines{
            line, stop in
            let sp: [String] = line.components(separatedBy: "=")
            var key: String = ""
            var value: String = ""
            for (index, spd) in sp.enumerated() {
                switch index{
                case 0:
                    key = self.descape(spd)
                case 1:
                    value = self.descape(spd)
                default:
                    break
                }
            }
            self.mData[key] = value
        }
    }
    init(fileName: String, force: Bool) {
        mLibraryDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] 
        mFileName = fileName
        let nstr: NSString? = try? NSString(contentsOfFile: (mLibraryDirPath as NSString).appendingPathComponent(mFileName), encoding: String.Encoding.utf8.rawValue)
        if nstr == nil {
            return
        }
        let str: String = nstr! as String
        str.enumerateLines{
            line, stop in
            let sp: [String] = line.components(separatedBy: "=")
            var key: String = ""
            var value: String = ""
            for (index, spd) in sp.enumerated() {
                switch index{
                case 0:
                    key = self.descape(spd)
                case 1:
                    value = self.descape(spd)
                default:
                    break
                }
            }
            self.mData[key] = value
        }
    }
    func save() {
        var str: String = ""
        for data in mData {
            str += escape(data.0)+"="+escape(data.1)+"\n"
        }
        do {
            try str.write(toFile: (mLibraryDirPath as NSString).appendingPathComponent(mFileName), atomically: true, encoding: String.Encoding.utf8)
        } catch _ {
        }
    }
    func putString(_ key: String, value: String) {
        mData[key] = value
    }
    func getString(_ key: String) -> (String?) {
        return mData[key]
    }
    func getString(_ key: String, def: String) -> (String) {
        if let d = getString(key) {
            return d
        }
        return def
    }
    func putInt32(_ key: String, value: Int32) {
        mData[key] = value.description
    }
    func getInt32(_ key: String) -> (Int32?) {
        if let datas: String = mData[key] {
        if let data: Int = Int(datas) {
            return Int32(data)
        }
        }
        return nil
    }
    func getInt32(_ key: String, def: Int32) -> (Int32) {
        if let d: Int32 = getInt32(key) {
            return d
        }
        return def
    }
    func putInt(_ key: String, value: Int) {
        mData[key] = value.description
    }
    func getInt(_ key: String) -> (Int?) {
        if let datas: String = mData[key] {
        if let data: Int = Int(datas) {
            return data
        }
        }
        return nil
    }
    func getInt(_ key: String, def: Int) -> (Int) {
        if let d: Int = getInt(key) {
            return d
        }
        return def
    }
    func putBool(_ key: String, value: Bool) {
        mData[key] = value ? "true" : "false"
    }
    func getBool(_ key: String) -> (Bool?) {
        if let data: String = mData[key] {
            return data == "true" ? true : data == "false" ? false : nil
        }
        return nil
    }
    func getBool(_ key: String, def: Bool) -> (Bool) {
        if let d: Bool = getBool(key) {
            return d
        }
        return def
    }
}
