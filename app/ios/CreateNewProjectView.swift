//
//  CreateNewProjectView.swift
//  RTABMapApp
//
//  Created by Karan Sehgal on 23/11/2022.
//

import Foundation
import UIKit

protocol CreateNewProjectViewDelegate: class {
    func sendRequest(projectName: String, projectID: String, startDate:String, endDate:String, isEdit:Bool)
}

class CreateNewProjectView: UIView, UITextFieldDelegate {
    
    public var delegate: CreateNewProjectViewDelegate!
    public var projectNameTextField: UITextField!
    public var clientNameTextField: UITextField!
    public var startDatePicker: UIDatePicker!
    public var endDatePicker: UIDatePicker!
    public var projectID: String!
    public var isEdit: Bool!
    private var myCancelButton: UIButton!
    private var createProjectButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, screenWidth: CGFloat, screenHeight: CGFloat, projectName: String, projectID: String, startDate:String, endDate:String, isEdit: Bool) {
        super.init(frame: frame)
        //self.isUserInteractionEnabled = true
        
        self.projectID = projectID
        self.isEdit = isEdit
        
        let locale = Locale.current
        print(locale.description)
        print(locale.regionCode!)
        
      
        let projectnameLabel = self.createLabel(frame: CGRect(x: 25, y: 50, width: 150, height: 20), labelText: "Project Name")
        self.addSubview(projectnameLabel)
        
        projectNameTextField = UITextField(frame: CGRect(x: 25, y: 75, width: self.frame.width-50, height: 40))
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
        
        let clientnameLabel = self.createLabel(frame: CGRect(x: 25, y: 125, width: 150, height: 20), labelText: "Client Name")
        self.addSubview(clientnameLabel)
        
        clientNameTextField = UITextField(frame: CGRect(x: 25, y: 150, width: self.frame.width-100, height: 40))
        clientNameTextField.placeholder = "Enter Client Name"
        clientNameTextField.text = projectName
        clientNameTextField.font = UIFont.systemFont(ofSize: 15)
        clientNameTextField.borderStyle = UITextField.BorderStyle.roundedRect
        clientNameTextField.autocorrectionType = UITextAutocorrectionType.no
        clientNameTextField.keyboardType = UIKeyboardType.default
        clientNameTextField.returnKeyType = UIReturnKeyType.done
        clientNameTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        clientNameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        clientNameTextField.delegate = self
        self.addSubview(clientNameTextField)
        
        startDatePicker = UIDatePicker()
        startDatePicker.frame = CGRect(x: 25, y: 200, width: self.frame.width-50, height: 50)
        startDatePicker.timeZone = NSTimeZone.local
        startDatePicker.datePickerMode = .date
        startDatePicker.backgroundColor = UIColor.clear
        startDatePicker.addTarget(self, action: #selector(startDatePickerValueChanged(_:)), for: .valueChanged)
        self.addSubview(startDatePicker)
        
        let startDateLabel = self.createLabel(frame: CGRect(x: 0, y: 15, width: 150, height: 20), labelText: "Start Date")
        startDatePicker.addSubview(startDateLabel)
        
        endDatePicker = UIDatePicker()
        endDatePicker.frame = CGRect(x: 25, y: 260, width: self.frame.width-50, height: 50)
        endDatePicker.timeZone = NSTimeZone.local
        endDatePicker.datePickerMode = .date
        endDatePicker.backgroundColor = UIColor.clear
        endDatePicker.addTarget(self, action: #selector(endDatePickerValueChanged(_:)), for: .valueChanged)
        self.addSubview(endDatePicker)
        
        let endDateLabel = self.createLabel(frame: CGRect(x: 0, y: 15, width: 150, height: 20), labelText: "End Date")
        endDatePicker.addSubview(endDateLabel)
        
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
        
        
    
        if(self.isEdit && !startDate.isEmpty && !endDate.isEmpty && startDate.count > 0 && endDate.count > 0){
            createProjectButton.setTitle("Update", for: .normal)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let editedStartdate = dateFormatter.date(from:startDate)!
            let editedEnddate = dateFormatter.date(from:endDate)!
            startDatePicker.date = editedStartdate
            endDatePicker.date = editedEnddate
        }
        else{
            createProjectButton.setTitle("Create Project", for: .normal)
            startDatePicker.date = Date()
            endDatePicker.date = Date()+60*60*24*60
        }
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
    
    @objc func createProjectButtonAction(sender: UIButton!){
        print("create project button pressed")
        print(projectNameTextField.text!)
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate: String = dateFormatter.string(from: startDatePicker.date)
        let endDate: String = dateFormatter.string(from: endDatePicker.date)
        print(startDate)
        print(endDate)
        self.delegate?.sendRequest(projectName: projectNameTextField.text!, projectID: self.projectID, startDate:startDate, endDate:endDate, isEdit: self.isEdit)
       
    }
    
    // MARK: - UITextField Delegate Functions
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
    
    // MARK: - UIDatePicker Functions
    func openDatePicker(){
        
    }
    
    @objc func startDatePickerValueChanged(_ sender: UIDatePicker){
         
        let dateFormatter: DateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let selectedDate: String = dateFormatter.string(from: sender.date)
        print("Selected value \(selectedDate)")
     }
    
    @objc func endDatePickerValueChanged(_ sender: UIDatePicker){
         
        let dateFormatter: DateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let selectedDate: String = dateFormatter.string(from: sender.date)
        print("Selected value \(selectedDate)")
     }
    
}

