// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Venue
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol VenueSpec {
	associatedtype VenueList: Scoped<VenueListFields>

	associatedtype VenueListFields: VenueFields

	func listVenues() async -> VenueList
}

// MARK: -
public extension VenueSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	VenueListFields: Fields<Venue.Identified> & Decodable {
	func listVenues() async -> Results<VenueListFields> {
		await fetch()
	}
}
