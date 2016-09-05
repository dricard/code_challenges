#!/usr/bin/env xcrun swift
//requires Swift 2.0
//-- parameter: name
var argument = "time"
if Process.arguments.count > 1 {
	argument = Process.arguments[1]
}

import Foundation

//print("Hello \(argument)!", terminator:"") // empty terminator suppresses newline

let constellation=[ "Elixus the Cat", "Shaer the Healer", "Oobiscus the Foxweir", "Eghorus the Rooster", "Ina D'Xus the Warrior", "Orcipus the Pig", "Falinea the Centaur", "Ma'Taline the Mystic", "Detros the Ruknee", "Awjus and Hamusa the Shredders","Josephus the Ancient", "Enba the Rat" ]

let zodiacLength = [ 28, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29, 29 ]

let constellation_short = [ "Cat", "Healer", "Fox", "Rooster", "Warrior", "Pig", "Centaur", "Mystic", "Maha", "Shredders", "Ancient", "Rat" ]

let weekday_names = ["Fordi", "Somdi", "Soldi", "Lundi", "Gradi", "Terrdi", "Merdi"]

// year starts with the winter season, so winter 14th is day of year 14
let seasonsNames = [ "Winter",  "Spring", "Summer", "Fall" ]

// Each season is 360 / 4  days = 90 days

enum amOrPm: String {
	case am = "am"
	case pm = "pm"
	
//	func simpleDescription() -> String {
//		switch self {
//			case .am:
//				return "am"
//			case .pm:
//				return "pm"
//		}
//	}
}

let gMoonPhaseText = [ " ", "a waxing crescent"
	, "a waxing crescent", "a waxing crescent"
	, "a waxing crescent", "a waxing quarter"
	, "a waxing quarter", "a waxing quarter (Half)"
	, "a waxing quarter", "a waxing quarter"
	, "a waxing gibbous", "a waxing gibbous"
	, "a waxing gibbous", "a waxing gibbous"
	, "O", "a waning gibbous"
	, "a waning gibbous", "a waning gibbous"
	, "a waning gibbous", "a waning quarter"
	, "a waning quarter", "a waning quarter (Half)"
	, "a waning quarter", "a waning quarter"
	, "a waning crescent", "a waning crescent"
	, "a waning crescent", "a waning crescent"
]

// MARK: - REAL LIFE

let daysInMonth = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ]

let monthName = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ]

// MARK: - General constants

let g_refyear = 599
let g_refyear1 = 546
let g_dayinyear = 360
let g_dayinzodiac = 29
let daysInMoonCycle = 28
let g_zodiacsincycle = 12

let g_secsInAMinute: Int64 = 60
let g_secsInAnHour: Int64 = 60 * g_secsInAMinute
let g_secsInADay: Int64 = 24 * g_secsInAnHour
let g_secsInAYear: Int64 = 360 * g_secsInADay

// MARK: - Properties

var puddleYear = 545
var g_current_doy = ""
var g_sunrise = 0
var g_sunset = 0
var g_timeString = ""
var g_time_prefix = "It is "

var g_current_cstl = 0
var g_daysInZodiac = 0

var g_ponder_time_to = false


var g_TIDE_time = [ 0, 0, 0, 0 ]

var g_TIDE_time_zero = 0

// MARK: - Utilities

/// Some functions, like findDaylight returns time in minutes. This function
/// converts those into hours, minutes and am/pm.
/// It is assumed that minutes is <= 1440 (which is 24 hours)
func convertMinutesToHoursMinutes(minutes: Int) -> (hours: Int, minutes: Int, timeHalf: amOrPm) {
	var hours = Int(floor(Double(minutes) / 60.0))
	let minutesLeft = minutes % 60
	var timeHalf: amOrPm = .am
	
	if hours > 12 {
		timeHalf = .pm
		hours -= 12
	}

	return (hours, minutesLeft, timeHalf)
}

//print(convertMinutesToHoursMinutes(157)) // expect (2, 37, cl_astro.amOrPm.am)
//print(convertMinutesToHoursMinutes(905)) // expect (3, 5, cl_astro.amOrPm.pm)
//print(convertMinutesToHoursMinutes(57)) // expect (0, 57, cl_astro.amOrPm.am)

// This is to convert form 24H to AM/PM (more used by CL people)
func convertToAmPmTimeFormat(hours: Int) -> (hour: Int, timeHalf: amOrPm) {
	var hoursAmPmFormat = 0
	var timeHalf: amOrPm = .am
	if hours == 0 {
		hoursAmPmFormat = 12
	} else if hours >= 12 {
		timeHalf = .pm
		if hours >= 12 {
			hoursAmPmFormat = hours - 12
		} else {
			hoursAmPmFormat = 12
		}
	} else {
		hoursAmPmFormat = hours
	}
	return (hoursAmPmFormat, timeHalf)
}

/// This function is used to return a formated string with the time expressed
/// in minutes. It uses convertMinutesToHoursMinutes
func convertMinutesToHoursMinutesDescription(minutes: Int) -> String {
	let time = convertMinutesToHoursMinutes(minutes)
	let filler = time.minutes < 10 ? "0" : ""
	return "\(time.hours):\(filler)\(time.minutes)\(time.timeHalf)"
}

