package io.agora.rtcwithst.views.sensetime;

import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import io.agora.rtcwithst.R;
import io.agora.rtcwithst.views.sensetime.beauty.BeautyOptionConfig;

public class EffectGroupListAdapter extends RecyclerView.Adapter {
    private static final int GROUP_COUNT = BeautyOptionConfig.GROUP_COUNT;
    private static final int GROUP_TEXT_SIZE = 16;
    private static final int GROUP_TEXT_MARGIN = 42;
    private static final int TEXT_VIEW_ID = 1 << 8;

    private int mSelectedIndex;
    private OnGroupClickedListener mListener;

    public EffectGroupListAdapter(OnGroupClickedListener listener) {
        mListener = listener;
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int position) {
        RelativeLayout layout = new RelativeLayout(viewGroup.getContext());

        TextView text = new TextView(layout.getContext());
        text.setId(TEXT_VIEW_ID);
        text.setText(BeautyOptionConfig.GROUP_NAMES[position]);
        text.setTextColor(text.getContext().getResources().
                getColorStateList(R.color.beauty_option_text_color));
        text.setTextSize(GROUP_TEXT_SIZE);
        text.setTextAlignment(View.TEXT_ALIGNMENT_GRAVITY);
        text.setGravity(Gravity.CENTER);

        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(
                RelativeLayout.LayoutParams.MATCH_PARENT,
                RelativeLayout.LayoutParams.MATCH_PARENT
        );
        params.leftMargin = GROUP_TEXT_MARGIN;
        params.rightMargin = GROUP_TEXT_MARGIN;

        layout.addView(text, params);
        return new BeautyOptionGroupItemViewHolder(layout);
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder viewHolder, final int position) {
        TextView text = ((BeautyOptionGroupItemViewHolder) viewHolder).mGroupName;
        text.setText(BeautyOptionConfig.GROUP_NAMES[position]);
        text.setActivated(position == mSelectedIndex);

        viewHolder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mSelectedIndex = position;
                notifyDataSetChanged();
                if (mListener != null) {
                    mListener.onGroupClicked(position);
                }
            }
        });
    }

    @Override
    public int getItemCount() {
        return GROUP_COUNT;
    }

    private static class BeautyOptionGroupItemViewHolder extends RecyclerView.ViewHolder {
        TextView mGroupName;

        BeautyOptionGroupItemViewHolder(@NonNull View itemView) {
            super(itemView);
            mGroupName = itemView.findViewById(TEXT_VIEW_ID);
        }
    }

    public interface OnGroupClickedListener {
        void onGroupClicked(int position);
    }
}
