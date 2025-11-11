import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as html;

class NewsItem {
  final String title;
  final String link;
  final String date;
  final String imageURL;

  NewsItem({
    required this.title,
    required this.link,
    required this.date,
    required this.imageURL,
  });
}

Future<List<NewsItem>> fetchBrsmNews() async {
  final response = await http.get(Uri.parse('https://brsm.by/ru/all-news-ru'));

  if (response.statusCode != 200) {
    throw Exception('Не удалось загрузить новости');
  }

  final document = parse(response.body);
  final news = <NewsItem>[];

  final items = document.querySelectorAll('a.news_item');

  for (html.Element el in items) {


    final rawLink = el.attributes['href'] ?? "";
    final link = rawLink.startsWith("http")
        ? rawLink
        : "https://brsm.by$rawLink";

    final date = el.querySelector('.news_date')?.text.trim() ?? '';

    final title = el.querySelector('.hover_text.font_size_22, .hover_text.font_size_36')?.text.trim() ?? '';

    final img = el.querySelector('img')?.attributes['src'] ?? '';
    final imageURL = img.startsWith("http") ? img : "https://brsm.by$img";

    news.add(NewsItem(
      title: title,
      link: link,
      date: date,
      imageURL: imageURL,
    ));
  }

  return news;
}
