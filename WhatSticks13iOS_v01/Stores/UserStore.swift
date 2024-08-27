//
//  UserStore.swift
//  WhatSticks13iOS
//
//  Created by Nick Rodriguez on 29/06/2024.
//

import Foundation


enum UserStoreError: Error {
    case failedDecode
    case failedToLogin
    case failedToRegister
    case failedToUpdateUser
    case failedToReceiveServerResponse
    case failedToReceiveExpectedResponse
    case fileNotFound
    case noApiPasswordIncludedInRequest
    case userHasNoUsername
    case noInternetConnection
    case requestStoreError
    case serverError(statusCode: Int)
    case generalError(Error)
    var localizedDescription: String {
        switch self {
        case .failedDecode: return "Failed to decode response."
        case .fileNotFound: return "What Sticks API could not find the dashboard data on the server."
        case .generalError(let error): return "Caught in UserStore, error: \(error.localizedDescription)"
        default: return "What Sticks main server is not responding."
        }
    }
}

class UserStore {
    
    static let shared = UserStore()
    
//    let fileManager:FileManager
//    let documentsURL:URL
    var user=User()
    var arryDataSourceObjects:[DataSourceObject]?
    var boolDashObjExists:Bool!
    var boolMultipleDashObjExist:Bool!
    var arryDashboardTableObjects=[DashboardTableObject](){
        didSet{
            guard let unwp_pos = currentDashboardObjPos else {return}
            if arryDashboardTableObjects.count > currentDashboardObjPos{
                currentDashboardObject = arryDashboardTableObjects[unwp_pos]
            }
        }
    }
    var currentDashboardObject:DashboardTableObject?
    var currentDashboardObjPos: Int!
    var existing_emails = [String]()
//    var urlStore:URLStore!
//    var requestStore:RequestStore!
    var hasLaunchedOnce = false
    var isOnline = false
    var isInDevMode = false
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    var isGuestMode = false
    
    func deleteUserDefaults_User(){
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.removeObject(forKey: "token")// <- keep this?
        UserDefaults.standard.removeObject(forKey: "admin_permission")
        UserDefaults.standard.removeObject(forKey: "location_permission_device")
        UserDefaults.standard.removeObject(forKey: "location_permission_ws")
        UserDefaults.standard.removeObject(forKey: "arryUserLocation")
        UserDefaults.standard.removeObject(forKey: "lastUpdateTimestamp")
        UserDefaults.standard.removeObject(forKey: "arryDataSourceObjects")
        UserDefaults.standard.removeObject(forKey: "hasShownLaunchVideo")
    }
    func deletedUser(){
        arryDashboardTableObjects = [DashboardTableObject]()
        arryDataSourceObjects = [DataSourceObject]()
        currentDashboardObject=DashboardTableObject()
        currentDashboardObjPos=0
        UserDefaults.standard.removeObject(forKey: "arryDashboardTableObjects")
        UserDefaults.standard.removeObject(forKey: "arryDataSourceObjects")

    }
    
