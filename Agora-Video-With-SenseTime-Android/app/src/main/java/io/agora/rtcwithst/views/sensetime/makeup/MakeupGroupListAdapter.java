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

public class MakeupGroupListAdapter extends RecyclerView.Adapter {
    interface OnMakeupGroupSelectedListener {
        void onMakeupGroupSelected(int groupIndex);
    }

    private LayoutInflater mInflater;
    private List<MakeupGroupItem> mItemList;
    private OnMakeupGroupSelectedListener mListener;

    public MakeupGroupListAdapter(Context context,
                                  OnMakeupGroupSelectedListener listener) {
        mInflater = LayoutInflater.from(context);
        mItemList = MakeupManager.getMakeupGroupItemList();
        mListener = listener;
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int position) {
        View container = mInflater.inflate(R.layout.makeup_group_item, viewGroup,false);
        return new MakeupGroupListViewHolder(container);
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder viewHolder, int position) {
        MakeupGroupListViewHolder holder = (MakeupGroupListViewHolder) viewHolder;
        final int pos = viewHolder.getAdapterPosition();
        MakeupGroupItem item = mItemList.get(pos);
        holder.itemView.setActivated(item.activated);
        holder.imageView.setImageResource(item.iconRes);
        holder.textView.setText(item.name);

        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mListener != null) {
                    mListener.onMakeupGroupSelected(pos);
                }
            }
        });
    }

    @Override
    public int getItemCount() {
        return mItemList == null ? 0 : mItemList.size();
    }

    private static class MakeupGroupListViewHolder extends RecyclerView.ViewHolder {
        ImageView imageView;
        TextView textView;

        MakeupGroupListViewHolder(@NonNull View itemView) {
            super(itemView);
            imageView = itemView.findViewById(R.id.makeup_group_item_image);
            textView = itemView.findViewById(R.id.makeup_group_item_name);
        }
    }

    /**
     * Set the group activated if some makeup effect is
     * taken effect under the group
     */
    public void setItemActivated(int groupIndex, boolean activated) {
        if (groupIndex < 0 || groupIndex >= getItemCount()) {
            return;
        }

        mItemList.get(groupIndex).activated = activated;
    }
}
