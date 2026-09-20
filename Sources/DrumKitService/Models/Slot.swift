// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.Slot
import struct DrumKit.Time
import struct DrumKit.Event
import struct DrumKit.Performance
import struct DrumKit.Corps
import struct DrumKit.Division
import struct DrumKit.Ensemble
import struct DrumKit.Feature
import struct Catena.IDFields
import protocol Catena.Valued

public extension Slot {
	typealias ID = Identifier<Identified>
	typealias IDFields = Catena.IDFields<Identified>
	typealias Identified = IdentifiedSlot
}

// MARK: -
public struct IdentifiedSlot: Sendable {
	public let id: Slot.ID
	public let value: Slot
	public let event: Event.Identified
	public let performance: Performance.Identified
	public let feature: Feature.Identified
}

// MARK: -
extension Slot.Identified {
	static func predicate(year: Int) -> PersistDB.Predicate<Self> {
		let calendar = Calendar.current
		// March, matching `Event.Identified` — a narrower window leaves early events with no slots.
		let startOfYear = DateComponents(calendar: calendar, year: year, month: 3).date!
		let endOfYear = calendar.date(byAdding: .year, value: 1, to: startOfYear)!
		return \.event.value.date > startOfYear && \.event.value.date < endOfYear
	}

	static func predicate(eventDetailsURL: URL) -> PersistDB.Predicate<Self> {
		\.event.value.detailsURL == eventDetailsURL
	}

	static func predicate(eventIDs: Set<Event.ID>) -> PersistDB.Predicate<Self> {
		Array(eventIDs).contains(\.event.id)
	}

	// Fetch only the top-N placed slots per event (a DB-level row limit for the fast/list path).
	// Rank 0 is the unscored/sentinel placement, so exclude it rather than counting it as top-N.
	static func predicate(eventIDs: Set<Event.ID>, maxRank: Int) -> PersistDB.Predicate<Self> {
		Array(eventIDs).contains(\.event.id) && \.performance.placement.value.rank >= 1 && \.performance.placement.value.rank <= maxRank
	}

	// Only slots that placed (rank ≥ 1), so an adjudicated event's result count excludes exhibitions.
	static func predicate(placedInEventsWith eventIDs: Set<Event.ID>) -> PersistDB.Predicate<Self> {
		Array(eventIDs).contains(\.event.id) && \.performance.placement.value.rank >= 1
	}

	static func predicate(eventIDs: Set<Event.ID>, corpsIDs: Set<Corps.ID>) -> PersistDB.Predicate<Self> {
		predicate(placedInEventsWith: eventIDs) && Array(corpsIDs).contains(\.performance.corps.id)
	}

	// A season's slots are reachable by their event's date and circuit, which keeps the predicate free of
	// an event-id list whose every element has to be rendered on each query.
	static func predicate(
		year: Int,
		includedCircuitNames: Set<String>,
		includedCircuitAbbreviations: Set<String>
	) -> PersistDB.Predicate<Self> {
		let inYear = predicate(year: year)

		guard let circuitClause = circuitClause(
			names: includedCircuitNames,
			abbreviations: includedCircuitAbbreviations
		) else { return inYear }

		return inYear && circuitClause
	}

	static func predicate(
		year: Int,
		includedCircuitNames: Set<String>,
		includedCircuitAbbreviations: Set<String>,
		divisionID: Division.ID
	) -> PersistDB.Predicate<Self> {
		predicate(
			year: year,
			includedCircuitNames: includedCircuitNames,
			includedCircuitAbbreviations: includedCircuitAbbreviations
		) && \.performance.placement.value.rank >= 1
			&& \.performance.placement.division.id == divisionID
	}

	static func predicate(
		year: Int,
		includedCircuitNames: Set<String>,
		includedCircuitAbbreviations: Set<String>,
		corpsIDs: Set<Corps.ID>
	) -> PersistDB.Predicate<Self> {
		predicate(
			year: year,
			includedCircuitNames: includedCircuitNames,
			includedCircuitAbbreviations: includedCircuitAbbreviations
		) && \.performance.placement.value.rank >= 1
			&& Array(corpsIDs).contains(\.performance.corps.id)
	}

