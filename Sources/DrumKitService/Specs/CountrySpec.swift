// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Country
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol CountrySpec {
	associatedtype CountryFetch: Scoped<CountryFetchFields>

	associatedtype CountryFetchFields: CountryFields

	func fetchCountry(named name: String) async -> CountryFetch
}

// MARK: -
public extension CountrySpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	CountryFetchFields: Fields<Country.Identified> & Decodable {
	func fetchCountry(named name: String) async -> SingleResult<CountryFetchFields?> {
		let results: Results<CountryFetchFields> = await fetch(
			where: Country.Identified.predicate(name: name)
		)

		return results.map(\.first)
	}
}
	