    func assignArryDataSourceObjects(jsonResponse:[String:Any]){
        print("---- in assignArryDataSourceObjects() ")
        
        if let unwp_array = jsonResponse["arryDataSourceObjects"] as? [[String: Any]] {
//            print("What is unwp_array:")
//            print("\(unwp_array)")
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: unwp_array, options: [])
                let array_data_source_obj = try JSONDecoder().decode([DataSourceObject].self, from: jsonData)
                self.arryDataSourceObjects = array_data_source_obj
                // Encode the array of DataSourceObject into Data
                let encodedData = try JSONEncoder().encode(self.arryDataSourceObjects)
                // Store the encoded Data in UserDefaults
                UserDefaults.standard.set(encodedData, forKey: "arryDataSourceObjects")
                print("--- successfully decodeed arryDataSourceObjects")
            }
            catch {
                print("failed to decode arryDataSourceObjects into [DataSourceObject]")
            }
        }
    }
    
    // offline mode
    func loadArryDataSourceObjectsFromUserDefaults() {
        if let encodedData = UserDefaults.standard.data(forKey: "arryDataSourceObjects") {
            do {
                let decodedArray = try JSONDecoder().decode([DataSourceObject].self, from: encodedData)
                self.arryDataSourceObjects = decodedArray
                print("Successfully loaded arryDataSourceObjects from UserDefaults")
            } catch {
                print("Failed to decode DataSourceObject: \(error)")
            }
        } else {
            print("No arryDataSourceObjects found in UserDefaults")
        }
    }
    
    func assignArryDashboardTableObjects(jsonResponse:[String:Any]){
        print("---- in assignArryDashboardTableObjects() ")
        
        if let unwp_array = jsonResponse["arryDashboardTableObjects"] as? [[String: Any]] {
//            print("What is unwp_array:")
//            print("\(unwp_array)")
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: unwp_array, options: [])
                let array_dashboard_table_obj = try JSONDecoder().decode([DashboardTableObject].self, from: jsonData)
                self.arryDashboardTableObjects = array_dashboard_table_obj
                self.currentDashboardObject = self.arryDashboardTableObjects[0]
                // Encode the array of DataSourceObject into Data
                let encodedData = try JSONEncoder().encode(self.arryDashboardTableObjects)
                // Store the encoded Data in UserDefaults
                UserDefaults.standard.set(encodedData, forKey: "arryDashboardTableObjects")
//                print("--- successfully decodeed arryDashboardTableObjects")
//                print("self.arryDashboardTableObjects:")
//                print(self.arryDashboardTableObjects)
            }
            catch {
                print("failed to decode arryDashboardTableObjects into [DashboardTableObject]")
            }
        }
    }
    
    // offline mode
    func loadArryDashboardTableFromUserDefaults() {
        if let encodedData = UserDefaults.standard.data(forKey: "arryDashboardTableObjects") {
            do {
                let decodedArray = try JSONDecoder().decode([DashboardTableObject].self, from: encodedData)
                self.arryDashboardTableObjects = decodedArray
                self.currentDashboardObject = self.arryDashboardTableObjects[0]
                print("Successfully loaded arryDashboardTableObjects from UserDefaults")
            } catch {
                print("Failed to decode DashboardTableObject: \(error)")
            }
        } else {
            print("No arryDashboardTableObjects found in UserDefaults")
        }
    }
    
    func assignUser(dictUser:[String:Any]){
        print("---- in assignUser() ")
        do {
            if let userData = try? JSONSerialization.data(withJSONObject: dictUser["user"] ?? [:], options: []) {
                
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: userData)
                self.user = user
                LocationFetcher.shared.setUserStoreUserLocationPermissionDevice()// set the correct user.location_permission_device i.e. the device dictates what this is, not the WS app.
                UserDefaults.standard.set(self.user.location_permission_ws, forKey: "location_permission_ws")
                if let unwp_username = self.user.username{
                    UserDefaults.standard.set(unwp_username, forKey: "userName")
                }
                if let unwp_email = self.user.email{
                    UserDefaults.standard.set(unwp_email, forKey: "email")
                }
                if let unwp_id = self.user.id {
                    UserDefaults.standard.set(unwp_id, forKey: "id")
                }
                if let unwp_admin_permission = self.user.admin_permission {
                    UserDefaults.standard.set(unwp_admin_permission, forKey: "admin_permission")
                }
                if let unwp_token = self.user.token {
                    UserDefaults.standard.set(unwp_token, forKey: "token")
                    RequestStore.shared.token = unwp_token
                }
            }
            print("- finished decoding and assigning User")
        }
        catch {
            print("There was an error decoding User in the response")
        }
    }
    func checkUser(){
        if UserDefaults.standard.string(forKey: "userName") == nil || UserDefaults.standard.string(forKey: "userName") == "new_user"  {
            deleteUserDefaults_User()
            self.user.username = "new_user"
            UserDefaults.standard.set("new_user", forKey: "userName")
        } else {
            user.email = UserDefaults.standard.string(forKey: "email")
            user.username = UserDefaults.standard.string(forKey: "userName")
            user.password = UserDefaults.standard.string(forKey: "password")
            user.id = UserDefaults.standard.string(forKey: "id")
            user.admin_permission = UserDefaults.standard.bool(forKey: "admin_permission")
            user.location_permission_device = UserDefaults.standard.bool(forKey: "location_permission_device")
            user.location_permission_ws = UserDefaults.standard.bool(forKey: "location_permission_ws")
        }
    }
    
    func connectDevice(completion: @escaping () -> Void){
        print("- in connectDevice(completion) ")
        if isGuestMode{
            print("assign guest user and data")
            loadGuestUser()
            completion()
        } else {
            checkUser()
            // Condition #1: Register user ambivalent_elf_####
            if UserDefaults.standard.string(forKey: "userName") == nil || UserDefaults.standard.string(forKey: "userName") == "new_user"  {
                callRegisterGenericUser { result_string_string_dict in
                    switch result_string_string_dict{
                    case .success(_):
                        RequestStore.shared.token = self.user.token
                        UserDefaults.standard.set(self.user.username!, forKey: "userName")
                        self.isOnline=true
                        completion()
                    case .failure(_):
                        print("--- Off line mode (Condition #1)")
                        self.loadArryDataSourceObjectsFromUserDefaults()
                        self.loadArryDashboardTableFromUserDefaults()
                        completion()
                    }
                }
            }
            // Condition #2: Login with Generic Elf
            else if UserDefaults.standard.string(forKey: "email") == nil  {
                self.user.username  = UserDefaults.standard.string(forKey: "userName")
                // /login user
                if UserDefaults.standard.string(forKey: "userEmail") == nil {
                    callLoginGenericUser(user: self.user) { result_dict_string_any_or_error in
                        switch result_dict_string_any_or_error {
                        case  .success(_):
                            self.isOnline=true
                            RequestStore.shared.token = self.user.token
                            completion()
                        case .failure(_):
                            print("--- Off line mode (Condition #2:)")
                            self.loadArryDataSourceObjectsFromUserDefaults()
                            self.loadArryDashboardTableFromUserDefaults()
                            completion()
                        }
                    }
                } else {
                    print("login real user")
                    completion()
                }
            }
            // Condition #3: Login with account
            else {
                print("---- Login with email and password ---")
                callLogin(user: self.user) { result_dict_or_error in
                    switch result_dict_or_error {
                    case .success(_):
                        self.isOnline=true
                        completion()
                    case let .failure(error):
                        print("-offline mode??? (Condition #3)")
                        print("error: \(error)")
                        self.loadArryDataSourceObjectsFromUserDefaults()
                        self.loadArryDashboardTableFromUserDefaults()
                        completion()
                    }
                }
            }
        }
    }
    
    func loadGuestDataSourceObjectArray() {
        if let url = Bundle.main.url(forResource: "data_source_list_for_user_guest", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let array_data_source_obj = try decoder.decode([DataSourceObject].self, from: data)
                self.arryDataSourceObjects = array_data_source_obj
            } catch {
                print("Error loading GUEST DataSourceObject data: \(error)")
            }
        }
    }
    
    
    func loadGuestDashboardTableObjectsArray() {
        if let url = Bundle.main.url(forResource: "data_table_objects_array_guest", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let objects = try decoder.decode([DashboardTableObject].self, from: data)
                self.arryDashboardTableObjects = objects
            } catch {
                print("Error loading GUEST DashboardTableObject data: \(error)")
            }
        }
    }
    
    func loadGuestUser(){
        self.isGuestMode = true
        self.user.username = "Guest User"
        loadGuestDataSourceObjectArray()
        loadGuestDashboardTableObjectsArray()
        if arryDashboardTableObjects.count > 0 {
            currentDashboardObjPos = 0
            currentDashboardObject = arryDashboardTableObjects[currentDashboardObjPos]
        }
    }
    
}

