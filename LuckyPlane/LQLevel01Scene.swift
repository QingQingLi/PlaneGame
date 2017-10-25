//
//  LQLevel01Scene.swift
//  LuckyPlane
//
//  Created by 魔曦 on 2017/9/26.
//  Copyright © 2017年 魔曦. All rights reserved.
//

import SpriteKit
import UIKit

class LQLevel01Scene: SKScene ,SKPhysicsContactDelegate{

    var reuserBackground :[SKSpriteNode] = Array()
    var backCount = 0
    
    let color = UIColor.init(colorLiteralRed: 237/255.0, green: 137/255.0, blue: 52/255.0, alpha: 1.0)
    
    //navView
    var topView : UIView?
    var backButton : UIButton?
    var HPProgerss : UIProgressView?
    var GoldImgView : UIImageView?
    var HPLabel0 : UILabel?
    var GoldLabel :UILabel?
    
    //pauseView
    var pauseView : UIView?
    
    //endView
    var endView  : UIView?
    
    //角色
    //背景
    var backgroundY :CGFloat = 0
    //飞船
    let spaceShipNode = LQMyPlayer(color: SKColor.white, size: CGSize(width: 75, height: 90))
    
    //石块
    
    //纹理
    //背景
    //飞船
    let shipTexture = SKTexture(imageNamed: "sp_all")
    var missileTexture = SKTexture(imageNamed: "Missile")
    //石块或者敌人
   
    //爆炸动画纹理
    var booms : [SKTexture] = Array()
    
    //血量
    let HPLabel = SKLabelNode(text: "HP:100")
    
    //位置信息
    var beganLocation = CGPoint.zero
    var beganPosition = CGPoint.zero
    
    //定时
    let fireWait = SKAction.wait(forDuration: 0.1)
    let rockWait = SKAction.wait(forDuration: 2)
    
    var backTexture : [SKTexture] = Array()
    
    var allBullets : Dictionary<String,Bullet> = Dictionary()
    var allEnemies : Dictionary<String,Bullet> = Dictionary()
    
    let bulletTexture = SKTexture(imageNamed: "Bullet")
    let enemyTexture = SKTexture(imageNamed: "sp_enemy")
    
    var backMoveNode : SKNode?
    var spriteInNode : SKNode?
    
