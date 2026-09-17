// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Division
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol DivisionSpec {
	associatedtype DivisionFetch: Scoped<DivisionFetchFields>

	associatedtype DivisionFetchFields: DivisionFields

	func fetchDivision(named name: String, inCircuitNamed circuitName: String, abbreviatedAs circuitAbbreviation: String?) async -> DivisionFetch
}

// MARK: -
public extension DivisionSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	DivisionFetchFields: Fields<Division.Identified> & Decodable {
	// Not a protocol requirement: only storage-backed conformers can list, and the API has no such query.
	func listDivisions() async -> Results<DivisionFetchFields> {
		await fetch()
	}

	func fetchDivision(named name: String, inCircuitNamed circuitName: String, abbreviatedAs circuitAbbreviation: String?) async -> SingleResult<DivisionFetchFields?> {
		let results: Results<DivisionFetchFields> = await fetch(
			where: Division.Identified.predicate(
				name: name,
				circuitName: circuitName,
				circuitAbbreviation: circuitAbbreviation
			)
		)

		return results.map(\.first)
	}
}
