//
//  CAdapter.c
//  mac_cpp_cl
//
//  Created by Kian on 2020-10-26.
//

#include <string>
#include <iostream>
#include <map>
#include "CAdapter.h"

typedef std::map<std::string, std::string> ssmap;

extern "C" {
void* map_create() {
    ssmap* p_map = new ssmap();
    std::cout << "map created on the C++ side" << std::endl;
    return (void*) p_map;
}

void map_delete(void* p_map) {
    ssmap* p_ssmap = (ssmap*) p_map;
    delete p_ssmap;
    std::cout << "map deleted on the C++ side" << std::endl;
}

void map_add(const char* key, const char* value, void* p_map) {
    (*((ssmap*) p_map))[key] = value;
}

void map_remove(const char* key, void* p_map) {
    (*((ssmap*) p_map)).erase(key);
}

const char* map_get(const char* key, void* p_map) {
    return (*((ssmap*) p_map))[key].c_str();
}

void map_iterate(void *mps) {

    map_struct *os = (map_struct*) mps;
    ssmap *p_map = (ssmap*) os->p_map;
    for( ssmap::const_iterator it = p_map->begin(); it != p_map->end(); ++it )
    {
        std::string value = it->second;
        os->callback(it->first.c_str(), it->second.c_str(), os->owner);
    }
}
}
