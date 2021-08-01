//
//  ViewController.swift
//  MeetingScheduler
//
//  Created by manish on 30/07/21.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    // MARK: - @IBOUTLET
    @IBOutlet weak var tblmeeting: UITableView!
    @IBOutlet weak var lblDateSelection: UILabel!
    var arrMeetingDetails = [meetingDetails]()
    var sortedArrDetails = [meetingDetails]()
    var datepick = UIDatePicker()
    var textField : UITextField!
    var appendnewDate:String = ""
    var arrpartcipants = [String]()
    var arrGetCoreData = [CoreMeet]()
   
    
    // MARK: - View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUp()
        
    }
    // function to setup the UI on the first load.
    func setUp() {
        
        
        // for the initail when the user opens the app,it will show the data for current day
        let dateformator = DateFormatter()
        dateformator.dateStyle = .medium
        dateformator.timeStyle = .none
        dateformator.dateFormat = "dd-MM-yyy"
        lblDateSelection.text = dateformator.string(from: Date())
        
        // checking for current day is sunday
        let df =  DateFormatter()
        df.dateFormat = "EEE"
        let currentday = df.string(from: Date()).capitalized
        if currentday == "Sun" {
            let nextnewday = Utility.sharedInstance.nextday(currentDate: Date())
            self.callDataFromApi(appendData:Utility.sharedInstance.datetostring(input: nextnewday as Date))
            appendnewDate = Utility.sharedInstance.datetostring(input: nextnewday as Date)
        }
        
        appendnewDate = Utility.sharedInstance.convertslashtohypanformat(input: lblDateSelection.text ?? "")
        lblDateSelection.text = appendnewDate
        self.callDataFromApi(appendData: appendnewDate)
        
        
        // user can tap on the date label and change the selected date
        let tap = UITapGestureRecognizer(target: self , action:#selector(createDatePicker))
        tap.numberOfTapsRequired = 1
        lblDateSelection.isUserInteractionEnabled = true
        lblDateSelection.addGestureRecognizer(tap)
        
        //registering the cells to the tableview
        self.tblmeeting.register(UINib(nibName: "meetCell", bundle: nil), forCellReuseIdentifier:Constants.Indentifiers.meetingcell)
        self.tblmeeting.register(UINib(nibName: Constants.Indentifiers.landscapeCell, bundle: nil), forCellReuseIdentifier:Constants.Indentifiers.landscapeCell)
        
        //getting data from coreData
        arrGetCoreData = DatabaseHelper.sharedInstance.getData()

       
        
    }
    
    
    // this is the function to select the date to fetch the particular day data
    @objc func createDatePicker() {
        datepick.datePickerMode = .date
        datepick.preferredDatePickerStyle = .wheels
        if  textField == nil {
            self.textField = UITextField(frame:.zero)
            textField.inputView = self.datepick
            self.view.addSubview(textField)
            let toolbar = UIToolbar();
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action:       #selector(donepressed));
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:       #selector(cancelDatePicker));
            toolbar.setItems([doneButton,spaceButton,cancelButton], animated:       false)
            textField.inputAccessoryView = toolbar
            textField.inputView = datepick
            
        }
        textField.becomeFirstResponder()
    }
    
    // fuction when the datepicker done with the selection of the date from picker
    @objc func donepressed() {
        let dateformator = DateFormatter()
        dateformator.dateStyle = .medium
        dateformator.timeStyle = .none
        dateformator.dateFormat = "dd-MM-yyyy"
        lblDateSelection.text = dateformator.string(from: datepick.date)
        appendnewDate = Utility.sharedInstance.convertslashtohypanformat(input: lblDateSelection.text ?? "")
        self.callDataFromApi(appendData: appendnewDate)
        textField.resignFirstResponder()
        
    }
    @objc func cancelDatePicker() {
        textField.resignFirstResponder()
        
    }
    
    // MARK: General Methods
    // function call to get the data
    func callDataFromApi (appendData:String)
    {
        

        lblDateSelection.text  = Utility.sharedInstance.convertslashtohypanformat(input: appendData)
        self.startAnimating()
        let session = URLSession.shared
        let serviceUrl = URL(string:Constants.Urls.ServiceUrl + appendData)
        session.dataTask(with: serviceUrl!) { (responseData, responseCode, error) in
            if (error == nil && responseData != nil)
            {
                //parse the response data here
                let decoder = JSONDecoder()
                DispatchQueue.main.async {
                    do {
                        self.stopAnimating()
                        let result = try decoder.decode([meetingDetails].self, from: responseData!)
                        self.arrMeetingDetails = result
                        // sorting of the data on the basis of start time
                        self.sortedArrDetails =  self.arrMeetingDetails.sorted { (lhs, rhs) -> Bool in
                            let lhsdate = Utility.sharedInstance.stringtosortingdate(input: lhs.startTime)
                            let rhsdate = Utility.sharedInstance.stringtosortingdate(input: rhs.startTime)
                            return lhsdate! < rhsdate!
                        }
                        self.tblmeeting.reloadData()
                    } catch let error {
                        self.stopAnimating()
                        debugPrint("error occured while decoding = \(error.localizedDescription)")
                    }
                }
                
            }
            
        }.resume()
        
    }

    // MARK: - @Actions
    @IBAction func btnScheduleMeet(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: Constants.Indentifiers.ScheduleController) as ScheduleController
        vc.ArrfromDetails = sortedArrDetails
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    // on press of this button user will the next day schedule data
    @IBAction func btnNext(_ sender: Any) {
        if let convertdate = Utility.sharedInstance.stringtoDate(input: appendnewDate) {
            let nextnewday = Utility.sharedInstance.nextday(currentDate: convertdate)
            self.callDataFromApi(appendData:Utility.sharedInstance.datetostring(input: nextnewday as Date))
            appendnewDate = Utility.sharedInstance.datetostring(input: nextnewday as Date)
        }
        saveingdata()
    }
    // on press of this button user will the previous day schedule data
    @IBAction func btnPrev(_ sender: Any) {
        
        guard let convertdate = Utility.sharedInstance.stringtoDate(input: appendnewDate) else { return  }
        let prevday  = Utility.sharedInstance.previousday(currentDate: convertdate)
        self.callDataFromApi(appendData:Utility.sharedInstance.datetostring(input:prevday as Date))
        appendnewDate = Utility.sharedInstance.datetostring(input: prevday as Date)
        
    }
    
    // this is called when the orientataion of the screen takes place
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.tblmeeting.reloadData()
    }
    
    // function too save the data in coredata
    func saveingdata() {
        var dict = [meetingDetails]()
        for items in sortedArrDetails {
            dict.append(items)
        }
        DatabaseHelper.sharedInstance.saveData(object:dict)
    }
    
}

