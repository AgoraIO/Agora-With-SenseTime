package io.agora.rtcwithst.views.sensetime.sticker;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

import io.agora.rtcwithst.R;
import io.agora.rtcwithst.views.sensetime.widgets.RoundImageView;

public class StickerItemListAdapter extends RecyclerView.Adapter {
    public interface OnStickerItemClickedListener {
        void onStickerItemClicked(String path);
        void onStickerRemoved();
    }

    private static final int ORIGINAL_POSITION = 0;
    private static final int STICKER_POSITION = 1;

    private LayoutInflater mInflater;
    private List<StickerItem> mItemList;
    private int mSelected;
    private OnStickerItemClickedListener mListener;

    public StickerItemListAdapter(Context context,
                                  OnStickerItemClickedListener listener) {
        mInflater = LayoutInflater.from(context);
        mItemList = StickerManager.getStickerList(context);
        mListener = listener;
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int position) {
        if (position == ORIGINAL_POSITION) {
            View view = mInflater.inflate(R.layout.effect_item_original, viewGroup, false);
            return new StickerOriginalViewHolder(view);
        } else {
            View view = mInflater.inflate(R.layout.sticker_item, viewGroup, false);
            return new StickerItemViewHolder(view);
        }
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder viewHolder, final int position) {
        int adapterPos = viewHolder.getAdapterPosition();
        boolean selected = mSelected == adapterPos;
        viewHolder.itemView.setActivated(selected);

        if (adapterPos == ORIGINAL_POSITION) {
            StickerOriginalViewHolder holder = (StickerOriginalViewHolder) viewHolder;
            holder.icon.setNeedBorder(selected);
            holder.itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    mSelected = position;
                    notifyDataSetChanged();
                    if (mListener != null) {
                        mListener.onStickerRemoved();
                    }
                }
            });
        } else {
            StickerItemViewHolder holder = (StickerItemViewHolder) viewHolder;
            final StickerItem item = mItemList.get(adapterPos - 1);
            holder.icon.setImageBitmap(item.icon);
            holder.icon.setNeedBorder(selected);
            holder.name.setText(item.name);
            holder.itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    mSelected = position;
                    notifyDataSetChanged();
                    if (mListener != null) {
                        mListener.onStickerItemClicked(item.path);
                    }
                }
            });
        }
    }

    @Override
    public int getItemCount() {
        return mItemList == null ? 1 : mItemList.size() + 1;
    }

    @Override
    public int getItemViewType(int position) {
        return position == ORIGINAL_POSITION ? ORIGINAL_POSITION : STICKER_POSITION;
    }

    private static class StickerItemViewHolder extends RecyclerView.ViewHolder {
        RoundImageView icon;
        TextView name;

        StickerItemViewHolder(@NonNull View itemView) {
            super(itemView);
            icon = itemView.findViewById(R.id.sticker_item_image);
            name = itemView.findViewById(R.id.sticker_item_name);
        }
    }

    private static class StickerOriginalViewHolder extends RecyclerView.ViewHolder {
        RoundImageView icon;
        TextView name;

        StickerOriginalViewHolder(@NonNull View itemView) {
            super(itemView);
            icon = itemView.findViewById(R.id.makeup_group_item_original_image);
            name = itemView.findViewById(R.id.makeup_group_item_name);
        }
    }

}
