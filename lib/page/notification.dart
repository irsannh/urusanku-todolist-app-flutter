import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urusanku_app/page/home_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
        }, icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 24,)),
        title: Text('Notifikasi', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600
        )),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(

        ),
      ),
    );
  }
}
