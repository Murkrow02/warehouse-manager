import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse_manager/core/configuration/preferences.dart';
import 'package:warehouse_manager/core/exceptions/api_validation_exception.dart';
import '../../../../core/configuration/configs.dart';
import '../../../../core/exceptions/rest_exception.dart';
import '../../../utils/toaster.dart';
import '../../models/serializable.dart';

class RestClient {

  // Logger
  final logger = Logger(
    printer: PrettyPrinter(),
  );

  String baseUrl = Configs.apiUrl;
  static const int timeoutSec = 5;

  // Get headers and take the token from the shared preferences
  Future<Map<String, String>> getHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authToken = prefs.getString(Preferences.AUTH_TOKEN) ?? '';
    return {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    return {};
  }

  // Function to perform a GET request
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    logger.d("GET: $endpoint");

    // Create the uri with the query parameters
    var uri = Uri.parse('$baseUrl/$endpoint');
    uri.replace(queryParameters: queryParameters);
    final response = await http
        .get(
      uri,
      headers: await getHeaders(),
    )
        .timeout(const Duration(seconds: timeoutSec));
    return handleResponse(response);
  }

  Future<dynamic> put(String endpoint, dynamic data) async {
    logger.d("PUT: $endpoint");
    final response = await http
        .put(
      Uri.parse('$baseUrl/$endpoint'),
      body: jsonEncode(data is Serializable ? data.toJson() : data),
      headers: await getHeaders(),
    )
        .timeout(const Duration(seconds: timeoutSec));
    return handleResponse(response);
  }

  // Function to perform a POST request
  Future<dynamic> post(String endpoint, dynamic data) async {
    logger.d("POST: $endpoint");
    final response = await http
        .post(
      Uri.parse('$baseUrl/$endpoint'),
      body: jsonEncode(data is Serializable ? data.toJson() : data),
      headers: await getHeaders(),
    )
        .timeout(const Duration(seconds: timeoutSec));
    return handleResponse(response);
  }

  // Function to perform a DELETE request
  Future<dynamic> delete(String endpoint) async {
    logger.d("DELETE: $endpoint");
    final response = await http
        .delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: await getHeaders(),
    )
        .timeout(const Duration(seconds: timeoutSec));
    return handleResponse(response);
  }

  Future<dynamic> handleResponse(http.Response response) async {
    // Internal server error
    if (response.statusCode == 500) {
      logger.e("Request: ${response.request?.url} failed. \n ${response.body}");
      throw RestException(
          "Internal server error, please try again later", response.statusCode);
    }

    // Decode the response
    var data = json.decode(response.body);
    String? message = data['message'];

    // Validation error
    if (response.statusCode == 422) {
      var errors = Map<String, List<dynamic>>.from(data['errors']);
      throw ApiValidationException(errors);
    }

    // Some type of error
    if (response.statusCode != 200 && response.statusCode != 201) {
      if (message != null && message.isNotEmpty) {
        Toaster.error(message);
      }
      throw RestException(message ?? "An error occurred", response.statusCode);
    }

    // Response success
    if (message != null && message.isNotEmpty) Toaster.success(message);

    // Check if response is well formatted
    if (data['data'] == null) {
      throw RestException("Response is not well formatted", response.statusCode);
    }

    // Return the data
    Logger().d("Response: $data");
    return data['data'];
  }
}