/* Calls to: Logins, Registers, Delete  */
extension UserStore{
    func callConvertGenericAccountToCustomAccount(email: String?, username:String?, password: String?, completion: @escaping (Result<[String: String], UserStoreError>) -> Void) {
        var parameters: [String: String] = ["ws_api_password": Config.ws_api_password]
        
        if let email = email {
            parameters["email"] = email
        }
        
        if let username = username {
            parameters["username"] = username
        }
        
        if let password = password {
            parameters["password"] = password
        }
        //        let request = requestStore.createRequestWithBody(endPoint: .register,token:true, body: parameters)
        let result = RequestStore.shared.createRequestWithTokenAndBodyWithAuth(endPoint: .convert_generic_account_to_custom_account,token:true, stringDict: parameters)
        
        switch result {
        case .success(let request):
            
            let task = session.dataTask(with: request) { data, response, error in
                // Check for an error. If there is one, complete with failure.
                if let error = error {
                    print("Network request error: \(error.localizedDescription)")
                    completion(.failure(UserStoreError.noInternetConnection))
                    return
                }
                // Ensure data is not nil, otherwise, complete with a custom error.
                guard let unwrappedData = data else {
                    print("No data response")
                    completion(.failure(UserStoreError.failedToReceiveServerResponse))
                    return
                }
                do {
                    print("- there is a response - 1 ")
                    // Attempt to decode the JSON response.
                    if let jsonResult = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as? [String: Any] {
                        print("JSON serialized well")
                        let keysToExtract = ["alert_title", "alert_message"]
                        var dictModifiedResponse: [String: String] = [:]
                        
                        for key in keysToExtract {
                            if let value = jsonResult[key] as? String {
                                dictModifiedResponse[key] = value
                            }
                        }
                        self.assignUser(dictUser: jsonResult)
                        
                        // Ensure completion handler is called on the main queue.
                        DispatchQueue.main.async {
                            completion(.success(dictModifiedResponse))
                        }
                    } else {
                        print("- there is a response - 2 ")
                        // If decoding fails due to not being a [String: String]
                        DispatchQueue.main.async {
                            completion(.failure(UserStoreError.failedToReceiveExpectedResponse))
                        }
                    }
                } catch {
                    // Handle any errors that occurred during the JSON decoding.
                    print("---- UserStore.registerNewUser: Failed to read response")
                    DispatchQueue.main.async {
                        completion(.failure(UserStoreError.failedDecode))
                    }
                }
            }
            task.resume()
        case .failure(let error):
            print("* error encodeing from requestStore.callRegisterNewUser: \(error)")
            OperationQueue.main.addOperation {
                completion(.failure(UserStoreError.requestStoreError))
            }
        }
    }
    
