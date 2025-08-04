// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Circuit
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol CircuitSpec {
	associatedtype CircuitFetch: Scoped<CircuitFetchFields>

	associatedtype CircuitFetchFields: CircuitFields

	func fetchCircuit(abbreviatedAs abbreviation: String) async -> CircuitFetch
}

// MARK: -
public extension CircuitSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	CircuitFetchFields: Fields<Circuit.Identified> & Decodable {
	func fetchCircuit(abbreviatedAs abbreviation: String) async -> SingleResult<CircuitFetchFields?> {
		let results: Results<CircuitFetchFields> = await fetch(
			where: Circuit.Identified.predicate(abbreviation: abbreviation)
		)

		return results.map(\.first)
	}
}
