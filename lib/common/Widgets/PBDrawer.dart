import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PBDrawer extends StatelessWidget {
  PBDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              radius: 30.0,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/John_Doe%2C_born_John_Nommensen_Duchac.jpg/1200px-John_Doe%2C_born_John_Nommensen_Duchac.jpg"),
            ),
            accountName: Text("Peerbits"),
            accountEmail: Text("apps@peerbits.com"),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("Edit Profile"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