    func callRegisterGenericUser(completion: @escaping (Result<[String:Any], Error>) -> Void) {
        
        guard let unwp_email = user.username else {
            completion(.failure(UserStoreError.userHasNoUsername))
            return
        }
        let result = RequestStore.shared.createRequestWithTokenAndBody(endPoint: .register_generic_account, token: false, body: ["new_username": unwp_email, "ws_api_password":Config.ws_api_password])
        
        
        switch result {
        case .success(let request):
            let task = session.dataTask(with: request) { (data, response, error) in
                // Handle the task's completion here as before
                guard let unwrapped_data = data else {
                    OperationQueue.main.addOperation {
                        completion(.failure(UserStoreError.failedToReceiveServerResponse))
                        print("failed to recieve response")
                    }
                    return
                }
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: unwrapped_data, options: []) as? [String: Any] {
//                        print("JSON dictionary: \(jsonResult)")
                        
                        self.assignUser(dictUser: jsonResult)
                        OperationQueue.main.addOperation {
                            completion(.success(jsonResult))
                        }
                    }
                    
                } catch {
                    OperationQueue.main.addOperation {
                        print("--- Failed in callRegisterGenericUser")
                        completion(.failure(UserStoreError.failedToLogin))
                    }
                }
            }
            task.resume()
            
