//
//  UIImageView + DownloadImage.swift
//  MyTvShows
//
//  Created by Romain Hild on 15/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImageWithURL(url: NSURL) -> NSURLSessionDownloadTask {
        let session = NSURLSession.sharedSession()
        
        let downloadTask = session.downloadTaskWithURL(url) {
            [weak self] url, response, error in
            if let error = error where error.code == -999 {
                return
            } else if error == nil, let url = url, data = NSData(contentsOfURL: url), image = UIImage(data: data) {
                dispatch_async(dispatch_get_main_queue()) {
                    if let strongSelf = self {
                        strongSelf.image = image
                    }
                }
            } else {
                print("Error while downloading image \(error)")
            }
        }
        
        downloadTask.resume()
        return downloadTask
    }
    
    func loadImageWithURL(url: NSURL, withInsets insets: UIEdgeInsets, andFrame frame: CGRect) -> NSURLSessionDownloadTask  {
        let session = NSURLSession.sharedSession()
        
        let downloadTask = session.downloadTaskWithURL(url) {
            [weak self, insets, frame] url, response, error in
            if let error = error where error.code == -999 {
                return
            } else if error == nil, let url = url, data = NSData(contentsOfURL: url), image = UIImage(data: data) {
                UIGraphicsBeginImageContextWithOptions(frame.size, false, 1)
                UIGraphicsGetCurrentContext()
                let origin = CGPoint(x: insets.left, y: insets.top)
                let scaledImage = UIImage(CGImage: image.CGImage!, scale: image.size.width/frame.size.width, orientation: image.imageOrientation)
                scaledImage.drawAtPoint(origin)
                let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                dispatch_async(dispatch_get_main_queue()) {
                    if let strongSelf = self {
                        strongSelf.image = imageWithInsets
                    }
                }
            } else {
                print("Error while downloading image \(error)")
            }
        }
    
        downloadTask.resume()
        return downloadTask
    }
}
