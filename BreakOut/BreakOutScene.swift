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
    
    let ballCategory   : UInt32 = 0x1 << 0
    let backCategory : UInt32 = 0x1 << 1
    let blockCategory  : UInt32 = 0x1 << 2
    let paddleCategory : UInt32 = 0x1 << 3
    
    var contentCreated = false
    var isStart = false
    
    var sceneBackgroundColor: UIColor!
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
            let blockWidth = ((frame.width) - CGFloat(columnCount-1))/CGFloat(columnCount)
            let blockHeigth:CGFloat = 5.0
            for j in 0..<columnCount {
                let block = SKSpriteNode(color: color, size: CGSize(width: blockWidth, height: blockHeigth))
                block.position = CGPointMake(1 + CGFloat(j) * (blockWidth + 1), (frame.height) - 20 - CGFloat(i) * (blockHeigth + 1))
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
    
    func removeBlocks() {
        while((childNodeWithName(blockName)) != nil) {
            childNodeWithName(blockName)?.removeFromParent()
        }
    }
    
    func createBall() {
        let ball = SKSpriteNode(color: ballColor, size: CGSize(width: 8, height: 8))
        ball.name = ballName
        ball.position = CGPointMake(frame.width * CGFloat(arc4random()) / CGFloat(UINT32_MAX), 30 + ball.frame.width)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.height/2)
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody?.categoryBitMask = ballCategory
        ball.physicsBody?.contactTestBitMask = blockCategory | paddleCategory | backCategory
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.linearDamping = 0.0
        ball.physicsBody?.restitution = 1.0
        ball.physicsBody?.friction = 0.0
        
        addChild(ball)
    }
    
    func removeball() {
        if let ball = childNodeWithName(ballName) {
            ball.removeFromParent()
        }
    }
    
    func reset() {
        removeBlocks()
        removeball()
        createBlocks()
        createBall()
    }
    
    func start() {
        isStart = true
        if let ball = childNodeWithName(ballName) {
            ball.physicsBody?.applyImpulse(CGVectorMake(0.2, -0.5))
        }
    }
    
    func moveHandle(value: CGFloat) {
        if let paddle = childNodeWithName(paddleName) {
            paddle.position.x = value
        }
    }
    
    func isGameWon() -> Bool {
        if let _ = childNodeWithName(blockName) {
            return false
        }
        return true
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        var ballBody: SKPhysicsBody?
        var otherBody: SKPhysicsBody?
        if contact.bodyA.contactTestBitMask > contact.bodyB.contactTestBitMask {
            otherBody = contact.bodyA
            ballBody = contact.bodyB
        }else {
            otherBody = contact.bodyB
            ballBody = contact.bodyA
        }
        
        if (otherBody?.contactTestBitMask ?? 0) == backCategory {
            reset()
            start()
        } else if otherBody!.contactTestBitMask & ballCategory != 0 {
            let minVelocity = CGFloat(20)
            var velocity = ballBody!.velocity as CGVector
            if velocity.dy < minVelocity && velocity.dy >= 0 {
                velocity.dy = minVelocity + 1
            } else if velocity.dy < 0 && velocity.dy > -minVelocity {
                velocity.dy = -minVelocity - 1
            }
            if velocity.dx <= 0 && velocity.dx > -minVelocity {
                velocity.dx = minVelocity + 1
            } else if velocity.dx > 0 && velocity.dx < minVelocity {
                velocity.dx = -minVelocity - 1
            }
            ballBody?.velocity = velocity
        }
        
        if let body = otherBody where (body.categoryBitMask & blockCategory != 0) && body.categoryBitMask == blockCategory {
            body.node?.removeFromParent()
            if isGameWon() {
                reset()
                start()
            }
        }
    }
    
    
    
    
    

}

















