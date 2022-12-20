//
//  UploadService.swift
//  RTABMapApp
//
//  Created by Karan Sehgal on 20/12/2022.
//

import Foundation

class UploadService {
 var uploadSession: URLSession!
 
 func start(file: File) {
   // Create upload task
     let uploadTask = UploadTask(file: file)
   //let uploadData = Data(file.data.utf8)
     var uploadData = Data()
     do {
         uploadData = try Data(contentsOf: URL(string: file.data)!)
         
     } catch {
             print(error)
     }
     // Create request
     let url = URL(string: file.link)!;
     var request = URLRequest(url: url)
     request.httpMethod = "POST"
 
     // Set headers if required, e.g.
     //request.setValue("application/json", forHTTPHeaderField: "Accept")
 
     // Create upload task
     uploadTask.task = uploadSession.uploadTask(with: request, from: uploadData)
     
     // Start upload
     uploadTask.task?.resume()
     uploadTask.inProgress = true
 }
}
