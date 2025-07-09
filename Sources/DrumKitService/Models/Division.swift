// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.Division
import struct Catena.IDFields
import protocol Catena.Valued

public extension Division {
	typealias ID = Identified.ID
	typealias IDFields = Catena.IDFields<Identified>
	typealias Identified = IdentifiedDivision
}

// MARK: -
public struct IdentifiedDivision: Sendable {
	public let id: Division.ID
	public let value: Division
}

// MARK: -
extension Division.Identified: Identifiable {
	// MARK: Identifiable
	public typealias RawIdentifier = UUID
}

extension Division.Identified: Valued {
	// MARK: Valued
	public typealias Value = Division
}

extension Division.Identified: PersistDB.Model {
	// MARK: Model
	public enum Path: String, CodingKey {
		case name
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.value.name * .name
	)

	public static let schemaName = "divisions"

	// MARK: Model
	public static var defaultOrder: [Ordering<Self>] {
		[.init(\.value.name, ascending: true)]
	}
}

// MARK: -
private extension Division.Identified {
	init(
		id: Division.ID,
		name: String
	) {
		self.init(
			id: id,
			value: .init(name: name)
		)
	}
}

// MARK: -
public extension [Division] {
	var name: [String] { map(\.name) }
}

// MARK: -
public extension [Division.Identified] {
	var id: [Division.ID] { map(\.id) }
	var value: [Division] { map(\.value) }

	// MARK: Model
	static let schema = Schema<Self>(
		Self.init,
		\.id * .id,
		\.value.name * .name
	)
}

// MARK: -
private extension [Division.Identified] {
	init(
		ids: [Division.ID],
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