//print(convertMinutesToHoursMinutesDescription(157)) // expect 2:37 am
//print(convertMinutesToHoursMinutesDescription(905)) // expect 3:05 pm
//print(convertMinutesToHoursMinutesDescription(57)) // expect 0:57 am

// MARK: - Astronomical data

/// This returns the number of days since the reference time
/// which is Merdi day 14th of Winter 545 which was the first day of the
/// constellation Shredders.
func getDaysSinceReference(year: Int, dayOfYear: Int) -> Int {
	var day_offset = 0
	var year_offset = 0
	if year == 545 {
		day_offset = dayOfYear - 14
	} else {
		year_offset = year - 546
		day_offset = (360 * year_offset) + 346 + dayOfYear
	}

	return day_offset
}

//print(getDaysSinceReference(605, dayOfYear: 147)) // expected 21733

/// Finds the rising constellation. Use this to get the constellation without the full
/// astronomical data.
/// This is based on Merdi Winter 14th 545 where Shredders rose for the first time
func constellationForDay(year: Int, dayOfYear: Int) -> (constIndex: Int, daysIntoZodiac: Int) {

	// First get the numbers of days since our reference point
	let day_offset = getDaysSinceReference(year, dayOfYear: dayOfYear)

	// we find the current day in a full one-year zodiac cycle
	// which is 12 times 29 days
	let currentCycleDay = day_offset % ( g_zodiacsincycle * g_dayinzodiac)

	// then we find the day in the current zodiac
	let dayInCycle = currentCycleDay % g_dayinzodiac
	// now we find the current zodiac
	var zodiacIndex = Int(currentCycleDay / g_dayinzodiac)
	// we need to add the starting index for the reference we use (Shredders)
	zodiacIndex += 9
	// normalize the index to 0-11
	if zodiacIndex > 11 { zodiacIndex -= 12 }

	// print(dayInCycle)
	// print(zodiacIndex)

	return (zodiacIndex, dayInCycle)

}
/// Finds the rising constellation. Use this to get the constellation without the full
/// astronomical data.
/// This is based on Merdi Winter 14th 545 where Shredders rose for the first time.
/// This expects the days since the reference time (as returned by getDaysSinceReference)
func constellationForDayReport(day_offset: Int) -> (constIndex: Int, daysIntoZodiac: Int) {

	// we find the current day in a full one-year zodiac cycle
	// which is 12 times 29 days
	let currentCycleDay = day_offset % ( g_zodiacsincycle * g_dayinzodiac)

	// then we find the day in the current zodiac
	let dayInCycle = currentCycleDay % g_dayinzodiac
	// now we find the current zodiac
	var zodiacIndex = Int(currentCycleDay / g_dayinzodiac)
	// we need to add the starting index for the reference we use (Shredders)
	zodiacIndex += 9
	// normalize the index to 0-11
	if zodiacIndex > 11 { zodiacIndex -= 12 }

	// print(dayInCycle)
	// print(zodiacIndex)

	return (zodiacIndex, dayInCycle)

}


//print(constellationForDay(605, dayOfYear: 147)) // expected (2, 12)

/// This function returns the index of the weekday_names array
func getDayOfWeek(year: Int, dayOfYear: Int) -> Int {

	// reference time is a Merdi, so add its index (6) to the dayOffset
	let dayOffset = getDaysSinceReference(year, dayOfYear: dayOfYear) + 6

	// we return this modulo 7 to convert it to 0...6
	return dayOffset % 7
}
/// This function returns the index of the weekday_names array
func getDayOfWeekReport(year: Int, dayOfYear: Int) -> Int {

	// reference time is a Merdi, so add its index (6) to the dayOffset
	let dayOffset = getDaysSinceReference(year, dayOfYear: dayOfYear) + 6

	// we return this modulo 7 to convert it to 0...6
	return dayOffset % 7
}

//print(getDayOfWeek(605, dayOfYear: 143)) // expect 0 (Fordi)
//print(getDayOfWeek(605, dayOfYear: 147)) // expect 4 (Gradi)

/// This function returns the number of days in the moon cycle
func getMoonPhase(year: Int, dayOfYear: Int) -> Int {

	// we get the days since the reference then substract 10 from that
	// because that reference day was 10 days into the moon cycle and
	// we want to reference to day 0 of the moon cycle.
	let dayOffset = getDaysSinceReference(year, dayOfYear: dayOfYear) - 10

	return dayOffset % daysInMoonCycle
}

/// This function returns the number of days in the moon cycle
/// This expects the days since the reference time (as returned by getDaysSinceReference)
func getMoonPhaseReport(dayOffset: Int) -> Int {

	// we get the days since the reference then substract 10 from that
	// because that reference day was 10 days into the moon cycle and
	// we want to reference to day 0 of the moon cycle.

	return (dayOffset - 10) % daysInMoonCycle
}

//print(getMoonPhase(605, dayOfYear: 147)) // expect 23


