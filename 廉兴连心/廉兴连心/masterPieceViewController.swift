//
//  masterPieceViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/12/3.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit
import Kingfisher

class masterPieceViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var myCollection: UICollectionView!
   
    //节标题
    var activitys = [String]()
   //创建字典，KEY为节标题，值为单元标题数组
    var myDic = [String:Array<String>]()
    var perfaces = [URL]()
    //单元标题
    var titles = [String]()
    //该数组从字典的Key 生成
    var sectionNames = [String]()
    
    func query(){
        self.myDic.removeAll()
        let queryItems = BmobQuery(className: "works")
        queryItems?.whereKey("index", equalTo: 0)
        //此句重要，一定按活动排序，否则按自己写的方法生成的字典有误
        queryItems?.order(byAscending: "activity")
        queryItems?.findObjectsInBackground({ (array, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
            }else{
                if array == nil {
                    print("查询结果为空")
                }else {
                    for obj in array! {
                        let object = obj as! BmobObject
                        let activity = object.object(forKey: "activity") as! String
                        let title = object.object(forKey: "title") as! String
                        let files = object.object(forKey: "works") as!BmobFile
                        let fileUrl = NSURL(string: files.url) as! URL
                        self.activitys.append(activity)
                        
                        self.titles.append(title)
           
                        self.perfaces.append(fileUrl)
                  
                    }
                    
                  
                }
            }
            DispatchQueue.main.async {
               
                //用于记录节标题重复元素
                 var v = 0
                //用于确定元素标题数组中不同元素开始的下标
                 var k = 0
                //临时数组用于存放元素标题数组中不同的元素
                 var tempArray = [String]()
                for i in 0..<self.activitys.count {
                    if i + 1 != self.activitys.count {
                        if self.activitys[i] == self.activitys[i + 1]{
                            //如何元素相等则V加1
                            v += 1
                        }else{
                            v = 0
                            //当不相等时开始拼接tempArray数组
                            for j in k...i {
                               tempArray.append(self.titles[j])
                            }
                            self.myDic[self.activitys[i]] = tempArray
                            k = i + 1
                            tempArray.removeAll()
                        }
                    }else{
                        for j in k...self.activitys.count - 1 {
                            tempArray.append(self.titles[j])
                        }
                        self.myDic[self.activitys[self.activitys.count - 1]] = tempArray
                        tempArray.removeAll()
                    }
                    
                }
                
                self.sectionNames = [String](self.myDic.keys)
                self.sectionNames.sort()
                for i in 0..<self.sectionNames.count{
                    print(self.sectionNames[i])
                }
                for i in 0..<self.activitys.count{
                    print(self.activitys[i])
                }
                for (key, value) in self.myDic{
                    print(key,value)
                }
                self.myCollection.reloadData()
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       query()
        myCollection.backgroundView = UIImageView(image: UIImage(named: "作品背景"))
        
        myCollection.delegate = self
        myCollection.dataSource = self
        
       
       
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.myDic.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let itemsArray = self.myDic[sectionNames[section]]! as Array<String>
        return itemsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! myCellCollectionViewCell
        

        let itemsArray = self.myDic[sectionNames[indexPath.section]]! as Array<String>
        //动态设置每列的item数量，根据前一个section的item数
        var columNum = 0
        //判断section是否是0，防止itemsArraybefore 数组越界
        if indexPath.section > 0 {
        let itemsArraybefor = self.myDic[sectionNames[indexPath.section - 1]]! as Array<String>
            
            columNum = itemsArraybefor.count
            
        }
        myCell.myLabel.text = itemsArray[indexPath.row]
         myCell.myImage.kf.setImage(with: ImageResource.init(downloadURL: self.perfaces[indexPath.section * columNum + indexPath.row]), placeholder: UIImage(named:"默认图片"), options: nil, progressBlock: nil, completionHandler: nil)
     
               
      return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "myhead", for: indexPath) as! myHeadCollectionReusableView
        
        
        header.myHeadTitle.text = sectionNames[indexPath.section]
        
        header.backgroundColor = UIColor.clear
        header.myHeadTitle.textColor = UIColor.darkText
        
        
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let pageDetail = self.storyboard?.instantiateViewController(withIdentifier: "pageDetail") as! pageDetailViewController
          let itemsArray = self.myDic[sectionNames[indexPath.section]]! as Array<String>
                
                pageDetail.selectedActivity = itemsArray[indexPath.row]
                //给作品板块加载本地封面，为网络加载预留时间
                
                pageDetail.navigationItem.title = "作品展示详情"
                 
                self.navigationController?.pushViewController(pageDetail, animated: true)
                
                
          
    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
