class Quotes {
  final int ID;
  final String title;
  final String content;

  Quotes({this.ID, this.title, this.content});

  factory Quotes.fromJson(Map<String, dynamic> json) {
    return Quotes(
      ID: json['ID'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }
}