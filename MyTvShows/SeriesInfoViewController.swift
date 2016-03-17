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
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SeasonSegue" {
            let controller = segue.destinationViewController as! EpisodesTableViewController
            let season = sender as! Season
            controller.season = season
            controller.colors = serie.posterColors
        }
    }

}

extension SeriesInfoViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serie.numberOfRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath {
        case let val where val == serie.indexOfOverview:
            let cell = tableView.dequeueReusableCellWithIdentifier("OverviewCell", forIndexPath: indexPath)
            cell.backgroundColor = serie.posterColors?.backgroundColor

            let overviewLabel = cell.viewWithTag(1) as! UILabel
            overviewLabel.text = serie.overview
            overviewLabel.textColor = serie.posterColors?.primaryColor
            
            return cell
        case let val where val == serie.indexOfRatings:
            let cell = tableView.dequeueReusableCellWithIdentifier("RatingCell", forIndexPath: indexPath)
            cell.backgroundColor = serie.posterColors?.backgroundColor
            
            let titleLabel = cell.viewWithTag(1) as! UILabel
            titleLabel.textColor = serie.posterColors?.detailColor

            let ratingLabel = cell.viewWithTag(2) as! UILabel
            ratingLabel.text = String(serie.rating)
            ratingLabel.textColor = serie.posterColors?.primaryColor

            let ratingCountLabel = cell.viewWithTag(3) as! UILabel
            if serie.ratingCount != -1 {
                ratingCountLabel.text = "\(serie.ratingCount) ratings"
                ratingCountLabel.textColor = serie.posterColors?.secondaryColor
            }
            else {
                ratingCountLabel.text = ""
            }
            return cell
        case let val where serie.indexOfGenre.contains(val):
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath)
            cell.backgroundColor = serie.posterColors?.backgroundColor
            
            let i = serie.indexOfGenre.indexOf(val)!
            if i == 0 {
                cell.textLabel?.text = "Genre:"
            }
            else {
                cell.textLabel?.text = ""
            }
            cell.textLabel?.textColor = serie.posterColors?.detailColor
            
            cell.detailTextLabel?.text = serie.genre[i]
            cell.detailTextLabel?.textColor = serie.posterColors?.primaryColor
            
            return cell
        case let val where val == serie.indexOfFirstAired:
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath)
            cell.backgroundColor = serie.posterColors?.backgroundColor
            
            cell.textLabel?.text = "First Aired:"
            cell.textLabel?.textColor = serie.posterColors?.detailColor
            
            cell.detailTextLabel?.text = Serie.firstAiredStringFormatter.stringFromDate(serie.firstAired!)
            cell.detailTextLabel?.textColor = serie.posterColors?.primaryColor
            
            return cell
        case let val where val == serie.indexOfStatus:
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath)
            cell.backgroundColor = serie.posterColors?.backgroundColor
            
            cell.textLabel?.text = "Status:"
            cell.textLabel?.textColor = serie.posterColors?.detailColor
            
            cell.detailTextLabel?.text = serie.status
            cell.detailTextLabel?.textColor = serie.posterColors?.primaryColor

            return cell
        case let val where val == serie.indexOfAirDay:
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath)
            cell.backgroundColor = serie.posterColors?.backgroundColor
            
            cell.textLabel?.text = "Air Day:"
            cell.textLabel?.textColor = serie.posterColors?.detailColor
            
            cell.detailTextLabel?.text = serie.airsDayOfWeek
            cell.detailTextLabel?.textColor = serie.posterColors?.primaryColor
            
            return cell
        case let val where val == serie.indexOfAirTime:
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath)
            cell.backgroundColor = serie.posterColors?.backgroundColor
            
            cell.textLabel?.text = "Air Time:"
            cell.textLabel?.textColor = serie.posterColors?.detailColor
            
            cell.detailTextLabel?.text = serie.airsTime
            cell.detailTextLabel?.textColor = serie.posterColors?.primaryColor
            
            return cell
        case let val where val == serie.indexOfNetwork:
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath)
            cell.backgroundColor = serie.posterColors?.backgroundColor
            
            cell.textLabel?.text = "Network:"
            cell.textLabel?.textColor = serie.posterColors?.detailColor
            
            cell.detailTextLabel?.text = serie.network
            cell.detailTextLabel?.textColor = serie.posterColors?.primaryColor
            
            return cell
        case let val where val == serie.indexOfRuntime:
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath)
            cell.backgroundColor = serie.posterColors?.backgroundColor
            
            cell.textLabel?.text = "Runtime:"
            cell.textLabel?.textColor = serie.posterColors?.detailColor
            
            cell.detailTextLabel?.text = serie.runtime.minutesAsTime()
            cell.detailTextLabel?.textColor = serie.posterColors?.primaryColor
            
            return cell
        case let val where serie.indexOfSeasons.contains(val):
            let cell = tableView.dequeueReusableCellWithIdentifier("SeasonCell", forIndexPath: indexPath)
            cell.backgroundColor = serie.posterColors?.backgroundColor
            
            let i = serie.indexOfSeasons.indexOf(val)!
            cell.textLabel?.text = "Season \(serie.seasons[i].seasonNumber)"
            cell.textLabel?.textColor = serie.posterColors?.primaryColor
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath)
            cell.backgroundColor = serie.posterColors?.backgroundColor
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
            return cell
        }
    }
}

extension SeriesInfoViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == serie.indexOfOverview {
            return UITableViewAutomaticDimension
        } else {
            return 44
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == serie.indexOfOverview {
            return 160
        } else {
            return 44
        }
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if serie.indexOfSeasons.contains(indexPath) {
            return indexPath
        }
        else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if serie.indexOfSeasons.contains(indexPath) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            let i = serie.indexOfSeasons.indexOf(indexPath)!
            performSegueWithIdentifier("SeasonSegue", sender: serie.seasons[i])
        }
    }
}

extension SeriesInfoViewController: UIImageViewDownloaderDelegate {
    func imageViewDidFinishDownloading(imageView: UIImageView) {
        serie.posterColors = posterView.image?.getColors(CGSize(width: posterView.frame.size.width/4, height: posterView.frame.size.height/4))
        view.backgroundColor = serie.posterColors?.backgroundColor
        tableView.reloadData()
    }
}
