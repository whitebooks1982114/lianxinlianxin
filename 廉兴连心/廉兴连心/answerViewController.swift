//
//  answerViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/10.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class answerViewController: UIViewController {
    
    @IBOutlet weak var answeraView: UIView!
  
    @IBOutlet weak var answerbView: UIView!
    
    @IBOutlet weak var answercView: UIView!
    
    @IBOutlet weak var answerdView: UIView!
    
    @IBOutlet weak var answeraLabel: UILabel!
    
    @IBOutlet weak var answerbLabel: UILabel!
    
    @IBOutlet weak var answercLable: UILabel!
    
    @IBOutlet weak var answerdLabel: UILabel!
    
    @IBOutlet weak var answeraImageView: UIImageView!
    
    @IBOutlet weak var answerbImageVeiw: UIImageView!
    
    @IBOutlet weak var answercImageView: UIImageView!
    
    @IBOutlet weak var answerdImageView: UIImageView!
    
    let levelResult = resultViewController()
    //记录已答过题目
    var answeredquestion:Int!
    //倒计时
    var countDownTime: Timer? = nil

    //倒计时
    var answerTime = 30
    //答对题目数字
    var rightans = 0
    //现在闯的关卡数
    var currentLevel:Int?
    
    //题目更新计时器
    var update: Timer? = nil
    //试卷识别号
    var testID:Int!
    //及格线
    var passline:Int!
    //用户名
    var username:String!
    //用户答题表查询的ID
    var myObjectID:String?
    
    var question:String!
    var answera:String!
    var answerb:String!
    var answerc:String!
    var answerd:String!
    var rightanswer:String!
    //每道题的正确答题数字代码
    var rightNum:Int!
    //题目总数
    var totalNum:Int!
   
    let myActivi = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    @IBOutlet weak var questionLable: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var btn1: UIButton!
    
    @IBOutlet weak var btn2: UIButton!
    
    @IBOutlet weak var btn3: UIButton!
    
    @IBOutlet weak var btn4: UIButton!
    
    let myStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    @IBAction func judge(_ sender: UIButton) {
        judgeAnswer(sender: sender)
    }
    //将ABCD转换成0123
    func changeAlphaToNum(Entry:String) -> Int {
        switch Entry {
        case "A":
            return 0
           
        case "B":
            return 1
           
        case "C":
            return 2
          
        default:
            return 3
         
        }
    }
   
    
    
    func queryQuestions(index:Int) {
        myActivi.startAnimating()
        
        
        let query = BmobQuery(className: "question")
        let query1 = BmobQuery(className: "question")
        let andQuery = BmobQuery(className: "question")
    
        query1?.whereKey("index", equalTo: index)
        query?.whereKey("testid", equalTo: testID)
        andQuery?.add(query)
        andQuery?.add(query1)
        andQuery?.andOperation()
        andQuery?.findObjectsInBackground({ (array, error) in
       
            if error != nil {
                let alert  = UIAlertController(title: "错误", message: "\(error?.localizedDescription)", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: {
                    (finish) -> Void in
                    _ = self.navigationController?.popToRootViewController(animated: true)
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }else{
                
                for obj in array! {
                    let object  = obj as! BmobObject
                    self.question = object.object(forKey: "questionlabel") as! String
                    self.answera = object.object(forKey: "answera") as! String
                    self.answerb = object.object(forKey: "answerb") as! String
                    self.answerc = object.object(forKey: "answerc") as! String
                    self.answerd = object.object(forKey: "answerd") as! String
                    self.rightanswer = object.object(forKey: "rightanswer") as! String
               
                }
                
            }
            DispatchQueue.main.async {
                self.questionLable.text = self.question
                self.answeraLabel.text = self.answera
                self.answerbLabel.text = self.answerb
                self.answercLable.text = self.answerc
                self.answerdLabel.text = self.answerd
                self.rightNum = self.changeAlphaToNum(Entry: self.rightanswer)
                self.myActivi.stopAnimating()
            }
        })
    }
    
    func judgeAnswer(sender: UIButton) {
  
        
        if sender.tag == rightNum{
            rightans += 1
            
        }else {
            switch sender.tag  {
            case 0:
                self.answeraImageView.image = #imageLiteral(resourceName: "wrong")
                break
                
            case 1:
                self.answerbImageVeiw.image = #imageLiteral(resourceName: "wrong")
                break
                
            case 2:
                self.answercImageView.image = #imageLiteral(resourceName: "wrong")
                break
                
            default:
                self.answerdImageView.image = #imageLiteral(resourceName: "wrong")
                break
                
            }

        }
        self.btn1.isEnabled = false
        self.btn2.isEnabled = false
        self.btn3.isEnabled = false
        self.btn4.isEnabled = false
        switch rightNum  {
        case 0:
            self.answeraImageView.image = #imageLiteral(resourceName: "rightbtn")
            break
          
        case 1:
            self.answerbImageVeiw.image = #imageLiteral(resourceName: "rightbtn")
            break
           
        case 2:
            self.answercImageView.image = #imageLiteral(resourceName: "rightbtn")
            break
          
        default:
            self.answerdImageView.image = #imageLiteral(resourceName: "rightbtn")
            break
          
        }
        answeredquestion = answeredquestion + 1

        
        //两秒钟后更新题目
        self.update?.invalidate()
        self.update = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.updateQuestion), userInfo: nil, repeats: false)
        
        
    }
    
    
    func updateQuestion() {
        if answeredquestion > totalNum - 1 {
            
            levelResult.rightresult = "\(self.rightans)"
            levelResult.wrongresult = "\(self.totalNum - self.rightans)"
            levelResult.testID_Result = self.testID
            levelResult.objectID_Result = self.myObjectID
            levelResult.rightanswers = rightans
            if rightans >= passline {
                levelResult.success = "恭喜你过关"
                levelResult.clear = true
                
            }else {
                levelResult.success = "很遗憾，您需要再努力"
                levelResult.clear = false
                
            }
            
            self.navigationController?.pushViewController(levelResult, animated: true)
        }

        self.question = ""
        self.answera = ""
        self.answerb = ""
        self.answerc = ""
        self.answerd = ""
        self.rightanswer = ""
        queryQuestions(index: answeredquestion)
        
        self.answeraImageView.image = #imageLiteral(resourceName: "defaultbtn")
        self.answerbImageVeiw.image = #imageLiteral(resourceName: "defaultbtn")
        self.answercImageView.image = #imageLiteral(resourceName: "defaultbtn")
        self.answerdImageView.image = #imageLiteral(resourceName: "defaultbtn")
        
      
        self.btn1.isEnabled = true
        self.btn2.isEnabled = true
        self.btn3.isEnabled = true
        self.btn4.isEnabled = true
     
        self.countDownTime?.invalidate()
        
        answerTime = 50
        countDownTime = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timeCount), userInfo: nil, repeats: true)
        
    }


    
    func timeCount() {
        
        let levelResult = resultViewController()
        answerTime -= 1
        if answerTime < 10 {
            timeLabel.text = "00:0\(answerTime)"
        }else {
            timeLabel.text = "00:\(answerTime)"
        }
        
        if answerTime <= 0 {
            self.countDownTime?.invalidate()
            let alert  = UIAlertController(title: "信息提示", message: "时间已到", preferredStyle: .alert)
            let ok = UIAlertAction(title: "答题结果", style: .default, handler: { (act) in
                
                levelResult.testID_Result = self.testID
                levelResult.objectID_Result = self.myObjectID
                levelResult.rightresult = "\(self.rightans)"
                levelResult.wrongresult = "\(self.totalNum - self.rightans)"
                levelResult.rightanswers = self.rightans
                if self.rightans >= self.passline {
                    
                    levelResult.success = "恭喜你过关"
                    levelResult.clear = true
                    
                }else {
                    
                    levelResult.success = "很遗憾，您需要再努力"
                    levelResult.clear = false
                    
                }

                
                self.navigationController?.pushViewController(levelResult, animated: true)
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "答题界面"
         self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "保存并返回", style: .plain, target: self, action: #selector(self.saveBack))
       
        username = BmobUser.current().username
        //文字大小自适应宽度
        answeraLabel.adjustsFontSizeToFitWidth = true
        answerbLabel.adjustsFontSizeToFitWidth = true
        answercLable.adjustsFontSizeToFitWidth = true
        answerdLabel.adjustsFontSizeToFitWidth = true
        
        //  自动换行
        questionLable.adjustsFontSizeToFitWidth = true
        questionLable.lineBreakMode = .byWordWrapping
        questionLable.numberOfLines = 0
        
        
        myActivi.frame.origin.x = UIScreen.main.bounds.width / 2
        myActivi.frame.origin.y = UIScreen.main.bounds.height / 2
        self.view.addSubview(myActivi)
        myActivi.startAnimating()
        myActivi.color = UIColor.red
        
        
     }
    
    func saveBack(){
        //保存答题记录到数据库
        if myObjectID != nil {
            let saveQuestion = BmobObject(outDataWithClassName: "usertestscore", objectId: myObjectID)
            saveQuestion?.setObject(answeredquestion, forKey: "answerednum")
            saveQuestion?.setObject(rightans, forKey: "right")
            saveQuestion?.setObject(false, forKey: "success")
            saveQuestion?.setObject(self.username, forKey: "name")
            saveQuestion?.setObject(self.testID, forKey: "testid")
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
            saveQuestion?.setObject(answeredquestion, forKey: "answerednum")
            saveQuestion?.setObject(rightans, forKey: "right")
            saveQuestion?.setObject(self.username, forKey: "name")
            saveQuestion?.setObject(false, forKey: "success")
            saveQuestion?.setObject(self.testID, forKey: "testid")
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
        
          self.present((self.myStoryboard.instantiateViewController(withIdentifier: "SWRevealViewController")), animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
   
        
        if answeredquestion >= totalNum {
            let alert  = UIAlertController(title: "温馨提示", message: "您已完成试卷，不可重复答题", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: {
                (_) in _ = self.navigationController?.popToRootViewController(animated: true)
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        }else {
      
       queryQuestions(index: answeredquestion)
        
        }

        answerTime = 50
        
        countDownTime = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timeCount), userInfo: nil, repeats: true)
        
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.countDownTime?.invalidate()
    }
  
}
