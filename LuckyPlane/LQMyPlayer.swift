//
//  LQMyPlayer.swift
//  LuckyPlane
//
//  Created by 魔曦 on 2017/9/26.
//  Copyright © 2017年 魔曦. All rights reserved.
//

import UIKit
import SpriteKit

class LQMyPlayer: SKSpriteNode {

    var player : LQPlayer = LQPlayer()
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
     
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")

    }
}
