ALTER TABLE `zl_report_sys`.`construction_project` ADD COLUMN `status` integer(3) NULL DEFAULT 1 COMMENT '状态：0 - 未完成创建；1 - 已完成创建' AFTER `province_code`;

CREATE TABLE `zl_report_sys`.`weight_coefficient`  (
  `id` VARCHAR(32) NOT NULL,
  `create_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `pid` VARCHAR(32) NULL COMMENT '项目id',
  `item` INTEGER(10) NULL COMMENT '因素，0 - 人工费；1 - 钢材；2 - 水泥；3 - 砂石；4 - 砖；5 - 其它',
  `unit` VARCHAR(20) NULL COMMENT '单位',
  `price_x` VARCHAR(15) NULL COMMENT '价格A',
  `weighting_x` VARCHAR(10) NULL COMMENT '影响概率（%）A',
  `price_y` VARCHAR(15) NULL COMMENT '价格B',
  `weighting_y` VARCHAR(10) NULL COMMENT '影响概率（%）B',
  PRIMARY KEY (`id`)
);