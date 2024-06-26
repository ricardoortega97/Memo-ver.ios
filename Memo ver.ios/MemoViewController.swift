//
//  MemoViewController.swift
//  Memo ver.ios
//
//  Created by Ricardo Ortega on 4/22/24.
//

import UIKit
import CoreData

class MemoViewController: UIViewController, UITextFieldDelegate, DateControllerDelegate, UITextViewDelegate, LevelControllerDelegate {
    
    var currentMemo: Memo?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    

    @IBOutlet weak var sgmtEditMode: UISegmentedControl!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtContent: UITextView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblLevel: UILabel!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var btnPick: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       //populating the UI
        if currentMemo != nil{
            txtTitle.text = currentMemo!.title
            txtContent.text = currentMemo!.content
            lblLevel.text = currentMemo!.cruciality
            
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            if currentMemo!.date != nil {
                lblDate.text = formatter.string(from: currentMemo!.date!)
            }
        }
        
        self.changeEditMode(self)
        
       //Listeners
        let textFields: [UITextField] = [txtTitle]
        let _: [UITextView] = [txtContent]
        
        for textField in textFields {
            textField.addTarget(self, action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)), for: UIControl.Event.editingDidEnd)
        }
        txtContent.delegate = self
       
    }
    //implemention of saving date
    func dateChanged(date: Date) {
        if currentMemo == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentMemo = Memo(context: context)
        }
        currentMemo?.date = date
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        lblDate.text = formatter.string(from: date)
    }
    
    func didSelectLevel(_ selectedLevel: String) {
        print("Level changed to: \(selectedLevel)") // Check if this prints the correct level
        
        if currentMemo == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentMemo = Memo(context: context)
        }
        currentMemo?.cruciality = selectedLevel
        lblLevel.text = selectedLevel
        print("lblLevel text set to: \(lblLevel.text ?? "nil")") // Check if lblLevel text is set correctly
        
        }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: - Edting
    @IBAction func changeEditMode(_ sender: Any) {
        let textFields: [UITextField] = [txtTitle]
        let textViews: [UITextView] = [txtContent]
        
        if sgmtEditMode.selectedSegmentIndex == 0 {
            for textField in textFields {
                textField.isEnabled = false
                textField.borderStyle = UITextField.BorderStyle.none
            }
            for textView in textViews {
                textView.isEditable = false
                textView.borderStyle = UITextView.BorderStyle.none
            }
            
            btnChange.isHidden = true
            btnPick.isHidden = true
            
            navigationItem.rightBarButtonItem = nil
        }
        else if sgmtEditMode.selectedSegmentIndex == 1 {
            for textField in textFields {
                textField.isEnabled = true
                textField.borderStyle = UITextField.BorderStyle.roundedRect
            }
            for textView in textViews {
                textView.isEditable = true
                            }
            btnChange.isHidden = false
            btnPick.isHidden = false
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self,
                                                                action: #selector(self.saveMemo))
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if currentMemo == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentMemo = Memo(context: context)
        }
        currentMemo?.title = txtTitle.text
        return true
    }
    //Content View
    func textViewDidChange(_ textView: UITextView) {
        if currentMemo == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentMemo = Memo(context: context)
        }
        currentMemo?.content = txtContent.text
        
        appDelegate.saveContext()
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if(segue.identifier == "segueMemoDate") {
            let dateController = segue.destination as! DateViewController
            dateController.delegate = self
        } 
        //This was the issue that did not grabed the picked tag id
        else if segue.identifier == "segueMemoPick" {
            let levelController = segue.destination as! LevelViewController
            levelController.delegate = self
        }
        // Pass the selected object to the new view controller.
    }
    //MARK: Saving data
    @objc func saveMemo() {
        appDelegate.saveContext()
        sgmtEditMode.selectedSegmentIndex = 0
        changeEditMode(self)
    }
}
