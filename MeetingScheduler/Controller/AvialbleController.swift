//
//  AvialbleController.swift
//  MeetingScheduler
//
//  Created by manish on 01/08/21.
//

import UIKit

class AvialbleController: UIViewController {

    @IBOutlet weak var tblavilable: UITableView!
    var avilableSlot = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
// MARK: TableView datasources and delegates
extension AvialbleController: UITableViewDelegate,UITableViewDataSource {
    
    
    // returns the number of rows in tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return avilableSlot.count
        
    }
    
    // returns the cell to show in tableview on basis on orientation of phone
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tblavilable.dequeueReusableCell(withIdentifier:Constants.Indentifiers.availableCell, for: indexPath) as! availableCell
        cell.selectionStyle = .none
        cell.statTime.text = avilableSlot[indexPath.row]
        cell.endTime.text = avilableSlot[indexPath.row ]
        return cell
        
        
    }
    // returns the height of the each row in tableview
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
  
}



// MARK: - avialableCell for landscape View
class availableCell:UITableViewCell {
    
    @IBOutlet weak var statTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
}

