//
//  Event+CoreDataProperties.swift
//  MyEvent309
//  Created by brfsu on 06.12.2023.
//
import Foundation
import CoreData

extension Event {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var id: Int16
    
    class func getEventsRemote(_ complection: @escaping ([Event]) -> Void) {
        let url = URL(string: "\(Event.rootUrl)/get-all-events")!
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                let jsonEvents = try! JSONSerialization.jsonObject(with: data!, options: []) as! [AnyObject]
                OperationQueue.main.addOperation {
                    for jsonEvent in jsonEvents {
                        let id = jsonEvent["id"] as! Int
                        let event = Event.eventWithID(id) ?? Event()
                        event.id = Int16(id)
                        event.name = jsonEvent["name"] as? String
                        eventsObjects.append(event)
                    }
                    Event.saveData()
                    complection(eventsObjects)
                }
            }
        }
        task.resume()
    }
    
    func postEventRemote() {
        let url = URL(string: "\(Event.rootUrl)/post-event")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body = "name=\(name! )&dtime=2021-01-28 22:18:07&evtype=0&repeating=0&completed=0&deleted=0"
        
        
        request.httpBody = body.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                let jsonEvent = try! JSONSerialization.jsonObject(with: data!, options: []) as AnyObject
                OperationQueue.main.addOperation {
                    self.id = jsonEvent["id"]! as! Int16
                    do {
                        try context.save()
                    } catch _ {
                        print("Error while saving context. ")
                    }
                }
            }
        }
        task.resume()
        
    }
    
    public class func refresh() {
        eventsObjects = Event.getData()
    }

    public class func getData() -> [Event] {
        let request = Event.fetchRequest() as NSFetchRequest<Event>
        request.returnsObjectsAsFaults = false
        do {
            eventsObjects = try context.fetch(request)
        } catch _ { }
        
        return eventsObjects
    }

    class func eventWithID(_ id: Int) -> Event? {
        let fetchRequest = 
        NSFetchRequest<NSFetchRequestResult>(entityName:
        "Event")
        fetchRequest.predicate = NSPredicate(format: "id == %@", String(id))
        let results = try? context.fetch(fetchRequest)
        return results?.first as? Event
    }
    
    class func getEvents(_ completion: @escaping ([Event]) -> Void ) {
       
        let request =
        NSFetchRequest<NSFetchRequestResult>(entityName:
        "Event")
        request.sortDescriptors = [NSSortDescriptor(key:
            "name", ascending: true)]
        
        backgroundContext.perform {
            request.resultType = .managedObjectIDResultType
            let ids = try! backgroundContext.fetch(request) as!
            [NSManagedObjectID]
            context.perform {
                var objects = [Event] ()
                for id in ids {
                    let object = context.object(with: id)
                    objects.append(object as! Event)
                }
                completion(objects)
            }
        }
        
    }
    
    public class func saveData() {
        do {
            try context.save()
        } catch _ { }
    }
    public class func deleteEvent(event: Event) {
        context.delete(event)
    }
}

extension Event : Identifiable {

}
