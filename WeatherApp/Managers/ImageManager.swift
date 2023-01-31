//
//  ImageManager.swift
//  WeatherApp
//
//  Created by Brandt Dary on 1/30/23.
//

import UIKit

class ImageManager {
    
    static let shared = ImageManager()
    
    func weatherIcon(for code:String, completionHandler: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(code)@2x.png") else {
            DispatchQueue.main.async {
                completionHandler(nil)
            }
            return
        }
        
        imageFor(url: url) { image in
            DispatchQueue.main.async {
                completionHandler(image)
            }
        }
    }
    
    
    func imageFor(url: URL!, completionHandler: @escaping (UIImage?) -> ()) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard error == nil, data != nil else {
                completionHandler(nil)
                return
            }
            DispatchQueue.global(qos: .userInteractive).async {
                if let image = UIImage(data: data!) {
                    completionHandler(image)
                }
            }
        })
        
        task.priority = URLSessionTask.highPriority
        task.resume()
    }
    
}
