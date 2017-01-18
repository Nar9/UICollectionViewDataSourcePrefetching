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
    
    var imageArray = [UIImage?](repeating: nil, count: 30)
    var tasks = [URLSessionDataTask?](repeating: nil, count: 30)
    var baseUrl = URL(string: "https://placehold.it")!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func urlComponents(index: Int) -> URL {
        
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
        
        if let img = imageArray[indexPath.row] {
            foodCell.foodImage.image = img
        }
        else {
            requestImage(forIndex: indexPath)
        }
        
        return foodCell
    }
    
    
    
    
    func requestImage(forIndex: IndexPath) {
        var task: URLSessionDataTask
        
        if imageArray[forIndex.row] != nil {
            // Image is already loaded
            return
        }
        
        if tasks[forIndex.row] != nil
            && tasks[forIndex.row]!.state == URLSessionTask.State.running {
            // Wait for task to finish
            return
        }
        
        task = getTask(forIndex: forIndex)
        tasks[forIndex.row] = task
        task.resume()
    }
    
    
    func getTask(forIndex: IndexPath) -> URLSessionDataTask {
        let imgURL = urlComponents(index: forIndex.row)
        return URLSession.shared.dataTask(with: imgURL) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() {
                let image = UIImage(data: data)!
                self.imageArray[forIndex.row] = image
                self.collectionView.reloadItems(at: [forIndex])
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths{
            requestImage(forIndex: indexPath)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths{
            if let task = tasks[indexPath.row] {
                if task.state != URLSessionTask.State.canceling {
                    task.cancel()
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSize(width:screenSize.width ,height: screenSize.height * 0.3)
    }
    
    
    
    
    
    
}

