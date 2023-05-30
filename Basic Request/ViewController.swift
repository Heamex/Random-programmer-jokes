//
//  ViewController.swift
//  Basic Request
//
//  Created by Nikita Belov on 29.05.23.
//

import UIKit

class ViewController: UIViewController, JokerViewController {
	
	private var jokeLabel: UILabel!
	private var nextButton: UIButton!
	private var activityIndicator: UIActivityIndicatorView!
	private var joker: Joker!
	private var needNewJoke = true
	private var firstPart: String?
	private var delivery: String?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		joker = Joker(delegate: self)
		buildScreen()
	}
	
	private func buildScreen() {
		drawButton()
		drawLabel()
		drawLoadingIndicator()
	}
	private func drawLabel() {
		let jokeLabel =  UILabel()
		jokeLabel.translatesAutoresizingMaskIntoConstraints = false
		jokeLabel.font = UIFont.systemFont(ofSize: 32)
		jokeLabel.numberOfLines = 0
		jokeLabel.text = "Push next button to start"
		jokeLabel.backgroundColor = .clear
		jokeLabel.layer.cornerRadius = 10
		view.addSubview(jokeLabel)
		
		
		NSLayoutConstraint.activate([
			jokeLabel.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -45),
			jokeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			jokeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			jokeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
		])
		self.jokeLabel = jokeLabel
	}
	
	private func drawButton() {
		let nextButton = UIButton(type: .system)
		nextButton.translatesAutoresizingMaskIntoConstraints = false
		nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
		view.addSubview(nextButton)
		
		nextButton.setTitle("Next >", for: .normal)
		nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
		nextButton.titleLabel?.textColor = .black
		nextButton.titleLabel?.tintColor = .black
		nextButton.backgroundColor = .systemGray4
		nextButton.layer.cornerRadius = 5
		
		NSLayoutConstraint.activate([
			nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
			nextButton.heightAnchor.constraint(equalToConstant: 45),
			nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -45)
		])
		self.nextButton = nextButton
	}
	
	private func drawLoadingIndicator() {
		let activityIndicator = UIActivityIndicatorView()
		view.addSubview(activityIndicator)
		activityIndicator.hidesWhenStopped = true
		if activityIndicator.isAnimating {
			activityIndicator.stopAnimating()
		}
		NSLayoutConstraint.activate([
			activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
		self.activityIndicator = activityIndicator
	}
	
	func newJokeBrings(joke: Joke) {
		dimissIndicator()
		firstPart = joke.setup
		delivery = joke.delivery
		
		self.jokeLabel.text = self.firstPart
	}
	
	func sayDelivery() {
		jokeLabel.text = delivery
	}
	
	
	@objc private func nextButtonTapped() {
		if needNewJoke {
			showIcator()
			needNewJoke.toggle()
			joker.makeNewJoke()
		} else {
			sayDelivery()
			needNewJoke.toggle()
		}
	}
	
	func showIcator() {
		var window: UIWindow? {
			return UIApplication.shared.windows.first
		}
		window?.isUserInteractionEnabled = false
		activityIndicator?.startAnimating()
	}
	func dimissIndicator() {
		DispatchQueue.main.async {
			var window: UIWindow? {
				return UIApplication.shared.windows.first
			}
			window?.isUserInteractionEnabled = true
			self.activityIndicator?.startAnimating()
		}
	}

}


