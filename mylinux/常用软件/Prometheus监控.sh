#!/usr/bin/env bash
promethus 下一代监控系统
优点：基于GO编写性能好（其实其他监控系统性能并不差，这点太牵强了）
     时序数据库 这个才是重点（解决了监控的老大难的问题,查询速度得到大幅优化）
     监控数据基于http传输方便查看（安全限制,自行解决）
     数据采集机制不错（适合跨机房监控）
     报警组件分离
     基于容器的监控还不错
缺点：上手不容易,文档参差不齐
     监控不够灵活,自己编写exprot 比较为难（相比zabbix就简单的多了）
     bug比较多,遇到问题不好解决

官网: https://prometheus.io/
基础概念

公司用的整体体验还算OK