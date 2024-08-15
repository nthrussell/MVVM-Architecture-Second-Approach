//
//  StorageProvider+Extension.swift
//  MVVM-Architecture
//
//  Created by russel on 15/8/24.
//

import Foundation
import CoreData

@testable import MVVM_Architecture

extension StorageProvider {
    func saveData(data: PokemonDetailModel) {
        _ = data.mapToEntity(persistentContainer.viewContext)
        saveContext()
    }
}

extension StorageProvider {
    func deleteData(data: PokemonDetailModel) {
        delete(name: data.name)
    }
}
