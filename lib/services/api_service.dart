
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/data_kampus.dart';


class ApiService {
  static const String baseUrl = 'http://192.168.43.245:8000/api/kampus';

  static Future<List<DataKampus>> fetchAll() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => DataKampus.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data');
    }
  }

  static Future<DataKampus> fetchById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return DataKampus.fromJson(json.decode(response.body));
    } else {
      throw Exception('Data tidak ditemukan');
    }
  }

  static Future<void> create(DataKampus kampus) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(kampus.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Gagal menambahkan data');
    }
  }

  static Future<void> update(int id, DataKampus kampus) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(kampus.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal mengupdate data');
    }
  }

  static Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus data');
    }
  }
}
