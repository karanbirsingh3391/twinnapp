//
//  LoginView.swift
//  RTABMapApp
//
//  Created by Karan Sehgal on 14/11/2022.
//

import Foundation
import UIKit

protocol LoginViewDelegate: class {
    func sendSetupRequest(email: String, password: String)
}

class LoginView: UIView, UITextFieldDelegate {
        
    private var loginOptionsView: UIView!
    private var loginSuccessfulView: UIView!
    private var emailTextField: UITextField!
    private var passwordTextField: UITextField!
    public var delegate: LoginViewDelegate!
    public var spinnerView: UIActivityIndicatorView!
    public var loginButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, screenWidth: CGFloat, screenHeight: CGFloat) {
        super.init(frame: frame)
        
        loginOptionsView = UIView(frame: CGRect(x:0, y: 0, width: screenWidth, height: screenHeight))
        self.addSubview(loginOptionsView)
        
        loginSuccessfulView = UIView(frame: CGRect(x:0, y: 0, width: screenWidth, height: screenHeight))
        self.addSubview(loginSuccessfulView)
        loginSuccessfulView.alpha = 0
        
        let loginSuccessImageView = UIImageView(image: UIImage(named: "LoginSuccessView.png")!)
        loginSuccessImageView.backgroundColor = .clear
        loginSuccessImageView.frame = CGRect(x: 0, y: 0, width: 700, height: 700)
        loginSuccessImageView.center = CGPoint(x: loginSuccessfulView.center.x, y: loginSuccessfulView.center.y)
        loginSuccessfulView.addSubview(loginSuccessImageView)
        
        let loginOptionsImageView = UIImageView(image: UIImage(named: "LoginOptionsImage.png")!)
        loginOptionsImageView.backgroundColor = .clear
        loginOptionsImageView.frame = CGRect(x: 25, y: 116, width: 650, height: 670)
        //loginOptionsImageView.center = CGPoint(x: loginSuccessfulView.center.x, y: loginSuccessfulView.center.y)
        loginOptionsView.addSubview(loginOptionsImageView)
        
        let logoImageView = UIImageView(image: UIImage(named: "Twinn LOGO.png")!)
        logoImageView.backgroundColor = .clear
        logoImageView.frame = CGRect(x: screenWidth-460, y: 215, width: 80, height: 80)
        loginOptionsView.addSubview(logoImageView)
        
        let twinnImageView = UIImageView(image: UIImage(named: "Vector.png")!)
        twinnImageView.backgroundColor = .clear
        twinnImageView.frame = CGRect(x: screenWidth-370, y: 215, width: 260, height: 80)
        loginOptionsView.addSubview(twinnImageView)
        
        let emailLabel = UILabel(frame: CGRect(x: screenWidth-540, y: 336, width: 90, height: 21))
        emailLabel.textAlignment = .left
        emailLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        emailLabel.textColor = .black
        emailLabel.font = UIFont(name: "Roboto-Medium", size: 14)
        //var paragraphStyle = NSMutableParagraphStyle()
        //paragraphStyle.lineHeightMultiple = 0.83
        emailLabel.text = "Email"
        loginOptionsView.addSubview(emailLabel)
        
        let passwordLabel = UILabel(frame: CGRect(x: screenWidth-540, y: 416, width: 90, height: 21))
        passwordLabel.textAlignment = .left
        passwordLabel.font = UIFont.preferredFont(forTextStyle: .body)
        passwordLabel.textColor = .black
        passwordLabel.font = UIFont(name: "Roboto-Medium", size: 14)
        //var paragraphStyle = NSMutableParagraphStyle()
        //paragraphStyle.lineHeightMultiple = 0.83
        passwordLabel.text = "Password"
        loginOptionsView.addSubview(passwordLabel)
        
        emailTextField = UITextField(frame: CGRect(x: screenWidth-540, y: 360, width: 514, height: 40))
        emailTextField.placeholder = "Enter text here"
        emailTextField.font = UIFont.systemFont(ofSize: 15)
        emailTextField.borderStyle = UITextField.BorderStyle.roundedRect
        emailTextField.autocorrectionType = UITextAutocorrectionType.no
        emailTextField.keyboardType = UIKeyboardType.default
        emailTextField.returnKeyType = UIReturnKeyType.done
        emailTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        emailTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        emailTextField.delegate = self
        loginOptionsView.addSubview(emailTextField)
        
        passwordTextField = UITextField(frame: CGRect(x: screenWidth-540, y: 440, width: 514, height: 40))
        passwordTextField.placeholder = "Enter text here"
        passwordTextField.font = UIFont.systemFont(ofSize: 15)
        passwordTextField.borderStyle = UITextField.BorderStyle.roundedRect
        passwordTextField.autocorrectionType = UITextAutocorrectionType.no
        passwordTextField.keyboardType = UIKeyboardType.default
        passwordTextField.returnKeyType = UIReturnKeyType.done
        passwordTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        passwordTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        passwordTextField.delegate = self
        loginOptionsView.addSubview(passwordTextField)
        
        emailTextField.text = "karan3391@gmail.com"
        passwordTextField.text = "karan3391"
        
        loginButton = UIButton(frame:CGRect(x: screenWidth-468, y: 520, width: 368, height: 40))
        loginButton.backgroundColor = .clear
        loginButton.setTitle("Log In", for: .normal)
        //newScanButton.titleLabel?.font = UIFont(name: "Sora-SemiBold", size: 16)
        loginButton.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        let l = CAGradientLayer()
        l.frame = loginButton.bounds
        l.colors = [UIColor(red: 62.0/255.0, green: 121/255.0, blue: 229.0/255.0, alpha: 1.0).cgColor, UIColor(red: 1.0/255.0, green: 184.0/255.0, blue: 227.0/255.0, alpha: 1.0).cgColor]
        l.startPoint = CGPoint(x: 0, y: 0.5)
        l.endPoint = CGPoint(x: 1, y: 0.5)
        l.cornerRadius = 2
        loginButton.layer.addSublayer(l)
        loginOptionsView.addSubview(loginButton)
    }
    
    @objc func loginButtonAction(sender: UIButton!){
        print("button Pressed")
        loginButton.setTitle("", for: .normal)
        spinnerView = UIActivityIndicatorView(style: .medium)
        spinnerView.color = .white
        spinnerView.center = loginButton.center
        //spinnerView.backgroundColor = .green
        self.addSubview(spinnerView)
        spinnerView.startAnimating()
        
        if((emailTextField.text?.isEmpty) != nil)
        {
            //loginUser()
            let parameters: [String: Any] = [
                "grant_type": "",
                "username": emailTextField.text!,
                "password": passwordTextField.text!,
                "scope": "",
                "client_id": "",
                "client_secret": ""
            ]
            APIHelper.shareInstance.loginUser(endpoint: "", parameters: parameters) { responseString, error in
                print("login response " + responseString)

                DispatchQueue.main.async {
                    self.spinnerView.stopAnimating()
                    self.spinnerView.removeFromSuperview()
                    self.loginButton.setTitle("Log In", for: .normal)

                    if(responseString == ""){
                        self.showToast(message: "Something went wrong.", font: UIFont.preferredFont(forTextStyle: .body))
                    }
                    else{
                        let dict = self.convertToDictionary(text: responseString)
                        print(dict?["access_token"] as! String)
                        UserDefaults.standard.setValue(dict?["access_token"] as! String, forKey: "access_token")
                        self.navigateToProjects()

                    }
                }
            }
        }
    }
    
    func navigateToProjects()
    {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            self.loginOptionsView.alpha = 0
        }, completion: { (finished: Bool) in
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
                self.loginSuccessfulView.alpha = 1
            }, completion: { (finished: Bool) in
                UIView.animate(withDuration: 1.0, delay: 2.0, options: [], animations: {
                    self.alpha = 0
                }, completion: { (finished: Bool) in
                    self.removeFromSuperview()
                    self.delegate?.sendSetupRequest(email: self.emailTextField.text ?? "a", password: self.passwordTextField.text ?? "b")
                })
            })
        })
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        print("begin editing")
        UIView.animate(withDuration: 0.5) {
            self.loginOptionsView.frame = CGRect(x: 0, y:-150, width: self.frame.width, height: self.frame.height)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        print("end editing")
        UIView.animate(withDuration: 0.5) {
            self.loginOptionsView.frame = CGRect(x: 0, y:0, width: self.frame.width, height: self.frame.height)
        }
        
    }
    
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.frame.size.width/2 - 150, y: self.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}

