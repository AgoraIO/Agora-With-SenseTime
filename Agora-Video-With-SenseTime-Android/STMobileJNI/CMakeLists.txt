# For more information about using CMake with Android Studio, read the
# documentation: https://d.android.com/studio/projects/add-native-code.html

# Sets the minimum version of CMake required to build the native library.

cmake_minimum_required(VERSION 3.4.1)
SET(CONFIG_COMMON src/main/jni/stmobile_common_jni.cpp
        src/main/jni/stmobile_humanaction_jni.cpp
        src/main/jni/utils.cpp
        src/main/jni/stmobile_authentification_jni.cpp
        src/main/jni/stmobile_color_convert_jni.cpp)

SET(CONFIG_HUMAN_ACTION src/main/jni/stmobile_animalface_jni.cpp
        src/main/jni/stmobile_green_screen_segment_jni.cpp
        src/main/jni/stmobile_face_verify_jni.cpp
        src/main/jni/stmobile_face_attribute_jni.cpp
        src/main/jni/utils_human_action.cpp)

SET(CONFIG_EFFECTS src/main/jni/stmobile_animalface_jni.cpp
        src/main/jni/stmobile_face_attribute_jni.cpp
        src/main/jni/stmobile_avatar_jni.cpp
        src/main/jni/stmobile_object_jni.cpp
        src/main/jni/stmobile_sound_play_jni.cpp
        src/main/jni/stmobile_sticker_event_callback_jni.cpp
        src/main/jni/jvmutil.cpp
        src/main/jni/stmobile_effect_jni.cpp

        src/main/jni/utils_effects.cpp)

SET(CONFIG_AVATAR src/main/jni/stmobile_face_attribute_jni.cpp
        src/main/jni/stmobile_pinch_avatar_jni.cpp
        src/main/jni/stmobile_attribute_face_feature_jni.cpp
        src/main/jni/utils_avatar.cpp)

SET(CONFIG_BODYS
        src/main/jni/stmobile_body_beautify_jni.cpp)

if(${PRODUCT_CONFIG} STREQUAL "human_action")
    add_library(stmobile_jni SHARED ${CONFIG_COMMON} ${CONFIG_HUMAN_ACTION})
elseif(${PRODUCT_CONFIG} STREQUAL "effects")
    add_library(stmobile_jni SHARED ${CONFIG_COMMON} ${CONFIG_EFFECTS})
elseif(${PRODUCT_CONFIG} STREQUAL "bodys")
    add_library(stmobile_jni SHARED ${CONFIG_COMMON} ${CONFIG_BODYS})
elseif(${PRODUCT_CONFIG} STREQUAL "avatar")
    add_library(stmobile_jni SHARED ${CONFIG_COMMON} ${CONFIG_AVATAR})
    
elseif(${PRODUCT_CONFIG} STREQUAL "human_action+effects")
    add_library(stmobile_jni SHARED ${CONFIG_COMMON} ${CONFIG_HUMAN_ACTION} ${CONFIG_EFFECTS})
elseif(${PRODUCT_CONFIG} STREQUAL "human_action+avatar")
    add_library(stmobile_jni SHARED ${CONFIG_COMMON} ${CONFIG_HUMAN_ACTION} ${CONFIG_AVATAR})
elseif(${PRODUCT_CONFIG} STREQUAL "human_action+bodys")
    add_library(stmobile_jni SHARED ${CONFIG_COMMON} ${CONFIG_HUMAN_ACTION} ${CONFIG_BODYS})
elseif(${PRODUCT_CONFIG} STREQUAL "effects+bodys")
    add_library(stmobile_jni SHARED ${CONFIG_COMMON} ${CONFIG_EFFECTS} ${CONFIG_BODYS})
elseif(${PRODUCT_CONFIG} STREQUAL "effects+avatar")
    add_library(stmobile_jni SHARED ${CONFIG_COMMON} ${CONFIG_EFFECTS} ${CONFIG_AVATAR})
elseif(${PRODUCT_CONFIG} STREQUAL "avatar+bodys")
    add_library(stmobile_jni SHARED ${CONFIG_COMMON} ${CONFIG_AVATAR} ${CONFIG_BODYS})
    
elseif(${PRODUCT_CONFIG} STREQUAL "human_action+effects+avatar")
    add_library(stmobile_jni SHARED ${CONFIG_COMMON} ${CONFIG_HUMAN_ACTION} ${CONFIG_EFFECTS} ${CONFIG_AVATAR})
elseif(${PRODUCT_CONFIG} STREQUAL "human_action+effects+bodys")
    add_library(stmobile_jni SHARED ${CONFIG_COMMON} ${CONFIG_HUMAN_ACTION} ${CONFIG_EFFECTS} ${CONFIG_BODYS})
elseif(${PRODUCT_CONFIG} STREQUAL "human_action+bodys+avatar")
    add_library(stmobile_jni SHARED ${CONFIG_COMMON} ${CONFIG_HUMAN_ACTION} ${CONFIG_BODYS} ${CONFIG_AVATAR})
elseif(${PRODUCT_CONFIG} STREQUAL "effects+bodys+avatar")
    add_library(stmobile_jni SHARED ${CONFIG_COMMON} ${CONFIG_EFFECTS} ${CONFIG_BODYS} ${CONFIG_AVATAR})
    
elseif(${PRODUCT_CONFIG} STREQUAL "effects+avatar+huaman_action+bodys")
    add_library(stmobile_jni SHARED ${CONFIG_COMMON} ${CONFIG_HUMAN_ACTION} ${CONFIG_EFFECTS} ${CONFIG_AVATAR} ${CONFIG_BODYS} )

endif()

include_directories(./src/main/jni/prebuilt/include)

find_library(log-lib log)
find_library(dl-lib dl)
find_library(android-lib android)
find_library(stmobile-lib st_mobile PATHS ./src/main/jni/prebuilt/lib/${ANDROID_ABI}/ NO_CMAKE_FIND_ROOT_PATH)

target_link_libraries( stmobile_jni ${log-lib} ${dl-lib} ${stmobile-lib} ${android-lib})