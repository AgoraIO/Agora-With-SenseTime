package io.agora.framework.channels;

import android.content.Context;

import io.agora.framework.comsumers.IVideoConsumer;
import io.agora.framework.preprocess.IPreprocessor;
import io.agora.framework.producers.IVideoProducer;

public class ChannelManager {
    public static final String TAG = ChannelManager.class.getSimpleName();
    private static final int CHANNEL_COUNT = 3;

    public static class ChannelID {
        public static final int CAMERA = 0;
        public static final int SCREEN_SHARE = 1;
        public static final int CUSTOM = 2;

        public static String toString(int id) {
            switch (id) {
                case CAMERA: return "camera_channel";
                case SCREEN_SHARE: return "ScreenShare_channel";
                case CUSTOM: return "custom_channel";
                default: return "undefined_channel";
            }
        }
    }

    public ChannelManager(Context context) {
        // The context should have no relation
        // to any Activity or a Service instance.
        mContext = context.getApplicationContext();
    }

    private Context mContext;
    private VideoChannel[] mChannels = new VideoChannel[CHANNEL_COUNT];

    public VideoChannel connectProducer(IVideoProducer producer, int id) {
        ensureChannelState(id);
        mChannels[id].connectProducer(producer);
        return mChannels[id];
    }

    public void disconnectProducer(int id) {
        ensureChannelState(id);
        mChannels[id].disconnectProducer();
    }

    public VideoChannel connectConsumer(IVideoConsumer consumer, int id, int type) {
        ensureChannelState(id);
        mChannels[id].connectConsumer(consumer, type);
        return mChannels[id];
    }

    public void disconnectConsumer(IVideoConsumer consumer, int id) {
        ensureChannelState(id);
        mChannels[id].disconnectConsumer(consumer);
    }

    private void ensureChannelState(int channelId) {
        checkChannelId(channelId);

        if (mChannels[channelId] == null) {
            mChannels[channelId] = new VideoChannel(mContext, channelId);
        }

        if (!mChannels[channelId].isRunning()) {
            mChannels[channelId].startChannel();
        }
    }

    public void stopChannel(int channelId) {
        checkChannelId(channelId);

        if (mChannels[channelId] != null &&
                mChannels[channelId].isRunning()) {
            mChannels[channelId].stopChannel();
            mChannels[channelId] = null;
        }
    }

    public void enableOffscreenMode(int channelId, boolean enable) {
        ensureChannelState(channelId);
        mChannels[channelId].enableOffscreenMode(enable);
    }

    public void setPreprocessor(int channelId, IPreprocessor preprocessor) {
        checkChannelId(channelId);
        if (mChannels[channelId] == null) {
            mChannels[channelId] = new VideoChannel(mContext, channelId);
        }

        mChannels[channelId].setPreprocessor(preprocessor);
    }

    public IPreprocessor getPreprocessor(int channelId) {
        checkChannelId(channelId);
        return mChannels[channelId].getPreprocessor();
    }

    private void checkChannelId(int channelId) {
        if (channelId < ChannelID.CAMERA || channelId > ChannelID.CUSTOM) {
            throw new IllegalArgumentException(
                    "[ChannelManager] wrong argument: Undefined channel id");
        }
    }
}
