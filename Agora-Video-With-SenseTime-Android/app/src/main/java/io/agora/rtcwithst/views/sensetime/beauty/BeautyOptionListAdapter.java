package io.agora.rtcwithst.views.sensetime.beauty;

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

public class BeautyOptionListAdapter extends RecyclerView.Adapter {
    public interface OnBeautyOptionItemClickedListener {
        void onBeautyOptionClicked(int group, int index);

        // Used to get the actual param values from preprocessor,
        // and then translate the float values to UI progress.
        int onGetBeautyOptionProgress(int group, int index);
    }

    private List<BeautyOptionItem> mItemList;
    private LayoutInflater mInflater;
    private int mGroupId;
    private int mSelected;

    private OnBeautyOptionItemClickedListener mListener;

    public BeautyOptionListAdapter(Context context, int group, List<BeautyOptionItem> list,
                                   OnBeautyOptionItemClickedListener listener) {
        mItemList = list;
        mGroupId = group;
        mListener = listener;
        mInflater = LayoutInflater.from(context);
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int position) {
        View view = mInflater.inflate(R.layout.beauty_option_item_layout, viewGroup, false);
        return new BeautyOptionListAdapterViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder viewHolder, int position) {
        BeautyOptionListAdapterViewHolder holder = (BeautyOptionListAdapterViewHolder) viewHolder;
        final int adapterPosition = holder.getAdapterPosition();
        BeautyOptionItem item = mItemList.get(adapterPosition);
        item.setProgress(mListener.onGetBeautyOptionProgress(mGroupId, position));
        holder.mIcon.setImageResource(item.getIconRes());
        holder.mName.setText(item.getText());
        holder.mSubscript.setText(String.valueOf(item.getProgress()));

        boolean activated = mSelected == position;
        holder.mIcon.setActivated(activated);
        holder.mName.setActivated(activated);
        holder.mSubscript.setActivated(activated);

        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mSelected = adapterPosition;
                notifyDataSetChanged();
                if (mListener != null) {
                    mListener.onBeautyOptionClicked(mGroupId, adapterPosition);
                }
            }
        });
    }

    @Override
    public int getItemCount() {
        return mItemList == null ? 0 : mItemList.size();
    }

    public int getSelected() {
        return mSelected;
    }

    private static class BeautyOptionListAdapterViewHolder extends RecyclerView.ViewHolder {
        ImageView mIcon;
        TextView mName;
        TextView mSubscript;

        BeautyOptionListAdapterViewHolder(@NonNull View itemView) {
            super(itemView);
            mIcon = itemView.findViewById(R.id.beauty_option_item_icon);
            mName = itemView.findViewById(R.id.beauty_option_item_name);
            mSubscript = itemView.findViewById(R.id.beauty_item_subscription);
        }
    }
}
