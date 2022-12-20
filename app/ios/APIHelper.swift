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
        
        
        
        print(request.httpMethod!)
        print(request.url!)
        print(request.allHTTPHeaderFields!)
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
    
    func uploadScan(endpoint:String, fileName: String, scanName: String, parameters:[String: Any], method: String ,completion: @escaping(String, Error?) -> ()){
        
        print("---------------------File Path--------------------------")
        print(fileName)
        print("---------------------Endpoint--------------------------")
        print(endpoint)
        
        
        let imageData = "Image Data".data(using: .utf8)!
        let boundary = "Boundary-\(UUID().uuidString)"
        
        let url = URL(string: baseURLCRM+endpoint)!
        let access_token = UserDefaults.standard.value(forKey: "access_token") as! String
        let bearer = "Bearer "+access_token
        
        var request = URLRequest(url: url)
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue(bearer, forHTTPHeaderField: "Authorization")
        request.httpMethod = method
       
        let httpBody = NSMutableData()
        httpBody.appendString(convertFormField(named: "DisplayName", value: "scanName", using: boundary))
        httpBody.append(convertFileData(fieldName: "files",
                                        fileName: scanName+".db",
                                        mimeType: "application/json",
                                        fileData: imageData,
                                        using: boundary))

        httpBody.appendString("--\(boundary)--")

        request.httpBody = httpBody as Data
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 2
        
        var appendedFilePath = "file://\(fileName)"
        
        
        //let uploadTask = URLSession(configuration: config).uploadTask(with: request, fromFile: tempfilePath!){ data, response, error in
        let uploadTask = URLSession(configuration: config).dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200..<300:
                    print("Success")
                case 400..<500:
                    print("Request error")
                    completion("", nil)
                case 500..<600:
                    print("Server error")
                    completion("", nil)
                case let otherCode:
                    print("Other code: \(otherCode)")
                    completion("", nil)
                }
            }
                                                                
            // Do something with the response data
            if let
                responseData = data,
                let responseString = String(data: responseData, encoding: String.Encoding.utf8) {
                print("Server Response:")
                print(responseString)
                completion(responseString, nil)
            }
                                                                
            // Do something with the error
            if let error = error {
                print(error.localizedDescription)
                completion("", nil)
            }
        }

        uploadTask.resume()
    }
    
    func uploadScan3(){
        
        let imageData = "Image Data".data(using: .utf8)!
        let boundary = "Boundary-\(UUID().uuidString)"

        var request = URLRequest(url: URL(string: "https://dev-crm-api.tooliqa.com/api/crm/api/v1/storage?file_location=/Projects/46fe5c31-bf41-4b16-82b3-1d516fe53b84/Scans")!)
        request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NzYyMDgyMzMsInN1YiI6IjkyZDJmOGI1LTcwZGYtNDg4MC1hNGVlLTg2ZjEyZmE3MDBlNiJ9.zchHP-WEcemkjYMo1W_IL8mfftZekzfJ1HPnWONFlVg", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let httpBody = NSMutableData()
        httpBody.appendString(convertFormField(named: "DisplayName", value: "sampleFile", using: boundary))
        httpBody.append(convertFileData(fieldName: "files",
                                        fileName: "newLottie.txt",
                                        mimeType: "application/json",
                                        fileData: imageData,
                                        using: boundary))

        httpBody.appendString("--\(boundary)--")

        request.httpBody = httpBody as Data

        print(String(data: httpBody as Data, encoding: .utf8)!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
        }

        task.resume()
        
        
    }
    
    func convertFormField(named name: String, value: String, using boundary: String) -> String {
      var fieldString = "--\(boundary)\r\n"
      fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
      fieldString += "\r\n"
      fieldString += "\(value)\r\n"

      return fieldString
    }

    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
      let data = NSMutableData()
        
      data.appendString("--\(boundary)\r\n")
      data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
      data.appendString("Content-Type: \(mimeType)\r\n\r\n")
      data.append(fileData)
      data.appendString("\r\n")

      return data as Data
    }
    
}

extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
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
