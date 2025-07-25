import 'package:edunjema3/services/openai_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// NEW: Provider for OpenAIService
final openAIServiceProvider = Provider<OpenAIService>((ref) => OpenAIService());
