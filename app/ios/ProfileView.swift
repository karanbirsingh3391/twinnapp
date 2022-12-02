//
//  ProfileView.swift
//  RTABMapApp
//
//  Created by Karan Sehgal on 02/12/2022.
//

import Foundation

import UIKit

protocol ProfileViewDelegate: AnyObject {
    func sendLogoutRequest(email: String, password: String)
}

class ProfileView: UIView, UITextFieldDelegate {
        
    public var delegate: ProfileViewDelegate!
    public var myNameTextField: UITextField!
    public var myEmailTextField: UITextField!
    private var myCancelButton: UIButton!
    private var myLogoutButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, screenWidth: CGFloat, screenHeight: CGFloat, withDictionary: [String: Any]) {
        super.init(frame: frame)
        print(withDictionary)
        let projectnameLabel = self.createLabel(frame: CGRect(x: 25, y: 50, width: 150, height: 20), labelText: "Name")
        self.addSubview(projectnameLabel)
        
        myNameTextField = UITextField(frame: CGRect(x: 25, y: 75, width: self.frame.width-50, height: 40))
        myNameTextField.placeholder = "Name"
        myNameTextField.font = UIFont.systemFont(ofSize: 15)
        myNameTextField.borderStyle = UITextField.BorderStyle.roundedRect
        myNameTextField.autocorrectionType = UITextAutocorrectionType.no
        myNameTextField.keyboardType = UIKeyboardType.default
        myNameTextField.returnKeyType = UIReturnKeyType.done
        myNameTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        myNameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        myNameTextField.delegate = self
        myNameTextField.isEnabled = false
        self.addSubview(myNameTextField)
        
        let clientnameLabel = self.createLabel(frame: CGRect(x: 25, y: 125, width: 150, height: 20), labelText: "Email")
        self.addSubview(clientnameLabel)
        
        myEmailTextField = UITextField(frame: CGRect(x: 25, y: 150, width: self.frame.width-50, height: 40))
        myEmailTextField.placeholder = "Email"
        myEmailTextField.font = UIFont.systemFont(ofSize: 15)
        myEmailTextField.borderStyle = UITextField.BorderStyle.roundedRect
        myEmailTextField.autocorrectionType = UITextAutocorrectionType.no
        myEmailTextField.keyboardType = UIKeyboardType.default
        myEmailTextField.returnKeyType = UIReturnKeyType.done
        myEmailTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        myEmailTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        myEmailTextField.delegate = self
        myEmailTextField.isEnabled = false
        self.addSubview(myEmailTextField)
        
        if(!withDictionary.isEmpty){
            myNameTextField.text = withDictionary["firstName"] as? String
            myEmailTextField.text = withDictionary["email"] as? String
        }
        
        myCancelButton = UIButton(frame: CGRect(x: 10, y: screenHeight-62, width: 146, height: 52))
        myCancelButton.backgroundColor = .clear
        //myCancelButton.isUserInteractionEnabled = true
        myCancelButton.setTitle("Cancel", for: .normal)
        myCancelButton.setTitleColor(UIColor(red: 0.259, green: 0.522, blue: 0.957, alpha: 1), for: .normal)
        myCancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        self.addSubview(myCancelButton)
        
        myLogoutButton = UIButton(frame: CGRect(x: self.frame.width-156, y: screenHeight-62, width: 146, height: 52))
        myLogoutButton.backgroundColor = .clear
        //myCancelButton.isUserInteractionEnabled = true
        myLogoutButton.setTitle("Logout", for: .normal)
        //createProjectButton.setTitleColor(UIColor(red: 0.259, green: 0.522, blue: 0.957, alpha: 1), for: .normal)
        myLogoutButton.addTarget(self, action: #selector(logoutButtonAction), for: .touchUpInside)
        let l = CAGradientLayer()
        l.frame = myLogoutButton.bounds
        l.colors = [UIColor(red: 62.0/255.0, green: 121/255.0, blue: 229.0/255.0, alpha: 1.0).cgColor, UIColor(red: 1.0/255.0, green: 184.0/255.0, blue: 227.0/255.0, alpha: 1.0).cgColor]
        l.startPoint = CGPoint(x: 0, y: 0.5)
        l.endPoint = CGPoint(x: 1, y: 0.5)
        l.cornerRadius = 10
        myLogoutButton.layer.addSublayer(l)
        self.addSubview(myLogoutButton)
    }
    
    func createLabel(frame: CGRect, labelText: String) -> UILabel{
        let customLabel = UILabel(frame: frame)
        customLabel.textAlignment = .left
        customLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        customLabel.textColor = .systemGray
        //projectNameLabel.font = UIFont(name: "Roboto-Medium", size: 10)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.83
        customLabel.text = labelText
        return customLabel
    }
    
    // MARK: - Button Actions
    @objc func cancelButtonAction(sender: UIButton!){
        print("cancel button pressed ")
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.frame = CGRect(x: UIScreen.main.bounds.width , y: 0, width: 400, height: UIScreen.main.bounds.width)

        }, completion: { (finished: Bool) in
            self.removeFromSuperview()
        })
    }
    
    @objc func logoutButtonAction(sender: UIButton!){
        print("cancel button pressed ")
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.frame = CGRect(x: UIScreen.main.bounds.width , y: 0, width: 400, height: UIScreen.main.bounds.width)

        }, completion: { (finished: Bool) in
            self.removeFromSuperview()
            self.delegate?.sendLogoutRequest(email: "", password: "")
        })
    }
    
}
