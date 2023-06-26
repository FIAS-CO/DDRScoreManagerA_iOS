//
//  UniquePattern.swift
//  dsm
//
//  Created by LinaNfinE on 6/5/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

// jissou mikanryou

struct UniquePattern{// implements Comparable<UniquePattern> {
    var MusicId: Int32 = 0
    //var WebMusicIds: [Int32 : WebMusicId] = [:]
    var Pattern: PatternType = PatternType.bSP
    //var Comparer: MusicSort
    //var musics: [Int32 : MusicData] = [:]
    //var scores: [Int32 : MusicScore] = [:]
    var RivalName: String = ""
    //var rivalScores: [Int32 : MusicScore] = [:]
    //var Comment: String = ""
    
    //func compareTo(var arg0: UniquePattern) -> (Bool)
    //{
    //    return Comparer.compare(self, plusUniquePattern: arg0);
    //}
    
    func equals(_ target: UniquePattern) -> (Bool) {
        if target.MusicId != MusicId { return false }
        if target.Pattern != Pattern { return false }
        //if target.RivalName != RivalName { return false }
        //if target.Comment != Comment { return false }
        return true
    }
    
}
