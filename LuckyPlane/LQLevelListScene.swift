//
//  LQLevelListScene.swift
//  LuckyPlane
//
//  Created by 魔曦 on 2017/9/29.
//  Copyright © 2017年 魔曦. All rights reserved.
//

import UIKit
import SpriteKit

class LQLevelListScene: SKScene {

    var bgView : UIView?
    var backMoveNode : SKNode?

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.backMoveNode = SKNode()
        self.addChild(self.backMoveNode!)
        
        let texture = SKTexture(imageNamed: "bg0")
        texture.filteringMode = SKTextureFilteringMode.nearest
        let backnode = SKSpriteNode(color: .white, size: self.frame.size)
        backnode.zPosition = 0
        backnode.texture = texture
        backnode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backnode.name = "back"
        self.backMoveNode!.addChild(backnode)
        
        bgView = UIView(frame: (self.view?.bounds)!)
        bgView?.backgroundColor = .clear
        self.view?.addSubview(bgView!)
        
        let arr = [NSLocalizedString("一", comment: ""),NSLocalizedString("二", comment: ""),NSLocalizedString("三", comment: ""),NSLocalizedString("四", comment: ""),NSLocalizedString("五", comment: "")]
        
        var ration : Int = -1
        
        let color = UIColor.init(colorLiteralRed: 237/255.0, green: 137/255.0, blue: 52/255.0, alpha: 1.0)
        var x : CGFloat? = 0.0
        var y : CGFloat? = 0.0
        let space : Int = 60
        
        for i in 0 ... 4 {
            if i == 0 {
                x = self.frame.midX - 30
                y = self.frame.midY * 2 / 3.0
            }else if i < 3{
                y = self.frame.midY * 2 / 3.0 + (CGFloat)(space * 2)
                x = self.frame.midX - (CGFloat)(space  * 1 * ration) - 30
            }else if i < 5{
                y = self.frame.midY * 2 / 3.0 + (CGFloat)(space * 2 * 2)
                x = self.frame.midX - (CGFloat)(space  * 1 * ration) - 30
            }
            
            
//            let top : CGFloat? =  (CGFloat)(50 * i)
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: x!, y: y!, width:60 , height: 60)

//            button.frame = CGRect(x: 0, y: self.frame.midY * 2 / 3.0 + top!, width:60 , height: 60)
//            button.center.x = self.frame.midX + (CGFloat)(ration * 50)
//            button.setBackgroundImage(UIImage(named : ""), for: .normal)
            button.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            button.layer.cornerRadius = 10.0
            button.layer.borderWidth = 1.0
            button.setTitle(arr[i], for: .normal)
            if i == LQGameGradesManager.manager.getGameLevel() - 1 {
                button.setTitleColor(color, for: .normal)
            }else{
                button.setTitleColor(UIColor.lightGray, for: .normal)
            }
            button.titleLabel?.font = UIFont.init(name: "【何尼玛】土肥圆", size: 30)//UIFont.systemFont(ofSize: 30)
            button.tag = 100 + i
            bgView?.addSubview(button)
            button.addTarget(self, action: #selector(LQLevelListScene.gotoGame(btn:)), for: .touchUpInside)
            
            if (i - 1) % 2 == 0 {
            }
            ration = ration * -1

        }
    }
    
    func gotoGame(btn : UIButton) {
      let tag = btn.tag
        if tag - 100 > LQGameGradesManager.manager.getGameLevel() {
            
            return
        }
        
        bgView?.removeFromSuperview()
        self.view?.presentScene(LQLevel01Scene(size: (self.view?.frame.size)!))
    }
}
