
# 联系方式

- 手机：17638588831
- Email：s2288156@163.com
- 微信号：17638588831

# 个人信息

 - 武春阳/男/1990 
 - 本科/中国石油大学
 - 工作年限：6年
 - 技术博客：https://juejin.im/user/4300945217299949
 - Github：https://github.com/s2288156

 - 期望职位：JAVA高级程序员，架构师，Team Leader
 - 期望薪资：税前月薪15k~20k，特别喜欢的公司可例外
 - 期望城市：郑州


# 工作经历

## 河南紫云智慧城市运营技术服务有限公司（ 20l9年3月 ~ 至今 ）

公司产品为智慧城市APP，与政府部门、银行等机构合作，为市民提供支付、医疗、政务、社区、智慧旅游、智慧党建、校园等场景的服务。在2020年新冠疫情全国爆发期间，为开封市大数据提供了开封市防疫健康码的服务，得到了开封市政府的高度认可，促使开封汴捷办APP成为本公司在河南省第一个落地的APP。后续公司陆续落地APP包括：周口通、放新办（新乡）等等。

公司技术架构以微服务为理念，主要服务包含app后台服务、订单中心、统一支付平台、卡务系统、停车系统、党建服务、社区服务、疫情服务等等，服务之间通过dubbo和Active Mq交互。

本人在公司担任高级研发工程师，主要负责支付相关业务，后独立为一个小组，担任Team Leader，负责订单中心、统一支付中心的设计，以及项目整体建设。在职期间，除了正常的项目研发，在职期间还推动了研发部以下工作:

1. 调研了配置中心，主导了公司项目全部接入配置中心，并在后期对中间件通用配置进行了抽离，统一了公司全部项目的通用配置
2. 抽离了业务服务中直接集成第三方接口业务如：立方网络缴费模块、微信支付、银联支付、支付宝支付等第三方能力，已jar包的方式，通过maven私服，集成到业务系统中。主要解决了以下问题：
    - 第三方接口属于通用能力，通过代码间的物理隔离，保证第三方接口封装中不会存在业务逻辑
    - 不同的第三方业务为独立的module，更利于维护和升级
    - 通过封装，屏蔽了业务代码不需要关心的参数，对业务模块提供更为精简的api接口，提高开发效率
3. 搭建了ELK日志搜集平台，并推广使用
4. 调研了ansible自动化运维工具，通过ansible实现了ELK集群的部署维护
5. 基于CAP理论，以及更方便接入gateway的考虑，将dubbo注册中心由zk替换为nacos，并接入spring cloud gateway网关
6. 为gateway集成sentinel限流，结合配置中心，实现限流规则在不重启任何服务的情况下，动态更新限流规则
7. 为公司搭建了jira平台，并根据公司情况，重新设计了jira工作流，为需求分解、工期评估、项目进度把控、版本管理提供了有效的管控

### 订单中心

订单中心的功能是为公司各业务服务，以及外部合作的第三方，提供通用的订单能力，包括：订单创建、订单支付、订单关闭、退款等能力。

订单中心的旨在提供标准的订单服务，为公司内部各业务服务，如：水电煤缴费、手机充值、停车缴费、党费缴费、商城等；以及第三方外部应用，如：医院His系统、小牵家教等提供标准的订单能力，包括：订单创建、订单支付、订单关闭等能力，依靠统一支付平台实现不同渠道的支付。

### 统一支付平台

统一支付平台主要是为订单中心提供支付能力，与平安银行旗下产品见证宝合作，提供了基于见证宝的用户和商户体系，包含三类户和银行卡快捷支付能力。同时支付平台也集成了微信服务商、支付宝服务商，以及银联无跳转支付等标准支付产品。为APP、公众号、微信小程序提供了统一的支付能力，包含：二维码支付、订单支付。同时，也提供了完备的运营端和商户端能力。

运营端：
1. 卡bin管理，对前端进行三类户绑卡、银联绑卡功能支持的银行进行控制，运营人员可以根据公司战略实时的控制用户可以绑定的银行；
2. 支付方式配置，运营人员可以通过修改配置，实时控制APP对用户开放的支付渠道，如：微信、支付宝、电子账户、银联；
3. 终端管理，管理支付终端，支付终端配合前端应用二维码，实现对二维码支付的管理与控制；
4. 交易管理，主要提供交易记录查询；
5. 商户管理，添加商户、审核商户申请、商户状态管理、商户三类户提现周期、提现手续费设置等；

