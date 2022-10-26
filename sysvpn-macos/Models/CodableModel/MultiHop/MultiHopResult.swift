//
//  MultiHopResult.swift
//
//  Created by doragon on 24/10/2022
//  Copyright (c) . All rights reserved.
//

import Foundation

class MultiHopResult: Codable {

  enum CodingKeys: String, CodingKey {
    case entry
    case exit
  }

  var entry: MultiHopEntry?
  var exit: MultiHopExit?

    //custom
    var cacheNode: NodePoint? 

    required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    entry = try container.decodeIfPresent(MultiHopEntry.self, forKey: .entry)
    exit = try container.decodeIfPresent(MultiHopExit.self, forKey: .exit)
  }
    
 
    

}



struct MultiHopSaveWraper: Codable {

    enum CodingKeys: String, CodingKey {
        case hop
    }

    var hop: [MultiHopResult]?


    func saveListMultiHop() {
        self.saveFile(fileName: .keySaveMutilHop)
    }

    static func getListMultiHop() -> MultiHopSaveWraper? {
        return MultiHopSaveWraper.readFile(fileName: .keySaveMutilHop) as? MultiHopSaveWraper
    }


}
