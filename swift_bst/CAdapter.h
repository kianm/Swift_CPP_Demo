//
//  CAdapter.h
//  mac_cpp_cl
//
//  Created by Kian on 2020-10-26.
//

#ifndef CAdapter_h
#define CAdapter_h



#ifdef __cplusplus
extern "C" {
#endif
typedef void (*iterate_fun)(const char*, const char*,  void*);

typedef struct {
    void *owner;
    void *p_map;
    iterate_fun callback;
} map_struct;

void* map_create();
void map_delete(void* p_map);
void map_add(const char* key, const char* value, void* p_map);
void map_remove(const char* key, void* p_map);
const char* map_get(const char* key, void* p_map);
void map_iterate(void *mps);
#ifdef __cplusplus
}
#endif


#endif /* CAdapter_h */
