//
//  LandingController.swift
//  RTABMapApp
//
//  Created by Karan Sehgal on 19/09/2022.
//

import Foundation
import UIKit

class LandingController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIContextMenuInteractionDelegate, UISearchBarDelegate, UICollectionViewDelegateFlowLayout {
    
    private var databases = [URL]()
    private var currentDatabaseIndex: Int = 0
    private var openedDatabasePath: URL?
    
    let RTABMAP_TMP_DB = "rtabmap.tmp.db"
    let RTABMAP_RECOVERY_DB = "rtabmap.tmp.recovery.db"
    let RTABMAP_EXPORT_DIR = "Export"
    let reuseIdentifier = "cell"
    

    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    private var projectTitle = UILabel()
    private let menuView = UIView()
    private let menuViewProjectsButton = UIButton()
    private let newScanButton = UIButton()
    private let profileButton = UIButton()
    private let backButton = UIButton()
    private let helpButton = UIButton()
    private var mySearchBar = UISearchBar()
    private var myCollectionView:UICollectionView!
    //private var myCollectionViewArray = [String]()
    private var myCollectionViewArray: [[String: Any]] = []
    private var myOriginalArray: [[String: Any]] = []
    private var isScansCollectionViewType:Bool!
    public var spinnerView: UIActivityIndicatorView!
    public var createNewProjectView: CreateNewProjectView!
    public var myProfileView: ProfileView!
    private var myProfileDictionary: [String: Any] = [:]
    public var projectID: String = ""
    //private var loginView = UIView()
    

    // MARK: - UI Rendering Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = true
        isScansCollectionViewType = false
        setupBaseElements()
        fetchProfile()
        fetchProjectsData()
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //super.viewWillTransition(to: size, with: coordinator)
        self.view.layoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(isScansCollectionViewType){
            self.createCollectionView()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //self.myCollectionView.removeFromSuperview()
    }
        
