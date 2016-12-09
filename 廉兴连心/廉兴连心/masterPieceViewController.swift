//
//  masterPieceViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/12/3.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class masterPieceViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var myCollection: UICollectionView!
    @IBOutlet weak var usrmenu: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = 310
            self.revealViewController().toggleAnimationDuration = 0.5
            
            
            self.usrmenu.target = self.revealViewController()
            
            self.usrmenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        myCollection.backgroundView = UIImageView(image: UIImage(named: "作品背景"))
        
        myCollection.delegate = self
        myCollection.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if section == 0{
        return 2
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! myCellCollectionViewCell
        
        if indexPath.section == 0 {
            myCell.myImage.image = UIImage(named: "封面")
            if indexPath.row == 0 {
                myCell.myLabel.text = "书画作品"
            }else {
                myCell.myLabel.text = "摄影作品"
            }
        }else {
            myCell.myImage.image = UIImage(named: "绘画1")
            if indexPath.row == 0 {
                myCell.myLabel.text = "绘画作品"
            }
        }
    
               
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "myhead", for: indexPath) as! myHeadCollectionReusableView
        
        if indexPath.section == 0{
            header.myHeadTitle.text = "同兴筑梦"
            
        }else if indexPath.section == 1 {
            header.myHeadTitle.text = "亲子共绘"
            
        }
        
        header.backgroundColor = UIColor.clear
        header.myHeadTitle.textColor = UIColor.darkText
        
        
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let pageDetail = self.storyboard?.instantiateViewController(withIdentifier: "pageDetail") as! pageDetailViewController
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                
                pageDetail.selectedActivity = "dream"
                //给作品板块加载本地封面，为网络加载预留时间
                
                 pageDetail.perface = "封面"
                pageDetail.navigationItem.title = "同兴筑梦--书画"
                pageDetail.lastOne = 4
                
                self.navigationController?.pushViewController(pageDetail, animated: true)
                
                
            }else {
                 pageDetail.selectedActivity = "dreampicture"
                    //给作品板块加载本地封面，为网络加载预留时间
                
                  pageDetail.perface = "封面"
                 pageDetail.navigationItem.title = "同兴筑梦--摄影"
                 pageDetail.lastOne = 0
                self.navigationController?.pushViewController(pageDetail, animated: true)

        }
        
            
        }else if indexPath.section == 1 {
         pageDetail.selectedActivity = "familypaint"
                //给作品板块加载本地封面，为网络加载预留时间
           
            pageDetail.perface = "绘画1"
            pageDetail.navigationItem.title = "亲子共绘"
             pageDetail.lastOne = 14
            self.navigationController?.pushViewController(pageDetail, animated: true)

        }
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
