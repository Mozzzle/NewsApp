//
//  APIManager.swift
//  NewsApp
//
//  Created by Артем  on 7/13/20.
//  Copyright © 2020 Artem Zagorovski. All rights reserved.
//

import Foundation

protocol JSONDecodable {
    init?(JSON: [String: AnyObject])
}

final class APIService: RemoteNewsService {
    weak var delegate: NewsRemoteServiceDelegate?

    func loadNews(page: Int) {
        guard let url = NewsApiUrlBuilder(page: page).url else { return }
        let request = URLRequest(url: url)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let dataTask = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            guard let httpResponse = response as? HTTPURLResponse else { return }
            switch httpResponse.statusCode {
            case 200:
                do {
                    guard let data = data, let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
                    if let dictionary = json["articles"] as? [[String: AnyObject]] {
                        self.delegate?.didLoadData(dictionary)
                    } else {
                        Logger.shared.logError(error: NewsError.parseDataError)
                        self.delegate?.didLoadData([])
                        return
                    }
                } catch let error as NSError {
                    Logger.shared.logError(error: error)
                }
            case 426:
                self.delegate?.didGetAnError(error: NewsError.tooManyRequests)
                self.delegate?.didLoadData([])
            default:
                print("We have got response status \(httpResponse.statusCode)")
            }
            if let error = error {
                Logger.shared.logError(error: error)
                self.delegate?.didGetAnError(error: error)
            }
        }
        dataTask.resume()
    }
}
