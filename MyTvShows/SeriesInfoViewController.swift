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
    
    var indexOfOverview: NSIndexPath?
    var indexOfNextEpisode: NSIndexPath?
    var indexOfAllEpisodes: NSIndexPath?
    var indexOfSeasons = [NSIndexPath]()
    var indexOfActors: NSIndexPath?
    var indexOfRatings: NSIndexPath?
    var indexOfGenre = [NSIndexPath]()
    var indexOfFirstAired: NSIndexPath?
    var indexOfStatus: NSIndexPath?
    var indexOfAirDay: NSIndexPath?
    var indexOfAirTime: NSIndexPath?
    var indexOfNetwork: NSIndexPath?
    var indexOfRuntime: NSIndexPath?
    var numberOfRowsInSection = [Int]()
    
    var selectedIndex: NSIndexPath?

    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = serie.seriesName
        
        if let path = serie.posterLocalURL, url = localFilePathForUrl(path.absoluteString), data = NSData(contentsOfURL: url), image = UIImage(data: data) {
            posterView.image = image
            if serie.posterColors == nil {
                serie.posterColors = posterView.image?.getColors(CGSize(width: posterView.frame.size.width/4, height: posterView.frame.size.height/4))
            }
            view.backgroundColor = serie.posterColors?.backgroundColor
            let navBar = self.navigationController?.navigationBar
            navBar?.tintColor = serie.posterColors?.detailColor
            //let attr = NSAttributedString(string: serie.seriesName, attributes: )
            navBar?.titleTextAttributes = [NSForegroundColorAttributeName:serie.posterColors!.primaryColor]
        }
        initIndexes()
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.contentInset = UIEdgeInsets(top: posterView.frame.size.height, left: 0, bottom: 0, right: 0)
        tableView.setContentOffset(CGPoint(x: 0, y: -posterView.frame.size.height), animated: true)
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
        else if segue.identifier == "ActorsSegue" {
            let controller = segue.destinationViewController as! ActorsCollectionViewController
            controller.serie = serie
        }
    }

    func initIndexes() {
        var section = 0
        var rows = 0

        if !serie.overview.isEmpty {
            indexOfOverview = NSIndexPath(forRow: rows, inSection: section)
            rows += 1
        }
        if rows > 0 {
            numberOfRowsInSection.append(rows)
        }
        section += 1
        
        rows = 0
        if let _ = serie.nextEpisode {
            indexOfNextEpisode = NSIndexPath(forRow: rows, inSection: section)
            rows += 1
        }
        if !serie.seasons.isEmpty {
            indexOfAllEpisodes = NSIndexPath(forRow: rows, inSection: section)
            rows += 1
            if let selectedIndex = selectedIndex where selectedIndex == indexOfAllEpisodes {
                for _ in serie.seasons {
                    indexOfSeasons.append(NSIndexPath(forRow: rows, inSection: section))
                    rows += 1
                }
            }
        }
        // display even if actors is empty
        indexOfActors = NSIndexPath(forRow: rows, inSection: section)
        rows += 1
        
        if rows > 0 {
            numberOfRowsInSection.append(rows)
        }
        section += 1

        rows = 0
        if serie.rating != -1 {
            indexOfRatings = NSIndexPath(forRow: rows, inSection: section)
            rows += 1
        }
        if !serie.genre.isEmpty {
            for _ in serie.genre {
                indexOfGenre.append(NSIndexPath(forRow: rows, inSection: section))
                rows += 1
            }
        }
        if let _ = serie.firstAired {
            indexOfFirstAired = NSIndexPath(forRow: rows, inSection: section)
            rows += 1
        }
        if !serie.status.isEmpty {
            indexOfStatus = NSIndexPath(forRow: rows, inSection: section)
            rows += 1
        }
        if !serie.airsDayOfWeek.isEmpty {
            indexOfAirDay = NSIndexPath(forRow: rows, inSection: section)
            rows += 1
        }
        if !serie.airsTime.isEmpty {
            indexOfAirTime = NSIndexPath(forRow: rows, inSection: section)
            rows += 1
        }
        if !serie.network.isEmpty {
            indexOfNetwork = NSIndexPath(forRow: rows, inSection: section)
            rows += 1
        }
        if serie.runtime != -1 {
            indexOfRuntime = NSIndexPath(forRow: rows, inSection: section)
            rows += 1
        }
        if rows > 0 {
            numberOfRowsInSection.append(rows)
        }
    }
    
    func updateIndexes() {
        var rows: Int
        if let _ = indexOfNextEpisode {
            rows = 1
        }
        else {
            rows = 0
        }
        indexOfSeasons = [NSIndexPath]()
        
        if let _ = indexOfAllEpisodes {
            rows += 1
        }
        
        if let selectedIndex = selectedIndex where selectedIndex == indexOfAllEpisodes {
            for _ in serie.seasons {
                indexOfSeasons.append(NSIndexPath(forRow: rows, inSection: indexOfAllEpisodes!.section))
                rows += 1
            }
            numberOfRowsInSection[indexOfAllEpisodes!.section] += serie.numberOfSeasons
        }
        else {
            numberOfRowsInSection[indexOfAllEpisodes!.section] -= serie.numberOfSeasons
        }
        
        if let _ = indexOfActors {
            indexOfActors = NSIndexPath(forRow: rows, inSection: indexOfActors!.section)
        }
    }
}

