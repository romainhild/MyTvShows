//
//  ChooseImageTableViewController.swift
//  MyTvShows
//
//  Created by Romain Hild on 01/04/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import UIKit

class ChooseImageTableViewController: UITableViewController {
    
    var delegate: ChooseImageControllerDelegate?
    var serie: Serie!
    var type: Serie.ImageType!
    var images = [Banner]()
    
    var dataTask: NSURLSessionDataTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch type! {
        case .Banner:
            tableView.rowHeight = tableView.bounds.size.width*140/758
        case .Poster:
            tableView.rowHeight = tableView.bounds.size.width*1000/680
        case .FanArt:
            tableView.rowHeight = tableView.bounds.size.width*168/300
        }

        if serie.banners.isEmpty {
            let url = TvDBApiSingleton.sharedInstance.urlForBannersForSerieID(serie.seriesid)
            let session = NSURLSession.sharedSession()
            dataTask = session.dataTaskWithURL(url) {
                data, response, error in
                if let error = error where error.code == -999 {
                    return
                } else if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200 {
                    let parser = TvDBImagesParser(type: self.type)
                    parser.delegate = self
                    if parser.parseImagesData(data!) {
                        self.images = self.serie.bannersOfType(self.type)
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            dataTask!.resume()
        }
        self.images = self.serie.bannersOfType(self.type)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancel(sender: AnyObject) {
        dataTask?.cancel()
        delegate?.chooseImageControllerDidCancel(self)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BannerCell", forIndexPath: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = nil
        let banner = images[indexPath.row]
        if let url = banner.bannerULR, data = NSData(contentsOfURL: url), image = UIImage(data: data) {
            print("find image")
            imageView.image = image
        }
        else {
            let url: NSURL
            switch type! {
            case .Banner, .Poster:
                url = TvDBApiSingleton.sharedInstance.urlForBanner(banner.bannerPath)
            case .FanArt:
                url = TvDBApiSingleton.sharedInstance.urlForBanner(banner.thumbnailPath)
            }
            let session = NSURLSession.sharedSession()
            
            let downloadTask = session.downloadTaskWithURL(url) {
                [imageView, banner] url, response, error in
                if let error = error where error.code == -999 {
                    return
                } else if error == nil, let url = url {
                    banner.bannerULR = url
                    if let data = NSData(contentsOfURL: url), image = UIImage(data: data) {
                        dispatch_async(dispatch_get_main_queue()) {
                            imageView.image = image
                        }
                    }
                }
            }
            
            downloadTask.resume()
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChooseImageTableViewController: TvDBImagesParserDelegate {
    func parser(parser: TvDBImagesParser, parsedImage image: Banner) {
        serie.banners.append(image)
    }
}

protocol ChooseImageControllerDelegate {
    func chooseImageControllerDidCancel(controller: ChooseImageTableViewController)
    func chooseImageController(controller: ChooseImageTableViewController, chooseBanner bannerURL: String)
    func chooseImageController(controller: ChooseImageTableViewController, choosePoster posterURL: String)
    func chooseImageController(controller: ChooseImageTableViewController, chooseFanArt fanArtURL: String)
}
