//
//  EpisodesTableViewController.swift
//  MyTvShows
//
//  Created by Romain Hild on 17/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import UIKit

class EpisodesTableViewController: UITableViewController {
    
    var season: Season!
    var colors: UIImageColors?
    
    var selectedIndex: NSIndexPath?
    var overviewIndex: NSIndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Season \(season.seasonNumber)"
        view.backgroundColor = colors?.backgroundColor

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = selectedIndex {
            return season.count + 1
        }
        else {
            return season.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let episode: Episode
        if let selectedIndex = selectedIndex {
            if indexPath == NSIndexPath(forRow: selectedIndex.row + 1, inSection: selectedIndex.section) {
                let cell = tableView.dequeueReusableCellWithIdentifier("OverviewCell", forIndexPath: indexPath)
                cell.backgroundColor = colors?.backgroundColor
                
                episode = season[selectedIndex.row]
                
                let overviewLabel = cell.viewWithTag(1) as! UILabel
                overviewLabel.text = episode.epOverview
                overviewLabel.textColor = colors?.primaryColor
                
                return cell
            }
            else if indexPath.row > selectedIndex.row {
                episode = season[indexPath.row - 1]
            }
            else {
                episode = season[indexPath.row]
            }
        }
        else {
            episode = season[indexPath.row]
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("EpisodeCell", forIndexPath: indexPath)
        cell.backgroundColor = colors?.backgroundColor
        
        
        let numberLabel = cell.viewWithTag(1) as! UILabel
        numberLabel.text = String(episode.epNumber)
        numberLabel.textColor = colors?.detailColor
        
        let nameLabel = cell.viewWithTag(2) as! UILabel
        nameLabel.text = episode.epName
        nameLabel.textColor = colors?.primaryColor
        
        let dateLabel = cell.viewWithTag(3) as! UILabel
        if let firstAired = episode.epFirstAired {
            dateLabel.text = Episode.firstAiredStringFormatter.stringFromDate(firstAired)
        }
        else {
            dateLabel.text = ""
        }
        dateLabel.textColor = colors?.detailColor
        
        let ratingLabel = cell.viewWithTag(4) as! UILabel
        if episode.epRating != -1 {
            ratingLabel.text = String(episode.epRating)
        }
        else {
            ratingLabel.text = ""
        }
        ratingLabel.textColor = colors?.primaryColor
        
        let ratingCountLabel = cell.viewWithTag(5) as! UILabel
        if episode.epRatingCount != -1 {
            ratingCountLabel.text = "\(episode.epRatingCount) ratings"
        }
        else {
            ratingCountLabel.text = ""
        }
        ratingCountLabel.textColor = colors?.primaryColor
        
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let selectedIndex = selectedIndex {
            if indexPath == selectedIndex {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
                self.selectedIndex = nil
                tableView.beginUpdates()
                tableView.deleteRowsAtIndexPaths([overviewIndex!], withRowAnimation: .Top)
                tableView.endUpdates()
                self.overviewIndex = nil
            }
            else if indexPath == overviewIndex {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            else if indexPath.row < selectedIndex.row {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
                self.selectedIndex = nil
                tableView.beginUpdates()
                tableView.deleteRowsAtIndexPaths([overviewIndex!], withRowAnimation: .Top)
                tableView.endUpdates()
                self.selectedIndex = indexPath
                self.overviewIndex = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
                tableView.beginUpdates()
                tableView.insertRowsAtIndexPaths([overviewIndex!], withRowAnimation: .Top)
                tableView.endUpdates()
            }
            else { // indexPath.row > overviewIndex.row
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
                self.selectedIndex = nil
                tableView.beginUpdates()
                tableView.deleteRowsAtIndexPaths([overviewIndex!], withRowAnimation: .Top)
                tableView.endUpdates()
                self.selectedIndex = NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)
                self.overviewIndex = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)
                tableView.beginUpdates()
                tableView.insertRowsAtIndexPaths([overviewIndex!], withRowAnimation: .Top)
                tableView.endUpdates()
            }
        }
        else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            selectedIndex = indexPath
            overviewIndex = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
            tableView.beginUpdates()
            tableView.insertRowsAtIndexPaths([overviewIndex!], withRowAnimation: .Top)
            tableView.endUpdates()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let overviewIndex = overviewIndex where indexPath == overviewIndex {
            return UITableViewAutomaticDimension
        } else {
            return 44
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let overviewIndex = overviewIndex where indexPath == overviewIndex {
            return 160
        } else {
            return 44
        }
    }

}
