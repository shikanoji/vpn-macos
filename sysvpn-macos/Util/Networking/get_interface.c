//
//  get_interface.c
//  sysvpn-macos
//
//  Created by macbook on 21/11/2022.
//
#include <sys/cdefs.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/route.h>
#include <arpa/inet.h>
#include <ifaddrs.h>
#include <ctype.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <uuid/uuid.h>
#include "../../define.h"

// Apple API ITOC
#define SIOCGIFAGENTDATA        _IOWR('i', 168, struct netagent_req)
#define SIOCGIFAGENTIDS         _IOWR('i', 167, struct if_agentidsreq)

struct if_agentidsreq {
    char        ifar_name[IFNAMSIZ];
    u_int32_t   ifar_count;
    uuid_t      *ifar_uuids;
};

#define NETAGENT_DOMAINSIZE      32
#define NETAGENT_TYPESIZE        32
#define NETAGENT_DESCSIZE        128

struct netagent_req {
    uuid_t      netagent_uuid;
    char        netagent_domain[NETAGENT_DOMAINSIZE];
    char        netagent_type[NETAGENT_TYPESIZE];
    char        netagent_desc[NETAGENT_DESCSIZE];
    u_int32_t   netagent_flags;
    u_int32_t   netagent_data_size;
    u_int8_t    *netagent_data;
};
// ---------- END APPLE API ITOC ---------


int get_sys_vpn_ifdv(struct ifaddrs *outputIfa) {
    struct ifaddrs *ifap, *ifa;
    char name[IFNAMSIZ];
    int s = socket(AF_INET, SOCK_DGRAM, 0);
    int ret = 0;
    if (getifaddrs(&ifap) != 0)
        return ret;
    
    for (ifa = ifap; ifa; ifa = ifa->ifa_next) {
        strncpy(name, ifa->ifa_name, IFNAMSIZ);
        if (ifa->ifa_addr->sa_family != AF_LINK) {
            continue;
        }
        struct if_agentidsreq ifar;
        memset(&ifar, 0, sizeof(ifar));
        strlcpy(ifar.ifar_name, name, sizeof(ifar.ifar_name));
        if (ioctl(s, SIOCGIFAGENTIDS, &ifar) != -1) {
            if (ifar.ifar_count != 0) {
                ifar.ifar_uuids = calloc(ifar.ifar_count, sizeof(uuid_t));
                if (ifar.ifar_uuids != NULL) {
                    if (ioctl(s, SIOCGIFAGENTIDS, &ifar) != 1) {
                        for (int agent_i = 0; agent_i < ifar.ifar_count; agent_i++) {
                            struct netagent_req nar;
                            memset(&nar, 0, sizeof(nar));
                            uuid_copy(nar.netagent_uuid, ifar.ifar_uuids[agent_i]);
                            if (ioctl(s, SIOCGIFAGENTDATA, &nar) != 1) {
                                if (
                                    strcmp(nar.netagent_type, AGENT_TYPE ) == 0 &&
                                    strcmp(nar.netagent_domain, DOMAIN_NAME) == 0 &&
                                    strstr(nar.netagent_desc, AGENT_NAME ) != NULL
                                    ) {
                                        memcpy(outputIfa, ifa, sizeof(struct ifaddrs));
                                        ret = 1;
                                        break;
                                }
                                
                            }
                        }
                    }
                    free(ifar.ifar_uuids);
                }
            }
            
            if (ret == 1){
                break;
            }
        }
    }
    free(ifap);
    close(s);
    return ret;
}
