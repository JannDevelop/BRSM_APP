import 'package:brsm_id/screens/events.dart';
import 'package:brsm_id/screens/profile.dart';
import 'package:brsm_id/screens/scaner.dart';
import 'package:brsm_id/screens/shop.dart';
import 'package:flutter/material.dart';
import 'package:brsm_id/service/parsing_news.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late Future<List<NewsItem>> newsFuture;
  
   late TabController _tabController;

   final List<String> _titles = [
    "Магазин",
    "Сканер",
    "Новости БРСМ",
    "События",
    "Профиль",
  ];

  @override
  void initState() {
    super.initState();
    newsFuture = fetchBrsmNews(); 
    _tabController = TabController(length: 5, vsync: this, initialIndex: 2);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {}); 
      }
    });

  }

  @override
  void dispose (){
    super.dispose();
    _tabController.dispose();
  }

  // Pull-to-refresh
  Future<void> _refresh() async {
    setState(() {
      newsFuture = fetchBrsmNews();
    });
  }

 @override
Widget build(BuildContext context) {
  return DefaultTabController(
    length: 5,
    child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
           _titles[_tabController.index],
        ),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.black,
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.white,
        child: TabBar(
          controller: _tabController,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.grey,
          indicator: const BoxDecoration(),
          labelPadding: EdgeInsets.zero,
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: 'montserrat',
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            fontFamily: 'montserrat',
          ),
          tabs: const [
            Tab(icon: FaIcon(FontAwesomeIcons.shop, size: 21), text: "Магазин"),
            Tab(icon: FaIcon(FontAwesomeIcons.qrcode, size: 21), text: "Сканер"),
            Tab(icon: FaIcon(FontAwesomeIcons.newspaper, size: 21), text: "Новости"),
            Tab(icon: FaIcon(FontAwesomeIcons.calendar, size: 21), text: "События"),
            Tab(icon: FaIcon(FontAwesomeIcons.user, size: 21), text: "Профиль"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 0 - Магазин
          ShopPage(),
          
          // 1 - Сканер
          const QrScanPage(), // твой сканер QR
          
          // 2 - Новости
          FutureBuilder<List<NewsItem>>(
            future: newsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 116, 199, 130),
                ));
              }
              if (snapshot.hasError) {
                return Center(child: Text("Ошибка: ${snapshot.error}"));
              }
              final news = snapshot.data!;
              return RefreshIndicator(
                onRefresh: _refresh,
                color: const Color.fromARGB(255, 116, 199, 130),
                child: ListView.builder(
                  itemCount: news.length,
                  itemBuilder: (context, index) {
                    final item = news[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          final uri = Uri.parse(item.link);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item.imageURL.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    item.imageURL,
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              const SizedBox(height: 12),
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.date,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          
          // 3 - События
           EventsPage(),
          
          // 4 - Профиль
          const ProfilePage (),
        ],
      ),
    ),
  );
}
}