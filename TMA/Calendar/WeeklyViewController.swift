//
//  WeeklyViewController.swift
//  TMA
//
//  Created by Joseph Rice on 4/23/24.
//

import UIKit

var selectedDate = Date()

class WeeklyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,
							UITableViewDelegate, UITableViewDataSource
{
	
	@IBOutlet weak var monthLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var collectionView: UICollectionView!
	

	var totalSquares = [Date]()
	
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		setCellsView()
		setWeekView()
	}
	
	func setCellsView()
	{
		let width = (collectionView.frame.size.width - 2) / 8
		let height = (collectionView.frame.size.height - 2)
		
		let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		flowLayout.itemSize = CGSize(width: width, height: height)
	}
	
	func setWeekView()
	{
		totalSquares.removeAll()
		
		var current = CalendarHelper().sundayForDate(date: selectedDate)
		let nextSunday = CalendarHelper().addDays(date: current, days: 7)
		
		while (current < nextSunday)
		{
			totalSquares.append(current)
			current = CalendarHelper().addDays(date: current, days: 1)
		}
		
		monthLabel.text = CalendarHelper().monthString(date: selectedDate)
			+ " " + CalendarHelper().yearString(date: selectedDate)
		collectionView.reloadData()
		tableView.reloadData()
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		totalSquares.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
		
		let date = totalSquares[indexPath.item]
		cell.dayOfMonth.text = String(CalendarHelper().dayOfMonth(date: date))
		
		if(date == selectedDate) {
			cell.backgroundColor = UIColor.systemBlue
		} else if let events = Event().eventsForDate(date: date), !events.isEmpty {
			cell.backgroundColor = UIColor.systemGreen
		} else {
			cell.backgroundColor = UIColor.white
		}
		
		return cell
	}
	
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
	{
		selectedDate = totalSquares[indexPath.item]
		collectionView.reloadData()
		tableView.reloadData()
	}
	
	@IBAction func previousWeek(_ sender: Any)
	{
		selectedDate = CalendarHelper().addDays(date: selectedDate, days: -7)
		setWeekView()
	}
	
	@IBAction func nextWeek(_ sender: Any)
	{
		selectedDate = CalendarHelper().addDays(date: selectedDate, days: 7)
		setWeekView()
	}
	
	override open var shouldAutorotate: Bool
	{
		return false
	}
	
	
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let events = Event().eventsForDate(date: selectedDate) {
            return events.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") as! EventCell
        
        if let events = Event().eventsForDate(date: selectedDate) {
            let sortedEvents = events.sorted {
                if $0.date == $1.date {
                    return $0.name < $1.name
                }
                return $0.date < $1.date
            }
            let event = sortedEvents[indexPath.row]
            cell.eventLabel.text = event.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let events = Event().eventsForDate(date: selectedDate), indexPath.row < events.count {
            let selectedEvent = events[indexPath.row]
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
    
	override func viewDidAppear(_ animated: Bool)
	{
		super.viewDidAppear(animated)
		setWeekView()
	}
}
