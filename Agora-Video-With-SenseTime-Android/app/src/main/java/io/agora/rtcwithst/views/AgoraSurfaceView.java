package io.agora.rtcwithst.views;

import android.content.Context;
import android.util.AttributeSet;
import android.view.SurfaceView;

import io.agora.framework.VideoModule;
import io.agora.framework.comsumers.SurfaceViewConsumer;

public class AgoraSurfaceView extends SurfaceView {
    private SurfaceViewConsumer mConsumer;

    public AgoraSurfaceView(Context context) {
        super(context);
        init();
    }

    public AgoraSurfaceView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    private void init() {
        setConsumer();
    }

    private void setConsumer() {
        mConsumer = new SurfaceViewConsumer(VideoModule.instance());
        mConsumer.setSurfaceView(this);
        getHolder().addCallback(mConsumer);
    }

    public void disconnect() {
        mConsumer.surfaceDestroyed(getHolder());
        mConsumer.setSurfaceView(null);
        getHolder().removeCallback(mConsumer);
        mConsumer = null;
    }
}
