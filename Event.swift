//
//  Event.swift
//  MyEvent309
//  Created by brfsu on 06.12.2023.
//
import Foundation
import CoreData
import UIKit

let applicationDelegate = UIApplication.shared.delegate as! AppDelegate
let context = applicationDelegate.persistentContainer.viewContext
let backgroundContext = applicationDelegate.backgroundContext
let session = URLSession(configuration: URLSessionConfiguration.default)

var eventsObjects = [Event]()

@objc(Event)
public class Event: NSManagedObject {
    static let rootUrl = "http://localhost:8081"
    
    convenience init() {
        self.init(entity: Event.entity(), insertInto: context)
    }
    
    convenience init(id: Int = 0, name: String = "") {
        self.init()
        self.id = Int16(id)
        self.name = String(name)
    }
    
}
