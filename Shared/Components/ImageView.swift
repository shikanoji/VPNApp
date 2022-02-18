//
//  ImageView.swift
//  SysVPN
//
//  Created by Da Phan Van on 20/01/2022.
//

import Foundation
import Combine
import SwiftUI

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }
    
    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}

struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage()
    @State var size: CGFloat = 100
    
    init(withURL url:String, size: CGFloat = 100) {
        self.size = size
        imageLoader = ImageLoader(urlString:url)
    }
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width:size, height:size)
            .onReceive(imageLoader.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage()
            }
    }
}
