import 'package:qiita_app/domain/model/user.dart';

class Article {
  final String title;
  final String url;
  final String createdTime;
  final User user;

  Article({
    required this.title,
    required this.url,
    required this.createdTime,
    required this.user,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      url: json['url'],
      createdTime: json['created_at'].toString(),
      user: User.fromJson(json['user']),
    );
  }
}
