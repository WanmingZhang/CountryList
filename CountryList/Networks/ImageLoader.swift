//
//  ImageLoader.swift
//  CountryList
//
//  Created by wanming zhang on 12/6/22.
//

import Foundation

import UIKit

class ImageLoader {
    var imageCache = NSCache<NSString,UIImage>()
    var runningReqs = Dictionary<UUID,URLSessionDataTask>()

    func getImage(_ urlStr: NSString) -> UIImage? {
        return imageCache.object(forKey: urlStr)
    }
    func loadImage(from url: URL, completion: @escaping (Result<UIImage,Error>) -> Void) -> UUID? {
        let str = NSString(string: url.absoluteString)
        // 1
        if let image = getImage(str) {
            completion(.success(image))
            return nil
        }
        // 2
        let uuid = UUID()
        
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
            guard let self = self else { return }
            // 3
            defer {
                self.runningReqs.removeValue(forKey:uuid)
            }
            // 4
            guard let data = data, let image = UIImage(data: data) else {
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
                return
            }
            // 5
            // Cache the image.
            self.imageCache.setObject(image, forKey: NSString(string: url.absoluteString))
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }
        
        task.resume()
        // 6
        runningReqs[uuid] = task
        return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
      runningReqs[uuid]?.cancel()
      runningReqs.removeValue(forKey: uuid)
    }
}
