//
//  LoggingUtilities.swift
//  WhatSticks13iOS_v01
//
//  Created by Nick Rodriguez on 13/10/2024.
//

import Foundation
// LoggingUtilities.swift

import Sentry

func logUserEvent(className: String, method: String, note:String) {
    let email = UserDefaults.standard.string(forKey: "email") ?? "N/A"
    let userName = UserDefaults.standard.string(forKey: "userName") ?? "N/A"
    let userId = UserDefaults.standard.string(forKey: "id") ?? "N/A"

    let userStoreEmail = UserStore.shared.user.email ?? "N/A"
    let userStoreUsername = UserStore.shared.user.username ?? "N/A"
    let userStoreId = UserStore.shared.user.id ?? "N/A"

    let baseMessage = "User accessed \(className).\(method)(): \nNote: \(note)\n"
    let userDetailsMessage = "UserDefaults userId: \(userId); email: \(email); username: \(userName); \nUserStore.user userId: \(userStoreId); email: \(userStoreEmail); username: \(userStoreUsername)"
    let message = baseMessage + userDetailsMessage
    SentrySDK.capture(message: message)
}
