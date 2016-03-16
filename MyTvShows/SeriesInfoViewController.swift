//
//  SeriesInfoViewController.swift
//  MyTvShows
//
//  Created by Romain Hild on 15/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import UIKit

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
            downloadTask = posterView.loadImageWithURL(url)
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
        return 19
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TestCell", forIndexPath: indexPath)
        return cell
    }
}
