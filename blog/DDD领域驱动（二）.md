往期文章：

> [DDD领域驱动 - 设计聚合](https://juejin.im/post/6893875509726773255)

# 3. CQRS

> CQRS --- Command Query Responsibility Segregation，command与query职责分离



这个概念是MartinFowler在2011年的一篇文章行提到的，emmmm....，当年我只知道是诺基亚手机游戏有Java图标。

<img src="https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fp1.itc.cn%2Fq_70%2Fimages03%2F20210204%2F3224b884877e4aaf9a858aa38feb482f.jpeg&refer=http%3A%2F%2Fp1.itc.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1627192720&t=5f7fa8d2036470887dce6f07cc237dc8" alt="img" style="zoom:50%;" />

传统架构：

![img](https://martinfowler.com/bliki/images/cqrs/single-model.png)

CQRS架构：

![img](https://martinfowler.com/bliki/images/cqrs/cqrs.png)
