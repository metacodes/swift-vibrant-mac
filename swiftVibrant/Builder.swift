//
//  Builder.swift
//
//  Created by Felix Liu on 2023/4/8.
//

import AppKit

public typealias Callback<T> = (T)->Void

public class Builder {

    private var _src: NSImage
    private var _opts: Vibrant.Options
    
    init(_ src: NSImage, _ opts: Vibrant.Options = Vibrant.Options()) {
        self._src = src
        self._opts = opts
    }
    public func maxColorCount(_ n: Int)->Builder {
        self._opts.colorCount = n
        return self
    }

    public func maxDimension(_ d: CGFloat)->Builder {
        self._opts.maxDimension = d
        return self
    }

    public func quality(_ q: Int)->Builder {
        self._opts.quality = q
        return self
    }
    
    public func addFilter(_ f: Filter)->Builder {
            self._opts.filters.append(f)
            return self
        }

    public func removeFilter(_ f: Filter)->Builder {
        self._opts.filters.removeAll(where: { (callback: Filter) in
            callback.id == f.id
        })
        return self
    }
    
    public func useGenerator(_ generator: @escaping Generator.generator)->Builder {
        self._opts.generator = generator
        return self
    }

    public func useQuantizer(_ quantizer: @escaping Quantizer.quantizer)->Builder {
        self._opts.quantizer = quantizer
        return self
    }
    
    public func build()->Vibrant {
        return Vibrant(src: self._src, opts: self._opts)
    }
    public func getPalette()->Palette {
        return self.build().getPalette()
    }
    public func getPalette(_ cb: @escaping Callback<Palette>) {
        return self.build().getPalette(cb)
    }

}
