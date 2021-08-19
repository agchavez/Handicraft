import 'package:handicraft_app/utils/constants.dart';
import 'package:flutter/material.dart';

import 'package:handicraft_app/widgets/body_messages.dart';
import 'package:handicraft_app/pages/menssange_pages.dart';

class MessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          SizedBox(
            width: 5,
          ),
          Container(
            child: FloatingActionButton(
              child: Image.asset(
                'assets/icons/back-black-icon.png',
                width: 5.0,
              ),
              backgroundColor: Colors.white,
              onPressed: () {
                Navigator.pop(context);
                MenssagePages();
              },
            ),
            height: 30.0,
            width: 30.0,
          ),
          SizedBox(
            width: 15,
          ),
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/user_2.png"),
          ),
          SizedBox(width: kDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Kristin Watson",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Active 3m ago",
                style: TextStyle(fontSize: 12),
              )
            ],
          )
        ],
      ),
      actions: [
        Row(
          children: [
            Image.asset(
              'assets/icons/menu-icon.png',
              width: 18,
              height: 18,
            ),
            SizedBox(
              width: 13,
            )
          ],
        )
      ],
    );
  }
}
