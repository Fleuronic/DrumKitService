// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.State
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol StateSpec {
	associatedtype StateList: Scoped<StateListFields>

	associatedtype StateListFields: StateFields

	func listStates() async -> StateList
}

// MARK: -
public extension StateSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	StateListFields: Fields<State.Identified> & Decodable {
	func listStates() async -> Results<StateListFields> {
		await fetch()
	}
}
