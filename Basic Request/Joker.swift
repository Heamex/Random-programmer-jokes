//
//  Joker.swift
//  Basic Request
//
//  Created by Nikita Belov on 30.05.23.
//

// MARK: API INFO: https://sv443.net/

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
				print("Произошла ошибка при конвертации шутки в модель\nОтвет сервера: \(String(data: data, encoding: .utf8) ?? "<ERROR: Невозможно расшифровать ответ сервера>")")
			}
		}
		task.resume()
	}
}
