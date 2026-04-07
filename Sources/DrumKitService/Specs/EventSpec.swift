// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Event
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol EventSpec {
	associatedtype EventList: Scoped<EventListFields>
	associatedtype EventFetch: Scoped<EventFetchFields>

	associatedtype EventListFields: EventFields
	associatedtype EventFetchFields: EventFields

	func listEvents(for year: Int, excludingCircuitsNamed circuitNames: [String]) async -> EventList
	func fetchEvent() async -> EventFetch
}

// MARK: -
public extension EventSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	EventListFields: Fields<Event.Identified> & Decodable,
	EventFetchFields: Fields<Event.Identified> & Decodable {
	func listEvents(for year: Int, excludingCircuitsNamed circuitNames: [String] = []) async -> Results<EventListFields> {
		await fetch(
			where: Event.Identified.predicate(
				year: year,
				excludedCircuitNames: circuitNames
			)
		)
	}

	func fetchEvent() async -> SingleResult<EventFetchFields?> {
		let results: Results<EventFetchFields> = await fetch()
		return results.map(\.first)
	}
}
