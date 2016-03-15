//
//  MySeries.swift
//  MyTvShows
//
//  Created by Romain Hild on 15/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import Foundation

class MySeries {
    var series = [Serie]()
    var delegate: MySeriesDelegate?
    
    var count: Int {
        return series.count
    }
    
    subscript(index: Int) -> Serie {
        get {
            return series[index]
        }
        set {
            newValue.delegate = self
            series[index] = newValue
        }
    }
    
    func append(serie: Serie) {
        serie.delegate = self
        series.append(serie)
    }
    
    func remove(index: Int) {
        series.removeAtIndex(index)
    }
}

extension MySeries: SerieDelegate {
    func serieFinishedInit(serie: Serie) {
        series.sortInPlace(<)
        delegate?.mySeriesNeedRefresh(self)
    }
}

protocol MySeriesDelegate: class {
    func mySeriesNeedRefresh(myseries: MySeries)
}