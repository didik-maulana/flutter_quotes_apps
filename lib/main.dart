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
    home: QuotesPage(),
  ));
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
    
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    Widget _buildRefetchButton = InkWell(
      onTap: () {},
      child: Container(
        width: width,
        margin: EdgeInsets.symmetric(
          horizontal: width/10,
        ),
        padding: EdgeInsets.symmetric(
          vertical: height/50,
        ), 
        child: Center(
          child: Text(
            'REFETCH QUOTES',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2.0,
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
    
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          bottom: height/20,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [const Color(0xff368882), const Color(0xff31597d)],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 50.0),
                    width: 50.0,
                    height: height/5,
                    color: Colors.blue,
                  );
                },
              ),
            ),
            _buildRefetchButton,
          ],
        ),
      ),
    );
  }
}