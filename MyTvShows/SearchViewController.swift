//
//  ViewController.swift
//  MyTvShows
//
//  Created by Romain Hild on 14/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var delegate: SearchViewControllerDelegate?
    
    var searchResults = [SearchResult]()
    var hasSearched = false
    
    var currentElementParsed = ""
    
    var dataTask: NSURLSessionDataTask?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func cancel(sender: AnyObject) {
        delegate?.searchViewControllerDidCancel(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.becomeFirstResponder()
        // put the content of the tableview below the searchbar
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0,
            right: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showNetworkError() {
        let alert = UIAlertController(title: "Whoops...", message: "There was an error reading from the TvDB. Please try again.", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            dataTask?.cancel()
            hasSearched = true
            searchBar.resignFirstResponder()
            
            searchResults = [SearchResult]()
            
            let url = TvDBApiSingleton.sharedInstance.urlForSearch(searchBar.text!)
            
            let session = NSURLSession.sharedSession()
            
            dataTask = session.dataTaskWithURL(url ) {
                data, response, error in
                if let error = error where error.code == -999 {
                    return
                } else if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200 {
                    //print("Success! \(data!)")
                    TvDBSearchParser.sharedInstance.delegate = self
                    if TvDBSearchParser.sharedInstance.parseSearchData(data!) {
                        self.searchResults.sortInPlace(<)
                    
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.reloadData()
                        }
                        return
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.hasSearched = false
                            self.tableView.reloadData()
                            self.showNetworkError()
                        }
                    }
                } else {
                    print("Failure! \(response)")
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.hasSearched = false
                    self.tableView.reloadData()
                    self.showNetworkError()
                }
            }
            
            dataTask?.resume()
        }
        
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !hasSearched {
            return 0
        } else if searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchResultCell"
        
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }
        
        if searchResults.count == 0 {
            cell.textLabel!.text = "Nothing found"
            cell.detailTextLabel!.text = ""
        } else {
            let searchResult = searchResults[indexPath.row]
            cell.textLabel!.text = searchResult.name
            cell.detailTextLabel!.text = searchResult.lang
        }
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        delegate?.searchViewController(self, addSerie: Serie(id: searchResults[indexPath.row].id))
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if searchResults.count == 0 {
            return nil
        } else {
            return indexPath
        }
    }
}

extension SearchViewController: TvDBSearchParserDelegate {
    func parser(parser: TvDBSearchParser, parsedSearchResult search: SearchResult) {
        searchResults.append(search)
        print(searchResults.count)
    }
}

protocol SearchViewControllerDelegate: class {
    func searchViewControllerDidCancel(controller: SearchViewController)
    func searchViewController(controller: SearchViewController, addSerie serie: Serie)
}
