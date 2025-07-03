// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Corps
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol CorpsSpec {
	associatedtype CorpsList: Scoped<CorpsListFields>

	associatedtype CorpsListFields: CorpsFields

	func listCorps() async -> CorpsList
}

// MARK: -
public extension CorpsSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	CorpsListFields: Fields<Corps.Identified> & Decodable {
	func listCorps() async -> Results<CorpsListFields> {
		await fetch()
	}
}
