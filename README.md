# time_manager_client

A new Flutter project.

## Getting Started

## 功能

- 待办列表
- 四象限
- ⭐添加任务
- 日历
- 设置


## 数据结构

清单 > 任务

group > task

```
group
|- name: <string>
|- icon: <string> (emoji)
|- color: <flutter.primaryColor> (random)
|- tasks: [<task>]
```


```
task
|- title: <string>
|- summary: <string?>
|- start_time: <datetime(int)?>
|- start_time_precision: <enum(int)?>
|- end_time: <datetime(int)?>
|- end_time_precision: <enum(int)?>
|- importance: <int?> 1-5
|- location: <string?>
|- participant: <string?>
|- note: <string?>
|- source: <string?> (原文地址，用户输入为空)
|- content: <string?>
|- status: <enum(int)> 1(未完成) 2(已完成)
```

time_precision:
| 状态 | 表示 |
| --- | --- |
| 0 | 年 |
| 1 | 月 |
| 2 | 日 |
| 3 | 时 |
| 4 | 分 |
| 5 | 秒 |


## 提示词
	
> 用户将提供给你一段新闻内容，请你分析新闻内容，并提取其中的关键信息，以 JSON 的形式输出，输出的 JSON 需遵守以下的格式：
> 
> {
>   "entiry": <新闻实体>,
>   "time": <新闻时间，格式为 YYYY-mm-dd HH:MM:SS，没有请填 null>,
>   "summary": <新闻内容总结>
> }

```
用户将提供给你一段信息，请你分析这段信息是否包含一个或多个事件，并按照括号内的要求提取关键信息，若是，则以 JSON 的形式输出，输出的 JSON 需遵守以下的格式：

[
    {
        "title": <事件标题>(string),
        "summary": <事件概况>(string),
        "start_time": <事件开始时间戳>(int),
        "start_time_precision": <时间开始的时间戳类型>(int), 
        "end_time": <事件结束时间戳>(int?),
        "end_time_precision": <时间结束的时间戳类型>(int?),
        "importance": <事件重要性，数据为:1(不重要)-5(很重要)>(int?),
        "location": <事件发生地点>(string?),
        "participant": <事件参与对象>(string?),
        "note": <事件备注>(string?),
    },
    ...
]

需要注意的是，"start_time_precision" 和 "end_time_precision" 的值为int，分别表示时间戳的精度，0表示精确到年，1表示精确到月，2表示精确到日，3表示精确到时，4表示精确到分，5表示精确到秒。

此外，小括号内标注的是类型，带有"?"的表示该属性可以为 null


若段信息不包含任何事件，则输出 []。
``` 

## ProtoBuf 编译

``` sh
protoc --proto_path=. --dart_out=lib/data/proto.gen lib/data/proto/task.proto lib/data/proto/group.proto lib/data/proto/tw.proto
```

## QR登陆信息
编码: `http://todo.zinc233.top/qrlogin?token=<token>`

## 数据库定时调度

``` sql
-- 安装 pg_cron 扩展（如果尚未安装）
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- 创建定时任务，每20分钟执行一次删除操作
SELECT cron.schedule('*/20 * * * *', $$DELETE FROM qr_login_request WHERE created_at < NOW() - INTERVAL '40 minutes'$$);
```