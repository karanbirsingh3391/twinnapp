//
//  APIHelper.swift
//  RTABMapApp
//
//  Created by Karan Sehgal on 20/11/2022.
//

import Foundation
import UIKit

//final public class APIHelper {
//
//    public static let shared = APIHelper()
//
//    private let baseURLAuth: String = "https://dev-crm-api.tooliqa.com/api/auth/api/v1/auth/login"
//
//    private init() {}
//
//    public func sendRequest(requestURL: String, requestEndPoint: String, Type: String)
//    {
//    }
//}
final public class APIHelper: NSObject {
    
    public static let shareInstance = APIHelper()
    
    private let baseURLAuth: String = "https://dev-crm-api.tooliqa.com/api/auth/api/v1"
    private let baseURLCRM: String = "https://dev-crm-api.tooliqa.com/api/crm/api/v1"
    
    struct ResponseObject<T: Decodable>: Decodable {
        let form: T    // often the top level key is `data`, but in the case of https://httpbin.org, it echos the submission under the key `form`
    }

    struct Foo: Decodable {
        let access_token: String
        let token_type: String
    }
    
    
    
    func User(endpoint:String, parameters:[String: Any], method: String, accessToken:Bool, completion: @escaping(String, Error?) -> ()){
        
        let url = URL(string: baseURLAuth+endpoint)!
        
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if(accessToken){
            let access_token = UserDefaults.standard.value(forKey: "access_token") as! String
            let bearer = "Bearer "+access_token
            request.setValue(bearer, forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = method
        request.httpBody = parameters.percentEncoded()
        
        print("\(request.httpMethod!) \(request.url!)")
        print(request.allHTTPHeaderFields!)
        print(String(data: request.httpBody ?? Data(), encoding: .utf8)!)
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 2
        
        
        let task = URLSession(configuration: config).dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {                                                               // check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                completion("", error)
                return
            }
            
            print(response.statusCode)
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                completion("", nil)
                return
            }
            
            do {
                let responseObject = try JSONDecoder().decode(ResponseObject<Foo>.self, from: data)
                //print(responseObject)
            } catch {
                print(error) // parsing error
                if let responseString = String(data: data, encoding: .utf8) {
                    //print("responseString = \(responseString)")
                    completion(responseString, nil)
                } else {
                    print("unable to parse response as string")
                }
            }
        }

        task.resume()
    }
    
    
    func apiCall(endpoint:String, parameters:[String: Any], method: String ,completion: @escaping(String, Error?) -> ()){
        
        let url = URL(string: baseURLCRM+endpoint)!
        let access_token = UserDefaults.standard.value(forKey: "access_token") as! String
        let bearer = "Bearer "+access_token
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue(bearer, forHTTPHeaderField: "Authorization")
        request.httpMethod = method
        
        if(parameters.isEmpty)
        {
            request.httpBody = parameters.percentEncoded()
        }
        else
        {
            request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        
        //request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
        
        
        
        //print("\(request.httpMethod!) \(request.url!)")
        //print(request.allHTTPHeaderFields!)
        print(String(data: request.httpBody ?? Data(), encoding: .utf8)!)
        
        //print(request.allHTTPHeaderFields)
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 2
        
        let task = URLSession(configuration: config).dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {                                                               // check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                completion("", error)
                return
            }
        
            print(response.statusCode)
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                completion("", nil)
                return
            }
                        
            do {
                //let array = try JSONSerialization.jsonObject(with: data) as? [[String : Any]]
//                let responseObject = try JSONDecoder().decode(ResponseObject<Foo>.self, from: data)
                //print("response object ")
                //print(array)
                if let responseString = String(data: data, encoding: .utf8) {
                    //print("responseString = \(responseString)")
                    completion(responseString, nil)
                } else {
                    print("unable to parse response as string")
                }
            } catch {
                print(error) // parsing error

            }
        }

        task.resume()
    }
    
    func uploadScan(endpoint:String, filePath: String, parameters:[String: Any], method: String ,completion: @escaping(String, Error?) -> ()){
        
        let url = URL(string: baseURLCRM+endpoint)!
        let access_token = UserDefaults.standard.value(forKey: "access_token") as! String
        let bearer = "Bearer "+access_token
        
        var request = URLRequest(url: url)
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue(bearer, forHTTPHeaderField: "Authorization")
        request.httpMethod = method
       
//        if(parameters.isEmpty)
//        {
//            request.httpBody = parameters.percentEncoded()
//        }
//        else
//        {
//            request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
//        }
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        print(request.httpMethod!)
        print(request.url!)
        print(request.allHTTPHeaderFields!)
        print(String(data: request.httpBody ?? Data(), encoding: .utf8)!)

        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 2
        
        var appendedFilePath = "file://\(filePath)"
        
        var tempfilePath = Bundle.main.url(forResource: "BackButton", withExtension: "png")
        print(tempfilePath!)
        
        //URL(string: tempfilePath)!
        let uploadTask = URLSession(configuration: config).uploadTask(with: request, fromFile: tempfilePath!){ data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200..<300:
                    print("Success")
                case 400..<500:
                    print("Request error")
                case 500..<600:
                    print("Server error")
                case let otherCode:
                    print("Other code: \(otherCode)")
                }
            }
                                                                
            // Do something with the response data
            if let
                responseData = data,
                let responseString = String(data: responseData, encoding: String.Encoding.utf8) {
                print("Server Response:")
                print(responseString)
            }
                                                                
            // Do something with the error
            if let error = error {
                print(error.localizedDescription)
            }
        }

        uploadTask.resume()
    }
    
    func uploadScan2(){
        var semaphore = DispatchSemaphore (value: 0)

        let myImage = UIImage(named: "Vector.png")!
        let myData = myImage.pngData()
        var tempfilePath = (Bundle.main.url(forResource: "BackButton", withExtension: "png") ?? URL(string: "file:///private/var/containers/Bundle/Application/CE4141DD-0557-416D-B756-ADD97C46F062/RTABMapApp.app/BackButton.png")) as URL?
        
        
        let parameters = [
          [
            "key": "files",
            "src": "/myLottie.db",
            "type": "file"
          ],
          [
            "key": "DisplayName",
            "value": "lottiefrompostman",
            "type": "text"
          ]] as [[String : Any]]

        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        var error: Error? = nil
        for param in parameters {
          if param["disabled"] == nil {
            let paramName = param["key"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if param["contentType"] != nil {
              body += "\r\nContent-Type: \(param["contentType"] as! String)"
            }
            let paramType = param["type"] as! String
            if paramType == "text" {
              let paramValue = param["value"] as! String
              body += "\r\n\r\n\(paramValue)\r\n"
            } else {
             
                let paramSrc = param["src"] as! String
                print(paramSrc)
                let fileData =  try! NSData(contentsOfFile:paramSrc, options:[]) as Data
                let fileContent = String(data: fileData, encoding: .utf8)!
                body += "; filename=\"\(paramSrc)\"\r\n" + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
            }
          }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://dev-crm-api.tooliqa.com/api/crm/api/v1/storage?file_location=/Projects/46fe5c31-bf41-4b16-82b3-1d516fe53b84/Scans")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NzYyMDgyMzMsInN1YiI6IjkyZDJmOGI1LTcwZGYtNDg4MC1hNGVlLTg2ZjEyZmE3MDBlNiJ9.zchHP-WEcemkjYMo1W_IL8mfftZekzfJ1HPnWONFlVg", forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        
        print(request.httpMethod!)
        print(request.url!)
        print(request.allHTTPHeaderFields!)
        print(String(data: request.httpBody ?? Data(), encoding: .utf8)!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
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
