class Constant {
  static const domain = "https://todo.zinc233.top";
  static const qrLoginPrefix = "$domain/qr_login?token=";

  static const String mindmapWebCode = """
<style>
	.markmap {
		position: relative;
	}
	.markmap > svg {
		width: 100%;
		height: 100%;
	}

  body {
    background-color: Canvas;
    color: var(--text-color);
    color-scheme: light dark;
  }
</style>

<div class="markmap">
	<script type="text/template">
###MINDMAP###
	</script>
</div>

<script src="https://cdn.jsdelivr.net/npm/markmap-autoloader@latest"></script>
""";

  static const String aiSystemPromptForAddTask = """
用户将提供给你一段信息，请你分析这段信息是否包含一个或多个事件，并按照括号内的要求提取关键信息，若是，则以 JSON 的形式输出，输出的 JSON 需遵守以下的格式：
[
    {
        "title": <事件标题>(string),
        "summary": <事件概况>(string),
        "startTime": <事件开始时间>(string),
        "startTimePrecision": <时间开始的时间类型>(int), 
        "endTime": <事件结束时间>(string?),
        "endTimePrecision": <时间结束的时间类型>(int?),
        "importance": <事件重要性，数据为:1(不重要)-5(很重要)>(int?),
        "location": <事件发生地点>(string?),
        "participant": <事件参与对象>(string?),
        "note": <事件备注>(string?),
        "noticeTimes": <事件提醒的时间>(List<string>),
        "tags": <事件标签>(List<string>),
    },
    ...
]

需要注意的是:

1. "startTime"、"endTime"、"noticeTimes" 中涉及到时间的文本，格式应为ISO8601的格式，即"YYYY-MM-DDThh:mm:ss"
2. "startTimePrecision" 和 "endTimePrecision" 的值为int，分别表示时间戳的精度，0表示精确到年，1表示精确到月，2表示精确到日，3表示精确到时，4表示精确到分，5表示精确到秒。
3. "noticeTimes" 是一个包含时间的数组，如果该事件需要提醒，则将提醒的时间戳放入该数组中，对于重要的事情，应当适当增加提醒次数。提醒时间如无特殊要求，请尽量将提醒时间设在每日工作时间内。
4. "tags" 是一个包含字符串的数组，用于给事件打标签，如 '工作'、 '个人'、 '学习'、 '健康'、 '财务'、 '社交'、 '旅行'、 '家庭'、 '创意'。
5. 小括号内标注的是类型，带有"?"的表示该属性可以为 null。
6. 若段信息不包含任何事件，则输出 []。
7. 这段信息可能存在部分无关文字，请注意判别。
8. 请尽可能以中文输出。
""";

  static const String aiSystemPromptForAnalyzeTasks = """
你是一个AI小助理，用户将以文本的形式告诉你他需要完成的任务，请基于这些任务，给用户一些小建议，如需优先完成什么任务，并总结成一段约140字的纯文本概述。

注意：
1. 请不要输出除给出的建议以外任何内容；
2. “[]”中括号中为任务编号，用于区分不同任务；
3. 如建议中需提到某一任务，请以 “{任务名称的概括}+[[任务编号]]” 的形式在文本中输出，需要注意的是，
    {任务名称的概括} 被一层花括号所包裹，“任务名称的概括”如果较长可以适当缩短 ;
    [[任务编号]] 被两层中括号所包裹，与 “任务编号” 相同，但无需加引号；
3. 输出内容为纯文本，不要Markdown格式；
4. 字数不得超过160字。
""";

  static const String aiSystemPromptForMindmap = """
你作为一个为用户安排事项的小秘书，用户将提供给你一段文本，请判断该文本是否可以转换成为一个思维导图，便于用户去浏览和执行任务。

如果可以，你需要输出一段使用缩进表示层级关系的文本，每层节点以 "- " 开头，不要带有任何其他信息，例如
```
- 节点1
  - 节点1.1
  - 节点1.2
- 节点2
  - 节点2.1
    - 节点2.1.1
    - 节点2.1.2
```

如果不可以，请直接输出 "无法转换"。
""";

  @Deprecated("不使用Prompt")
  static const String aiSystemPromptForAutoTask = """
用户将提供给你一段事情，请分析这件事情是否可以自动完成。
如果可以，请适当将用户的需求描述清楚，便于后续Agent的对接；
如果不行，则输出 "无法自动完成"。
请注意：
1. 该事情必须可以自动在电脑上完成，且无需用户参与；
""";

  static const String aiSystemPromptForAutoTaskCaveat = """
注意:
1. 请优先使用必应、百度等搜索引擎，尽可能不要使用谷歌；
2. 生成的文件请优先放在桌面上。
""";
}
