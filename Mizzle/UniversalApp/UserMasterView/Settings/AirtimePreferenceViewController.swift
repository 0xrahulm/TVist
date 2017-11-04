//
//  AirtimePreferenceViewController.swift
//  TVist
//
//  Created by Rahul Meena on 23/09/17.
//  Copyright © 2017 Ardour Labs. All rights reserved.
//

import UIKit

class AirtimePreferenceViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let kRangeOffset:Float = 6
    let kTimeOffset: Int = 23
    
    var saveBarButtonItem:UIBarButtonItem!
    @IBOutlet weak var selectedRangeOptionLabel: UILabel!
    var preference: UserPreferenceKey!
    
    
    @IBOutlet weak var startPicker: UIPickerView!
    @IBOutlet weak var endPicker: UIPickerView!
    
    var selectedStartValue: String?
    var selectedEndValue: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startPicker.dataSource = self
        endPicker.dataSource = self
        
        let airtimePreference = UserPreferenceVader.shared.getAirtimePreference()
        
        self.selectedStartValue = airtimePreference[0]
        self.selectedEndValue = airtimePreference[1]
        
        saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(AirtimePreferenceViewController.saveButtonTapped(_:)))
        
        updateViews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationItem.setRightBarButton(saveBarButtonItem, animated: true)
        
        if let startValue = self.selectedStartValue, let endValue = self.selectedEndValue {
            
            self.startPicker.selectRow(timeValueForString(string: startValue), inComponent: 0, animated: false)
            self.endPicker.selectRow(timeValueForString(string: endValue), inComponent: 0, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func timeValueForString(string: String) -> Int {
        var stringArr = string.components(separatedBy: " ")
        
        var returnVal:Int = 0
        if stringArr[0] == "12" {
            returnVal = 0
        } else {
            if let integer = Int(stringArr[0]) {
             
                returnVal = integer
            }
        }
        
        if stringArr[1] == "pm" {
            returnVal = returnVal+12
        }
        
        return returnVal
    }
    
    func stringForTimeValue(value: Int) -> String {
        
        if value > 11 {
            let pValue = value - 12
            if pValue == 0 {
                return "12 pm"
            } else {
                return "\(pValue) pm"
            }
        } else {
            if value == 0 {
                return "12 am"
            } else {
                return "\(value) am"
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 24
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stringForTimeValue(value: row)
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.startPicker == pickerView {
            self.selectedStartValue = stringForTimeValue(value: row)
        }
        
        if self.endPicker == pickerView {
            if let startValString = self.selectedStartValue {
             
                let startValue = timeValueForString(string: startValString)
                
                if row == startValue {
                    self.endPicker.selectRow(startValue+1, inComponent: 0, animated: true)
                } else {
                    
                    self.selectedEndValue = stringForTimeValue(value: row)
                }
            }
        }
        updateViews()
    }
    
    func updateViews() {
        if let startValue = self.selectedStartValue, let endValue = self.selectedEndValue {
            self.selectedRangeOptionLabel.text = "\(startValue) - \(endValue)"
        }
        determineSaveButtonFate()
    }
    
    func determineSaveButtonFate() {
        
        let airtimePreference = UserPreferenceVader.shared.getAirtimePreference()
        
        self.saveBarButtonItem.isEnabled = ((self.selectedEndValue != airtimePreference[1]) || (self.selectedStartValue != airtimePreference[0]))
    }
    
    
    @objc func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        if let startValue = self.selectedStartValue, let endValue = self.selectedEndValue {
            UserDataProvider.sharedDataProvider.setPreferenceFor(key: preference, value: [startValue, endValue])
            
            self.navigationController?.popViewController(animated: true)
            
            if let title = UserPreferenceVader.shared.valueStringForPreference(preference: self.preference), let selectionTitle = self.title {
                ScreenVader.sharedVader.makeToast(toastStr: "\(selectionTitle): \(title)")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
