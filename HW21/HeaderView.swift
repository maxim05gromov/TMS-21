//
//  HeaderView.swift
//  HW21
//
//  Created by Максим Громов on 11.09.2024.
//

import UIKit

class HeaderView: UIView {
    lazy var fontSizeButton = UIButton()
    weak var delegate: HeaderViewDelegate?
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .systemGray6
        
        addSubview(fontSizeButton)
        fontSizeButton.translatesAutoresizingMaskIntoConstraints = false
        fontSizeButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        fontSizeButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        fontSizeButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        fontSizeButton.setImage(UIImage(systemName: "textformat.size"), for: .normal)
        fontSizeButton.setPreferredSymbolConfiguration(.init(pointSize: 25), forImageIn: .normal)
        fontSizeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        fontSizeButton.addTarget(self, action: #selector(fontSizeButtonTapped), for: .touchUpInside)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2
        layer.shadowOffset = .init(width: 0, height: 1)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func fontSizeButtonTapped() {
        delegate?.fontSizeButtonTapped()
    }
}
protocol HeaderViewDelegate: AnyObject {
    func fontSizeButtonTapped()
}
