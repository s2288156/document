<!-- TOC -->

- [1. 微服务AlibabaCloud实践](#1-微服务alibabacloud实践)
    - [1.1. 技术栈更新](#11-技术栈更新)
    - [1.2. 注册中心](#12-注册中心)
        - [1.2.2. 一致性(Consistency)](#122-一致性consistency)
        - [1.2.3. 可用性（Availability）](#123-可用性availability)
        - [1.2.1. Nacos Register](#121-nacos-register)
    - [1.3. 网关（SpringCloud Gateway）](#13-网关springcloud-gateway)
        - [1.3.1. Route Predicate Factories](#131-route-predicate-factories)
            - [1.3.1.1. Path Route Predicate Factory](#1311-path-route-predicate-factory)
            - [1.3.1.2. Host Route Predicate Facotry](#1312-host-route-predicate-facotry)
            - [1.3.1.3. Header Route Predicate Facotry](#1313-header-route-predicate-facotry)
    - [1.4. sentinel](#14-sentinel)
        - [1.4.1. gateway集成sentinel](#141-gateway集成sentinel)

<!-- /TOC -->
# 1. 微服务AlibabaCloud实践

## 1.1. 技术栈更新

![](https://wcy-img.oss-cn-beijing.aliyuncs.com/images/micro/zyzh-fwsj1.0.png)

## 1.2. 注册中心

CAP原则，一致性(Consistency)、可用性（Availability）、分区容错性（Partition tolerance）。

### 1.2.2. 一致性(Consistency)

保证一致性，就需要时间同步副本文件，同步过程中不能保证可用性

### 1.2.3. 可用性（Availability）

数据出现不一致，仍然保证可用性，允许数据不同步，这时一致性就不能保证

### 1.2.1. Nacos Register

- 服务列表
- 订阅者列表
- 服务上线下线

## 1.3. 网关（SpringCloud Gateway）

### 1.3.1. Route Predicate Factories

#### 1.3.1.1. Path Route Predicate Factory

```yml
spring:
  cloud:
    gateway:
      routes:
      - id: path_route
        uri: https://example.org
        predicates:
        - Path=/red/{segment},/order/**
```

- `/red/{segment}`会匹配`/red/1`或`/red/xxx`这样的路径
- `/order/**`会匹配所有以`/order/`为前缀的请求

#### 1.3.1.2. Host Route Predicate Facotry

匹配配置的request host规则

```yml
spring:
  cloud:
    gateway:
      routes:
      - id: host_route
        uri: https://example.org
        predicates:
        - Host=**.somehost.org,**.anotherhost.org
```

#### 1.3.1.3. Header Route Predicate Facotry

request header匹配到指定的字符串或正则表达式，则执行此路由配置

```yml
spring:
  cloud:
    gateway:
      routes:
      - id: header_route
        uri: https://example.org
        predicates:
        - Header=X-Request-Id, \d+
```

## 1.4. sentinel

### 1.4.1. gateway集成sentinel

- 获取client端rules信息：`http://192.168.31.21:18000/gateway/getRules`

```json
// sentinel集成配置，特别注意gateway集成sentinel，rule-type必须为gw-flow，非gateway项目集成rule-type为flow
spring: 
  cloud:
    sentinel:
      eager: true
      transport:
        dashboard: 192.168.30.204:8100
        port: 18000
      datasource:
        gateway-ds:
          nacos:
            serverAddr: 192.168.30.206:8848
            namespace: test-1
            dataId: gateway-flow-rules
            groupId: SENTINEL_GROUP
            rule-type: gw-flow


// resource：资源名称；
// count：单机阈值；
// strategy：流控模式，0表示直接，1表示关联，2表示链路；
// clusterMode：是否集群。
// controlBehavior：流控效果，0表示快速失败，1表示Warm Up，2表示排队等待
// grade：阈值类型，0表示线程数，1表示QPS
// 这里为限流规则，持久化到nacos中，resource为routeId或Api分组，暂时未找到持久化方法，需要个性化开发
// 如果Api分组不能持久化，限流规则会在gw重启后失效，要想使限流规则在gw重启后立即生效，需要保证gw重启时能先初始化api分组信息
[
    {
    "burst": 0,
    "controlBehavior": 0,
    "count": 3.0,
    "grade": 1,
    "intervalSec": 1,
    "maxQueueingTimeoutMs": 500,
    "resource": "/upp/merchant/**",
    "resourceMode": 1
    }
]
```