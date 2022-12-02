import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class MyAccord extends StatelessWidget {
  const MyAccord({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile App Guidlines'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const <Widget>[
            GFAccordion(
              title: "How to Apply for Loan",
              content: "Desc",
            ),
            GFAccordion(
              title: "How to Calculate Loan & Interest",
              content: "Desc",
            ),
            GFAccordion(
              title: "How to Calculate Credit Score",
              content: "Desc",
            ),
            GFAccordion(
              title: "How to Track Loan",
              content: "Desc",
            ),
            GFAccordion(
              title: "How to Make Payment",
              content: "Desc",
            ),
            GFAccordion(
              title: "How to Record Expenses",
              content: "Desc",
            ),
            GFAccordion(
              title: "How to Manage Notifications",
              content: "Desc",
            )
          ],
        ),
      ),
    );
  }
}
