package io.agora.rtcwithst.views.sensetime.makeup;

import android.content.Context;
import android.widget.LinearLayout;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;

public class MakeupOptionLayout extends LinearLayout
        implements MakeupGroupListAdapter.OnMakeupGroupSelectedListener,
                   MakeupItemListAdapter.OnMakeupItemClickedListener {
    public interface OnMakeupListener {
        void onMakeupSelected(int group, int type, String path);
        void onMakeupRemoved(int group);
        String onGetCurrentGroupMakeup(String group);
    }

    private OnMakeupListener mListener;

    private MakeupGroupListAdapter mGroupListAdapter;
    private List<MakeupItemListAdapter> mSubGroupAdapters;
    private RecyclerView mRecyclerView;

    public MakeupOptionLayout(Context context, OnMakeupListener listener) {
        super(context);
        init(context);
        mListener = listener;
    }

    private void init(Context context) {
        setAttributes();
        initGroupList(context);
        initSubGroups(context);
    }

    private void setAttributes() {
        setOrientation(LinearLayout.HORIZONTAL);
    }

    private void initGroupList(Context context) {
        LinearLayoutManager layoutManager = new LinearLayoutManager(context);
        layoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
        mRecyclerView = new RecyclerView(context);
        mRecyclerView.setLayoutManager(layoutManager);
        addView(mRecyclerView, LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
        mGroupListAdapter = new MakeupGroupListAdapter(context, this);
        mRecyclerView.setAdapter(mGroupListAdapter);
    }

    private void initSubGroups(Context context) {
        int count = mGroupListAdapter.getItemCount();
        mSubGroupAdapters = new ArrayList<>();
        for (int i = 0; i < count; i++) {
            mSubGroupAdapters.add(MakeupManager.getItemListAdapter(context, i, this));
        }
    }

    private MakeupItemListAdapter getItemAdapter(int groupIndex) {
        return mSubGroupAdapters.get(groupIndex);
    }

    @Override
    public void onMakeupGroupSelected(int groupIndex) {
        RecyclerView.Adapter adapter = getItemAdapter(groupIndex);
        mRecyclerView.setAdapter(adapter);
    }

    @Override
    public String onGetCurrentGroupMakeup(String index) {
        return mListener.onGetCurrentGroupMakeup(index);
    }

    private void showGroupList() {
        mRecyclerView.setAdapter(mGroupListAdapter);
    }

    @Override
    public void onBackSelected() {
        showGroupList();
    }

    @Override
    public void onOriginalSelected(int group, String indexString) {
        mGroupListAdapter.setItemActivated(group, false);
        mListener.onMakeupRemoved(group);
    }

    @Override
    public void onMakeupItemSelected(int group, int makeupIndex, String indexString, String file) {
        mGroupListAdapter.setItemActivated(group, true);
        mListener.onMakeupSelected(group, MakeupManager.indexToMakeupType(group), file);
    }
}
