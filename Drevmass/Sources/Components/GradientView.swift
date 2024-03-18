//
//  GradientView.swift
//  Drevmass
//
//  Created by Aset Bakirov on 17.03.2024.
//

import UIKit

public class CustomGradientView: UIView {
    var startColor:   UIColor = .black { didSet { updateColors() }}
    var midColor:   UIColor = .black { didSet { updateColors() }}
    var endColor:     UIColor = .white { didSet { updateColors() }}
    var startLocation: Double =   0.1 { didSet { updateLocations() }}
    var midLocation: Double =   0.8 { didSet { updateLocations() }}
    var endLocation:   Double =   1.0 { didSet { updateLocations() }}
    var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    
    init(startColor: UIColor, midColor:UIColor, endColor: UIColor, startLocation: Double, midLocation:Double, endLocation: Double, horizontalMode: Bool, diagonalMode: Bool) {
        self.startColor = startColor
        self.midColor = midColor
        self.endColor = endColor
        self.startLocation = startLocation
        self.midLocation = midLocation
        self.endLocation = endLocation
        self.horizontalMode = horizontalMode
        self.diagonalMode = diagonalMode
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, midLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, midColor.cgColor, endColor.cgColor]
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }

}
