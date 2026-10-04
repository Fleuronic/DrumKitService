// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.DivisionSubordination
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol DivisionSubordinationSpec {
	associatedtype DivisionSubordinationList: Scoped<DivisionSubordinationListFields>

	associatedtype DivisionSubordinationListFields: DivisionSubordinationFields

	func listDivisionSubordinations() async -> DivisionSubordinationList
}

// MARK: -
public extension DivisionSubordinationSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	DivisionSubordinationListFields: Fields<DivisionSubordination.Identified> & Decodable {
	func listDivisionSubordinations() async -> Results<DivisionSubordinationListFields> {
		await fetch()
	}
}