	// The null-sentinel division stands in for placements scored without one, so it is never a division.
	static func predicate(
		divisionedIn year: Int,
		includedCircuitNames: Set<String>,
		includedCircuitAbbreviations: Set<String>
	) -> PersistDB.Predicate<Self> {
		predicate(
			year: year,
			includedCircuitNames: includedCircuitNames,
			includedCircuitAbbreviations: includedCircuitAbbreviations
		) && \.performance.placement.value.rank >= 1
			&& \.performance.placement.division.id != Division.ID.null
	}

	// No names and no abbreviations means no circuit constraint (every circuit is allowed).
	private static func circuitClause(
		names: Set<String>,
		abbreviations: Set<String>
	) -> PersistDB.Predicate<Self>? {
		var clause: PersistDB.Predicate<Self>? = names.isEmpty
			? nil
			: names.contains(\.event.circuit.value.name)

		if !abbreviations.isEmpty {
			let abbreviationClause: PersistDB.Predicate<Self> = abbreviations.map { $0 as String? }.contains(\.event.circuit.value.abbreviation)
			clause = clause.map { $0 || abbreviationClause } ?? abbreviationClause
		}

		return clause
	}

	static func predicate(
		eventID: Event.ID,
		corpsID: Corps.ID?,
		ensembleID: Ensemble.ID?
	) -> PersistDB.Predicate<Self> {
		var predicate: PersistDB.Predicate<Self> = \.event.id == eventID

		if let corpsID {
			predicate = predicate && \.performance.corps.id == corpsID
		} else if let ensembleID {
			predicate = predicate && \.performance.ensemble.id == ensembleID
		}

		return predicate
	}
}

// MARK: -
extension Slot.Identified: Identifiable {
	// MARK: Identifiable
	public typealias RawIdentifier = UUID
}

extension Slot.Identified: Valued {
	// MARK: Valued
	public typealias Value = Slot
}

extension Slot.Identified: PersistDB.Model {
	// MARK: Model
	public enum Path: String, CodingKey {
		case time
		case event
		case performance
		case feature
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.value.time * .time,
		\.event --> .event,
		\.performance -?> .performance,
		\.feature -?> .feature
	)

	public static let schemaName = "slots"

	// MARK: Model
	public static var defaultOrder: [Ordering<Self>] {
		[.init(\.value.time, ascending: true)]
	}
}

// MARK: -
private extension Slot.Identified {
	init(
		id: Slot.ID,
		time: Time?,
		event: Event.Identified,
		performance: Performance.Identified,
		feature: Feature.Identified
	) {
		self.init(
			id: id,
			value: .init(time: time),
			event: event,
			performance: performance,
			feature: feature
		)
	}
}

// MARK: -
public extension [Slot] {
	var time: [Time?] { map(\.time) }
}

// MARK: -
public extension [Slot.Identified] {
	var id: [Slot.ID] { map(\.id) }
	var value: [Slot] { map(\.value) }
	var performance: [Performance.Identified] { map(\.performance) }
	var feature: [Feature.Identified] { map(\.feature) }

	// MARK: Model
	static var schema: Schema<Self> {
		.init(
			Self.init,
			\.id * .id,
			\.value.time * .time,
			\.performance -?> .performance,
			\.feature -?> .feature
		)
	}
}

// MARK: -
private extension [Slot.Identified] {
	init(
		ids: [Slot.ID],
		times: [Time?],
		performances: [Performance.Identified],
		features: [Feature.Identified]
	) {
		let events: [Event.Identified] = []
		self = ids.enumerated().map { index, id in
			.init(
				id: id,
				time: times[index],
				event: events[index],
				performance: performances[index],
				feature: features[index]
			)
		}
	}
}