/// This function takes the days in the moon cycle and returns
/// a string with the moon phase description
func moonPhaseDescription(moonPhase: Int) -> String {
	var description: String
	switch moonPhase {
	case 22...27:
		description = "The Moon is in her 4th quarter "
	case 15...21:
		description = "The Moon is in her 3rd quarter "
	case 14:
		description = "Today is the Full Moon "
	case 8...13:
		description = "The Moon is in her 2nd quarter "
	case 1...7:
		description = "The Moon is in her 1st quarter "
	case 0:
		description = "Today is the New Moon "
	default:
		description = "This will never happen"
	}
	description += "(" + gMoonPhaseText[moonPhase] + ")"
	return description
}

//print(moonPhaseDescription(23)) // expect The Moon is in her 4th quarter (a waning quarter)

/// This returns the number of days until the next full moon
func nextFullMoon(year: Int, dayOfYear: Int) -> Int {
	let moonPhase = getMoonPhase(year, dayOfYear: dayOfYear)

	var daysToFullMoon = 14 - moonPhase

	if daysToFullMoon <= 0 {
		daysToFullMoon += 28
	}

	return daysToFullMoon
}
/// This returns the number of days until the next full moon
/// This expects the days since the reference time (as returned by getDaysSinceReference)
func nextFullMoonReport(dayOffset: Int) -> Int {
	let moonPhase = getMoonPhaseReport(dayOffset)

	var daysToFullMoon = 14 - moonPhase

	if daysToFullMoon <= 0 {
		daysToFullMoon += 28
	}

	return daysToFullMoon
}

//print(nextFullMoon(605, dayOfYear: 147)) // expect 19

/// Returns the sunrise and sunset in minutes. Use
/// convertMinutesToHoursMinutes to convert into h/m
func findDaylight(dayOfYear: Int) -> (sunrise: Int, sunset: Int) {

	// the year starts in winter so day of year 0 is first day of
	// winter. That day is the shortest day of the year with sunrise
	// at 9am and sunset at 3pm. Each day gains 2 minutes up to the middle
	// of the year (day of year 180) which is the longest day and things
	// flip sides.
	var sunrise: Int
	var sunset: Int
	if dayOfYear <= 180 {
		sunrise = 540 - (2 * dayOfYear)
		sunset = 900 + (2 * dayOfYear)
	} else {
		let dayIndex = dayOfYear - 180
		sunrise = 180 + (2 * dayIndex)
		sunset = 1260 - (2 * dayIndex)
	}

	return (sunrise, sunset)
}

//print(findDaylight(147)) // expect (246, 1194)
//print(convertMinutesToHoursMinutesDescription(findDaylight(147).sunrise)) // expect 4:06 am
//print(convertMinutesToHoursMinutesDescription(findDaylight(147).sunset)) // expect 7:54 pm

/// returns the index of seasonsNames. Winter is the first season with index 0.
/// Each season is exactly 90 days
func getSeason(dayOfYear: Int) -> Int {
	return Int(dayOfYear / 90)
}

//print(getSeason(147)) // expect 1

// MARK: - Reporting methods

/// This finds all the relevant astonomical information and outputs a
/// formated string containing the informations.
func astroData(year: Int, dayOfYear: Int) -> String {

	// To reduce unecessary computation we'll call getDaysSinceReference ounce here
	// and then call the corresponding methods that expect this parameter
	let dayOffset = getDaysSinceReference(year, dayOfYear: dayOfYear)
	
	// Date
	var description = "Today is " + weekday_names[getDayOfWeek(year, dayOfYear: dayOfYear)] + ", day \(dayOfYear % 90) of " + seasonsNames[getSeason(dayOfYear)] + ", \(year)."

	// Sun information
	description += " The sun rises at " + convertMinutesToHoursMinutesDescription(findDaylight(dayOfYear).sunrise) + " and sets at " + convertMinutesToHoursMinutesDescription(findDaylight(dayOfYear).sunset) + "."

	// Moon information
	let nextFM = nextFullMoonReport(dayOffset)

	description += " " + moonPhaseDescription(getMoonPhaseReport(dayOffset)) + ", it is day \(getMoonPhaseReport(dayOffset)) of the moon. The next full moon will be in \(nextFM) day" + ( nextFM > 1 ? "s." : ".")

	// Zodiac information
	let const = constellationForDayReport(dayOffset)
	var nextConst = const.constIndex + 1
	if nextConst > 11 { nextConst -= 12 }
	let nextZodiac = g_dayinzodiac - const.daysIntoZodiac
	description += " The " + constellation_short[const.constIndex] + " rises with the Sun today; " + constellation_short[nextConst] + " will be next in \(nextZodiac) day" + ( nextZodiac > 1 ? "s." : ".")

	return description
}

//print(astroData(605, dayOfYear: 147))

/* expect: Today is Gradi, day 57 of Spring, 605. The sun rises at 4:06 am and sets at 7:54 pm. The Moon is in her 4th quarter (a waning quarter), it is day 23 of the moon. The next full moon will be in 19 days. The Fox rises with the Sun today. The Rooster will rise in 17 days.
*/

