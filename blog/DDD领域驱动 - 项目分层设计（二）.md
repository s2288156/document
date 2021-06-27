[toc]

![](https://images.unsplash.com/photo-1469334031218-e382a71b716b?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80)

最近看到了阿里团队分享的几篇关于DDD的文章，对自己启发挺大的，这里做一个总结、记录、学习分享。内容比较多，具体可以看原文，这里对文章做一下提炼总结，方便大家有个全局的认识。

> 参考文章：
>
> [阿里技术专家详解 DDD 系列- Domain Primitive ](https://segmentfault.com/a/1190000020270851)
>
> [殷浩详解DDD：如何避免写流水账代码？](https://mp.weixin.qq.com/s/SjU1DbsXcBD-2DJt9z65zg)
>
> 往期文章：
>
> [DDD领域驱动 - 设计聚合](https://juejin.im/post/6893875509726773255)

# 1. Domain Primitive



## 1.1. 什么是Primitive

> Primitive的定义: 原始的



这里先不解释Domain Primitive，先做个类比，Java Primitive，像String、Integer、Long等，这些可以称为Java编程语言的Primitive，它们是Java的基础。



但这些类型是在编程语言层面，对于领域来说，关联性就很小，所以就有了Domain Primitive的定义，那么什么是Domain的基础呢，Domain是用来处理复杂业务的，是业务相关的，所以它的Primitive应该是有业务属性的，显然String、Integer没有业务属性。



所以Domain Primitive其实进一步的封装，举个栗子，比如要注册一个用户：

```java
public class User {
    Long userId;
    String name;
    String phone;
    String address;
    Long repId;
}

public interface RegistrationService {
    User register(String name, String phone, String address);
}
// 这种方式调用放register("13312331233", "张三", "beijing")，代码这样写出来，编译也是可以通过的。
```

这样的入参形式三个String类型是和业务无关，在调用过程中如果字段传入顺序错误，编码过程中是很难发现的，可能只有在代码发布，甚至上线后才被发现。



再看一下另一种方式：

```java
public class User {
    UserId userId;
    Name name;
    PhoneNumber phone;
    Address address;
    RepId repId;
}

public class Name {
    private finale String name;
    
    public Name(String name) {
        if(StringUtils.isBlank(name)) {
            throw new ValidationException("name不能为空");
        }
    }
    
    public String getName() {
        return name;
    }
}

public class PhoneNumber {

    private final String number;
    public String getNumber() {
        return number;
    }

    public PhoneNumber(String number) {
        if (number == null) {
            throw new ValidationException("number不能为空");
        } else if (isValid(number)) {
            throw new ValidationException("number格式错误");
        }
        this.number = number;
    }
}

public interface RegistrationService {
    User register(Name name, PhoneNumber phone, Address address);
}
```

分析下这样的方式：

1. 将String字段，封装为一个具体的对象，在构造方法中加入校验逻辑，所以只要这个对象创建成功，则说明其必然是合法的；
2. 入参每个值都有对应的对象，所以不存在传错参数的问题，如果传错，直接在编译器就能发现。

这种形式，就是Domain Primitive。

## 1.2. Domain Primitive总结

**Domain Primitive定义：**

- DP是一个传统意义上的Value Object，拥有Immutable的特性
- DP是一个完整的概念整体，拥有精准定义
- DP使用业务域中的原生语言
- DP可以是业务域的最小组成部分、也可以构建复杂组合



使用Domain Primitive三原则：

- 让隐性的概念显性化
- 让隐性的上下文显性化
- 封装多对象行为

# 2. DDD代码分层

这方面可以参考下阿里工程师开源的COLA4.0脚手架 -> [alibaba/COLA: 🥤 COLA: Clean Object-oriented & Layered Architecture (github.com)](https://github.com/alibaba/COLA/)

## 2.1. Interface层

接口层作为对外的门户，将网络协议与业务逻辑解耦。可以包含鉴权、Session管理、限流、异常处理、日志等功能，当然如果有一个统一的网关服务的话，可以抽离出鉴权、Session、限流、日志等逻辑。

### 返回值

接口层返回值统一封装`Response`对象，比如在COLA架构中，返回值分为四个：`Response` / `SingleResponse` / `PageResponse` / `MultiResponse`

具体细节没有展示，每个公司可能都有封装这样的对象，实现细节大同小异

```java
public class Response extends DTO {
    private static final long serialVersionUID = 1L;
    private boolean success;
    private String errCode;
    private String errMessage;
}

public class SingleResponse<T> extends Response {
    private T data;   
}    

public class PageResponse<T> extends Response {
    private static final long serialVersionUID = 1L;
    private int totalCount = 0;
    private int pageSize = 1;
    private int pageIndex = 1;
    private Collection<T> data;   
}

public class MultiResponse<T> extends Response {
    private static final long serialVersionUID = 1L;
    private Collection<T> data;
}    
```

### Interface层的接口数量与业务间的隔离



> 一个Interface层的类应该是“小而美”的，应该是面向“一个单一的业务”或“一类同样需求的业务”，需要尽量避免用同一个类承接不同类型业务的需求。



## 2.2. Application层

Application层的几个核心类：

- Service应用服务：负责业务流程编排但本身不负责任何业务逻辑
- DTO Assembler：负责将内部领域模型转化为可对外的DTO
- Command、Query、Event对象：作为ApplicationService的入参
- 返回DTO：作为Service的出参

### Command、Query、Event对象

- **Command: **对系统进行操作的指令，通常为写操作，涉及到“增、删、改”。通常指需要一个明确的返回值。
- **Query: **指调用方查询操作，包含查询参数、过滤、分页等条件，属于**只读**操作。
- **Event: **指一件已经发生过的既有事实，需要系统根据这个事实作出改变或者响应的，通常事件处理都会有一定的写操作。事件处理器一般不会有返回值，为异步操作。

> **CQE规范：** ApplicationService的接口入参只能是一个Command、Query、Event对象，需要能代表当前方法的**语义**。唯一可以例外的是单一ID查询，可以省略一个Query对象。

### CQE vs DTO

表面上看，两种对象都是简单的POJO对象，但其实是有很大区别的：

- **CQE: **是ApplicationService的输入，有明确的“意图”，对象的内部需要保证其**正确性**。
  - 每一个CQE都是有明确“**意图**”的，所以要尽量避免CQE的复用，哪怕所有参数都一样，只要语义不同，就**不应该复用**。
- **DTO: ** 只是数据容器，只是为了和外部交互，所以本身不包含任何逻辑，只是贫血对象。

因为CQE是有“意图”的，所以，理论上CQE的数量是无限的。但DTO作为数据容器，是和模型对应的，所以是有限的。

### ApplicationService

当一个领域中流程较多，每一个流程对应一个或多个方法，将这些方法都收敛到一个service类中，好处是有一个完整的业务流程，流程清晰。但缺点是，这样会导致service中代码量过大。

可以通过`CommandHandler、EventHandler`来降低代码量，同时，不要在ApplicationService中定义`private`方法：

```java
@Component
public class CheckoutCommandHandler implements CommandHandler<CheckoutCommand, OrderDTO> {
    @Override
    public OrderDTO handle(CheckoutCommand cmd) {
        // ....
    }
}
// ApplicationService
public class CheckoutServiceImpl implements CheckoutService {
    @Resource
    private CheckoutCommandHandler checkoutCommandHandler;
    
    @Override
    public OrderDTO checkout(@Valid CheckoutCommand cmd) {
        return checkoutCommandHandler.handle(cmd);
    }
}
```

> ApplicationService是业务流程的封装，不处理业务逻辑。



**判断一段代码是否是业务流程的几个点：**

- 不要有if/else分支逻辑
- 不要有计算逻辑
- 一些数据转化可以交给其他对象来做DTO Assembler（建议使用MapStruct类库实现）



**常用的ApplicationService套路：**

- 数据准备：包括从外部服务或持久化源取出相应的Entity、VO以及外部服务返回的DTO
- 执行操作：包括新对象的创建、赋值，以及调用领域对象的方法对其进行操作，通常是纯内存操作，非持久化。
- 持久化



### 防腐层

微服务场景下，Application经常会引用外部服务，外部服务可能提供的是http接口、RPC接口、FeignApi等。



无防腐层的情况：

![image-20210627135335100](https://wcy-img.oss-cn-beijing.aliyuncs.com/images/md/no-ACL.png)

有防腐层的情况：

![image-20210627135439283](https://wcy-img.oss-cn-beijing.aliyuncs.com/images/md/ACL.png)

ACL的加入，通过转换为内部对象，通过FacadeInterface接口类，屏蔽了外部服务的类、方法和外部对象。如果未来外部服务有变化，只需要修改Facade实现类和数据转化逻辑，而不需要修改ApplicationService逻辑。

加入防腐层的优点在于，将外部服务进行了解耦，屏蔽了外部服务的变化。但这也收有代价的，它使得对象转换，外部服务封装代码增多，增加了代码量，和维护成本。但从长远角度来看，这样的代价其收益远高于弊端。

## 2.3. Domain层

封装核心业务逻辑，并通过领域服务（Domain Service）和（Domain Entity）的方法对Application层提供业务实体和业务逻辑计算。领域层是应用的核心，只关注业务，不关注技术实现细节，所以它不依赖任何其它层次。

## 2.4. Infrastructure层

主要负责技术细节处理，比如数据库CRUD、缓存、消息服务、搜索引擎、RPC等。

## 2.5. 异常处理

Interface层处理所有异常，返回统一的`Response`对象，捕获所有异常。

Application层不负责处理异常，可以随意抛出异常，返回DTO。
