//
//  User.swift
//  WhatSticks13iOS
//
//  Created by Nick Rodriguez on 29/06/2024.
//

import Foundation

import Foundation

class LoginResponse: Codable {
    var alert_title: String?
    var alert_message: String?
    var user: User?
}


class User: Codable {
    var id: String?
    var email: String?
    var password: String?
    var username: String?
    var token: String?
    var admin_permission: Bool?/* was admin */
    var latitude: String?
    var longitude: String?
    var timezone: String?
    var location_permission_device: Bool?/* was location_permission */
    //var location_permission_ws:Bool? /* was location_reoccuring_permission */
    var location_permission_ws:Bool = false {
        didSet{
            UserDefaults.standard.set(location_permission_ws, forKey: "location_permission_ws")
        }
    }
    var last_location_date: String?
    var notifications:Bool?
}


