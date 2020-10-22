//
//  BaseButton.swift
//  RM
//
//

import UIKit

class BaseButton: UIButton {
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    // MARK: - Private properties
    
    private var buttonPressed: (_ sender: UIButton) -> Void = { _ in }
    
    private var endEditingClosure: (() -> Void)?
    
    // MARK: - Life cycle
 
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    /// this method calls when awakeFromNib
    ///
    /// - Parameters:
    ///   - title: Need key for NSLocalizedString
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(NSLocalizedString(title ?? "", comment: ""), for: state)
    }
    
    // MARK: - Public methods
    
    /// After initalize method
    func configureUI() { }
    
    /// method that set callback action for button
    ///
    /// - Parameter callback: return self as sender
    func bind(callback: @escaping (_ sender: UIButton) -> Void) {
        
        buttonPressed = callback
        addTarget(self, action: #selector(buttonWasPressed), for: .touchUpInside)
    }

}

// MARK: - Actions

private extension BaseButton {
    
    @objc func buttonWasPressed(_ button: UIButton) {
        buttonPressed(button)
    }
    
}
