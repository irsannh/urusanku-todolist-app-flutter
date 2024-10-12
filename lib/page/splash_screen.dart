import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urusanku_app/config/app_color.dart';
import 'package:urusanku_app/page/home_page.dart';
import 'package:urusanku_app/page/welcome_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomePage()));
      }
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.blueColor,
      body: Column(
        children: [
          SizedBox(height: 276,),
          Center(child: Image.asset('images/logo_dua.png', height: 128, width: 128,)),
          SizedBox(height: 24,),
          Text('UrusanKu', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold
          )),)
        ],
      ),
    );
  }
}
