// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.State
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol StateSpec {
	associatedtype StateFetch: Scoped<StateFetchFields>

	associatedtype StateFetchFields: StateFields

	func fetchState(abbreviatedAs abbreviation: String) async -> StateFetch
}

// MARK: -
public extension StateSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	StateFetchFields: Fields<State.Identified> & Decodable {
	func fetchState(abbreviatedAs abbreviation: String) async -> SingleResult<StateFetchFields?> {
		let results: Results<StateFetchFields> = await fetch(
			where: State.Identified.predicate(abbreviation: abbreviation)
		)

		return results.map(\.first)
	}
}
	