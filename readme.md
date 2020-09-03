### XNNetwork 网络库说明文档（基于Alamofire）

***

导入方式：

* pod 'XNNetwork'</br>

***

* <a href="#1">功能支持</a>
* <a href="#2">业务类说明</a>
* <a href="#3">解决问题示例</a>
* <a href="#4">待完善部分</a>

***

####  <a name="1">功能支持</a>
1. 序列化方式
2. 请求方式
3. 域名配置
4. 域名对应结构键值配置
5. 域名对应错误类型配置
6. 网络缓存配置
7. 请求拦截处理

***

####  <a name="2">业务类说明</a>

<font color=#009999 size=3>XNBaseAPIManager（业务基类）</font>


包含代理：

* XNRequestConfigutionDelegate</br>
`序列化、请求方式、URI、域名、缓存配置`

* XNRequestDomainConfigutionDelegate</br>
`XNAPIConfiguration对应的域名先关配置`

* XNRequestParamsDelegate</br>
`参数配置`

* XNRequestValidatorDelegate</br>
`请求发起前的校验`

* XNRequestCallbackDelegate</br>
`回调处理,处理前的拦截处理`

包含公共方法：

* requestWithURI\:params\:successBlock\:failedBlock\:</br>
`通过必要业务传参直接发起请求，并在回调中处理先关逻辑`

父类方法：
* 发起请求、取消请求、批量取消请求</br>

<font color=#009999 size=3>XNAPIConfiguration（配置类，针对域名）</font>

* 介绍</br>
`支持多域名注册，域名相关配置，以配置的形式兼容不同域名见返回及定义的差异，公共header、body的配置`

***

####  <a name="3">解决问题示例</a>

* 同域名下不同接口结构的统一配置</br>
`继承XNBaseAPIManager，更改需要变动的代理中的方法，通过简便公用方法调用，或一个接口对应一个子类（以支持模块化的拓展）`

* 不同项目通过配置的形式快速接入网络库，脱离大规模的复制粘贴</br>
`详情见XNAPIConfiguration中注释`

* 通过配置的形式对应不同的错误状态，以枚举的形式统一并暴露错误状态，提高代码可读性</br>

* 提供拦截方法，以处理不同状态下的事件，可统一也可针对某些接口，拦截后自行处理需不需要继续执行接下来的回调逻辑</br>
`比如登录、token过期时，需要进行相关的业务`

* 网络库模块化，之后通过版本控制工具引入即可，使用时引入XNNetwork.h头文件</br>

***

####  <a name="4">待完善部分</a>

* 下载、上传封装</br>

* 其他网络相关便捷方法</br>
`比如网络监测部分逻辑，与本库的关联性方面`