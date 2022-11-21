//
//  sysvpn_macos_birdge_header.h
//  sysvpn-macos
//
//  Created by macbook on 17/10/2022.
//

#ifndef sysvpn_macos_birdge_header_h
#define sysvpn_macos_birdge_header_h
    #include "VPNCore/IPC/AuditTokenGetter.h"
    #include "define.h"
    #include <ifaddrs.h>

    int get_sys_vpn_ifdv(struct ifaddrs *outputIfa);
#endif /* sysvpn_macos_birdge_header_h */

