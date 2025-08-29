// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Venue
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol VenueSpec {
	associatedtype VenueFetch: Scoped<VenueFetchFields>

	associatedtype VenueFetchFields: VenueFields

	func fetchVenue(at streetAddress: String) async -> VenueFetch
}

// MARK: -
public extension VenueSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	VenueFetchFields: Fields<Venue.Identified> & Decodable {
	func fetchVenue(at streetAddress: String) async -> SingleResult<VenueFetchFields?> {
		let results: Results<VenueFetchFields> = await fetch(
			where: Venue.Identified.predicate(streetAddress: streetAddress)
		)

		return results.map(\.first)
	}
}
	