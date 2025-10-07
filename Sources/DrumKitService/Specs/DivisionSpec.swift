// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Division
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol DivisionSpec {
	associatedtype DivisionFetch: Scoped<DivisionFetchFields>

	associatedtype DivisionFetchFields: DivisionFields

	func fetchDivision(
		name: String, 
		circuit: String
	) async -> DivisionFetch
}

// MARK: -
public extension DivisionSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	DivisionFetchFields: Fields<Division.Identified> & Decodable {
	func fetchDivision(
		name: String, 
		circuit: String
	) async -> SingleResult<DivisionFetchFields?> {
		let results: Results<DivisionFetchFields> = await fetch(
			where: Division.Identified.predicate(
				name: name, 
				circuit: circuit
			)
		)

		return results.map(\.first)
	}
}
	