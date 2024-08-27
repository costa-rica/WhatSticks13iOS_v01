//
//  UrlStore.swift
//  WS11iOS_v08
//
//  Created by Nick Rodriguez on 31/01/2024.
//

import UIKit

enum APIBase:String, CaseIterable {
    case local = "localhost"
    case dev = "dev"
    case prod = "prod"
    var urlString:String {
        switch self{
        case .local: return "http://127.0.0.1:5001/"
        case .dev: return "https://dev.api13.what-sticks.com/"
        case .prod: return "https://api13.what-sticks.com/"
        }
    }
}

enum EndPoint: String {
    case are_we_running = "are_we_running"
    case login = "login"
    case login_generic_account = "login_generic_account"
    case register_generic_account = "register_generic_account"
    case convert_generic_account_to_custom_account = "convert_generic_account_to_custom_account"
    case delete_user = "delete_user"
//    case update_user_location_with_user_location_json = "update_user_location_with_user_location_json"
//    case update_user_location_with_lat_lon = "update_user_location_with_lat_lon"
    case update_user_location_details = "update_user_location_details"
    case get_reset_password_token = "get_reset_password_token"

    case receive_apple_qty_cat_data = "receive_apple_qty_cat_data"
    case receive_apple_workouts_data = "receive_apple_workouts_data"
    case delete_apple_health_for_user = "delete_apple_health_for_user"
    
    case send_data_source_objects = "send_data_source_objects"
    case send_dashboard_table_objects = "send_dashboard_table_objects"
    
}

class URLStore {
    static let shared = URLStore()
    var apiBase:APIBase!

    func callEndpoint(endPoint: EndPoint) -> URL{
        let baseURLString = apiBase.urlString + endPoint.rawValue
        let components = URLComponents(string:baseURLString)!
        return components.url!
    }
}
