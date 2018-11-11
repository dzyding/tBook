//
//  InfoModel.swift
//  tBook
//
//  Created by dzy_PC on 2018/5/24.
//  Copyright © 2018年 dzy_person. All rights reserved.
//

import Foundation

@objc public enum InfoType: Int {
    case work    = 1
    case family
    case play
    case health
    case other
    
    var name: String {
        switch self {
        case .work:
            return "工作"
        case .family:
            return "家庭"
        case .play:
            return "娱乐"
        case .health:
            return "健康"
        case .other:
            return "其他"
        }
    }
    
    var color: UIColor {
        switch self {
        case .work:
            return COLOR_WORK
        case .family:
            return COLOR_FAMILY
        case .play:
            return COLOR_PLAY
        case .health:
            return COLOR_HEALTH
        case .other:
            return COLOR_OTHER
        }
    }
}

struct InfoModel {
    //唯一标示 从0开始渐增
    var guid:   Int64?
    //类型
    var type:   InfoType?
    //开始时间
    var start:  String?
    //结束时间
    var end:    String?
    //持续时长
    var time:   Int?
    //子分类
    var tag:    String?
}
