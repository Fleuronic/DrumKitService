// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Show
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol ShowSpec {
	associatedtype ShowFetch: Scoped<ShowFetchFields>

	associatedtype ShowFetchFields: ShowFields

	func fetchShow(named name: String) async -> ShowFetch
}

// MARK: -
public extension ShowSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	ShowFetchFields: Fields<Show.Identified> & Decodable {
	func fetchShow(named name: String) async -> SingleResult<ShowFetchFields?> {
		let results: Results<ShowFetchFields> = await fetch(
			where: Show.Identified.predicate(name: name)
		)

		return results.map(\.first)
	}
}
