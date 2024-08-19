//
//  CalendarDay.swift
//  TMA
//
//  Created by Joseph Rice on 4/23/24.
//

import Foundation

class CalendarDay
{
	var day: String!
	var month: Month!
	
	enum Month
	{
		case previous
		case current
		case next
	}
}
