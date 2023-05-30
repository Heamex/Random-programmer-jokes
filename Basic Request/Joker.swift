//
//  Joker.swift
//  Basic Request
//
//  Created by Nikita Belov on 30.05.23.
//

import UIKit

struct Joke: Codable {
	let setup: String
	let delivery: String
}

protocol JokerViewController {
	func newJokeBrings(joke: Joke)
	
}

final class Joker {
	var joke: Joke?
	let delegate: JokerViewController
	
	init(delegate: JokerViewController) {
		self.delegate = delegate
	}
	
	func makeNewJoke(){
		makeRequest()
	}
	
	private func makeRequest(){
		let link = "https://v2.jokeapi.dev/joke/Any?type=twopart"
		guard let url = URL(string: link) else { fatalError("bad link") }
		let request = URLRequest(url: url)
		
		let task = URLSession.shared.dataTask(with: request) {data, response, error in
			guard let httpResponse = response as? HTTPURLResponse,
				  (200...299).contains(httpResponse.statusCode),
				  let data = data else {fatalError("пришла какая-то дич")}
			do {
				let jokeResponse = try JSONDecoder().decode(Joke.self, from: data)
				DispatchQueue.main.async {
					self.delegate.newJokeBrings(joke: jokeResponse)
				}
			}
			catch {
				print("произошла жопа при конвертации шутки в модель\nВот че пришло\n\n\(String(data: data, encoding: .utf8) ?? "какая-то вообще непонятная херня")")
			}
		}
		task.resume()
	}
}
