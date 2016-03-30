//
//  ActorCollectionViewCell.swift
//  MyTvShows
//
//  Created by Romain Hild on 30/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import UIKit

class ActorCollectionViewCell: UICollectionViewCell {
    
    static let placeholder = UIImage(named: "placeholder.jpg")
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var actorLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    
    func configureCellForActor(actor: Actor, andColors colors: UIImageColors?) {
        backgroundColor = colors?.backgroundColor
        
        actorLabel.text = actor.name
        actorLabel.textColor = colors?.primaryColor
        roleLabel.text = actor.role
        roleLabel.textColor = colors?.detailColor
        
        if let path = actor.imagePath, url = localFilePathForUrl(path.absoluteString), data = NSData(contentsOfURL: url), image = UIImage(data: data) {
            imageView.image = image
        } else {
            imageView.image = ActorCollectionViewCell.placeholder
            downloadActorImage(actor)
        }
    }
    
    func downloadActorImage(actor: Actor) {
        let tvDBApi = TvDBApiSingleton.sharedInstance
        let url = tvDBApi.urlForBanner(actor.imageURL)
        let session = NSURLSession.sharedSession()
        
        let downloadTask = session.downloadTaskWithURL(url) {
            [weak self, actor] url, response, error in
            if let error = error where error.code == -999 {
                return
            } else if error == nil, let url = url, destinationURL = localFilePathForUrl(url.absoluteString) {
                // copy to sandbox
                let fileManager = NSFileManager.defaultManager()
                do {
                    try fileManager.removeItemAtURL(destinationURL)
                } catch {
                    // Non-fatal: file probably doesn't exist
                }
                do {
                    try fileManager.copyItemAtURL(url, toURL: destinationURL)
                } catch let error as NSError {
                    print("Could not copy file to disk: \(error.localizedDescription)")
                }
                actor.imagePath = destinationURL
                if let data = NSData(contentsOfURL: destinationURL), image = UIImage(data: data) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self?.imageView.image = image
                    }
                }
            }
        }
        
        downloadTask.resume()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = ActorCollectionViewCell.placeholder
    }
}
