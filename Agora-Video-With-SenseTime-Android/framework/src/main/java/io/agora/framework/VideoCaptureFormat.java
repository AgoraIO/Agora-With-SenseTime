// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.agora.framework;

public class VideoCaptureFormat {
    protected int mWidth;
    protected int mHeight;
    protected int mFrameRate;
    protected int mFormat;

    public VideoCaptureFormat(int width, int height, int framerate, int format) {
        mWidth = width;
        mHeight = height;
        mFrameRate = framerate;
        mFormat = format;
    }

    public int getWidth() {
        return mWidth;
    }

    public void setWidth(int width) {
        mWidth = width;
    }

    public int getHeight() {
        return mHeight;
    }

    public void setHeight(int height) {
        mHeight = height;
    }

    public int getFramerate() {
        return mFrameRate;
    }

    public int getPixelFormat() {
        return mFormat;
    }

    public void setPixelFormat(int format) {
        mFormat = format;
    }

    public String toString() {
        return "VideoCaptureFormat{" +
                "mFormat=" + mFormat +
                "mFrameRate=" + mFrameRate +
                ", mWidth=" + mWidth +
                ", mHeight=" + mHeight +
                '}';
    }
}
