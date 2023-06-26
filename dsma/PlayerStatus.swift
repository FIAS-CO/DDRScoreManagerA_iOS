//
//  PlayerStatus.swift
//  dsm
//
//  Created by LinaNfinE on 9/11/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

struct PlayerStatus {
    
    var SingleMgrStream: Int32 = 0
    var SingleMgrVoltage: Int32 = 0
    var SingleMgrAir: Int32 = 0
    var SingleMgrFreeze: Int32 = 0
    var SingleMgrChaos: Int32 = 0
    
    var DoubleMgrStream: Int32 = 0
    var DoubleMgrVoltage: Int32 = 0
    var DoubleMgrAir: Int32 = 0
    var DoubleMgrFreeze: Int32 = 0
    var DoubleMgrChaos: Int32 = 0
    
    var DancerName: String = ""
    var DdrCode: String = ""
    var Todofuken: String = ""
    var EnjoyLevel: Int32 = 0
    var EnjoyLevelNextExp: Int32 = 0
    var PlayCount: Int32 = 0
    var LastPlay: String = ""

    var SingleShougou: String = ""
    var SinglePlayCount: Int32 = 0
    var SingleLastPlay: String = ""
    
    var DoubleShougou: String = ""
    var DoublePlayCount: Int32 = 0
    var DoubleLastPlay: String = ""
}