//
//  ViewController.swift
//  MyEvent309
//  Created by brfsu on 06.12.2023.
//
import UIKit

class EventsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, EventDelegate
{
    private var tableView: UITableView!
    private let cellId = "tvCell"
    private var index: Int?
    
    private let navBar: UINavigationBar = {
        let screenSize: CGRect = UIScreen.main.bounds
        let bar = UINavigationBar(frame: CGRect(x: 0, y: 60, width: screenSize.width, height: 45))
        
        let navItem = UINavigationItem(title: "")
        
        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: nil, action: #selector(addEventHandler))
        
        navItem.rightBarButtonItem = addItem
        bar.setItems([navItem], animated: true)
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareInterface()
    }
    override func viewWillAppear(_ animated: Bool) {
        Event.getEventsRemote { events in
            self.reloadEvents()
            self.tableView.reloadData()
        }
    }
    
    private func prepareInterface() { ///
        self.view.backgroundColor = .systemGray
        
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: 100, width: displayWidth, height: displayHeight))
        
        tableView.register(EventsTVCell.self, forCellReuseIdentifier: cellId)
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 66
        tableView.estimatedRowHeight = 66
        
        tableView.backgroundColor = .lightGray
        tableView.separatorStyle = .none
        
        view.addSubview(navBar)
        view.addSubview(tableView)
        
        Event.refresh()
        tableView.reloadData()

        /// swipeDown
        /// refresh
    }
    
    func reloadEvents() {
        Event.getEvents { events in
            eventsObjects = events
            self.tableView.reloadData()
        }
        
    }
    
    @objc private func addEventHandler() {
        let vc = EditEventVC()
        vc.delegate = self
        index = nil
        vc.index = nil
        present(vc, animated: true, completion: nil)
    }
    
    func addEvent(vc: EditEventVC, eventOf: String) {
        let e = Event(name: eventOf)
        eventsObjects.append(e)
        ///e.postEventRemote()
        Event.saveData()
        tableView.reloadData()
    }
    
    func editEvent(vc: EditEventVC, eventOf: String) {
        if let i = index {
            eventsObjects[i].name = eventOf
            let e = eventsObjects[i]
            ///e.patchEventRemote()
            ///e.postEventRemote()
            Event.saveData()
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        eventsObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EventsTVCell
        cell.nameLabel.text = eventsObjects[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EditEventVC()
        vc.delegate = self
        index = indexPath.row
        vc.index = index
        present(vc, animated: true)
    }
}
