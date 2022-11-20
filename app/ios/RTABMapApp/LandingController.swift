//
//  LandingController.swift
//  RTABMapApp
//
//  Created by Karan Sehgal on 19/09/2022.
//

import Foundation
import UIKit



class LandingController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIContextMenuInteractionDelegate, UISearchBarDelegate, UICollectionViewDelegateFlowLayout {

    @IBAction func launchButton(_ sender: UIButton) {
       // self.navigationController?.pushViewController(ViewController, animated: true)
    }
    
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
    
    private enum ViewConstants {
        static let Padding: CGFloat = 10
        static let Dimensions: CGFloat = 100
        static let Offset: CGFloat = 0
    }
    
    private struct myDataModel {
        var name: String
        var clientName: String
        var dateCreated: String
        var status: String
        var image: String
        
    }
    
    private var projectTitle = UILabel()
    private let menuView = UIView()
    private let menuViewProjectsButton = UIButton()
    private let newScanButton = UIButton()
    private let profileButton = UIButton()
    private let helpButton = UIButton()
    private var searchBar = UISearchBar()
    private var myCollectionView:UICollectionView!
    //private var myCollectionViewArray = [String]()
    private var myCollectionViewArray: [[String: Any]] = []
    private var myCollectionViewType:Bool!
    //private var loginView = UIView()
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.isUserInteractionEnabled = true
        myCollectionViewType = false
        
        self.updateDatabases()
        if databases.isEmpty {
            return
        }
        setupBaseElements()
        //setupProjectListView()
        setupScanListView()
        
        
        if (isKeyPresentInUserDefaults(key: "access_token"))
        {
            //do nothing
            setupLoginView()
        }
        else
        {
            setupLoginView()
        }
        //UserDefaults.standard.setValue(dataModel, forKey: "access_token")
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //super.viewWillTransition(to: size, with: coordinator)
        
