//
//  LevelViewController.swift
//  Memo ver.ios
//
//  Created by Ricardo Ortega on 4/23/24.
//

import UIKit

protocol LevelControllerDelegate: AnyObject {
    func didSelectLevel(_ level: String)
}

class LevelViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pvLevel: UIPickerView!
    
    weak var delegate: LevelControllerDelegate?
    
    let levelItems: Array<String> = ["low" , "medium", "high"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pvLevel.dataSource = self
        pvLevel.delegate = self
        
        // Do any additional setup after loading the view.
        let saveButton: UIBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save, target: self
            , action: #selector(saveLevel))
        
        self.navigationItem.rightBarButtonItem = saveButton
        self.title = "Pick Level"
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return levelItems.count
    }
    //Sets the value that is shwon for each row in the picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)
    -> String? {
        return levelItems[row]
    }
    //If the user chooses from the pickerView, it calls this functions instead
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Chosen item: \(levelItems[row])")
        
    }
    @objc func saveLevel() {
        let selectedRow = pvLevel.selectedRow(inComponent: 0)
        let selectedLevel = levelItems[selectedRow]
        
        // Save selected level to UserDefaults
        UserDefaults.standard.set(selectedLevel, forKey: "selectedLevel")
        
        // Notify delegate about the level change and update lblText
        delegate?.didSelectLevel(selectedLevel)
        
        // Optionally, you can dismiss the view controller after saving
        navigationController?.popViewController(animated: true)
    }

}
