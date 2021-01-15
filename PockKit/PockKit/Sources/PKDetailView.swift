//
//  PKDetailView.swift
//  PockKit
//
//  Created by Pierluigi Galdi on 26/05/2019.
//  Copyright © 2019 Pierluigi Galdi. All rights reserved.
//

import Foundation
import SnapKit

open class PKDetailView: PKView {
    
    /// Core
    public static       let kBounceAnimationKey: String  = "kBounceAnimationKey"
    public private(set) var isAnimating:         Bool    = false
    public              var maxWidth:            CGFloat = 0 {
        didSet {
            updateConstraint()
        }
    }
    public              var leftToRight:         Bool    = true {
        didSet {
            updateConstraint()
        }
    }
    
    /// UI
    public var imageView:    NSImageView!
    public var titleView:    ScrollingTextView!
    public var subtitleView: ScrollingTextView!
    
    /// Variables
    public var canScrollTitle:    Bool = true
    public var canScrollSubtitle: Bool = true
    public var shouldHideIcon:    Bool = false {
        didSet {
            updateConstraint()
        }
    }
    
    public convenience init(frame: NSRect = .zero, leftToRight: Bool = true) {
        self.init(frame: frame)
        self.leftToRight = leftToRight
        self.load()
    }
    
    /// Load subviews if `self` is used as an IBOutlet
    public func load() {
        imageView = NSImageView(frame: .zero)
        imageView.imageScaling = .scaleProportionallyDown
        
        titleView = ScrollingTextView(frame: .zero)
        titleView.font = NSFont.systemFont(ofSize: 9)
        if !canScrollTitle { titleView.speed = 0 }
        
        subtitleView = ScrollingTextView(frame: .zero)
        subtitleView.font = NSFont.systemFont(ofSize: 9)
        subtitleView.textColor = NSColor(calibratedRed: 124/255, green: 131/255, blue: 127/255, alpha: 1)
        if !canScrollSubtitle { subtitleView.speed = 0 }
        
        addSubview(imageView)
        addSubview(titleView)
        addSubview(subtitleView)
        
        updateConstraint()
        didLoad()
    }
    
    /// Override this function to do your initial setup.
    open func didLoad() {
        /// do your implementation
    }
    
    /// Override this function to layout subviews as you prefer.
    /// SnapKit can help you in this.
    open func updateConstraint() {
        if leftToRight {
            imageView.snp.remakeConstraints({ maker in
                maker.width.equalTo(shouldHideIcon ? 0 : 24)
                maker.top.bottom.equalTo(self)
                maker.left.equalTo(self)
            })
            titleView.snp.remakeConstraints({ maker in
                if maxWidth > 0 {
                    maker.width.equalTo(maxWidth).priority(.medium)
                }
                maker.height.equalTo(self).dividedBy(2)
                maker.left.equalTo(imageView.snp.right).offset(4)
                maker.top.equalTo(self).inset(2)
                maker.right.equalToSuperview().inset(4)
            })
            subtitleView.snp.remakeConstraints({ maker in
                if maxWidth > 0 {
                    maker.width.equalTo(maxWidth).priority(.medium)
                }
                maker.left.equalTo(titleView)
                maker.top.equalTo(titleView.snp.bottom).inset(3)
                maker.right.equalTo(titleView)
                maker.bottom.greaterThanOrEqualTo(self)
            })
        }else {
            titleView.snp.remakeConstraints({ maker in
                if maxWidth > 0 {
                    maker.width.equalTo(maxWidth).priority(.medium)
                }
                maker.height.equalTo(self).dividedBy(2)
                maker.left.equalToSuperview()
                maker.top.equalTo(self).inset(2)
            })
            subtitleView.snp.remakeConstraints({ maker in
                if maxWidth > 0 {
                    maker.width.equalTo(maxWidth).priority(.medium)
                }
                maker.top.equalTo(titleView.snp.bottom).inset(3)
                maker.left.equalTo(titleView)
                maker.bottom.greaterThanOrEqualTo(self)
            })
            imageView.snp.remakeConstraints({ maker in
                maker.width.equalTo(shouldHideIcon ? 0 : 24)
                maker.top.bottom.equalTo(self)
                maker.right.equalTo(self)
                maker.left.equalTo((titleView.frame.width > subtitleView.frame.width ? titleView : subtitleView).snp.right).offset(4)
            })
        }
    }
    
    open func set(title: String?) {
        titleView.setup(string: title ?? "")
    }
    
    open func set(subtitle: String?) {
        subtitleView.setup(string: subtitle ?? "")
    }
    
    open func set(image: NSImage?) {
        imageView?.image = image
    }
    
}

extension PKDetailView {
    
    public func startBounceAnimation() {
        if !isAnimating {
            self.loadBounceAnimation()
        }
    }
    
    public func stopBounceAnimation() {
        self.imageView.layer?.removeAnimation(forKey: PKDetailView.kBounceAnimationKey)
        self.isAnimating = false
    }
    
    private func loadBounceAnimation() {
        isAnimating                   = true
        
        let bounce                   = CABasicAnimation(keyPath: "transform.scale")
        bounce.fromValue             = 0.86
        bounce.toValue               = 1
        bounce.duration              = 1.2
        bounce.autoreverses          = true
        bounce.repeatCount           = Float.infinity
        bounce.timingFunction        = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        let frame = self.imageView.layer?.frame
        self.imageView.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.imageView.layer?.frame = frame ?? .zero
        self.imageView.layer?.add(bounce, forKey: PKDetailView.kBounceAnimationKey)
    }
    
}

