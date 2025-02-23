import 'package:openai_dart/openai_dart.dart';
import 'package:time_manager_client/data/environment/constant.dart';
import 'package:time_manager_client/data/environment/env.dart';
import 'package:time_manager_client/data/repository/logger.dart';
import 'package:time_manager_client/data/types/task.dart';

class Network {
  static const String aiApiKey = Env.dsApiKey;
  static const String aiBasicUrl = "https://api.deepseek.com";

  static final aiClient = OpenAIClient(apiKey: aiApiKey, baseUrl: aiBasicUrl);

  static Future<List<Task>> getTaskFromText(
    String text, {
    String systemPrompt = Constant.aiSystemPrompt,
    String modelId = "deepseek-chat",
  }) async {
    logger.t("SEND TEXT TO AI");
    final cccr = await aiClient.createChatCompletion(
      request: CreateChatCompletionRequest(
        model: ChatCompletionModel.modelId(modelId),
        messages: [
          ChatCompletionMessage.system(content: systemPrompt),
          ChatCompletionMessage.user(content: ChatCompletionUserMessageContent.string(text)),
        ],
        stream: false,
        temperature: 0.7,
        // maxTokens: 1024,
      ),
    );

    var r = cccr.choices.first.message.content;
    logger.t(r);
    if (r == null) return [];

    r = r.replaceAll("```json", "").replaceAll("```", "").trim();

    final tl = Task.fromJsonString(r);
    for (final element in tl) {
      element.content = text;
    }
    logger.t(tl);

    return tl;
  }
}

enum AiModel {
  deepseekChat("标准", "deepseek-chat"),
  deepseekReason("推理", "deepseek-reasoner"),
  ;

  final String name;
  final String id;

  const AiModel(this.name, this.id);

  @override
  String toString() => name;
}
