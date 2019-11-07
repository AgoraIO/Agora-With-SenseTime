package io.agora.rtcwithst.views.sensetime;

import android.content.Context;
import android.view.LayoutInflater;
import android.widget.RelativeLayout;
import android.widget.SeekBar;
import android.widget.TextView;

import io.agora.rtcwithst.R;

public class EffectProgressBarLayout extends RelativeLayout {
    public interface OnEffectProgressChangedListener {
        void onEffectProgressChanged(int progress);
    }

    private SeekBar mBar;
    private TextView mMinValueView;
    private TextView mMaxValueView;

    private OnEffectProgressChangedListener mListener;

    private int mMinValue;

    public EffectProgressBarLayout(Context context) {
        super(context);
        init();
    }

    private void init() {
        LayoutInflater.from(getContext()).inflate(R.layout.beauty_option_progress_layout, this);
        mBar = findViewById(R.id.beauty_seekbar);
        mMinValueView = findViewById(R.id.beauty_option_min_value_text);
        mMaxValueView = findViewById(R.id.beauty_option_max_value_text);
        // Max value text is always 100
        mBar.setMax(100);
        mMaxValueView.setText(String.valueOf(100));

        mBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {

            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
                int progress = seekBar.getProgress();
                if (mListener != null) {
                    mListener.onEffectProgressChanged(progress);
                }
            }
        });
    }

    public void setOnEffectProgressSelectedListener(
            OnEffectProgressChangedListener listener) {
        mListener = listener;
    }

    public void setMinValue(int value) {
        mMinValue = value;
        mMinValueView.setText(String.valueOf(mMinValue));
    }

    /**
     * Set actual progress according to the minimum value
     * @param progress progress in the range of [-100, 100]
     *                 the if minimum value is -100;
     *                 or [0, 100] if the minimum value is 0.
     */
    public void setProgress(int progress) {
        double ratio = (progress - mMinValue) / (float) (mBar.getMax() - mMinValue);
        int displayProgress = (int) (ratio * 100 + 0.05);
        mBar.setProgress(displayProgress);
        mMaxValueView.setText(String.valueOf(progress));
    }
}
