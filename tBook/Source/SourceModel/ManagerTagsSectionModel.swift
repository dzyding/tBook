//
//  ManagerTagsSectionModel.swift
//  tBook
//
//  Created by dzy_PC on 2018/6/26.
//  Copyright © 2018年 dzy_person. All rights reserved.
//

import Foundation

struct ManagerTagsSectionModel {
    var title: String
    var items: [Item]
}

extension ManagerTagsSectionModel: SectionModelType {
    
    typealias Item = ManagerTagsItemModel
    
    init(original: ManagerTagsSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

/*
enum ManagerTagsSectionModel {
    case normalSection(title: String, items: [ManagerTagsItemModel])
}

extension ManagerTagsSectionModel: SectionModelType {
    
    typealias Item = ManagerTagsItemModel
    
    var items: [Item] {
        switch self {
        case .normalSection(title: _, items: let items):
            return items
        }
    }
    
    init(original: ManagerTagsSectionModel, items: [Item]) {
        switch original {
        case let .normalSection(title: title, items: _):
            self = .normalSection(title: title, items: items)
        }
    }
}

extension ManagerTagsSectionModel {
    var title: String {
        switch self {
        case let .normalSection(title: title, items: _):
            return title
        }
    }
}
*/
