// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Ensemble
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol EnsembleSpec {
	associatedtype EnsembleFetch: Scoped<EnsembleFetchFields>

	associatedtype EnsembleFetchFields: EnsembleFields

	func fetchEnsemble(named name: String) async -> EnsembleFetch
}

// MARK: -
public extension EnsembleSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	EnsembleFetchFields: Fields<Ensemble.Identified> & Decodable {
	func fetchEnsemble(named name: String) async -> SingleResult<EnsembleFetchFields?> {
		let results: Results<EnsembleFetchFields> = await fetch(
			where: Ensemble.Identified.predicate(name: name)
		)

		return results.map(\.first)
	}
}
