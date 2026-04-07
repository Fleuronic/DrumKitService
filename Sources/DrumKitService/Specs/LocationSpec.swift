// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Location
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol LocationSpec {
	associatedtype LocationFetch: Scoped<LocationFetchFields>

	associatedtype LocationFetchFields: LocationFields

	func fetchLocation(for city: String, in state: String) async -> LocationFetch
}

// MARK: -
public extension LocationSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	LocationFetchFields: Fields<Location.Identified> & Decodable {
	func fetchLocation(for city: String, in state: String) async -> SingleResult<LocationFetchFields?> {
		let results: Results<LocationFetchFields> = await fetch(
			where: Location.Identified.predicate(
				city: city,
				state: state
			)
		)

		return results.map(\.first)
	}
}
