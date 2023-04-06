//
//  HomeViewController.swift
//  Moviemax
//
//  Created by Андрей Фроленков on 3.04.23.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {

    var allDataArray = [MultimediaTypeURL: [MultimediaViewModel]]()

    var multimediaLoader: MultimediaLoader?

    override func viewDidLoad() {
        super.viewDidLoad()
        multimediaLoader = MultimediaLoader(delegate: self)
        view.backgroundColor = .green
        fetchAllTypesOfMedia()

    }

    var moviesArray = [MultimediaViewModel]()
    var tvShowsArray = [MultimediaViewModel]()

    func fetchAllTypesOfMedia() {
        multimediaLoader?.getAllTypesOfMediaData { allDataArray in
            self.allDataArray = allDataArray
            print(allDataArray)
        }
    }
}

