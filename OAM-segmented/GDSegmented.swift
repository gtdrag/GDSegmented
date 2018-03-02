//
//  OAMSegmented.swift
//  OAM-segmented
//
//  Created by George Drag on 2/26/18.
//  Copyright © 2018 Red Foundry. All rights reserved.
//

import UIKit

@IBDesignable
class GDSegmented: UIControl {
    var buttons = [UIButton]()
    var selector = UIView()
    var selectedIndex = 0
    var caret = Caret(origin: CGPoint(x: 0, y: 0), color: nil)
    var selectorWidth = CGFloat()
    var background = UIView()
    var buttonImages = [UIImage?]()
    
    @IBInspectable
    var button1Image: UIImage? = nil {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var button2Image: UIImage? = nil {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var button3Image: UIImage? = nil {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var button4Image: UIImage? = nil {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var button5Image: UIImage? = nil {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0.8 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var fontSize: CGFloat = 17.0 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var segmentBackgroundColor: UIColor = .white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = .clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable
    var segmentNames: String = "places,people,cities" {
        didSet {
            updateView()
        }
    }
    @IBInspectable
    var textColor: UIColor = .lightGray {
        didSet {
            updateView()
        }
    }
    @IBInspectable
    var selectedBgColor: UIColor = .darkGray {
        didSet {
            updateView()
        }
    }
    @IBInspectable
    var selectedTextColor: UIColor = .white {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        backgroundColor = borderColor
        buttons.removeAll()
        subviews.forEach { $0.removeFromSuperview() }
        let segmentTitles = segmentNames.components(separatedBy: ",")
        for (index, title) in segmentTitles.enumerated() {
            let button = UIButton(type: .custom)
            button.setTitle(title.uppercased(), for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.titleLabel?.font = UIFont(name: "Bambino", size: fontSize)
            button.addTarget(self, action: #selector(buttonTapped(button: )), for: .touchUpInside)
            
            switch index {
            case 0 :
                if let image = button1Image {
                    addButtonImage(image: image, button: button)
                }
            case 1:
                if let image = button2Image {
                    addButtonImage(image:image, button: button)
                }
            case 2:
                if let image = button3Image {
                    addButtonImage(image:image, button: button)
                }
            case 3:
                if let image = button4Image {
                    addButtonImage(image:image, button: button)
                }
            case 4:
                if let image = button5Image {
                    addButtonImage(image:image, button: button)
                }
            default: break
            }
            buttons.append(button)
        }
        buttons[0].setTitleColor(.white, for: .normal)
        background = UIView(frame: CGRect(x: borderWidth, y: borderWidth, width: frame.width - (borderWidth * 2), height: frame.height - (borderWidth * 2)))
        background.backgroundColor = segmentBackgroundColor
        addSubview(background)
        selectorWidth = frame.width / CGFloat(buttons.count)
        selector = UIView(frame: CGRect(x: borderWidth, y: 0, width: selectorWidth, height: frame.height - borderWidth))
        selector.backgroundColor = selectedBgColor
        for (index, _) in buttons.enumerated() {
            let separator = UIView(frame: CGRect(x: selectorWidth * CGFloat(index), y: 0, width: borderWidth, height: frame.height))
            separator.backgroundColor = borderColor
            addSubview(separator)
        }
        addSubview(selector)
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        caret = Caret(origin: CGPoint(x: (selectorWidth/2 - 11), y: self.frame.height-borderWidth), color: selectedBgColor)
        addSubview(caret)
    }
    
    func addButtonImage(image: UIImage, button: UIButton) {
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: -10, bottom: 10, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
    }
    
    @objc func buttonTapped(button: UIButton) {
        for (index, butt) in buttons.enumerated() {
            butt.setTitleColor(textColor, for: .normal)
            if butt == button {
                selectedIndex = index
                let selectorXposition = (frame.width / CGFloat(buttons.count)) * CGFloat(index)
                UIView.animate(withDuration: 0.3, animations: {
                    self.selector.frame.origin.x = selectorXposition
                    butt.setTitleColor(self.selectedTextColor, for: .normal)
                    self.caret.frame.origin.x = selectorXposition + (self.selectorWidth/2 - 11)
                })
            }
        }
        sendActions(for: .valueChanged)
    }
    
    override func draw(_ rect: CGRect) {
        updateView()
    }
}

class Caret: UIView {
    let width: CGFloat = 21
    let height: CGFloat = 22
    var color = UIColor()
    
    var trianglePathSmall: UIBezierPath {
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: 0, y: 0))
        trianglePath.addLine(to: CGPoint(x: width/2, y: height))
        trianglePath.addLine(to: CGPoint(x: width, y: 0))
        trianglePath.close()
        return trianglePath
    }
    
    init(origin: CGPoint, color: UIColor?) {
        if let caretColor = color { self.color = caretColor } else { self.color = .clear}
        super.init(frame: CGRect(x: origin.x, y: origin.y, width: width, height: height))
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = trianglePathSmall
        color.setFill()
        path.fill()
    }
}
