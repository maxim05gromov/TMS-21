//
//  ViewController.swift
//  HW21
//
//  Created by Максим Громов on 10.09.2024.
//

import UIKit

class ViewController: UIViewController, HeaderViewDelegate, FontSizeDelegate, UITextViewDelegate, UIColorPickerViewControllerDelegate {
    lazy var textView = UITextView()
    lazy var header = HeaderView()
    lazy var modifyPanel = UIStackView()
    lazy var fontView = FontSizeView()
    
    var boldButton: UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bold")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 24)), for: .normal)
        button.addTarget(self, action: #selector(boldButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        return button
    }
    
    var italicButton: UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: "italic")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 24)), for: .normal)
        button.addTarget(self, action: #selector(italicButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.widthAnchor.constraint(equalToConstant: 60).isActive =
        true
        return button
        
    }
    
    var underlineButton: UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: "underline")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 24)), for: .normal)
        button.addTarget(self, action: #selector(underlineButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        return button
    }
    
    var eraseButton: UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eraser")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 24)), for: .normal)
        button.addTarget(self, action: #selector(eraseButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        return button
    }
    
    var colorButton: UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: "paintpalette")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 24)), for: .normal)
        button.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        return button
    }
    
    var fontSize: CGFloat = 32
    var gestureRecognizers: [UITapGestureRecognizer] = []
    var selectedText: NSRange?
    var text: NSMutableAttributedString = .init()
    
    var bottom: NSLayoutConstraint?
    var height: NSLayoutConstraint?
    
    
    func lowerFontSize() -> CGFloat {
        fontSize -= 2
        self.textView.font = .systemFont(ofSize: fontSize)
        return fontSize
    }
    func upperFontSize() -> CGFloat {
        fontSize += 2
        self.textView.font = .systemFont(ofSize: fontSize)
        return fontSize
    }
    @objc func fontSizeButtonTapped() {
        UIView.animate(withDuration: 0.3) {
            self.fontView.alpha = self.fontView.alpha == 0 ? 1 : 0
            if self.fontView.alpha == 1 {
                self.textView.addGestureRecognizer(self.gestureRecognizers[0])
                self.header.addGestureRecognizer(self.gestureRecognizers[1])
                self.modifyPanel.addGestureRecognizer(self.gestureRecognizers[2])
            }else{
                self.textView.removeGestureRecognizer(self.gestureRecognizers[0])
                self.header.removeGestureRecognizer(self.gestureRecognizers[1])
                self.modifyPanel.removeGestureRecognizer(self.gestureRecognizers[2])
            }
        }
    }
    
    
    
    @objc func keyboardAppeared(_ notification: Notification){
        print("keyboard appeared")
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        bottom?.constant = -1 * value.cgRectValue.height
        
        
        UIView.animate(withDuration: 0.3) {
            self.modifyPanel.layoutIfNeeded()
        }
    }
    @objc func keyboardDisappeared(_ notification: Notification){
        print("Keyboard disappeared")
        bottom?.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.modifyPanel.layoutIfNeeded()
        }
    }
    
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        selectedText = textView.selectedRange
            UIView.animate(withDuration: 0.3) {
                if textView.selectedRange.length == 0 {
                    self.height?.constant = 0
                }else{
                    self.height?.constant = 60
                }
                self.modifyPanel.layoutIfNeeded()
            }
    }
    
    @objc func boldButtonTapped(){
        text.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: fontSize), range: selectedText
                          ?? NSRange(location: 0, length: 0))
        textView.attributedText = text

    }
    
    @objc func italicButtonTapped(){
        text.addAttribute(.font, value: UIFont.italicSystemFont(ofSize: fontSize), range: selectedText
                          ?? NSRange(location: 0, length: 0))
        textView.attributedText = text
    }
    
    @objc func underlineButtonTapped(){
        text.addAttribute(.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: selectedText
                          ?? .init(location: 0, length: 0))
        textView.attributedText = text
    }
    
    @objc func eraseButtonTapped(){
        text.removeAttribute(.font, range: selectedText ?? .init(location: 0, length: 0))
        text.removeAttribute(.underlineStyle, range: selectedText ?? .init(location: 0, length: 0))
        textView.attributedText = text
    }
    
    @objc func colorButtonTapped(){
        let picker = UIColorPickerViewController()
        picker.delegate = self
        present(picker, animated: true)
    }
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        text.addAttribute(.foregroundColor, value: viewController.selectedColor, range: selectedText
                          ?? .init(location: 0, length: 0))
        textView.attributedText = text
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0 ..< 3{
            gestureRecognizers.append(UITapGestureRecognizer(target: self,
                                                             action: #selector(fontSizeButtonTapped)))
        }
        view.addSubview(textView)
        view.addSubview(modifyPanel)
        view.addSubview(header)
        view.addSubview(fontView)
        
        modifyPanel.translatesAutoresizingMaskIntoConstraints = false
        modifyPanel.backgroundColor = .systemGray6
        bottom = modifyPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 100)
        bottom!.isActive = true
        height = modifyPanel.heightAnchor.constraint(equalToConstant: 100)
        height?.isActive = true
        modifyPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        modifyPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        modifyPanel.axis = .horizontal
        
        modifyPanel.addArrangedSubview(boldButton)
        modifyPanel.addArrangedSubview(italicButton)
        modifyPanel.addArrangedSubview(underlineButton)
        modifyPanel.addArrangedSubview(colorButton)
        modifyPanel.addArrangedSubview(eraseButton)
        
        
        view.backgroundColor = .systemGray5
        textView.backgroundColor = .systemGray5
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: modifyPanel.topAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        textView.delegate = self
        text =
        NSMutableAttributedString(string: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
        
        textView.attributedText = text
        textView.font = .systemFont(ofSize: fontSize)
        
        
        header.translatesAutoresizingMaskIntoConstraints = false
        header.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        header.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        header.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: 100).isActive = true
        header.delegate = self
        
        
        fontView.translatesAutoresizingMaskIntoConstraints = false
        fontView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10).isActive = true
        fontView.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -20).isActive = true
        fontView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        fontView.widthAnchor.constraint(equalToConstant: 210).isActive = true
        fontView.delegate = self
        fontView.alpha = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappeared),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppeared),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
    }


}
#Preview{
    ViewController()
}
