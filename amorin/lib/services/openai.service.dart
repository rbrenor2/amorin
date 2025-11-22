import 'package:amorin/prompts/amorin1.prompt.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAiService {
  final model = 'gpt-4';
  final String systemPrompt = amorin1Prompt;

  OpenAiService() {
    OpenAI.apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
  }

  Future<String> sendMessage(String text) async {
    try {
      final completion = await OpenAI.instance.chat.create(
        model: model,
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.system,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                systemPrompt,
              ),
            ],
          ),
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(text),
            ],
          ),
        ],
      );

      return completion.choices.first.message.content?.first.text ?? '';
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }
}
