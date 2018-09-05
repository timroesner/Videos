//
//  MoviesDetailPip.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 9/4/18.
//  Copyright © 2018 Tim Roesner. All rights reserved.
//

import AVKit

extension UIViewController: AVPlayerViewControllerDelegate {
    func presentPlayer(withURL: URL) {
        let playerVC = AVPlayerViewController()
        playerVC.delegate = self
        playerVC.player = AVPlayer(url: withURL)
        self.present(playerVC, animated: true) {
            playerVC.player?.play()
        }
    }
    
    public func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        present(playerViewController, animated: true) {
            completionHandler(true)
        }
    }
}