        case .failure(let error):
            // Handle the error here
            print("* error encodeing from reqeustStore.createRequestLogin")
            OperationQueue.main.addOperation {
                completion(.failure(error))
            }
        }
    }
    
    func callLoginGenericUser(user:User, completion: @escaping(Result<[String:Any],Error>) ->Void){
        print("- in callLoginGenericUser -")
        var parameters: [String: String] = ["ws_api_password": Config.ws_api_password]
        if let username = user.username {
            parameters["username"] = username
        } else {
            completion(.failure(UserStoreError.failedToLogin))
            return
        }
        let request = RequestStore.shared.createRequestWithUsername(endPoint: .login_generic_account,body: parameters)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network request error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("No data response or invalid response")
                completion(.failure(UserStoreError.failedToReceiveServerResponse))
                return
            }
            if httpResponse.statusCode == 400 {
                print("Received 400 Bad Request")
                completion(.failure(UserStoreError.userHasNoUsername))
                return
            }
            guard let unwrapped_data = data else {
                print("No data response")
                completion(.failure(UserStoreError.failedToReceiveServerResponse))
                return
            }
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: unwrapped_data, options: []) as? [String: Any] {
//                    print("--- This should include a ArryDataSourceObjects ----")
//                    print("JSON dictionary: \(jsonResult)")
                    self.assignUser(dictUser: jsonResult)
                    self.assignArryDataSourceObjects(jsonResponse: jsonResult)
                    self.assignArryDashboardTableObjects(jsonResponse: jsonResult)
                    OperationQueue.main.addOperation {
                        completion(.success(jsonResult))
                    }
                }
                
            } catch {
                OperationQueue.main.addOperation {
                    print("Failed to decode user or find a user in API response: \(UserStoreError.failedToLogin)")
                    completion(.failure(UserStoreError.failedToLogin))
                }
            }
            
        }
        task.resume()
    }
    
    func callLogin(user:User, completion: @escaping(Result<[String:Any],UserStoreError>) ->Void){
        print("- in callLoginUser -")
        var parameters: [String: String] = ["ws_api_password": Config.ws_api_password]
        if let username = user.email,
           let password = user.password{
            parameters["email"] = username
            parameters["password"] = password
        } else {
            completion(.failure(UserStoreError.failedToLogin))
            return
        }
        let result = RequestStore.shared.createRequestWithTokenAndBodyWithAuth(endPoint: .login,token:false, stringDict: parameters)
        
        switch result {
        case .success(let request):
            
            let task = session.dataTask(with: request) { data, response, error in
                // Check for an error. If there is one, complete with failure.
                if let error = error {
                    print("Network request error: \(error.localizedDescription)")
                    completion(.failure(UserStoreError.noInternetConnection))
                    return
                }
                // Ensure data is not nil, otherwise, complete with a custom error.
                guard let unwrappedData = data else {
                    print("No data response")
                    completion(.failure(UserStoreError.failedToReceiveServerResponse))
                    return
                }
                do {
                    print("- there is a response - 1 ")
                    // Attempt to decode the JSON response.
                    if let jsonResult = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as? [String: Any] {
                        print("JSON serialized well")
                        let keysToExtract = ["alert_title", "alert_message"]
                        var dictModifiedResponse: [String: String] = [:]
                        
                        for key in keysToExtract {
                            if let value = jsonResult[key] as? String {
                                dictModifiedResponse[key] = value
                            }
                        }
                        self.assignUser(dictUser: jsonResult)
                        self.assignArryDataSourceObjects(jsonResponse: jsonResult)
                        self.assignArryDashboardTableObjects(jsonResponse: jsonResult)
                        // Ensure completion handler is called on the main queue.
                        DispatchQueue.main.async {
                            completion(.success(dictModifiedResponse))
                        }
                    } else {
                        print("- there is a response - 2 ")
                        // If decoding fails due to not being a [String: String]
                        DispatchQueue.main.async {
                            completion(.failure(UserStoreError.failedToReceiveExpectedResponse))
                        }
                    }
                } catch {
                    // Handle any errors that occurred during the JSON decoding.
                    print("---- UserStore.registerNewUser: Failed to read response")
                    DispatchQueue.main.async {
                        completion(.failure(UserStoreError.failedDecode))
                    }
                }
            }
            task.resume()
        case .failure(let error):
            print("* error encodeing from requestStore.callRegisterNewUser: \(error)")
            OperationQueue.main.addOperation {
                completion(.failure(UserStoreError.requestStoreError))
            }
        }
    }
    
    func callDeleteUser(completion: @escaping (Result<[String: String], UserStoreError>) -> Void) {
        print("- in callDeleteAppleHealthData")
        let request = RequestStore.shared.createRequestWithToken(endpoint: .delete_user)
        let task = RequestStore.shared.session.dataTask(with: request) { data, response, error in
            // Handle potential error from the data task
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(UserStoreError.generalError(error)))
                    print("- callDeleteUser: failure response")
                    print("\(UserStoreError.generalError(error).localizedDescription)")
                }
                return
            }
            guard let unwrapped_data = data else {
                // No data scenario
                DispatchQueue.main.async {
                    //                    completion(.failure(URLError(.badServerResponse)))
                    completion(.failure(UserStoreError.generalError(URLError(.badServerResponse))))
                    print("- callDeleteUser: failure response: \(URLError(.badServerResponse))")
                }
                return
            }
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: unwrapped_data, options: []) as? [String: Any] {
                    DispatchQueue.main.async {
                        self.deleteUserDefaults_User()
                        self.assignUser(dictUser: jsonResult)
                        completion(.success(["alert_message":"successfully deleted"]))
                        print("- callDeleteUser: Successful response: \(jsonResult)")
                    }
                } else {
                    // Data is not in the expected format
                    DispatchQueue.main.async {
                        //                        completion(.failure(URLError(.cannotParseResponse)))
                        completion(.failure(UserStoreError.generalError(URLError(.cannotParseResponse))))
                        print("- callDeleteUser: failure response: \(URLError(.cannotParseResponse))")
                    }
                }
            } catch {
                // Data parsing error
                DispatchQueue.main.async {
                    completion(.failure(UserStoreError.generalError(error)))
                    print("- callDeleteUser: failure response: \(error)")
                }
            }
        }
        task.resume()
    }
}



