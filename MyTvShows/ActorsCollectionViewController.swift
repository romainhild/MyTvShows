//
//  ActorsCollectionViewController.swift
//  MyTvShows
//
//  Created by Romain Hild on 30/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ActorCell"

class ActorsCollectionViewController: UICollectionViewController {
    
    var serie: Serie!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.collectionView?.backgroundColor = serie.posterColors?.backgroundColor
        
        if serie.actors.isEmpty {
            let url = TvDBApiSingleton.sharedInstance.urlForActorsForSerieId(serie.seriesid)
            let session = NSURLSession.sharedSession()
            let dataTask = session.dataTaskWithURL(url ) {
                data, response, error in
                if let error = error where error.code == -999 {
                    return
                } else if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200 {
                    let parser = TvDBActorParser.sharedInstance
                    parser.delegate = self
                    if parser.parseActorData(data!) {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.collectionView?.reloadData()
                        }
                    }
                }
            }
        
        dataTask.resume()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serie.actors.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ActorCollectionViewCell
    
        cell.configureCellForActor(serie.actors[indexPath.row], andColors: serie.posterColors)
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}

extension ActorsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 316, height: 524)
    }
}

extension ActorsCollectionViewController: TvDBActorParserDelegate {
    func parser(parser: TvDBActorParser, parsedActor actor: Actor) {
        serie.actors.append(actor)
    }
}
