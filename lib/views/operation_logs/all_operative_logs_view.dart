import 'package:flutter/material.dart';
import '/widgets/operative_logs_list.dart';

class AllOperativeLogsView extends StatelessWidget {
  final String userEmail;
  const AllOperativeLogsView({Key? key, required this.userEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OperativeLogsList(userEmail: userEmail,),
    );
  }
}
