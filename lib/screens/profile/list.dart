import 'package:communityapp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ListUsers extends StatefulWidget {
  const ListUsers({Key? key}) : super(key: key);

  @override
  _ListUsersState createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<UserModel>?>(context) ?? [];

    return ListView.builder(
        shrinkWrap: true,
        itemCount: users.length ,
        itemBuilder: (context, index) {
          final user = users[index];
          return InkWell(
            onTap: () =>
                Navigator.pushNamed(context, '/profile', arguments: user.id),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(children: [
                      user.profileImageUrl != ''
                          ? CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  NetworkImage(user.profileImageUrl),
                            )
                          : const Icon(Icons.person, size: 40),
                      const SizedBox(width: 10),
                      Text(user.name)
                    ])),
                const Divider(
                  thickness: 1,
                )
              ],
            ),
          );
        });
  }
}