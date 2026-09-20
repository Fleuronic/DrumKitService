// Copyright © Fleuronic LLC. All rights reserved.

import Foundation
import Identity
import PersistDB
import struct DrumKit.Event
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Catenoid.AnonymousFields
import protocol Catenoid.Database
import protocol Caesura.Storage

public protocol EventSpec {
	associatedtype EventList: Scoped<EventListFields>
	associatedtype EventFetch: Scoped<EventFetchFields>

	associatedtype EventListFields: EventFields
	associatedtype EventFetchFields: EventFields

	func listEvents(on date: Date) async -> EventList
	func listEvents(with ids: Set<Event.ID>) async -> EventList
	func listEvents(onAnyOf dates: Set<Date>, includingCircuitsNamed names: Set<String>, orAbbreviated abbreviations: Set<String>) async -> EventList
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

	func listEvents(onAnyOf dates: Set<Date>, includingCircuitsNamed names: Set<String> = [], orAbbreviated abbreviations: Set<String> = []) async -> Results<EventListFields> {
		await fetch(
			where: Event.Identified.predicate(
				dates: dates,
				includedCircuitNames: names,
				includedCircuitAbbreviations: abbreviations
			)
		)
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

// MARK: -
public extension EventSpec where
	Self: Catenoid.Database & ResultProviding,
	Store == PersistDB.Store<ReadWrite>,
	Error == Never {
	/// The season's distinct event dates, collapsed by the database rather than by materializing every event.
	func listEventDates<Fields: Catenoid.AnonymousFields<Event.Identified>>(
		for year: Int,
		includingCircuitsNamed names: Set<String> = [],
		orAbbreviated abbreviations: Set<String> = []
	) async -> Results<Fields> {
		await fetchAnonymous(
			where: Event.Identified.predicate(
				year: year,
				includedCircuitNames: names,
				includedCircuitAbbreviations: abbreviations
			)
		)
	}

	/// The season's latest dates, newest first.
	func listEventDates<Fields: Catenoid.AnonymousFields<Event.Identified>>(
		for year: Int,
		includingCircuitsNamed names: Set<String> = [],
		orAbbreviated abbreviations: Set<String> = [],
		mostRecent limit: Int
	) async -> Results<Fields> {
		await fetchAnonymous(
			where: Event.Identified.predicate(
				year: year,
				includedCircuitNames: names,
				includedCircuitAbbreviations: abbreviations
			),
			sortedBy: \.value.date,
			ascending: false,
			limit: limit
		)
	}

	/// The season's most recent elapsed dates, excluding shows whose names carry any of `excluded`.
	func listEventDates<Fields: Catenoid.AnonymousFields<Event.Identified>>(
		for year: Int,
		includingCircuitsNamed names: Set<String> = [],
		orAbbreviated abbreviations: Set<String> = [],
		onOrBefore date: Date,
		excludingShowsNamed excluded: [String],
		mostRecent limit: Int
	) async -> Results<Fields> {
		await fetchAnonymous(
			where: Event.Identified.predicate(
				year: year,
				includedCircuitNames: names,
				includedCircuitAbbreviations: abbreviations,
				on: date,
				excludingShowsNamed: excluded
			),
			sortedBy: \.value.date,
			ascending: false,
			limit: limit
		)
	}

	func countEvents(
		for year: Int,
		includingCircuitsNamed names: Set<String> = [],
		orAbbreviated abbreviations: Set<String> = []
	) async -> SingleResult<Int> {
		await count(
			Event.Identified.self,
			where: Event.Identified.predicate(
				year: year,
				includedCircuitNames: names,
				includedCircuitAbbreviations: abbreviations
			)
		)
	}
}
