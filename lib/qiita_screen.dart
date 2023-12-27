import 'package:flutter/material.dart';
import 'package:qiita_app/api/qiita_client.dart';
import 'package:qiita_app/model/article.dart';
import 'package:url_launcher/url_launcher.dart';

class QiitaScreen extends StatefulWidget {
  const QiitaScreen({super.key});

  @override
  State<QiitaScreen> createState() => _QiitaScreenState();
}

class _QiitaScreenState extends State<QiitaScreen> {
  List<Article> posts = [];
  int currentPage = 1;
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    getData();
    controller.addListener(_scrollListener);
  }

  void getData() {
    QiitaClient.fetchArticle(page: currentPage).then((articles) {
      setState(() {
        posts.addAll(articles);
        currentPage++;
      });
    });
  }

  void _scrollListener() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      getData();
    }
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F4),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/images/qiita.png',
          width: 80,
          height: 30,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: posts.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      getData();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ListView.builder(
                        controller: controller,
                        itemCount: posts.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          return (index < posts.length)
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 5,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      final url = Uri.parse(posts[index].url);
                                      launchUrl(url);
                                    },
                                    child: Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 25,
                                                    backgroundImage:
                                                        NetworkImage(
                                                      posts[index].user.iconUrl,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        posts[index].user.id,
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFF101010),
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        posts[index]
                                                            .createdTime,
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFFB3B3B3),
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                posts[index].title,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                        },
                      ),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      ),
    );
  }
}
