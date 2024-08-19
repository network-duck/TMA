//
//  DailyViewController.swift
//  TMA
//
//  Created by Joseph Rice on 4/23/24.
//

import UIKit

class DailyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
	@IBOutlet weak var hourTableView: UITableView!
	@IBOutlet weak var dayOfWeekLabel: UILabel!
	@IBOutlet weak var dayLabel: UILabel!
	
	var hours = [Int]()

	override func viewDidLoad()
	{
		super.viewDidLoad()
		initTime()
		setDayView()
	}
	
	func initTime()
	{
		for hour in 0...23
		{
			hours.append(hour)
		}
	}
	
	func setDayView()
	{
		dayLabel.text = CalendarHelper().monthDayString(date: selectedDate)
		dayOfWeekLabel.text = CalendarHelper().weekDayAsString(date: selectedDate)
		hourTableView.reloadData()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return hours.count
	}
	
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDailyID") as! DailyCell
        
        let hour = hours[indexPath.row]
        cell.time.text = formatHour(hour: hour)
        
        if let events = Event().eventsForDateAndTime(date: selectedDate, hour: hour) {
            setEvents(cell, events)
        } else {
            hideAll(cell)
        }
        
        return cell
    }
    
	func setEvents(_ cell: DailyCell, _ events: [Event])
	{
		hideAll(cell)
		switch events.count
		{
		case 1:
			setEvent1(cell, events[0])
		case 2:
			setEvent1(cell, events[0])
			setEvent2(cell, events[1])
		case 3:
			setEvent1(cell, events[0])
			setEvent2(cell, events[1])
			setEvent3(cell, events[2])
		
		case let count where count > 3:
			setEvent1(cell, events[0])
			setEvent2(cell, events[1])
			setMoreEvents(cell, events.count - 2)
		default:
			break
		}
	}
	
	
	func setMoreEvents(_ cell: DailyCell, _ count: Int)
	{
		cell.event3.isHidden = false
		cell.event3.text = String(count) + " More Events"
	}
	
	func setEvent1(_ cell: DailyCell, _ event: Event)
	{
		cell.event1.isHidden = false
		cell.event1.text = event.name
	}
	
	func setEvent2(_ cell: DailyCell, _ event: Event)
	{
		cell.event2.isHidden = false
		cell.event2.text = event.name
	}
	
	func setEvent3(_ cell: DailyCell, _ event: Event)
	{
		cell.event3.isHidden = false
		cell.event3.text = event.name
	}
	
	func hideAll(_ cell: DailyCell)
	{
		cell.event1.isHidden = true
		cell.event2.isHidden = true
		cell.event3.isHidden = true
	}
	
	
	func formatHour(hour: Int) -> String
	{
		return String(format: "%02d:%02d", hour, 0)
	}
	
	@IBAction func nextDayAction(_ sender: Any)
	{
		selectedDate = CalendarHelper().addDays(date: selectedDate, days: 1)
		setDayView()
	}
	
	@IBAction func previousDayAction(_ sender: Any)
	{
		selectedDate = CalendarHelper().addDays(date: selectedDate, days: -1)
		setDayView()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setDayView()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let hour = hours[indexPath.row]
		if let events = Event().eventsForDateAndTime(date: selectedDate, hour: hour), !events.isEmpty {
			let selectedEvent = events[0] // Assuming you want to edit the first event in the list
			performSegue(withIdentifier: "eventEditSegue", sender: selectedEvent)
		} else {
			let alertController = UIAlertController(title: "No Event Selected", message: "Please select a valid event.", preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			present(alertController, animated: true, completion: nil)
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "eventEditSegue", let eventEditVC = segue.destination as? EventEditViewController,
			let selectedEvent = sender as? Event {
			eventEditVC.event = selectedEvent
		}
	}
}