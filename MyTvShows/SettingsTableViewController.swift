//
//  SettingsTableViewController.swift
//  MyTvShows
//
//  Created by Romain Hild on 30/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var mySeries: MySeries!
    var languages = [(String,String)]()

    var languagePickerVisible = false
    let indexPathLanguage = NSIndexPath(forRow: 0, inSection: 0)
    let indexPathLanguagePicker = NSIndexPath(forRow: 1, inSection: 0)
    
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet var languagePickerCell: UITableViewCell!
    @IBOutlet weak var languagePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBar = self.tabBarController as! SeriesTabBarController
        mySeries = tabBar.mySeries
        
        let abbr = TvDBApiSingleton.sharedInstance.lang
        if !abbr.isEmpty, let index = languages.indexOf( { $0.0 == abbr } ) {
            languageLabel.text = languages[index].1
        }
        else {
            languageLabel.text = "English"
        }
        
        if languages.isEmpty {
            let url = TvDBApiSingleton.sharedInstance.urlForLanguages()
            let session = NSURLSession.sharedSession()
            let dataTask = session.dataTaskWithURL(url) {
                data, response, error in
                if let error = error where error.code == -999 {
                    return
                } else if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200 {
                    let parser = TvDBLanguageParser()
                    parser.delegate = self
                    if parser.parseLanguageData(data!) {
                        self.languages = self.languages.sort {$0.1.compare($1.1) == .OrderedAscending }
                        dispatch_async(dispatch_get_main_queue()) {
                            self.languagePicker.reloadAllComponents()
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
    
    func showLanguagePicker() {
        languagePickerVisible = true
        let abbr = TvDBApiSingleton.sharedInstance.lang
        if !abbr.isEmpty, let index = languages.indexOf( { $0.0 == abbr } ) {
            languagePicker.selectRow(index, inComponent: 0, animated: true)
        }
        else if let index = languages.indexOf( { $0.0 == "en" } ) {
            languagePicker.selectRow(index, inComponent: 0, animated: true)
        }
        
        tableView.insertRowsAtIndexPaths([indexPathLanguagePicker], withRowAnimation: .Fade)
    }
    
    func hideLanguagePicker() {
        if languagePickerVisible {
            languagePickerVisible = false
            
            tableView.deleteRowsAtIndexPaths([indexPathLanguagePicker], withRowAnimation: .Fade)
        }
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == indexPathLanguagePicker.section && languagePickerVisible {
            return 2
        }
        else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath == indexPathLanguagePicker {
            return languagePickerCell
        }
        else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == indexPathLanguagePicker && languagePickerVisible {
            return 217
        }
        else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath == indexPathLanguage {
            return indexPath
        }
        else {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath == indexPathLanguage {
            if languagePickerVisible {
                hideLanguagePicker()
            }
            else {
                showLanguagePicker()
            }
        }
    }
    
    override func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        if indexPath == indexPathLanguagePicker {
            return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPathLanguage)
        }
        else {
            return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
        }
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

extension SettingsTableViewController: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
}

extension SettingsTableViewController: UIPickerViewDelegate{
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row].1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        languageLabel.text = languages[row].1
        TvDBApiSingleton.sharedInstance.lang = languages[row].0
    }
}

extension SettingsTableViewController: TvDBLanguageParserDelegate {
    func parser(parser: TvDBLanguageParser, parsedLanguage language: String, withAbbreviation abbr: String) {
        languages.append((abbr, language))
    }
}
