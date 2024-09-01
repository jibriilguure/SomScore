import 'package:flutter/material.dart';

class BrowseCompetition extends StatelessWidget {
  final List<Map<String, String>> competitions = [
    {'region': 'Europe', 'name': 'Champions League', 'flag': '🇪🇺'},
    {'region': 'England', 'name': 'Premier League', 'flag': '🏴'},
    {'region': 'Spain', 'name': 'La Liga', 'flag': '🇪🇸'},
    {'region': 'Italy', 'name': 'Serie A', 'flag': '🇮🇹'},
    {'region': 'Germany', 'name': 'Bundesliga', 'flag': '🇩🇪'},
    {'region': 'France', 'name': 'Ligue 1', 'flag': '🇫🇷'},
    {'region': 'Europe', 'name': 'Europa League', 'flag': '🇪🇺'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '9:41',
                    style: TextStyle(color: Colors.white),
                  ),
                  Row(
                    children: List.generate(3, (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Browse Competition',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    hintText: 'Search for competition, club...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Top',
                    style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Region',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Favorites',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'TOP COMPETITIONS',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: competitions.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          leading: Text(
                            competitions[index]['flag']!,
                            style: TextStyle(fontSize: 24),
                          ),
                          title: Text(
                            competitions[index]['name']!,
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            competitions[index]['region']!,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Divider(color: Colors.grey[700]),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Competition',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BrowseCompetition(),
    theme: ThemeData.dark(),
  ));
}
