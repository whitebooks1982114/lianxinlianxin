//
//  settingsViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/30.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class settingsViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
  
    
    @IBOutlet weak var noticeSwitch: UISwitch!
    
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    @IBAction func noticeVoiceSwitch(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "noticevoice")
            UserDefaults.standard.set( 1, forKey: "noticetimes")
            
        }else {
            
            UserDefaults.standard.set(false, forKey: "noticevoice")
             UserDefaults.standard.set( 1, forKey: "noticetimes")
        }
    }
    
    @IBAction func alarmVoiceSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "alarmvoice")
            UserDefaults.standard.set( 1, forKey: "alarmtimes")
            
        }else {
            
            UserDefaults.standard.set(false, forKey: "alarmvoice")
             UserDefaults.standard.set( 1, forKey: "alarmtimes")

        }

    }
    
    @IBOutlet weak var myToolBar: UIToolbar!
    
    var settingdays: Float?
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        UIView.animate(withDuration: 0.5, animations:{
            self.myTextField.endEditing(true)
           
            UserDefaults.standard.set(self.myTextField.text, forKey: "daysstring")
            UserDefaults.standard.set(self.settingdays, forKey: "days")
            self.myTextField.resignFirstResponder()
            
        }
      
        )
        
        
    }
    
    @IBOutlet weak var myPickeView: UIPickerView!
    
    @IBOutlet weak var myTextField: UITextField!
    
    
    @IBOutlet weak var adminLabel: UILabel!
    
    @IBOutlet weak var adminTextField: UITextField!
    
    var daysArray: NSArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "alarmdays", ofType: "plist")
        daysArray = NSArray(contentsOfFile: path!)
        
        myPickeView.delegate = self
        myPickeView.dataSource = self
        myTextField.delegate = self
        adminTextField.delegate = self
        
        myToolBar.removeFromSuperview()
        myPickeView.removeFromSuperview()
        
        myTextField.inputView = myPickeView
        myTextField.inputAccessoryView = myToolBar
        
        let settedDays = Int(UserDefaults.standard.float(forKey: "days"))
        self.myTextField.text = "提前\(settedDays)天"
     }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.5, animations: {
            let adminDays = Int(self.adminTextField.text!)
            UserDefaults.standard.set(adminDays, forKey: "adminSettingDays")
            self.myTextField.resignFirstResponder()
            self.adminTextField.resignFirstResponder()
        
        })
    }
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let adminDays = Int(self.adminTextField.text!)
        UserDefaults.standard.set(adminDays, forKey: "adminSettingDays")
        self.adminTextField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let currentNoticeSwitch = UserDefaults.standard.bool(forKey: "noticevoice")
        let currentAlarmSwitch = UserDefaults.standard.bool(forKey: "alarmvoice")
        myTextField.text = UserDefaults.standard.string(forKey: "daysstring")
        adminTextField.text = "\(UserDefaults.standard.integer(forKey: "adminSettingDays"))天"
        
        if currentNoticeSwitch == false {
            noticeSwitch.isOn = false
        }else {
            noticeSwitch.isOn = true
        }
        
        if currentAlarmSwitch == false {
            alarmSwitch.isOn = false
        }else {
            alarmSwitch.isOn = true
        }
        let user = BmobUser.current()
        let isAdmin = user?.object(forKey: "isadmin") as? Bool
        if isAdmin == true {
            self.adminTextField.isHidden = false
            self.adminLabel.isHidden = false
            
        }else {
            
            self.adminLabel.isHidden = true
            self.adminTextField.isHidden = true
        }
        
        
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (daysArray?.count)!
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return daysArray?[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        myTextField.text = daysArray?[row] as? String
        settingdays = Float(row) + 1.0
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     }
    

}
