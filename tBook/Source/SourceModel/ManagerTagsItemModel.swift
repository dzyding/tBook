//
//  ManagerTagsItemModel.swift
//  tBook
//
//  Created by dzy_PC on 2018/6/26.
//  Copyright © 2018年 dzy_person. All rights reserved.
//

import Foundation

enum TagsItemType {
    case normal
    case edit
    case add
}

struct ManagerTagsItemModel {
    var title: String?
    var cellType:  TagsItemType
}
