//
//  ViewController.swift
//  SitePoint-UICollectionView
//
//  Created by Klevis Davidhi on 11/6/16.
//  Copyright © 2016 Klevis Davidhi. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let screenSize: CGRect = UIScreen.main.bounds

    var imageArray = [UIImage](repeating: UIImage(), count: 30)
    var sourceArray = [URL](repeating: URL(string: "https://placehold.it")!,count: 30)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        
        
        for index in 0...4{
            
            let baseUrl = sourceArray[index]
            
            
            let url = urlComponents(baseUrl: baseUrl, index: index)
            
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async() {
                    self.imageArray[index] = UIImage(data: data)!
                    self.collectionView.reloadData()
                }
            }
            task.resume()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func urlComponents(baseUrl:URL, index: Int) -> URL {
        
        var baseUrlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        baseUrlComponents?.path = "/\(screenSize.width)x\(screenSize.height * 0.3)"
        baseUrlComponents?.query = "text=food \(index)"
        return (baseUrlComponents?.url)!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let foodCell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as! collectionViewCell
        
        foodCell.foodImage.image = imageArray[indexPath.row]
        
        return foodCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths{
            
            let baseUrl = sourceArray[indexPath.row]
            let url = urlComponents(baseUrl: baseUrl, index: indexPath.row)
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                self.imageArray[indexPath.row] = UIImage(data: data)!
            }
            
            task.resume()
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths{
            imageArray[indexPath.row] = UIImage()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSize(width:screenSize.width ,height: screenSize.height * 0.3)
    }
    
}