商户端：
1. 商户注册账号后，可以通过提交商户信息由运营人员审核，审核通过后可开通对应的收单渠道；
2. 商户三类户账户资金管理，可设置和重置支付密码，并进行结算、提现；
3. 多渠道（微信、支付宝、银联、见证宝）对账单查询和下载；


同时，也提供了完善的后台运营能力，使得公司运营人员进行商户管理、支付会员管理、交易管理、对账查询、支付方式配置等能力。商户端，提供了商户的交易查询、商户收单账户的添加、收款渠道的配置、交易金额的结算提现、对账等功能。

### 通用第三方服务封装（starter）

- Fastdfs文件上传
- 银联支付
- 微信支付
- 支付宝支付
- 平安银行见证宝

## 郑州易宝科技有限公司（ 20l7年10月 ~ 2019年3月 ）

### 中移在线业务中台-任务受理中心

任务受理中心是借鉴工序化作业的理念，对业务进行拆解，前段保持便捷化、轻量化，以订单采集为主，将重量级的业务实现和交付类工作快速甩单到中台实施集中化、规范化处理。

### 中移在线一体化客服-客户群项目

根据用户特点对用户进行分类，通过分类到不同的客户群进行管理，在将用户纳入到客户群系统管理后，客户在来电的同时，坐席可以根据前台展示的客户群标签来确认来电客户的客户群类型，并根据不同客户群提前制定好沟通技巧与方式，精准有效的对客户进行服务与营销，提升客户满意度和营销成功率。

### 中移在线一体化客服-接触查询项目

记录坐席在与用户接触过程中所有的记录，包括通话录音、转接操作、短信操作、通话时长等，有效的帮助业务部门在话务量统计、服务质量、以及投诉复查等方面提供了数据支持，并通过ES、分库分表等改造，有效的支撑了全国31省平均每个月900W数据1.5年存储周期的查询能力。

### 中一在线一体化客服-短彩信项目

统一了全国各省分公司的短信接口标准化，接入短信发送、满意度短信发送能力，对外围系统提供了统一的接口，使得外围系统发送短信可以通过调用短彩信单一接口，实现全网短信的发送，并提供了发送短信、短信模板、短信收藏、批量发送等页面

## 北京毫末科技有限公司 （ 20l5年4月 ~ 2017年9月 ）

### 农业物联网项目

本期项目中的物联网技术服务平台以科研功能、公众服务、企业服务和推广示范为目标，建设全国农业物联网科学家交流对接模块。平台用户主要分为两类，科研人员和企业人员，科研用户可以通过本平台进行科研团队的创建、管理，以及科研任务的发布，进度的跟踪。企业用户可以通过认证企业账号，在平台上进行企业产品的展示与交易。同时可以对产品申请进行检测，申请后的产品会分配给相关的科研人员进行检测。

### 文献管理展示系统

用户将书籍整理为excel的特定格式，通过管理系统读取excel文件，存取到数据库，通过数据库和后台进行管理，并展示给用户浏览，查看。主要的难点在于整理的excel排版格式较多，需要对格式进行判断，并设置书->卷->标题->段落，以及段落正文中的人名、地名、年号等信息的关系，同时加入对应的HTML标签，方便前台获取数据后可以直接用作静态页面展示

# 开源项目和作品

## 开源项目
（对于程序员来讲，没有什么比Show me the code能有说服力了）

  - [asktao(问道)](https://github.com/s2288156/asktao)：基于springboot，对微服务架构各模块集成、使用、项目分层、代码风格的一些探索，包含：gateway、nacos、openFeign、sentinel、mybatis、rocketMQ、spring security、spring Oauth2等。同时，实现了简单的商城和权限管理系统。 

## 技术文章
（挑选你写作或翻译的技术文章，好的文章可以从侧面证实你的表达和沟通能力，也帮助招聘方更了解你）

- [一个产品经理眼中的云计算：前生今世和未来](http://get.jobdeer.com/706.get)
- [来自HeroKu的HTTP API 设计指南(翻译文章)](http://get.jobdeer.com/343.get) （ 好的翻译文章可以侧证你对英文技术文档的阅读能力）

# 技能清单

以下均为我熟练使用的技能

- 后端：Java/Springboot/RocketMQ/Flyway
- 微服务：SpringCloud Gateway/Nacos/Docker/Sentinel/OpenFeign/Dubbo
- 前端：Vue/elementui/css/Html
- 数据库相关：MySQL/Redis/Elasticsearch
- 版本管理、文档和自动化部署工具：Git/Jenkins/Jira/Ansible/
      
---      
# 致谢

感谢您花时间阅读我的简历，期待能有机会和您共事。