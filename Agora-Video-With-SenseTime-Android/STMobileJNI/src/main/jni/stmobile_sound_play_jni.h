#ifndef COM_STMOBILE_SOUND_PLAY_H
#define COM_STMOBILE_SOUND_PLAY_H

#include "prebuilt/include/st_mobile_effect.h"

#ifdef __cplusplus
extern "C" {
#endif

void soundLoad(void* handle, void* sound, const char* sound_name, int length);
void soundPlay(void* handle, const char* sound_name, int loop);
void soundStop(void* handle, const char* sound_name);
void soundPause(void* handle, const char* sound_name);
void soundResume(void* handle, const char* sound_name);
int sound_state_changed(void* handle, const st_effect_module_info_t* module_info);

#ifdef __cplusplus
}
#endif

#endif
