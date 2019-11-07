package io.agora.rtcwithst.views.sensetime.filter;

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

public class FilterListAdapter extends RecyclerView.Adapter {
    public interface OnFilterSelectedListener {
        void onFilterSelected(String modelPath, float strength);
        void onFilterChanged(int index);
        String onGetCurrentFilterPath();
    }

    private LayoutInflater mInflater;
    private List<FilterItem> mFilterItemList;
    private int mSelected;
    private OnFilterSelectedListener mListener;

    public FilterListAdapter(Context context, OnFilterSelectedListener listener) {
        mInflater = LayoutInflater.from(context);
        mFilterItemList = FilterManager.getFilterList(context);
        mListener = listener;
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int position) {
        View view = mInflater.inflate(R.layout.filter_item_layout, viewGroup, false);
        return new FilterItemViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder viewHolder, int position) {
        final int adapterPos = viewHolder.getAdapterPosition();
        FilterItemViewHolder holder = (FilterItemViewHolder) viewHolder;
        final FilterItem item = mFilterItemList.get(adapterPos);
        holder.icon.setImageBitmap(item.icon);
        holder.text.setText(item.name);

        // If currently Sense Time has set a filter beforehand,
        // Get the filter model file path and select.
        String currentPath = (mListener != null) ? mListener.onGetCurrentFilterPath() : null;
        if (item.model != null && item.model.equals(currentPath)) {
            mSelected = adapterPos;
        }

        holder.container.setActivated(adapterPos == mSelected);

        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mSelected != adapterPos && mListener != null) {
                    mListener.onFilterChanged(adapterPos);
                }

                mSelected = adapterPos;
                notifyDataSetChanged();
                if (mListener != null) {
                    mListener.onFilterSelected(mSelected == 0 ? null : item.model, item.strength);
                }
            }
        });
    }

    @Override
    public int getItemCount() {
        return mFilterItemList == null ? 0 : mFilterItemList.size();
    }

    public int getSelected() {
        return mSelected;
    }

    private FilterItem getItem(int index) {
        return mFilterItemList.get(index);
    }

    public int getStrength(int index) {
        // filter strength of range [0, 1] to
        // progress [0, 100]
        return (int) (getItem(index).strength * 100);
    }

    public void setStrength(int index, int strength) {
        getItem(index).strength = strength;
        changeFilterStrength(strength);
    }

    /**
     * Called when the strength of filter is changed by the SeekBar
     * @param strength
     */
    public void changeFilterStrength(int strength) {
        FilterItem item = mFilterItemList.get(mSelected);
        if (strength != item.strength && mListener != null) {
            item.strength = strength;
            mListener.onFilterSelected(item.model, item.strength);
        }
    }

    private static class FilterItemViewHolder extends RecyclerView.ViewHolder {
        public ImageView icon;
        public TextView text;
        public View container;

        public FilterItemViewHolder(@NonNull View itemView) {
            super(itemView);
            icon = itemView.findViewById(R.id.filter_image);
            text = itemView.findViewById(R.id.filter_text);
            container = itemView.findViewById(R.id.filter_image_container);
        }
    }
}
