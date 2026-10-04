// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.FeatureRole
import protocol Catena.Scoped
import protocol Catena.ResultProviding
import protocol Catenoid.Fields
import protocol Caesura.Storage

public protocol FeatureRoleSpec {
	associatedtype FeatureRoleList: Scoped<FeatureRoleListFields>

	associatedtype FeatureRoleListFields: FeatureRoleFields

	func listFeatureRoles() async -> FeatureRoleList
}

// MARK: -
public extension FeatureRoleSpec where
	Self: Storage & ResultProviding,
	Error == StorageError,
	FeatureRoleListFields: Fields<FeatureRole.Identified> & Decodable {
	func listFeatureRoles() async -> Results<FeatureRoleListFields> {
		await fetch()
	}
}
