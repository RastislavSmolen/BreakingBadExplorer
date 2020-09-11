//
//  CharacterDetailsViewController.swift
//  BreakingBadExplorer
//
//  Created by Rastislav Smolen on 11/09/20.
//  Copyright © 2020 Rastislav Smolen. All rights reserved.
//

import UIKit
import AlamofireImage

class CharacterDetailsViewController: UIViewController {

	var viewModel: CharacterViewModel!

	@IBOutlet private weak var imageView: UIImageView!
	@IBOutlet private weak var nameLabel: UILabel!
	@IBOutlet private weak var occupationLabel: UILabel!
	@IBOutlet private weak var statusLabel: UILabel!
	@IBOutlet private weak var nicknameLabel: UILabel!
	@IBOutlet private weak var seasonAppearanceLabel: UILabel!

	override func viewDidLoad() {
        super.viewDidLoad()
		display()
    }

	private func display() {
		imageView.layer.cornerRadius = 5

		if let url = viewModel.imageURL {
			let placeholderImage = UIImage(named: "Logo")!
			imageView.af.setImage(withURL: url, placeholderImage: placeholderImage) { (dataResponse) in
				guard let image = dataResponse.value else { return }
				let aspectRatio = image.size.height/image.size.width
				NSLayoutConstraint(item: self.imageView!, attribute: .height, relatedBy: .equal, toItem: self.imageView, attribute: .width, multiplier: aspectRatio, constant: 0).isActive = true
			}
		}

		nameLabel.text = viewModel.name
		occupationLabel.text = viewModel.occupationString
		statusLabel.text = viewModel.status
		nicknameLabel.text = viewModel.nickname
		seasonAppearanceLabel.text = viewModel.appearanceString
	}
}
