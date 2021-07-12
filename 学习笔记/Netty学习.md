[toc]



# 1. 三种模式



|          BIO          |   NIO   |   AIO    |
| :-------------------: | :-----: | :------: |
| Thread-Per-Connection | Reactor | Proactor |



- BIO（废弃）: 
- AIO（废弃）:
- NIO: 
  - Common
  - Linux
  - Mac 

## 1.1 Reactor三种模式



- 单线程模式 
- 多线程模式
- 主从多线程模式



```java
// Reactor单线程模式
EventLoopGroup eventGroup = new NioEventLoopGroup(1);

ServerBootstrap serverBootstrap = new ServerBootstrap();
serverBootstrap.group(eventGroup);

// 非主从Reactor多线程模式
EventLoopGroup eventGroup = new NioEventLoopGroup();

ServerBootstrap serverBootstrap = new ServerBootstrap();
serverBootstrap.group(eventGroup);

// 主从Reactor多线程模式
EventLoopGroup boosGroup = new NioEventLoopGroup();
EventLoopGroup workerGroup = new NioEventLoopGroup();

ServerBootstrap serverBootstrap = new ServerBootstrap();
serverBootstrap.group(boosGroup, workerGroup);
```

