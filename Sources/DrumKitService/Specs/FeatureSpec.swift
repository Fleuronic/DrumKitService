// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Feature
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol FeatureSpec {
	associatedtype FeatureFetch: Scoped<FeatureFetchFields>

	associatedtype FeatureFetchFields: FeatureFields

	func fetchFeature(named name: String) async -> FeatureFetch
}

// MARK: -
public extension FeatureSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	FeatureFetchFields: Fields<Feature.Identified> & Decodable {
	func fetchFeature(named name: String) async -> SingleResult<FeatureFetchFields?> {
		let results: Results<FeatureFetchFields> = await fetch(
			where: Feature.Identified.predicate(name: name)
		)

		return results.map(\.first)
	}
}
