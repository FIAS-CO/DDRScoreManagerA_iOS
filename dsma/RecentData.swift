//
//  RecentData.swift
//  dsma
//
//  Created by LinaNfinE on 4/11/16.
//  Copyright © 2016 LinaNfinE. All rights reserved.
//

import Swift

struct RecentData: Equatable {
    var Id: Int32
    var PatternType_: PatternType
}

func == (l: RecentData, r: RecentData) -> Bool {
    return l.Id == r.Id && l.PatternType_ == r.PatternType_
}