        self.view.layoutSubviews()
//        self.view.setNeedsDisplay()
//            if UIDevice.current.orientation.isLandscape {
//                print("Landscape")
//            } else {
//                print("Portrait")
//            }
//        self.view.contentMode = .redraw
//        newScanButton.frame = CGRect(x: screenWidth-110, y: screenHeight-60, width: 100, height: 50)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)
//        self.updateDatabases()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.myCollectionView.removeFromSuperview()
        
    }
    
     @objc func update()
    {
        self.setupScanListView()
    }
    
    func setupLoginView()
    {
        let loginView = LoginView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), screenWidth: screenWidth, screenHeight: screenHeight)
        loginView.backgroundColor = .white
        loginView.delegate = self
        self.view.addSubview(loginView)
    }
    
    func setupBaseElements()
    {
        projectTitle = UILabel(frame: CGRect(x: 122, y: 50, width: 400, height: 21))
        //projectTitle.center = CGPoint(x: 160, y: 285)
        //projectTitle.font = UIFont(name: projectTitle.font.fontName, size: 20)
        projectTitle.textAlignment = .left
        projectTitle.font = UIFont.preferredFont(forTextStyle: .headline)
        //projectTitle.font.withSize(20)
        projectTitle.textColor = UIColor(red: 157.0/255.0, green: 157.0/255.0, blue: 157.0/255.0, alpha: 1.0)
        projectTitle.font = UIFont(name: "Inter-Medium", size: 20)
        //var paragraphStyle = NSMutableParagraphStyle()
        //paragraphStyle.lineHeightMultiple = 0.83
        projectTitle.text = "Organization Name | Projects | Project Name"
        self.view.addSubview(projectTitle)
        
        searchBar.frame = CGRect(x:screenWidth-320, y:36 , width:300, height: 44)
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.backgroundColor = .clear
        searchBar.placeholder = " Search"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        //navigationItem.titleView = searchBar
        self.view.addSubview(searchBar)
        
        menuView.frame = CGRect(x:0, y:0 , width:80, height: screenHeight)
        menuView.backgroundColor = .systemGray6
        menuView.layer.shadowColor = UIColor.systemGray.cgColor
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowOffset = .zero
        menuView.layer.shadowRadius = 5
        self.view.addSubview(menuView)
        
        let logoImageView = UIImageView(image: UIImage(named: "Twinn LOGO.png")!)
        logoImageView.backgroundColor = .clear
        logoImageView.frame = CGRect(x: 15, y: 25, width: 50, height: 50)
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
        menuViewProjectsButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
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
        
        profileButton.frame = CGRect(x: 20, y: screenHeight-125, width: 40, height: 40)
        //profileButton.backgroundColor = .systemGreen
        profileButton.setImage(UIImage(named: "ProfilePlaceholder"), for: .normal)
        profileButton.setImage(UIImage(named: "ProfilePlaceholder"), for: .highlighted)
        profileButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        menuView.addSubview(profileButton)
        
        helpButton.frame = CGRect(x: 27, y: screenHeight-60, width: 25, height: 25)
        //profileButton.backgroundColor = .systemGreen
        helpButton.setImage(UIImage(named: "HelpIcon"), for: .normal)
        helpButton.setImage(UIImage(named: "HelpIcon"), for: .highlighted)
        helpButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        menuView.addSubview(helpButton)
    }
    
    func setupProjectListView()
    {
//        let projectListCollectionView = ProjectsListCollectionView(frame: CGRect(x: 122, y: 148, width: UIScreen.main.bounds.width-132, height: UIScreen.main.bounds.height-200), collectionViewLayout: UICollectionViewFlowLayout.init())
//        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
//        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
//        //layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//        layout.itemSize = CGSize(width: 200, height: 280)
//        layout.minimumLineSpacing = 50
//        layout.minimumInteritemSpacing = 10
//        projectListCollectionView.setCollectionViewLayout(layout, animated: true)
//        projectListCollectionView.delegate = self
//        projectListCollectionView.dataSource = self
//        projectListCollectionView.backgroundColor = UIColor.clear
//        projectListCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//        self.view.addSubview(projectListCollectionView)
        
        //myCollectionViewArray.removeAll()
        
    }
    
    func setupScanListView()
    {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        myCollectionView = ProjectsListCollectionView(frame: CGRect(x: 122, y: 148, width: UIScreen.main.bounds.width-132, height: UIScreen.main.bounds.height-200), collectionViewLayout: layout)
//        myCollectionView = ProjectsListCollectionView(frame: CGRect(x: 122, y: 148, width: UIScreen.main.bounds.width-132, height: UIScreen.main.bounds.height-200))
//        myCollectionView.setCollectionViewLayout(layout, animated: true)
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        //layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//        layout.itemSize = CGSize(width: 200, height: 280)
//        layout.minimumLineSpacing = 50
//        layout.minimumInteritemSpacing = 10
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.backgroundColor = UIColor.clear
        myCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        //myCollectionView.register(ScanCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.view.addSubview(myCollectionView)
        
        newScanButton.frame = CGRect(x: screenWidth-156, y: screenHeight-62, width: 146, height: 52)
        newScanButton.backgroundColor = .clear
        newScanButton.setTitle("New Scan", for: .normal)
        //newScanButton.titleLabel?.font = UIFont(name: "Sora-SemiBold", size: 16)
        newScanButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        let l = CAGradientLayer()
        l.frame = newScanButton.bounds
        l.colors = [UIColor(red: 62.0/255.0, green: 121/255.0, blue: 229.0/255.0, alpha: 1.0).cgColor, UIColor(red: 1.0/255.0, green: 184.0/255.0, blue: 227.0/255.0, alpha: 1.0).cgColor]
        l.startPoint = CGPoint(x: 0, y: 0.5)
        l.endPoint = CGPoint(x: 1, y: 0.5)
        l.cornerRadius = 10
        newScanButton.layer.addSublayer(l)
        self.view.addSubview(newScanButton)
    }
    
    @objc func buttonAction(sender: UIButton!){
        print("button Pressed")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GLKitViewController") as! ViewController
        //self.present(nextViewController, animated:true, completion:nil)
        //nextViewController.passedIndex = currentDatabaseIndex
        self.show(nextViewController, sender: currentDatabaseIndex)
    }
    
    func updateDatabases()
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
            //file:///private/var/mobile/Containers/Data/Application/FBBEA336-4AC8-431D-A440-28E4231FAA75/Documents/Door.db
            
            if(myCollectionViewType)
            {
                for i in 0...databases.count-1 {
                    myCollectionViewArray.insert(["name": URL(fileURLWithPath: databases[i].path).lastPathComponent.components(separatedBy: ".")[0], "clientName":"", "dateCreated":(try! URL(fileURLWithPath: databases[i].path).resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate!.getFormattedDate(format: "dd/MM/yyyy")), "status": "In Progress", "image": databases[i].path], at: i)
                }
            }
            else
            {
                myCollectionViewArray.insert(["name": "Google", "clientName":"", "dateCreated":"22/11/2022", "status": "In Progress", "image": "ProjectSmapleImage.png"], at: 0)
                myCollectionViewArray.insert(["name": "Facebook", "clientName":"", "dateCreated":"22/11/2022", "status": "In Progress", "image": "ProjectSmapleImage.png"], at: 1)
                myCollectionViewArray.insert(["name": "Microsoft", "clientName":"", "dateCreated":"22/11/2022", "status": "In Progress", "image": "ProjectSmapleImage.png"], at: 2)
            }
        } catch {
            print("Error while enumerating files : \(error.localizedDescription)")
            return
        }
        
        print(myCollectionViewArray)
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
                        self.updateDatabases()
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
                    
                    self.updateDatabases()
                    self.myCollectionView.removeFromSuperview()
                    UIView.animate(withDuration: 1.0, delay: 1.0, options: [], animations: {
                        self.setupScanListView()
                    }, completion: { (finished: Bool) in
                        
                    })
                    
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
    
 
    // MARK: - UISearchBarDelegate protocol
    
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        print(textSearched)
        
