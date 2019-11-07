package io.agora.framework;

import android.content.Context;

import io.agora.framework.channels.ChannelManager;
import io.agora.framework.channels.VideoChannel;
import io.agora.framework.comsumers.IVideoConsumer;
import io.agora.framework.preprocess.IPreprocessor;
import io.agora.framework.producers.IVideoProducer;

public class VideoModule {
    private static final String TAG = VideoModule.class.getSimpleName();

    private static VideoModule mSelf;
    private ChannelManager mChannelManager;

    //TODO May need a better way for singleton
    public static VideoModule instance() {
        if (mSelf == null) {
            mSelf = new VideoModule();
        }

        return mSelf;
    }

    private VideoModule() {

    }

    /**
     * Should be called globally once before any
     * video channel APIs are called.
     * @param context
     */
    public void init(Context context) {
        mChannelManager = new ChannelManager(context);
    }

    public VideoChannel connectProducer(IVideoProducer producer, int id) {
        return mChannelManager.connectProducer(producer, id);
    }

    public VideoChannel connectConsumer(IVideoConsumer consumer, int id, int type) {
        return mChannelManager.connectConsumer(consumer, id, type);
    }

    public void disconnectProducer(IVideoProducer producer, int id) {
        mChannelManager.disconnectProducer(id);
    }

    public void disconnectConsumer(IVideoConsumer consumer, int id) {
        mChannelManager.disconnectConsumer(consumer, id);
    }

    public void stopChannel(int channelId) {
        mChannelManager.stopChannel(channelId);
    }

    public void stopAllChannels() {
        stopChannel(ChannelManager.ChannelID.CAMERA);
        stopChannel(ChannelManager.ChannelID.SCREEN_SHARE);
        stopChannel(ChannelManager.ChannelID.CUSTOM);
    }

    /**
     * Enable the channel to capture video frames and do
     * offscreen rendering without the onscreen consumer
     * (Like SurfaceView or TextureView).
     * The default is true.
     * @param channelId
     * @param enabled
     */
    public void enableOffscreenMode(int channelId, boolean enabled) {
        mChannelManager.enableOffscreenMode(channelId, enabled);
    }

    public void setPreprocessor(int channelId, IPreprocessor preprocessor) {
        mChannelManager.setPreprocessor(channelId, preprocessor);
    }

    public IPreprocessor getPreprocessor(int channelId) {
        return mChannelManager.getPreprocessor(channelId);
    }
}
