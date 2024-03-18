

import Foundation
class TriviaService {
  static func fetchQuestion(completion: (([TriviaQuestion]) -> Void)? = nil) {
      let url = URL(string: "https://opentdb.com/api.php?amount=5")!
      // create a data task and pass in the URL
      let task = URLSession.shared.dataTask(with: url) { data, response, error in
        // this closure is fired when the response is received
        guard error == nil else {
          assertionFailure("Error: \(error!.localizedDescription)")
          return
        }
        guard let httpResponse = response as? HTTPURLResponse else {
          assertionFailure("Invalid response")
          return
        }
        guard let data = data, httpResponse.statusCode == 200 else {
          assertionFailure("Invalid response status code: \(httpResponse.statusCode)")
          return
        }
          do {
              let decoder = JSONDecoder()
              let response = try decoder.decode(TriviaAPIResponse.self, from: data)
              DispatchQueue.main.async {
                  completion?(response.results)
              }
          } catch {
              print("Error decoding data: \(error.localizedDescription)")
          }

      }
      task.resume() // resume the task and fire the request
  }
}
