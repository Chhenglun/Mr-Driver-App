import 'package:flutter/material.dart';
import 'dart:async';

import 'package:scholarar/view/screen/home/driver_accepted.dart';

class Waiting extends StatefulWidget {
  const Waiting({super.key});

  @override
  State<Waiting> createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {

  int _counter = 10;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Start the timer to update the counter every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer.cancel(); // Stop the timer when countdown reaches 0
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DriverAccepted()),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                            // decoration: BoxDecoration(
                            //     color: Colors.black,
                            //     borderRadius: BorderRadius.circular(25)),
                            child: ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.red),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'ត្រឡប់ក្រោយ',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                )),
                          ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 2 / 15,
            ),
            Stack(
              children: [
                Container(
                  width: 220,
                  height: 220,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black12,
                  ),
                  child: CircularProgressIndicator(
                    value: (_counter / 10),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    strokeWidth: 5,
                  ),
                ),
                Positioned(
                  left: 80,
                  top: 100,
                    child: Text(
                      '$_counter វិនាទី',
                      style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 1 / 30,
            ),
            Text('សូមរង់ចាំការឆ្លើយតបពីអ្នកបើកបរ'),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 1 / 15,
            ),
            ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.red),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    'លុបចោលការកក់',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
          ]
        ),
      ),
    );
  }
}
