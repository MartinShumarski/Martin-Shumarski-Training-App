//
//  Variables.swift
//  Martin Shumarski Training App
//
//  Created by Martin Shumarski on 29.07.19.
//  Copyright © 2019 Martin Shumarski. All rights reserved.
//

import Foundation
import Leanplum

struct Variables {
    
    static var orangeColor : LPVar?
    static var greenColor : LPVar?

    
    static func initLPVariables () {
        
        orangeColor = LPVar.define("colorsLabel", with: UIColor.white)
        
        
    }
    
    
}
