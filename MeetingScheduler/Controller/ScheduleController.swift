//
//  ScheduleControllerViewController.swift
//  MeetingScheduler
//
//  Created by manish on 31/07/21.
//


import UIKit
/// this class used the scdeuleing the meet
class ScheduleController: UIViewController {
    // MARK: - @IBOUTLET
    
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtStartTime: UITextField!
    @IBOutlet weak var txtEndTime: UITextField!
    var timepicker = UIDatePicker()
    var timepicker2 = UIDatePicker()
    var ArrfromDetails = [meetingDetails]()
    var ArrpossibleSlot = [String]()
    // MARK: - view life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setUp()
        
    }
    
    func setUp() {
        txtDate.isUserInteractionEnabled = false
        
        // picker for the startTime
        timepicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        timepicker.addTarget(self, action: #selector(self.dateChanged), for: .allEvents)
        timepicker.datePickerMode = .time
        timepicker.preferredDatePickerStyle = .wheels
        txtStartTime.inputView = timepicker
        let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.datePickerDone))
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        txtStartTime.inputAccessoryView = toolBar
        
        // picker for the endTime
        timepicker2 = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        timepicker2.addTarget(self, action: #selector(self.dateChanged2), for: .allEvents)
        timepicker2.datePickerMode = .time
        timepicker2.preferredDatePickerStyle = .wheels
        txtEndTime.inputView = timepicker2
        let doneButton2 = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.datePickerDone2))
        let toolBar2 = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar2.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton2], animated: true)
        txtEndTime.inputAccessoryView = toolBar2
        ArrpossibleSlot = possibleSlot()
        
    }
    func date(withDay day: Int, hour: Int, minute: Int) -> Date {
        return DateComponents(calendar: Calendar.current, year: 2021, month: 8, day: day, hour: hour, minute: minute, second: 0).date!
    }
    
    func possibleSlot() -> [String] {
        var arrPossibleString = [String]()
        let openTime = date(withDay: 30, hour: 9, minute: 0)
        let closeTime = date(withDay: 30, hour: 17, minute: 0)
        let currentAppointments: [Date] = [
            date(withDay: 30, hour: 9, minute: 30),
            date(withDay: 30, hour: 11, minute: 60),
            date(withDay: 30, hour: 13, minute: 60),
            date(withDay: 30, hour: 14, minute: 30)
        ].sorted()
        let openMinutes = Calendar.current.dateComponents([.minute], from: openTime, to: closeTime).minute!
        // durtation of one appointment in minutes
        let appointmentLength = 30
        // minutes. change this to 30 if you only want to be able to schedule at :00 and :30
        let appointmentInterval = 30
        
        // create a list of all appointments that would be possible throughout the day, regardless of actual availability
        var possibleAppointments = stride(from: 0, to: openMinutes, by: appointmentInterval).compactMap { Calendar.current.date(byAdding: .minute, value: $0, to: openTime) }
        
        
        // check which of the theoretic timeslots aren't available and remove them from the list
        for possibleAppointmentStart in possibleAppointments {
            let possibleAppointmentEnd = Calendar.current.date(byAdding: .minute, value: appointmentLength, to: possibleAppointmentStart)!
            if possibleAppointmentEnd > closeTime {
                // if the appointment would end after closing time, it's obviously invalid
                if let appointmentIndex = possibleAppointments.firstIndex(of: possibleAppointmentStart) {
                    possibleAppointments.remove(at: appointmentIndex)
                    continue
                }
            }
            
            for existingAppointmentStart in currentAppointments {
                let existingAppointmentEnd = Calendar.current.date(byAdding: .minute, value: appointmentLength, to: existingAppointmentStart)!
                // a interval overlaps a second interval if
                // - the interval starts earlier then the second intervals ends. And
                // - the second interval starts earlier than the first interval ends
                if possibleAppointmentStart < existingAppointmentEnd && existingAppointmentStart < possibleAppointmentEnd {
                    if let appointmentIndex = possibleAppointments.firstIndex(of: possibleAppointmentStart) {
                        possibleAppointments.remove(at: appointmentIndex)
                        break
                    }
                }
            }
        }
        
        let df = DateFormatter()
        df.dateStyle = .none
        df.timeStyle = .short
        df.locale = Locale.current
        let appointmentStrings = possibleAppointments.map { df.string(from: $0) }
        arrPossibleString.append(contentsOf: appointmentStrings)
        print("Possible appointments: \(appointmentStrings.joined(separator: ", "))")
        return arrPossibleString
    }

    @objc func datePickerDone() {
        
        txtStartTime.resignFirstResponder()
        
    }
    @objc func datePickerDone2() {
        
        txtEndTime.resignFirstResponder()
    }
    
    @objc func dateChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        txtStartTime.text = dateFormatter.string(from: sender.date)
    }
    @objc func dateChanged2(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        txtEndTime.text = dateFormatter.string(from: sender.date)
    }
    
    
    // MARK: - @Actions
    @IBAction func btnback(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnSubmit(_ sender: Any) {
        
        if ArrpossibleSlot.count == 0 {
            let alert = UIAlertController(title: "Slot Avialability", message:"Sorry No slots available!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
                
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }else {
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          let vc = storyboard.instantiateViewController(identifier: Constants.Indentifiers.AvialbleController) as AvialbleController
          vc.avilableSlot = ArrpossibleSlot
          vc.modalPresentationStyle = .overCurrentContext
          self.present(vc, animated: true, completion: nil)
        }
        
    }
    
}



