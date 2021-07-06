import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wealth_management/Home_Page/HomePage.dart';

import 'check_internet.dart';

class No_Internet_Connection extends StatefulWidget {
  const No_Internet_Connection({Key? key}) : super(key: key);

  @override
  _No_Internet_ConnectionState createState() => _No_Internet_ConnectionState();
}

class _No_Internet_ConnectionState extends State<No_Internet_Connection> {

  int checkInt = 0;

  @override
  void initState() {
    super.initState();
    Future<int> a = CheckInternet().checkInternetConnection();
    a.then((value) {
      if (value == 0) {
        setState(() {
          checkInt = 0;
        });
        print('No internet connect');
        // Timer(
        //     Duration(seconds: 1),
        //         () => Navigator.pushAndRemoveUntil(
        //         context,
        //         MaterialPageRoute(builder: (context) => No_Internet_Connection()),
        //             (route) => false));

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No internet connection!'),
        ));
      } else {
        setState(() {
          checkInt = 1;
        });
        print('Internet connected');
        Timer(
            Duration(seconds:2),
                () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage(url: 'http://carryforward.bizzware.net/')),
                    (route) => false));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Connected to the internet'),
        ));
      }
    });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
       child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/no-internet.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Text(
              "No Internet Connection",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(
                    "You are not connected to the internet",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Make sure Wi-Fi is on, Airplane Mode is Off and try again.",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),



                  SizedBox(height: 20,),

                  TextButton(
                      child: Text(
                          "Try to connect".toUpperCase(),
                          style: TextStyle(fontSize: 14)
                      ),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                          foregroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(251, 182, 77, 1)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color:Color.fromRGBO(251, 182, 77, 1))
                              )
                          )
                      ), onPressed: () {


                    Future<int> a = CheckInternet().checkInternetConnection();
                    a.then((value) {
                      if (value == 0) {
                        setState(() {
                          checkInt = 0;
                        });
                        print('No internet connect');
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('No internet connection!'),
                        ));
                      } else {
                        setState(() {
                          checkInt = 1;
                        });
                        print('Internet connected');
                        Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => HomePage(url: 'http://carryforward.bizzware.net/')),
                                    (route) => false);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Connected to the internet'),
                        ));
                      }
                    });

                  }
                  )
                ],
              ),

            )
          ],
        ),
      )
    // This trailing comma makes auto-formatting nicer for build methods.
    );
  }



}