    func setupLoginView(){
        let loginView = LoginView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), screenWidth: screenWidth, screenHeight: screenHeight)
        loginView.backgroundColor = .white
        loginView.delegate = self
        self.view.addSubview(loginView)
    }

    func setupBaseElements(){
        projectTitle = UILabel(frame: CGRect(x: 140, y: 50, width: 400, height: 21))
        //projectTitle.center = CGPoint(x: 160, y: 285)
        //projectTitle.font = UIFont(name: projectTitle.font.fontName, size: 20)
        projectTitle.textAlignment = .left
        projectTitle.font = UIFont.preferredFont(forTextStyle: .headline)
        //projectTitle.font.withSize(20)
        projectTitle.textColor = UIColor(red: 157.0/255.0, green: 157.0/255.0, blue: 157.0/255.0, alpha: 1.0)
        projectTitle.font = UIFont(name: "Inter-Medium", size: 20)
        //var paragraphStyle = NSMutableParagraphStyle()
        //paragraphStyle.lineHeightMultiple = 0.83
        //projectTitle.text = "Projects"
        projectTitle.attributedText = NSMutableAttributedString().normal("Projects")
        projectTitle.isUserInteractionEnabled = true
        self.view.addSubview(projectTitle)
        
        mySearchBar.frame = CGRect(x:screenWidth-320, y:36 , width:300, height: 44)
        mySearchBar.searchBarStyle = UISearchBar.Style.default
        mySearchBar.backgroundColor = .clear
        mySearchBar.placeholder = " Search"
        mySearchBar.sizeToFit()
        mySearchBar.isTranslucent = false
        mySearchBar.backgroundImage = UIImage()
        mySearchBar.delegate = self
        //navigationItem.titleView = searchBar
        self.view.addSubview(mySearchBar)
        
        menuView.frame = CGRect(x:0, y:0 , width:80, height: screenHeight)
        menuView.backgroundColor = .systemGray6
        menuView.layer.shadowColor = UIColor.systemGray.cgColor
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowOffset = .zero
        menuView.layer.shadowRadius = 5
        self.view.addSubview(menuView)
        
        let logoImageView = UIImageView(image: UIImage(named: "Twinn LOGO.png")!)
        logoImageView.backgroundColor = .clear
        logoImageView.frame = CGRect(x: 15, y: 35, width: 50, height: 50)
        menuView.addSubview(logoImageView)
        
        menuViewProjectsButton.frame = CGRect(x: 4, y: 120, width: 72, height: 72)
        menuViewProjectsButton.layer.backgroundColor = UIColor(red: 0.259, green: 0.522, blue: 0.957, alpha: 1).cgColor
//        menuViewProjectsButton.titleLabel?.font = UIFont.systemFont(ofSize: 8)
//        //menuViewProjectsButton.titleLabel?.frame = CGRect(x: 3, y: 54, width: 66, height: 17)
//        //menuViewProjectsButton.titleLabel?.font = UIFont(name: "Inter-Regular", size: 8)
//        menuViewProjectsButton.setTitle("Projects",for: .normal)
//        menuViewProjectsButton.setTitle("Projects",for: .highlighted)
//        menuViewProjectsButton.setTitleColor(UIColor.white, for: .normal)
//        menuViewProjectsButton.setTitleColor(UIColor.white, for: .highlighted)
//        menuViewProjectsButton.setImage(UIImage(named: "ProjectsButtonImage1"), for: .normal)
//        menuViewProjectsButton.setImage(UIImage(named: "ProjectsButtonImage1"), for: .highlighted)
//        menuViewProjectsButton.contentVerticalAlignment = .center
//        menuViewProjectsButton.alignImageAndTitleVertically()
        menuViewProjectsButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        menuView.addSubview(menuViewProjectsButton)
        
        let buttonImageView = UIImageView(image: UIImage(named: "ProjectsButtonImage.png")!)
        buttonImageView.backgroundColor = .clear
        buttonImageView.frame = CGRect(x: 24, y: 10, width: 24, height: 24)
        menuViewProjectsButton.addSubview(buttonImageView)

        let buttonLabel = UILabel()
        buttonLabel.frame = CGRect(x: 3, y: 45, width: 66, height: 17)
        buttonLabel.backgroundColor = .clear
        buttonLabel.textColor = UIColor(red: 0.914, green: 0.922, blue: 0.922, alpha: 1)
        buttonLabel.textAlignment = .center
        buttonLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        buttonLabel.font = UIFont(name: "Inter-Regular", size: 10)
        buttonLabel.text = "Projects"
        buttonLabel.numberOfLines = 1
        buttonLabel.adjustsFontSizeToFitWidth = true
        menuViewProjectsButton.addSubview(buttonLabel)
        
        profileButton.frame = CGRect(x: 20, y: screenHeight-70, width: 40, height: 40)
        //profileButton.backgroundColor = .systemGreen
        profileButton.setImage(UIImage(named: "ProfilePlaceholder"), for: .normal)
        profileButton.setImage(UIImage(named: "ProfilePlaceholder"), for: .highlighted)
        profileButton.addTarget(self, action: #selector(profileButtonAction), for: .touchUpInside)
        menuView.addSubview(profileButton)
        
        helpButton.frame = CGRect(x: 27, y: screenHeight-60, width: 25, height: 25)
        //profileButton.backgroundColor = .systemGreen
        helpButton.setImage(UIImage(named: "HelpIcon"), for: .normal)
        //helpButton.setImage(UIImage(named: "HelpIcon"), for: .highlighted)
        helpButton.addTarget(self, action: #selector(logoutButtonAction), for: .touchUpInside)
        //menuView.addSubview(helpButton)

        backButton.frame = CGRect(x: 100, y: 50, width: 30, height: 30)
        //backButton.backgroundColor = .systemGreen
        backButton.setImage(UIImage(systemName: "arrowshape.left.fill"), for: .normal)
        //backButton.setImage(UIImage(named: "BackButton"), for: .highlighted)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        self.view.addSubview(backButton)
        backButton.isHidden = true
        
        newScanButton.frame = CGRect(x: screenWidth-156, y: screenHeight-62, width: 146, height: 52)
        newScanButton.backgroundColor = .clear
        newScanButton.setTitle("Create Project", for: .normal)
        //newScanButton.titleLabel?.font = UIFont(name: "Sora-SemiBold", size: 16)
        newScanButton.addTarget(self, action: #selector(newScanButtonAction), for: .touchUpInside)
        let l = CAGradientLayer()
        l.frame = newScanButton.bounds
        l.colors = [UIColor(red: 62.0/255.0, green: 121/255.0, blue: 229.0/255.0, alpha: 1.0).cgColor, UIColor(red: 1.0/255.0, green: 184.0/255.0, blue: 227.0/255.0, alpha: 1.0).cgColor]
        l.startPoint = CGPoint(x: 0, y: 0.5)
        l.endPoint = CGPoint(x: 1, y: 0.5)
        l.cornerRadius = 10
        newScanButton.layer.addSublayer(l)
        self.view.addSubview(newScanButton)
    
    }
    
    func setupScanListView(){
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        myCollectionView = ProjectsListCollectionView(frame: CGRect(x: 100, y: 110, width: UIScreen.main.bounds.width-110, height: UIScreen.main.bounds.height-110), collectionViewLayout: layout)
        //myCollectionView = ProjectsListCollectionView(frame: CGRect(x: 122, y: 148, width: UIScreen.main.bounds.width-132, height: UIScreen.main.bounds.height-200))
        //myCollectionView.setCollectionViewLayout(layout, animated: true)
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        //layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        //layout.itemSize = CGSize(width: 200, height: 280)
        //layout.minimumLineSpacing = 50
        //layout.minimumInteritemSpacing = 10
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.backgroundColor = UIColor.clear
        myCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        //myCollectionView.register(ScanCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.view.addSubview(myCollectionView)
        self.view.bringSubviewToFront(newScanButton)
        self.view.bringSubviewToFront(projectTitle)
        self.view.bringSubviewToFront(backButton)
        
    }
    
    func createNewProjectView(withName: String, withProjectID: String, clientID: String, clientName: String, startDate:String, endDate:String, isEdit: Bool){
        createNewProjectView = CreateNewProjectView(frame: CGRect(x: screenWidth, y: 0, width: 400, height: screenHeight), screenWidth: screenWidth, screenHeight: screenHeight, projectName: withName, projectID: withProjectID, clientID: clientID, clientName: clientName, startDate:startDate, endDate:endDate, isEdit:isEdit)
        createNewProjectView.delegate = self
        self.view.addSubview(createNewProjectView)
        //self.view.bringSubviewToFront(newScanButton)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.createNewProjectView.frame = CGRect(x: self.screenWidth-400, y: 0, width: 400, height: self.screenHeight)

        }, completion: { (finished: Bool) in
            self.fetchClientsList()
        })
    }
    
    // MARK: - Helper Functions
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func updateDatabases(projectID: String)
    {
        databases.removeAll()
        myCollectionViewArray.removeAll()
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: getDocumentDirectory(), includingPropertiesForKeys: nil)
            // if you want to filter the directory contents you can do like this:
            
            let data = fileURLs.map { url in
                        (url, (try? url.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast)
                    }
                    .sorted(by: { $0.1 > $1.1 }) // sort descending modification dates
                    .map { $0.0 } // extract file names
            databases = data.filter{ $0.pathExtension == "db" && $0.lastPathComponent != RTABMAP_TMP_DB && $0.lastPathComponent != RTABMAP_RECOVERY_DB }
            print(databases)
            var tempArray = [URL]()
            for path in databases{
                let filteredPath:String = path.lastPathComponent.components(separatedBy: "-twinn-")[0]
                if filteredPath == projectID {
                    tempArray.append(path)
                }
            }
            databases = tempArray
            ///file:///private/var/mobile/Containers/Data/Application/FBBEA336-4AC8-431D-A440-28E4231FAA75/Documents/Door.db
            ///file:///private/var/mobile/Containers/Data/Application/4ACBF65C-BF27-4D72-A622-CB974952573D/Documents/Cup-twinn-30d56a6c-4afd-4a51-8e95-a56db94d410d.db
            if(isScansCollectionViewType)
            {
                if(databases.count > 0)
                {
                    for i in 0...databases.count-1 {
                        myCollectionViewArray.insert(["name": URL(fileURLWithPath: databases[i].path).lastPathComponent.components(separatedBy: ".")[0], "clientName":"","image": "ProjectSmapleImage.png", "dateCreated":(try! URL(fileURLWithPath: databases[i].path).resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate!.getFormattedDate(format: "dd/MM/yyyy")), "status": "In Progress", "image2": databases[i].path], at: i)
                }
                
                }
            }
            else
            {
                //myCollectionViewArray.insert(["name": "Google", "clientName":"", "dateCreated":"22/11/2022", "status": "In Progress", "image": "ProjectSmapleImage.png"], at: 0)

            }
        } catch {
            print("Error while enumerating files : \(error.localizedDescription)")
            return
        }
    }
    
    func getDocumentDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func shareFile(_ fileUrl: URL) {
        let fileURL = NSURL(fileURLWithPath: fileUrl.path)

        // Create the Array which includes the files you want to share
        var filesToShare = [Any]()

        // Add the path of the file to the Array
        filesToShare.append(fileURL)

        // Make the activityViewContoller which shows the share-view
        let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }

        // Show the share-view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func rename(fileURL: URL)
    {
        //Step : 1
        let alert = UIAlertController(title: "Rename Scan", message: "Database Name (*.db):", preferredStyle: .alert )
        //Step : 2
        let rename = UIAlertAction(title: "Rename", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if textField.text != "" {
                //Read TextFields text data
                let fileName = textField.text!+".db"
                let filePath = self.getDocumentDirectory().appendingPathComponent(fileName).path
                if FileManager.default.fileExists(atPath: filePath) {
                    let alert = UIAlertController(title: "File Already Exists", message: "Do you want to overwrite the existing file?", preferredStyle: .alert)
                    let yes = UIAlertAction(title: "Yes", style: .default) {
                        (UIAlertAction) -> Void in
                        
                        do {
                            try FileManager.default.moveItem(at: fileURL, to: URL(fileURLWithPath: filePath))
                            print("File \(fileURL) renamed to \(filePath)")
                        }
                        catch {
                            print("Error renaming file \(fileURL) to \(filePath)")
                        }
                        self.updateDatabases(projectID: "")
                    }
                    alert.addAction(yes)
                    let no = UIAlertAction(title: "No", style: .cancel) {
                        (UIAlertAction) -> Void in
                    }
                    alert.addAction(no)
                    
                    self.present(alert, animated: true, completion: nil)
                } else {
                    do {
                        try FileManager.default.moveItem(at: fileURL, to: URL(fileURLWithPath: filePath))
                        print("File \(fileURL) renamed to \(filePath)")
                    }
                    catch {
                        print("Error renaming file \(fileURL) to \(filePath)")
                    }
                    self.createCollectionView()
                    
                    
                }
            }
        }

        //Step : 3
        alert.addTextField { (textField) in
            var components = fileURL.lastPathComponent.components(separatedBy: ".")
            if components.count > 1 { // If there is a file extension
              components.removeLast()
                textField.text = components.joined(separator: ".")
            } else {
                textField.text = fileURL.lastPathComponent
            }
        }

        //Step : 4
        alert.addAction(rename)
        //Cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { (alertAction) in })

        self.present(alert, animated: true) {
            alert.textFields?.first?.selectAll(nil)
        }
    }
    
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
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
    
    // MARK: - API Calls
    func fetchProjectsData(){
        isScansCollectionViewType = false
        if (isKeyPresentInUserDefaults(key: "access_token"))
        {
            myCollectionViewArray.removeAll()
            self.addSpinner()
            
            let parameters: [String: Any] = [:]
            APIHelper.shareInstance.apiCall(endpoint: "/project", parameters: parameters, method: "GET") { responseString, error in
                //print(responseString)
                
                DispatchQueue.main.async {
                    self.removeSpinner()
                    
                    if(responseString == ""){
                        self.showToast(message: "Something went wrong.", font: UIFont.preferredFont(forTextStyle: .body))
                    }
                    else{
                        let dict = self.convertToDictionary(text: responseString)
                
                        if let projects = dict?["projects"] as? [[String: AnyObject]] {
                            //for i in 0...projects.count-1 {}
                                for project in projects {
                                    if project["projectName"] is String {
                                        self.myCollectionViewArray.append([
                                            "name": project["projectName"]!,
                                            "clientName":project["clientName"]!,
                                            "clientId":project["clientId"]!,
                                            "dateCreated":project["startDate"]!,
                                            "endDate":project["endDate"]!,
                                            "status": "In Progress",
                                            "image": "ProjectSmapleImage.png",
                                            "projectId":project["projectId"]!])
                                        UserDefaults.standard.setValue(project["clientId"]!, forKey: "clientId")
                                    }
                                }
                            self.myOriginalArray = self.myCollectionViewArray
                        }
                        
                        self.setupScanListView()
                    }
                }
            }
        }
        else
        {
            setupLoginView()
            //self.showToast(message: "Your session has expired, please login again.", font: UIFont.preferredFont(forTextStyle: .body))
        }
    }
    
    func fetchScansData(projectID: String){

        if (isKeyPresentInUserDefaults(key: "access_token"))
        {
            myCollectionViewArray.removeAll()
            self.addSpinner()
            
            let parameters: [String: Any] = [:]
            ///"/storage?path=/Projects/"+projectID+"/Scans"
            ///storage?path=/Projects/1234/Scans
            APIHelper.shareInstance.apiCall(endpoint: "/storage?path=/Projects/"+projectID+"/Scans", parameters: parameters, method: "GET") { responseString, error in
                //print(responseString)
                
                DispatchQueue.main.async {
                    self.removeSpinner()
                    
                    if(responseString == ""){
                        self.showToast(message: "Something went wrong.", font: UIFont.preferredFont(forTextStyle: .body))
                    }
                    else{
                        let dict = self.convertToDictionary(text: responseString)
                
                        if let scans = dict?["data"] as? [[String: AnyObject]] {
                            //for i in 0...projects.count-1 {}
                                for scan in scans {
                                    self.myCollectionViewArray.append([
                                        "Id": scan["Id"]!,
                                        "name":scan["name"]!,
                                        "display_name":scan["display_name"]!,
                                        "downloadUrl":scan["downloadUrl"]!,
                                        "dateCreated":scan["createdAt"]!,
                                        "path":scan["path"]!,
                                        "status": "In Progress",
                                        "image": "ProjectSmapleImage.png",
                                        "resource":scan["resource"]!])
                                }
                            
                        }
                        print(self.myCollectionViewArray)
                        if(!self.myCollectionViewArray.isEmpty){
                            self.setupScanListView()
                        }
                        
                    }
                }
            }
        }
        else
        {
            setupLoginView()
            //self.showToast(message: "Your session has expired, please login again.", font: UIFont.preferredFont(forTextStyle: .body))
        }
    }
    
    func fetchClientsList(){
        isScansCollectionViewType = false
        if (isKeyPresentInUserDefaults(key: "access_token"))
        {
            self.createNewProjectView.addSpinner()
            
            let parameters: [String: Any] = [:]
            APIHelper.shareInstance.apiCall(endpoint: "/client", parameters: parameters, method: "GET") { responseString, error in
                //print(responseString)
                
                DispatchQueue.main.async {
                    self.createNewProjectView.removeSpinner()
                    
                    if(responseString == ""){
                        self.showToast(message: "Something went wrong.", font: UIFont.preferredFont(forTextStyle: .body))
                    }
                    else{
                        let dict = self.convertToDictionary(text: responseString)
                        print(responseString)
                        if let clients = dict?["clients"] as? [[String: AnyObject]] {
                            for client in clients{
                                self.createNewProjectView.projectListArray.append(
                                    ["clientName":client["clientName"]!,
                                     "clientId":client["clientId"]!])
                            }
                        }
                        print(self.createNewProjectView.projectListArray)
                    }
                }
            }
        }
        else
        {
            
            //self.showToast(message: "Your session has expired, please login again.", font: UIFont.preferredFont(forTextStyle: .body))
        }
    }
    
    func createNewProject(name:String, clientID: String, projectID: String, startDate: String, endDate: String){
        isScansCollectionViewType = false
        if (isKeyPresentInUserDefaults(key: "access_token"))
        {
            print(clientID)
            myCollectionViewArray.removeAll()
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                self.createNewProjectView.frame = CGRect(x: self.screenWidth, y: 0, width: 400, height: self.screenHeight)
            }, completion: { (finished: Bool) in
                self.createNewProjectView.removeFromSuperview()
            })
            self.addSpinner()
            newScanButton.setTitle("", for: .normal)
            //"730381f5-c003-4206-86d8-a21a68fb2b72"
            //730381f5-c003-4206-86d8-a21a68fb2b72
            let parameters: [String: Any] = [
                "clientId": clientID,
                "projectName": name,
                "description": "",
                "startDate": startDate,
                "endDate": endDate,
                "address": "",
                "contactPoint": "",
                "contact": "",
                "projectType": "",
                "projectImage": ""
            ]
            APIHelper.shareInstance.apiCall(endpoint: "/project", parameters: parameters, method: "POST") { responseString, error in
                DispatchQueue.main.async {
                    self.removeSpinner()

                    if(responseString == ""){
                        self.showToast(message: "Something went wrong.", font: UIFont.preferredFont(forTextStyle: .body))
                        self.labelsSwitchToProjectsView()
                    }
                    else
                    {
                        self.showToast(message: "Project created successfully", font: UIFont.preferredFont(forTextStyle: .body))

                        UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
                            self.myCollectionViewArray.removeAll()
                            self.myCollectionView.removeFromSuperview()
                        }, completion: { (finished: Bool) in
                            self.fetchProjectsData()
                            self.labelsSwitchToProjectsView()
                        })
                        
                    }
                    
                }
            }
        }
        else
        {
            setupLoginView()
            self.showToast(message: "Your session has expired, please login again.", font: UIFont.preferredFont(forTextStyle: .body))
        }
    }
    
    func modifyProject(name:String, clientID: String, projectID: String, startDate: String, endDate: String){
        isScansCollectionViewType = false
        if (isKeyPresentInUserDefaults(key: "access_token"))
        {
            myCollectionViewArray.removeAll()
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                self.createNewProjectView.frame = CGRect(x: self.screenWidth, y: 0, width: 400, height: self.screenHeight)
            }, completion: { (finished: Bool) in
                self.createNewProjectView.removeFromSuperview()
            })
            self.addSpinner()
            newScanButton.setTitle("", for: .normal)
            //"730381f5-c003-4206-86d8-a21a68fb2b72"
            let parameters: [String: Any] = [
                "clientId": clientID,
                "projectName": name,
                "projectId":projectID,
                "description": "",
                "startDate": startDate,
                "endDate": endDate,
                "address": "",
                "contactPoint": "",
                "contact": "",
                "projectType": "",
                "projectImage": ""
            ]
            APIHelper.shareInstance.apiCall(endpoint: "/project", parameters: parameters, method: "PUT") { responseString, error in
                DispatchQueue.main.async {
                    self.removeSpinner()

                    if(responseString == ""){
                        self.showToast(message: "Something went wrong.", font: UIFont.preferredFont(forTextStyle: .body))
                    }
                    else
                    {
                        //print(responseString)
                        self.showToast(message: "Project updated successfully", font: UIFont.preferredFont(forTextStyle: .body))

                        UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
                            self.myCollectionViewArray.removeAll()
                            self.myCollectionView.removeFromSuperview()
                        }, completion: { (finished: Bool) in
                            self.fetchProjectsData()
                            self.labelsSwitchToProjectsView()
                        })
                        
                    }
                    
                }
            }
        }
        else
        {
            setupLoginView()
            self.showToast(message: "Your session has expired, please login again.", font: UIFont.preferredFont(forTextStyle: .body))
        }
    }
    
    func deleteProject(projectID:String){
        isScansCollectionViewType = false
        if (isKeyPresentInUserDefaults(key: "access_token"))
        {
            
            self.addSpinner()
            let parameters: [String: Any] = [
                "projectId": projectID
            ]
            print(projectID)
            APIHelper.shareInstance.apiCall(endpoint:"/project/"+projectID, parameters: parameters, method: "DELETE") { responseString, error in
                DispatchQueue.main.async {
                    self.removeSpinner()

                    if(responseString == ""){
                        self.showToast(message: "Something went wrong.", font: UIFont.preferredFont(forTextStyle: .body))
                    }
                    else
                    {
                        self.showToast(message: "Project deleted successfully", font: UIFont.preferredFont(forTextStyle: .body))

                        UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
                            self.myCollectionViewArray.removeAll()
                            self.myCollectionView.removeFromSuperview()
                        }, completion: { (finished: Bool) in
                            self.fetchProjectsData()
                            self.labelsSwitchToProjectsView()
                        })
                        
                    }
                    
                }
            }
        }
        else
        {
            setupLoginView()
            self.showToast(message: "Your session has expired, please login again.", font: UIFont.preferredFont(forTextStyle: .body))
        }
    }
    
    func duplicateProject(projectID:String){
        isScansCollectionViewType = false
        if (isKeyPresentInUserDefaults(key: "access_token"))
        {
            
            self.addSpinner()
            let parameters: [String: Any] = [
                "projectId": projectID
            ]
            print(projectID)
            APIHelper.shareInstance.apiCall(endpoint:"/project/duplicate/project", parameters: parameters, method: "POST") { responseString, error in
                DispatchQueue.main.async {
                    self.removeSpinner()

                    if(responseString == ""){
                        self.showToast(message: "Something went wrong.", font: UIFont.preferredFont(forTextStyle: .body))
                    }
                    else
                    {
                        self.showToast(message: "Project duplicated successfully", font: UIFont.preferredFont(forTextStyle: .body))

                        UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
                            self.myCollectionViewArray.removeAll()
                            self.myCollectionView.removeFromSuperview()
                        }, completion: { (finished: Bool) in
                            self.fetchProjectsData()
                            self.labelsSwitchToProjectsView()
                        })
                        
                    }
                    
                }
            }
        }
        else
        {
            setupLoginView()
            self.showToast(message: "Your session has expired, please login again.", font: UIFont.preferredFont(forTextStyle: .body))
        }
    }
    
    func addNewClient(clientName:String){
        isScansCollectionViewType = false
        if (isKeyPresentInUserDefaults(key: "access_token"))
        {
            self.createNewProjectView.addSpinner()
            var dataArray: [[String:Any]] = []
            let dataDictionary: [String:Any] = ["addressId": "","addressLine1": "","addressLine2": "","city": "","state": "","country": "","pincode": "","clientId": "","address_type_id": 1]
            dataArray.append(dataDictionary)
            
            let parameters: [String: Any] = [
                "clientName": clientName,
                "email": "",
                 "contactNumber": "",
                 "about": "",
                 "logoImage": "",
                 "addresses": dataArray
            ]
            
            APIHelper.shareInstance.apiCall(endpoint:"/client", parameters: parameters, method: "POST") { responseString, error in
                DispatchQueue.main.async {
                    self.createNewProjectView.removeSpinner()

                    if(responseString == ""){
                        self.showToast(message: "Something went wrong.", font: UIFont.preferredFont(forTextStyle: .body))
                    }
                    else
                    {
                        let dict = self.convertToDictionary(text: responseString)
                        let clientName = dict?["clientName"] as? String
                        let clientID = dict?["clientId"] as? String
                        self.createNewProjectView.projectListArray.append(
                            ["clientName":clientName!,
                             "clientId":clientID!])
                        
                        self.createNewProjectView.clientID = clientID
                        self.showToast(message: "Client created successfully", font: UIFont.preferredFont(forTextStyle: .body))
                    }
                    
                }
            }
        }
        else
        {
            setupLoginView()
            self.showToast(message: "Your session has expired, please login again.", font: UIFont.preferredFont(forTextStyle: .body))
        }
    }
    
    func fetchProfile(){
        isScansCollectionViewType = false
        if (isKeyPresentInUserDefaults(key: "access_token"))
        {
            
            let parameters: [String: Any] = [:]
            APIHelper.shareInstance.User(endpoint:"/user/me", parameters: parameters, method: "GET", accessToken: true) { responseString, error in
                DispatchQueue.main.async {
                    if(responseString == ""){
                        self.showToast(message: "Something went wrong.", font: UIFont.preferredFont(forTextStyle: .body))
                    }
                    else
                    {
                        //{"userId":"92d2f8b5-70df-4880-a4ee-86f12fa700e6","username":"karan3391","email":"karan3391@gmail.com","firstName":"Karan","lastName":"Sehgal","countryCode":"US","profileImage":"","isActive":true,"accountId":"c9b3f7b7-853c-410e-8de1-333e40ed6a5e","containerName":"c-c9b3f7b7-853c-410e-8de1-333e40ed6a5e"}
                        self.myProfileDictionary = self.convertToDictionary(text: responseString)!
                        print(self.myProfileDictionary)
                        print("My Profile Data")
                    }
                    
                }
            }
        }
        else
        {
        
        }
    }
 
    // MARK: - UISearchBarDelegate protocol
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidBeginEditing")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        print(textSearched)
        self.myCollectionViewArray = self.myOriginalArray
        
        if(!textSearched.isEmpty){
            var myArray = [[String:Any]]()
            for i in 0...self.myCollectionViewArray.count-1{
                let val = self.myCollectionViewArray[i]["name"] as? String
                var result = val?.lowercased().contains(textSearched)
                if(result!){
                    myArray.append(self.myCollectionViewArray[i])
                }
            }
            self.myCollectionViewArray = myArray
            
        }
        self.myCollectionView.removeFromSuperview()
        setupScanListView()

    }
    

    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.myCollectionViewArray.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let interaction = UIContextMenuInteraction(delegate: self)
        cell.backgroundColor = UIColor.white
        cell.layer.shadowColor = UIColor.systemGray.cgColor
        cell.layer.shadowOpacity = 1
        cell.layer.shadowOffset = .zero
        cell.layer.shadowRadius = 2
        
        let cellOptionsButton = UIButton(frame: CGRect(x: cell.frame.width-25, y: 16, width: 20, height: 20))
        cellOptionsButton.backgroundColor = .clear
        cellOptionsButton.imageView?.contentMode = .scaleAspectFit
        cellOptionsButton.setImage(UIImage(named: "CellOptionsButton"), for: .normal)
        cellOptionsButton.setImage(UIImage(named: "CellOptionsButton"), for: .highlighted)
        //cellOptionsButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        cellOptionsButton.addInteraction(interaction)
        cellOptionsButton.tag = indexPath.row
        cellOptionsButton.showsMenuAsPrimaryAction = true
        
        if(self.isScansCollectionViewType){
            let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                print(self.databases[interaction.view!.tag])
                self.shareFile(self.databases[interaction.view!.tag])
            }
            
            let editAction = UIAction(title: "Rename", image: UIImage(systemName: "square.and.pencil")) { _ in
                self.rename(fileURL: self.databases[interaction.view!.tag])
            }
            
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                do {
                    try FileManager.default.removeItem(at: self.databases[interaction.view!.tag])
                }
                catch {
                    print("Error deleting file \(self.databases[interaction.view!.tag])")
                }
                self.createCollectionView()
            }
            cellOptionsButton.menu = UIMenu(title: "", children: [shareAction, deleteAction])
        }
        else{
            let editAction = UIAction(title: "Edit Project Name", image: UIImage(systemName: "square.and.pencil")) { _ in
                let projectID = self.myCollectionViewArray[interaction.view!.tag]["projectId"] as? String
                let projectName = self.myCollectionViewArray[interaction.view!.tag]["name"] as? String
                let startDate = self.myCollectionViewArray[interaction.view!.tag]["dateCreated"] as? String
                let endDate = self.myCollectionViewArray[interaction.view!.tag]["endDate"] as? String
                let clientID = self.myCollectionViewArray[interaction.view!.tag]["clientId"] as? String
                let clientName = self.myCollectionViewArray[interaction.view!.tag]["clientName"] as? String
                self.createNewProjectView(withName: projectName!, withProjectID: projectID!, clientID: clientID!, clientName: clientName!, startDate: startDate!, endDate: endDate!, isEdit: true)
                
            }
            
            let copyLinkAction = UIAction(title: "Copy Link", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                let projectID = self.myCollectionViewArray[interaction.view!.tag]["projectId"] as? String
                
                // write to clipboard
                UIPasteboard.general.string = projectID!

                // read from clipboard
                //let content = UIPasteboard.general.string
                
                self.showToast(message: "Project ID copied to clipboard.", font: UIFont.preferredFont(forTextStyle: .body))
            }
            
            let duplicateAction = UIAction(title: "Duplicate", image: UIImage(systemName: "square.and.arrow.down.on.square")) { _ in
                let projectID = self.myCollectionViewArray[interaction.view!.tag]["projectId"] as? String
                self.duplicateProject(projectID: projectID!)
            }
            
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                
                let projectID = self.myCollectionViewArray[interaction.view!.tag]["projectId"] as? String
                self.deleteProject(projectID: projectID!)
            }
            cellOptionsButton.menu = UIMenu(title: "", children: [editAction, copyLinkAction, duplicateAction, deleteAction])
        }
        cell.addSubview(cellOptionsButton)
        
        let scanTitle = UILabel(frame: CGRect(x: 12, y: 16, width: 170, height: 15))
        //projectTitle.font = UIFont(name: projectTitle.font.fontName, size: 20)
        scanTitle.backgroundColor = .clear
        scanTitle.textAlignment = .left
        scanTitle.font = UIFont.preferredFont(forTextStyle: .body)
        scanTitle.font.withSize(8)
        scanTitle.textColor = .gray
        //scanTitle.text = "Scan "+String(indexPath.row+1)
        let itemName = self.myCollectionViewArray[indexPath.row]["name"] as? String
        
        cell.addSubview(scanTitle)
        
        //let imageName = "SampleScan.png"
        //let image = UIImage(named: imageName)
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 10, y: 50, width: cell.frame.width-20, height: 146)
        cell.addSubview(imageView)
        
        let dateScanTitle = UILabel(frame: CGRect(x: 12, y: 241, width: 70, height: 12))
        //projectTitle.center = CGPoint(x: 160, y: 285)
        //projectTitle.font = UIFont(name: projectTitle.font.fontName, size: 20)
        dateScanTitle.backgroundColor = .clear
        dateScanTitle.textAlignment = .left
        dateScanTitle.font = UIFont.preferredFont(forTextStyle: .body)
        dateScanTitle.font.withSize(8)
        dateScanTitle.textColor = .systemGray
        dateScanTitle.numberOfLines = 1
        dateScanTitle.adjustsFontSizeToFitWidth = true
        dateScanTitle.text = "Date Created"
        cell.addSubview(dateScanTitle)
        
        let dateTitle = UILabel(frame: CGRect(x: 12, y: 254, width: 70, height: 15))
        //projectTitle.center = CGPoint(x: 160, y: 285)
        //projectTitle.font = UIFont(name: projectTitle.font.fontName, size: 20)
        dateTitle.backgroundColor = .clear
        dateTitle.textAlignment = .left
        dateTitle.font = UIFont.preferredFont(forTextStyle: .body)
        dateTitle.font.withSize(8)
        dateTitle.textColor = .systemBlue
        //dateTitle.text  = URL(fileURLWithPath: databases[indexPath.row].path).lastPathComponent
        //dateTitle.text = "05/08/2022"
        let scannedDate = self.myCollectionViewArray[indexPath.row]["dateCreated"] as? String
        dateTitle.text  = scannedDate?.components(separatedBy: " ")[0]
        dateTitle.numberOfLines = 1
        dateTitle.adjustsFontSizeToFitWidth = true
        cell.addSubview(dateTitle)
        
        
        if(self.isScansCollectionViewType)
        {
            
            imageView.image = UIImage(named: self.myCollectionViewArray[indexPath.row]["image"] as! String)!
//            DispatchQueue.global().async {
//                let downloadedImage = getPreviewImage(databasePath: self.myCollectionViewArray[indexPath.row]["image"] as! String)
//                DispatchQueue.main.async {
//                    imageView.image = downloadedImage
//                }
//            }
            
            //        let cellProgressView = UIProgressView(frame: CGRect(x: 0, y: 210, width: cell.frame.width, height: 20))
            //        cellProgressView.backgroundColor = .clear
            //        cellProgressView.setProgress(1.0, animated: true)
            //        cellProgressView.trackTintColor = UIColor(red: 0.925, green: 0.953, blue: 0.996, alpha: 1)
            //        cellProgressView.tintColor = UIColor(red: 0.235, green: 0.475, blue: 0.871, alpha: 1)
            //        let transform : CGAffineTransform = CGAffineTransformMakeScale(1.0, 3.0)
            //        cellProgressView.transform = transform
            //        cell.addSubview(cellProgressView)
            
            scanTitle.text = itemName?.components(separatedBy: "-twinn-")[1]
        }
        else
        {
            imageView.image = UIImage(named: self.myCollectionViewArray[indexPath.row]["image"] as! String)!
            scanTitle.text = itemName?.components(separatedBy: "-twinn-")[0]
            
            let clientName = UILabel(frame: CGRect(x: 110, y: 247, width: 80, height: 20))
            //projectTitle.center = CGPoint(x: 160, y: 285)
            //projectTitle.font = UIFont(name: projectTitle.font.fontName, size: 20)
            clientName.backgroundColor = .clear
            clientName.textAlignment = .right
            clientName.font = UIFont.preferredFont(forTextStyle: .body)
            clientName.font.withSize(8)
            clientName.textColor = .systemBlue
            clientName.numberOfLines = 1
            clientName.adjustsFontSizeToFitWidth = true
            clientName.text = self.myCollectionViewArray[indexPath.row]["clientName"] as? String
            cell.addSubview(clientName)
            
        }
        
        cell.addInteraction(interaction)
        cell.tag = indexPath.row
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: 200, height: 280)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 25, left: 15, bottom: 0, right: 5)
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.item)!")
        NotificationCenter.default.post(name: NSNotification.Name("com.user.projectcell.tapped"), object: nil)
       
        let projectID = self.myCollectionViewArray[indexPath.row]["projectId"] as? String
        
        if(isScansCollectionViewType)
        {
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GLKitViewController") as! ViewController
            //self.present(nextViewController, animated:true, completion:nil)
            nextViewController.passedIndex = indexPath.row
            nextViewController.projectID = projectID
            self.show(nextViewController, sender: currentDatabaseIndex)
        }
        else
        {
            isScansCollectionViewType = true
            self.labelsSwitchToScansView()
            
            
            let  projectName = self.myCollectionViewArray[indexPath.row]["name"] as? String
            projectTitle.attributedText =
                NSMutableAttributedString()
                    .underlined("Projects")
                    .normal(" | ")
                    .bold(projectName!)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            projectTitle.addGestureRecognizer(tapGesture)
                
            self.myCollectionView.removeFromSuperview()
            //myCollectionViewArray.removeAll()
            
            self.projectID = projectID!
//            self.fetchScansData(projectID: projectID!)
   
            self.updateDatabases(projectID: self.projectID)
            self.setupScanListView()

        }
    }
    
    func createCollectionView(){
        self.myCollectionView.removeFromSuperview()
        self.updateDatabases(projectID: self.projectID)
        
        UIView.animate(withDuration: 1.0, delay: 1.0, options: [], animations: {
            self.setupScanListView()
        }, completion: { (finished: Bool) in
        })
    }
    
    // MARK: - Button Actions
    @objc func newScanButtonAction(sender: UIButton!){
        print("button Pressed")
        if(isScansCollectionViewType)
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GLKitViewController") as! ViewController
            //self.present(nextViewController, animated:true, completion:nil)
            //nextViewController.passedIndex = currentDatabaseIndex
            nextViewController.projectID = self.projectID
            self.show(nextViewController, sender: currentDatabaseIndex)
        }
        else
        {
            self.createNewProjectView(withName: "", withProjectID: "", clientID: "", clientName: "", startDate: "", endDate: "", isEdit:false)
        }

    }
    
    @objc func backButtonAction(sender: UIButton!){
        NotificationCenter.default.post(name: NSNotification.Name("com.user.projectcell.tapped"), object: nil)
        isScansCollectionViewType = false
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
            self.myCollectionView.removeFromSuperview()
            self.myCollectionViewArray.removeAll()
        }, completion: { (finished: Bool) in
            self.fetchProjectsData()
            self.labelsSwitchToProjectsView()
        })
    }
    
    @objc func handleTap(_ gestureRecognize: UITapGestureRecognizer) {
        isScansCollectionViewType = false
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
            self.myCollectionViewArray.removeAll()
            self.myCollectionView.removeFromSuperview()
        }, completion: { (finished: Bool) in
            self.fetchProjectsData()
            self.labelsSwitchToProjectsView()
        })
    }
    
    @objc func profileButtonAction(sender: UIButton!){
        myProfileView = ProfileView(frame: CGRect(x: screenWidth, y: 0, width: 400, height: screenHeight), screenWidth: screenWidth, screenHeight: screenHeight, withDictionary: self.myProfileDictionary)
        myProfileView.delegate = self
        self.view.addSubview(myProfileView)
        //self.view.bringSubviewToFront(newScanButton)
        //
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.myProfileView.frame = CGRect(x: self.screenWidth-400, y: 0, width: 400, height: self.screenHeight)

        }, completion: { (finished: Bool) in

        })
    }
    
    @objc func logoutButtonAction(sender: UIButton!){
        isScansCollectionViewType = false
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
            self.myCollectionViewArray.removeAll()
            self.myCollectionView.removeFromSuperview()
        }, completion: { (finished: Bool) in
            self.labelsSwitchToProjectsView()
            self.setupLoginView()
            UserDefaults.standard.removeObject(forKey: "access_token")
        })
        
        
    }
    
    // MARK: - Context Menu Actions
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
            if(self.isScansCollectionViewType){
                let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                    print(self.databases[interaction.view!.tag])
                    self.shareFile(self.databases[interaction.view!.tag])
                }
                
                let editAction = UIAction(title: "Rename", image: UIImage(systemName: "square.and.pencil")) { _ in
                    self.rename(fileURL: self.databases[interaction.view!.tag])
                }
                
                let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    do {
                        try FileManager.default.removeItem(at: self.databases[interaction.view!.tag])
                    }
                    catch {
                        print("Error deleting file \(self.databases[interaction.view!.tag])")
                    }
                    self.createCollectionView()
                }
                return UIMenu(title: "", children: [shareAction, deleteAction])
            }
            else{
                let editAction = UIAction(title: "Edit Project Name", image: UIImage(systemName: "square.and.pencil")) { _ in
                    let projectID = self.myCollectionViewArray[interaction.view!.tag]["projectId"] as? String
                    let projectName = self.myCollectionViewArray[interaction.view!.tag]["name"] as? String
                    let startDate = self.myCollectionViewArray[interaction.view!.tag]["dateCreated"] as? String
                    let endDate = self.myCollectionViewArray[interaction.view!.tag]["endDate"] as? String
                    let clientID = self.myCollectionViewArray[interaction.view!.tag]["clientId"] as? String
                    let clientName = self.myCollectionViewArray[interaction.view!.tag]["clientName"] as? String
                    self.createNewProjectView(withName: projectName!, withProjectID: projectID!, clientID: clientID!, clientName: clientName!, startDate: startDate!, endDate: endDate!, isEdit: true)
                    
                }
                
                let copyLinkAction = UIAction(title: "Copy Link", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                    let projectID = self.myCollectionViewArray[interaction.view!.tag]["projectId"] as? String
                    
                    // write to clipboard
                    UIPasteboard.general.string = projectID!

                    // read from clipboard
                    //let content = UIPasteboard.general.string
                    
                    self.showToast(message: "Project ID copied to clipboard.", font: UIFont.preferredFont(forTextStyle: .body))
                }
                
                let duplicateAction = UIAction(title: "Duplicate", image: UIImage(systemName: "square.and.arrow.down.on.square")) { _ in
                    let projectID = self.myCollectionViewArray[interaction.view!.tag]["projectId"] as? String
                    self.duplicateProject(projectID: projectID!)
                }
                
                let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    
                    let projectID = self.myCollectionViewArray[interaction.view!.tag]["projectId"] as? String
                    self.deleteProject(projectID: projectID!)
                }
                return UIMenu(title: "", children: [editAction, copyLinkAction, duplicateAction, deleteAction])
            }
            
        }
    }
    
    // MARK: - Activity Spinner Functions
    func addSpinner(){
        spinnerView = UIActivityIndicatorView(style: .large)
        spinnerView.color = .darkGray
        spinnerView.center = self.view.center
        self.view.addSubview(spinnerView)
        spinnerView.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    
    func removeSpinner(){
        self.spinnerView.stopAnimating()
        self.spinnerView.removeFromSuperview()
        self.view.isUserInteractionEnabled = true
    }
    
    // MARK: - Switch Labels
    func labelsSwitchToProjectsView(){
        self.newScanButton.setTitle("Create Project", for: .normal)
        //self.projectTitle.text = "Projects"
        self.projectTitle.attributedText = NSMutableAttributedString().normal("Projects")
        self.backButton.isHidden = true
        self.mySearchBar.isHidden = false
    }
    
    func labelsSwitchToScansView(){
        self.newScanButton.setTitle("New Scan", for: .normal)
        self.backButton.isHidden = false
        self.mySearchBar.isHidden = true
    }
    
}//class ends