// MARK: - Real Life Time to CL Time convertions

/// This returns the number of days in the whole years between
/// the year passed as a parameter and the reference year (2013), 
/// not including days in 2013 and in the year passed as a parameter.
/// Takes leap years into account
func daysInYearsBetween(year: Int) -> Int {
	var days = 0
	if year - 2013 <= 1 {
		// since we don't count days in the passed year
		// if 2014 - 2013 = 1, we're not counting days
		// in 2014 nor days in 2013, so zero is returned
		return 0
	} else {
		for y in 2014..<year {
			days += 365
			days += y % 4 == 0 ? 1 : 0
			// print("Y: \(y): \(days)")
		}
	}
	return days
}

//print(daysInYearsBetween(2016)) // expect 730
//print(daysInYearsBetween(2015)) // expect 365
//print(daysInYearsBetween(2014)) // expect 0

/// This returns the days in a given year up to a given date. This includes the
/// day (as if it was completed) so compensate for a time in that day
/// (so substract). This takes leap years into account
func daysToDate(year: Int, month: Int, day: Int) -> Int {
	let leapYear = year % 4 == 0 ? 1 : 0
	// print("\(year) is a leap year? \(leapYear)")

	// validate parameters
	guard month >= 1 && month <= 12 else {
		print("Bad month parameter")
		return 0
	}
	
	guard day >= 1 && day <= 31 else {
		print("Bad day parameter")
		return 0
	}
		
	if month == 2 {
		if leapYear == 0 && day > 28 || leapYear == 1 && day > 29 || day < 1 {
			print("Bad number of days for month 2")
			return 0
		}
	} else {
		if day >= daysInMonth[month - 1] || day < 1{
			print("Wrong number of days for month 1")
			return 0
		}
	}
	
	var days = 0
	for m in 1..<month {
		// we use m-1 because we're zero-indexed
		days += daysInMonth[m - 1]
	}
	// adjust for leap year if needed
	if month > 2 {
		days += leapYear
	}
	// add days of the current month
	days += day

	return days
}

//print(daysToDate(2016, month: 08, day: 25)) // expcet 238
//print(daysToDate(2016, month: 02, day: 30)) // expcet Wrong number of days
//print(daysToDate(2016, month: 02, day: 29)) // expect 60
//print(daysToDate(2016, month: 02, day: 28)) // expect 59
//print(daysToDate(2015, month: 02, day: 30)) // expcet Wrong number of days
//print(daysToDate(2015, month: 02, day: 29)) // expect Wrong number of days
//print(daysToDate(2015, month: 02, day: 28)) // expect 59
//print(daysToDate(2013, month: 3, day: 2)) // expect 61

/// This returns the time in the year of reference for the RL convertion
/// which is 2013/03/02 at 4:51:53p and corresponds to 07:37:30p
/// This returns the time **after** the reference time in the year
/// which is used to compute the time-since-the-reference
func daysIn2013() -> (days: Int, sec: Int) {
//	let daysToRef = daysToDate(2013, month: 03, day: 02)
//	let secondsInDay = 16 * 60 * 60 + 51 * 60 + 53
//	let secInADay = 24 * 60 * 60
//	return (365 - daysToRef, secInADay - secondsInDay)
	return (304, 25687)
}

//print(daysIn2013()) // expect (304, 25687)

/// This converts a number of seconds (in real life) to a number
/// of seconds in CL time
func convertToClTime(secs: Int64) -> Double {
	let a = 4.0909
	// the values of a and b were computed by inear regression
	// of RL -> CL matches over many years
	let b = 9544129.43619996
	let y = a * Double(secs) + b
	// print(y)
	return y
}

//print(convertToClTime(1000)) // expect 9548220.33619996

/// This is the reverse function which converts CL to RL time
func convertToRlTime(secs: Int64) -> Double {
	let a = 4.0909
	// the values of a and b were computed by inear regression
	// of RL -> CL matches over many years
//    let b = 9544129.43619996 / a
//    let y = Double(secs) / a - b
	let y = Double(secs) / a
//    print(y)
	return y
}

//print(convertToRlTime(Int64(1000)))  // expect 244.444987655528

