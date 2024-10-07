//
//  FontSizeView.swift
//  HW21
//
//  Created by Максим Громов on 11.09.2024.
//

import UIKit

class FontSizeView: UIView {
    lazy var lowerButton = UIButton()
    lazy var upperButton = UIButton()
    lazy var stack = UIStackView()
    weak var delegate: FontSizeDelegate?
    init() {
        super.init(frame: .zero)
        layer.shadowOffset = .init(width: 2, height: 2)
        layer.shadowRadius = 5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.cornerRadius = 10
        backgroundColor = .systemGray6


        let lowerString = NSMutableAttributedString(string: "-")
        lowerString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 0, length: 1))
        lowerButton.setAttributedTitle(lowerString, for: .normal)
        lowerButton.layer.cornerRadius = 10
        
        let upperString = NSMutableAttributedString(string: "+")
        upperString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 0, length: 1))
        upperButton.setAttributedTitle(upperString, for: .normal)
        upperButton.layer.cornerRadius = 10
        
        
        
        stack.addArrangedSubview(lowerButton)
        stack.addArrangedSubview(upperButton)
        
        
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        stack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        lowerButton.widthAnchor.constraint(equalTo: upperButton.widthAnchor).isActive = true
        
        lowerButton.addTarget(self, action: #selector(selected), for: .touchDown)
        lowerButton.addTarget(self, action: #selector(deselected), for: .touchUpInside)
        lowerButton.addTarget(self, action: #selector(deselected), for: .touchUpOutside)
        lowerButton.addTarget(self, action: #selector(lowerFontSize), for: .touchUpInside)
        
        upperButton.addTarget(self, action: #selector(selected), for: .touchDown)
        upperButton.addTarget(self, action: #selector(deselected), for: .touchUpInside)
        upperButton.addTarget(self, action: #selector(deselected), for: .touchUpOutside)
        upperButton.addTarget(self, action: #selector(upperFontSize), for: .touchUpInside)
        
        
        
    }
    @objc func selected(_ sender: UIButton){
        sender.backgroundColor = .systemGray4
    }
    @objc func deselected(_ sender: UIButton){
        sender.backgroundColor = .clear
    }
    @objc func lowerFontSize(){
        delegate?.lowerFontSize()
    }
    @objc func upperFontSize(){
        delegate?.upperFontSize()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
protocol FontSizeDelegate: AnyObject{
    func lowerFontSize() -> CGFloat
    func upperFontSize() -> CGFloat
}
