//
//  AlertWithTextfield.swift
//  CollectionNxN
//
//  Created by Karthikeyan A. on 24/09/19.
//  Copyright © 2019 Aravind. All rights reserved.
//

import Foundation
import UIKit

/// A validation rule for text input.
public enum TextValidationRule {
    /// Any input is valid, including an empty string.
    case noRestriction
    /// The input must not be empty.
    case nonEmpty
    /// The enitre input must match a regular expression. A matching substring is not enough.
    case regularExpression(NSRegularExpression)
    /// The input is valid if the predicate function returns `true`.
    case predicate((String) -> Bool)
    
    public func isValid(_ input: String) -> Bool {
        switch self {
        case .noRestriction:
            return true
        case .nonEmpty:
            return !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .regularExpression(let regex):
            let fullNSRange = NSRange(input.startIndex..., in: input)
            return regex.rangeOfFirstMatch(in: input, options: .anchored, range: fullNSRange) == fullNSRange
        case .predicate(let p):
            return p(input)
        }
    }
}

extension UIAlertController {
    
    public enum TextInputResult {
        /// The user tapped Cancel.
        case cancel
        /// The user tapped the OK button. The payload is the text they entered in the text field.
        case ok(String)
        
        func get() -> String {
            switch self {
            case .ok(let text):
                return text
            case .cancel:
                return ""
            }
        }
    }
    
    /// Creates a fully configured alert controller with one text field for text input, a Cancel and
    /// and an OK button.
    ///
    /// - Parameters:
    ///   - title: The title of the alert view.
    ///   - message: The message of the alert view.
    ///   - cancelButtonTitle: The title of the Cancel button.
    ///   - okButtonTitle: The title of the OK button.
    ///   - validationRule: The OK button will be disabled as long as the entered text doesn't pass
    ///     the validation. The default value is `.noRestriction` (any input is valid, including
    ///     an empty string).
    ///   - textFieldConfiguration: Use this to configure the text field (e.g. set placeholder text).
    ///   - onCompletion: Called when the user closes the alert view. The argument tells you whether
    ///     the user tapped the Close or the OK button (in which case this delivers the entered text).
    public convenience init(title: String, message: String? = nil,
                            cancelButtonTitle: String, okButtonTitle: String,
                            validate validationRule: TextValidationRule = .noRestriction,
                            textFieldConfiguration: ((UITextField) -> Void)? = nil,
                            onCompletion: @escaping (TextInputResult) -> Void) {
        self.init(title: title, message: message, preferredStyle: .alert)
        
        /// Observes a UITextField for various events and reports them via callbacks.
        /// Sets itself as the text field's delegate and target-action target.
        class TextFieldObserver: NSObject, UITextFieldDelegate {
            let textFieldValueChanged: (UITextField) -> Void
            let textFieldShouldReturn: (UITextField) -> Bool
            
            init(textField: UITextField, valueChanged: @escaping (UITextField) -> Void, shouldReturn: @escaping (UITextField) -> Bool) {
                self.textFieldValueChanged = valueChanged
                self.textFieldShouldReturn = shouldReturn
                super.init()
                textField.delegate = self
                textField.keyboardType = .numberPad
                textField.addTarget(self, action: #selector(TextFieldObserver.textFieldValueChanged(sender:)), for: .editingChanged)
            }
            
            @objc func textFieldValueChanged(sender: UITextField) {                
                textFieldValueChanged(sender)
            }
            
            // MARK: UITextFieldDelegate
            func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                return textFieldShouldReturn(textField)
            }
            func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                
                let currentCharacterCount = textField.text?.count ?? 0
                if range.length + range.location > currentCharacterCount {
                    return false
                }
                let newLength = currentCharacterCount + string.count - range.length
                return newLength <= 2
            }
        }
        
        var textFieldObserver: TextFieldObserver?
        
        // Every `UIAlertAction` handler must eventually call this
        func finish(result: TextInputResult) {
            // Capture the observer to keep it alive while the alert is on screen
            textFieldObserver = nil
            onCompletion(result)
        }
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { _ in
            finish(result: .cancel)
        })
        let okAction = UIAlertAction(title: okButtonTitle, style: .default, handler: { [unowned self] _ in
            finish(result: .ok(self.textFields?.first?.text ?? ""))
        })
        addAction(cancelAction)
        addAction(okAction)
        preferredAction = okAction
        
        addTextField(configurationHandler: { textField in
            textFieldConfiguration?(textField)
            textFieldObserver = TextFieldObserver(textField: textField,
                                                  valueChanged: { textField in
                                                    // okAction.isEnabled = validationRule.isValid(textField.text ?? "")
                                                    okAction.isEnabled  = false
                                                    guard let getText = textField.text, !getText.isEmpty,  let convertToInt = Int(getText) else {
                                                        self.message = ""
                                                        
                                                        return
                                                    }
                                                    var setString = ""
                                                    if convertToInt < 3 || convertToInt > 10 {
                                                        setString = String(format: "please enter the input 3>= %@ <=10", getText)
                                                    }
                                                    self.message = setString
                                                    if !setString.isEmpty {
                                                        let attributedString = NSAttributedString(string: setString, attributes: [
                                                            NSAttributedString.Key.foregroundColor : UIColor.red
                                                        ])
                                                        self.setValue(attributedString, forKey: "attributedMessage")
                                                        
                                                    }else{
                                                        okAction.isEnabled = true
                                                    }
            },
                                                  shouldReturn: { textField in
                                                    validationRule.isValid(textField.text ?? "")
            })
        })
        // Start with a disabled OK button if necessary
        okAction.isEnabled = false// validationRule.isValid(textFields?.first?.text ?? "")
    }
    
    func show() {
        present(animated: true, completion: nil)
    }
    
    var mainWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                return windowScene.windows.first
            }
        }
        return UIApplication.shared.keyWindow
    }
    
    func present(animated: Bool, completion: (() -> Void)?) {
        if  let getWindow = mainWindow ,  let rootVC = getWindow.rootViewController {
            presentFromController(controller: rootVC, animated: animated, completion: completion)
        }
    }
    
    private func presentFromController(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let navVC = controller as? UINavigationController,
            let visibleVC = navVC.visibleViewController {
            presentFromController(controller: visibleVC, animated: animated, completion: completion)
        }  else {
            controller.present(self, animated: animated, completion: completion);
        }
    }
    
    
    
}
