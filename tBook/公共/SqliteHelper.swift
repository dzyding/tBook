//
//  SqliteHelper.swift
//  tBook
//
//  Created by dzy_PC on 2018/5/24.
//  Copyright © 2018年 dzy_person. All rights reserved.
//

import Foundation

enum QueryType {
    case today      (start: String)                 //当天
    case section    (start: String, end: String)    //区间
    case previous   (end: String)                   //(-, end]
    case all                                        //全部
}

let USERS = Table("infos")
let GUID  = Expression<Int64>("guid")
let TYPE  = Expression<Int>("type")
let START = Expression<String?>("start")
let END   = Expression<String?>("end")
let TIME  = Expression<Int?>("time")
let TAG   = Expression<String?>("tag")

struct SqliteHelper {
    
    let DB_path = (NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? "") + "/tBook.sqlite3"
    
    static let `default` = SqliteHelper()
    
    //MARK: - 创建
    func db_create() {
        do {
            print(DB_path)
            try Connection(DB_path).run(USERS.create { t in
                t.column(GUID, primaryKey: true)
                t.column(TYPE)
                t.column(START)
                t.column(END)
                t.column(TIME)
                t.column(TAG)
            })
        }catch let error {
            dzy_log(error)
        }
    }
    
    //MARK: - 插入数据
    func db_insert(_ model: InfoModel) {
        guard let guidMsg = model.guid else {return}
        guard let typeMsg = model.type?.rawValue else {return}
        do {
            let inset = USERS.insert(
                GUID    <- guidMsg,
                TYPE    <- typeMsg,
                START   <- model.start,
                END     <- model.end,
                TIME    <- model.time,
                TAG     <- model.tag
            )
            try Connection(DB_path).run(inset)
        }catch let error {
            dzy_log(error)
        }
    }
    
    //MARK: - 查找
    //获取总数
    func db_total() -> Int {
        var count = 0
        do {
            count = try Connection(DB_path).scalar(USERS.count)
        }catch let error {
            dzy_log(error)
        }
        return count
    }
    
    ///查找最后一条数据 -1 为没有数据
    func db_lastGuid() -> Int64 {
        var guid: Int64 = -1
        do {
            if let temp = try Connection(DB_path)
                .scalar("SELECT * FROM infos ORDER BY guid DESC LIMIT 1;") as? Int64
            {
                guid = temp
            }
        }catch let error {
            dzy_log(error)
        }
        return guid
    }
    
    //自定义查找
    func db_searchFromBool(_ predicate: Expression<Bool>) -> [InfoModel] {
        var result: [InfoModel] = []
        do {
            result = try Connection(DB_path)
                .prepare(USERS.filter(predicate))
                .compactMap({ (item) -> InfoModel in
                    var model = InfoModel()
                    model.end   = item[END]
                    model.guid  = item[GUID]
                    model.start = item[START]
                    model.time  = item[TIME]
                    model.tag   = item[TAG]
                    model.type  = InfoType(rawValue: item[TYPE])
                    return model
                })
                .reversed()
        }catch let error {
            dzy_error(error.localizedDescription)
        }
        return result
    }
    
    //根据时间来查找
    func db_searchFromDate(start: String? = nil, end: String? = nil) -> [InfoModel] {
        var type: QueryType?
        if let start = start,
            let end = end
        {
            // 区间查找
            type = .section(start: start, end: end)
        }else if let start = start {
            // 查找今天的数据
            type = .today(start: start)
        }else if let end = end {
            // 查找某一时间点之前的数据
            type = .previous(end: end)
        }else {
            // 查找所有数据
            type = .all
        }
        if let t = type {
            return db_searchFromDateBase(t)
        }else {
            return []
        }
    }
    
    func db_searchFromDateBase(_ type: QueryType) -> [InfoModel] {
        var result: [InfoModel] = []
        do {
            let db = try Connection(DB_path)
            var que:AnySequence<Row>?
            switch type {
            case .section(let start, let end):
                que = try db.prepare(USERS.filter(START >= start && START <= end))
            case .today(let start):
                que = try db.prepare(USERS.filter(START > start))
            case .previous(let end):
                que = try db.prepare(USERS.filter(START < end))
            default:
                que = try db.prepare(USERS)
            }
            if let que = que {
                result = que.reversed().compactMap({ (item) -> InfoModel in
                    var model = InfoModel()
                    model.end   = item[END]
                    model.guid  = item[GUID]
                    model.start = item[START]
                    model.time  = item[TIME]
                    model.tag   = item[TAG]
                    model.type  = InfoType(rawValue: item[TYPE])
                    return model
                })
            }
        }catch let error {
            dzy_error(error.localizedDescription)
        }
        return result
    }
    
    //MARK: - 更新
    @discardableResult
    func db_update(_ model: InfoModel) -> Bool {
        guard let guid = model.guid else {return false}
        guard let type = model.type?.rawValue else {return false}
        var result = 0
        do {
            let item = USERS.filter(GUID == guid)
            result = try Connection(DB_path).run(item.update([
                GUID    <- guid,
                TYPE    <- type,
                START   <- model.start,
                END     <- model.end,
                TIME    <- model.time,
                TAG     <- model.tag
                ]))
        }catch let error {
            dzy_log(error)
        }
        return result > 0 ? true : false
    }
    
    //MARK: - 删除
    //根据 model 删除
    @discardableResult
    func db_deleteModel(_ model: InfoModel) -> Bool {
        guard let guid = model.guid else {return false}
        var result: Int = 0
        do {
            let item = USERS.filter(GUID == guid)
            result = try Connection(DB_path).run(item.delete())
        }catch let error {
            dzy_log(error)
        }
        return result > 0 ? true : false
    }
    
    //自定义删除
    @discardableResult
    func db_deleteBool(_ predicate: Expression<Bool?>) -> Bool {
        var result: Int = 0
        do {
            let item = USERS.filter(predicate)
            result = try Connection(DB_path).run(item.delete())
        }catch let error {
            dzy_log(error)
        }
        return result > 0 ? true : false
    }
}


