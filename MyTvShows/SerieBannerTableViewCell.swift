//
//  SerieBannerTableViewCell.swift
//  MyTvShows
//
//  Created by Romain Hild on 14/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import UIKit

class SerieBannerTableViewCell: UITableViewCell {
    
    var downloadTask: NSURLSessionDownloadTask?

    @IBOutlet weak var bannerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        downloadTask?.cancel()
        downloadTask = nil
        bannerImageView.image = nil
    }
    
    func configureForSerie(serie: Serie) {
        bannerImageView.image = UIImage()
        if !serie.banner.isEmpty {
            let tvDBApi = TvDBApiSingleton.sharedInstance
            let url = tvDBApi.urlForBanner(serie.banner)
            downloadTask = bannerImageView.loadImageWithURL(url)
        }
    }

}
