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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(left: 35, right: 35, top: 30, bottom: 30),
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
                              child: nothingtext(all_main, 60, align: TextAlign.center)
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
            AspectRatio(
              aspectRatio: 0.7,
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                crossAxisCount: 4,
                children: [
                  numberButton('%', AddChar),
                  numberButton("+/-", AddChar),
                  numberButton('()', AddChar),
                  numberButton('/', AddChar, Colors.red),
                  numberButton('7', AddChar),
                  numberButton('8', AddChar),
                  numberButton('9', AddChar),
                  numberButton('×', AddChar, Colors.red),
                  numberButton('4', AddChar),
                  numberButton('5', AddChar),
                  numberButton('6', AddChar),
                  numberButton('-', AddChar, Colors.red),
                  numberButton('1', AddChar),
                  numberButton('2', AddChar),
                  numberButton('3', AddChar),
                  numberButton('+', AddChar, Colors.red),
                  numberButton('AC', AddChar, Colors.white, Colors.red),
                  numberButton('0', AddChar),
                  numberButton('.', AddChar),
                  numberButton('=', AddChar, Colors.red),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
