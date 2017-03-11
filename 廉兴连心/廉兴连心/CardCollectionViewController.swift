//
//  CardCollectionViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 17/2/26.
//  Copyright © 2017年 whitebooks. All rights reserved.
//
import UIKit

class CardCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var usrmenu: UIBarButtonItem!
    var currentUserName:String?
    //题目数组
    var titleList = [String]()
    //题目积分
    var scoreList = [Int]()
    //是否是党员测试
    var isPartyList = [Bool]()
    //题目总数
    var questionsList = [Int]()
    //已答题list
    var answeredList = [Int]()
    
    //过关list
    var successList = [Bool]()
   
    //及格线数组
    var passLineList = [Int]()
    //usertestscore表的testid
    var user_testid = [Int]()
    //现在用户
    var user:BmobUser?
    
    let detail = answerViewController()
   
    let  myActivi = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    var  numLabel:UILabel!
    
    //添加试卷
    @IBAction func addquestion(_ sender: UIBarButtonItem) {
        let user = BmobUser.current()
        if user != nil {
        let isAdmin = user?.object(forKey: "isadmin") as! Bool
        if isAdmin {
            self.navigationController?.pushViewController(ExamPerfaceViewController(), animated: true)
            
        }else {
            let alert  = UIAlertController(title: "温馨提示", message: "对不起，您无权出题", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        }else {
            let alert  = UIAlertController(title: "温馨提示", message: "对不起，您无权出题", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func queryUserScore(){
        user_testid.removeAll()
        successList.removeAll()
        answeredList.removeAll()
        if user != nil {
           
                let myquery = BmobQuery(className: "usertestscore")
                myquery?.order(byAscending: "testid")
                myquery?.whereKey("name", equalTo: currentUserName)
                myquery?.findObjectsInBackground({ (array, error) in
                    if error != nil {
                        print("\(error?.localizedDescription)")
                    }else {
                        for obj in array! {
                            let object = obj as! BmobObject
                            let id = object.object(forKey: "testid") as! Int
                            let sucess = object.object(forKey: "success") as! Bool
                            let answeredNum = object.object(forKey: "answerednum") as! Int
                            self.successList.append(sucess)
                            self.answeredList.append(answeredNum)
                            self.user_testid.append(id)
                        }
                    }
                    DispatchQueue.main.async {
                      
                       
                        self.collectionView?.reloadData()
                        self.collectionView?.layoutIfNeeded()
                        self.myActivi.stopAnimating()
                        
                    }
                    
                })
        
        
           }
      }

     func query(){
        self.passLineList.removeAll()
        self.titleList.removeAll()
        self.scoreList.removeAll()
        self.isPartyList.removeAll()
        self.questionsList.removeAll()
    
        
        let query1 = BmobQuery(className: "tests")
        query1?.order(byAscending: "testid")
        query1?.findObjectsInBackground({ (array, error) in
            if error != nil {
                let alert  = UIAlertController(title: "温馨提示", message: "错误\(error?.localizedDescription)", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }else if (array?.count)! > 0 {
                for obj in array! {
                    let object = obj as! BmobObject
                    let title = object.object(forKey: "title") as! String
                    let score = object.object(forKey: "score") as! Int
                    let isParty = object.object(forKey: "isparty") as! Bool
                    let pass = object.object(forKey: "passline") as! Int
                    let questions = object.object(forKey: "questions") as! Int
                    self.titleList.append(title)
                    self.scoreList.append(score)
                    self.isPartyList.append(isParty)
                    self.questionsList.append(questions)
                    self.passLineList.append(pass)
                   
                    
                }
            }else {
                print("题目为空")
            }
            DispatchQueue.main.async {
                
                self.collectionView?.reloadData()
                self.collectionView?.layoutIfNeeded()
                self.myActivi.stopAnimating()
              
            }
            
        })
        
        
    }
    
    
    
    /// The pan gesture will be used for this scroll view so the collection view can page items smaller than it's width
    lazy var pagingScrollView: UIScrollView = { [unowned self] in
        let scrollView = UIScrollView()
        scrollView.isHidden = true
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.bounces = true
        return scrollView
        }()
    

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = 310
            self.revealViewController().toggleAnimationDuration = 0.5
            
            
            self.usrmenu.target = self.revealViewController()
            
            self.usrmenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
        }
        
        // inset collection view left/right-most cards can be centered
        let flowLayout = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        let edgePadding = (self.collectionView!.bounds.size.width - flowLayout.itemSize.width)/2
        self.collectionView!.contentInset = UIEdgeInsets(top: 0, left: edgePadding, bottom: 0, right: edgePadding)
        

        self.collectionView?.backgroundView = UIImageView(image: UIImage(named:"通知背景"))
        
        // Register cell classes
        let cardNib = UINib(nibName: "CardCellCollectionViewCell", bundle: Bundle.main)
        self.collectionView!.register(cardNib, forCellWithReuseIdentifier: "cellid")
        
        // add scroll view which we'll hijack scrolling from
        let scrollViewFrame = CGRect(
            x: self.view.bounds.width,
            y: 0,
            width: flowLayout.itemSize.width,
            height: self.view.bounds.height)
        pagingScrollView.frame = scrollViewFrame
        pagingScrollView.contentSize = CGSize(width: flowLayout.itemSize.width*8, height: self.view.bounds.height)
        self.collectionView!.superview!.insertSubview(pagingScrollView, belowSubview: self.collectionView!)
        self.collectionView!.addGestureRecognizer(pagingScrollView.panGestureRecognizer)
        self.collectionView!.isScrollEnabled = false
        numLabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.width / 2 - 10.0, y: UIScreen.main.bounds.height - 80.0, width: 100.0, height: 30.0))
        
        numLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        self.view.addSubview(numLabel)
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         user = BmobUser.current()
        if user != nil {
           
            currentUserName = BmobUser.current().username
        }
        query()
        queryUserScore()
       
        myActivi.frame.origin.x = UIScreen.main.bounds.width / 2
        myActivi.frame.origin.y = UIScreen.main.bounds.height / 2
        self.view.addSubview(myActivi)
        myActivi.startAnimating()
        myActivi.color = UIColor.red
        
       
        
     
    }
    
  
    
    // MARK: - Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


// MARK: - Collection View Delegate

extension CardCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
   
        let user = BmobUser.current()
        if user != nil {
        let userName = user?.username
        let userisParty = user?.object(forKey: "party") as! Bool
            if isPartyList[indexPath.row - 1] {
                if userisParty {
                    detail.testID = objectIDs[indexPath.row - 1]
                    detail.passline = self.passLineList[indexPath.row - 1]
                    detail.totalNum = self.questionsList[indexPath.row - 1]
                    //查询答题记录
                    let query = BmobQuery(className: "usertestscore")
                    let query1 = BmobQuery(className: "usertestscore")
                    let mainQuery = BmobQuery(className: "usertestscore")
                    query?.whereKey("name", equalTo: userName)
                    query1?.whereKey("testid", equalTo: objectIDs[indexPath.row - 1])
                    mainQuery?.add(query)
                    mainQuery?.add(query1)
                    mainQuery?.andOperation()
                    
                    mainQuery?.findObjectsInBackground({ (array, error) in
                        if error != nil {
                            let alert  = UIAlertController(title: "温馨提示", message: "未查到答题记录", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                            alert.addAction(ok)
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            
                            if (array?.count)! > 0 {
                                print(1)
                                for obj in array! {
                                    let object = obj as! BmobObject
                                    let answeredNum = object.object(forKey: "answerednum") as! Int
                                    let rigthNum = object.object(forKey: "right") as! Int
                                    self.detail.myObjectID = object.objectId
                                    self.detail.answeredquestion = answeredNum
                                    self.detail.rightans = rigthNum
                                    
                                }
                                
                                self.navigationController?.pushViewController(self.detail, animated: true)
                            }else {
                                print("aaaa")
                                self.detail.answeredquestion = 0
                                self.detail.rightans = 0
                                self.navigationController?.pushViewController(self.detail, animated: true)
                            }
                        }
                    })

            }else {
                let alert  = UIAlertController(title: "温馨提示", message: "此试卷为党员试卷", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }else {
        
      
        detail.testID = objectIDs[indexPath.row - 1]
        detail.passline = self.passLineList[indexPath.row - 1]
        detail.totalNum = self.questionsList[indexPath.row - 1]
            //查询答题记录
            let query = BmobQuery(className: "usertestscore")
            let query1 = BmobQuery(className: "usertestscore")
            let mainQuery = BmobQuery(className: "usertestscore")
            query?.whereKey("name", equalTo: userName)
            query1?.whereKey("testid", equalTo: objectIDs[indexPath.row - 1])
            mainQuery?.add(query)
            mainQuery?.add(query1)
            mainQuery?.andOperation()
           
            mainQuery?.findObjectsInBackground({ (array, error) in
                if error != nil {
                    let alert  = UIAlertController(title: "温馨提示", message: "未查到答题记录", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }else if (array?.count)! > 0 {
                    
                    for obj in array! {
                        let object = obj as! BmobObject
                        let answeredNum = object.object(forKey: "answerednum") as! Int
                        let rigthNum = object.object(forKey: "right") as! Int
                        self.detail.myObjectID = object.objectId
                        self.detail.answeredquestion = answeredNum
                        self.detail.rightans = rigthNum
                    
                    }
                    
                    self.navigationController?.pushViewController(self.detail, animated: true)
                }else {
                  
                    self.detail.answeredquestion = 0
                    self.detail.rightans = 0
                    self.navigationController?.pushViewController(self.detail, animated: true)
                }
            })
        
        }
        }else{
            let alert  = UIAlertController(title: "温馨提示", message: "对不起，您未登录", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
}


// MARK: - Collection View Datasource

extension CardCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titleList.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! CardCellCollectionViewCell
        
    
        if indexPath.row == 0 {
            cell.testLevels.text = "欢迎您来参加知识测试"
            cell.testScore.isHidden = true
            cell.testTitle.isHidden = true
            cell.testLevels.textColor = UIColor.red
            cell.testLevels.font = UIFont.boldSystemFont(ofSize: 30.0)
            cell.myContentView.layer.backgroundColor = UIColor.cyan.cgColor
            cell.isUserInteractionEnabled = false
        }else {
            cell.testTitle.text = titleList[indexPath.row - 1]
            cell.testScore.text = "积分为\(String(scoreList[indexPath.row - 1]))分"
            cell.testLevels.text = "未查询到做题记录,共\(String(questionsList[indexPath.row - 1]))题"
            if self.user_testid.count > 0 {
                for i in 0..<self.user_testid.count{
                    if self.user_testid[i] == objectIDs[indexPath.row - 1] {
                        if successList[i] == true {
                            cell.testLevels.text = "恭喜您已过关"
                        }else {
                            cell.testLevels.text = "您已答\(String(answeredList[i]))题，共\(String(questionsList[indexPath.row - 1]))题"
                        }
                    }
                }
            }
            
            if isPartyList[indexPath.row - 1]{
                cell.partyImage.isHidden = false
                
            }else {
                cell.partyImage.isHidden = true
            }
            
            if scoreList[indexPath.row - 1] >= 100 {
                cell.myContentView.layer.backgroundColor = UIColor.red.cgColor
            }else if scoreList[indexPath.row - 1] >= 50 {
             cell.myContentView.layer.backgroundColor = UIColor.magenta.cgColor
            }else if scoreList[indexPath.row - 1] >= 30 {
             cell.myContentView.layer.backgroundColor = UIColor.orange.cgColor
            }else {
             cell.myContentView.layer.backgroundColor = UIColor.yellow.cgColor
            }
        }
        
        //随机生成卡片颜色
       // cell.myContentView.layer.backgroundColor = UIColor(red: CGFloat(Float((arc4random() % 255)) / 255.0), green: CGFloat(Float((arc4random() % 255)) / 255.0), blue: CGFloat(Float((arc4random() % 255)) / 255.0), alpha: 1.0).cgColor
            
            
            
            
        return cell
    }
    //滑动COLLECTON LABEL 文字发生变化
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pinPoint:CGPoint = self.view.convert((self.collectionView?.center)!, to: self.collectionView)
        let myindexPath:IndexPath = (self.collectionView?.indexPathForItem(at: pinPoint))!
       
        
         numLabel.text = "\(myindexPath.row)/\(titleList.count)"
        
        
        
    }
}


// MARK: - Scroll Delegate

extension CardCollectionViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === pagingScrollView {
            // adjust collection view scroll view to match paging scroll view
            let contentOffset = CGPoint(x: scrollView.contentOffset.x - self.collectionView!.contentInset.left,
                                        y: self.collectionView!.contentOffset.y)
            self.collectionView!.contentOffset = contentOffset
         
        }
        //防止scrollView过度滑动,每个ITEM宽度250
        if Double(scrollView.contentOffset.x) > Double(titleList.count * 250) {
            scrollView.contentOffset.x = CGFloat(titleList.count * 250)
        }
    }
}


