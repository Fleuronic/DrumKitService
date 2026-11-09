// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.VenueEra
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol VenueEraSpec {
	associatedtype VenueEraList: Scoped<VenueEraListFields>

	associatedtype VenueEraListFields: VenueEraFields

	func listVenueEras() async -> VenueEraList
}

// MARK: -
public extension VenueEraSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	VenueEraListFields: Fields<VenueEra.Identified> & Decodable {
	func listVenueEras() async -> Results<VenueEraListFields> {
		await fetch()
	}
}
