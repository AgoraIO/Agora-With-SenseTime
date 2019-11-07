package io.agora.rtcwithst.activities;

import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import io.agora.rtcwithst.Constant;
import io.agora.rtcwithst.R;

public class MainActivity extends BaseActivity implements TextWatcher {
    private EditText mChannelNameEdit;
    private Button mStartBroadcast;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initUI();
    }

    private void initUI() {
        setContentView(R.layout.activity_main);
        mChannelNameEdit = findViewById(R.id.edit_channel_name);
        mChannelNameEdit.addTextChangedListener(this);
        mStartBroadcast = findViewById(R.id.start_broadcast_btn);
        mStartBroadcast.setEnabled(!mChannelNameEdit.getText().toString().isEmpty());
    }

    @Override
    protected void onPermissionsGranted() {
        String channelName = mChannelNameEdit.getText().toString();
        if (!channelName.isEmpty()) {
            Intent intent = new Intent(this, LiveActivity.class);
            intent.putExtra(Constant.ACTION_KEY_ROOM_NAME, channelName);
            startActivity(intent);
        } else {
            Toast.makeText(this, R.string.empty_channel_name,
                    Toast.LENGTH_SHORT).show();
        }
    }

    @Override
    protected void onPermissionsFailed() {
        Toast.makeText(this, R.string.need_permissions,
                Toast.LENGTH_SHORT).show();
    }

    public void onStartBroadcastClick(View view) {
        checkPermission();
    }

    @Override
    public void beforeTextChanged(CharSequence s, int start, int count, int after) {

    }

    @Override
    public void onTextChanged(CharSequence s, int start, int before, int count) {

    }

    @Override
    public void afterTextChanged(Editable s) {
        mStartBroadcast.setEnabled(!s.toString().isEmpty());
    }
}