//        let itemsArray = ["Google", "Goodbye", "Go", "Hello"]
//        let searchToSearch = "go"
//
//        let filtered = myCollectionViewArray.filter { $0.contains("Go") }
//        let filtered = itemsArray.filter { String in
//            return String.count>4
//        }
//        print(filtered)
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
        //cell.frame = CGRectMake(0, 0, 100, 100)
        //let cell = UICollectionViewCell(frame: CGRectMake(0, 0, 100, 100))
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        //cell.myLabel.text = self.items[indexPath.row] // The row value is the same as the index of the desired text within the array.
        cell.backgroundColor = UIColor.systemGray6
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
        cell.addSubview(cellOptionsButton)
        
        let scanTitle = UILabel(frame: CGRect(x: 12, y: 16, width: 104, height: 15))
        //projectTitle.center = CGPoint(x: 160, y: 285)
        //projectTitle.font = UIFont(name: projectTitle.font.fontName, size: 20)
        scanTitle.backgroundColor = .clear
        scanTitle.textAlignment = .left
        scanTitle.font = UIFont.preferredFont(forTextStyle: .body)
        scanTitle.font.withSize(8)
        scanTitle.textColor = .gray
        //scanTitle.text = "Scan "+String(indexPath.row+1)
        scanTitle.text = self.myCollectionViewArray[indexPath.row]["name"] as? String
        cell.addSubview(scanTitle)
        
        //let imageName = "SampleScan.png"
        //let image = UIImage(named: imageName)
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 10, y: 50, width: cell.frame.width-20, height: 146)
//        imageView.layer.shadowColor = UIColor.systemGray.cgColor
//        imageView.layer.shadowOpacity = 1
//        imageView.layer.shadowOffset = .zero
//        imageView.layer.shadowRadius = 5
        cell.addSubview(imageView)
        
        let cellProgressView = UIProgressView(frame: CGRect(x: 0, y: 210, width: cell.frame.width, height: 20))
        cellProgressView.backgroundColor = .clear
        cellProgressView.setProgress(1.0, animated: true)
        cellProgressView.trackTintColor = UIColor(red: 0.925, green: 0.953, blue: 0.996, alpha: 1)
        cellProgressView.tintColor = UIColor(red: 0.235, green: 0.475, blue: 0.871, alpha: 1)
        let transform : CGAffineTransform = CGAffineTransformMakeScale(1.0, 3.0)
        cellProgressView.transform = transform
        
        
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
        
        dateTitle.text  = self.myCollectionViewArray[indexPath.row]["dateCreated"] as? String
        
        //dateTitle.text = "05/08/2022"
        dateTitle.numberOfLines = 1
        dateTitle.adjustsFontSizeToFitWidth = true
        cell.addSubview(dateTitle)
        
        let statusTitle = UILabel(frame: CGRect(x: 110, y: 247, width: 80, height: 20))
        //projectTitle.center = CGPoint(x: 160, y: 285)
        //projectTitle.font = UIFont(name: projectTitle.font.fontName, size: 20)
        statusTitle.backgroundColor = .clear
        statusTitle.textAlignment = .center
        statusTitle.font = UIFont.preferredFont(forTextStyle: .body)
        statusTitle.font.withSize(8)
        statusTitle.textColor = .systemBlue
        statusTitle.text = self.myCollectionViewArray[indexPath.row]["status"] as? String
        statusTitle.numberOfLines = 1
        statusTitle.adjustsFontSizeToFitWidth = true
        
        
        
        if(self.myCollectionViewType)
        {
            DispatchQueue.global().async {
                let downloadedImage = getPreviewImage(databasePath: self.myCollectionViewArray[indexPath.row]["image"] as! String)
                DispatchQueue.main.async {
                    imageView.image = downloadedImage
                }
            }
            cell.addSubview(cellProgressView)
            dateScanTitle.text = "Date Scanned"
            cell.addSubview(statusTitle)
        }
        else
        {
            imageView.image = UIImage(named: self.myCollectionViewArray[indexPath.row]["image"] as! String)!
            dateScanTitle.text = "Date Created"
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
    
    
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        //print(interaction.view?.tag)
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
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
                        self.updateDatabases()
                        self.myCollectionView.removeFromSuperview()
                        UIView.animate(withDuration: 1.0, delay: 1.0, options: [], animations: {
                            self.setupScanListView()
                        }, completion: { (finished: Bool) in
                            
                        })
                        
//                        self.myCollectionView.reloadData()
//                        self.myCollectionView.performBatchUpdates({ [weak self] in
//                            let visibleItems = self?.myCollectionView.indexPathsForVisibleItems ?? []
//                            self?.myCollectionView.reloadItems(at: visibleItems)
//                        }, completion: { (_) in
//                        })
                    }
                    return UIMenu(title: "", children: [shareAction, editAction, deleteAction])
             }
    }
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GLKitViewController") as! ViewController
        //self.present(nextViewController, animated:true, completion:nil)
        nextViewController.passedIndex = indexPath.row
        self.show(nextViewController, sender: currentDatabaseIndex)
    }
    
}

// MARK: - LoginViewExtension
extension LandingController: LoginViewDelegate {
    func sendLoginRequest(email: String, password: String) {
        print(email)
        print(password)
    }
}


