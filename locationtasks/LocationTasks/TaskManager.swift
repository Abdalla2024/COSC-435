//
//  TaskManager.swift
//  LocationTasks
//
//  Created by Abdalla Abdelmagid on 11/5/24.
//

import Foundation
import CoreLocation

class TaskManager: ObservableObject {
    @Published var tasks: [Task] = []
    
    func addTask(name: String, description: String, dueDate: Date, location: CLLocationCoordinate2D) {
        let newTask = Task(name: name, description: description, dueDate: dueDate, location: location)
        tasks.append(newTask)
    }
    
    func removeTask(at index: Int) {
        tasks.remove(at: index)
    }
}
