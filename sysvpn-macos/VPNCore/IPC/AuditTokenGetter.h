//
//  AuditTokenGetter.swift
//  TunnelKitHost
//
//  Created by macbook on 15/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//
    
#ifndef AuditTokenGetter_h
#define AuditTokenGetter_h

#import <Foundation/Foundation.h>

/// The audit token property of an NSXPCConnection is private, for no good reason. Apple lets us "properly"
/// check the code signature of an `xpc_connection_t` using `xpc_connection_set_peer_code_signing_requirement`,
/// but gives us no such luxury for NSXPCConnections. The best we can do with public API is to check the pid of
/// the endpoint, but this also presents security challenges as pids are known to roll over and can thus be subject
/// to TOCTTOU attacks. This simple interface exposes the private property to us and lets us access it normally.
@interface NSXPCConnection(AuditTokenGetter)
@property (nonatomic, readonly) audit_token_t auditToken;
@end

#endif /* AuditTokenGetter_h */
