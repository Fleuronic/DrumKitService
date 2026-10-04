// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.CorpsEra
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol CorpsEraSpec {
	associatedtype CorpsEraList: Scoped<CorpsEraListFields>

	associatedtype CorpsEraListFields: CorpsEraFields

	func listCorpsEras() async -> CorpsEraList
}

// MARK: -
public extension CorpsEraSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	CorpsEraListFields: Fields<CorpsEra.Identified> & Decodable {
	func listCorpsEras() async -> Results<CorpsEraListFields> {
		await fetch()
	}
}