extension SeriesInfoViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfRowsInSection.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath {
        case let val where val == indexOfOverview:
            let cell = tableView.dequeueReusableCellWithIdentifier("OverviewCell", forIndexPath: indexPath)
            cell.backgroundColor = serie.posterColors?.backgroundColor

            let overviewLabel = cell.viewWithTag(1) as! UILabel
            overviewLabel.text = serie.overview
            overviewLabel.textColor = serie.posterColors?.primaryColor
            
            return cell
        case let val where val == indexOfRatings:
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
        case let val where indexOfGenre.contains(val):
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath)
            cell.backgroundColor = serie.posterColors?.backgroundColor
            
            let i = indexOfGenre.indexOf(val)!
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
        case let val where val == indexOfFirstAired:
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath)
            cell.backgroundColor = serie.posterColors?.backgroundColor
            
            cell.textLabel?.text = "First Aired:"
            cell.textLabel?.textColor = serie.posterColors?.detailColor
            
            cell.detailTextLabel?.text = Serie.firstAiredStringFormatter.stringFromDate(serie.firstAired!)
            cell.detailTextLabel?.textColor = serie.posterColors?.primaryColor
            
            return cell
        case let val where val == indexOfStatus:
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath)
            cell.backgroundColor = serie.posterColors?.backgroundColor
            
            cell.textLabel?.text = "Status:"
            cell.textLabel?.textColor = serie.posterColors?.detailColor
            
            cell.detailTextLabel?.text = serie.status
            cell.detailTextLabel?.textColor = serie.posterColors?.primaryColor

            return cell
        case let val where val == indexOfAirDay:
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath)
            cell.backgroundColor = serie.posterColors?.backgroundColor
            
            cell.textLabel?.text = "Air Day:"
            cell.textLabel?.textColor = serie.posterColors?.detailColor
            
            cell.detailTextLabel?.text = serie.airsDayOfWeek
            cell.detailTextLabel?.textColor = serie.posterColors?.primaryColor
            
            return cell
        case let val where val == indexOfAirTime:
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath)
            cell.backgroundColor = serie.posterColors?.backgroundColor
            
            cell.textLabel?.text = "Air Time:"
            cell.textLabel?.textColor = serie.posterColors?.detailColor
            
            cell.detailTextLabel?.text = serie.airsTime
            cell.detailTextLabel?.textColor = serie.posterColors?.primaryColor
            
            return cell
        case let val where val == indexOfNetwork:
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath)
            cell.backgroundColor = serie.posterColors?.backgroundColor
            
            cell.textLabel?.text = "Network:"
            cell.textLabel?.textColor = serie.posterColors?.detailColor
            
            cell.detailTextLabel?.text = serie.network
            cell.detailTextLabel?.textColor = serie.posterColors?.primaryColor
            
            return cell
        case let val where val == indexOfRuntime:
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath)
            cell.backgroundColor = serie.posterColors?.backgroundColor
            
            cell.textLabel?.text = "Runtime:"
            cell.textLabel?.textColor = serie.posterColors?.detailColor
            
            cell.detailTextLabel?.text = serie.runtime.minutesAsTime()
            cell.detailTextLabel?.textColor = serie.posterColors?.primaryColor
            
            return cell
        case let val where indexOfSeasons.contains(val):
            let cell = tableView.dequeueReusableCellWithIdentifier("SeasonCell", forIndexPath: indexPath)
            cell.backgroundColor = serie.posterColors?.backgroundColor
            
            let i = indexOfSeasons.indexOf(val)!
            cell.textLabel?.text = "Season \(serie.seasons[i].seasonNumber)"
            cell.textLabel?.textColor = serie.posterColors?.primaryColor
            return cell
        case let val where val == indexOfAllEpisodes:
            let cell = tableView.dequeueReusableCellWithIdentifier("SeasonCell", forIndexPath: indexPath)
            cell.backgroundColor = serie.posterColors?.backgroundColor
            cell.textLabel?.text = "All Episodes"
            cell.textLabel?.textColor = serie.posterColors?.detailColor
            cell.accessoryType = .None
            return cell
        case let val where val == indexOfNextEpisode:
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath)
            cell.backgroundColor = serie.posterColors?.backgroundColor
            
            cell.textLabel?.text = "Next Episode:"
            cell.textLabel?.textColor = serie.posterColors?.detailColor
            
            cell.detailTextLabel?.text = Episode.firstAiredStringFormatter.stringFromDate(serie.nextEpisode!)
            cell.detailTextLabel?.textColor = serie.posterColors?.primaryColor
            
            return cell
        case let val where val == indexOfActors:
            let cell = tableView.dequeueReusableCellWithIdentifier("SeasonCell", forIndexPath: indexPath)
            cell.backgroundColor = serie.posterColors?.backgroundColor
            cell.textLabel?.text = "Actors"
            cell.textLabel?.textColor = serie.posterColors?.detailColor
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
        if indexPath == indexOfOverview {
            return UITableViewAutomaticDimension
        } else {
            return 44
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == indexOfOverview {
            return 160
        } else {
            return 44
        }
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        switch indexPath {
        case let val where val == indexOfAllEpisodes:
            return indexPath
        case let val where val == indexOfActors:
            return indexPath
        case let val where indexOfSeasons.contains(val):
            return indexPath
        default:
            return nil
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath {
        case let val where val == indexOfAllEpisodes:
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            if let _ = selectedIndex {
                selectedIndex = nil
                let oldIndexes = indexOfSeasons
                updateIndexes()
                tableView.beginUpdates()
                tableView.deleteRowsAtIndexPaths(oldIndexes, withRowAnimation: .Top)
                tableView.endUpdates()
            }
            else {
                selectedIndex = indexOfAllEpisodes
                updateIndexes()
                tableView.beginUpdates()
                tableView.insertRowsAtIndexPaths(indexOfSeasons, withRowAnimation: .Top)
                tableView.endUpdates()
            }
        case let val where val == indexOfActors:
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            performSegueWithIdentifier("ActorsSegue", sender: nil)
        case let val where indexOfSeasons.contains(val):
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            let i = indexOfSeasons.indexOf(indexPath)!
            performSegueWithIdentifier("SeasonSegue", sender: serie.seasons[i])
        default:
            break
        }
    }
}

extension SeriesInfoViewController: SeriePosterDelegate {
    func serieFinishedDownloadPoster(serie: Serie) {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
}
