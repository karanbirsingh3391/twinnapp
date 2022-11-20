//
//  LoginView.swift
//  RTABMapApp
//
//  Created by Karan Sehgal on 14/11/2022.
//

import Foundation
import UIKit

protocol LoginViewDelegate: class {
    func sendLoginRequest(email: String, password: String)
}

class LoginView: UIView, UITextFieldDelegate {
    
    struct ResponseObject<T: Decodable>: Decodable {
        let form: T    // often the top level key is `data`, but in the case of https://httpbin.org, it echos the submission under the key `form`
    }

    struct Foo: Decodable {
        let access_token: String
        let token_type: String
    }
    
    private var loginOptionsView: UIView!
    private var loginSuccessfulView: UIView!
    private var emailTextField: UITextField!
    private var passwordTextField: UITextField!
    public var delegate: LoginViewDelegate!
    
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
        
        let loginButton = UIButton(frame:CGRect(x: screenWidth-468, y: 520, width: 368, height: 40))
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
//        self.delegate?.sendLoginRequest(email: self.emailTextField.text ?? "a", password: self.passwordTextField.text ?? "b")

        loginUser()
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
    
    func loginUser(){
        let url = URL(string: "https://dev-crm-api.tooliqa.com/api/auth/api/v1/auth/login")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "grant_type": "",
            "username": emailTextField.text!,
            "password": passwordTextField.text!,
            "scope": "",
            "client_id": "",
            "client_secret": ""
        ]
        request.httpBody = parameters.percentEncoded()

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {                                                               // check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            
            print(response.statusCode)
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            // do whatever you want with the `data`, e.g.:
        
            
            do {
                let responseObject = try JSONDecoder().decode(ResponseObject<Foo>.self, from: data)
                print(responseObject)
            } catch {
                print(error) // parsing error
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                    let dict = self.convertToDictionary(text: responseString)
                    print(dict?["access_token"] as! String)
                    UserDefaults.standard.setValue(dict?["access_token"] as! String, forKey: "access_token")
                    DispatchQueue.main.async {
                        self.navigateToProjects()
                        }
                    
                    
                } else {
                    print("unable to parse response as string")
                }
            }
        }

        task.resume()
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

extension Dictionary {
    func percentEncoded() -> Data? {
        map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed: CharacterSet = .urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
