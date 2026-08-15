import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/ask_ai_models.dart';
import '../models/conversation_model.dart';

class AiRemoteDatasource {
  const AiRemoteDatasource(this._apiClient);

  final ApiClient _apiClient;

  Future<AskAiResponse> askAi({
    required String message,
    String? conversationId,
  }) async {
    try {
      final payload = AskAiRequest(
        message: message,
        conversationId: conversationId,
      );
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.aiAsk,
        data: payload.toJson(),
      );
      final responseJson = response.data ?? <String, dynamic>{};
      return AskAiResponse.fromJson(responseJson);
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  Future<List<ConversationModel>> listConversations() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiConstants.aiConversations,
      );
      final responseJson = response.data ?? <String, dynamic>{};
      final dataList = responseJson['data'] as List<dynamic>? ?? const <dynamic>[];
      return dataList
          .map((item) => ConversationModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  Future<ConversationModel> getConversation(String conversationId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '${ApiConstants.aiConversationDetail}/$conversationId',
      );
      final responseJson = response.data ?? <String, dynamic>{};
      final data = responseJson['data'] as Map<String, dynamic>;
      return ConversationModel.fromJson(data);
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  Future<void> deleteConversation(String conversationId) async {
    try {
      await _apiClient.delete<Map<String, dynamic>>(
        '${ApiConstants.aiConversationDetail}/$conversationId',
      );
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  Future<ConversationModel> updateConversation({
    required String conversationId,
    String? title,
    String? status,
  }) async {
    try {
      final payload = <String, dynamic>{};
      if (title != null) payload['title'] = title;
      if (status != null) payload['status'] = status;

      final response = await _apiClient.patch<Map<String, dynamic>>(
        '${ApiConstants.aiConversationDetail}/$conversationId',
        data: payload,
      );
      final responseJson = response.data ?? <String, dynamic>{};
      final data = responseJson['data'] as Map<String, dynamic>;
      return ConversationModel.fromJson(data);
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }
}
