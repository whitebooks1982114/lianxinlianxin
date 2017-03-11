//
//  ExamDetailViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 17/3/4.
//  Copyright © 2017年 whitebooks. All rights reserved.
//

import UIKit

class ExamDetailViewController: UIViewController ,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    let myStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    
    @IBOutlet weak var myPickerView: UIPickerView!
    var testid_detail:Int!
    var questionNum:Int!
    
    var answerArray:NSArray!
    
    var index:Int = 0
    
    @IBOutlet weak var questionTF: UITextField!
    
    @IBOutlet weak var answerATF: UITextField!

    @IBOutlet weak var answerBTF: UITextField!
    
 
    
    func saveQuestions(){
        if questionTF.text == "" || answerATF.text == "" || answerBTF.text == "" || answerCTF.text == "" ||
            answerDTF.text == "" || rightAnswerTF.text == "" {
            let alert  = UIAlertController(title: "温馨提示", message: "标题内容不能为空", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        }else {
            let question = BmobObject(className: "question")
            question?.setObject(self.questionTF.text, forKey: "questionlabel")
            question?.setObject(self.answerATF.text, forKey: "answera")
            question?.setObject(self.answerBTF.text, forKey: "answerb")
            question?.setObject(self.answerCTF.text, forKey: "answerc")
            question?.setObject(self.answerDTF.text, forKey: "answerd")
            question?.setObject(self.rightAnswerTF.text, forKey: "rightanswer")
            question?.setObject(self.index, forKey: "index")
            question?.setObject(self.testid_detail, forKey: "testid")
            question?.saveInBackground(resultBlock: { (success, error) in
                if success {
                    print("success")
                    
                    
                    
                }else {
                    let alert  = UIAlertController(title: "提示", message: "保存失败", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                DispatchQueue.main.async {
                    self.questionTF.text = ""
                    self.answerATF.text = ""
                    self.answerBTF.text = ""
                    self.answerCTF.text = ""
                    self.answerDTF.text = ""
                    self.rightAnswerTF.text = ""
                    self.index += 1
                }
                
            })
            
            
        }
        
    }
    
    @IBAction func nextQuestion(_ sender: UITapGestureRecognizer) {
        if index + 1 <= questionNum {
        saveQuestions()
        }else {
            let alert  = UIAlertController(title: "提示", message: "题目编写数量已满，请点击完成按钮完成出题", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBOutlet weak var answerCTF: UITextField!
    
    @IBOutlet weak var answerDTF: UITextField!
    
    @IBOutlet weak var rightAnswerTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionTF.delegate = self
        answerATF.delegate = self
        answerBTF.delegate = self
        answerCTF.delegate = self
        answerDTF.delegate = self
        rightAnswerTF.delegate = self
        rightAnswerTF.inputView = myPickerView
        myPickerView.delegate = self
        myPickerView.dataSource = self
        
        myPickerView.removeFromSuperview()
        
        self.navigationItem.title = "编辑试题"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(self.goBack))
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(self.complete))
        
        let path = Bundle.main.path(forResource: "answers", ofType: "plist")
        answerArray = NSArray(contentsOfFile: path!)
        

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        questionTF.resignFirstResponder()
        answerDTF.resignFirstResponder()
        answerCTF.resignFirstResponder()
        answerBTF.resignFirstResponder()
        answerATF.resignFirstResponder()
        rightAnswerTF.endEditing(true)
        rightAnswerTF.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        questionTF.resignFirstResponder()
        answerDTF.resignFirstResponder()
        answerCTF.resignFirstResponder()
        answerBTF.resignFirstResponder()
        answerATF.resignFirstResponder()
        rightAnswerTF.endEditing(true)
        rightAnswerTF.resignFirstResponder()
        return true
    }
    
    func complete() {
      
        if index + 1 < questionNum {
            let alert  = UIAlertController(title: "提示", message: "请继续上传试题", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }else if index + 1 > questionNum{
            let alert  = UIAlertController(title: "提示", message: "出题已完成，将返回首页", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: {
                (ok) in
               self.present((self.myStoryboard.instantiateViewController(withIdentifier: "SWRevealViewController")), animated: true, completion: nil)
                
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        }else {
        saveQuestions()
        index = 0
       _ = self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func goBack() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return answerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return answerArray[row] as? String
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rightAnswerTF.text = answerArray[row] as? String
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let frame: CGRect = answerDTF.frame
        
        let offset = frame.origin.y + 100 - (self.view.frame.size.height - 240)
        
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
