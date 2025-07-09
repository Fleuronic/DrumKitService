// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.Feature
import struct Catena.IDFields
import protocol Catena.Valued

public extension Feature {
	typealias ID = Identified.ID
	typealias IDFields = Catena.IDFields<Identified>
	typealias Identified = IdentifiedFeature
}

// MARK: -
public struct IdentifiedFeature: Sendable {
	public let id: Feature.ID
	public let value: Feature
}

// MARK: -
extension Feature.Identified: Identifiable {
	// MARK: Identifiable
	public typealias RawIdentifier = UUID
}

extension Feature.Identified: Valued {
	// MARK: Valued
	public typealias Value = Feature
}

extension Feature.Identified: PersistDB.Model {
	// MARK: Model
	public enum Path: String, CodingKey {
		case name
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.value.name * .name
	)

	public static let schemaName = "features"

	// MARK: Model
	public static var defaultOrder: [Ordering<Self>] {
		[.init(\.value.name, ascending: true)]
	}
}

// MARK: -
private extension Feature.Identified {
	init(
		id: Feature.ID,
		name: String
	) {
		self.init(
			id: id,
			value: .init(name: name)
		)
	}
}

// MARK: -
public extension [Feature] {
	var name: [String] { map(\.name) }
}

// MARK: -
public extension [Feature.Identified] {
	var id: [Feature.ID] { map(\.id) }
	var value: [Feature] { map(\.value) }

	// MARK: Model
	static let schema = Schema<Self>(
		Self.init,
		\.id * .id,
		\.value.name * .name
	)
}

// MARK: -
private extension [Feature.Identified] {
	init(
		ids: [Feature.ID],
		names: [String]
	) {
		self = ids.enumerated().map { index, id in
			.init(
				id: id,
				name: names[index]
			)
		}
	}
}
