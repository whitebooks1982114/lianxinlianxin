//
//  resultViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/11.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class resultViewController: UIViewController {
    
    @IBOutlet weak var rightNum: UILabel!
    
    @IBOutlet weak var wrongNum: UILabel!
    
    @IBOutlet weak var result:UILabel!
    
    @IBOutlet weak var totalNum: UILabel!
    
    
    var rightresult:String = ""
    var wrongresult:String = ""
    var success: String = ""
    var questionsNum:Int!
    //试题ID
    var testID_Result:Int!
    //OBJECTID
    var objectID_Result:String!
    //是否过关
    var clear:Bool!
    //答对题目数
    var rightanswers:Int!
    
    let usr = BmobUser.current()
    let myActivi = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "答题结果"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(self.goBack))
        self.result.adjustsFontSizeToFitWidth = true
        
        myActivi.frame.origin.x = UIScreen.main.bounds.width / 2
        myActivi.frame.origin.y = UIScreen.main.bounds.height / 2
        self.view.addSubview(myActivi)
        myActivi.startAnimating()
        myActivi.color = UIColor.red
    }
    
    func goBack() {
        let userName = usr?.username
        //保存答题记录到数据库
        if objectID_Result != nil {
            let saveQuestion = BmobObject(outDataWithClassName: "usertestscore", objectId: objectID_Result)
            saveQuestion?.setObject(questionsNum, forKey: "answerednum")
            saveQuestion?.setObject(rightanswers, forKey: "right")
            saveQuestion?.setObject(clear, forKey: "success")
            saveQuestion?.setObject(userName, forKey: "name")
            saveQuestion?.setObject(testID_Result, forKey: "testid")
            saveQuestion?.updateInBackground(resultBlock: { (success, error) in
                if success {
                    print("success")
                    
                }else {
                    let alert  = UIAlertController(title: "提示", message: "保存失败", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                
            })
        }else {
            let saveQuestion = BmobObject(className: "usertestscore")
            saveQuestion?.setObject(questionsNum, forKey: "answerednum")
            saveQuestion?.setObject(rightanswers, forKey: "right")
            saveQuestion?.setObject(clear, forKey: "success")
            saveQuestion?.setObject(userName, forKey: "name")
            saveQuestion?.setObject(testID_Result, forKey: "testid")
            saveQuestion?.saveInBackground(resultBlock: { (success, error) in
                if success {
                    print("success")
                    
                }else {
                    let alert  = UIAlertController(title: "提示", message: "保存失败", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            })
        }

        
       _ = navigationController?.popToRootViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.myActivi.startAnimating()
        let query = BmobQuery(className: "tests")
        query?.whereKey("testid", equalTo: self.testID_Result)
        query?.findObjectsInBackground({ (array, error) in
            if error != nil {
                let alert  = UIAlertController(title: "错误", message: "\(error?.localizedDescription)", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }else{
                
                for obj in array! {
                    let object  = obj as! BmobObject
                    self.questionsNum = object.object(forKey: "questions") as! Int
                    
                   
                    
                }
                
            }
            DispatchQueue.main.async {
             self.totalNum.text = "\(String(self.questionsNum))"
             self.myActivi.stopAnimating()
            }

        })
        
        
        self.rightNum.text = rightresult
        self.wrongNum.text = wrongresult
        self.result.text = success
        if success == "恭喜你过关了" {
            self.result.textColor = UIColor.red
        }else if success == "很遗憾，您需要再努力" {
            self.result.textColor = UIColor.green
        }else {
            self.result.textColor = UIColor.orange
            self.result.isHighlighted = true
        }
        
      
        
       

    }
    
}
