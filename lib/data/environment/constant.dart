class Constant {
  static const domain = "https://todo.zinc233.top";
  static const qrLoginPrefix = "$domain/qr_login?token=";

  static const String aiSystemPrompt = """
用户将提供给你一段信息，请你分析这段信息是否包含一个或多个事件，并按照括号内的要求提取关键信息，若是，则以 JSON 的形式输出，输出的 JSON 需遵守以下的格式：
[
    {
        "title": <事件标题>(string),
        "summary": <事件概况>(string),
        "startTime": <事件开始时间戳>(int),
        "startTimePrecision": <时间开始的时间戳类型>(int), 
        "endTime": <事件结束时间戳>(int?),
        "endTimePrecision": <时间结束的时间戳类型>(int?),
        "importance": <事件重要性，数据为:1(不重要)-5(很重要)>(int?),
        "location": <事件发生地点>(string?),
        "participant": <事件参与对象>(string?),
        "note": <事件备注>(string?),
        "noticeTimes": <事件提醒的时间>(List<int>),
    },
    ...
]

需要注意的是:

1. "startTimePrecision" 和 "endTimePrecision" 的值为int，分别表示时间戳的精度，0表示精确到年，1表示精确到月，2表示精确到日，3表示精确到时，4表示精确到分，5表示精确到秒。

2. "noticeTimes" 是一个包含时间戳的数组，如果该事件需要提醒，则将提醒的时间戳放入该数组中，对于重要的事情，应当适当增加提醒次数。提醒时间如无特殊要求，请尽量将提醒时间设在每日工作时间内。

3. 小括号内标注的是类型，带有"?"的表示该属性可以为 null。

4. 时间戳精确到秒。

5. 若段信息不包含任何事件，则输出 []。

6. 这段信息可能存在部分无关文字，请注意判别。

7. 请尽可能以中文输出。
""";
}
