import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qiita_app/feature/qiita/qiita_notifier.dart';
import 'package:url_launcher/url_launcher.dart';

class QiitaScreen extends HookConsumerWidget {
  const QiitaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(qiitaNotifierProvider);
    final controller = useScrollController();
    useEffect(() {
      ref.read(qiitaNotifierProvider.notifier).fetchArticles();
      controller.addListener(() {
        if (controller.position.pixels == controller.position.maxScrollExtent) {
          ref.read(qiitaNotifierProvider.notifier).fetchArticles();
        }
      });
      return controller.dispose;
    }, [controller]);
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
                      ref.read(qiitaNotifierProvider.notifier).fetchArticles();
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
