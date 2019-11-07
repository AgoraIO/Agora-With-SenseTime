package io.agora.rtcwithst.views.sensetime.beauty;

public class BeautyOptionItem {
    private int mProgress;
    private int mIconRes;
    private String mText;

    public BeautyOptionItem(String text, int iconRes) {
        mText = text;
        mIconRes = iconRes;
    }

    public int getProgress() {
        return mProgress;
    }

    public void setProgress(int progress) {
        mProgress = progress;
    }

    public int getIconRes() {
        return mIconRes;
    }

    public String getText() {
        return mText;
    }
}
