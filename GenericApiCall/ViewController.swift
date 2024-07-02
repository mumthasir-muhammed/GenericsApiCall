//
//  ViewController.swift
//  GenericApiCall
//
//  Created by Mumthasir VP on 02/07/24.
//

import UIKit

class ViewController: UIViewController {
    // IF YOU WANT TO TRY WITH ANY OTHER API ADD ENDPONT AND MODEL BELOW, THEN TRY
   
    // Model One
    struct Things: Codable {
        let id, name: String
    }
    typealias ThingsList = [Things]

    
    // Model Two
    struct Brewery: Codable {
        var name : String
        var city: String
        var country: String
    }
    typealias BreweryList = [Brewery]
    
    // Two API End points
    struct Constants {
        static var urlThings = "https://api.restful-api.dev/objects"
        static var urlBrewery = "https://api.openbrewerydb.org/v1/breweries"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genericApiCall(urlString: Constants.urlBrewery, type: BreweryList.self) {  result in
            switch result {
            case .success(let responseModel):
                if ((responseModel as? BreweryList) != nil) {
                    print("#BreweryList Names: \(responseModel.map({ $0.name }))")
                } else if ((responseModel as? ThingsList) != nil){
                    print("ThingsList #Name: \(responseModel.map({ $0.name }))")
                }
            case .failure(let error):
                print("#Error:\(error)")
            }
        }
    }
    
    // Api call with generic type
    func genericApiCall<T: Codable>(
        urlString: String,
        type:T.Type,
        completion: @escaping (Result<T, Error>) -> Void)
    {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { result, _, error in
            do {
                let response = try JSONDecoder().decode(type.self, from: result!)
                DispatchQueue.main.async { completion(.success(response)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }
}