    var labelNode : SKNode?
    override func didMove(to view: SKView) {
        self.shipTexture.filteringMode = SKTextureFilteringMode.nearest
        self.missileTexture.filteringMode = SKTextureFilteringMode.nearest
        self.bulletTexture.filteringMode = SKTextureFilteringMode.nearest
        
        self.backMoveNode = SKNode()
        self.spriteInNode = SKNode()
        self.labelNode = SKNode()
        self.backMoveNode?.zPosition = 0
        self.spriteInNode?.zPosition = 1
        self.labelNode?.zPosition = 2
        
        self.addChild(self.backMoveNode!)
        self.addChild(self.spriteInNode!)
        self.addChild(self.labelNode!)
        
        self.createTopView()
        
        //爆炸
        for i in 1 ..< 8 {
            let texture = SKTexture(imageNamed: String(format: "boom%d", i))
            booms.append(texture)
        }
        let texture = SKTexture(imageNamed: "bg1")
        texture.filteringMode = SKTextureFilteringMode.nearest
        
        let backnode = SKSpriteNode(color: .white, size: self.frame.size)
        backnode.zPosition = 0
        backnode.texture = texture
        backnode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        backnode.name = "back"
        self.backMoveNode!.addChild(backnode)
//        self.backMoveNode!.run(SKAction.repeatForever(SKAction.move(by: CGVector(dx: 0,dy: -2), duration: 0.003)))

//        self.performSelector(inBackground: #selector(LQLevel01Scene.loadBackgroundTexture), with: nil)
        self.backgroundColor = .black
        
        self.allBullets = self.loadAllTextures("Bullet", broadTexture: self.bulletTexture)
        self.allEnemies = self.loadAllTextures("sp_enemy", broadTexture: self.enemyTexture)
        
        DispatchQueue.global().async { () -> Void in
            
            self.createSpaceShipNode()
            
            let fireMissile = SKAction.perform(#selector(LQLevel01Scene.fireMissile), onTarget: self)
            self.spaceShipNode.run(SKAction.repeatForever(SKAction.sequence([fireMissile,self.fireWait])))
            
            let addEnemies = SKAction.perform(#selector(LQLevel01Scene.addEnemies), onTarget: self)
            let enemyAction = SKAction.repeatForever(SKAction.sequence([addEnemies,addEnemies,self.rockWait]))
            self.run(enemyAction)
            self.isUserInteractionEnabled = false
            self.physicsWorld.contactDelegate = self
        }
        
    }
    
//    var HPView : UIView?
//    var Gold : UIImageView?
//    var HPLabel0 : UILabel?
//    var GoldLabel :UILabel?
    func createTopView() {
        let width : CGFloat = UIScreen.main.bounds.size.width
        topView = UIView(frame: CGRect(x: 0, y: 20, width: width, height: 44))
        topView?.backgroundColor = .clear
        self.view?.addSubview(topView!)
        
        backButton = UIButton(frame: CGRect(x: 10, y: 0, width: 20, height: 22))
        backButton?.center.y = (topView?.frame.height)!/2.0
        backButton?.setImage(UIImage(named: "pause"), for: .normal)
        backButton?.setImage(UIImage(named: "play"), for: .selected)
        backButton?.contentMode = .scaleToFill
//        backButton?.setTitle("返回", for: .normal)
//        backButton?.setTitleColor(.red, for: .normal)
        backButton?.addTarget(scene, action:#selector(LQLevel01Scene.pauseGame), for: UIControlEvents.touchUpInside)
        topView?.addSubview(backButton!)
    
        
        HPProgerss = UIProgressView(frame: CGRect(x: (self.backButton?.frame.maxX)! + 10, y: 0, width: 100, height: 44))
        HPProgerss?.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        HPProgerss?.center.x = width/2.0 
        HPProgerss?.center.y = (topView?.frame.height)!/2.0
        HPProgerss?.progressViewStyle = .default
        HPProgerss?.layer.cornerRadius = 5
        HPProgerss?.progress = 1.0
        HPProgerss?.trackTintColor = .gray
        HPProgerss?.progressTintColor = color
        topView?.addSubview(HPProgerss!)
        
        HPLabel0 = UILabel(frame: CGRect(x: (self.HPProgerss?.frame.maxX)! + 5, y: 0, width: 40, height: 44))
        HPLabel0?.text = "100"
        HPLabel0?.textColor = color
        topView?.addSubview(HPLabel0!)
        
//        GoldImgView = UIImageView(frame: CGRect(x: (self.HPLabel0?.frame.maxX)! + 10, y: 0, width: 40, height: 44))
        GoldImgView = UIImageView(image: UIImage(named: "gold1"))
        GoldImgView?.frame.origin = CGPoint(x: (self.HPLabel0?.frame.maxX)! + 1, y: 0)
        GoldImgView?.center.y = (topView?.frame.height)!/2.0
//        GoldImgView?.backgroundColor = .black
        topView?.addSubview(GoldImgView!)
        
        GoldLabel = UILabel(frame: CGRect(x: (self.GoldImgView?.frame.maxX)! + 5, y: 0, width: 60, height: 44))
        GoldLabel?.text = "000"
        GoldLabel?.textColor = color
        topView?.addSubview(GoldLabel!)
        
    }
    
    func createPauseView()  {
        
        pauseView = UIView(frame: CGRect(x: 0, y: 0 , width: 200 , height: 250))
        pauseView?.center = (self.view?.center)!
        pauseView?.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        pauseView?.layer.borderColor = color.cgColor
        pauseView?.layer.borderWidth = 1
        pauseView?.layer.cornerRadius = 5
        UIApplication.shared.keyWindow?.addSubview(pauseView!)
        
        let countinueBtn = UIButton(frame: CGRect(x: 0, y: 50, width: 200, height: 50))
        countinueBtn.center.x = (pauseView?.frame.width)!/2.0
        countinueBtn.setTitle(NSLocalizedString("继续游戏", comment: ""), for: .normal)
        countinueBtn.setTitleColor(color, for: .normal)
        countinueBtn.titleLabel?.font = UIFont.init(name: "【何尼玛】土肥圆", size: 25)
        countinueBtn.addTarget(scene, action:#selector(LQLevel01Scene.gotoGame), for: UIControlEvents.touchUpInside)
       pauseView?.addSubview(countinueBtn)
        
        
        let mainBtn = UIButton(frame: CGRect(x: 0, y: countinueBtn.frame.maxY + 50, width: 200, height: 50))
         mainBtn.center.x = (pauseView?.frame.width)!/2.0
        mainBtn.setTitle(NSLocalizedString("返回主页", comment: ""), for: .normal)
        mainBtn.setTitleColor(color, for: .normal)
        mainBtn.titleLabel?.font = UIFont.init(name: "【何尼玛】土肥圆", size: 25)
        mainBtn.addTarget(scene, action:#selector(LQLevel01Scene.backMainMenu), for: UIControlEvents.touchUpInside)
        pauseView?.addSubview( mainBtn)
        
    }
    
    func createEndView() {
       
        let width : CGFloat = 200
        endView = UIView(frame: CGRect(x: 0, y: 0 , width: width , height: 350))
        endView?.center.y = (self.view?.center.y)!
        endView?.center.x = (self.view?.center.x)!
        UIApplication.shared.keyWindow?.addSubview(endView!)
        
        let label = UILabel(frame: CGRect(x: 0, y: 50, width: width, height: 50))
        label.center.x = (endView?.frame.width)!/2.0
        label.text = "GAME OVER"
        label.textAlignment = .center
        label.textColor = color
        label.font = UIFont.init(name: "Chalkduster", size: 25)
        endView?.addSubview(label)
        
        let againBtn = UIButton(frame: CGRect(x: 0, y: label.frame.maxY + 50, width: 200, height: 50))
        againBtn.center.x = (endView?.frame.width)!/2.0
        againBtn.setTitle(NSLocalizedString("再来一局", comment: ""), for: .normal)
        againBtn.setTitleColor(color, for: .normal)
        againBtn.titleLabel?.font = UIFont.init(name: "【何尼玛】土肥圆", size: 25)
        againBtn.addTarget(scene, action:#selector(LQLevel01Scene.againgame), for: UIControlEvents.touchUpInside)
        endView?.addSubview(againBtn)
        
        
        let mainBtn = UIButton(frame: CGRect(x: 0, y: againBtn.frame.maxY + 50, width: 200, height: 50))
        mainBtn.center.x = (endView?.frame.width)!/2.0
        mainBtn.setTitle(NSLocalizedString("返回主页", comment: ""), for: .normal)
        mainBtn.setTitleColor(color, for: .normal)
        mainBtn.titleLabel?.font = UIFont.init(name: "【何尼玛】土肥圆", size: 25)
        mainBtn.addTarget(scene, action:#selector(LQLevel01Scene.backMainMenu), for: UIControlEvents.touchUpInside)
        endView?.addSubview(mainBtn)
        
    }
    
    func pauseGame(btn : UIButton) {
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            self.createPauseView()
            self.isPaused = true

        }else{
            
            pauseView?.removeFromSuperview()
            self.isPaused = false
        }
    }
    
    func gotoGame() {//继续游戏
        backButton?.isSelected = !(backButton?.isSelected)!
        
        self.isPaused = false
        pauseView?.removeFromSuperview()
        
    }
    
    func againgame() {
        endView?.removeFromSuperview()
        
        self.HPLabel0?.text = "100"
        self.isPaused = false
        
    }
    
    func backMainMenu(){
        
        topView?.removeFromSuperview()
        pauseView?.removeFromSuperview()
        endView?.removeFromSuperview()
        self.view!.presentScene(LQStartScene(size: (self.view?.frame.size)!))
    }
    
    func loadAllTextures(_ imgName : String, broadTexture: SKTexture) -> Dictionary<String,Bullet> {
        let resourceDic = NSDictionary(contentsOfFile: Bundle.main.path(forResource: imgName, ofType: "plist")!)
        let bulletDict = resourceDic!["frames"] as! NSDictionary
        var textures : Dictionary<String,Bullet> = Dictionary()
        for (key,value) in bulletDict {
            let dict = value as! NSDictionary
            let bullet = Bullet()
            bullet.setValuesForKeys(dict as! [String : AnyObject])
            let rect  = self.getTextureRect(bullet.frameValue, inTexture:broadTexture)
            bullet.texture = SKTexture(rect: rect, in: broadTexture)
            textures.updateValue(bullet, forKey: key as! String)
            
        }
        
        return textures
        
    }
    
    func getTextureRect(_ frame : CGRect, inTexture : SKTexture?) -> CGRect {
        if let myTexture = inTexture {
            let rect = CGRect.init(x: frame.origin.x / myTexture.size().width, y: (myTexture.size().height - frame.origin.y - frame.height) / myTexture.size().height, width: frame.width / myTexture.size().width, height: frame.height / myTexture.size().height)

            return rect
        }
        return CGRect.zero
    }
    
    //Actions
    func loadBackgroundTexture(){
        
        for i in (0...30).reversed() {
            let texture = SKTexture(imageNamed: String(format: "bg1_%02d", i))
            texture.filteringMode = SKTextureFilteringMode.nearest
            self.backTexture.append(texture)
            
        }
        self.reuserBackgroundAction()
    }
    
    func reuserBackgroundAction()  {
        
        //背景
        for i in 1 ..< self.backTexture.count {
            let texture = self.backTexture[i]
            let backNode1 = SKSpriteNode(color: .white, size: CGSize(width: self.frame.width, height: self.frame.width / texture.size().width * texture.size().height))
            self.reuserBackground.append(backNode1)
            backNode1.zPosition = 0
            backNode1.texture = texture
            backNode1.position = CGPoint(x: self.frame.midX, y: self.backgroundY)
            backNode1.name = "background"
            self.backMoveNode!.addChild(backNode1)
            
            self.backgroundY = self.backgroundY + backNode1.size.height
            
        }
        
        self.backMoveNode!.run(SKAction.repeatForever(SKAction.move(by: CGVector(dx: 0,dy: -2), duration: 0.03)))
    }
    
    //起始位置
    func createSpaceShipNode() {
        spaceShipNode.position = CGPoint(x: (self.frame).midX, y: (self.frame).minY)
        spaceShipNode.zPosition = 2
        
        let rect = self.getTextureRect(CGRectFromString("{{140,265},{116,131}}"), inTexture: self.shipTexture)
    
        spaceShipNode.texture = SKTexture.init(rect: rect, in: self.shipTexture)
        spaceShipNode.run(SKAction.moveTo(y: 70, duration: 0.6)){ () -> Void in
            self.isUserInteractionEnabled = true
            
        }
        spaceShipNode.name = "spaceShip"
        let plumb = SKSpriteNode(color: .white, size: CGSize(width: 60, height: 60))
        let plumbRect = getTextureRect(CGRectFromString("{{140,398},{120,108}}"), inTexture: self.shipTexture)
        plumb.texture = SKTexture(rect: plumbRect, in: self.shipTexture)
        plumb.position = CGPoint(x: 1, y: -57)
        self.spaceShipNode.addChild(plumb)
        let fireAction = SKAction.fadeAlpha(to: 1.1, duration: 0.05)
        let fireOutAction = SKAction.fadeAlpha(to: 0.6, duration: 0.05)
        let fireAction1 = SKAction.scaleY(to: 1.05, duration: 0.05)
        let fireOutAction1 = SKAction.scaleY(to: 1, duration: 0.05)
        let fA = SKAction.sequence([fireAction,fireOutAction,fireAction1,fireOutAction1])
        let  fireA  = SKAction.repeatForever(fA)
        plumb.run(fireA)
        
        self.spaceShipNode.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        self.spaceShipNode.physicsBody!.isDynamic = false
        self.spaceShipNode.physicsBody!.contactTestBitMask = 1<<2
        
        self.spriteInNode?.addChild(self.spaceShipNode)
        HPLabel.position = CGPoint(x: 100, y: 100)
        HPLabel.zPosition = 2
        HPLabel.fontSize = 20
        
//        self.labelNode!.addChild(HPLabel)
        self.spaceShipNode.player.totalHP = 100
        self.spaceShipNode.player.define = 0
        self.spaceShipNode.player.attackFP = 0
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            self.beganLocation = touch.location(in: self)
            self.beganPosition = self.spaceShipNode.position
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            
            var translateX  = location.x - self.beganLocation.x
            var translateY  = location.y - self.beganLocation.y
            
            if self.beganPosition.y + translateY <= 10 {
                translateY = 11 - self.beganPosition.y
            }
            
            if self.beganPosition.x + translateX <= 10 {
                translateX = 11 - self.beganPosition.x
            }
            
            if self.beganPosition.y + translateY >= self.frame.height - 10 {
                translateY = self.frame.height - 11 - self.beganPosition.y
            }
            if self.beganPosition.x + translateX >= self.frame.width - 10 {
            
                translateX = self.frame.width - 11 - self.beganPosition.x
            }
            
            self.spaceShipNode.position = CGPoint(x: self.beganPosition.x + translateX, y: self.beganPosition.y + translateY)
        }
    }
    
    
    //导弹
    func fireMissile()  {
        let missile = SKSpriteNode(texture: self.allBullets["Bullet_01.png"]!.texture)
        missile.xScale = 0.5
        missile.yScale = 0.5
        missile.zPosition = 1
        missile.position = CGPoint(x: self.spaceShipNode.position.x, y: self.spaceShipNode.position.y + 50)
        missile.name = "missile"
        
        missile.physicsBody = SKPhysicsBody(rectangleOf: missile.size)
        missile.physicsBody?.isDynamic = false
        missile.run(SKAction.moveTo(y: 800, duration: 1))
        missile.physicsBody?.contactTestBitMask = 01
        self.spriteInNode!.addChild(missile)
    }
    
    func addEnemies() {
        let enemy = SKSpriteNode(color: .white, size: CGSize(width: 90, height: 90))
        enemy.zPosition = 3
        let bullet = self.allEnemies["enemy0.png"]
        enemy.texture = bullet!.texture
        enemy.position = CGPoint(x: CGFloat(arc4random() % UInt32(self.frame.width)), y: self.frame.height - 40)
        enemy.name = "rock"
        enemy.physicsBody = SKPhysicsBody(texture: enemy.texture!, size: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.allowsRotation = false
        if bullet!.rotated {
            enemy.run(SKAction.rotate(byAngle: CGFloat.pi, duration: 0))
        }
        enemy.run(SKAction.repeatForever(SKAction.move(by: CGVector(dx: 0, dy: -7), duration: 0.03)))
    
            enemy.physicsBody!.contactTestBitMask = 01<<1
        self.spriteInNode!.addChild(enemy)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    //移除超出屏幕的石头 、导弹、地图背景
    override func didSimulatePhysics() {
        self.spriteInNode!.enumerateChildNodes(withName: "rock") { (node, stop) in
            if node.position.y < 0 {
                node.removeAllActions()
                node.removeFromParent()
            }
        }
        
        self.spriteInNode!.enumerateChildNodes(withName: "missile") { (node, stop) in
            if node.position.y > self.size.height {
                node.removeAllActions()
                node.removeFromParent()
            }
        }
        
        self.backMoveNode!.enumerateChildNodes(withName: "background") { (node, stop) in
            if self.backMoveNode!.position.y + node.frame.height + node.position.y <= 0{
                node.removeFromParent()
            }
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        NSLog("bodyA = %@  bodyB = %@  HP = %@  AttackHP = %@", contact.bodyA.node!.name ?? "",contact.bodyB.node!.name ?? "",self.HPLabel0?.text ?? "",self.GoldLabel?.text ?? "")
        
        //火箭 石头
        if contact.bodyA.contactTestBitMask | contact.bodyB.contactTestBitMask == 0x3 {
            if let nameA = contact.bodyA.node!.name {
                if let nameB = contact.bodyB.node!.name {
                    if nameA == "rock"  && nameB == "missile" {
                        self.exploreAndRemoveFromParent(contact.bodyA.node!)
                        
                    }else if nameB == "rock"  && nameA == "missile" {
                        self.exploreAndRemoveFromParent(contact.bodyB.node!)
                    }
                }
            }
        }
        
        //石头 与 飞船
        if contact.bodyA.contactTestBitMask | contact.bodyB.contactTestBitMask == 0x6 {
            if let nameA = contact.bodyA.node!.name {
                if let nameB = contact.bodyB.node!.name {
                    if nameA == "rock"  {
                        self.exploreAndRemoveFromParent(contact.bodyA.node!)
                        self.exploreShipMinusHP(10.0)
                    }else if nameB == "rock" {
                        self.exploreAndRemoveFromParent(contact.bodyB.node!)
                        self.exploreShipMinusHP(10.0)
                        
                    }
                }
            }
        }
        
        
        
    }
    

    func exploreAndRemoveFromParent(_ node:SKNode) {
        
        self.spaceShipNode.player.attackFP += 100
        self.GoldLabel?.text = String(format: "%.0f", self.spaceShipNode.player.attackFP)
        node.removeAllActions()
        node.physicsBody!.isDynamic = false
//        self.run(SKAction.playSoundFileNamed("Explode01.mp3", waitForCompletion: false))
        
        node.run(SKAction.animate(with: booms, timePerFrame: 0.05))
        node.perform(#selector(SKNode.removeFromParent), with: nil, afterDelay: 0.4)
        
    }
    
    //能量值
    func exploreShipMinusHP(_ minusHP : Float)  {
        self.spaceShipNode.player.totalHP = self.spaceShipNode.player.totalHP - minusHP
        self.HPLabel.text = String(format: "HP:%3.0f", self.spaceShipNode.player.totalHP)
        self.HPLabel0?.text = String(format: "%3.0f", self.spaceShipNode.player.totalHP)
        
        UIView.animate(withDuration: 0.5) { 
            self.HPProgerss?.progress = self.spaceShipNode.player.totalHP/100.0
        }
        if spaceShipNode.player.totalHP <= 0 {
            
            self.isPaused = true
            
            self.HPLabel.text = "HP:000"
            self.HPLabel0?.text = "000"
            self.HPProgerss?.progress = 0.0
//            spaceShipNode.removeFromParent()
            
//            spaceShipNode.run(SKAction.animate(with: booms, timePerFrame: 0.05))
//            spaceShipNode.perform(#selector(SKNode.removeFromParent), with: nil, afterDelay: 0.4)
//            self.isUserInteractionEnabled = false
//            let label = SKLabelNode(text: "GAME OVER!")
//            label.fontName = "Chalkduster"
//            label.fontSize = 45
//            label.position = self.view!.center
//            self.addChild(label)
            
            self.createEndView()
            
//            self.backMoveNode!.run(SKAction.repeatForever(SKAction.move(by: CGVector(dx: 0,dy: -0.01), duration: 0.00003)))

        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
//        NSLog("结束啦" )
    }
    
    
    
    
}
