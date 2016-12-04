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
        return 3
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! myCellCollectionViewCell
        
        
        myCell.myImage.image = UIImage(named: "摄影作品")
        if indexPath.section == 0 {
            myCell.myImage.image = UIImage(named: "书法")
        }
       
        myCell.myLabel.text = "长兴作品"
        
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "myhead", for: indexPath) as! myHeadCollectionReusableView
        
        if indexPath.section == 0{
            header.myHeadTitle.text = "书画"
            
        }else if indexPath.section == 1 {
            header.myHeadTitle.text = "美文"
            
        }else {
            header.myHeadTitle.text = "摄影"
        }
        
        header.backgroundColor = UIColor.clear
        header.myHeadTitle.textColor = UIColor.darkText
        
        
        return header
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
