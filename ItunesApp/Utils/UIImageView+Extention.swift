//
//  ImageNetwork.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 06/01/24.
//

import UIKit
//onListen: @escaping (Bool)->Void
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleToFill, onSuccess:@escaping ()->Void) {
//        contentMode = mode
        self.image = UIImage(systemName: "circle.dotted")
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                onSuccess()
//                self?.contentMode = .scaleAspectFill
//                self?.asCircle()
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit,onSuccess:@escaping ()->Void) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode){
            onSuccess()
        }
    }
    
    func asCircle(){
          self.layer.cornerRadius = self.frame.width / 2;
          self.layer.masksToBounds = true
        self.layer.masksToBounds = true
      }

}
