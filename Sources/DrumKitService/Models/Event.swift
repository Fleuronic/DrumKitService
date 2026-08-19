// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.Event
import struct DrumKit.Circuit
import struct DrumKit.Location
import struct DrumKit.Show
import struct DrumKit.Venue
import struct DrumKit.Slot
import struct Catena.IDFields
import protocol Catena.Valued

public extension Event {
	typealias ID = Identified.ID
	typealias IDFields = Catena.IDFields<Identified>
	typealias Identified = IdentifiedEvent
}

// MARK: -
public struct IdentifiedEvent: Sendable {
	public let id: Event.ID
	public let value: Event
	public let circuit: Circuit.Identified
	public let location: Location.Identified
	public let show: Show.Identified
	public let venue: Venue.Identified
	public let slots: [Slot.Identified]
}

// MARK: -
extension Event.Identified {
	static func predicate(detailsURL: URL) -> PersistDB.Predicate<Self> {
		\.value.detailsURL == detailsURL
	}

	static func predicate(date: Date) -> PersistDB.Predicate<Self> {
		\.value.date == date
	}

	static func predicate(dates: Set<Date>) -> PersistDB.Predicate<Self> {
		Array(dates).contains(\.value.date)
	}

	static func predicate(
		year: Int,
		includedCircuitNames: Set<String>,
		includedCircuitAbbreviations: Set<String>
	) -> PersistDB.Predicate<Self> {
		let calendar = Calendar.current
		let startOfYear = DateComponents(calendar: calendar, year: year, month: 3).date!
		let endOfYear = calendar.date(byAdding: .year, value: 1, to: startOfYear)!
		let inYear: PersistDB.Predicate<Self> = \.value.date > startOfYear && \.value.date < endOfYear
		// No names and no abbreviations means no circuit constraint (every circuit is allowed).
		var circuitClause: PersistDB.Predicate<Self>? = includedCircuitNames.isEmpty
			? nil
			: includedCircuitNames.contains(\.circuit.value.name)
		for abbreviation in includedCircuitAbbreviations {
			let clause: PersistDB.Predicate<Self> = \.circuit.value.abbreviation == abbreviation
			circuitClause = circuitClause.map { $0 || clause } ?? clause
		}
		guard let circuitClause else { return inYear }
		return inYear && circuitClause
	}
}

// MARK: -
extension Event.Identified: Identifiable {
	// MARK: Identifiable
	public typealias RawIdentifier = UUID
}

extension Event.Identified: Valued {
	// MARK: Valued
	public typealias Value = Event
}

extension Event.Identified: PersistDB.Model {
	// MARK: Model
	public enum Path: String, CodingKey {
		case date
		case detailsURL = "details_url"
		case scoresURL = "scores_url"
		case circuit
		case location
		case show
		case venue
		case slots
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.value.date * .date,
		\.value.detailsURL * .detailsURL,
		\.value.scoresURL * .scoresURL,
		\.circuit -?> .circuit,
		\.location --> .location,
		\.show -?> .show,
		\.venue -?> .venue,
		\.slots <<- \.event
	)

	public static let schemaName = "events"

	// MARK: Model
	public static var defaultOrder: [Ordering<Self>] {
		[.init(\.value.date, ascending: true)]
	}
}

// MARK: -
private extension Event.Identified {
	init(
		id: Event.ID,
		date: Date,
		detailsURL: URL?,
		scoresURL: URL?,
		circuit: Circuit.Identified,
		location: Location.Identified,
		show: Show.Identified,
		venue: Venue.Identified,
		slots: [Slot.Identified]
	) {
		self.init(
			id: id,
			value: .init(
				date: date,
				detailsURL: detailsURL,
				scoresURL: scoresURL
			),
			circuit: circuit,
			location: location,
			show: show,
			venue: venue,
			slots: slots
		)
	}
}
