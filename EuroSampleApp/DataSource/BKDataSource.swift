//
//  BKDataSource.swift
//  EuroSampleApp
//
//  Created by Ashish Parmar on 17/1/17.
//  Copyright © 2017 Ashish. All rights reserved.
//

import Foundation

private let SERVER_URL = "https://api.myjson.com/bins/"
private let reachability = Reachability()!

@objc public enum BKMasterFilter: Int {
    
    case flights
    case trains
    case buses
    
    func name() -> String {
        
        switch self {
        case .flights: return "w60i"
        case .trains: return "3zmcy"
        case .buses: return "37yzm"
        }
    }
}

@objc public enum BKBKDataSourceError : Int {
    
    case tempPathInvalid = 1,
    statusCodeMismatch,
    requestFailed,
    writeFailed,
    deleteFailed,
    fileDontExist,
    dataNULL,
    invalidURL,
    invalidSavePath,
    invalidHTTPResponse,
    networkNotReachable,
    noError
}

@objc public class BKDataSource: NSObject {
    
    override public init() {
        super.init()
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    deinit {
        
        print("BKDataSource deallocated")
    }
    
    // MARK: Public Methods
    public func isNetworkReachable() -> Bool {
        
        return reachability.isReachable
    }
    
    public func retrieveListFor(_ value : BKMasterFilter, completion : @escaping((Array<Dictionary<String, Any>>, BKBKDataSourceError) -> ())) {
        
        if let tempPath = self.pathForSavingFile(value.name()) {
            
            if FileManager.default.fileExists(atPath: tempPath) {
                
                if let value = getDataList(tempPath) {
                    completion(value, .noError)
                    return
                }
            }
            else if !isNetworkReachable() {
                completion([], .fileDontExist)
                return
            }
        }
        
        if let requestURL = URL(string: "\(SERVER_URL)\(value.name())") {
            
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

            let task = session.dataTask(with: requestURL, completionHandler: {
                (data : Data?, response : URLResponse?, error : Error?) in
                
                if let newError = error {
                    
                    print("Failure: \((newError as NSError).localizedDescription)")
                    completion([], .requestFailed)
                }
                else {
                    
                    if let newResponse = response as? HTTPURLResponse {
                        
                        if newResponse.statusCode == 200 {
                            
                            if let tempPath = self.pathForSavingFile(value.name()) {
                                
                                do {
                                    try FileManager.default.removeItem(atPath: tempPath)
                                }
                                catch let error as NSError {
                                    
                                    print("Exception while deleting file : \(error)")
                                }
                                
                                let fileURL = URL(fileURLWithPath: tempPath)
                                
                                if let newData = data {
                                    
                                    do {
                                        try newData.write(to: fileURL, options: .completeFileProtection)
                                        
                                        if let value = self.getDataList(tempPath) {
                                            completion(value, .noError)
                                        }
                                    }
                                    catch let error as NSError {
                                        
                                        print("Exception while writing file : \(error)")
                                        completion([], .writeFailed)
                                    }
                                }
                                else {
                                    print("Failure: Data is invalid.")
                                    completion([], .dataNULL)
                                }
                            }
                            else {
                                print("Failure: Temp Path cannot be generated.")
                                completion([], .tempPathInvalid)
                            }
                        }
                        else {
                            print("Failure: StatusCode is \(newResponse.statusCode)")
                            completion([], .statusCodeMismatch)
                        }
                    }
                    else {
                        print("Failure: Invalid HTTP Response.")
                        completion([], .invalidHTTPResponse)
                    }
                }
            })
            
            task.resume()
        }
        else {
            print("Failure: Invalid URL")
            completion([], .invalidURL)
        }
    }
    
    public func getImageFor(_ path : String, completion : @escaping((String, BKBKDataSourceError) -> ())) {
        
        if let tempPath = pathForSavingImage() {
            
            var newFilePath = ""
            let pathArray = path.components(separatedBy: "/")
            if pathArray.count > 0 {
                newFilePath = pathArray[pathArray.count - 1]
                newFilePath = tempPath + "/" + newFilePath
                
                if FileManager.default.fileExists(atPath: newFilePath) {
                    
                    completion(newFilePath, .noError)
                    return
                }
            }
            else {
                completion("", .noError)
                return
            }        
            
            if isNetworkReachable() {
                
                if let requestURL = URL(string: path) {
                    
                    let sessionConfig = URLSessionConfiguration.default
                    let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
                    
                    let task = session.dataTask(with: requestURL, completionHandler: {
                        (data : Data?, response : URLResponse?, error : Error?) in
                        
                        (BKSharedManager.sharedManager() as! BKSharedManager).removeImageKey(forDownloading: path)
                        
                        if let newError = error {
                            
                            print("Failure: \((newError as NSError).localizedDescription)")
                            completion("", .requestFailed)
                        }
                        else {
                            
                            if let newResponse = response as? HTTPURLResponse {
                                
                                if newResponse.statusCode == 200 {
                                    
                                    let fileURL = URL(fileURLWithPath: newFilePath)
                                    
                                    if let newData = data {
                                        
                                        do {
                                            try newData.write(to: fileURL, options: .completeFileProtection)
                                            
                                            let newPathArray = newFilePath.components(separatedBy: "/")
                                            if newPathArray.count > 0 {
                                                let lastComp = newPathArray[newPathArray.count - 1]
                                                NotificationCenter.default.post(name: Notification.Name("IMAGE_\(lastComp)"), object: newFilePath)
                                            }
                                            
                                            completion(newFilePath, .noError)
                                        }
                                        catch let error as NSError {
                                            
                                            print("Exception while writing file : \(error)")
                                            completion("", .writeFailed)
                                        }
                                    }
                                    else {
                                        print("Failure: Data is invalid.")
                                        completion("", .dataNULL)
                                    }
                                }
                                else {
                                    print("Failure: StatusCode is \(newResponse.statusCode)")
                                    completion("", .statusCodeMismatch)
                                }
                            }
                            else {
                                print("Failure: Invalid HTTP Response.")
                                completion("", .invalidHTTPResponse)
                            }
                        }
                    })
                    
                    task.resume()
                    (BKSharedManager.sharedManager() as! BKSharedManager).setImageKeyForDownloading(path)
                }
                else {
                    print("Failure: Invalid URL")
                    completion("", .invalidURL)
                }
            }
            else {
                print("Failure: Network not reachable")
                completion("", .networkNotReachable)
            }
        }
        else {
            print("Failure: Save Image Path not valid")
            completion("", .invalidSavePath)
        }
    }
    
    // MARK: Private Methods
    
    fileprivate func pathForSavingFile(_ name : String) -> String? {
        
        let pathList = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if pathList.count > 0 {
            
            let resultPath = pathList[0].appending("/\(name)")
            print("Save Path : \(resultPath)")
            return resultPath
        }
        
        return nil
    }
    
    fileprivate func pathForSavingImage() -> String? {
        
        let pathList = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if pathList.count > 0 {
            
            let resultPath = pathList[0].appending("/Images")
            if !FileManager.default.fileExists(atPath: resultPath) {
                
                do {
                    try FileManager.default.createDirectory(atPath: resultPath, withIntermediateDirectories: false, attributes: nil)
                }
                catch let error as NSError {
                    print("Exception while creating directory : \(error)")
                    return nil
                }
            }
            
            //print("Save Image Path : \(resultPath)")
            return resultPath
        }
        
        return nil
    }
    
    fileprivate func getDataList(_ filePath : String) -> Array<Dictionary<String, Any>>? {
        
        if let jsonObject = readJSONFile(filePath) {
            
            print("Finished reading JSON file.")
            
            if let jsonArray = jsonObject as? Array<Dictionary<String, Any>> {
                
                return jsonArray
            }
        }
        
        return nil
    }
    
    // MARK: JSON Methods
    fileprivate func readJSONFile(_ filePath : String) -> Any? {
        
        var outputObject : Any?
        do {
            let pathURL = NSURL.fileURL(withPath: filePath)
            let jsonData = try Data(contentsOf: pathURL, options: Data.ReadingOptions.mappedIfSafe)
            do {
                outputObject = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
                
            } catch _ {
                print("Error - Not able to serialize JSON response")
            }
        } catch _ {
            print("Error - Not able to read contents of file")
        }
        
        return outputObject
    }
}
