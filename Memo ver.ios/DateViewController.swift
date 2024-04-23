//
//  DateViewController.swift
//  Memo ver.ios
//
//  Created by Ricardo Ortega on 4/23/24.
//

import UIKit

protocol DateControllerDelegate: AnyObject {
    func dateChanged(date: Date)
}

class DateViewController: UIViewController {

    @IBOutlet weak var dtpDate: UIDatePicker!
    //Delegate may not always be set, so it's weak, and the type is optional (?)
    //opitional types are set to nil by default no need for init methods
    weak var delegate: DateControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton: UIBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save, target: self
            , action: #selector(saveDate))
        
        self.navigationItem.rightBarButtonItem = saveButton
        self.title = "Pick Date"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
//MARK: Save data
    
    @objc func saveDate() {
        self.delegate?.dateChanged(date: dtpDate.date)
        self.navigationController?.popViewController(animated: true)
    }
}
