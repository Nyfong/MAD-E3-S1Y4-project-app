import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rupp_final_mad/data/api/api_config.dart';
import 'package:rupp_final_mad/data/services/token_storage_service.dart';

class ApiClient {
  final String baseUrl;
  final Map<String, String> defaultHeaders;
  final TokenStorageService _tokenStorage = TokenStorageService();

  ApiClient({
    String? baseUrl,
    Map<String, String>? headers,
  })  : baseUrl = baseUrl ?? ApiConfig.baseUrl,
        defaultHeaders = headers ??
            {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            };

  Future<Map<String, String>> _getHeaders(
      Map<String, String>? additionalHeaders) async {
    final headers = <String, String>{...defaultHeaders};

    // Add authorization header if token exists
    final authHeader = await _tokenStorage.getAuthorizationHeader();
    if (authHeader != null) {
      headers['Authorization'] = authHeader;
    }

    // Add any additional headers
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    // If baseUrl is empty, throw to trigger fallback
    if (baseUrl.isEmpty) {
      throw Exception('API is disabled - using fallback data');
    }

    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final requestHeaders = await _getHeaders(headers);
      debugPrint('API GET Request: $url');
      debugPrint('Request headers: $requestHeaders');

      final response = await http.get(
        url,
        headers: requestHeaders,
      );

      debugPrint('API Response status: ${response.statusCode}');
      return _handleResponse(response);
    } catch (e, stackTrace) {
      debugPrint('API GET error: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('GET request failed: $e');
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    // If baseUrl is empty, throw to trigger fallback
    if (baseUrl.isEmpty) {
      throw Exception('API is disabled - using fallback data');
    }

    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final requestHeaders = await _getHeaders(headers);
      debugPrint('API POST Request: $url');
      debugPrint('Request headers: $requestHeaders');
      debugPrint('Request body: ${data != null ? jsonEncode(data) : null}');

      final response = await http.post(
        url,
        headers: requestHeaders,
        body: data != null ? jsonEncode(data) : null,
      );

      debugPrint('API Response status: ${response.statusCode}');
      debugPrint('API Response body: ${response.body}');

      return _handleResponse(response);
    } catch (e, stackTrace) {
      debugPrint('API POST error: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('POST request failed: $e');
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final requestHeaders = await _getHeaders(headers);
      final response = await http.put(
        url,
        headers: requestHeaders,
        body: data != null ? jsonEncode(data) : null,
      );

      return _handleResponse(response);
    } catch (e, stackTrace) {
      debugPrint('API PUT error: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('PUT request failed: $e');
    }
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final requestHeaders = await _getHeaders(headers);
      final response = await http.delete(
        url,
        headers: requestHeaders,
      );

      return _handleResponse(response);
    } catch (e, stackTrace) {
      debugPrint('API DELETE error: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('DELETE request failed: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    debugPrint('Handling response with status: ${response.statusCode}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        debugPrint('Response body is empty');
        return {};
      }
      try {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        debugPrint('Response decoded successfully');
        return decoded;
      } catch (e) {
        debugPrint('JSON decode error: $e');
        throw Exception('Failed to decode response: $e');
      }
    } else {
      debugPrint('Request failed with status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      throw Exception(
        'Request failed with status: ${response.statusCode}. ${response.body}',
      );
    }
  }
}
