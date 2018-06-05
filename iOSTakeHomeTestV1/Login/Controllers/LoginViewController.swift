//
//  LoginViewController.swift
//  iOSTakeHomeTestV1
//
//  Created by Jayven Nhan on 3/28/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import UIKit
import SnapKit
import SwiftSpinner

// MARK: LoginViewController
final class LoginViewController: UIViewController {
    
    // MARK: LoginViewController - Properties
    private let spinnerAnimationDuration = 2.0
    
    private let headerLabel: UILabel = {
        let titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
                                    NSAttributedStringKey.font: Font(object: .titleLabel).instance]
        let titleAttributedText = NSMutableAttributedString(string: "Restaurants\n", attributes: titleTextAttributes)
        let spacingTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10)]
        let spacingAttributedText = NSMutableAttributedString(string: "\n", attributes: titleTextAttributes)
        let subTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
                                       NSAttributedStringKey.font: Font(object: .subTitleLabel).instance]
        let subTitleAttributedText = NSMutableAttributedString(string: "Made for 2359 Media",
                                                                attributes: subTitleTextAttributes)
        titleAttributedText.append(subTitleAttributedText)
        let label = UILabel()
        label.numberOfLines = -1
        label.attributedText = titleAttributedText
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.sizeToFit()
        return label
    }()
    
    private let emailTextField: TextField = {
        let textField = TextField()
        textField.placeholder = "Email"
        textField.spellCheckingType = .no
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .done
        return textField
    }()
    
    private let passwordTextField: TextField = {
        let textField = TextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton: ActionButton = {
        let button = ActionButton()
        button.setTitle("Login", for: .normal)
        button.setTitle("Logging in", for: .selected)
        button.addTarget(self, action: #selector(LoginViewController.loginButtonDidTouch(_:)), for: .touchUpInside)
        return button
    }()
    
    private let skipButton: AlternateActionButton = {
        let button = AlternateActionButton()
        button.setTitle("Skip", for: .normal)
        button.addTarget(self, action: #selector(LoginViewController.loginLaterButtonDidTouch(_:)), for: .touchUpInside)
        return button
    }()
    
    private let leftSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.seperatorGray
        return view
    }()
    
    private let rightSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.seperatorGray
        return view
    }()
    
    private let seperatorLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.seperatorGray
        label.font = Font(.installed(.robotoRegular), size: .standard(.h2)).instance
        label.text = "or"
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var seperatorStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [leftSeperatorView,
                                                       seperatorLabel,
                                                       rightSeperatorView])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    fileprivate lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField,
                                                       passwordTextField,
                                                       loginButton,
                                                       seperatorStackView,
                                                       skipButton])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 12
        return stackView
    }()
    
    fileprivate lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerLabel, bottomStackView])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alpha = 0
        return stackView
    }()
    
    fileprivate var loginButtonBottomConstraint: Constraint?
    
    fileprivate enum EmailTextFieldErrorMessage: String {
        case empty = "Empty email field. Please enter your email address."
        case atSymbolError = "@ symbol not at beginning or end."
        case invalidEmailError = "Email does not exist."
    }
    
    fileprivate enum PasswordTextFieldMessage: String {
        case empty = "Empty password field. Please enter your password."
        case invalidCharactersLength = "Password has to be at least 8 characters long."
        case passwordNotWellFormedError = "Password requires at least 1 uppercase, 1 lowercase, 1 number and 1 special character."
        case incorrectPassword = "Password does not match email."
    }
    
    var registeredAccounts: [String: String] = ["takehome@2359media.com": "1Faraday@",
                                                "myemail@email.com": "Pass?111"]
    
}

// MARK: LoginViewController - Life cycles
extension LoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpUI()
        setUpTextFieldDelegates()
        observeKeyboardNotifications()
        presentUI()
    }
    
}

// MARK: LoginViewController - UI, Layout, Overhead
extension LoginViewController {
    fileprivate func setUpLayout() {
        view.addSubviews(views: [
            stackView
            ])
        
        stackView.snp.makeConstraints { (make) in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(40)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-40)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            loginButtonBottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40).constraint
        }
        
        emailTextField.snp.makeConstraints { (make) in
            make.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.height.equalTo(emailTextField)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.height.equalTo(emailTextField)
        }
        
        skipButton.snp.makeConstraints { (make) in
            make.height.equalTo(emailTextField)
        }
        
        seperatorLabel.snp.makeConstraints({ (make) in
            make.width.equalTo(26)
        })
        
        leftSeperatorView.snp.makeConstraints { (make) in
            make.height.equalTo(1)
        }
        
        rightSeperatorView.snp.makeConstraints { (make) in
            make.height.equalTo(leftSeperatorView)
            make.width.equalTo(leftSeperatorView)
        }
        
        seperatorStackView.snp.makeConstraints { (make) in
            make.height.equalTo(26)
        }
    }
    
    fileprivate func setUpUI() {
        view.backgroundColor = .white
    }
    
    fileprivate func presentUI() {
        let duration: TimeInterval = 0.3
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
            self.stackView.alpha = 1
        })
    }
    
    fileprivate func setUpTextFieldDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
}

