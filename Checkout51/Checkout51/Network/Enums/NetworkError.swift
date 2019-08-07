//
//  NetworkError.swift
//  NetworkLayer
//
//  Created by Marcin Jackowski on 06/09/2018.
//  Copyright © 2018 CocoApps. All rights reserved.
//

enum NetworkError:String {
    case network = "Network Error"
    case server = "Server Error"
    case unknown = "Somthing is wrong!"
    case parsingError = "Wrong data fetched"
    case noJSONData = "No Data"
}
