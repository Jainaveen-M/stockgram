import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockgram/bloc/market/market_bloc.dart';
import 'package:stockgram/bloc/order_history/order_history_bloc.dart';
import 'package:stockgram/presentation/screens/auth_screen.dart';
import 'package:stockgram/presentation/screens/market.dart';
import 'package:stockgram/presentation/screens/order_history.dart';
import 'package:stockgram/presentation/screens/portfolio.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late int currentTab;
  late TabController tabController;
  Color unselectedColor = Colors.grey;
  @override
  void initState() {
    currentTab = 0;
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stockgram"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Logout"),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("No"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthScreen()));
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: TabBar(
                controller: tabController,
                indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(
                  color: Colors.orange,
                  width: 3,
                )),
                indicatorPadding: const EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 0.0),
                tabs: [
                  Text(
                    'Market',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight:
                          currentTab == 0 ? FontWeight.bold : FontWeight.normal,
                      fontSize: 16.0,
                      color: currentTab == 0 ? Colors.black : unselectedColor,
                    ),
                  ),
                  Text(
                    'History',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight:
                          currentTab == 1 ? FontWeight.bold : FontWeight.normal,
                      fontSize: 16.0,
                      color: currentTab == 1 ? Colors.black : unselectedColor,
                    ),
                  ),
                  Text(
                    'Portfolio',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight:
                          currentTab == 2 ? FontWeight.bold : FontWeight.normal,
                      fontSize: 16.0,
                      color: currentTab == 2 ? Colors.black : unselectedColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  BlocProvider(
                    create: (context) => MarketBloc(),
                    child: const Market(),
                  ),
                  BlocProvider(
                    create: (context) => OrderHistoryBloc(),
                    child: const OrderHistory(),
                  ),
                  PortFolio()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
