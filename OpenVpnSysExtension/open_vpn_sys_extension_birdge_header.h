//
//  open_vpn_sys_extension_birdge_header.h
//  sysvpn-macos
//
//  Created by macbook on 17/10/2022.
//

#ifndef open_vpn_sys_extension_birdge_header_h
#define open_vpn_sys_extension_birdge_header_h
#include "../sysvpn-macos/VPNCore/IPC/AuditTokenGetter.h"

#define CTLIOCGINFO 0xc0644e03UL
struct ctl_info {
    u_int32_t   ctl_id;
    char        ctl_name[96];
};

struct sockaddr_ctl {
    u_char      sc_len;
    u_char      sc_family;
    u_int16_t   ss_sysaddr;
    u_int32_t   sc_id;
    u_int32_t   sc_unit;
    u_int32_t   sc_reserved[5];
};

#endif /* open_vpn_sys_extension_birdge_header_h */
