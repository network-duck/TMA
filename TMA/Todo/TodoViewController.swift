//
//  TodoViewController.swift
//  TMA
//
//  Created by Joseph Rice on 4/23/24.
//

import UIKit

class TodoViewController: UITableViewController {

    var allEvents: [Date: [Event]] = [:] // Dictionary to store events grouped by date
    var sortedDates: [Date] = [] // Array to store sorted dates

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(EventCell.self, forCellReuseIdentifier: "cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
        tableView.reloadData()
    }

    func updateData() {
        // Reset data
        allEvents.removeAll()
        sortedDates.removeAll()

        // Group events by date
        for event in eventsList {
            let date = Calendar.current.startOfDay(for: event.date)
            if var eventsForDate = self.allEvents[date] {
                eventsForDate.append(event)
                self.allEvents[date] = eventsForDate.sorted(by: { $0.name < $1.name })
            } else {
                self.allEvents[date] = [event]
            }
        }

        // Sort dates
        sortedDates = Array(self.allEvents.keys).sorted()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sortedDates.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = sortedDates[section]
        return allEvents[date]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let date = sortedDates[indexPath.section]
        if let eventsForDate = allEvents[date] {
            let sortedEvents = eventsForDate.sorted {
                if $0.date == $1.date {
                    return $0.name < $1.name
                }
                return $0.date < $1.date
            }
            let event = sortedEvents[indexPath.row]
            cell.textLabel?.text = event.name
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = sortedDates[section]
        return formatDate(date)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let date = sortedDates[indexPath.section]
        if let eventsForDate = allEvents[date], indexPath.row < eventsForDate.count {
            let selectedEvent = eventsForDate[indexPath.row]
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

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter.string(from: date)
    }
}