//
//  CustomControl.swift
//  Star Rating
//
//  Copyright © 2020 Joe Veverka. All rights reserved.
//

import UIKit

@IBDesignable class CustomControl: UIControl {
    //MARK: Properties
    var value: Int = 1
    
    private let componentDimension: CGFloat = 40
    private let componentSpacing: CGFloat = 8
    private let componentCount = 6
    private let componentActiveColor: UIColor = .black
    private let componentInactiveColor: UIColor = .gray
    private let fontSize: CGFloat = 32
    
    //MARK: Data Source
    private var labelArray = [UILabel]()
    
    
    //MARK: Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    //MARK: View Methods
    private func setup() {
        for i in 1...componentCount {
            
            let label = UILabel()
            label.tag = i
            
            //set label's position
            var position = CGPoint(x: (i-1)*Int(componentDimension) + Int(componentSpacing*2), y: 0)
            if i == 1 {
                position = CGPoint(x: componentSpacing, y: 0)
            }
            label.frame = CGRect(origin: position, size: CGSize(width: componentDimension, height: componentDimension))
            
            label.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
            label.text = "☆"
            label.textAlignment = .center
            
            if i == 1 {
                label.textColor = componentActiveColor
            } else {
                label.textColor = componentInactiveColor
            }
            addSubview(label)
            labelArray.append(label)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let componentsWidth = CGFloat(componentCount) * componentDimension
        let componentsSpacing = CGFloat(componentCount + 1) * componentSpacing
        let width = componentsWidth + componentsSpacing
        return CGSize(width: width, height: componentDimension)
    }
    
    func updateValue(at touch: UITouch) {
        for label in labelArray {
            if label.bounds.contains(touch.location(in: label)) {
                if label.tag != value {
                    value = label.tag
                    sendActions(for: .valueChanged)
                }
            }
        }
        // Active Labels
        for i in 0..<value {
            labelArray[i].textColor = componentActiveColor
        }
        // Inactive labels
        for i in value..<labelArray.count {
            labelArray[i].textColor = componentInactiveColor
        }
    }
    
    //MARK: Gestures/Touches
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        updateValue(at: touch)
        sendActions(for: [.touchDown])
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        if touchBounds(for: touch) {
            updateValue(at: touch)
            sendActions(for: [.touchDragInside])
        } else {
            sendActions(for: [.touchDragOutside])
        }
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        if touchBounds(for: touch) {
            updateValue(at: touch!) //unwrapped in checkTouchBounds
            sendActions(for: [.touchUpInside])
            performFlare()
        } else {
            sendActions(for: [.touchUpOutside])
        }
        
    }
    
    override func cancelTracking(with event: UIEvent?) {
        sendActions(for: .touchCancel)
    }
    
    //MARK: Touch Helper
    func touchBounds(for touch: UITouch?) -> Bool {
        guard let touchPoint = touch?.location(in: self) else {return false}
        if bounds.contains(touchPoint) {
            return true
        }
        return false
    }
    
}

extension UIView {
    // animation sequence for stars 
    func performFlare() {
        func flare()   { transform = CGAffineTransform(scaleX: 1.6, y: 1.6) }
        func unflare() { transform = .identity }
        
        UIView.animate(withDuration: 0.3,
                       animations: { flare() },
                       completion: { _ in UIView.animate(withDuration: 0.1) { unflare() }})
    }
}

