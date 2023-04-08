//
//  Vibrant.swift
//
//  Created by Felix Liu on 2023/4/8.
//

import Foundation
import AppKit

public class Vibrant {
    
    public struct Options {
        var colorCount: Int = 64
        
        var quality: Int = 5
        
        var quantizer: Quantizer.quantizer = Quantizer.defaultQuantizer
        
        var generator: Generator.generator = Generator.defaultGenerator
        
        var maxDimension: CGFloat?
        
        var filters: [Filter] = [Filter.defaultFilter]
        
        fileprivate var combinedFilter: Filter?
    }
    
    public static func from( _ src: NSImage)->Builder {
        return Builder(src)
    }

    var opts: Options
    var src: NSImage
    
    private var _palette: Palette?
    public var palette: Palette? { _palette }
    
    public init(src: NSImage, opts: Options?) {
        self.src = src
        self.opts = opts ?? Options()
        self.opts.combinedFilter = Filter.combineFilters(filters: self.opts.filters)
    }
    
    static func process(image: Image, opts: Options)->Palette {
        let quantizer = opts.quantizer
        let generator = opts.generator
        let combinedFilter = opts.combinedFilter!
        let maxDimension = opts.maxDimension
        
        image.scaleTo(size: maxDimension, quality: opts.quality)
        
        
        let imageData = image.applyFilter(combinedFilter)
        let swatches = quantizer(imageData, opts)
        let colors = Swatch.applyFilter(colors: swatches, filter: combinedFilter)
        let palette = generator(colors)
        return palette
    }
    
    public func getPalette(_ cb: @escaping Callback<Palette>) {
        DispatchQueue.init(label: "colorProcessor", qos: .background).async {
            let palette = self.getPalette()
            DispatchQueue.main.async {
                cb(palette)
            }
        }
    }
    
    public func getPalette()->Palette {
        let image = Image(image: self.src)
        let palette = Vibrant.process(image: image, opts: self.opts)
        self._palette = palette
        return palette
    }
}
