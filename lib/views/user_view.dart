import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '/models/doctor_user.dart';

import 'all_operative_logs_view.dart';

class UserView extends StatelessWidget {
  final DoctorUser user;
  const UserView({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black87,),
      body: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 75.0,
                backgroundImage: NetworkImage(
                    'https://www.shareicon.net/data/512x512/2016/09/01/822712_user_512x512.png'),
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(
                height: 21,
              ),
              Text(
                user.name!.toUpperCase(),
                style: const TextStyle(fontSize: 21.0),
              ),
              Text(
                user.roles!.first.toUpperCase(),
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(
                height: 28,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children:  [
                    ListTile(
                      onTap: (){
                        Get.to(()=> AllOperativeLogsView(userEmail: user.email!));
                      },
                      leading: const Icon(Icons.book_outlined),
                      title: const Text('Operative logs'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                    const ListTile(
                      leading: Icon(Icons.fact_check_outlined),
                      title: Text('Quizzes'),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
