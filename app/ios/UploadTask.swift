//
//  UploadTask.swift
//  RTABMapApp
//
//  Created by Karan Sehgal on 20/12/2022.
//

import Foundation

class UploadTask {
 var file: File
 var inProgress = false
 var task: URLSessionUploadTask?
init(file: File) {
 self.file = file
 }
}
