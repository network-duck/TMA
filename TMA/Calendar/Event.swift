//
//  Event.swift
//  TMA
//
//  Created by Joseph Rice on 4/23/24.
//

import Foundation

var eventsList = [Event]()

class Event: Codable {
    var id: Int
    var name: String
    var date: Date
        
    init(id: Int = 0, name: String = "", date: Date = Date()) {
        self.id = id
        self.name = name
        self.date = date
    }
    
    func eventsForDate(date: Date) -> [Event]? {
        var daysEvents = [Event]()
        for event in eventsList {
            if Calendar.current.isDate(event.date, inSameDayAs: date) {
                daysEvents.append(event)
            }
        }
        return daysEvents.isEmpty ? nil : daysEvents
    }
    
    func eventsForDateAndTime(date: Date, hour: Int) -> [Event]? {
        var daysEvents = [Event]()
        for event in eventsList {
            if Calendar.current.isDate(event.date, inSameDayAs: date) {
                let eventHour = CalendarHelper().hourFromDate(date: event.date)
                if eventHour == hour {
                    daysEvents.append(event)
                }
            }
        }
        return daysEvents.isEmpty ? nil : daysEvents
    }
}
