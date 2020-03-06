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