/// This takes the current date and time and converts it to CL time
/// This does not take daylight savings into account: see clTime()
/// This is not normally called on its own, the calling function is
/// responsible to check for DST.
func convertRLTime(year: Int, month: Int, day: Int, hour: Int, min: Int, sec: Int) -> (year: Int, dayOfYear: Int, hour: Int, min: Int, sec: Int) {
	// first the time interval in the end of the reference year
	let referenceYear = daysIn2013()
	// print("Ref year days: \(referenceYear.days), secs: \(referenceYear.sec)")
	// now the time up to the date given in the current year
	let thisYear = daysToDate(year, month: month, day: day)
	// print("ThisYear (including this full day): \(thisYear)")
	// finally the years in between the current and the reference year
	let daysInBetween = daysInYearsBetween(year)
	// print("Days in between years: \(daysInBetween)")
	
	// add the days to the given date (not counting seconds yet)
	// since this day is not complete we substract one from the
	// thisyear number
	var totalDays = referenceYear.days + daysInBetween + thisYear - 1
	// print("total days: \(totalDays)")

	var totalSecs: Int64 = Int64(referenceYear.sec)
	totalSecs += Int64(hour) * 60 * 60
	totalSecs += Int64(min) * 60
	totalSecs += Int64(sec)
	while totalSecs > 86400 {
		totalDays += 1
		totalSecs -= 86400
	}

	// convert everyting in secs (a day is 24 * 60 min * 60 sec = 86400)
	totalSecs = totalSecs + Int64(totalDays) * 86400

	// print("Date: \(year)-\(month)-\(day) @ \(hour):\(min):\(sec)")
	// print("secs from ref: \(totalSecs)")

	// convertion factor for CL time vs RL time
	var clSecs: Double
	clSecs = convertToClTime(totalSecs)

	// print("CL secs: \(clSecs)")

	// now we're in CL time (secs since reference)
	// get the number of days since
	var days = Int(clSecs / 86400)
	var secs = clSecs % 86400
	// now substract the amount corresponding to the reference year
	days -= 126
	secs -= 15750
	// adjust here
	secs -= 14616
	if secs < 0 {
		// print("secs **are** < 0!")
		secs += 86400
		days -= 1
	}
	// make sure our secs aren't more than a day
	if secs > 86399 {
		secs -= 86400
		days += 1
	}
	// now we're referenced to the start of the year 591
	var clYear = 591
	while days > 359 {
		days -= 360
		clYear += 1
	}
	let clHours = Int( secs / 3600 )
	let clMin = Int((secs % 3600) / 60 )
	let clSec = Int((secs % 3600) % 60 )
	
	return (clYear, days, clHours, clMin, clSec)
}

//print(convertRLTime(2016, month: 8, day: 25, hour: 16, min: 25, sec: 0)) // expect (605, 147, 19, 56, 3)

/// This returns true if Daylight Saving Time is in effect
func isDST() -> Bool {
	let timeZone: CFTimeZone = CFTimeZoneCopyDefault()
	let time = CFAbsoluteTimeGetCurrent()
	let daylightSavingInEffect = CFTimeZoneIsDaylightSavingTime(timeZone, time)
	return daylightSavingInEffect
}

//print(isDST()) // result depends on local date and time!
 
/// This is the function to call to get the current CL time.
/// It is a function of the current time and takes DST into account.
func clTime() ->  (year: Int, dayOfYear: Int, hour: Int, min: Int, sec: Int) {
	let userCalendar = NSCalendar.currentCalendar()
	let requestedDateComponents: NSCalendarUnit = [.Year,
						       .Month,
						       .Day,
						       .Hour,
						       .Minute,
						       .Second]
	let today = NSDate()
	let date = userCalendar.components(requestedDateComponents,
					   fromDate: today)
//	print(date)

	return convertRLTime(date.year, month: date.month, day: date.day, hour: date.hour, min: date.minute, sec: date.second)
}

//print(clTime())

/// This is the main call for astronomical data. It computes CL time from
/// the user's local time and returns a formated string with the astro data
func astroDataNow() -> String {
	let time = clTime()
	return astroData(time.year, dayOfYear: time.dayOfYear)
}

//print(astroDataNow())

/// This returns a formated string with the current CL time (just the HH:MM:SS)
func clTimeNow() -> String {
	let time = clTime()
// Convert to AM/PM
	let americanTime = convertToAmPmTimeFormat(time.hour)
	let fillerM = time.min < 10 ? "0" : ""
	return "It is \(americanTime.hour):\(fillerM)\(time.min)\(americanTime.timeHalf)"
}

/// This returns a formated string with the current CL time (just the HH:MM:SS)
func clCurrentZodiac() -> String {
	let time = clTime()
	let const = constellationForDay(time.year, dayOfYear: time.dayOfYear)
	return constellation_short[const.constIndex] + " rises with the Sun today."
}

//print(clTimeNow())

/// This returns a formated string with all the current CL date and time
func clTimeNowFull() -> String {
	let time = clTime()
	let season = getSeason(time.dayOfYear)
	let day = time.dayOfYear - season * 90
// Convert to AM/PM
	let americanTime = convertToAmPmTimeFormat(time.hour)
	let fillerM = time.min < 10 ? "0" : ""
	return "It is \(americanTime.hour):\(fillerM)\(time.min)\(americanTime.timeHalf) on \(weekday_names[getDayOfWeek(time.year, dayOfYear: time.dayOfYear)]) day \(day) of \(seasonsNames[season]) \(time.year)."
}

//print(clTimeNowFull())

