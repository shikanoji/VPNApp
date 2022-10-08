//
//  ServiceManager+VPN.swift
//  SysVPN
//
//  Created by Nguyen Dinh Thach on 19/08/2022.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON
import SwiftUI

extension ServiceManager {
    func getServerStats() -> Single<APIResponse<ServerStats>> {
        return request(.getServerStats)
            .map { response in
                let result = try JSONDecoder().decode(APIResponse<ServerStats>.self, from: response.data)
                return result
            }
            .catch { error in
                throw APIError.someError
            }
    }
    
    func getStatsByServer() -> Single<APIResponse<StatusResult>> {
        return request(.getStatsByServerId)
            .map { response in
                let result = try JSONDecoder().decode(APIResponse<StatusResult>.self, from: response.data)
                return result
            }
            .catch { error in
                throw APIError.someError
            }
    }
    
    func getCountryList() -> Single<APIResponse<CountryListResultModel>> {
        return request(.getCountryList)
            .map { response in
                let result = try JSONDecoder().decode(APIResponse<CountryListResultModel>.self, from: response.data)
                return result
            }
            .catch { error in
                throw APIError.someError
            }
    }
    
    func getRequestCertificate(asNewConnection: Bool = false) -> Single<APIResponse<RequestCerAPI>> {
        return request(.getRequestCertificate(asNewConnection: asNewConnection))
            .map { response in
                let result = try JSONDecoder().decode(APIResponse<RequestCerAPI>.self, from: response.data)
                return result
            }
            .catch { error in
                throw APIError.someError
            }
    }
    
    func getListSession(page: Int = 1, limit: Int = 20) -> Single<APIResponse<SessionResult>> {
        return request(.getListSession(page: page, limit: limit))
            .map { response in
                let result = try JSONDecoder().decode(APIResponse<SessionResult>.self, from: response.data)
                return result
            }
            .catch { error in
                throw APIError.someError
            }
    }
    
    func disconnectSession(sessionId: String, terminal: Bool) -> Single<APIResponse<EmptyResult>> {
        return request(.disconnectSession(sessionId: sessionId, terminal: terminal))
            .map { response in
                let result = try JSONDecoder().decode(APIResponse<EmptyResult>.self, from: response.data)
                return result
            }
            .catch { error in
                throw APIError.someError
            }
    }
    
    func getTopicQuestionList() -> Single<APIResponse<[TopicQuestionModel]>> {
        return request(.getTopicQuestionList)
            .map { response in
                let result = try JSONDecoder().decode(APIResponse<[TopicQuestionModel]>.self, from: response.data)
                return result
            }
            .catch { error in
                throw APIError.someError
            }
    }
    
    func getMutihopList() -> Single<APIResponse<[MultihopModel]>> {
        return request(.getMultihopList)
            .map { response in
                let result = try JSONDecoder().decode(APIResponse<[MultihopModel]>.self, from: response.data)
                return result
            }
            .catch { error in
                throw APIError.someError
            }
    }
}

extension PrimitiveSequenceType where Trait == SingleTrait {
    public func subscribe(_ observer: @escaping (SingleEvent<Element>) -> Void) -> Disposable {
        var stopped = false
        return self.primitiveSequence.asObservable().subscribe { event in
            if stopped { return }
            stopped = true

            switch event {
            case .next(let element):
                observer(.success(element))
            case .error(let error):
                observer(.failure(error))
            case .completed:
                observer(.failure(APIError.unknown))
            }
        }
    }
    
    public func subscribe(onSuccess: ((Element) -> Void)? = nil,
                          onFailure: ((Swift.Error) -> Void)? = nil,
                          onDisposed: (() -> Void)? = nil) -> Disposable {
        #if DEBUG
            let callStack = Hooks.recordCallStackOnError ? Thread.callStackSymbols : []
        #else
            let callStack = [String]()
        #endif

        let disposable: Disposable
        if let onDisposed = onDisposed {
            disposable = Disposables.create(with: onDisposed)
        } else {
            disposable = Disposables.create()
        }

        let observer: SingleObserver = { event in
            switch event {
            case .success(let element):
                onSuccess?(element)
                disposable.dispose()
            case .failure(let error):
                if let onFailure = onFailure {
                    onFailure(error)
                } else {
                    Hooks.defaultErrorHandler(callStack, error)
                }
                disposable.dispose()
            }
        }

        return Disposables.create(
            self.primitiveSequence.subscribe(observer),
            disposable
        )
    }
}
