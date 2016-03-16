//
//  SeriesInfoViewController.swift
//  MyTvShows
//
//  Created by Romain Hild on 15/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import UIKit
import QuartzCore

class SeriesInfoViewController: UIViewController {
    
    var serie: Serie!
    
    var downloadTask: NSURLSessionDownloadTask?
    var colors: UIImageColors?
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = serie.seriesName
        
        if !serie.poster.isEmpty {
            let tvDBApi = TvDBApiSingleton.sharedInstance
            let url = tvDBApi.urlForBanner(serie.poster)
            downloadTask = posterView.loadImageWithURL(url, delegate: self)
        }
        
        tableView.contentInset = UIEdgeInsets(top: posterView.frame.size.height, left: 0, bottom: 0,
            right: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SeriesInfoViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("OverviewCell", forIndexPath: indexPath)
            let overviewLabel = cell.viewWithTag(1) as! UILabel
            overviewLabel.text = serie.overview
            if let colors = colors {
                cell.backgroundColor = colors.backgroundColor
                overviewLabel.textColor = colors.primaryColor
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("TestCell", forIndexPath: indexPath)
            return cell
        }
    }
}

extension SeriesInfoViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return UITableViewAutomaticDimension
        } else {
            return 44
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 160
        } else {
            return 44
        }
    }
}

extension SeriesInfoViewController: UIImageViewDownloaderDelegate {
    func imageViewDidFinishDownloading(imageView: UIImageView) {
        colors = posterView.image?.getColors(CGSize(width: posterView.frame.size.width/4, height: posterView.frame.size.height/4))
        view.backgroundColor = colors?.backgroundColor
        tableView.reloadData()
    }
}
