//
//  giftsViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 17/2/25.
//  Copyright © 2017年 whitebooks. All rights reserved.
//

import UIKit
import Kingfisher

var userNeedScore = 0

class giftsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,cellbuttonclick{

    @IBOutlet weak var shopList: UITableView!
    
    @IBOutlet weak var totalScore: UILabel!
    
    let myActivi = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
  
    var user:BmobUser?
    var namelist = [String]()
    var imagelist = [URL]()
    var scorelist = [Int]()
    var totallist = [Int]()
    //用户可兑换总积分
    var exscore = 0
    //用户订单商品名称数组
    var orderNameList = [String]()
    //用户订单商品数量数组
    var orderNumList = [String]()
    
    
    let myStoryboard = UIStoryboard(name: "Main", bundle: nil)
   
    
    
   //兑换按钮
   
    @IBAction func exchange(_ sender: UIButton) {
        if user == nil {
            let alart = UIAlertController(title: "温馨提示", message: "请先登录！", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alart.addAction(ok)
            self.present(alart, animated: true, completion: nil)
        }else if userNeedScore > exscore {
            let alart = UIAlertController(title: "温馨提示", message: "积分不够", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alart.addAction(ok)
            self.present(alart, animated: true, completion: nil)
        }else {
            let batch = BmobObjectsBatch()
            for i in 0..<orderNumList.count {
                //由于cell初始化时把orderNumlist数组元素都设置为0，使数组size与cell数目相等，防止跳空点击cell时出现数组越界错误
                if self.orderNumList[i] != "0" {
                batch.saveBmobObject(withClassName: "exchange", parameters:["username": (self.user?.username!)! as String,"quantity":self.orderNumList[i],"giftname":self.orderNameList[i]]
                )
                }
            }
            batch.batchObjectsInBackground(resultBlock: { (success, error) in
                if error != nil {
                    let alart = UIAlertController(title: "错误提示", message: "订单发送失败", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                    alart.addAction(ok)
                    self.present(alart, animated: true, completion: nil)
                }
                
            })
            let alart = UIAlertController(title: "温馨提示", message: "本次兑换将扣减\(String(userNeedScore))可兑换积分", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default,handler:{(ok)->Void in
                self.user?.setObject(self.exscore - userNeedScore,forKey:"exscore")
                self.user?.updateInBackground(resultBlock: { (success, error) in
                    if error != nil {
                        print("\(error?.localizedDescription)")
                    }
                })
            self.present((self.myStoryboard.instantiateViewController(withIdentifier: "SWRevealViewController")), animated: true, completion: nil)
            
            })
            alart.addAction(ok)
            self.present(alart, animated: true, completion: nil)
            
        }
        
    }
    
    func query(){
        myActivi.startAnimating()
        self.totallist.removeAll()
        self.scorelist.removeAll()
        self.namelist.removeAll()
        self.imagelist.removeAll()
        let query1 = BmobQuery(className: "gifts")
        query1?.findObjectsInBackground({ (array,error) in
            if array != nil {
                for obj in array! {
                    let object  = obj as! BmobObject
                    let name = object.object(forKey: "name") as! String
                    let score = object.object(forKey: "score") as! Int
                    let totle = object.object(forKey: "total") as! Int
                    let imageFile = object.object(forKey: "image") as! BmobFile
                    let imageurl = NSURL(string: imageFile.url) as! URL
                    
                    self.namelist.append(name)
                    self.scorelist.append(score)
                    self.totallist.append(totle)
                    self.imagelist.append(imageurl)
                    
                    
                }
                
            }else {
                let alart = UIAlertController(title: "错误提示", message: "查询失败！", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                alart.addAction(ok)
                self.present(alart, animated: true, completion: nil)
            }
            
            DispatchQueue.main.async {
                self.shopList.reloadData()
                self.shopList.layoutIfNeeded()
                self.myActivi.stopAnimating()
                
            }
        })
        
        
        
        
        
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
         shopList.dataSource = self
        shopList.delegate = self
        
        self.navigationItem.title = "积分商城"
        
        user = BmobUser.current()
        if user != nil {
        exscore = user?.object(forKey: "exscore") as! Int
        }
        
        self.totalScore.adjustsFontSizeToFitWidth = true
        self.totalScore.lineBreakMode = .byWordWrapping
        self.totalScore.numberOfLines = 0
        self.totalScore.text = "您的可兑换积分总数为\(exscore),本次兑换所需积分\(userNeedScore)"

        shoppingcellTableViewCell.delegate = self
        
        
        myActivi.frame.origin.x = UIScreen.main.bounds.width / 2
        myActivi.frame.origin.y = UIScreen.main.bounds.height / 2
        self.view.addSubview(myActivi)
        myActivi.startAnimating()
        myActivi.color = UIColor.red
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.orderNameList.removeAll()
        self.orderNumList.removeAll()
        query()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.namelist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mycell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath) as! shoppingcellTableViewCell
        mycell.shopname.text = self.namelist[indexPath.row]
        mycell.shopimage.kf.setImage(with: ImageResource.init(downloadURL: self.imagelist[indexPath.row]), placeholder: UIImage(named:"默认图片"), options: nil, progressBlock: nil, completionHandler: nil)
        let cellscore = self.scorelist[indexPath.row]
        let celltotal = self.totallist[indexPath.row]
        mycell.perScore = cellscore
        mycell.number = celltotal
        
        mycell.selectionStyle = .none
        
        mycell.shopscore.text = "商品剩余\(String(celltotal)),商品所需积分\(String(cellscore))"
        //由于两个数组初建立时时空数组，防止数组越界
        self.orderNumList.insert("0", at: indexPath.row)
        self.orderNameList.insert("0", at: indexPath.row)
        
        return mycell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let mycell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath) as! shoppingcellTableViewCell
        
        return mycell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
   
    //点击cell中的button更新totalScore label值
    func cellForRowButtonClicked(tableview: UITableView) {
       self.totalScore.text = "您的可兑换积分总数为\(exscore),本次兑换所需积分\(userNeedScore)"
    }
    
    func getCellLabelContent(tableview: UITableView, cellIndexPath cellindexPath: IndexPath) {
        let mycell = tableview.cellForRow(at: cellindexPath) as! shoppingcellTableViewCell
        let shopName = mycell.shopname.text
        let orderNum = mycell.quantity.text!
       
       
//        orderNameList.insert(shopName!, at: cellindexPath.row)
//        orderNumList.insert(orderNum, at: cellindexPath.row)
        
        orderNameList[cellindexPath.row]  = shopName!
        orderNumList[cellindexPath.row] = orderNum
        
        
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
