package com.sensetime.stmobile;

/**
 *body beauty result
 */
public class STBodyBeautifyResult {

    public final static int ST_BODY_BEAUTIFY_RESULT_SUCCEED = 0;            /// body beauty succeed
    public final static int ST_BODY_BEAUTIFY_RESULT_PARAM_EMPTY = 1;        /// body beauty params empty, no effect
    public final static int ST_BODY_BEAUTIFY_RESULT_NO_BODY = 2;            /// no body in image, no effect
    public final static int ST_BODY_BEAUTIFY_RESULT_BODY_OCCLUDED = 3;      /// no enough quantity of key points, no effect
    public final static int ST_BODY_BEAUTIFY_RESULT_NO_CAPABILITY = 4;      /// sdk no capability，no effect
    public final static int ST_BODY_BEAUTIFY_RESULT_OTHER_ERROR = 5;        /// other error，no effect
}