// MARK: - LoginViewExtension
extension LandingController: LoginViewDelegate {
    func sendSetupRequest(email: String, password: String) {
        fetchProfile()
        fetchProjectsData()
    }
    
    func showLoginErrorToast(message:String){
        showToast(message: message, font: UIFont.preferredFont(forTextStyle: .body))
    }
}

// MARK: - LoginViewExtension
extension LandingController: ProfileViewDelegate {
    func sendLogoutRequest(email: String, password: String) {
        logoutButtonAction(sender: nil)
    }
}

// MARK: - CreateNewProjectViewExtension
extension LandingController: CreateNewProjectViewDelegate {
    func sendRequest(projectName: String, projectID: String, clientID: String, startDate:String, endDate:String, isEdit: Bool) {
        
        if(isEdit){
            self.modifyProject(name: projectName, clientID: clientID, projectID: projectID, startDate: startDate, endDate: endDate)
        }
        else{
            self.createNewProject(name: projectName, clientID: clientID, projectID: projectID, startDate: startDate, endDate: endDate)
        }
    }
    
    func createNewClient(clientName:String){
        addNewClient(clientName: clientName)
    }
    
    func showErrorToast(message:String){
        showToast(message: message, font: UIFont.preferredFont(forTextStyle: .body))
    }
    
}

// MARK: - NSMutableAttributedStringExtension
extension NSMutableAttributedString {
    var fontSize:CGFloat { return 20 }
    var boldFont:UIFont { return UIFont(name: "AvenirNext-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont(name: "AvenirNext-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    func orangeHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.orange
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func blackHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func underlined(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
