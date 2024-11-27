// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news/controllers/news_controller.dart';
import 'package:news/models/news.dart';
import 'package:news/services/connectivity_service.dart';
import 'package:news/services/shared_preferences_service.dart';
import '../views/news_detail_view.dart';
import '../views/country_selection_dialog.dart';
import '../widgets/error_widget.dart';

class NewsView extends StatefulWidget {
  final String initialCountry;

  const NewsView({super.key, required this.initialCountry});

  @override
  _NewsViewState createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  final NewsController _newsController = NewsController();
  final ConnectivityService _connectivityService = ConnectivityService();
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  late Future<List<News>> _newsFuture;
  late String _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.initialCountry;
    _loadNews();
  }

  void _loadNews() async {
    bool isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      setState(() {
        _newsFuture = Future.error("Tidak ada koneksi internet.");
      });
      return;
    }
    setState(() {
      _newsFuture = _newsController.fetchNews(_selectedCountry);
    });
  }

  Future<void> _changeCountry() async {
    final country = await showDialog<String>(
      context: context,
      builder: (context) => CountrySelectionDialog(),
    );

    if (country != null && country != _selectedCountry) {
      await _prefsService.setSelectedCountry(country);
      setState(() {
        _selectedCountry = country;
      });
      _loadNews();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Berita dari $_selectedCountry",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: _changeCountry,
          ),
        ],
      ),
      body: FutureBuilder<List<News>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return ErrorDisplayWidget(message: snapshot.error.toString());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada berita."));
          } else {
            final newsList = snapshot.data!;
            return ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];
                return ListTile(
                  leading: news.imageUrl.isNotEmpty
                      ? Image.network(news.imageUrl,
                          width: 100, fit: BoxFit.cover)
                      : const Icon(Icons.image),
                  title: Text(
                    news.title,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailView(news: news),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
