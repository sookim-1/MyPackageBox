//
//  UIView+Extension.swift
//
//  Created by iOS Developer on 2025-05-13
//  Source: https://blog.stackademic.com/10-uiview-extensions-every-ios-developer-should-know-a970d744a624
//  Copyright © 2025 sookim-1. All rights reserved.

import UIKit

extension UIView {

    /// Adds multiple subviews to the view in one call.
    ///
    ///     view.addSubviews(titleLabel, imageView, descriptionLabel, actionButton)
    ///
    /// - Parameters:
    ///   - views: The views to be added as subviews.
    public func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }

}

extension UIView {

    /// Pins the view’s edges to its superview with optional insets.
    ///
    ///     view.pinToSuperview(top: 16, left: 16, bottom: 16, right: 16)
    ///
    /// - Parameters:
    ///   - top:     Top inset from superview's top anchor. Default is 0.
    ///   - left:    Left inset from superview's left anchor. Default is 0.
    ///   - bottom:  Bottom inset from superview's bottom anchor. Default is 0.
    ///   - right:   Right inset from superview's right anchor. Default is 0.
    public func pinToSuperview(
        top: CGFloat = 0,
        left: CGFloat = 0,
        bottom: CGFloat = 0,
        right: CGFloat = 0
    ) {
        guard let superview = superview else {
            assertionFailure("Superview is missing when calling pinToSuperview()")
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: top),
            leftAnchor.constraint(equalTo: superview.leftAnchor, constant: left),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottom),
            rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -right)
        ])
    }

}

extension UIView {

    /// Performs an animation block on the view.
    ///
    ///     view.animate(duration: 1.0) { view in
    ///         view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    ///     }
    ///
    ///     view.animate(duration: 1.0) { view in
    ///         view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    ///     } completion: { finished in
    ///         // Completion handler
    ///     }
    ///
    /// - Parameters:
    ///   - duration: Animation duration in seconds.
    ///   - delay:    Delay before the animation starts. Default is 0.
    ///   - options:  UIView.AnimationOptions for configuring the animation. Default is [].
    ///   - animations: Block containing animation changes.
    ///   - completion: Optional completion handler called when animation ends.
    public func animate(
        duration: TimeInterval,
        delay: TimeInterval = 0,
        options: UIView.AnimationOptions = [],
        animations: @escaping (UIView) -> Void,
        completion: ((Bool) -> Void)? = nil
    ) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: options,
            animations: { animations(self) },
            completion: completion
        )
    }

    /// Fades in the view by animating its alpha from 0 to 1.
    ///
    ///     view.fadeIn()
    ///
    /// - Parameters:
    ///   - duration: Duration of fade-in animation. Default is 0.3.
    ///   - delay:    Delay before the animation starts. Default is 0.
    ///   - completion: Optional handler called when animation ends.
    public func fadeIn(
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        completion: ((Bool) -> Void)? = nil
    ) {
        alpha = 0
        isHidden = false
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: .curveEaseInOut,
            animations: { [weak self] in self?.alpha = 1 },
            completion: completion
        )
    }

    /// Fades out the view by animating its alpha from 1 to 0, then hides it.
    ///
    ///     view.fadeOut()
    ///
    /// - Parameters:
    ///   - duration: Duration of fade-out animation. Default is 0.3.
    ///   - delay:    Delay before the animation starts. Default is 0.
    ///   - completion: Optional handler called when animation ends.
    public func fadeOut(
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        completion: ((Bool) -> Void)? = nil
    ) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: .curveEaseInOut,
            animations: { [weak self] in self?.alpha = 0 },
            completion: { [weak self] finished in
                self?.isHidden = true
                completion?(finished)
            }
        )
    }

}

extension UIView {

    /// Shakes the view horizontally for attention or validation feedback.
    ///
    ///     passwordTextField.shake()
    ///
    /// - Parameters:
    ///   - duration:     Total duration of the shake animation. Default is 0.5.
    ///   - repeatCount:  Number of shake repetitions. Default is 2.
    public func shake(
        duration: TimeInterval = 0.5,
        repeatCount: Float = 2
    ) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = duration
        animation.values = [-10, 10, -8, 8, -5, 5, -3, 3, 0]
        animation.repeatCount = repeatCount
        layer.add(animation, forKey: "shake")
    }

}


extension UIView {

    /// Creates a pulse effect by scaling up and back down.
    ///
    ///     submitButton.pulse()
    ///
    /// - Parameters:
    ///   - duration: Duration of the full pulse cycle. Default is 0.5.
    ///   - scale:    Scale factor for the pulse. Default is 1.1.
    public func pulse(
        duration: TimeInterval = 0.5,
        scale: CGFloat = 1.1
    ) {
        UIView.animate(
            withDuration: duration / 2,
            animations: { [weak self] in
                self?.transform = CGAffineTransform(scaleX: scale, y: scale)
            }, completion: { [weak self] _ in
                UIView.animate(withDuration: duration / 2) {
                    self?.transform = CGAffineTransform.identity
                }
            })
    }

}

extension UIView {

    /// Rounds specified corners of the view.
    ///
    ///     cardView.roundCorners(corners: [.topLeft, .topRight], radius: 12)
    ///
    /// - Parameters:
    ///   - corners: The corners to round (e.g., .topLeft, .bottomRight).
    ///   - radius:  The radius of the rounding.
    public func roundCorners(
        corners: UIRectCorner,
        radius: CGFloat
    ) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIView {

    /// Adds a drop shadow to the view.
    ///
    ///     profileCard.addShadow(color: .darkGray, opacity: 0.2, radius: 8)
    ///
    /// - Parameters:
    ///   - color:    Shadow color. Default is `.black`.
    ///   - opacity:  Shadow opacity. Default is 0.3.
    ///   - offset:   Shadow offset. Default is (0, 2).
    ///   - radius:   Shadow blur radius. Default is 4.
    public func addShadow(
        color: UIColor = .black,
        opacity: Float = 0.3,
        offset: CGSize = CGSize(width: 0, height: 2),
        radius: CGFloat = 4
    ) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }

}

extension UIView {

    /// Adds a gradient layer behind the view’s content.
    ///
    ///     let gradient = headerView.addGradient(
    ///         colors: [.systemBlue, .systemIndigo],
    ///         startPoint: CGPoint(x: 0, y: 0),
    ///         endPoint: CGPoint(x: 1, y: 1)
    ///     )
    ///
    /// - Parameters:
    ///   - colors:     Array of UIColors for the gradient.
    ///   - startPoint: Normalized start point (0...1). Default is (0.5, 0).
    ///   - endPoint:   Normalized end point (0...1). Default is (0.5, 1).
    /// - Returns: The created `CAGradientLayer` instance.
    ///
    /// Use `@discardableResult` to allow calling this method without using the returned layer,
    /// preventing compiler warnings when the gradient is applied directly to the view.
    @discardableResult
    public func addGradient(
        colors: [UIColor],
        startPoint: CGPoint = CGPoint(x: 0.5, y: 0),
        endPoint: CGPoint = CGPoint(x: 0.5, y: 1)
    ) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }

}

extension UIView {

    /// Renders the view and its sublayers into a `UIImage`.
    ///
    ///     let chartImage = chartView.asImage()
    ///
    /// - Returns: A snapshot image of the view.
    public func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { ctx in
            layer.render(in: ctx.cgContext)
        }
    }

}
