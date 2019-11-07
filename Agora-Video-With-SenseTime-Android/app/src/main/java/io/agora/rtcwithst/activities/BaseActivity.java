package io.agora.rtcwithst.activities;

import android.Manifest;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import io.agora.framework.VideoModule;
import io.agora.rtc.RtcEngine;
import io.agora.rtcwithst.AgoraApplication;
import io.agora.rtcwithst.framework.PreprocessorSenseTime;
import io.agora.rtcwithst.rtc.IRtcEventHandler;

public abstract class BaseActivity extends AppCompatActivity {
    private static final int PERMISSION_REQUEST_CODE = 1;

    private static final String[] PERMISSIONS = {
            Manifest.permission.CAMERA,
            Manifest.permission.WRITE_EXTERNAL_STORAGE,
            Manifest.permission.RECORD_AUDIO
    };

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        configScreen();
        super.onCreate(savedInstanceState);
    }

    private void hideTitle() {
        requestWindowFeature(Window.FEATURE_NO_TITLE);
    }

    private void hideWindowStatusBar(Window window) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
            window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                    | View.SYSTEM_UI_FLAG_LAYOUT_STABLE);
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.setStatusBarColor(Color.TRANSPARENT);
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            window.addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
        }
    }

    private void keepScreenOn() {
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
    }

    private void configScreen() {
        hideTitle();
        hideWindowStatusBar(getWindow());
        keepScreenOn();
    }

    private boolean isPermissionGranted(String permission) {
        return ContextCompat.checkSelfPermission(
                getApplicationContext(), permission) ==
                PackageManager.PERMISSION_GRANTED;
    }

    protected void checkPermission() {
        boolean granted = true;
        for (String permission : PERMISSIONS) {
            granted = isPermissionGranted(permission);
            if (!granted) break;
        }

        if (granted) {
            onPermissionsGranted();
        } else {
            ActivityCompat.requestPermissions(this,
                    PERMISSIONS, PERMISSION_REQUEST_CODE);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode,
           @NonNull String[] permissions, @NonNull int[] grantResults) {
        if (requestCode == PERMISSION_REQUEST_CODE) {
            boolean granted = true;
            for (int result : grantResults) {
                granted = result == PackageManager.PERMISSION_GRANTED;
                if (!granted) break;
            }

            if (granted) {
                onPermissionsGranted();
            } else {
                onPermissionsFailed();
            }
        }
    }

    protected abstract void onPermissionsGranted();

    protected abstract void onPermissionsFailed();

    private AgoraApplication application() {
        return (AgoraApplication) getApplication();
    }

    public VideoModule videoModule() {
        return application().videoModule();
    }

    public RtcEngine rtcEngine() {
        return application().rtcEngine();
    }

    public void registerHandler(IRtcEventHandler handler) {
        application().registerEventHandler(handler);
    }

    public void removeHandler(IRtcEventHandler handler) {
        application().removeEventHandler(handler);
    }

    public PreprocessorSenseTime getSenseTimeRender() {
        return application().getSenseTimeRender();
    }
}
