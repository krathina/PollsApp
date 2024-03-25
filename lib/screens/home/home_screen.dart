import 'package:flutter/material.dart';
import 'package:polls_app/data/rest_ds.dart';
import 'package:polls_app/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late BuildContext _ctx;
  RestDatasource api = RestDatasource();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Polls from Maldives"),
          centerTitle: true,
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          child: FutureBuilder<List>(
              future: api.getPolls(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, int position) {
                        var item = snapshot.data![position];
                        return ExpansionTile(
                            leading: (item['pollIcon'].toString().isEmpty
                                ? CircleAvatar(
                                    backgroundColor: Colors.lightBlueAccent,
                                    child: Text(item['question'][0]
                                        .toString()
                                        .toUpperCase()),
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.lightBlueAccent,
                                    backgroundImage:
                                        NetworkImage(item['pollIcon']),
                                  )),
                            title: Text(item['question']),
                            children: generatePolls(item));
                      });
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ));
  }

  List<Widget> generatePolls(Map item) {
    List<Widget> widgets = [];
    widgets.add(ListTile(
        title: Text(
      item['description'],
      textAlign: TextAlign.justify,
      style: const TextStyle(fontSize: 15.0),
    )));

    for (int x = 1; x < 10; x++) {
      if (item['ans$x'] != null) {
        Widget tile = ListTile(
            leading: (item['ansPic$x'] != null)
                ? CircleAvatar(
                    backgroundColor: Colors.lightBlue,
                    backgroundImage: NetworkImage(item['ansPic$x']))
                : null,
            trailing: TextButton.icon(
                onPressed: () => doVote(item['id'], x),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Vote')),
            subtitle: Text('${item['score$x']} %'),
            title: Text(item['ans$x']));
        widgets.add(tile);
      }
    }
    return widgets;
  }

  doVote(int pollId, int answerId) async {
    String currState = await getAuthState();
    if (currState == "logged_out") {
      Navigator.of(_ctx).pushReplacementNamed("/login");
    } else {
      String accessToken = await getAccessToken();
      if (accessToken == '') {
        Navigator.of(_ctx).pushReplacementNamed("/login");
      } else {
        api.vote(accessToken, pollId, answerId);
      }
    }
  }

  checkLoggedIn() async {
    String currState = await getAuthState();
    if (currState != "logged_out") {
      Navigator.of(_ctx).pushReplacementNamed("/home");
    }
  }
}
