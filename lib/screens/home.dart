import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

import 'article.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1);
  List<dynamic> posts = [];

  Future<void> fetchPosts(int pageKey) async {
    final url = Uri.parse(
        'https://www.amicidomenicani.it/wp-json/wp/v2/posts?per_page=10&page=$pageKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> fetchedPosts = jsonDecode(response.body);
        final isLastPage = fetchedPosts.length < 10;
        if (isLastPage) {
          _pagingController.appendLastPage(fetchedPosts);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(fetchedPosts, nextPageKey);
        }
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      fetchPosts(pageKey);
    });
    super.initState();
  }

  Future<void> refreshPosts() async {
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amici Domenicani'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              refreshPosts();
            },
          ),
        ],
      ),
      body: PagedListView<int, dynamic>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<dynamic>(
          firstPageErrorIndicatorBuilder: (context) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: InkWell(
                child: Text(
                  "Si è verificato un errore di rete. Tocca per riprovare",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                onTap: () {
                  _pagingController.retryLastFailedRequest();
                },
              ),
            ),
          ),
          newPageErrorIndicatorBuilder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: InkWell(
                child: Text(
                  "Si è verificato un errore di rete. Tocca per riprovare",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  _pagingController.retryLastFailedRequest();
                },
              ),
            ),
          ),
          itemBuilder: (context, post, index) {
            return ListTile(
              title: Text(
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  htmlToPlainText(post['title']['rendered'])),
              subtitle: Text(
                formatDate(post['date']),
              ),
              onTap: () {
                final articleText = post['content']['rendered'];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ArticlePage(articleText: htmlToPlainText(articleText)),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

String htmlToPlainText(String htmlString) {
  final unescape = HtmlUnescape();
  final text = unescape.convert(htmlString);
  return text;
}

String formatDate(String dateString) {
  final inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
  final outputFormat = DateFormat('d MMMM yyyy', 'it_IT');
  final date = inputFormat.parse(dateString);
  final formattedDate = outputFormat.format(date);
  return formattedDate;
}
