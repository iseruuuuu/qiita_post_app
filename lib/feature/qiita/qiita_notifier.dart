import 'package:qiita_app/data/api/qiita_api.dart';
import 'package:qiita_app/domain/model/article.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'qiita_notifier.g.dart';

@riverpod
class QiitaNotifier extends _$QiitaNotifier {
  @override
  List<Article> build() => [];

  int currentPage = 1;

  Future<void> fetchArticles() async {
    List<Article> articles = await QiitaApi.fetchArticle(page: currentPage);
    state = [...state, ...articles];
    currentPage++;
  }
}