/// This will only be used to compute astronomical events in the near future
func convertFromClTime(year: Int, dayOfYear: Int, hour: Int, min: Int, sec: Int) -> (year: Int, month: Int, day: Int, hour: Int, min: Int, sec: Int) {
	let dateComponents = NSDateComponents()
	dateComponents.day = 26
	dateComponents.month = 1
	dateComponents.year = 2016
	dateComponents.hour = 22
	dateComponents.minute = 1
	dateComponents.second = 03
//    dateComponents.timeZone = NSTimeZone(name: "America/Montreal")
//    dateComponents.timeZone = timeZone

	let userCalendar = NSCalendar.currentCalendar()
	let refDay = userCalendar.dateFromComponents(dateComponents)!
//    print(refDay.description)

	let requestedDateComponents: NSCalendarUnit = [.Year,
												   .Month,
												   .Day,
												   .Hour,
												   .Minute,
												   .Second]
	var date = userCalendar.components(requestedDateComponents,
													  fromDate: refDay)
//    date.year
//    date.month
//    date.day
//    date.hour
//    date.minute
//    date.second

	// we start by working in CL secs for reference time
	// which will be 603/001@12h20:51
	var clSecs: Int64 = Int64(603) * g_secsInAYear
	clSecs += Int64(1) * g_secsInADay
	clSecs += Int64(12) * g_secsInAnHour
	clSecs += Int64(20) * g_secsInAMinute
	clSecs += Int64(51)
//    print("clSecs = \(clSecs)")
	// the we get the CL secs for the time we want
	var eventSecs: Int64 = Int64(year) * g_secsInAYear
	eventSecs += Int64(dayOfYear) * g_secsInADay
	eventSecs += Int64(hour) * g_secsInAnHour
	eventSecs += Int64(min) * g_secsInAMinute
	eventSecs += Int64(sec)
//    print("eventSecs = \(eventSecs)")
	// Now get the difference
	let deltaSecs = eventSecs - clSecs
//    print("deltaSecs = \(deltaSecs)")
	// Now convert that interval from CL time to RL time
	let rlSecs = convertToRlTime(deltaSecs)
//    print("rlSecs = \(rlSecs)")
	let futureDate = refDay.dateByAddingTimeInterval(rlSecs)
//    print(futureDate)
	date = userCalendar.components(requestedDateComponents,
								   fromDate: futureDate)
//    date.year
//    date.month
//    date.day
//    date.hour
//    date.minute
//    date.second

	return(date.year, date.month, date.day, date.hour, date.minute, date.second)
}

/// This computes the Real Life date and time of the next full moon
func nextFullMoonInRL() -> String {
	let time = clTime()
	var year = time.year
	let day = time.dayOfYear
	let daysToFullMoon = nextFullMoon(year, dayOfYear: day)
	var dayEvent = day + daysToFullMoon
	if dayEvent > 360 {
		dayEvent -= 360
		year += 1
	}
	var timeZone = ""
	if isDST() {
		timeZone = "[EDT]"
	} else {
		timeZone = "[EDT]"
	}
	// default to finding noon on that day (used for full moon)
	let event = convertFromClTime(year, dayOfYear: dayEvent, hour: 12, min: 0, sec: 0)
	// Convert to AM/PM
	let americanTime = convertToAmPmTimeFormat(event.hour)
	let whichMonth = monthName[event.month - 1]
	let fillerM = event.min < 10 ? "0" : ""
	var eventString = "The next FMOCR will be "
	eventString += "\(whichMonth) \(event.day) at \(americanTime.hour):\(fillerM)\(event.min)\(americanTime.timeHalf). " + timeZone
	return eventString
}

//print(nextFullMoonInRL())

func next2FullMoonInRL() -> String {
	let time = clTime()
	var year = time.year
	let day = time.dayOfYear
	let daysToFullMoon = nextFullMoon(year, dayOfYear: day)
	var dayEvent = day + daysToFullMoon
	if dayEvent > 360 {
		dayEvent -= 360
		year += 1
	}
	var timeZone = ""
	if isDST() {
		timeZone = "[EDT]"
	} else {
		timeZone = "[EST]"
	}
	// default to finding noon on that day (used for full moon)
	var event = convertFromClTime(year, dayOfYear: dayEvent, hour: 12, min: 0, sec: 0)
	var americanTime = convertToAmPmTimeFormat(event.hour)
	var whichMonth = monthName[event.month - 1]
	var fillerM = event.min < 10 ? "0" : ""
	var eventString = "The next FMOCR will be "
	eventString += "\(whichMonth) \(event.day) at \(americanTime.hour):\(fillerM)\(event.min)\(americanTime.timeHalf),"
//	eventString += "\(event.year)-\(event.month)-\(event.day) @ \(americanTime.hour):\(event.min):\(event.sec) \(americanTime.timeHalf),"
	// Now get the second next full moon which happens 28 days later
	dayEvent += 28
	if dayEvent > 360 {
		dayEvent -= 360
		year += 1
	}
	// default to finding noon on that day (used for full moon)
	event = convertFromClTime(year, dayOfYear: dayEvent, hour: 12, min: 0, sec: 0)
	americanTime = convertToAmPmTimeFormat(event.hour)
	whichMonth = monthName[event.month - 1]
	fillerM = event.min < 10 ? "0" : ""
	eventString += " and the following will be "
	eventString += "\(whichMonth) \(event.day) at \(americanTime.hour):\(fillerM)\(event.min)\(americanTime.timeHalf). " + timeZone 

	return eventString
}

