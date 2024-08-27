//
//  NEW_LocationFetcher.swift
//  WhatSticks13iOS
//
//  Created by Nick Rodriguez on 18/08/2024.
//

import Foundation
import CoreLocation


enum LocationFetcherError:Error{
    case failedDecode
    case somethingWentWrong
    var localizedDescription:String{
        switch self{
        case.failedDecode: return "Failed to decode"
        default:return "uhhh Idk?"
        }
    }
}

extension CLAuthorizationStatus {
    var localizedDescription: String {
        switch self {
        case .notDetermined:return "Not determined"
        case .restricted:return  "Restricted"
        case .denied:return "Denied"
        case .authorizedAlways:   return "Always allowed"
        case .authorizedWhenInUse: return "When in use"
        @unknown default: return "Unknown"
        }
    }
}

class LocationFetcher: NSObject, CLLocationManagerDelegate {
    
    /* Properties */
    static let shared = LocationFetcher()
    let locationManager = CLLocationManager()
    var arryUserLocation: [UserLocation] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(arryUserLocation) {
                UserDefaults.standard.set(encoded, forKey: "arryUserLocation")
                print("- appended a UserLocation to UserDefault")
            }
        }
    }
    var lastLocationUpdateDate: Date = Calendar.current.date(byAdding: .hour, value: -24, to: Date())! {
        didSet{
            UserDefaults.standard.set(lastLocationUpdateDate, forKey: "lastLocationUpdateDate")
        }
    }
    var completionCLLocation: ((CLLocation?) -> Void)?
    var updateInterval: TimeInterval = 86_400 // 24 hours in seconds

    
    override init() {
        // Initialize arryUserLocation with value from UserDefaults
        if let encodedData = UserDefaults.standard.data(forKey: "arryUserLocation") {
            do {
                let decodedArray = try JSONDecoder().decode([UserLocation].self, from: encodedData)
                arryUserLocation = decodedArray
                print("- Load: arryUserLocation from UserDefaults ")
            } catch {
                print("- No arryUserLocation in UserDefaults. This should occur on first Launch, error: \(error) ***")
                arryUserLocation = [] // Fallback if decoding fails
            }
        } else {
            arryUserLocation = [] // Fallback if there's no data in UserDefaults
        }
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true // Enable background location updates
        locationManager.pausesLocationUpdatesAutomatically = false // Prevent automatic pausing
//        loadLocationFetcherUserDefaults()
        setUserStoreUserLocationPermissionDevice()
    }
    
    func deletedUser(){
        arryUserLocation = []
        UserDefaults.standard.removeObject(forKey: "lastUpdateTimestamp")
        UserDefaults.standard.removeObject(forKey: "arryUserLocation")
    }
    func loadLocationFetcherUserDefaults() {
        arryUserLocation = []
        if let encodedData = UserDefaults.standard.data(forKey: "arryUserLocation") {
            do {
                let decodedArray = try JSONDecoder().decode([UserLocation].self, from: encodedData)
                arryUserLocation = decodedArray
            } catch {
                print("*** (1) This should occur on first Launch: \(error) ***")
            }
        }
        // Retrieve the date from UserDefaults
        if let savedDate = UserDefaults.standard.object(forKey: "lastLocationUpdateDate") as? Date {
            // Assign the retrieved date to the object's property
            self.lastLocationUpdateDate = savedDate
        }
    }
    
    
    func fetchLocationOnce(completion: @escaping (CLLocation?) -> Void) {
        // Optional unnecessary - API can receive as many locations updates, but ws_utilities screens for existing UserLocationDay, therefore, it won't add an additional loc even if iOS sends one.
        self.completionCLLocation = completion
        locationManager.requestLocation()
    }
    
    func appendLocationToArryHistUserLocation(lastLocation: CLLocation) {
        let userLocation = UserLocation()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd-HHmm"
        userLocation.timestampString = dateFormatter.string(from: userLocation.timestamp)
        userLocation.latitude = lastLocation.coordinate.latitude
        userLocation.longitude = lastLocation.coordinate.longitude
        arryUserLocation.append(userLocation)
    }
    func setUserStoreUserLocationPermissionDevice(){
        switch locationManager.authorizationStatus{
        case .authorizedAlways, .authorizedWhenInUse:
            UserStore.shared.user.location_permission_device = true
            UserDefaults.standard.set(true, forKey: "location_permission_device")
        default:
            UserStore.shared.user.location_permission_device = false
            UserDefaults.standard.set(false, forKey: "location_permission_device")
        }
    }
    
    /* delegate methods */
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        setUserStoreUserLocationPermissionDevice()
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            completionCLLocation?(nil)
            return
        }
        // If there is a saved
        let savedDateConertedToDouble = lastLocationUpdateDate.timeIntervalSince1970// Converts to a double
        let now = Date().timeIntervalSince1970// Converts to a double
        if now - savedDateConertedToDouble < updateInterval {
            completionCLLocation?(nil)
            return
        }
        lastLocationUpdateDate=Date()
        completionCLLocation?(lastLocation)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        // Handle the error here, e.g. show an alert to the user
    }
}



class UserLocation: Codable {
    var timestamp: Date = Date()
    var timestampString: String!
    var latitude: Double!
    var longitude: Double!
    //    var appState: String?
}

class UpdateUserLocationDetailsDictionary: Codable {
    var location_permission_device: Bool?
    var location_permission_ws: Bool?
    var user_location: [UserLocation]?
}
