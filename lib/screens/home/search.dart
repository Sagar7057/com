import 'package:communityapp/screens/profile/list.dart';
import 'package:communityapp/services/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final UserService _userService = UserService();
  String search = '';
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: _userService.queryByName(search),
      initialData: null,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  search = text;
                });
              },
              decoration: const InputDecoration(hintText: 'Search...'),
            ),
          ),
          const ListUsers()
        ],
      ),
    );
  }
}