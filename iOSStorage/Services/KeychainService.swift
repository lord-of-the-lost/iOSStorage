//
//  KeychainService.swift
//  iOSStorage
//
//  Created by Николай Игнатов on 27.05.2023.
//

import Foundation

protocol KeychainServiceProtocol {
    func setPassword(_ password: String, forAccount account: String) -> Bool
    func getPassword(forAccount account: String) -> String?
    func deletePassword(forAccount account: String) -> Bool
}

final class KeychainService: KeychainServiceProtocol {
    func setPassword(_ password: String, forAccount account: String) -> Bool {
        guard let passwordData = password.data(using: .utf8) else {
            return false
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: passwordData
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        return status == errSecSuccess
    }

    func getPassword(forAccount account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess,
            let passwordData = result as? Data,
            let password = String(data: passwordData, encoding: .utf8) {
            return password
        }

        return nil
    }

    func deletePassword(forAccount account: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account
        ]

        let status = SecItemDelete(query as CFDictionary)

        return status == errSecSuccess
    }
}
