import 'package:flutter/material.dart';
import 'package:flutter_quotes_apps/model/quotes.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Quotes Apps",
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}

class QuotesPage extends StatefulWidget {
  @override
  _QuotesPageState createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {

  static const urlApi = "http://quotesondesign.com/wp-json/posts?filter[orderby]=rand&filter[posts_per_page]=10";

  List<Quotes> parseQuotes(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Quotes>((json) => Quotes.fromJson(json)).toList();
  }

  Future<List<Quotes>> fetchQuotes(http.Client client) async {
    final response = await client.get(urlApi);
    return compute(parseQuotes, response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}