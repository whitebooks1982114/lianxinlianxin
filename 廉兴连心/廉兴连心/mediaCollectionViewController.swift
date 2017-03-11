//
//  mediaCollectionViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/12/31.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit


class mediaCollectionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var titleList = [String]()
    var perfaceName:String!
    
    @IBOutlet weak var mediaCollection: UICollectionView!
    
     let media = mediaViewController()
    
    func query() {
        titleList.removeAll()
        let query = BmobQuery(className: "media")
        query?.whereKey("name", equalTo: perfaceName)
        query?.order(byDescending: "updatedAt")
        query?.findObjectsInBackground({ (array, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
                let alert = UIAlertController(title: "错误提示", message: "服务器连接失败", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            }else {
                for obj in array! {
                    
                    let detail = obj as! BmobObject
                    let listtitle = detail.object(forKey: "title") as! String
                    self.titleList.append(listtitle)
                    
                }
                
            }
            DispatchQueue.main.async {
                self.mediaCollection.reloadData()
            }
            
        })

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      mediaCollection.backgroundView = UIImageView(image: UIImage(named: "百科背景"))        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        query()
    }
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let num = titleList.count % 3
        
        if  section == titleList.count / 3
        {  if num != 0 {
            return titleList.count % 3
        }else {
            return 3
            }
            
        }else {
            
            return 3
        }
    }
    
    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        let num = titleList.count % 3
        if titleList.count < 3 {
            return 1
        }else{
            if num == 0 {
                return titleList.count / 3
            }else {
                return titleList.count / 3 + 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
  
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! MediaCellCollectionViewCell
        
        myCell.mediaImage.image = UIImage(named: "视频图标")
        if titleList.count != 0 {
       myCell.mediaName.text = titleList[indexPath.section * 3 + indexPath.row]
        }
        myCell.mediaName.adjustsFontSizeToFitWidth = true
        
        return myCell
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = titleList[indexPath.row]
        media.myTitle = selected
        
        self.navigationController?.pushViewController(media, animated: true)
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
