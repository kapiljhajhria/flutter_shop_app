import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userid;
  final String apiKey = "";

  bool get isAuth {
    return token != null;
  }

  String? get userId => _userid;

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=$apiKey');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      // ignore: prefer_interpolation_to_compose_strings

      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData['error'] != null) {
        debugPrint(
            "error message: ${json.decode(response.body)['error']['message']}");
      }
      //set auth details
      _token = responseData['idToken'] as String;
      _userid = responseData['localId'] as String;
      _expiryDate = DateTime.now().add(
          Duration(seconds: int.parse(responseData['expiresIn'] as String)));
      notifyListeners();
      debugPrint(responseData.toString());
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message'] as String);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signupNewUser');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'verifyPassword');
  }

  void logout() {
    _token = null;
    _userid = null;
    _expiryDate = null;
    notifyListeners();
  }
}
