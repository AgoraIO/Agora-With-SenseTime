#ifndef COM_STMOBILE_STICKER_EVENT_CALLBACK_H
#define COM_STMOBILE_STICKER_EVENT_CALLBACK_H

#ifdef __cplusplus
extern "C" {
#endif

void packageEvent(void* handle, const char* package_name, int packageID, int event, int displayed_frame);
void animationEvent(void* handle, const char* module_name, int module_id, int animation_event, int current_frame, int position_id, unsigned long long position_type);
void keyFrameEvent(void* handle, const char* material_name, int frame);

#ifdef __cplusplus
}
#endif

#endif
