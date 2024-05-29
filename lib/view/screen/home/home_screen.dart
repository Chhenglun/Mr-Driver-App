import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scholarar/view/screen/home/current_location.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TypewriterAnimatedTextKit(
            text: ['Mr Passenger CAM'],
            textStyle: TextStyle(
              color: Colors.red,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            speed: Duration(milliseconds: 200),
          ),
          actions: [
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.notifications, color: Colors.red,)
            )
          ],
        ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: ElevatedButton(
            style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Colors.red),
                        ),
            onPressed: (){
              Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => const CurrentLocation(),
                              )
                            );
            },
            child: Text('Booking', style: TextStyle(color: Colors.white),),
            )
          ),
        ),
    );
  }
}
