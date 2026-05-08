import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/cep_model.dart';

class ViaCepService {
  ViaCepService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<CepModel> fetchCep(String cep) async {
    final Uri url = Uri.parse('https://viacep.com.br/ws/$cep/json/');

    http.Response response;
    try {
      response = await _client.get(url);
    } catch (_) {
      throw Exception('Falha de conexao. Verifique sua internet.');
    }

    if (response.statusCode != 200) {
      throw Exception('Falha ao consultar o CEP.');
    }

    final Object? decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Resposta invalida da API.');
    }

    // ViaCEP uses the "erro" flag when the CEP is not found.
    if (decoded['erro'] == true) {
      throw Exception('CEP nao encontrado.');
    }

    return CepModel.fromJson(decoded);
  }
}
