//
//  RequestStore.swift
//  WS11iOS_v08
//
//  Created by Nick Rodriguez on 31/01/2024.
//

import Foundation

enum RequestStoreError: Error{
    case encodingFailed
    case someOtherError
    case missingToken
    case missingAuth
    var localizedDescription: String {
        switch self {
        case .encodingFailed: return "Failed to decode response."
        default: return "What Sticks main server is not responding."
        }
    }
}

class RequestStore {
    static let shared = RequestStore()
//    var urlStore:URLStore!
    var token: String!
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 240 // Timeout interval in seconds
        return URLSession(configuration: config)
    }()
    
//    init() {
//
//        self.urlStore=URLStore()
//        self.urlStore.apiBase = APIBase.prod
////        self.urlStore.apiBase = APIBase.dev
////        self.urlStore.apiBase = APIBase.local
//    }
    
    
    func createRequestLogin(email:String, password:String)->Result<URLRequest,Error>{
        let url = URLStore.shared.callEndpoint(endPoint: .login)
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        let loginString = "\(email):\(password)"
        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
            return .failure(RequestStoreError.encodingFailed)
        }
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        return .success(request)
    }
    
    func createRequestWithToken(endpoint:EndPoint) ->URLRequest{
        let url = URLStore.shared.callEndpoint(endPoint: endpoint)
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.setValue( self.token, forHTTPHeaderField: "x-access-token")
        print("- createRequestWithToken:")
        print(request)
        return request
    }
    
    func createRequestWithTokenAndBody<T: Encodable>(endPoint: EndPoint, token:Bool,body: T) ->Result<URLRequest,Error> {
        print("- createRequestWithTokenAndBody")
        let url = URLStore.shared.callEndpoint(endPoint: endPoint)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        if token {
            request.setValue(self.token, forHTTPHeaderField: "x-access-token")
        }
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(body)
            request.httpBody = jsonData
        } catch {
            print("Failed to encode body: \(error)")
            return .failure(RequestStoreError.encodingFailed)
        }
        print("built request: \(request)")
        return .success(request)
    }
    
    func createRequestWithTokenAndBodyWithAuth(endPoint:EndPoint,token:Bool,stringDict:[String:String]) -> Result<URLRequest,Error>{
        print("- createRequestWithBodyTokenAndAuth")
        let url = URLStore.shared.callEndpoint(endPoint: endPoint)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        if token {
            request.setValue(self.token, forHTTPHeaderField: "x-access-token")
        }
        
        if let unwp_email = stringDict["email"],
           let unwp_password = stringDict["password"]{
            let loginString = "\(unwp_email):\(unwp_password)"
            guard let loginData = loginString.data(using: String.Encoding.utf8) else {
                return .failure(RequestStoreError.encodingFailed)
            }
            let base64LoginString = loginData.base64EncodedString()
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        }
        else{
            print("- RequestStoreError: missing email or password")
            return .failure(RequestStoreError.missingAuth)
        }
        
        if let unwp_ws_api_password = stringDict["ws_api_password"]{
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: ["ws_api_password":Config.ws_api_password], options: [])
            } catch {
                print("Error encoding httpBody JSON: \(error)")
                return .failure(RequestStoreError.encodingFailed)
            }
        }
        return .success(request)
        
    }
    
    func createRequestWithUsername<T: Encodable>(endPoint:EndPoint,body:T) -> URLRequest{
        print("- createRequestWithUsername")
        let url = URLStore.shared.callEndpoint(endPoint: endPoint)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(body)
            request.httpBody = jsonData
        } catch {
            print("Failed to encode body: \(error)")
            
        }
        print("- Finished createRequestWithUsername ---")
        return request
        
    }
    
}



