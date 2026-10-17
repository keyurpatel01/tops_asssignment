// QUESTION (Task 4):
// Compare the behavior of a basic news feed app screen with and without local
// storage: first, display a list of news headlines fetched from a mock API;
// then, modify the app to cache the headlines locally so they are still shown
// when the device is offline.

import 'package:flutter/material.dart';
import 'package:flutter_application_1/database.dart';

bool offline = false;

Future<List<String>> fetchNews() async {
  await Future.delayed(const Duration(seconds: 1)); // fake loading time
  if (offline) throw Exception('No internet');
  return [
    'Flutter releases new version',
    'ISRO announces next mission',
    'Stock market hits record high',
    'India wins cricket series',
  ];
}

class P4 extends StatefulWidget {
  const P4({super.key});

  @override
  State<P4> createState() => _P4State();
}

class _P4State extends State<P4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News App')),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Simulate offline'),
            value: offline,
            onChanged: (value) => setState(() => offline = value),
          ),
          ElevatedButton(
            child: const Text('Without local storage'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const NewsScreen(useCache: false),
              ),
            ),
          ),
          ElevatedButton(
            child: const Text('With local storage'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const NewsScreen(useCache: true),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NewsScreen extends StatefulWidget {
  final bool useCache;
  const NewsScreen({super.key, required this.useCache});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<String> news = [];
  String message = '';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadNews();
  }

  Future<void> loadNews() async {
    try {
      final list = await fetchNews();

      if (widget.useCache) {
        await database_helper.saveNews(list);
      }
      news = list;
      message = '';
    } catch (e) {
      if (widget.useCache) {
        news = await database_helper.getNews();
        message = 'Offline - showing saved news';
      } else {
        news = [];
        message = 'No internet connection';
      }
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.useCache ? 'With Cache' : 'Without Cache'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (message.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                Expanded(
                  child: ListView(
                    children: news
                        .map((title) => ListTile(title: Text(title)))
                        .toList(),
                  ),
                ),
              ],
            ),
    );
  }
}
