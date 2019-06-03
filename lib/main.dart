import 'package:flutter/material.dart';
import 'package:flutter_quotes_apps/model/quotes.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Quotes Apps",
    home: QuotesPage(),
  ));
}

List<Quotes> parseQuotes(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Quotes>((json) => Quotes.fromJson(json)).toList();
}

Future<List<Quotes>> fetchQuotes(http.Client client) async {
  final urlApi = "http://quotesondesign.com/wp-json/posts?filter[orderby]=rand&filter[posts_per_page]=10";
  final response = await client.get(urlApi);
  return compute(parseQuotes, response.body);
}

class QuotesPage extends StatefulWidget {
  @override
  _QuotesPageState createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {

  @override
  Widget build(BuildContext context) {
    
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: height/12,
          bottom: height/5.5,
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
            Center(
              child: Text(
                'Quotes Apps',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 20.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: height/12,
              ),
            ),
            FutureBuilder<List<Quotes>>(
              future: fetchQuotes(http.Client()),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);

                if (snapshot.hasData) {
                  return _buildQuotesSection(
                    width,
                    height,
                    snapshot.data
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuotesSection(
    final double width, 
    final double height,
    final List<Quotes> quotes
  ) {

    String _htmlParsed(String text) {
      var document = parse(text);
      String parsedString = parse(document.body.text).documentElement.text;
      return parsedString;
    }

    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(
              right: width/20,
              left: width/20,
            ),
            padding: EdgeInsets.all(16.0),
            width: width/1.1,
            height: height/5,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Text(
                    _htmlParsed(quotes[index].content),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    quotes[index].title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}