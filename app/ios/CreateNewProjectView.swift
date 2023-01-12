//
//  CreateNewProjectView.swift
//  RTABMapApp
//
//  Created by Karan Sehgal on 23/11/2022.
//

import Foundation
import UIKit

protocol CreateNewProjectViewDelegate: AnyObject {
    func sendRequest(projectName: String, projectID: String, clientID:String, startDate:String, endDate:String, isEdit:Bool)
    func createNewClient(clientName:String)
    func showErrorToast(message:String)
}

class CreateNewProjectView: UIView, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let reuseIdentifier = "cell"
    public var delegate: CreateNewProjectViewDelegate!
    public var projectNameTextField: UITextField!
    public var clientNameTextField: UITextField!
    public var clientID: String!
    private var addClientButton: UIButton!
    public var startDatePicker: UIDatePicker!
    public var endDatePicker: UIDatePicker!
    public var projectID: String!
    public var isEdit: Bool!
    private var myCancelButton: UIButton!
    private var createProjectButton: UIButton!
    public var projectListTableView: UITableView!
    public var projectListArray: [[String: Any]] = []
    private var spinnerView: UIActivityIndicatorView!
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, screenWidth: CGFloat, screenHeight: CGFloat, projectName: String, projectID: String, clientID: String, clientName: String, startDate:String, endDate:String, isEdit: Bool) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.shadowColor = UIColor.systemGray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 2
        //self.isUserInteractionEnabled = true
        
        self.isEdit = isEdit
        self.projectID = projectID
        self.clientID = clientID
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
        clientNameTextField.text = clientName
        clientNameTextField.font = UIFont.systemFont(ofSize: 15)
        clientNameTextField.borderStyle = UITextField.BorderStyle.roundedRect
        clientNameTextField.autocorrectionType = UITextAutocorrectionType.no
        clientNameTextField.keyboardType = UIKeyboardType.default
        clientNameTextField.returnKeyType = UIReturnKeyType.done
        clientNameTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        clientNameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        clientNameTextField.delegate = self
        clientNameTextField.tag = 2
        self.addSubview(clientNameTextField)
        
        addClientButton = UIButton(frame: CGRect(x: self.frame.width-60, y: 150, width: 40, height: 40))
        addClientButton.backgroundColor = .clear
        addClientButton.addTarget(self, action: #selector(addClientButtonAction), for: .touchUpInside)
        let layer = CAGradientLayer()
        layer.frame = addClientButton.bounds
        layer.colors = [UIColor(red: 62.0/255.0, green: 121/255.0, blue: 229.0/255.0, alpha: 1.0).cgColor, UIColor(red: 1.0/255.0, green: 184.0/255.0, blue: 227.0/255.0, alpha: 1.0).cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.cornerRadius = 5
        addClientButton.layer.addSublayer(layer)
        //addClientButton.setTitle("+", for: .normal)
        self.addSubview(addClientButton)
        
        
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
        myCancelButton.setTitle("Cancel", for: .normal)
        myCancelButton.setTitleColor(UIColor(red: 0.259, green: 0.522, blue: 0.957, alpha: 1), for: .normal)
        myCancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
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
            clientNameTextField.isEnabled = false
            clientNameTextField.frame = CGRect(x: 25, y: 150, width: self.frame.width-50, height: 40)
            clientNameTextField.backgroundColor = .systemGray6
            clientNameTextField.borderStyle = .roundedRect
            addClientButton.isHidden = true
            
            createProjectButton.setTitle("Update", for: .normal)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if(!startDate.isEmpty && startDate.count > 0){
                let editedStartdate = dateFormatter.date(from:startDate)!
                startDatePicker.date = editedStartdate
                if(!endDate.isEmpty && endDate.count > 0){
                    let editedEnddate = dateFormatter.date(from:endDate)!
                    endDatePicker.date = editedEnddate
                }
                else{
                    endDatePicker.date = Date()+60*60*24*60
                }
            }
            else{
                startDatePicker.date = Date()
            }
        }
        else{
            createProjectButton.setTitle("Create Project", for: .normal)
            startDatePicker.date = Date()
            endDatePicker.date = Date()+60*60*24*60
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(cancelView), name: NSNotification.Name("com.user.projectcell.tapped"), object: nil)

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
    
    @objc func cancelView(){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.frame = CGRect(x: UIScreen.main.bounds.width , y: 0, width: 400, height: UIScreen.main.bounds.width)

        }, completion: { (finished: Bool) in
            self.removeFromSuperview()
        })
    }
    
    @objc func createProjectButtonAction(sender: UIButton!){
        print("create project button pressed")
        print(projectNameTextField.text!)
        
        if (!projectNameTextField.text!.isEmpty && !clientNameTextField.text!.isEmpty) {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let startDate: String = dateFormatter.string(from: startDatePicker.date)
            let endDate: String = dateFormatter.string(from: endDatePicker.date)
            print(startDate)
            print(endDate)
            if(!self.clientID.isEmpty){
                self.delegate?.sendRequest(projectName: projectNameTextField.text!, projectID: self.projectID, clientID: self.clientID, startDate:startDate, endDate:endDate, isEdit: self.isEdit)
            }
            else{
                self.delegate?.showErrorToast(message: "The client does not exist.")
            }
        }
        else{
            self.delegate?.showErrorToast(message: "Please enter project and client name.")
        }
        
        
    }
    
    @objc func addClientButtonAction(sender: UIButton!){
        print("add client button pressed")
        if (!clientNameTextField.text!.isEmpty) {
            projectListTableView.removeFromSuperview()
            clientNameTextField.resignFirstResponder()
            self.delegate?.createNewClient(clientName: clientNameTextField.text!)
        }
        else{
            self.delegate?.showErrorToast(message: "Please enter client name.")
            clientNameTextField.resignFirstResponder()
        }
        
    }
    
    // MARK: - UITextField Delegate Functions
    func textFieldDidBeginEditing(_ textField: UITextField){
        print("begin editing")
        if(textField.tag == 2){
            projectListTableView = UITableView(frame: CGRect(x: 25, y: 190, width: self.frame.width-100, height: 140))
            projectListTableView.backgroundColor = UIColor.white
            projectListTableView.layer.borderColor = UIColor.systemGray4.cgColor
            projectListTableView.layer.borderWidth = 1
//            projectListTableView.layer.shadowColor = UIColor.systemGray.cgColor
//            projectListTableView.layer.shadowOpacity = 1
//            projectListTableView.layer.shadowOffset = .zero
//            projectListTableView.layer.shadowRadius = 20
            //projectListTableView.clipsToBounds = false
            //projectListTableView.layer.masksToBounds = false
            projectListTableView.delegate = self
            projectListTableView.dataSource = self
            projectListTableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
            self.addSubview(projectListTableView)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        print("end editing")
        if(textField.tag == 2){
            projectListTableView.removeFromSuperview()
            clientNameTextField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print("end editing")
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
    
    
    // MARK: - UItableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        projectListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.image = UIImage(systemName: "star")
        content.text = self.projectListArray[indexPath.row]["clientName"] as? String
        content.imageProperties.tintColor = .blue
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clientNameTextField.text = self.projectListArray[indexPath.row]["clientName"] as? String
        self.clientID = self.projectListArray[indexPath.row]["clientId"] as? String
        clientNameTextField.resignFirstResponder()
        projectListTableView.removeFromSuperview()
    }
    
    // MARK: - Activity Spinner Functions
    func addSpinner(){
        spinnerView = UIActivityIndicatorView(style: .medium)
        spinnerView.color = .white
        spinnerView.center = addClientButton.center
        addClientButton.addSubview(spinnerView)
        spinnerView.startAnimating()
        addClientButton.setTitle("", for: .normal)
        //self.isUserInteractionEnabled = false
    }
    
    func removeSpinner(){
        self.spinnerView.stopAnimating()
        self.spinnerView.removeFromSuperview()
        addClientButton.setTitle("+", for: .normal)
        //self.isUserInteractionEnabled = true
    }
    
}

