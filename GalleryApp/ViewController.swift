//
//  ViewController.swift
//  GalleryApp
//
//  Created by surya-zstk231 on 16/05/21.
//

import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDelegate{

    var imageArray=[UIImage]()
    let blockAlertLabel = UILabel()
    
    @IBOutlet weak var collectionViewArea: UICollectionView!
    
    @IBOutlet weak var alertTextLabel: UILabel!
    let collectionCellNibName = "ImageCollectionViewCell"
    let collectionCellID = "PhotoCellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        permissionFunc()
        
        collectionViewArea.register(UINib(nibName: collectionCellNibName, bundle: nil), forCellWithReuseIdentifier: collectionCellID)
        collectionViewArea.delegate=self
        collectionViewArea.dataSource=self
    }
    
    func permissionFunc(){
        let photos = PHPhotoLibrary.authorizationStatus()
        print("raw value \(photos.rawValue)")
        if photos == .notDetermined{
            PHPhotoLibrary.requestAuthorization({status in
                self.workOnStatus(status: status)
            })
        }
        workOnStatus(status: photos)
        
    }
    
    func workOnStatus(status: PHAuthorizationStatus){
        switch status {
        case .authorized:
            goToWork()
        case .denied:
            DispatchQueue.main.async { [self] in
                alertTextLabel.text = "Your access denied"
                addBloackAlertLabel()
            }
        default:
            print("Other")
        }
    }
    
    
    func addBloackAlertLabel(){
        blockAlertLabel.frame = CGRect(x: (view.frame.width/2)-150, y: (view.frame.height/2)-25, width: 300, height: 50)
        blockAlertLabel.text = "You block the access"
        blockAlertLabel.textAlignment = .center
        
       view.addSubview(blockAlertLabel)
    }
       
    func goToWork(){
        grabPhotos()
    }
    func grabPhotos(){
        imageArray = []
        
            let imgManager = PHImageManager.default()
            
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors=[NSSortDescriptor(key:"creationDate", ascending: false)]
            
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            print(fetchResult)
            print(fetchResult.count)
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count{
                    imgManager.requestImage(for: fetchResult.object(at: i) as PHAsset, targetSize: CGSize(width:500, height: 500),contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
                        self.imageArray.append(image!)
                    })
                }
            } else {
                print("You got no photos.")
                DispatchQueue.main.async { [self] in
                    alertTextLabel.text = "You got no photos"
                }
                
            }
            
            DispatchQueue.main.async {
                self.collectionViewArea.reloadData()
            }
    }
    
}


extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (view.frame.width/3)-15
        return CGSize(width: size, height: size)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}


extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellID, for: indexPath) as! ImageCollectionViewCell
        let img = imageArray[indexPath.row]
        cell.imageViewArea.image = img
        return cell
    }
    
}

