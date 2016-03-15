//
//  MySeriesTableViewController.swift
//  MyTvShows
//
//  Created by Romain Hild on 14/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import UIKit

class MySeriesTableViewController: UITableViewController {
    
    var mySeries = MySeries()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mySeries.delegate = self

        let cellNib = UINib(nibName: "SerieBannerCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: "SerieBannerCell")
        tableView.rowHeight = tableView.bounds.size.width*140/758
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        mySeries.append(Serie(id: "161511"))
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
        return mySeries.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SerieBannerCell", forIndexPath: indexPath) as! SerieBannerTableViewCell
        cell.configureForSerie(mySeries[indexPath.row])

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            mySeries.remove(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
    }

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddSerie" {
            let naviguation = segue.destinationViewController as! UINavigationController
            let searchController = naviguation.topViewController as! SearchViewController
            searchController.delegate = self
        } else if segue.identifier == "SerieInfo" {
            let serie = sender as! Serie
            let controller = segue.destinationViewController as! SeriesInfoViewController
            controller.serie = serie
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if mySeries.count == 0 {
            return nil
        } else {
            return indexPath
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("SerieInfo", sender: mySeries[indexPath.row])
    }
}

extension MySeriesTableViewController: SearchViewControllerDelegate {
    func searchViewControllerDidCancel(controller: SearchViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func searchViewController(controller: SearchViewController, addSerie serie: Serie) {
        mySeries.append(serie)
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension MySeriesTableViewController: MySeriesDelegate {
    func mySeriesNeedRefresh(myseries: MySeries) {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
}
