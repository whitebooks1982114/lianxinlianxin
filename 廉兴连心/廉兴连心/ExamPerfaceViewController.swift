//
//  ExamPerfaceViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 17/3/4.
//  Copyright © 2017年 whitebooks. All rights reserved.
//

import UIKit

class ExamPerfaceViewController: UIViewController,UITextFieldDelegate {
    
    var isParty = false
    //识别试卷的标识
    var testid:Int!

    
    let detail = ExamDetailViewController()
    
    
    @IBOutlet weak var passlineTF: UITextField!
    @IBOutlet weak var titleTF: UITextField!
    
    @IBOutlet weak var scoreTF: UITextField!
    
    @IBOutlet weak var numTF: UITextField!
    
    @IBOutlet weak var partySW: UISwitch!
    
    @IBAction func isPartySW(_ sender: UISwitch) {
        if sender.isOn {
            isParty = true
        }else {
            isParty = false
        }
    }
    
    @IBAction func savebt(_ sender: UIButton) {
        if titleTF.text == "" || scoreTF.text == "" || numTF.text == "" || passlineTF.text == "" {
            let alert  = UIAlertController(title: "温馨提示", message: "标题内容不能为空", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }else{
            objectIDs.insert(testid, at: 0)
            let test = BmobObject(className: "tests")
            test?.setObject(self.titleTF.text, forKey: "title")
            test?.setObject(Int(self.scoreTF.text!), forKey: "score")
            test?.setObject(Int(self.numTF.text!), forKey: "questions")
            test?.setObject(Int(self.passlineTF.text!), forKey: "passline")
            test?.setObject(isParty, forKey: "isparty")
            test?.setObject(testid, forKey: "testid")
            test?.saveInBackground(resultBlock: { (success, error) in
                if success {
                    print("success")
                    self.detail.testid_detail = self.testid
                    self.detail.questionNum = Int(self.numTF.text!)
                    self.navigationController?.pushViewController(self.detail, animated: true)
                    
                    
                }else {
                    let alert  = UIAlertController(title: "提示", message: "保存失败", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            })
            
        }

    }
    
   
    
     override func viewDidLoad() {
        super.viewDidLoad()
        //时间戳
        let nowdate = Date()
        let timeInterval = nowdate.timeIntervalSince1970
        testid = Int(timeInterval)
        
        passlineTF.delegate = self
        titleTF.delegate = self
        scoreTF.delegate = self
        numTF.delegate = self
        partySW.isOn = false
        self.navigationItem.title = "编辑试题概要"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(self.goBack))
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func goBack() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleTF.resignFirstResponder()
        scoreTF.resignFirstResponder()
        numTF.resignFirstResponder()
        passlineTF.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTF.resignFirstResponder()
        scoreTF.resignFirstResponder()
        numTF.resignFirstResponder()
        passlineTF.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let frame: CGRect = passlineTF.frame
        
        let offset = frame.origin.y + 10 - (self.view.frame.size.height - 240)
        
        if offset > 0 {
            UIView.animate(withDuration: 0.8, animations: {
                self.view.frame = CGRect(x: 0, y: -offset, width: self.view.frame.size.width, height: self.view.frame.size.height)
            })
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
