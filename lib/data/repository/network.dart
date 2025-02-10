import 'package:openai_dart/openai_dart.dart';
import 'package:time_manager_client/data/environment/env.dart';
import 'package:time_manager_client/data/types/task.dart';

class Network {
  static const String aiApiKey = Env.dsApiKey;
  static const String aiBasicUrl = "https://api.deepseek.com";

  static final aiClient = OpenAIClient(apiKey: aiApiKey, baseUrl: aiBasicUrl);

  static Future<List<Task>> getTaskFromText(String text) async {
    print("SEND TEXT TO AI");
    final cccr = await aiClient.createChatCompletion(
      request: CreateChatCompletionRequest(
        model: ChatCompletionModel.modelId("deepseek-chat"),
        messages: [
          ChatCompletionMessage.system(content: aiSystemPrompt),
          ChatCompletionMessage.user(content: ChatCompletionUserMessageContent.string(text)),
        ],
        stream: false,
        temperature: 0.7,
        maxTokens: 1024,
      ),
    );

    final r = cccr.choices.first.message.content;
    print(r);
    if (r == null) return [];

    final tl = Task.fromJsonString(r);
    for (final element in tl) {
      element.content = text;
    }
    // print(tl);

    return tl;
  }

  static const String aiSystemPrompt = """
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
""";
}
