//
//  E7Public.swift
//  EFOOD7
//
//  Created by 森泓投资 on 2017/5/23.
//  Copyright © 2017年 EFOOD7. All rights reserved.
//

import Foundation
import UIKit

@_exported import SnapKit
@_exported import SQLite
@_exported import RxSwift
@_exported import RxCocoa
@_exported import RxDataSources

enum DzyError : Error {
    case Error_FilePath
}

#if DEBUG
    public let BasicUrl = "http://118.178.138.133:1666/"
    
    public let WxUrl = "http://118.178.138.133:1777/"
#else
    public let BasicUrl = "https://api.qijiaoxing.com/"
    
    public let WxUrl = "https://m.qijiaoxing.com/"
#endif

public let Hud_Time: TimeInterval = 2.0

public let FONT_BLACK = RGB(r: 51.0, g: 51.0, b: 51.0)

public let FONT_DARKGRAY = RGB(r: 134.0, g: 134.0, b: 134.0) //868686

public let FONT_LIGHTGRAY = RGB(r: 153.0, g: 153.0, b: 153.0) //999999

public let BACKGROUND_DARKGRAY = RGB(r: 220.0, g: 220.0, b: 220.0) //dcdcdc

public let BACKGROUND_GRAY = RGB(r: 236.0, g: 236.0, b: 236.0)

public let BACKGROUND_LIGHTGRAY = RGB(r: 250.0, g: 250.0, b: 250.0)

public let MAIN_COLOR = RGB(r: 117.0, g: 156.0, b: 221.0)

public let COLOR_WORK = RGBA(r: 254.0, g: 128.0, b: 131.0, a: 1)

public let COLOR_FAMILY = RGBA(r: 186.0, g: 175.0, b: 254.0, a: 1)

public let COLOR_HEALTH = RGBA(r: 46.0, g: 206.0, b: 178.0, a: 1)

public let COLOR_OTHER = RGBA(r: 122.0, g: 173.0, b: 255.0, a: 1)

public let COLOR_PLAY = RGBA(r: 253.0, g: 190.0, b: 84.0, a: 1)

public let COLOR_L_BLUE = RGB(r: 168.0, g: 193.0, b: 237.0)

public let LINE_LIGHT = RGB(r: 230.0, g: 230.0, b: 230.0)

public let LINE_DARK = RGB(r: 212.0, g: 209.0, b: 209.0)
