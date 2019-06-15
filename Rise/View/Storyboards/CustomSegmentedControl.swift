//
//  CustomSegmentedControl.swift
//  Rise
//
//  Created by Vladimir Korolev on 15/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

@IBDesignable
class CustomSegmentedContrl: UIControl {
    
    var buttons = [UIButton]()
    var selectedSegmentIndex = 1
    
    var commaSeperatedButtonTitles: String = "" {
        
        didSet {
            updateView()
        }
    }
    
    var textColor: UIColor = UIColor.white.withAlphaComponent(0.5) {
        
        didSet {
            updateView()
        }
    }
    
    var selectorTextColor: UIColor = .white {
        
        didSet {
            updateView()
        }
    }
    
    init(frame: CGRect, buttonTitles: String) {
        super.init(frame: frame)
        commaSeperatedButtonTitles = buttonTitles
        updateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView() {
        
        buttons.removeAll()
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        let buttonTitles = commaSeperatedButtonTitles.components(separatedBy: ",")
        
        for buttonTitle in buttonTitles {
            
            let button = UIButton.init(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            buttons.append(button)
            //            button.setTitleColor(button.isSelected ? UIColor.gray : selectorTextColor, for: .normal)
        }
        
        buttons[selectedSegmentIndex].setTitleColor(selectorTextColor, for: .normal)
        
        // Create a StackView
        
        let stackView = UIStackView.init(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0.0
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        // Drawing code
        
        // layer.cornerRadius = frame.height/2
        
    }
    
    @objc func buttonTapped(button: UIButton) {
        
        for (buttonIndex, btn) in buttons.enumerated() {
            
            btn.setTitleColor(textColor, for: .normal)
            
            if btn == button {
                selectedSegmentIndex = buttonIndex
                
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
        
        sendActions(for: .valueChanged)
    }
    
    func updateSegmentedControlSegs(index: Int) {
        
        for btn in buttons {
            btn.setTitleColor(textColor, for: .normal)
        }
        
        buttons[index].setTitleColor(selectorTextColor, for: .normal)
        
    }
    
    //    override func sendActions(for controlEvents: UIControlEvents) {
    //
    //        super.sendActions(for: controlEvents)
    //
    //        let  selectorStartPosition = frame.width / CGFloat(buttons.count) * CGFloat(selectedSegmentIndex)
    //
    //        UIView.animate(withDuration: 0.3, animations: {
    //
    //            self.selector.frame.origin.x = selectorStartPosition
    //        })
    //
    //        buttons[selectedSegmentIndex].setTitleColor(selectorTextColor, for: .normal)
    //
    //    }
    
}
