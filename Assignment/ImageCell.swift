//
//  ImageCell.swift
//  Assignment
//
//  Created by Gaurav Tiwari on 19/04/24.
//

import UIKit
import AVFoundation


class ImageCell: UICollectionViewCell {
    let imageView: CenterCropImageView = {
           let imageView = CenterCropImageView()
           imageView.contentMode = .scaleAspectFill
           imageView.clipsToBounds = true
           return imageView
       }()
       
       var imageLoadTask: URLSessionDataTask?
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           setupViews()
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       override func prepareForReuse() {
           super.prepareForReuse()
           // Cancel ongoing image loading task
           imageLoadTask?.cancel()
           imageView.image = nil
       }
       
       private func setupViews() {
           addSubview(imageView)
           imageView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               imageView.topAnchor.constraint(equalTo: topAnchor),
               imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
               imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
               imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
           ])
       }
}


class CenterCropImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if let image = image {
            let imageSize = image.size
            let viewSize = bounds.size
            let scale = max(viewSize.width / imageSize.width, viewSize.height / imageSize.height)
            let scaledImageSize = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
            let origin = CGPoint(x: (viewSize.width - scaledImageSize.width) / 2, y: (viewSize.height - scaledImageSize.height) / 2)
            let rect = CGRect(origin: origin, size: scaledImageSize)
            layer.contentsRect = AVMakeRect(aspectRatio: imageSize, insideRect: rect)
        }
    }
}

// MARK: - ImageCache

class ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    private let cacheQueue = DispatchQueue(label: "com.example.imageCache")
    
    func image(for url: URL) -> UIImage? {
        return cacheQueue.sync {
            return cache.object(forKey: url.absoluteString as NSString)
        }
    }
    
    func cache(_ image: UIImage, for url: URL) {
        cacheQueue.async { [weak self] in
            self?.cache.setObject(image, forKey: url.absoluteString as NSString)
        }
    }
}


