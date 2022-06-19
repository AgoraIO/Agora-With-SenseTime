package com.sensetime.stmobile.model;

public class STAnimationTarget {
    private int animClipId;     /// load_animation_clip返回的clip id
    private int loopNum;       /// 循环次数，目前只支持0, 1两个值，其中0指一直循环，1指播放单次
    private float smoothSec;   /// 从前面一个动画过渡到当前动画的过渡时间

    public STAnimationTarget(int animClipId, int loopNum, float smoothSec){
        this.animClipId = animClipId;
        this.loopNum = loopNum;
        this.smoothSec = smoothSec;
    }
}
