import 'dart:convert'; // Import dart:convert for JSON decoding

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  Future<List<dynamic>> fetchMovies() async {
    const apiKey =
        "1500496dcaf1512b62894bd98ba83f9d"; // Replace with your API key
    final url = Uri.parse(
        "https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body)["results"];
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff191826),
      appBar: AppBar(
        backgroundColor: const Color(0xff191826),
        title: const Text(
          'MOVIES',
          style: TextStyle(fontSize: 25, color: Color(0xfff43370)),
        ),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: FutureBuilder(
        future: fetchMovies(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            List<dynamic> movies = snapshot.data as List<dynamic>;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Container(
                      height: 250,
                      alignment: Alignment.centerLeft,
                      child: Card(
                        child: Image.network(
                          "https://image.tmdb.org/t/p/w500" +
                              movies[index]["poster_path"],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20.0),
                          Text(movies[index]["original_title"],
                              style: const TextStyle(color: Colors.white)),
                          const SizedBox(height: 10),
                          Text(movies[index]["release_date"],
                              style:
                                  const TextStyle(color: Color(0xff868597))),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 100,
                            child: Text(movies[index]["overview"],
                                style: const TextStyle(
                                    color: Color(0xff868597))),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }
          return const Center(
            child: Text("No data available."),
          );
        },
      ),
    );
  }
}
