//
//  DemoTableViewController.swift
//  ImageInNavigationBarDemo
//
//  Created by Tung Fam on 11/14/17.
//  Copyright © 2017 Tung Fam. All rights reserved.
//

import UIKit

class DemoTableViewController: UITableViewController {

    let imageView = UIImageView(image: UIImage(named: "image_name"))

    /// WARNING: Change these constants according to your project's design
    private struct Const {
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 40
        /// Spacing from right anchor of safe area to right anchor of Image
        static let ImageRightSpace: CGFloat = 16
        /// Spacing from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomSpaceForLargeState: CGFloat = 12
        /// Spacing from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomSpaceForSmallState: CGFloat = 6
        /// Factor used to multiply your ImageSizeForLargeState to get the Image Size for Small NavBar State. For example: Image size for Large NavBar is 40, Image size for Small NavBar is 32, then value of SmallImageFactor = 32/40 = 0.8
        static let SmallImageFactor: CGFloat = 0.8

        /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 44
        /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true

        title = "Large Title"

        guard let navigationBar = self.navigationController?.navigationBar else { return }

        // Initial setup for image for Large NavBar state since the the screen always has Large NavBar once it gets opened
        navigationBar.addSubview(imageView)
        imageView.layer.cornerRadius = 20.0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor,
                                             constant: -Const.ImageRightSpace),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor,
                                              constant: -Const.ImageBottomSpaceForLargeState),
            imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showImage(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showImage(true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoCell", for: indexPath)
        cell.textLabel?.text = "Sample"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SegueID", sender: nil)
    }

    // MARK: - Delegates

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResizeImage(for: height)
    }

    // MARK: - Private methods

    private func moveAndResizeImage(for height: CGFloat) {
        // Value of difference between icons for large and small states
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - Const.SmallImageFactor) // 8.0

        // This value = 14. It equals to difference of 12 and 6 (bottom spacing for large and small states)
        // Also it adds 8.0 (size difference when the image gets smaller size)
        let maxYTranslation = Const.ImageBottomSpaceForLargeState - Const.ImageBottomSpaceForSmallState + sizeDiff

        if height <= Const.NavBarHeightSmallState {
            // If NavBar height matches or smaller than Small state we tranform image to small state
            imageView.transform = CGAffineTransform.identity
                .scaledBy(x: Const.SmallImageFactor, y: Const.SmallImageFactor)
                .translatedBy(x: sizeDiff, y: maxYTranslation)
        } else if height >= Const.NavBarHeightLargeState {
            // If NavBar height matches or bigger than Large state we tranform image to large state (basically to normal size)
            imageView.transform = CGAffineTransform.identity
                .scaledBy(x: 1.0, y: 1.0)
                .translatedBy(x: 0.0, y: 0.0)
        } else {
            // If NavBar is in between of Small and Large states we tranform image and move bottom and right spacings proportionally to the size of NavBar. This way it creates a smooth animation for image resizing
            let delta = height - Const.NavBarHeightSmallState
            let coeff = delta / (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            let sizeAddendumFactor = coeff * (1.0 - Const.SmallImageFactor)
            let scale = sizeAddendumFactor + Const.SmallImageFactor

            let yTranslation = maxYTranslation - (coeff * Const.ImageBottomSpaceForSmallState + coeff * sizeDiff)
            let xTranslation = sizeDiff - coeff * sizeDiff

            imageView.transform = CGAffineTransform.identity
                .scaledBy(x: scale, y: scale)
                .translatedBy(x: xTranslation, y: yTranslation)
        }
    }
    
    private func showImage(_ show: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.imageView.alpha = show ? 1.0 : 0.0
        }
    }

}

