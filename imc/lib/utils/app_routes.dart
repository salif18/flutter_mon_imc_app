import 'package:flutter/material.dart';
import 'package:imc/views/calculatrice.dart';
import 'package:imc/views/imc_view.dart';
import 'package:imc/views/stats_view.dart';

class MyAppRoutes extends StatefulWidget {
  const MyAppRoutes({super.key});

  @override
  State<MyAppRoutes> createState() => _MyAppRoutesState();
}

class _MyAppRoutesState extends State<MyAppRoutes> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const [
        ImcCalculatorView(),
        ImcView(),
        StatsView()
      ][_currentIndex],
      bottomNavigationBar: _bottomTab(),
    );
  }

  Widget _bottomTab() {
    return SizedBox(
      height: 80,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        elevation: 20,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.blueGrey,
        iconSize: MediaQuery.of(context).size.width * 0.06,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.calculate), label: "Calculer IMC"),
          BottomNavigationBarItem(
              icon: Icon(Icons.speed_rounded), label: "Mon IMC"),
               BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded), label: "Evolution"),
        ],
      ),
    );
  }
}
