package io.agora.rtcwithst.views.sensetime.makeup;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

import io.agora.rtcwithst.R;
import io.agora.rtcwithst.views.sensetime.widgets.RoundImageView;

/**
 * For a makeup group
 */
public class MakeupItemListAdapter extends RecyclerView.Adapter {
    interface OnMakeupItemClickedListener {
        void onBackSelected();
        void onOriginalSelected(int group, String indexString);
        void onMakeupItemSelected(int group, int makeupIndex, String indexString, String path);
        String onGetCurrentGroupMakeup(String index);
    }

    private static final int TYPE_BACK = 0;
    private static final int TYPE_ORIGINAL = 1;
    private static final int TYPE_NORMAL = 2;

    private String mGroupName;
    private int mGroupIconRes;
    private ImageView mGroupIconView;
    private TextView mGroupNameView;
    private RoundImageView mOriginalIcon;
    private List<MakeupItem> mMakeupItemList;
    private int mSelected;
    private int mGroupIndex;

    private OnMakeupItemClickedListener mListener;

    private LayoutInflater mInflater;

    public MakeupItemListAdapter(Context context, int group, String name,
                 int groupIconRes, OnMakeupItemClickedListener listener) {
        mInflater = LayoutInflater.from(context);
        mGroupIndex = group;
        mGroupName = name;
        mGroupIconRes = groupIconRes;
        mListener = listener;
        mMakeupItemList = MakeupManager.getMakeupItemList(context, group);
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int position) {
        int res = position == TYPE_BACK ? R.layout.makeup_item_back :
                position == TYPE_ORIGINAL ? R.layout.effect_item_original :
                        R.layout.makeup_item;
        View view = mInflater.inflate(res, viewGroup, false);
        if (position == TYPE_BACK) {
            mGroupNameView = view.findViewById(R.id.makeup_group_item_name);
            mGroupIconView = view.findViewById(R.id.makeup_group_item_image);
            return new MakeupGroupNameViewHolder(view);
        } else if (position == TYPE_ORIGINAL) {
            mOriginalIcon = view.findViewById(R.id.makeup_group_item_original_image);
        }
        return new MakeupItemViewHolder(view, position);
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder viewHolder, int position) {
        final int pos = viewHolder.getAdapterPosition();

        MakeupItemViewHolder holder = null;
        if (pos != 0) {
            holder = (MakeupItemViewHolder) viewHolder;
        }

        if (position == 0) {
            MakeupGroupNameViewHolder groupHolder = (MakeupGroupNameViewHolder) viewHolder;
            groupHolder.itemView.setActivated(mSelected >= 1 && mSelected != TYPE_ORIGINAL);
            mGroupNameView.setText(mGroupName);
            mGroupIconView.setImageResource(mGroupIconRes);
            groupHolder.itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    mSelected = pos;
                    if (mListener != null) {
                        mListener.onBackSelected();
                    }
                    notifyDataSetChanged();
                }
            });
        } else if (position == 1) {
            boolean selected = position == mSelected;
            holder.itemView.setActivated(selected);
            mOriginalIcon.setNeedBorder(selected);
            holder.itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    mSelected = pos;
                    if (mListener != null) {
                        mListener.onOriginalSelected(mGroupIndex,
                                MakeupManager.getMakeupIndexString(mGroupIndex));
                    }
                    notifyDataSetChanged();
                }
            });
        } else {
            final int makeupItemIndex = pos - 2;
            final MakeupItem item =  mMakeupItemList.get(makeupItemIndex);

            String currentMakeup = mListener.onGetCurrentGroupMakeup(mGroupName);
            if (item.makeupFile.equals(currentMakeup)) {
                mSelected = position;
            }

            boolean selected = position == mSelected;
            holder.itemView.setActivated(selected);
            holder.icon.setImageBitmap(item.icon);
            holder.icon.setNeedBorder(selected);
            holder.name.setText(item.name);
            holder.itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    mSelected = pos;
                    if (mListener != null) {
                        // Item list index differs
                        // RecyclerView position by 2
                        mListener.onMakeupItemSelected(mGroupIndex, makeupItemIndex,
                                MakeupManager.getMakeupIndexString(mGroupIndex),
                                item.makeupFile);
                    }
                    notifyDataSetChanged();
                }
            });
        }
    }

    @Override
    public int getItemViewType(int position) {
        return position == TYPE_BACK ? TYPE_BACK
                : position == TYPE_ORIGINAL ? TYPE_ORIGINAL
                : TYPE_NORMAL;
    }

    @Override
    public int getItemCount() {
        int effectCount = mMakeupItemList == null ? 0 : mMakeupItemList.size();
        return effectCount + 2;
    }

    private static class MakeupItemViewHolder extends RecyclerView.ViewHolder {
        public TextView name;
        public RoundImageView icon;
        public int group;

        MakeupItemViewHolder(@NonNull View itemView, int group) {
            super(itemView);
            this.group = group;
            name = itemView.findViewById(R.id.makeup_group_item_name);
            icon = itemView.findViewById(R.id.makeup_group_item_image);
        }
    }

    private static class MakeupGroupNameViewHolder extends RecyclerView.ViewHolder {
        MakeupGroupNameViewHolder(@NonNull View itemView) {
            super(itemView);
        }
    }
}
