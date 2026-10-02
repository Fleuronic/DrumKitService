// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.FeatureRole
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol FeatureRoleSpec {}

// MARK: -
public extension FeatureRoleSpec where
	Self: Storage & ResultProviding,
	Error == StorageError {
	func listFeatureRoles<ListFields: FeatureRoleFields & Fields<FeatureRole.Identified> & Decodable>() async -> Results<ListFields> {
		await fetch()
	}
}
