//
//  NextEpisodesTableViewController.swift
//  MyTvShows
//
//  Created by Romain Hild on 31/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import UIKit

class NextEpisodesTableViewController: UITableViewController {
    
    var mySeries: MySeries!
    var nextEpisodes = [NSDate:[Episode]]()
    var sortedDates = [NSDate]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tabBar = tabBarController as? SeriesTabBarController {
            mySeries = tabBar.mySeries
        }

        update()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(NextEpisodesTableViewController.update(_:)), forControlEvents: .ValueChanged)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update(sender: UIRefreshControl? = nil) {
        nextEpisodes = [NSDate: [Episode]]()
        let today = NSDate()
        for serie in mySeries.series {
            for season in serie.seasons {
                for ep in season.episodes {
                    if ep >= today {
                        append(ep)
                    }
                }
            }
        }
        sortedDates = nextEpisodes.keys.sort { $0.compare($1) == .OrderedAscending }
        tableView.reloadData()
        
        sender?.endRefreshing()
    }
    
    func append(episode: Episode) {
        var didFindDay = false
        for (date, var episodes) in nextEpisodes {
            if date.isSameDay(episode.epFirstAired!) {
                episodes.append(episode)
                nextEpisodes.updateValue(episodes, forKey: date)
                didFindDay = true
                break
            }
        }
        if !didFindDay {
            nextEpisodes.updateValue([episode], forKey: episode.epFirstAired!)
        }
    }
    
    func dateAtIndex(index: Int) -> NSDate {
        return sortedDates[index]
    }
    
    func episodesInDayAtIndex(index: Int) -> [Episode] {
        return nextEpisodes[dateAtIndex(index)]!
    }
    
    func episodeAtIndexPath(indexPath: NSIndexPath) -> Episode {
        return nextEpisodes[dateAtIndex(indexPath.section)]![indexPath.row]
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return nextEpisodes.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodesInDayAtIndex(section).count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NextEpisodeCell", forIndexPath: indexPath)

        let episode = episodeAtIndexPath(indexPath)
        cell.detailTextLabel?.text = String(format: "%02dx%02d %@", episode.epSeason, episode.epNumber, episode.epName)
        
        if let serie = mySeries.serieWithId(episode.serieId) {
            cell.textLabel?.text = serie.seriesName
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Episode.firstAiredStringFormatter.stringFromDate(dateAtIndex(section))
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
