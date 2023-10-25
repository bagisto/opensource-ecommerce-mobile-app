//
//  DetectViewModel.swift
//  Runner
//
//  Created by vandana on 04/07/23.
//

import UIKit

protocol DetectedItem: class {
    func DetectedValue(value: String)
}

class DetectViewModel: NSObject {
    
    var TextStringValue: [String] = []
    weak var delegate: DetectedItem?
    
    func getValue(data: [String], completion: ((_ data: Bool) -> Void)) {
        if data.count != 0 {
            TextStringValue = data
            completion(true)
        } else {
            completion(false)
        }
    }
    
}

extension DetectViewModel: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TextStringValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = TextStringValue[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.DetectedValue(value: TextStringValue[indexPath.row])
    }
}

