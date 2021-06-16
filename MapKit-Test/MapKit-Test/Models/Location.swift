//
//  Location.swift
//  MapKit-Test
//
//  Created by anthony byrd on 6/15/21.
//

import Foundation
import CoreLocation

class Location {
    let title: String
    let coordinates: CLLocationCoordinate2D?
    
    init(title: String, coordinates: CLLocationCoordinate2D?) {
        self.title = title
        self.coordinates = coordinates
    }
}
