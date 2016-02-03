//
//  BreakOutToRefrehView.swift
//  BreakOut
//
//  Created by Zhicong Zang on 2/3/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit
import SpriteKit

@objc public protocol BreakOutToRefreshDelegate: class {
    func refreshViewDidRefresh(refreshView: BreakOutToRefreshView)
}

public class BreakOutToRefreshView: SKView {
    private let sceneHeight = CGFloat(100)
    private let breakOutScene: BreakOutScene
    private unowned let scrollView: UIScrollView
    public weak var delegate: BreakOutToRefreshDelegate?
    public var forceEnd = false
    public var isRefreshing = false
    private var isDragging = false
    private var isVisible = false
    
    public var sceneBackgroundColor:UIColor {
        didSet{
            breakOutScene.backgroundColor = sceneBackgroundColor
            startScene.backgroundColor = sceneBackgroundColor
        }
    }
    
    public var textColor: UIColor {
        didSet {
            breakOutScene.textColor = textColor
            startScene.textColor = textColor
        }
    }
    
    public var paddleColor: UIColor {
        didSet {
            breakOutScene.paddleColor = paddleColor
        }
    }
    public var ballColor: UIColor {
        didSet {
            breakOutScene.ballColor = ballColor
        }
    }
    
    public var blockColors: [UIColor] {
        didSet {
            breakOutScene.blockColors = blockColors
        }
    }
    
    private lazy var startScene:StartScene = {
        let size = CGSize(width: self.scrollView.frame.width, height: self.sceneHeight)
        let startScene = StartScene(size: size)
        startScene.backgroundColor = self.sceneBackgroundColor
        startScene.textColor = self.textColor
        return startScene
    }()
    
    public override init(frame: CGRect) {
        fatalError("Use init(scrollView:) instead.")
    }
    
    public init(scrollView inScrollView: UIScrollView) {
        let frame = CGRect(x: 0.0, y: -sceneHeight, width: inScrollView.frame.size.width, height: sceneHeight)
        
        breakOutScene = BreakOutScene(size: frame.size)
        self.scrollView = inScrollView
        sceneBackgroundColor = UIColor.whiteColor()
        textColor = UIColor.blackColor()
        paddleColor = UIColor.grayColor()
        ballColor = UIColor.blackColor()
        blockColors = [UIColor(white: 0.2, alpha: 1.0), UIColor(white: 0.4, alpha: 1.0), UIColor(white: 0.6, alpha: 1.0)]
        
        breakOutScene.scenebackgroundColor = sceneBackgroundColor
        breakOutScene.textColor = textColor
        breakOutScene.paddleColor = paddleColor
        breakOutScene.ballColor = ballColor
        breakOutScene.blockColors = blockColors
        
        super.init(frame: frame)
        layer.borderColor = UIColor.grayColor().CGColor
        layer.borderWidth = 1.0
        
        presentScene(startScene)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func beginRefreshing() {
        isRefreshing = true
        
        let doors = SKTransition.doorsOpenVerticalWithDuration(0.5)
        presentScene(breakOutScene, transition: doors)
        breakOutScene.updateLabel("Loading...")
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.scrollView.contentInset.top += self.sceneHeight
            }) { (_) -> Void in
                if self.scrollView.contentOffset.y < -60 {
                    self.breakOutScene.reset()
                    self.breakOutScene.start()
                }
                self.isVisible = true
        }
        
    }
    
    public func endRefreshing() {
        if (!isDragging||forceEnd) && isVisible {
            self.isVisible = false
            UIView.animateWithDuration(1, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                self.scrollView.contentInset.top -= self.sceneHeight
                }, completion: { (_) -> Void in
                    self.isRefreshing = false
                    self.presentScene(self.startScene)
            })
        } else {
            breakOutScene.updateLabel("Loading Finished")
            isRefreshing = false
        }
    }

    
    
    
}

extension BreakOutToRefreshView: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        isDragging = true
    }
    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        isDragging = false
        if !isRefreshing && scrollView.contentOffset.y + scrollView.contentInset.top < -sceneHeight {
            beginRefreshing()
            targetContentOffset.memory.y = -scrollView.contentInset.top
            delegate?.refreshViewDidRefresh(self)
        }
        
        if !isRefreshing {
            endRefreshing()
        }
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        let yPosition = sceneHeight - (-scrollView.contentInset.top - scrollView.contentOffset.y) * 2
        breakOutScene.moveHandle(yPosition)
    }
}





















