//
//  CreateNewProjectView.swift
//  RTABMapApp
//
//  Created by Karan Sehgal on 23/11/2022.
//

import Foundation
import UIKit

protocol CreateNewProjectViewDelegate: class {
    func sendRequest(projectName: String, projectID: String, isEdit:Bool)
}

class CreateNewProjectView: UIView, UITextFieldDelegate {
    
    public var delegate: CreateNewProjectViewDelegate!
    public var projectNameTextField: UITextField!
    public var projectID: String!
    public var isEdit: Bool!
    private var myCancelButton: UIButton!
    private var createProjectButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, screenWidth: CGFloat, screenHeight: CGFloat, projectName: String, projectID: String, isEdit: Bool) {
        super.init(frame: frame)
        //self.isUserInteractionEnabled = true
        
        self.projectID = projectID
        self.isEdit = isEdit
        
        let projectNameLabel = UILabel(frame: CGRect(x: 25, y: 50, width: 150, height: 21))
        projectNameLabel.textAlignment = .left
        projectNameLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        projectNameLabel.textColor = .systemGray
        //projectNameLabel.font = UIFont(name: "Roboto-Medium", size: 10)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.83
        projectNameLabel.text = "Project Name"
        self.addSubview(projectNameLabel)
        
        projectNameTextField = UITextField(frame: CGRect(x: 25, y: 80, width: 350, height: 40))
        projectNameTextField.placeholder = "Enter Project Name"
        projectNameTextField.text = projectName
        projectNameTextField.font = UIFont.systemFont(ofSize: 15)
        projectNameTextField.borderStyle = UITextField.BorderStyle.roundedRect
        projectNameTextField.autocorrectionType = UITextAutocorrectionType.no
        projectNameTextField.keyboardType = UIKeyboardType.default
        projectNameTextField.returnKeyType = UIReturnKeyType.done
        projectNameTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        projectNameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        projectNameTextField.delegate = self
        self.addSubview(projectNameTextField)
        
        myCancelButton = UIButton(frame: CGRect(x: 10, y: screenHeight-62, width: 146, height: 52))
        myCancelButton.backgroundColor = .clear
        //myCancelButton.isUserInteractionEnabled = true
        myCancelButton.setTitle("Cancel", for: .normal)
        myCancelButton.setTitleColor(UIColor(red: 0.259, green: 0.522, blue: 0.957, alpha: 1), for: .normal)
        myCancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
//        let l = CAGradientLayer()
//        l.frame = myCancelButton.bounds
//        l.colors = [UIColor(red: 62.0/255.0, green: 121/255.0, blue: 229.0/255.0, alpha: 1.0).cgColor, UIColor(red: 1.0/255.0, green: 184.0/255.0, blue: 227.0/255.0, alpha: 1.0).cgColor]
//        l.startPoint = CGPoint(x: 0, y: 0.5)
//        l.endPoint = CGPoint(x: 1, y: 0.5)
//        l.cornerRadius = 10
//        myCancelButton.layer.addSublayer(l)
        self.addSubview(myCancelButton)
        
        createProjectButton = UIButton(frame: CGRect(x: self.frame.width-156, y: screenHeight-62, width: 146, height: 52))
        createProjectButton.backgroundColor = .clear
        //myCancelButton.isUserInteractionEnabled = true
        
        //createProjectButton.setTitleColor(UIColor(red: 0.259, green: 0.522, blue: 0.957, alpha: 1), for: .normal)
        createProjectButton.addTarget(self, action: #selector(createProjectButtonAction), for: .touchUpInside)
        let l = CAGradientLayer()
        l.frame = createProjectButton.bounds
        l.colors = [UIColor(red: 62.0/255.0, green: 121/255.0, blue: 229.0/255.0, alpha: 1.0).cgColor, UIColor(red: 1.0/255.0, green: 184.0/255.0, blue: 227.0/255.0, alpha: 1.0).cgColor]
        l.startPoint = CGPoint(x: 0, y: 0.5)
        l.endPoint = CGPoint(x: 1, y: 0.5)
        l.cornerRadius = 10
        createProjectButton.layer.addSublayer(l)
        self.addSubview(createProjectButton)
        
        if(self.isEdit){
            createProjectButton.setTitle("Update", for: .normal)
        }
        else{
            createProjectButton.setTitle("Create Project", for: .normal)
        }
        
        
    }
    
    @objc func cancelButtonAction(sender: UIButton!){
        print("cancel button pressed ")
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.frame = CGRect(x: UIScreen.main.bounds.width , y: 0, width: 400, height: UIScreen.main.bounds.width)

        }, completion: { (finished: Bool) in
            self.removeFromSuperview()
        })
    }
    
    @objc func createProjectButtonAction(sender: UIButton!){
        print("create project button pressed")
        print(projectNameTextField.text!)
        self.delegate?.sendRequest(projectName: projectNameTextField.text!, projectID: self.projectID, isEdit: self.isEdit)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        print("begin editing")
        UIView.animate(withDuration: 0.5) {
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        print("end editing")
        UIView.animate(withDuration: 0.5) {
            
        }
        
    }
    
}
