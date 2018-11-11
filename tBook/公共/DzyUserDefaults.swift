//
//  DzyUserDefaults.swift
//  170815_UserDefaults封装
//
//  Created by dzy_PC on 2017/8/15.
//  Copyright © 2017年 dzy_PC. All rights reserved.
//

import Foundation

fileprivate let Defaults = UserDefaults.standard

extension UserDefaults {
    
   fileprivate enum Keys: String {
        case tag_family = "tBook_Tag_Family"
        case tag_health = "tBook_Tag_Health"
        case tag_other  = "tBook_Tag_Other"
        case tag_work   = "tBook_Tag_Work"
        case tag_play   = "tBook_Tag_Play"
    }
    
    fileprivate subscript(key: Keys) -> [String : Any]? {
        set {
            set(newValue, forKey: key.rawValue)
        }
        get {
            return object(forKey: key.rawValue) as? [String : Any]
        }
    }
    
    fileprivate subscript(key: Keys) -> Bool? {
        set {
            set(newValue, forKey: key.rawValue)
        }
        get {
            return object(forKey: key.rawValue) as? Bool
        }
    }
    
    fileprivate subscript(key: Keys) -> String? {
        set {
            set(newValue, forKey: key.rawValue)
        }
        get {
             return object(forKey: key.rawValue) as? String
        }
    }
    
    fileprivate subscript(key: Keys) -> Int? {
        set {
            set(newValue, forKey: key.rawValue)
        }
        get {
            return object(forKey: key.rawValue) as? Int
        }
    }
    
    fileprivate subscript(key: Keys) -> Double? {
        set {
            set(newValue, forKey: key.rawValue)
        }
        get {
            return object(forKey: key.rawValue) as? Double
        }
    }
    
    fileprivate subscript(key: Keys) -> [String]? {
        set {
            set(newValue, forKey: key.rawValue)
        }
        get {
            return object(forKey: key.rawValue) as? [String]
        }
    }
    
    ///删除
    fileprivate func removeObject(key: Keys) {
        Defaults.removeObject(forKey: key.rawValue)
    }

//    MARK: -
    fileprivate static func clearAllUserMsg() {
        //这里没有删除汇率方面的信息
        Defaults.removeObject(key: .tag_play)
        Defaults.removeObject(key: .tag_work)
        Defaults.removeObject(key: .tag_other)
        Defaults.removeObject(key: .tag_family)
        Defaults.removeObject(key: .tag_health)
    }
}

public var Tags_Work: [String]? {
    get {
        return Defaults[.tag_work]
    }
    set {
        Defaults[.tag_work] = newValue
    }
}

public var Tags_Family: [String]? {
    get {
        return Defaults[.tag_family]
    }
    set {
        Defaults[.tag_family] = newValue
    }
}

public var Tags_Other: [String]? {
    get {
        return Defaults[.tag_other]
    }
    set {
        Defaults[.tag_other] = newValue
    }
}

public var Tags_Health: [String]? {
    get {
        return Defaults[.tag_health]
    }
    set {
        Defaults[.tag_health] = newValue
    }
}

public var Tags_Play: [String]? {
    get {
        return Defaults[.tag_play]
    }
    set {
        Defaults[.tag_play] = newValue
    }
}

public func tagsArr(_ type: InfoType) -> [String]? {
    switch type {
    case .family:
        return Tags_Family
    case .work:
        return Tags_Work
    case .health:
        return Tags_Health
    case .play:
        return Tags_Play
    case .other:
        return Tags_Other
    }
}

public func User_ClearUserMsg() {
    UserDefaults.clearAllUserMsg()
}


