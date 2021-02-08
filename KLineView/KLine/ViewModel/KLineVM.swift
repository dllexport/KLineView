//
//  KLineViewModel.swift
//  CCSwift
//
//  Created by job on 2019/1/22.
//  Copyright © 2019 我是花轮. All rights reserved.
//

import UIKit
import SwiftyJSON


class KLineVM: NSObject {
    static let sharedInstance = KLineVM()
    
    lazy var data: [KLineModel] = {
        if let path = Bundle.main.path(forResource: "kline.json", ofType: nil) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let jsonData : Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                var jsonArr = jsonData as! [Any]
                jsonArr.reverse()
                let lines = jsonArr.map { (element: Any) -> KLineModel in
                    let obj = (element as! [Any])
                    let open = Double(obj[1] as! String)!
                    let close = Double(obj[4] as! String)!
                    let high = Double(obj[2] as! String)!
                    let low = Double(obj[3] as! String)!
                    let volume = Double(obj[5] as! String)!
                    return KLineModel(closeprice: close, openprice: open, highestprice: high, lowestprice: low, turnovervol: volume, avg_5: 0, avg_10: 0, avg_20: 0)
                }
                return lines
              } catch {
                   return [KLineModel]()
              }
        }
        return [KLineModel]()
    }()
    
    /// cell宽度(打横放)
    var cellHeight = kLineViewCellDefaultHeight
    /// price极高值 默认0
    var priceMax: CGFloat = 10
    /// price极小值 默认0
    var priceMin: CGFloat = 0
    /// 交易量极高值 默认0
    var volumeMax: CGFloat = 50000000

    /// 计算价格K线柱在cell中的位置
    ///
    /// - Parameter data: 数据
    /// - Returns: 位置
    public func getKLinePriceRect(_ data: KLineModel) -> CGRect {
        let dataMax: CGFloat = CGFloat([data.openprice, data.closeprice].max()!)
        let dataMin: CGFloat = CGFloat([data.openprice, data.closeprice].min()!)
        
        let rect = CGRect.init(x: self.getKLinePriceTopDis(dataMax), y: kLinePriceViewCellSeg, width: self.getKLinePriceTopDis(dataMin) - self.getKLinePriceTopDis(dataMax), height: cellHeight - 2 * kLinePriceViewCellSeg)
        return rect
    }
    
    /// 计算交易量K线柱在cell中的位置
    ///
    /// - Parameter data: 数据
    /// - Returns: 位置
    public func getKLineVolumeRect(_ data: KLineModel) -> CGRect {
        let dataMax: CGFloat =  CGFloat(data.turnovervol)
        let rect = CGRect.init(x: self.getKLineVolumeTopDis(dataMax), y: kLinePriceViewCellSeg, width: kLineVolumeViewHeight - self.getKLineVolumeTopDis(dataMax), height: cellHeight - 2 * kLinePriceViewCellSeg)
        return rect
    }
    
    
    /// 计算这个值在cell中距上方位置
    ///
    /// - Parameter data: 数值
    /// - Returns:距上方位置
    public func getKLineVolumeTopDis(_ data: CGFloat) -> CGFloat {
        
        // 假如当前数据没有最高值 返回0
        if priceMax == 0 || data == priceMax{
            return 0
        }
        let top = (volumeMax - data) / volumeMax * kLineVolumeViewHeight
        return top
    }
    
    /// 计算这个值在cell中距上方位置
    ///
    /// - Parameter data: 数值
    /// - Returns:距上方位置
    public func getKLinePriceTopDis(_ data: CGFloat) -> CGFloat {
        // 假如当前数据没有最高值 返回0
        if priceMax == 0 {
            return 0
        }
        let top = (priceMax - data) / (priceMax - priceMin) * (kLinePriceViewHeight - kLinePriceViewSeg * 2) + kLinePriceViewSeg
        return top
    }
}
