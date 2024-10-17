import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urusanku_app/config/app_color.dart';
import 'package:urusanku_app/page/home_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Map<dynamic, dynamic>? notifications;

  Future<void> getNotifications() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref = FirebaseDatabase.instance.ref("UsersData/$uid");

    try {
      DatabaseEvent event = await ref.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          notifications = data['notifications'] != null ? Map<dynamic, dynamic>.from(data['notifications']) : {};
        });
      } else {
        setState(() {
          notifications = {};
        });
      }
    } catch (e) {
      setState(() {
        notifications = {};
      });
    }
  }

  Future<void> deleteNotification(String key) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref = FirebaseDatabase.instance.ref("UsersData/$uid/notifications/$key");

    try {
      await ref.remove();
      setState(() {
        CircularProgressIndicator();
        notifications!.remove(key);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal Menghapus, terjadi kesalahan: $e', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal
        )),), backgroundColor: Colors.red,),
      );
    }
  }

  Future<void> deleteAllNotifications() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref = FirebaseDatabase.instance.ref("UsersData/$uid/notifications");

    try {
      await ref.remove();
      setState(() {
        CircularProgressIndicator();
        notifications = {};
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal Menghapus, terjadi kesalahan: $e', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal
        )),), backgroundColor: Colors.red,),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage()), (
              Route<dynamic> route) => false);
        }, icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 24,)),
        title: Text('Notifikasi', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600
        )),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            notifications == null || notifications!.isEmpty ? Center(
              child: Text('Tidak Ada Notifikasi'),
            ) : Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(onPressed: (){
                          deleteAllNotifications();
                        }, child: Text('Hapus Semua', style: GoogleFonts.plusJakartaSans(
                          textStyle: TextStyle(
                            color: AppColor.blueColor, fontSize: 14, fontWeight: FontWeight.w600
                          )
                        ),))
                      ],
                    ),
                    SizedBox(height: 16,),
                    Expanded(
                        child: ListView.builder(
                          itemCount: notifications!.length,
                          itemBuilder: (context, index) {
                            String key = notifications!.keys.elementAt(index);
                            Map notification = notifications![key];
                            
                            return Card(
                              color: Colors.white,
                              elevation: 1,
                              margin: EdgeInsets.only(bottom: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(notification['title'], style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                                            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold
                                          )),),
                                          SizedBox(height: 8,),
                                          Text(notification['message'], style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                                            color: Colors.black, fontSize: 14, fontWeight: FontWeight.w300
                                          )),),
                                          SizedBox(height: 8,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Icon(Icons.calendar_today, size: 24, color: Colors.black,),
                                              SizedBox(width: 8,),
                                              Text(notification['notificationTime'], style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                                                color: Colors.black38, fontSize: 14, fontWeight: FontWeight.w300
                                              )),),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 20),
                                          child: IconButton(
                                            onPressed: (){
                                              deleteNotification(key);
                                            },
                                            icon: Icon(Icons.delete, color: Colors.red, size: 24),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                    )
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}
