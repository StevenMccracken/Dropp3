//
//  CredentialRule.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/22/20.
//

import Foundation

protocol CredentialRule {
  associatedtype Credential
  var credential: Credential { get }
  var isValid: Bool { get }
}

protocol DependentCredentialRule: CredentialRule {
  associatedtype DependentCredential
  /// Dependent credential that can be used for additional validation against `credential`. Should be assumed to be valid already
  var dependentCredential: DependentCredential { get }
}
