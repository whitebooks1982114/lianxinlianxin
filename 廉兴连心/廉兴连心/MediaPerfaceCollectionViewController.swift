//
//  MediaPerfaceCollectionViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 17/3/11.
//  Copyright © 2017年 whitebooks. All rights reserved.
//

import UIKit
import Kingfisher

class MediaPerfaceCollectionViewController: UICollectionViewController {
    
    var titleList = [String]()
    var imageList = [URL]()
    let  myActivi = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
 
    let myStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
   
    func query() {
        self.myActivi.startAnimating()
        self.titleList.removeAll()
        self.imageList.removeAll()
        let query = BmobQuery(className: "media")
        query?.whereKey("index", equalTo: 0)
        query?.findObjectsInBackground({ (array, error) in
            if error != nil {
                let alert  = UIAlertController(title: "提示", message: " 查询失败", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: {
                    (ok) -> Void in
                        _ = self.navigationController?.popToRootViewController(animated: true)
                   
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }else {
                for obj in array! {
                    let object = obj as! BmobObject
                    let title = object.object(forKey: "name") as! String
                    let image = object.object(forKey: "image") as! BmobFile
                    let imageUrl =  NSURL(string: image.url) as! URL
                    self.titleList.append(title)
                    self.imageList.append(imageUrl)
                    print(self.titleList.count)
                }
            }
            DispatchQueue.main.async {
                
                self.collectionView?.reloadData()
                self.collectionView?.layoutIfNeeded()
                 self.myActivi.stopAnimating()
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
     
       self.collectionView?.backgroundView = UIImageView(image: UIImage(named: "百科背景"))

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        query()
        myActivi.frame.origin.x = UIScreen.main.bounds.width / 2
        myActivi.frame.origin.y = UIScreen.main.bounds.height / 2
        self.view.addSubview(myActivi)
        myActivi.startAnimating()
        myActivi.color = UIColor.red
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
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
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
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
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! MediaPerfaceCellCollectionViewCell
        if self.titleList.count != 0 {
        cell.perfaceImage.kf.setImage(with: ImageResource.init(downloadURL: self.imageList[indexPath.section * 3 + indexPath.row]),placeholder: UIImage(named:"默认图片"), options: nil, progressBlock: nil, completionHandler: nil)
        cell.perfaceLabel.text = self.titleList[indexPath.section * 3 + indexPath.row]
        cell.perfaceLabel.numberOfLines = 0
        cell.perfaceLabel.lineBreakMode = .byWordWrapping
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mediaCollection = self.myStoryboard.instantiateViewController(withIdentifier: "mediaCollection") as! mediaCollectionViewController
        mediaCollection.perfaceName = titleList[indexPath.section * 3 + indexPath.row]
      
        self.navigationController?.pushViewController(mediaCollection, animated: true)
        
        
    }
   
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

  
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
