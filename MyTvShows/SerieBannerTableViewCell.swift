//
//  SerieBannerTableViewCell.swift
//  MyTvShows
//
//  Created by Romain Hild on 14/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import UIKit

class SerieBannerTableViewCell: UITableViewCell {
    
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
        bannerImageView.image = nil
    }
    
    func configureForSerie(serie: Serie) {
        bannerImageView.image = UIImage()
        if let url = serie.bannerLocalURL, data = NSData(contentsOfURL: url), image = UIImage(data: data) {
            bannerImageView.image = image
        }
    }

}
