// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Corps
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol CorpsSpec {
	associatedtype CorpsList: Scoped<CorpsListFields>
	associatedtype CorpsFetch: Scoped<CorpsFetchFields>

	associatedtype CorpsListFields: CorpsFields
	associatedtype CorpsFetchFields: CorpsFields

	func listCorps() async -> CorpsList
	func fetchCorps(named name: String) async -> CorpsFetch
}

// MARK: -
public extension CorpsSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	CorpsListFields: Fields<Corps.Identified> & Decodable,
	CorpsFetchFields: Fields<Corps.Identified> & Decodable {
	func listCorps() async -> Results<CorpsListFields> {
		await fetch()
	}

	func fetchCorps(named name: String) async -> SingleResult<CorpsFetchFields?> {
		let results: Results<CorpsFetchFields> = await fetch(
			where: Corps.Identified.predicate(name: name)
		)

		return results.map(\.first)
	}
}
