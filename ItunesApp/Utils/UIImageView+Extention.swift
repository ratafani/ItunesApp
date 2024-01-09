//
//  ImageNetwork.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 06/01/24.
//

import UIKit
//onListen: @escaping (Bool)->Void
extension UIImageView {
    //MARK: download image from network url
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleToFill, onSuccess:@escaping ()->Void) {
        //        contentMode = mode
        DispatchQueue.main.async {
            self.image = UIColor.lightGray.image()
        }
        
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
    //MARK: download from network using url in string
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit,onSuccess:@escaping ()->Void) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode){
            onSuccess()
        }
    }
    
    //MARK: editing image to have radius
    func editImage(){
        if self.frame.width > 50{
            let view = UIView(frame: self.frame)
            
            let gradient = CAGradientLayer()
            
            gradient.frame = view.bounds
            
            gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.8).cgColor]
            
            gradient.locations = [0.5, 1.0]
            
            view.layer.insertSublayer(gradient, at: 0)
            
            self.addSubview(view)
            self.bringSubviewToFront(view)
        }
        self.layer.cornerRadius = 12/*self.frame.width / 2*/
        self.layer.masksToBounds = true
        
    }
    
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
