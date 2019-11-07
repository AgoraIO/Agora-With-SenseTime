package com.sensetime.stmobile;

public class STStickerEvent {
    private static String TAG = "STStickerEvent";
    private static STStickerEvent mInstance;
    private StickerEventListener mStickerEventDefaultListener;

    /**
     * STStickerEvent初始化
     * @return
     */
    public static STStickerEvent createInstance() {
        if (mInstance == null) {
            mInstance = new STStickerEvent();
        }
        return mInstance;
    }

    public static STStickerEvent getInstance() {
        return mInstance;
    }

    /**
     * 音频播放监听器
     */
    public interface StickerEventListener {
        /**
         * 贴纸package播放event回调
         *
         * @param packageName    贴纸package名字
         * @param packageID      贴纸package id
         * @param event          贴纸package播放event, 见st_mobile_sticker_transition.h中的st_package_state_type
         * @param displayedFrame 当前package播放的帧数
         */
        void onPackageEvent(String packageName, int packageID, int event, int displayedFrame);

        /**
         * 贴纸part播放event回调
         *
         * @param moduleName     贴纸part名字
         * @param moduleId       贴纸part id
         * @param animationEvent 贴纸part播放event, 见st_mobile_sticker_transition.h中的st_animation_state_type
         * @param currentFrame   当前播放的帧数
         * @param positionId     贴纸对应的position id, 即st_mobile_human_action_t结果中不同类型结果中的id
         * @param positionType   贴纸对应的position种类, 见st_mobile_human_action_t中的动作类型
         */
        void onAnimationEvent(String moduleName, int moduleId, int animationEvent, int currentFrame, int positionId, long positionType);

        /**
         * 贴纸关键帧 event回调
         *
         * @param materialName    贴纸part名字
         * @param frame           触发的关键帧
         */
        void onKeyFrameEvent(String materialName, int frame);
    }

    /**
     * 设置控制监听器
     *
     * @param listener listener为null，SDK默认处理，若不为null，用户自行处理
     */
    public void setStickerEventListener(StickerEventListener listener) {
        if (listener != null) {
            mStickerEventDefaultListener = listener;
        }
    }

    //===========================================================================================================
    //JNI调用，不做混淆
    private void onPackageEvent(String packageName, int packageID, int event, int displayedFrame) {
        if (mStickerEventDefaultListener != null) {
            mStickerEventDefaultListener.onPackageEvent(packageName, packageID, event, displayedFrame);
        }
    }

    //JNI调用，不做混淆
    private void onAnimationEvent(String moduleName, int moduleId, int animationEvent, int currentFrame, int positionId, long position_type) {
        if (mStickerEventDefaultListener != null) {
            mStickerEventDefaultListener.onAnimationEvent(moduleName, moduleId, animationEvent, currentFrame, positionId, position_type);
        }
    }

    //JNI调用，不做混淆
    private void onKeyFrameEvent(String materialName, int frame) {
        if (mStickerEventDefaultListener != null) {
            mStickerEventDefaultListener.onKeyFrameEvent(materialName, frame);
        }
    }
}
