//
//  Task.swift
//  LocationTasks
//
//  Created by Abdalla Abdelmagid on 11/10/24.
//

import CoreLocation

struct Task: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var description: String
    var dueDate: Date
    var location: CLLocationCoordinate2D
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, dueDate, latitude, longitude
    }
    
    init(id: UUID = UUID(), name: String, description: String, dueDate: Date, location: CLLocationCoordinate2D) {
        self.id = id
        self.name = name
        self.description = description
        self.dueDate = dueDate
        self.location = location
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        dueDate = try container.decode(Date.self, forKey: .dueDate)
        
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(dueDate, forKey: .dueDate)
        
        try container.encode(location.latitude, forKey: .latitude)
        try container.encode(location.longitude, forKey: .longitude)
    }
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.description == rhs.description &&
        lhs.dueDate == rhs.dueDate &&
        lhs.location.latitude == rhs.location.latitude &&
        lhs.location.longitude == rhs.location.longitude
    }
}