// MARK: TableView datasources and delegates
extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    
    // returns the number of rows in tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedArrDetails.count
        
    }
    
    // returns the cell to show in tableview on basis on orientation of phone
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if UIDevice.current.orientation  == .landscapeLeft || UIDevice.current.orientation == .landscapeRight{
            
            let cell = tblmeeting.dequeueReusableCell(withIdentifier:Constants.Indentifiers.landscapeCell, for: indexPath) as! landscapeCell
            cell.selectionStyle = .none
            cell.lblTitle.text = sortedArrDetails[indexPath.row].welcomeDescription
            cell.startTime.text =  Utility.sharedInstance.convert24hrs12(input:sortedArrDetails[indexPath.row].startTime)
            cell.endTime.text =  Utility.sharedInstance.convert24hrs12(input:sortedArrDetails[indexPath.row].endTime)
            arrpartcipants  = sortedArrDetails[indexPath.row].participants
            let formatter = ListFormatter()
            if let string = formatter.string(from: arrpartcipants) {
                cell.lblNames.text = string
            }
            return cell
            
        } else  {
            let cell = tblmeeting.dequeueReusableCell(withIdentifier: Constants.Indentifiers.meetingcell, for: indexPath) as! meetingcell
            cell.selectionStyle = .none
            cell.lblDescription.text = sortedArrDetails[indexPath.row].welcomeDescription
            cell.startTime.text = Utility.sharedInstance.convert24hrs12(input:sortedArrDetails[indexPath.row].startTime)
            cell.endTime.text =  Utility.sharedInstance.convert24hrs12(input:sortedArrDetails[indexPath.row].endTime)
            return cell
            
        }
        
    }
    // returns the height of the each row in tableview
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constants.rowHeight.regularRow)
    }
  
}
// MARK: - meetingcell for protait View
class meetingcell:UITableViewCell {
    
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
}
// MARK: - landscapeCell for landscape View
class landscapeCell:UITableViewCell {
    @IBOutlet weak var startTime:UILabel!
    @IBOutlet weak var endTime:UILabel!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblNames:UILabel!
}



