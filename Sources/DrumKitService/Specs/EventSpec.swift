// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Event
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol EventSpec {
	associatedtype EventList: Scoped<EventListFields>

	associatedtype EventListFields: EventFields

	func listEvents(for year: Int, excludingCircuitsNamed circuitNames: [String]) async -> EventList
}

// MARK: -
public extension EventSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	EventListFields: Fields<Event.Identified> & Decodable {
	func listEvents(for year: Int, excludingCircuitsNamed circuitNames: [String] = []) async -> Results<EventListFields> {
		await fetch(
			where: Event.Identified.predicate(
				year: year,
				excludedCircuitNames: circuitNames
			)
		)
	}
}
