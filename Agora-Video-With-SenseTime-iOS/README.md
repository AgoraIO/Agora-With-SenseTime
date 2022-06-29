# 运行项目 需要集成商汤SDK

#### 注意事项
 使用商汤8.8.0版本SDK

1.添加remoteSourcesLib下面 include文件夹 和 `libSenseArSourceService.a`库

2.st_mobile_sdk下面添加 `models` `include` `ios_os_universal` 这三个文件中所有资源集成进项目中

3.修改`KeyCenter.m`中 `AppId`