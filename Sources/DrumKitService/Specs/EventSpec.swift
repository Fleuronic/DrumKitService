// Copyright © Fleuronic LLC. All rights reserved.

import Foundation
import Identity
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

	func listEvents(on date: Date) async -> EventList
	func listEvents(with ids: Set<Event.ID>) async -> EventList
	func listEvents(for year: Int, includingCircuitsNamed names: Set<String>, orAbbreviated abbreviations: Set<String>) async -> EventList
	func fetchEvent(with detailsURL: URL) async -> EventFetch
}

// MARK: -
public extension EventSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	EventListFields: Fields<Event.Identified> & Decodable,
	EventFetchFields: Fields<Event.Identified> & Decodable {
	func listEvents(on date: Date) async -> Results<EventListFields> {
		await fetch(where: Event.Identified.predicate(date: date))
	}

	func listEvents(with ids: Set<Event.ID>) async -> Results<EventListFields> {
		await fetch(where: Event.Identified.predicate(ids: ids))
	}

	func listEvents(for year: Int, includingCircuitsNamed names: Set<String> = [], orAbbreviated abbreviations: Set<String> = []) async -> Results<EventListFields> {
		await fetch(
			where: Event.Identified.predicate(
				year: year,
				includedCircuitNames: names,
				includedCircuitAbbreviations: abbreviations
			)
		)
	}

	func fetchEvent(with detailsURL: URL) async -> SingleResult<EventFetchFields?> {
		let results: Results<EventFetchFields> = await fetch(
			where: Event.Identified.predicate(detailsURL: detailsURL)
		)

		return results.map(\.first)
	}
}