/* Good For now */
extension UserStore {

    func callUpdateUserLocationDetails(endPoint: EndPoint, sendUserLocations:Bool, completion: @escaping (Result<String,UserStoreError>) -> Void){
        // sendUserLocations:Bool is somewhat unncessary - API can receive as many locations updates, but ws_utilities screens for existing UserLocationDay, therefore, it won't add an additional loc even if iOS sends one.
        print("in UserStore.callUpdateUserLocationDetails()")
        let updateUserLocDict = UpdateUserLocationDetailsDictionary()
        updateUserLocDict.location_permission_device = self.user.location_permission_device
        updateUserLocDict.location_permission_ws = self.user.location_permission_ws
        if sendUserLocations{
            updateUserLocDict.user_location = LocationFetcher.shared.arryUserLocation
        }
        let requestStoreResult = RequestStore.shared.createRequestWithTokenAndBody(endPoint: endPoint,token:true, body: updateUserLocDict)
        switch requestStoreResult {
        case let .success(request):
            let task = session.dataTask(with: request){ data, response, error in
                guard let unwrappedData = data else {
                    print("no data response")
                    completion(.failure(UserStoreError.failedToReceiveServerResponse))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("No data response or invalid response")
                    completion(.failure(UserStoreError.failedToReceiveServerResponse))
                    return
                }
                if httpResponse.statusCode == 400 {
                    print("Received 400 Bad Request")
                    completion(.failure(UserStoreError.userHasNoUsername))
                    return
                }
                do {
                    guard let jsonResult = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as? [String: Any] else {
                        throw UserStoreError.failedDecode// throw will send to the catch block
                    }
                    self.assignUser(dictUser: jsonResult)// will not crash if no "user"
                    guard let message = jsonResult["alert_message"] as? String else {
                        throw UserStoreError.failedDecode
                    }
                    OperationQueue.main.addOperation {
                        print("--> successful callUpdateUser api response")
                        completion(.success(message))
                    }
                } catch {
                    print("---- UserStore.failedToUpdateUser: Failed to read response")
                    completion(.failure(UserStoreError.failedDecode))
                }
            }
            task.resume()
        case .failure(_):
            completion(.failure(UserStoreError.requestStoreError))
        }
    }
}

/* Receive Apple Health Statistics from API */
extension UserStore {
    func callSendDataSourceObjects(completion:@escaping (Result<Bool,Error>) -> Void){
        print("- in callSendDataSourceObjects")
        let request = RequestStore.shared.createRequestWithToken(endpoint: .send_data_source_objects)
        let task = RequestStore.shared.session.dataTask(with: request) { data, urlResponse, error in
            guard let unwrapped_data = data else {
                OperationQueue.main.addOperation {
                    completion(.failure(UserStoreError.failedToReceiveServerResponse))
                }
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let jsonArryDataSourceObj = try jsonDecoder.decode([DataSourceObject].self, from: unwrapped_data)
                OperationQueue.main.addOperation {
                    print("- decoded jsonArryDataSourceObj")
                    let repackagedJsonResponse = ["arryDataSourceObjects":jsonArryDataSourceObj] as [String:Any]
                    // MARK: call assingDataSourceObjects
                    self.assignArryDataSourceObjects(jsonResponse: repackagedJsonResponse)
                    completion(.success(true))
                }
            } catch {
                print("did not get expected response from WSAPI - probably no file for user")
                OperationQueue.main.addOperation {
                    completion(.failure(UserStoreError.failedToReceiveExpectedResponse))
                }
            }
        }
        task.resume()
    }
}
