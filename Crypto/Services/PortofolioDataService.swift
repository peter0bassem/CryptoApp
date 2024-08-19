//
//  PortofolioDataService.swift
//  Crypto
//
//  Created by iCommunity app on 15/08/2024.
//

import Foundation
import CoreData

actor PortofolioDataService {
    private let container: NSPersistentContainer
    private let containerName = "PortofolioContainer"
    private let entityName = "PortofolioEntity"
    
    @Published private(set) var portofolios: [PortofolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { [weak self] _, error in
            if let error = error {
                print("Failed to load core data: \(error)")
                return
            }
            Task { [weak self] in
                await self?.getPortofolios()
            }
        }
    }
    
    // MARK: PUBLIC
    func updatePortofolio(coin: Coin, amount: Double) {
        // check if coin is already in portofolio
        if let entity = portofolios.first(where: {$0.coinID == coin.id }) {
            // already saved
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            // add it to entities
            add(coin: coin, amount: amount)
        }
    }
    
    // MARK: PRIVATE
    private func getPortofolios() {
        let request = NSFetchRequest<PortofolioEntity>(entityName: entityName)
        do {
            self.portofolios = try container.viewContext.fetch(request)
        } catch  {
            print("Failed to fetch portofolio request: \(error)")
        }
    }
    
    private func add(coin: Coin, amount: Double) {
        let entity = PortofolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity: PortofolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: PortofolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch {
            print("Failed to save portofolio: \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortofolios()
    }
}
