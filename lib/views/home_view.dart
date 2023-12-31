import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nba_app/models/team.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  List<Team> teams = [];

  Future getTeam() async {
    var url = Uri.https("balldontlie.io", "/api/v1/teams");
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);

    for (var eachTeam in jsonData["data"]) {
      final team =
          Team(abbreviation: eachTeam['abbreviation'], city: eachTeam['city']);
      teams.add(team);
    }
    print(teams.length);
  }

  @override
  Widget build(BuildContext context) {
    getTeam();
    return Scaffold(
      body: FutureBuilder(
          future: getTeam(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      child: ListTile(
                        title: Text(teams[index].abbreviation),
                        subtitle: Text(teams[index].city),
                      ),
                    );
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
