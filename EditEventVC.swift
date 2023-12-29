//
//  EditEventVC.swift
//  MyEvent309
//  Created by brfsu on 06.12.2023.
//
import UIKit

class EditEventVC: UIViewController, UITextFieldDelegate
{
    weak var delegate: EventDelegate?
    var index: Int?

    
    private let navBar: UINavigationBar = {
        let screenSize: CGRect = UIScreen.main.bounds
        let bar = UINavigationBar(frame: CGRect(x: 0, y: 60, width: screenSize.width, height: 45))
        let navItem = UINavigationItem(title: "event")
        let undoItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.undo, target: nil, action: #selector(undoHandler))
        let saveItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: nil, action: #selector(saveHandler))
        navItem.leftBarButtonItem = undoItem
        navItem.rightBarButtonItem = saveItem
        bar.setItems([navItem], animated: true)
        return bar
    }()
    
    
    private let textField: UITextField = {
        let control = UITextField()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.placeholder = "Event"
        control.textColor = .white
        control.backgroundColor = .darkGray
        control.layer.borderWidth = 1.0
        control.layer.borderColor = UIColor.gray.cgColor
        control.layer.cornerRadius = 5
               
        control.font = UIFont.systemFont(ofSize: 22)
        control.clipsToBounds = true
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5.0, height: 2.0))
        control.leftView = leftView
        control.leftViewMode = .always
        return control
    }()
    
    
    
    @objc private func undoHandler() {
        setupAddEditVC()
    }
    
    
    @objc private func saveHandler() {
        let name = textField.text
        if name!.count == 0 {
            textField.backgroundColor = .red
            textField.becomeFirstResponder()
        } else { // we can save
            textField.resignFirstResponder()
            textField.backgroundColor = .darkGray
            
            if let _ = index { // Edit
                delegate?.editEvent(vc: self, eventOf: name!)
            } else {
                delegate?.addEvent(vc: self, eventOf: name!)
            }
            Event.saveData()
            dismiss(animated: true, completion: nil)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareInterface()

    }
    
    
    private func prepareInterface() {
        view.backgroundColor = .darkGray
        
        var title = "New event"
        if let _ = index {
            title = "Edit event"
        }
        
        navBar.topItem?.title = title
        
        view.addSubview(navBar)
        view.addSubview(textField)
        
        navBar.pinTop(to: view)
        navBar.pinLeft(to: view)
        navBar.pinRight(to: view)
        navBar.setHeight(40)
        
        textField.pinTop(to: view, 120)
        textField.pinLeft(to: view, 10)
        textField.pinRight(to: view, 10)
        textField.setHeight(45)
        
        setupAddEditVC()
    }
    private func setupAddEditVC() { ///
        textField.resignFirstResponder()
        textField.backgroundColor = .darkGray
        
        if let ind = index {
            textField.text = eventsObjects[ind].name
            ///
        } else { // Add
            textField.text = ""
        }
    }
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.backgroundColor = .darkGray
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        textField.backgroundColor = .darkGray
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.backgroundColor = .darkGray
        return true
    }
    
}
