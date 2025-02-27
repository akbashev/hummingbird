//===----------------------------------------------------------------------===//
//
// This source file is part of the Hummingbird server framework project
//
// Copyright (c) 2021-2021 the Hummingbird authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See hummingbird/CONTRIBUTORS.txt for the list of Hummingbird authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import Hummingbird
import NIOCore
import NIOHTTP1

/// Response structure returned by XCT testing framework
public struct HBXCTResponse {
    /// response status
    public let status: HTTPResponseStatus
    /// response headers
    public let headers: HTTPHeaders
    /// response body
    public let body: ByteBuffer?

    public init(status: HTTPResponseStatus, headers: HTTPHeaders, body: ByteBuffer? = nil) {
        self.status = status
        self.headers = headers
        self.body = body
    }
}

/// Errors thrown by XCT framework.
public struct HBXCTError: Error, Equatable {
    private enum _Internal {
        case notStarted
        case noHead
        case illegalBody
        case noEnd
        case timeout
    }

    private let value: _Internal
    private init(_ value: _Internal) {
        self.value = value
    }

    public static var notStarted: Self { .init(.notStarted) }
    public static var noHead: Self { .init(.noHead) }
    public static var illegalBody: Self { .init(.illegalBody) }
    public static var noEnd: Self { .init(.noEnd) }
    public static var timeout: Self { .init(.timeout) }
}

/// Protocol for XCT framework.
public protocol HBXCT {
    /// Called to start testing of application
    func start(application: HBApplication) throws
    /// Called to stop testing of application
    func stop(application: HBApplication)
    /// Execute URL request and provide response
    func execute(
        uri: String,
        method: HTTPMethod,
        headers: HTTPHeaders,
        body: ByteBuffer?
    ) -> EventLoopFuture<HBXCTResponse>
    /// EventLoopGroup used by XCT framework
    var eventLoopGroup: EventLoopGroup { get }
}
