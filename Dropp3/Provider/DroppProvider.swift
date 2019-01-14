//
//  DroppProvider.swift
//  Dropp3
//
//  Created by McCracken, Steven on 1/12/19.
//  Copyright © 2019 Steven McCracken. All rights reserved.
//

import Foundation
import RealmSwift

protocol DroppProvider {
    var droppService: DroppService { get set }
    func getDropps(around location: Location)
}

class MainDroppProvider {
    var droppService: DroppService
    init(droppService: DroppService) {
        self.droppService = droppService
    }
}

extension MainDroppProvider: DroppProvider {
    func getDropps(around location: Location) {
        droppService.getDropps(around: location, success: { dropps in
            let realmDropps: [RealmDropp] = dropps.map { RealmDropp(dropp: $0) }
            RealmProvider().add(realmDropps, update: true)
        }) { error in
            debugPrint(error)
        }
    }
}
