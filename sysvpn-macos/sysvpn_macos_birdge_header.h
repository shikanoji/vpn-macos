//
//  sysvpn_macos_birdge_header.h
//  sysvpn-macos
//
//  Created by macbook on 17/10/2022.
//

#ifndef sysvpn_macos_birdge_header_h
#define sysvpn_macos_birdge_header_h
    #include "VPNCore/IPC/AuditTokenGetter.h"
    #include <ifaddrs.h>

    #define DOMAIN_NAME "NetworkExtension"
    #define AGENT_TYPE  "VPN"
    #define AGENT_NAME "sysvpn-macos"


    int getSysVpnProto(struct ifaddrs *outputIfa);
#endif /* sysvpn_macos_birdge_header_h */

