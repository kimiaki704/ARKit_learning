//
//  Constants.swift
//  ARKit_learning
//
//  Created by 鈴木公章 on 2020/01/18.
//  Copyright © 2020 鈴木公章. All rights reserved.
//

import UIKit

class Common {
    let sampleArray = [HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataBlue, HeatColors.dataGreen, HeatColors.dataGreen, HeatColors.dataLightGreen,
                              HeatColors.dataLightGreen, HeatColors.dataYellow, HeatColors.dataYellow, HeatColors.dataYellow, HeatColors.dataOrange, HeatColors.dataOrange,
                              HeatColors.dataRed, HeatColors.dataOrange, HeatColors.dataOrange, HeatColors.dataYellow, HeatColors.dataYellow, HeatColors.dataYellow,
                              HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataGreen, HeatColors.dataGreen, HeatColors.dataBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue]
    func getHeatColor(data: Double) -> UIColor {
        switch data {
            // kA/m
        case 0..<1.667:
            return UIColor.initWithHex(color24: 0x3F51B5)
        case 1.667..<3.334:
            return UIColor.initWithHex(color24: 0x2196F3)
        case 3.334..<5.001:
            return UIColor.initWithHex(color24: 0x4CAF50)
        case 5.001..<6.668:
            return UIColor.initWithHex(color24: 0x8BC34A)
        case 6.668..<8.335:
            return UIColor.initWithHex(color24: 0xFFEB3B)
        case 8.335..<9.700:
            return UIColor.initWithHex(color24: 0xFF9800)
        case 9.700...:
            return UIColor.initWithHex(color24: 0xf44336)
        default:
            return UIColor.initWithHex(color24: 0x3F51B5)
        }
    }
    
    /// ヒートマップ配列のサンプルを作成（x軸方向のarrayで取得する仮定）
    ///
    /// - Parameters:
    ///   - y: 高さ方向で何層目か
    ///   - z: 縦方向で何層目か（とりあえず9）
    func initHeatMapArray(y: Int, z: Int) -> [Double] {
        // 1, 2段目
        if y >= 0 && y < 2 {
            switch z {
            case 0, 8:
                return [HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue,
                        HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue,
                        HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue,
                        HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue]
            case 1, 7:
                return [HeatColors.dataDarkBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen,
                        HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen,
                        HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen,
                        HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataDarkBlue]
            case 2, 6:
                return [HeatColors.dataBlue, HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen,
                        HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen,
                        HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen,
                        HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataBlue]
            case 3, 5:
                return [HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue,
                        HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue,
                        HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue,
                        HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataLightGreen]
            default:
                return [HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataBlue, HeatColors.dataLightGreen, HeatColors.dataLightGreen]
            }
        }// 1, 2段目
            
        // 3, 4段目
        else if y >= 2 && y < 4 {
            return [HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue,
                    HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue,
                    HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue,
                    HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataBlue]
        }// 3, 4段目
        
        
        // 5段目
        else if y >= 4 && y < 5 {
            switch z {
            case 0, 1, 2, 6, 7, 8:
                return [HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue]
            case 3, 5:
                return [HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataBlue,
                        HeatColors.dataBlue, HeatColors.dataBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue]
            default:
                return [HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataBlue,
                        HeatColors.dataLightGreen, HeatColors.dataBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue]
            }
        }// 5段目
            
        // 6段目
        else if y >= 5 && y < 6 {
            switch z {
            case 0, 1, 7, 8:
                return [HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue]
            case 2, 6:
                return [HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue]
            case 3, 5:
                return [HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataBlue, HeatColors.dataLightGreen,
                        HeatColors.dataLightGreen, HeatColors.dataLightGreen, HeatColors.dataBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue]
            default:
                return [HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataBlue, HeatColors.dataLightGreen,
                        HeatColors.dataOrange, HeatColors.dataLightGreen, HeatColors.dataBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue]
            }
        }// 6段目
        
        // 7段目
        else if y >= 6 && y < 7 {
            switch z {
            case 0, 1, 2, 6, 7, 8:
                return [HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue]
            case 3, 5:
                return [HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataLightGreen,
                        HeatColors.dataOrange, HeatColors.dataLightGreen, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue]
            default:
                return [HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataLightGreen, HeatColors.dataOrange,
                        HeatColors.dataRed, HeatColors.dataOrange, HeatColors.dataLightGreen, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue]
            }
        }// 7段目
            
        // 8段目
        else {
            switch z {
            case 0, 1, 2, 6, 7, 8:
                return [HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue]
            default:
                return [HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataRed,
                        HeatColors.dataRed, HeatColors.dataRed, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue,
                        HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue, HeatColors.dataDarkBlue]
            }
        }// 8段目
    }
}

struct HeatColors {
    static let dataDarkBlue: Double = 1.000
    static let dataBlue: Double = 2.000
//    case lightBlue = 0 //03A9F4
//    case cyan = 0//00BCD4
//    case darkGreen = 0 //009688
    static let dataGreen: Double = 4.000
    static let dataLightGreen: Double = 6.000
//    case lime = 0//CDDC39
    static let dataYellow: Double = 8.000
//    case amber = 0//FFC107
    static let dataOrange: Double = 9.000
//    case lightRed = 0//FF5722
    static let dataRed: Double = 9.800
}

