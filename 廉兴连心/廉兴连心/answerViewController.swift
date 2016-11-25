//
//  answerViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/10.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class answerViewController: UIViewController {
    
  
    //计算每一关答过的题目，若果过四关就跳转至结果界面
    var answeredquestion = 0
    //倒计时
    var countDownTime: Timer? = nil

    //当前题目数
    var currentQuestion:Int?
    //倒计时
    var answerTime = 30
    //答对题目数字
    var rightans = 0
    //现在闯的关卡数
    var currentLevel:Int?
    
    //题目更新计时器
    var update: Timer? = nil
    
   
    
   
    
    let path = Bundle.main.path(forResource: "题库", ofType: "plist")

    @IBOutlet weak var tickImage1: UIImageView!
    
    @IBOutlet weak var tickImage2: UIImageView!
    
    @IBOutlet weak var tickImage3: UIImageView!
    
    @IBOutlet weak var tickImage4: UIImageView!
    
    @IBOutlet weak var questionLable: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var btn1: UIButton!
    
    @IBOutlet weak var btn2: UIButton!
    
    @IBOutlet weak var btn3: UIButton!
    
    @IBOutlet weak var btn4: UIButton!
    
    
    @IBAction func judge(_ sender: UIButton) {
        judgeAnswer(sender: sender)
    }
    
    
    func judgeAnswer(sender: UIButton) {
        let questionArray = NSArray(contentsOfFile: path!)
        let question = questionArray?[currentQuestion!] as! NSArray
        if sender.tag == question[5] as! Int{
            rightans += 1
            
        }
        self.btn1.isEnabled = false
        self.btn2.isEnabled = false
        self.btn3.isEnabled = false
        self.btn4.isEnabled = false
        switch question[5] as! Int {
        case 1:
            tickImage1.isHidden = false
        case 2:
            tickImage2.isHidden = false
        case 3:
            tickImage3.isHidden = false
        default:
            tickImage4.isHidden = false
        }
        answeredquestion += 1
        //一秒钟后更新题目
        self.update?.invalidate()
        self.update = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateQuestion), userInfo: nil, repeats: false)
        
        
    }
    
    
    func updateQuestion() {
      
        let levelResult = resultViewController()
        let questionArray = NSArray(contentsOfFile: path!)
        if currentQuestion! < 89 {
            currentQuestion! += 1
 
        }else {
            currentQuestion = 89
        }
        let question = questionArray?[currentQuestion!] as! NSArray
        
        questionLable.text = question[0] as? String
        btn1.setTitle(question[1] as? String, for: .normal)
        btn2.setTitle(question[2] as? String, for: .normal)
        btn3.setTitle(question[3] as? String, for: .normal)
        btn4.setTitle(question[4] as? String, for: .normal)
        
        self.btn1.isEnabled = true
        self.btn2.isEnabled = true
        self.btn3.isEnabled = true
        self.btn4.isEnabled = true
        self.tickImage1.isHidden = true
        self.tickImage2.isHidden = true
        self.tickImage3.isHidden = true
        self.tickImage4.isHidden = true
        self.countDownTime?.invalidate()
        
        answerTime = 30
        countDownTime = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timeCount), userInfo: nil, repeats: true)
        
        if answeredquestion > 9 {
            answeredquestion = 0
            
           levelResult.rightresult = "\(self.rightans)"
           levelResult.wrongresult = "\(10 - self.rightans)"
            
            if rightans == 10 {
               levelResult.success = "恭喜你过关了"
               levelResult.clearedLevel = self.currentLevel!
           
                
            }else {
                
               levelResult.success = "很遗憾，您需要再努力"
                levelResult.clearedLevel = self.currentLevel! - 1
            }
            
            if rightans == 10 {
                if self.currentLevel! < 9 {
                   allLevels[currentLevel!] = 1
                   write()
            
                    
                } else if self.currentLevel == 9 {
                    levelResult.success = "恭喜你闯关成功"
                    levelResult.clearedLevel = self.currentLevel!
                }
            }
            
            self.navigationController?.pushViewController(levelResult, animated: true)
        }
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
                
                
                levelResult.rightresult = "\(self.rightans)"
                levelResult.wrongresult = "\(10 - self.rightans)"
                if self.rightans == 10 {
                    if self.currentLevel! < 9 {
                        allLevels[self.currentLevel!] = 1
                        write()
                        levelResult.success = "恭喜你过关了"
                        levelResult.clearedLevel = self.currentLevel!
                        
                        
                    } else if self.currentLevel == 9 {
                        levelResult.clearedLevel = self.currentLevel!
                        
                    }
            
                }else  {
                    levelResult.success = "很遗憾，您需要再努力"
                    levelResult.clearedLevel = self.currentLevel! - 1
                    
                } //未达到过关要求
                
                self.navigationController?.pushViewController(levelResult, animated: true)
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "答题界面"
        tickImage1.isHidden = true
        tickImage2.isHidden = true
        tickImage3.isHidden = true
        tickImage4.isHidden = true
        
        btn1.contentHorizontalAlignment = .left
        btn2.contentHorizontalAlignment = .left
        btn3.contentHorizontalAlignment = .left
        btn4.contentHorizontalAlignment = .left
        //文字大小自适应宽度
        btn1.titleLabel?.adjustsFontSizeToFitWidth = true
         btn2.titleLabel?.adjustsFontSizeToFitWidth = true
         btn3.titleLabel?.adjustsFontSizeToFitWidth = true
         btn4.titleLabel?.adjustsFontSizeToFitWidth = true
        
        //  自动换行
        questionLable.lineBreakMode = .byWordWrapping
        questionLable.numberOfLines = 0
        
    

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let questionArray = NSArray(contentsOfFile: path!)
        let question = questionArray?[currentQuestion!] as! NSArray
        
        questionLable.text = question[0] as? String
        btn1.setTitle(question[1] as? String, for: .normal)
        btn2.setTitle(question[2] as? String, for: .normal)
        btn3.setTitle(question[3] as? String, for: .normal)
        btn4.setTitle(question[4] as? String, for: .normal)
        rightans = 0

        answerTime = 30
        
        countDownTime = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timeCount), userInfo: nil, repeats: true)
        
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.countDownTime?.invalidate()
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
