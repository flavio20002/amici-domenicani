import 'package:flutter/material.dart';

import '../screens/article.dart';
import '../utility.dart';

class Post extends StatelessWidget {
  const Post({super.key, this.post});

  final dynamic post;

  @override
  Widget build(BuildContext context) {
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
  }
}
