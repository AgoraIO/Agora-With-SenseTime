package com.sensetime.stmobile.params;

public enum STResultCode {
    ST_OK(0),                           ///< 正常运行
    ST_E_INVALIDARG(-1),                ///< 无效参数
    ST_E_HANDLE(-2),                    ///< 句柄错误
    ST_E_OUTOFMEMORY(-3),               ///< 内存不足
    ST_E_FAIL(-4),                      ///< 内部错误
    ST_E_DELNOTFOUND(-5),               ///< 定义缺失
    ST_E_INVALID_PIXEL_FORMAT(-6),      ///< 不支持的图像格式
    ST_E_FILE_NOT_FOUND(-7),            ///< 模型文件不存在
    ST_E_INVALID_FILE_FORMAT(-8),       ///< 模型格式不正确，导致加载失败
    ST_E_FILE_EXPIRE(-9),               ///< 模型文件过期
    ST_E_INVALID_AUTH(-13),             ///< license不合法
    ST_E_INVALID_APPID(-14),            ///< 包名错误
    ST_E_AUTH_EXPIRE(-15),              ///< license过期
    ST_E_UUID_MISMATCH(-16),            ///< UUID不匹配
    ST_E_ONLINE_AUTH_CONNECT_FAIL(-17), ///< 在线验证连接失败
    ST_E_ONLINE_AUTH_TIMEOUT(-18),      ///< 在线验证超时
    ST_E_ONLINE_AUTH_INVALID(-19),      ///< 在线签发服务器端返回错误
    ST_E_LICENSE_IS_NOT_ACTIVABLE(-20), ///< license不可激活
    ST_E_ACTIVE_FAIL(-21),              ///< license激活失败
    ST_E_ACTIVE_CODE_INVALID(-22),      ///< 激活码无效
    ST_E_NO_CAPABILITY(-23),            ///< license文件没有提供这个能力
    ST_E_PLATFORM_NOTSUPPORTED(-24),    ///< license不支持这个平台
    ST_E_SUBMODEL_NOT_EXIST(-26),       ///< 子模型不存在
    ST_E_ONLINE_ACTIVATE_NO_NEED(-27),  ///< 不需要在线激活
    ST_E_ONLINE_ACTIVATE_FAIL(-28),     ///< 在线激活失败
    ST_E_ONLINE_ACTIVATE_CODE_INVALID(-29), ///< 在线激活码无效
    ST_E_ONLINE_ACTIVATE_CONNECT_FAIL(-30), ///< 在线激活连接失败
    ST_E_UNSUPPORTED_ZIP(-32),          ///< 当前sdk不支持的素材包
    ST_E_ZIP_EXIST_IN_MEMORY(-33),      ///< 素材包已存在在内存中，不重复加载
    ST_E_NOT_CONNECT_TO_NETWORK(-34),   ///< 设备没有联网
    ST_E_OTHER_LINK_ERRORS_IN_HTTPS(-35), ///< https中的其他链接错误
    ST_E_CERTIFICAT_NOT_BE_TRUSTED(-36), ///< windows系统有病毒或被黑导致证书不被信任

    ST_E_LICENSE_LIMIT_EXCEEDED(-37),          ///< license激活次数已用完
    ST_E_NOFACE(-38),                     	 ///< 没有检测到人脸
    ST_E_API_UNSUPPORTED(-39),                 ///< 该API暂不支持
    ST_E_API_DEPRECATED(-40),                  ///< 该API已标记为废弃，应替换其他API或停止使用
    ST_E_ARG_UNSUPPORTED(-41),                 ///< 该参数不支持
    ST_E_PRECONDITION(-42),                    ///< 前置条件不满足
    ST_E_SIGN_ACTIVATION_CODE_TOKEN_EXPIRE(-43),  ///< 激活码token过期
    ST_E_SIGN_ACTIVATION_CODE_EXPIRE(-44),     ///< 激活码过期

    // rendering related errors.
    ST_E_INVALID_GL_CONTEXT(-100),              ///< OpenGL Context错误，当前为空，或不一致
    ST_E_RENDER_DISABLED(-101);                 ///< 创建句柄时候没有开启渲染

    private final int resultCode;

    STResultCode(int resultCode) {
        this.resultCode = resultCode;
    }

    public int getResultCode() {
        return resultCode;
    }
}
