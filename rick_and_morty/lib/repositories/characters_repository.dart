import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty/constants/network_constants.dart';
import 'package:rick_and_morty/models/characters_network_response.dart';

class CharactersRepository {
  final Dio _dio = Dio();

  CharactersRepository() {
    // Configure Dio
    _dio.interceptors.add(LogInterceptor(
      logPrint: (o) => debugPrint(o.toString()),
      requestBody: true,
      responseBody: true,
    ));
  }

  Future<CharactersNetworkResponse> getCharacters(int page) async {
    try {
      final response = await _dio.get(NetworkConstants.CHARACTERS_PATH,
          queryParameters: {"page": page});

      return CharactersNetworkResponse.fromMap(response.data);
    } catch (e) {
      throw Error();
    }
  }

  Future<CharacterNetworkResponse> getCharacter(int id) async {
    try {
      final response =
          await _dio.get("${NetworkConstants.CHARACTERS_PATH}/$id");

      return CharacterNetworkResponse.fromMap(response.data);
    } catch (e) {
      throw Error();
    }
  }
}