//print(next2FullMoonInRL())

// Dayphase represent where in the day we are in relation to sunrise and sunset
enum DayPhase {
	case BeforeSunrise
	case BeforeSunset
	case AfterSunset
}

func dayPhase(dayOfYear: Int) -> DayPhase {
	let daylight = findDaylight(dayOfYear)  // returns the number of minutes in the day
	let now = clTime()                      // return a tuple with the year, doy, hr, min, sec
	let nowMinutes = now.hour * 60 + now.min + (now.sec > 0 ? 1 : 0)
	if nowMinutes < daylight.sunrise {
		return .BeforeSunrise
	} else if nowMinutes < daylight.sunset {
		return .BeforeSunset
	} else {
		return .AfterSunset
	}
}
	
func nextSunEvent() -> String {
	let now = clTime()                          // returns a tuple with the year, doy, hr, min, sec
	let dPhase = dayPhase(now.dayOfYear)        // returns which part of the day we're in at the moment
	let daylight = findDaylight(now.dayOfYear)  // returns the number of minutes in the day for sunrise and sunset
	var timeZone = ""
	if isDST() {
		timeZone = "[IRL, EDT]"
	} else {
		timeZone = "[IRL, EST]"
	}
	// depending on which part of the day we're in, find Real Life time of next event (sunrise or sunset)
	switch dPhase {
	case .BeforeSunrise:
		// the next event will be today's sunrise
		let timeOfSunrise = convertMinutesToHoursMinutes(daylight.sunrise)
		var hour = (timeOfSunrise.timeHalf == .am ? timeOfSunrise.hours : timeOfSunrise.hours + 12)
		var event = convertFromClTime(now.year, dayOfYear: now.dayOfYear, hour: hour, min: timeOfSunrise.minutes, sec: 0)
		var americanTime = convertToAmPmTimeFormat(event.hour)
		var fillerM = ( event.min < 10 ? "0" : "" )
		let message = "Sunrise is at \(americanTime.hour):\(fillerM)\(event.min)\(americanTime.timeHalf)"
		// Now following event will be today's sunset
		let timeOfSunset = convertMinutesToHoursMinutes(daylight.sunset)
		hour = (timeOfSunset.timeHalf == .am ? timeOfSunset.hours : timeOfSunset.hours + 12)
		event = convertFromClTime(now.year, dayOfYear: now.dayOfYear, hour: hour, min: timeOfSunset.minutes, sec: 0)
		americanTime = convertToAmPmTimeFormat(event.hour)
		fillerM = ( event.min < 10 ? "0" : "" )
		return message + " and sunset is at \(americanTime.hour):\(fillerM)\(event.min)\(americanTime.timeHalf) \(timeZone)"

	case .BeforeSunset:
		// the next event will be today's sunset
		let timeOfSunset = convertMinutesToHoursMinutes(daylight.sunset)
		var hour = (timeOfSunset.timeHalf == .am ? timeOfSunset.hours : timeOfSunset.hours + 12)
		var event = convertFromClTime(now.year, dayOfYear: now.dayOfYear, hour: hour, min: timeOfSunset.minutes, sec: 0)
		var americanTime = convertToAmPmTimeFormat(event.hour)
		var fillerM = ( event.min < 10 ? "0" : "" )
		let message = "Sunset is at \(americanTime.hour):\(fillerM)\(event.min)\(americanTime.timeHalf)"

		// the following event will be tomorrow's (CL time) sunrise
		// add one day, making sure we handle if we're changing year
		var day = now.dayOfYear + 1
		var year = now.year
		if day > 360 {
			day = 1
			year += 1
		}
		let daylightTomorrow = findDaylight(day)  // find sunrise tomorrow
		let timeOfSunrise = convertMinutesToHoursMinutes(daylightTomorrow.sunrise)
		hour = (timeOfSunrise.timeHalf == .am ? timeOfSunrise.hours : timeOfSunrise.hours + 12)
		event = convertFromClTime(year, dayOfYear: day, hour: hour, min: timeOfSunrise.minutes, sec: 0)
		americanTime = convertToAmPmTimeFormat(event.hour)
		fillerM = ( event.min < 10 ? "0" : "" )
		return message + " and sunrise (tomorrow) is at \(americanTime.hour):\(fillerM)\(event.min)\(americanTime.timeHalf) \(timeZone)"
	case .AfterSunset:
		// the next event will be tomorrow's (CL time) sunrise
		// add one day, making sure we handle if we're changing year
		var day = now.dayOfYear + 1
		var year = now.year
		if day > 360 {
			day = 1
			year += 1
		}
		let daylightTomorrow = findDaylight(day)  // find sunrise tomorrow
		let timeOfSunrise = convertMinutesToHoursMinutes(daylightTomorrow.sunrise)
		var hour = (timeOfSunrise.timeHalf == .am ? timeOfSunrise.hours : timeOfSunrise.hours + 12)
		var event = convertFromClTime(year, dayOfYear: day, hour: hour, min: timeOfSunrise.minutes, sec: 0)
		var americanTime = convertToAmPmTimeFormat(event.hour)
		var fillerM = ( event.min < 10 ? "0" : "" )
		let message = "Sunrise (next) is at \(americanTime.hour):\(fillerM)\(event.min)\(americanTime.timeHalf)"

		// the following event will be tomorrows's sunset
		let timeOfSunset = convertMinutesToHoursMinutes(daylightTomorrow.sunset)
		hour = (timeOfSunset.timeHalf == .am ? timeOfSunset.hours : timeOfSunset.hours + 12)
		event = convertFromClTime(year, dayOfYear: day, hour: hour, min: timeOfSunset.minutes, sec: 0)
		americanTime = convertToAmPmTimeFormat(event.hour)
		fillerM = ( event.min < 10 ? "0" : "" )
		return message + " and sunset is at \(americanTime.hour):\(fillerM)\(event.min)\(americanTime.timeHalf) \(timeZone)"
	}
}

