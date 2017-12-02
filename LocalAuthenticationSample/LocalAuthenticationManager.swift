//
//  LocalAuthenticationManager.swift
//  LocalAuthenticationSample
//
//  Created by 大國嗣元 on 2017/12/02.
//  Copyright © 2017年 hideyuki okuni. All rights reserved.
//

import Foundation
import LocalAuthentication

final class LocalAuthenticationManager {
    enum LocalAuthenticationResult {
        case success
        case userFallback
        case cancel
        case error(LocalAuthenticationError)
    }

    enum LocalAuthenticationError {
        case notSupport
        case unknownError
        case authenticationFailed
        case passcodeNotSet
        case systemCancel
    }

    enum LocalAuthenticationBiometryType {
        case touchId
        case faceId
        case none
    }

    static func evaluatePolicy(reply: @escaping (LocalAuthenticationResult) -> Void) {
        let context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            let localizedReason = "指紋認証を行なってください。"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason, reply: { success, error in
                if let error = error {
                    switch LAError(_nsError: error as NSError) {
                    case LAError.userCancel:
                        // キャンセル
                        reply(.cancel)
                    case LAError.userFallback:
                        // パスコードを入力
                        reply(.userFallback)
                    case LAError.authenticationFailed:
                        reply(.error(.authenticationFailed))
                    case LAError.passcodeNotSet:
                        reply(.error(.passcodeNotSet))
                    case LAError.systemCancel:
                        reply(.error(.systemCancel))
                    default:
                        reply(.error(.unknownError))
                    }
                } else if success {
                    reply(.success)
                } else {
                    reply(.error(.unknownError))
                }
            })
        } else {
            reply(.error(.notSupport))
        }
    }

    static var biometryType: LocalAuthenticationBiometryType {
        let context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            if #available(iOS 11.0, *) {
                switch context.biometryType {
                case .typeTouchID:
                    return .touchId
                case .typeFaceID:
                    return .faceId
                case .none:
                    return .none
                }
            } else {
                return .touchId
            }
        } else {
            return .none
        }
    }
}
