import 'package:amici_domenicani/screens/article_list.dart';
import 'package:flutter/material.dart';

import '../utility.dart';

class MyCategory extends StatelessWidget {
  const MyCategory({super.key, this.post, required this.getChildren});

  final dynamic post;
  final Future<List> Function(int id) getChildren;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: const Border(),
      title: Text(
          style: const TextStyle(fontWeight: FontWeight.bold),
          htmlToPlainText(post['name'])),
      children: <Widget>[
        FutureBuilder(
          future: getChildren(post['id']),
          builder: (BuildContext context, AsyncSnapshot<List> response) {
            if (!response.hasData) {
              return const Center(
                child: Text('Loading...'),
              );
            } else {
              return Column(
                children: response.data!
                    .map((e) => ListTile(
                          title: Text(
                            e['name'],
                          ),
                          onTap: () {
                            final categoryId = e['id'];
                            final categoryName = e['name'];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArticleListPage(
                                  categoryId: categoryId,
                                  categoryName: categoryName,
                                ),
                              ),
                            );
                          },
                        ))
                    .toList(),
              );
            }
          },
        )
      ],
    );
  }
}
