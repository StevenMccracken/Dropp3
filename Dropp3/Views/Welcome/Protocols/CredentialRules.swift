//
//  CredentialRules.swift
//  Dropp3
//
//  Created by Steven McCracken on 2/22/20.
//  Copyright © 2020 Steven McCracken. All rights reserved.
//

import Foundation

struct CredentialRules {
  struct Name: CredentialRule {
    typealias Credential = String
    let credential: Credential
    var isValid: Bool {
      return credential.trimmingCharacters(in: .whitespacesAndNewlines).count >= 2
    }
  }

  struct Username: CredentialRule {
    typealias Credential = String
    let credential: Credential
    var isValid: Bool {
      return credential.trimmingCharacters(in: .whitespacesAndNewlines).count >= 8
    }
  }

  struct Password: CredentialRule {
    typealias Credential = String
    let credential: Credential
    var isValid: Bool {
      return credential.trimmingCharacters(in: .whitespacesAndNewlines).count >= 10
    }
  }

  struct ConfirmPassword: DependentCredentialRule {
    typealias Credential = String
    typealias DependentCredential = String
    let credential: Credential
    let dependentCredential: DependentCredential
    var isValid: Bool {
      return Password(credential: credential).isValid && credential == dependentCredential
    }
  }
}
