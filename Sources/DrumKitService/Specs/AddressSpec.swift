// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Address
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol AddressSpec {
	associatedtype AddressFetch: Scoped<AddressFetchFields>

	associatedtype AddressFetchFields: AddressFields

	func fetchAddress(at streetAddress: String, zipCode: String) async -> AddressFetch
}

// MARK: -
public extension AddressSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	AddressFetchFields: Fields<Address.Identified> & Decodable {
	func fetchAddress(at streetAddress: String, zipCode: String) async -> SingleResult<AddressFetchFields?> {
		let results: Results<AddressFetchFields> = await fetch(
			where: Address.Identified.predicate(streetAddress: streetAddress, zipCode: zipCode)
		)

		return results.map(\.first)
	}
}
