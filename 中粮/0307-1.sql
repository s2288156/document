ALTER TABLE `zl_report_sys`.`construction_project_item` MODIFY COLUMN `civil_call_price` varchar(15) NULL COMMENT '土建结算价（万元）' AFTER `zero_layer_board`;

ALTER TABLE `zl_report_sys`.`construction_project_item` MODIFY COLUMN `civil_unit_price` varchar(15) NULL COMMENT '土建单位价格（元/单位）' AFTER `civil_call_price`;

ALTER TABLE `zl_report_sys`.`construction_project_item` MODIFY COLUMN `refined_decoration_unit_price` varchar(15) NULL COMMENT '精装修单位价格（元/平方米）' AFTER `civil_unit_price`;