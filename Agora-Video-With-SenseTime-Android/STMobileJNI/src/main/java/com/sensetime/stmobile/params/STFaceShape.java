package com.sensetime.stmobile.params;

public enum STFaceShape {
    ST_FACE_SHAPE_UNKNOWN(0),      /// 未知类型
    ST_FACE_SHAPE_NATURAL(1),      /// 自然
    ST_FACE_SHAPE_ROUND(2),        /// 圆脸
    ST_FACE_SHAPE_SQUARE(3),       /// 方脸
    ST_FACE_SHAPE_LONG(4),         /// 长脸
    ST_FACE_SHAPE_RECTANGLE(5);     /// 长形脸

    private final int shape;

    STFaceShape(int shape) {
        this.shape = shape;
    }

    public int getShape() {
        return shape;
    }
}
