//
//  Int + intToTime.swift
//  MyTvShows
//
//  Created by Romain Hild on 17/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import Foundation

extension Int {
    func minutesAsTime() -> (Int,Int) {
        return (self/60, self % 60)
    }
    
    func secondsAsTime() -> (Int,Int,Int) {
        return (self / 3600, (self % 3600) / 60, (self % 60) )
    }
    
    func secondsAsTime() -> String {
        var string = ""
        let (h,m,s) = self.secondsAsTime()
        if h != 0 {
            string += "\(h)h"
        }
        if m != 0 {
            if h != 0 {
                string += " "
            }
            string += "\(m)m"
        }
        if s != 0 {
            if h != 0 || m != 0 {
                string += " "
            }
            string += "\(s)s"
        }
        return string
    }
    
    func minutesAsTime() -> String {
        var string = ""
        let (h,m) = self.minutesAsTime()
        if h == 1 {
            string += "\(h) hour"
        } else if h > 1 {
            string += "\(h) hours"
        }
        if m != 0 {
            if h != 0 {
                string += " "
            }
            if m == 1 {
                string += "\(m) minute"
            } else if m > 1 {
                string += "\(m) minutes"
            }
        }
        return string
    }
}