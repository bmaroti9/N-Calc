/*
Copyright (C) <2023>  <Balint Maroti>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

*/

import 'package:flutter/material.dart';
import 'package:n_calc/ui_helper.dart';
import 'package:function_tree/function_tree.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String main = '';
  String all_main = '0';
  String sub = '';

  void AddChar(String char) {
    setState(() {
      if (char == 'AC') {
        main = '';
      }
      else if (char == '+/-') {
        if (main[0] == "-") {
          main = main.substring(1);
        }
        else {
          main = "-$main";
        }
      }
      else if (char == '=') {
        main = sub.toString();
        sub = '';
      }
      else {
        main = "$main$char";
      }
      if (Numeric(main)) {
        sub = '';
      }
      else {
        try {
          String hihi = combText(main);
          num n = hihi.interpret();
          sub = n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
        } on Exception{
          sub = '';
        } on Error {
          sub = '';
        }
      }

      if (main != '') {
        all_main = main.toString();
      }
      else {
        all_main = '0';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
        child: Column(
          children: [
            Expanded(
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 120),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                          child: Center(
                            key: ValueKey<String>(all_main),
                              child: nothingtext(all_main, 50, align: TextAlign.center)
                          )
                        ),
                        AnimatedSwitcher(
                            duration: const Duration(milliseconds: 120),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return FadeTransition(opacity: animation, child: child);
                            },
                            child: Center(
                                key: ValueKey<String>(sub),
                                child: nothingtext(sub, 25, align: TextAlign.center)
                            )
                        ),
                      ],
                    ),
                )
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: height * 0.7),
                child: AspectRatio(
                  aspectRatio: 0.7,
                  child:  LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      double width = constraints.maxWidth;
                      return GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        crossAxisCount: 4,
                        children: [
                          numberButton('%', AddChar, width),
                          numberButton("+/-", AddChar, width),
                          numberButton('()', AddChar, width),
                          numberButton('/', AddChar, width, Colors.red),
                          numberButton('7', AddChar, width),
                          numberButton('8', AddChar, width),
                          numberButton('9', AddChar, width),
                          numberButton('×', AddChar, width, Colors.red),
                          numberButton('4', AddChar, width),
                          numberButton('5', AddChar, width),
                          numberButton('6', AddChar, width),
                          numberButton('-', AddChar, width, Colors.red),
                          numberButton('1', AddChar, width),
                          numberButton('2', AddChar, width),
                          numberButton('3', AddChar, width),
                          numberButton('+', AddChar, width, Colors.red),
                          numberButton('AC', AddChar, width, Colors.white, Colors.red),
                          numberButton('0', AddChar, width),
                          numberButton('.', AddChar, width),
                          numberButton('=', AddChar, width, Colors.red),
                        ],

                      );
                  }
                ),
              )
              ),
            )
          ],
        ),
      ),
    );
  }
}