// MARK: LoginViewController - Observers
extension LoginViewController {
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardShow), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: Keyboard
extension LoginViewController {
    @objc fileprivate func keyboardShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIKeyboardFrameBeginUserInfoKey] as? CGRect,
            let keyboardDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double
            else { return }
        
        loginButtonBottomConstraint?.update(offset: -(keyboardFrame.height + 30))
        
        UIView.animate(withDuration: keyboardDuration, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    @objc fileprivate func keyboardHide(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double
            else { return }
        
        loginButtonBottomConstraint?.update(offset: -40)
        
        UIView.animate(withDuration: keyboardDuration, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc fileprivate func loginButtonDidTouch(_ button: UIButton) {
        login()
    }
    
    @objc fileprivate func loginLaterButtonDidTouch(_ button: UIButton) {
        presentMainTabBarController()
    }
    
    fileprivate func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: LoginViewController - Login
extension LoginViewController {
    fileprivate func login() {
        dismissKeyboard()
        guard let emailAddress = emailTextField.text?.lowercased(), !emailAddress.isEmpty else {
            SwiftSpinner.show(duration: spinnerAnimationDuration, title: EmailTextFieldErrorMessage.empty.rawValue)
            return
        }
        
        guard emailAddress.first != "@", emailAddress.last != "@" else {
            SwiftSpinner.show(duration: spinnerAnimationDuration, title: EmailTextFieldErrorMessage.atSymbolError.rawValue)
            return
        }
        
        guard let userAccountPassword = registeredAccounts[emailAddress] else {
            SwiftSpinner.show(duration: spinnerAnimationDuration, title: EmailTextFieldErrorMessage.invalidEmailError.rawValue)
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            SwiftSpinner.show(duration: spinnerAnimationDuration, title: PasswordTextFieldMessage.empty.rawValue)
            return
        }
        
        guard password.count >= 8 else {
            SwiftSpinner.show(duration: spinnerAnimationDuration, title: PasswordTextFieldMessage.invalidCharactersLength.rawValue)
            return
        }
        
        guard password.containsAtLeastOneUppercasedCharacter(),
            password.containsAtLeastOneLowerCasedCharacter(),
            password.containsAtLeastOneIntegerCharacter(),
            password.containsAtLeastOneSpecialCharacter() else {
                SwiftSpinner.show(duration: spinnerAnimationDuration, title: PasswordTextFieldMessage.passwordNotWellFormedError.rawValue)
                return
        }
        
        guard userAccountPassword == password else {
            SwiftSpinner.show(duration: spinnerAnimationDuration, title: PasswordTextFieldMessage.incorrectPassword.rawValue)
            return
        }
        
        SwiftSpinner.show("Login Successfully")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + spinnerAnimationDuration) {
            SwiftSpinner.hide {
                self.presentMainTabBarController()
            }
        }
    }
    
    fileprivate func presentMainTabBarController() {
        self.present(MainTabBarController(), animated: true)
    }
    
    fileprivate func numberOfUppercasedCharacters(from string: String) -> Int {
        return string.replaceWhiteSpaces().replacePunctuationCharacters().reduce(0) { (result, character) -> Int in
            let uppercased = String(character).uppercased()
            guard String(character) != uppercased else {
                return result + 1
            }
            return result
        }
    }
    
    fileprivate func numberOfLowercasedCharacters(from string: String) -> Int {
        return string.replaceWhiteSpaces().replacePunctuationCharacters().reduce(0) { (result, character) -> Int in
            let lowercased = String(character).lowercased()
            guard String(character) != lowercased else {
                return result + 1
            }
            return result
        }
    }
    
    fileprivate func numberOfIntegers(from string: String) -> Int {
        return string.reduce(0) { (result, character) -> Int in
            let isInt = Int(String(character)) != nil ? true : false
            guard !isInt else {
                return result + 1
            }
            return result
        }
    }
    
    fileprivate func numberOfSpecialCharacters(from string: String) -> Int {
        return string.reduce(0) { (result, character) -> Int in
            let isInt = Int(String(character)) != nil ? true : false
            guard !isInt else {
                return result + 1
            }
            return result
        }
    }
    
}

// MARK: LoginViewController - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: LoginViewController - String Extension
fileprivate extension String {
    func containsAtLeastOneSpecialCharacter() -> Bool {
        let characterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        return self.rangeOfCharacter(from: characterSet.inverted) != nil
    }
    
    func containsAtLeastOneUppercasedCharacter() -> Bool {
        let uppercasedCharactersCount = self.replaceWhiteSpaces().replacePunctuationCharacters().reduce(0) { (result, character) -> Int in
            let uppercased = String(character).uppercased()
            guard String(character) != uppercased else {
                return result + 1
            }
            return result
        }
        return uppercasedCharactersCount > 0
    }
    
    func containsAtLeastOneLowerCasedCharacter() -> Bool {
        let lowercasedCharactersCount = self.replaceWhiteSpaces().replacePunctuationCharacters().reduce(0) { (result, character) -> Int in
            let lowercased = String(character).lowercased()
            guard String(character) != lowercased else {
                return result + 1
            }
            return result
        }
        return lowercasedCharactersCount > 0
    }
    
    func containsAtLeastOneIntegerCharacter() -> Bool {
        let integerCharactersCount = self.reduce(0) { (result, character) -> Int in
            let isInt = Int(String(character)) != nil ? true : false
            guard !isInt else {
                return result + 1
            }
            return result
        }
        return integerCharactersCount > 0
    }
}
