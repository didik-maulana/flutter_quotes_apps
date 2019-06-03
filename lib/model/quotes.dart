class Quotes {
  final int id;
  final String title;
  final String content;

  Quotes({this.id, this.title, this.content});

  factory Quotes.fromJson(Map<String, dynamic> json) {
    return Quotes(
      id: json['ID'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }
}