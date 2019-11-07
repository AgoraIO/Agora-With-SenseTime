package io.agora.rtcwithst.views.sensetime;

import android.content.Context;
import android.content.res.Resources;
import android.util.AttributeSet;
import android.util.Log;
import android.util.SparseArray;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.sensetime.effects.STEffectListener;

import java.util.List;

import io.agora.rtcwithst.R;
import io.agora.rtcwithst.views.sensetime.beauty.BeautyOptionConfig;
import io.agora.rtcwithst.views.sensetime.beauty.BeautyOptionItem;
import io.agora.rtcwithst.views.sensetime.beauty.BeautyOptionListAdapter;
import io.agora.rtcwithst.views.sensetime.filter.FilterListAdapter;
import io.agora.rtcwithst.views.sensetime.makeup.MakeupManager;
import io.agora.rtcwithst.views.sensetime.makeup.MakeupOptionLayout;
import io.agora.rtcwithst.views.sensetime.sticker.StickerItemListAdapter;

/**
 * Layout of all options of SenseTime effects, including beautification,
 * filters, makeups, and stickers which are arranged into groups.
 * Beauty options are split into groups of basic, pro, micro shaping and adjustment.
 */
public class EffectOptionsLayout extends LinearLayout
        implements EffectGroupListAdapter.OnGroupClickedListener,
                   BeautyOptionListAdapter.OnBeautyOptionItemClickedListener,
                   EffectProgressBarLayout.OnEffectProgressChangedListener,
                   FilterListAdapter.OnFilterSelectedListener,
                   MakeupOptionLayout.OnMakeupListener,
                   StickerItemListAdapter.OnStickerItemClickedListener {

    private static final String TAG = EffectOptionsLayout.class.getSimpleName();

    private static final int GROUP_BASIC_BEAUTY = 0;
    private static final int GROUP_PRO_BEAUTY = 1;
    private static final int GROUP_MICRO_SHAPING = 2;
    private static final int GROUP_MAKEUP = 3;
    private static final int GROUP_FILTER = 4;
    private static final int GROUP_ADJUSTMENT = 5;
    private static final int GROUP_STICKER = 6;

    private static final int DIVIDER_HEIGHT = 3;

    private Resources mResources;
    private LayoutInflater mInflater;

    private int mProgressLayoutHeight;
    private int mGroupLayoutHeight;
    private int mOptionListLayoutHeight;

    private RelativeLayout mProgressLayout;
    private EffectProgressBarLayout mSeekBarLayout;
    private LinearLayout mGroupLayout;
    private LinearLayout mOptionListLayout;
    private MakeupOptionLayout mMakeupOptionLayout;

    private RecyclerView mBeautyOptionListRecyclerView;

    private int mCurrentGroup;
    private int mCurrentIndex;
    private EffectGroupListAdapter mGroupListAdapter;
    private BeautyOptionListAdapter mBasicBeautyAdapter;
    private BeautyOptionListAdapter mProBeautyAdapter;
    private BeautyOptionListAdapter mMicroShapingAdapter;
    private BeautyOptionListAdapter mAdjustmentAdapter;
    private FilterListAdapter mFilterListAdapter;
    private StickerItemListAdapter mStickerAdapter;

    private BeautyOptionConfig mBeautyOptionConfig = new BeautyOptionConfig();
    private SparseArray<List<BeautyOptionItem>> mBeautyOptionItemListArray = new SparseArray<>();

    private STEffectListener mListener;

    public void setSTEffectListener(STEffectListener listener) {
        mListener = listener;
    }

    public EffectOptionsLayout(Context context) {
        super(context);
        init(context);
    }

    public EffectOptionsLayout(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public EffectOptionsLayout(Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context);
    }

    private void init(Context context) {
        mResources = context.getResources();
        mInflater = LayoutInflater.from(context);
        setAttributes();
        getDimensions();
        initOptionItems();
        initContentLayouts(context);
        initAdapters(context);
        showDefaultGroup();
    }

    private void setAttributes() {
        setOrientation(LinearLayout.VERTICAL);
    }

    private void initOptionItems() {
        mBeautyOptionItemListArray.append(GROUP_BASIC_BEAUTY, mBeautyOptionConfig.getBeautyOptionListByGroup(GROUP_BASIC_BEAUTY));
        mBeautyOptionItemListArray.append(GROUP_PRO_BEAUTY, mBeautyOptionConfig.getBeautyOptionListByGroup(GROUP_PRO_BEAUTY));
        mBeautyOptionItemListArray.append(GROUP_MICRO_SHAPING, mBeautyOptionConfig.getBeautyOptionListByGroup(GROUP_MICRO_SHAPING));
        mBeautyOptionItemListArray.append(GROUP_ADJUSTMENT, mBeautyOptionConfig.getBeautyOptionListByGroup(GROUP_ADJUSTMENT));
    }

    private void getDimensions() {
        mProgressLayoutHeight = getDimension(R.dimen.beauty_option_progress_height);
        mGroupLayoutHeight = getDimension(R.dimen.beauty_option_group_height);
        mOptionListLayoutHeight = getDimension(R.dimen.effect_option_list_height);
    }

    private int getDimension(int dimen) {
        return mResources.getDimensionPixelSize(dimen);
    }

    private void initContentLayouts(Context context) {
        initProgressLayout(context);
        initGroupLayout(context);
        addDivider(context);
        initOptionListLayout(context);
    }

    private void addDivider(Context context) {
        View view = new View(context);
        view.setBackgroundColor(mResources.getColor(R.color.beauty_option_divider_color));
        addView(view, RelativeLayout.LayoutParams.MATCH_PARENT, DIVIDER_HEIGHT);
    }

    private void initProgressLayout(Context context) {
        mProgressLayout = new RelativeLayout(context);
        addView(mProgressLayout, RelativeLayout.LayoutParams.MATCH_PARENT, mProgressLayoutHeight);

        mSeekBarLayout = new EffectProgressBarLayout(context);
        mSeekBarLayout.setOnEffectProgressSelectedListener(this);
        mProgressLayout.addView(mSeekBarLayout,
                RelativeLayout.LayoutParams.MATCH_PARENT,
                RelativeLayout.LayoutParams.MATCH_PARENT);
        mProgressLayout.setVisibility(View.GONE);
    }

    private void initGroupLayout(Context context) {
        mGroupLayout = new LinearLayout(context);
        mGroupLayout.setBackgroundResource(R.color.beauty_option_panel_background);
        addView(mGroupLayout, LayoutParams.MATCH_PARENT, mGroupLayoutHeight);

        RecyclerView recycler = new RecyclerView(context);
        mGroupLayout.addView(recycler,
                LayoutParams.MATCH_PARENT,
                LayoutParams.MATCH_PARENT);

        LinearLayoutManager layoutManager = new LinearLayoutManager(context);
        layoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
        recycler.setLayoutManager(layoutManager);

        mGroupListAdapter = new EffectGroupListAdapter(this);
        recycler.setAdapter(mGroupListAdapter);
    }

    private void initOptionListLayout(Context context) {
        mOptionListLayout = new LinearLayout(context);
        mOptionListLayout.setBackgroundResource(R.color.beauty_option_panel_background);
        addView(mOptionListLayout, LayoutParams.MATCH_PARENT, mOptionListLayoutHeight);

        mBeautyOptionListRecyclerView = new RecyclerView(context);
        mOptionListLayout.addView(mBeautyOptionListRecyclerView,
                LayoutParams.MATCH_PARENT,
                LayoutParams.MATCH_PARENT);

        LinearLayoutManager layoutManager = new LinearLayoutManager(context);
        layoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
        mBeautyOptionListRecyclerView.setLayoutManager(layoutManager);

        mMakeupOptionLayout = new MakeupOptionLayout(context, this);
    }

    private void initAdapters(Context context) {
        mBasicBeautyAdapter = new BeautyOptionListAdapter(context, GROUP_BASIC_BEAUTY,
                mBeautyOptionItemListArray.get(GROUP_BASIC_BEAUTY), this);
        mProBeautyAdapter = new BeautyOptionListAdapter(context, GROUP_PRO_BEAUTY,
                mBeautyOptionItemListArray.get(GROUP_PRO_BEAUTY), this);
        mMicroShapingAdapter = new BeautyOptionListAdapter(context, GROUP_MICRO_SHAPING,
                mBeautyOptionItemListArray.get(GROUP_MICRO_SHAPING), this);
        mAdjustmentAdapter = new BeautyOptionListAdapter(context, GROUP_ADJUSTMENT,
                mBeautyOptionItemListArray.get(GROUP_ADJUSTMENT), this);
        mFilterListAdapter = new FilterListAdapter(context, this);
        mStickerAdapter = new StickerItemListAdapter(context, this);
    }

    /**
     * Only called at initialization
     */
    private void showDefaultGroup() {
        // Show basic beauty option and select the first item
        mBeautyOptionListRecyclerView.setAdapter(getGroupAdapter(mCurrentGroup));
        showEffectProgress(mCurrentGroup, 0);
    }

    @Override
    public void onGroupClicked(int position) {
        changeGroup(position);
        mCurrentGroup = position;
    }

    private void changeGroup(int group) {
        if (group == mCurrentGroup) {
            return;
        }

        RecyclerView.Adapter adapter = getGroupAdapter(group);
        if (adapter != null) {
            mOptionListLayout.removeAllViews();
            mOptionListLayout.addView(mBeautyOptionListRecyclerView,
                    LayoutParams.MATCH_PARENT,
                    LayoutParams.MATCH_PARENT);

            mBeautyOptionListRecyclerView.setAdapter(adapter);
            if (adapter instanceof BeautyOptionListAdapter) {
                BeautyOptionListAdapter optionAdapter =
                        (BeautyOptionListAdapter) adapter;
                mCurrentIndex = optionAdapter.getSelected();
                showEffectProgress(group, mCurrentIndex);
            } else if (adapter instanceof FilterListAdapter) {
                FilterListAdapter filterAdapter =
                        (FilterListAdapter) adapter;
                mCurrentIndex = filterAdapter.getSelected();
                if (mCurrentIndex != 0) {
                    // The original filter don't need to show
                    // the Seek Bar
                    showEffectProgress(group, mCurrentIndex);
                } else {
                    hideEffectProgress();
                }
            }
        } else {
            if (isMakeupOption(group)) {
                hideEffectProgress();
                mOptionListLayout.removeAllViews();
                mOptionListLayout.addView(mMakeupOptionLayout,
                        LayoutParams.MATCH_PARENT,
                        LayoutParams.MATCH_PARENT);
            }
            mCurrentIndex = 0;
        }
    }

    private RecyclerView.Adapter getGroupAdapter(int group) {
        switch (group) {
            case GROUP_BASIC_BEAUTY:
                return mBasicBeautyAdapter;
            case GROUP_PRO_BEAUTY:
                return mProBeautyAdapter;
            case GROUP_MICRO_SHAPING:
                return mMicroShapingAdapter;
            case GROUP_ADJUSTMENT:
                return mAdjustmentAdapter;
            case GROUP_FILTER:
                return mFilterListAdapter;
            case GROUP_STICKER:
                return mStickerAdapter;
            default:
                return null;
        }
    }

    @Override
    public void onBeautyOptionClicked(int group, int index) {
        // Log.i(TAG, "onBeautyOptionClicked group:" + group + " index:" + index);
        mCurrentIndex = index;
        showEffectProgress(group, index);
    }

    @Override
    public int onGetBeautyOptionProgress(int group, int index) {
        float value = mListener.onGetBeautyParamValue(
                mBeautyOptionConfig.toBeautyParamType(group, index));
        return mBeautyOptionConfig.valueToProgress(value);
    }

    /**
     * Called when the option group changes or the beauty item
     * is clicked.
     * @param group
     * @param index
     */
    private void showEffectProgress(int group, int index) {
        mProgressLayout.setVisibility(View.VISIBLE);
        boolean hasNegative = isBeautyOption(group) &&
                mBeautyOptionConfig.hasNegativeBeautyValue(group, index);
        mSeekBarLayout.setMinValue(hasNegative ? -100 : 0);
        mSeekBarLayout.setProgress(getProgressByGroupId(group, index));
    }

    private void hideEffectProgress() {
        mProgressLayout.setVisibility(View.GONE);
    }

    private int getProgressByGroupId(int group, int index) {
        if (isBeautyOption(group)) {
            return mBeautyOptionItemListArray.get(group).get(index).getProgress();
        } else if (isFilterOption(group)) {
            return mFilterListAdapter.getStrength(index);
        } else {
            return 0;
        }
    }

    /**
     * Called when the progress of SeekBar is changed.
     * @param progress SeekBar progress ranging from 0 to 100
     */
    @Override
    public void onEffectProgressChanged(int progress) {
        if (isBeautyOption(mCurrentGroup)) {
            BeautyOptionItem item = mBeautyOptionItemListArray.
                    get(mCurrentGroup).get(mCurrentIndex);

            int itemProgress = toItemProgress(mBeautyOptionConfig.
                    hasNegativeBeautyValue(mCurrentGroup, mCurrentIndex), progress);
            item.setProgress(itemProgress);
            mSeekBarLayout.setProgress(item.getProgress());
            getGroupAdapter(mCurrentGroup).notifyDataSetChanged();

            if (mListener != null) {
                mListener.onBeautyParamSelected(
                        mBeautyOptionConfig.toBeautyParamType(mCurrentGroup, mCurrentIndex),
                        mBeautyOptionConfig.progressToValue(itemProgress));
            }
        } else if (isFilterOption(mCurrentGroup) &&
                mSeekBarLayout.getVisibility() == View.VISIBLE) {
            mFilterListAdapter.setStrength(mCurrentIndex, progress);
            mSeekBarLayout.setMinValue(0);
            mSeekBarLayout.setProgress(progress);
        }
    }

    private boolean isBeautyOption(int group) {
        return GROUP_BASIC_BEAUTY <= group &&
                group <= GROUP_MICRO_SHAPING ||
                group == GROUP_ADJUSTMENT;
    }

    private boolean isFilterOption(int group) {
        return GROUP_FILTER == group;
    }

    private boolean isMakeupOption(int group) {
        return GROUP_MAKEUP == group;
    }

    /**
     * Change the progress of the SeekBar to actual value progress
     * @param hasNegative true if the BeautyParam has negative values
     * @param progress seek bar progress
     * @return
     */
    private int toItemProgress(boolean hasNegative, int progress) {
        double ratio = progress / 100f;
        int min = hasNegative ? -100 : 0;
        return (int) ((100 - min) * ratio + 0.05 + min);

    }

    @Override
    public void onFilterSelected(String modelPath, float strength) {
        Log.i("filter", "filter selected strength: " + strength);
        if (mListener != null) {
            mListener.onFilterSelected(modelPath, strength);
        }
    }

    @Override
    public void onFilterChanged(int index) {
        if (isFilterOption(mCurrentGroup)) {
            if (index == 0) {
                hideEffectProgress();
            } else {
                showEffectProgress(mCurrentGroup, index);
            }
        }
    }

    @Override
    public String onGetCurrentFilterPath() {
        if (mListener != null) {
            return mListener.onGetCurrentFilterPath();
        }

        return null;
    }

    @Override
    public void onMakeupSelected(int group, int type, String path) {
        if (mListener != null) {
            mListener.onMakeupSelected(type,
                    MakeupManager.getMakeupGroupName(group), path);
        }
    }

    @Override
    public void onMakeupRemoved(int group) {
        if (mListener != null) {
            mListener.onMakeupSelected(-1,
                    MakeupManager.getMakeupGroupName(group), null);
        }
    }

    @Override
    public String onGetCurrentGroupMakeup(String index) {
        if (mListener != null) {
            return mListener.onGetCurrentGroupMakeup(index);
        }
        return null;
    }

    @Override
    public void onStickerItemClicked(String path) {
        if (mListener != null) {
            mListener.onStickerSelected(path);
        }
    }

    @Override
    public void onStickerRemoved() {
        if (mListener != null) {
            mListener.onStickerSelected(null);
        }
    }
}
