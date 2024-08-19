//
//  CoinImageService.swift
//  Crypto
//
//  Created by iCommunity app on 11/08/2024.
//

import Foundation
import SwiftUI
import Combine

actor CoinImageService {
    @Published private(set) var image: UIImage? = nil
    private let coin: Coin
    private var imageSubscription: AnyCancellable?
    private let localFileManager = LocalFileManage.instance
    private let folderName = "coin_images"
    
    init(coin: Coin) {
        self.coin = coin
        Task {
            await getCoinImage()
        }
    }
    
    private func getCoinImage() {
        if let image = localFileManager.getImage(for: coin.id.removeOptional(), in: folderName) {
            self.image = image
            print("Retreived image from file manager!")
        } else {
            downloadCoinImage()
            print("Downloading image...")
        }
    }
    
    private func downloadCoinImage() {
        guard let url = URL(string: coin.image.removeOptional()) else { return }
        imageSubscription = NetworkingManager.download(url: url)
            .tryCompactMap {
                return UIImage(data: $0)
            }
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] image in
                Task { [weak self] in
                    await self?.updateImage(with: image)
                    await self?.imageSubscription?.cancel()
                    self?.localFileManager.saveImage(image: image, imageName: self?.coin.id.removeOptional() ?? "", folderName: self?.folderName ?? "")
                }
            })
    }
    
    private func updateImage(with image: UIImage) {
        self.image = image
    }
}
