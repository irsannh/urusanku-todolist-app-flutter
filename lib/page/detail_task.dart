import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urusanku_app/config/app_color.dart';
import 'package:urusanku_app/page/edit_task.dart';
import 'package:urusanku_app/page/home_page.dart';

class DetailTaskPage extends StatefulWidget {
  final Map task;
  final String taskKey;
  const DetailTaskPage({super.key, required this.task, required this.taskKey});

  @override
  State<DetailTaskPage> createState() => _DetailTaskPageState();
}

class _DetailTaskPageState extends State<DetailTaskPage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  String uid = FirebaseAuth.instance.currentUser!.uid;

  Future <void> completedTask() async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref("UsersData/$uid/tasks/${widget.taskKey}");
      await ref.update({
        "isDone" : true
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berhasil Menyelesaikan Urusan', style: GoogleFonts.plusJakartaSans(
              textStyle: TextStyle(
                  color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal
              )
          ),), backgroundColor: Colors.green,)
      );

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()), (
          Route<dynamic> route) => false);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi Kesalahan: $e', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal
        )),), backgroundColor: Colors.red,),
      );
    }
  }

  Future<void> deleteTask() async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref("UsersData/$uid/tasks/${widget.taskKey}");
      await ref.remove();

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berhasil Menghapus Urusan', style: GoogleFonts.plusJakartaSans(
              textStyle: TextStyle(
                  color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal
              )
          ),), backgroundColor: Colors.green,)
      );

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()), (
          Route<dynamic> route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi Kesalahan: $e', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal
        )),), backgroundColor: Colors.red,),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios, color: Colors.black,)),
        title: Text('Detail Urusan', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600
        )),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8,),
              Text('Urusan', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600
              )),),
              SizedBox(height: 8,),
              TextFormField(
                initialValue: widget.task['taskName'],
                style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                  color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600
                )),
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 16.0, // Padding konsisten agar teks di dalam field tetap rapi
                  ),
                  helperText: ' ',
                ),
              ),
              SizedBox(height: 8,),
              Text('Prioritas Urusan', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                  color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600
              )),),
              SizedBox(height: 8,),
              TextFormField(
                initialValue: widget.task['taskPriority'],
                style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                    color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600
                )),
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 16.0, // Padding konsisten agar teks di dalam field tetap rapi
                  ),
                  helperText: ' ',
                ),
              ),
              SizedBox(height: 8,),
              Text('Deskripsi Urusan', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                  color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600
              )),),
              SizedBox(height: 8,),
              TextFormField(
                initialValue: widget.task['taskDescription'],
                maxLines: 5,
                style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                    color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600
                )),
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 16.0, // Padding konsisten agar teks di dalam field tetap rapi
                  ),
                  helperText: ' ',
                ),
              ),
              SizedBox(height: 8,),
              Text('Waktu Urusan', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                  color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600
              )),),
              SizedBox(height: 8,),
              TextFormField(
                initialValue: widget.task['taskTime'],
                style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                    color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600
                )),
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 16.0, // Padding konsisten agar teks di dalam field tetap rapi
                  ),
                  helperText: ' ',
                ),
              ),
              SizedBox(height: 8,),

              if (widget.task['isDone'] == false) ...[
                SizedBox(
                  height: 52, width: double.infinity,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(AppColor.blueColor),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)
                              )
                          )
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditTaskPage(task: widget.task, taskKey: widget.taskKey)));
                      }, child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit, color: Colors.white,),
                      SizedBox(width: 8,),
                      Text('Ubah Detail Urusan', style: GoogleFonts.plusJakartaSans(
                          textStyle: TextStyle(
                              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold
                          )
                      ),)
                    ],
                  )),
                ),
                SizedBox(height: 12,),
                SizedBox(
                  height: 52, width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(AppColor.greenColor),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    onPressed: () {
                      completedTask();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Selesaikan Urusan',
                          style: GoogleFonts.plusJakartaSans(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12,),
              ],
              SizedBox(
                height: 52, width: double.infinity,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)
                            )
                        )
                    ),
                    onPressed: (){
                      deleteTask();
                    }, child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete, color: Colors.white,),
                    SizedBox(width: 8,),
                    Text('Hapus Urusan', style: GoogleFonts.plusJakartaSans(
                        textStyle: TextStyle(
                            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold
                        )
                    ),)
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
