//
//  BreakOutScene.swift
//  BreakOut
//
//  Created by Zhicong Zang on 2/2/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import SpriteKit

class BreakOutScene: SKScene, SKPhysicsContactDelegate {
    let ballName = "Ball"
    let paddleName = "Paddle"
    let blockName = "Block"
    let backgroundLabelName = "BackgroundLabel"
    
    let ballCategory   : UInt32 = 0x1 << 0
    let backCategory : UInt32 = 0x1 << 1
    let blockCategory  : UInt32 = 0x1 << 2
    let paddleCategory : UInt32 = 0x1 << 3
    
    var contentCreated = false
    var isStart = false
    
    var sceneBackgroundColor: UIColor!
    var textColor: UIColor!
    var paddleColor: UIColor!
    var ballColor: UIColor!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        if !contentCreated {
            createSceneContents()
        }
    }
    
    func createSceneContents() {
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        backgroundColor = self.sceneBackgroundColor
        scaleMode = .AspectFit
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        physicsBody?.restitution = 1.0
        physicsBody?.friction = 0.0
        name = "scene"
        
        let back = SKNode()
        back.physicsBody = SKPhysicsBody(edgeFromPoint: CGPointMake(0, 1), toPoint: CGPointMake(frame.size.width, 1))
        back.physicsBody?.categoryBitMask = backCategory
        addChild(back)
        
        createLoadingLabelNode()
        
        let paddle = createPaddle()
        paddle.position = CGPoint(x: CGRectGetMidX(frame), y: 30)
        addChild(paddle)
        
        createBall()
        createBlocks()
        
        contentCreated = true
    }
    
    func createPaddle() -> SKSpriteNode {
        let paddle = SKSpriteNode(color: paddleColor, size: CGSize(width: 30, height: 5))
        
        paddle.physicsBody = SKPhysicsBody(rectangleOfSize: paddle.size)
        paddle.physicsBody?.dynamic = false
        paddle.physicsBody?.restitution = 1.0
        paddle.physicsBody?.friction = 0.0
        paddle.name = paddleName
        
        return paddle
    }
    
    func createBlocks() {
        let rowCount = Int(arc4random_uniform(4))+4
        for i in 0..<rowCount {
            let color = UIColor(white: CGFloat(i) * 0.8 / CGFloat(rowCount), alpha: 1)
            
            let columnCount = Int(arc4random_uniform(5))+10
            let blockWidth = ((self.view?.frame.width)! - CGFloat(columnCount-1))/CGFloat(columnCount)
            let blockHeigth:CGFloat = 5.0
            for j in 0..<columnCount {
                let block = SKSpriteNode(color: color, size: CGSize(width: blockWidth, height: blockHeigth))
                block.position = CGPointMake(1 + CGFloat(j) * (blockWidth + 1), (self.view?.frame.height)! - 20 - CGFloat(i) * (blockHeigth + 1))
                block.name = blockName
                block.physicsBody = SKPhysicsBody(rectangleOfSize: block.size)
                block.physicsBody?.allowsRotation = false
                block.physicsBody?.restitution = 1.0
                block.physicsBody?.friction = 0.0
                block.physicsBody?.dynamic = false
                
                addChild(block)
                
            }
        }
    }
    
    
    
    
    
    
    
    
    

}

