var step = [[Int]]()

var steps = [Int]()

// Human/undisclosed series

steps = [ 0, 7, 4, 6, 1, 7, 2, 11, 8, 6, 5, 11 ]
step.append(steps)

// dwarf series

steps = [ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ]
step.append(steps)

// thoom series

steps = [ 0, 9, 5, 5, 9, 1, 1, 9, 8, 9, 5, 9 ]
step.append(steps)

// zo series

steps = [ 0, 4, 1, 9, 1, 4, 11, 4, 3, 10, 9, 1 ]
step.append(steps)

// fen series

steps = [ 0, 5, 8, 8, 11, 6, 9, 5, 3, 8, 3, 4 ]
step.append(steps)

// sylvan series

steps = [ 0, 11, 10, 8, 5, 9, 6, 1, 2, 4, 7, 3 ]
step.append(steps)

// halfling series

steps = [ 0, 8, 11, 11, 9, 10, 4, 5, 4, 9, 10, 7 ]
step.append(steps)

// starting zodiac sign (negative) offset by race
// races are: human, dwarf, thoom, zo, fen, sylvan, halfling

let start = [ 11, 11, 10, 7, 1, 0, 7 ] 

// This makes sure that a zodiac sign index is in the 0...11 range
// this assumes (as is the case in this maze solution) that the
// maximum added to an index is 11
func normaliseZodiacIndex(index: Int) -> Int {
	var nIndex = 0
	if index < 0 {
		nIndex = 12 + index
	} else if index > 11 {
		nIndex = index - 12
	} else {
		nIndex = index
	}
	return nIndex
}

// Melabrion's Zodiac maze has the following solution:
// Each of the 7 races has a different starting zodiac sign which depends on
// the current rising zodiac. Once this starting sign is found, each race
// steps through the other 11 signs in steps (dwarves do it in the normal sequence
// of rising zodiacs, other have more complicated steps patterns)
func sayMZMPath(race: String) -> String {
	let time = clTime()
	let const = constellationForDay(time.year, dayOfYear: time.dayOfYear).constIndex
	var raceIndex = 0 // default to human
	switch race {
		case "human":
			raceIndex = 0
		case "dwarf":
			raceIndex = 1
		case "thoom":
			raceIndex = 2
		case "zo":
			raceIndex = 3
		case "fen":
			raceIndex = 4
		case "sylvan":
			raceIndex = 5
		case "halfling":
			raceIndex = 6
		default: // all other races introduced after defaults to human sequence
			raceIndex = 0
	}
	var path = [Int]()
	// get the starting zodiac sign for that race's path
	path.append(normaliseZodiacIndex(const - start[raceIndex])) 
	// now complete the path
	for i in 1...11 {
		path.append(normaliseZodiacIndex(path[i-1] + step[raceIndex][i]))
	}
	var pathString = "Path for \(race) is: "
	for i in 0...11 {
		pathString += constellation_short[path[i]]
		if i < 11 {
			pathString += ", "
		} else {
			pathString += "."
		}
	}
	return pathString
}

var expension: String = "placeholder \(argument)"
switch argument {
	case "time":
		expension = clTimeNow()
	case "date":
		expension = clTimeNowFull()
	case "astro":
		expension = astroDataNow()
    case "moon":
    		expension = nextFullMoonInRL()
    case "2moon":
    		expension = next2FullMoonInRL()
	case "zodiac":
		expension = clCurrentZodiac()
	case "sun":
		expension = nextSunEvent()
	case "mzm_human":
		expension = sayMZMPath("human")
	case "mzm_dwarf":
		expension = sayMZMPath("dwarf")
	case "mzm_thoom":
		expension = sayMZMPath("thoom")
	case "mzm_zo":
		expension = sayMZMPath("zo")
	case "mzm_fen":
		expension = sayMZMPath("fen")
	case "mzm_sylvan":
		expension = sayMZMPath("sylvan")
	case "mzm_halfling":
		expension = sayMZMPath("halfling")
	default:
		expension = astroDataNow()
}

print(expension, terminator:"") // empty terminator suppresses newline
