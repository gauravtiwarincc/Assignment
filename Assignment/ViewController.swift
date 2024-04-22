//
//  ViewController.swift
//  Assignment
//
//  Created by Gaurav Tiwari on 19/04/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel = MediaCoverageViewModel()
    private var imageLoadTasks: [URLSessionDataTask] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupViewModel()
        viewModel.fetchMediaCoverages()
    }
    
    private func setupCollectionView() {
          collectionView.dataSource = self
          collectionView.delegate = self
          collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
          
          // Configure collection view layout
          if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
              layout.minimumLineSpacing = 10
              layout.minimumInteritemSpacing = 10
              let width = (collectionView.bounds.width - 30) / 3 
              layout.itemSize = CGSize(width: width, height: width)
          }
      }
    
    private func setupViewModel() {
         viewModel.onFetchCompleted = { [weak self] in
             DispatchQueue.main.async {
                 self?.collectionView.reloadData()
             }
         }
         viewModel.onError = { error in
             print("Error fetching media coverages: \(error.localizedDescription)")
         }
     }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.mediaCoverages.count
    }
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
            let mediaCoverage = viewModel.mediaCoverages[indexPath.item]
            let imageURL = "https://cimg.acharyaprashant.org/\(mediaCoverage.thumbnail.basePath)/0/\(mediaCoverage.thumbnail.key.rawValue)"
            
            loadImage(for: indexPath, from: imageURL)
            
            return cell
        }


}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3 - 10 // Adjust spacing as needed
        return CGSize(width: width, height: width)
    }
}

extension ViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let mediaCoverage = viewModel.mediaCoverages[indexPath.item]
            let imageURL = "https://cimg.acharyaprashant.org/\(mediaCoverage.thumbnail.basePath)/0/\(mediaCoverage.thumbnail.key.rawValue)"
            loadImage(for: indexPath, from: imageURL)
        }
    }
}

extension ViewController {
    private func loadImage(for indexPath: IndexPath, from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let image = UIImage(data: data) {
                ImageCache.shared.cache(image, for: url) // Cache the image
                DispatchQueue.main.async {
                    if let cell = self?.collectionView.cellForItem(at: indexPath) as? ImageCell {
                        cell.imageView.image = image
                    }
                }
            }
        }
        task.resume()
    }
}


