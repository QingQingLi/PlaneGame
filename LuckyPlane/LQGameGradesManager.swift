//
//  LQGameGradesManager.swift
//  LuckyPlane
//
//  Created by 魔曦 on 2017/10/3.
//  Copyright © 2017年 魔曦. All rights reserved.
//

import UIKit
import Foundation

class LQGameGradesManager: NSObject {

    static let manager = LQGameGradesManager.init()
    private override init() {}
    
//    func manager() -> LQGameGradesManager {
//        let manager = LQGameGradesManager.init()
//        return manager
//    }
    
    func saveScores(_ scores : Int) {
        
        UserDefaults.standard.set(scores, forKey: "score")
        UserDefaults.standard.synchronize()
    }
    
    func getGameLevel() -> Int {
        
        let scores = UserDefaults.standard.integer(forKey: "score")
        
        if scores <= 20000{
            return 0
        }
        
        if scores  >= 100000{
            return 5
        }
        
        return scores/20000
        
    }
    
}
