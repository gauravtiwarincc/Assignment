//
//  MediaCoverageViewModel.swift
//  Assignment
//
//  Created by Gaurav Tiwari on 19/04/24.
//

import Foundation


class MediaCoverageViewModel {
    
    private let apiURL = "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100"
    
    var mediaCoverages: [MediaCoveragesModel] = []
    var onFetchCompleted: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    func fetchMediaCoverages() {
        guard let url = URL(string: apiURL) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                self?.onError?(error!)
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Welcome.self, from: data)
                self?.mediaCoverages = response
                self?.onFetchCompleted?()
            } catch {
                self?.onError?(error)
            }
        }.resume()
    }
}
