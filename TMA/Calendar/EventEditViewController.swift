//
//  EventEditViewController.swift
//  TMA
//
//  Created by Joseph Rice on 4/23/24.
//

import UIKit

class EventEditViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let event = event {
            nameTF.text = event.name
            datePicker.date = event.date
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if let event = event, let index = eventsList.firstIndex(where: { $0.id == event.id }) {
            // Update existing event
            eventsList[index].name = nameTF.text ?? ""
            eventsList[index].date = datePicker.date
        } else {
            // Create new event
            let newEvent = Event(id: eventsList.count, name: nameTF.text ?? "", date: datePicker.date)
            eventsList.append(newEvent)
        }
        CalendarHelper.saveEvents(eventsList)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        if let event = event, let index = eventsList.firstIndex(where: { $0.id == event.id }) {
            eventsList.remove(at: index)
            CalendarHelper.saveEvents(eventsList)
            navigationController?.popViewController(animated: true)
        }
    }
}