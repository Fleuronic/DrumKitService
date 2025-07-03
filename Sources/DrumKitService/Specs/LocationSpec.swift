// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Location
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol LocationSpec {
	associatedtype LocationList: Scoped<LocationListFields>

	associatedtype LocationListFields: LocationFields

	func listLocations() async -> LocationList
}

// MARK: -
public extension LocationSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	LocationListFields: Fields<Location.Identified> & Decodable {
	func listLocations() async -> Results<LocationListFields> {
		await fetch()
	}
}
