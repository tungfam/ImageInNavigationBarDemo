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

    private struct Const {
        static let ImageSizeForLargeState: CGFloat = 40
        static let ImageRightSpaceForLargeState: CGFloat = 16
        static let ImageBottomSpaceForLargeState: CGFloat = 12
        static let ImageBottomSpaceForSmallState: CGFloat = 6
        static let SmallImageFactor: CGFloat = 0.8 // Size for small icon is 32 = 40 * 0.8

        static let NavBarHeightSmallState: CGFloat = 44
        static let NavBarHeightLargeState: CGFloat = 96.5

        static let SummitHeaderNibName = "SummaryHeaderView"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true

        title = "Large Title"

        guard let navigationBar = self.navigationController?.navigationBar else { return }

        navigationBar.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor,
                                                              constant: -Const.ImageRightSpaceForLargeState),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor,
                                                               constant: -Const.ImageBottomSpaceForLargeState),
            imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            ])


        imageView.layer.cornerRadius = 20.0
        imageView.clipsToBounds = true
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

    // MARK: - Delegates

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        print(height)
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
            imageView.transform = CGAffineTransform.identity
                .scaledBy(x: Const.SmallImageFactor, y: Const.SmallImageFactor)
                .translatedBy(x: sizeDiff, y: maxYTranslation)
        } else if height >= Const.NavBarHeightLargeState {
            imageView.transform = CGAffineTransform.identity
                .scaledBy(x: 1.0, y: 1.0)
                .translatedBy(x: 0.0, y: 0.0)
        } else {
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

}
