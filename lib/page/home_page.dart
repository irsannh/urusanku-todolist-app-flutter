import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urusanku_app/config/app_color.dart';
import 'package:urusanku_app/controller/notification_service.dart';
import 'package:urusanku_app/page/add_task.dart';
import 'package:urusanku_app/page/detail_task.dart';
import 'package:urusanku_app/page/notification.dart';
import 'package:urusanku_app/page/welcome_page.dart';
import 'package:badges/badges.dart' as badges;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? name;
  Map<dynamic, dynamic>? tasks;

  Future<void> getNameAndTasks() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref = FirebaseDatabase.instance.ref("UsersData/$uid");

    try {
      DatabaseEvent event = await ref.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          name = data['name'];
          tasks = data['tasks'] != null ? Map<dynamic, dynamic>.from(data['tasks']) : {};
        });
      } else {
        setState(() {
          name = FirebaseAuth.instance.currentUser!.email as String;
          tasks = {};
        });
      }
    } catch (e) {
      setState(() {
        name = 'User';
        tasks = {};
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationService.refreshToken();
    getNameAndTasks();
  }

  void logout(BuildContext context) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DatabaseReference ref = FirebaseDatabase.instance.ref("UsersData/$uid");
      await ref.update({
        "fcmToken": "0",
        "isLoggedIn": false,
      });
      await FirebaseMessaging.instance.deleteToken();
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => WelcomePage()), (
          Route<dynamic> route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi Kesalahan',
          style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal
          )),), backgroundColor: Colors.red,),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (name == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'UrusanKu', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20
        )),
        ),
        centerTitle: true,
        actions: [
          Row(
            children: [
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage()));
              }, icon: Icon(Icons.notifications, color: Colors.black, size: 24,)),
              IconButton(onPressed: () {
                logout(context);
              }, icon: Icon(Icons.logout, color: Colors.black, size: 24,)),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskPage()));
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColor.blueColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Halo,', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.normal
            ))),
            SizedBox(height: 8),
            Text(name!, style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600
            ))),
            SizedBox(height: 16),
            Text('Senarai Urusan', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16
            ))),
            SizedBox(height: 8),
            tasks == null || tasks!.isEmpty ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 213),
                  Text('Anda Belum Memiliki Urusan Apapun', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                      color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600
                  ))),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Tekan', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                          color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600
                      ))),
                      SizedBox(width: 8),
                      Icon(Icons.add, color: Colors.black, size: 24),
                      SizedBox(width: 8),
                      Text('Untuk', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                          color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600
                      ))),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('Membuat Urusan Baru', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                      color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600
                  ))),
                ],
              ),
            ) : Expanded(
              child: ListView.builder(
                itemCount: tasks!.length,
                itemBuilder: (context, index) {
                  String key = tasks!.keys.elementAt(index);
                  Map task = tasks![key];

                  return Card(
                    color: Colors.white,
                    elevation: 1,
                    margin: EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded( // Agar konten utama fleksibel mengikuti trailing
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(task['taskName'], style: GoogleFonts.plusJakartaSans(
                                        color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600
                                    )),
                                    SizedBox(width: 8,),
                                    if (task['isDone'] == false)
                                      Icon(Icons.close, color: Colors.red, size: 24,)
                                    else
                                      Icon(Icons.check, color: Colors.green, size: 24,)
                                  ],
                                ),
                                SizedBox(height: 12),
                                if (task['taskPriority'] == "Prioritas Tinggi")
                                  Container(
                                    decoration: BoxDecoration(
                                        color: AppColor.blueColor,
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text('PRIORITAS TINGGI', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                                          color: Colors.white, fontSize: 12, fontWeight: FontWeight.w200
                                      ))),
                                    ),
                                  )
                                else if (task['taskPriority'] == "Prioritas Sedang")
                                  Container(
                                    decoration: BoxDecoration(
                                        color: AppColor.lightBlueColor,
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text('PRIORITAS SEDANG', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                                          color: Colors.white, fontSize: 12, fontWeight: FontWeight.w200
                                      ))),
                                    ),
                                  )
                                else if (task['taskPriority'] == "Prioritas Rendah")
                                    Container(
                                      decoration: BoxDecoration(
                                          color: AppColor.veryLightBlueColor,
                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text('PRIORITAS RENDAH', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                                            color: Colors.white, fontSize: 12, fontWeight: FontWeight.w200
                                        ))),
                                      ),
                                    ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today, color: Colors.black, size: 24),
                                    SizedBox(width: 8),
                                    Text(task['taskTime'], style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                                        color: Colors.black, fontSize: 12, fontWeight: FontWeight.w200
                                    ))),
                                  ],
                                )
                              ],
                            ),
                          ),
                          // Trailing arrow icon moved to the right
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: IconButton(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailTaskPage(task: task, taskKey: key)));
                                  },
                                  icon: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 24),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );

                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}