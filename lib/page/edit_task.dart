import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urusanku_app/config/app_color.dart';
import 'package:urusanku_app/page/home_page.dart';

class EditTaskPage extends StatefulWidget {
  final Map task;
  final String taskKey;
  const EditTaskPage({super.key, required this.task, required this.taskKey});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _urusanController = TextEditingController(text: widget.task['taskName']);
  late TextEditingController _deskripsiController = TextEditingController(text: widget.task['taskDescription']);
  late TextEditingController _waktuController = TextEditingController(text: widget.task['taskTime']);
  late String _selectedPriority = widget.task['taskPriority'];

  final List<String> _itemsPriority = ['Prioritas Rendah', 'Prioritas Sedang', 'Prioritas Tinggi'];

  late String initialTaskName = widget.task['taskName'];
  late String initialTaskDescription = widget.task['taskDescription'];
  late String initialTaskTime = widget.task['taskTime'];
  late String initialPriority = widget.task['taskPriority'];


  Future <void> updateTask() async {
    if (_formKey.currentState!.validate()) {
      if (_urusanController.text == initialTaskName && _selectedPriority == initialPriority && _deskripsiController.text == initialTaskDescription && _waktuController.text == initialTaskTime) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak Ada Yang Diubah', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal
          )),), backgroundColor: Colors.red,),
        );
      } else {
        try {
          DatabaseReference ref = FirebaseDatabase.instance.ref("UsersData/$uid/tasks/${widget.taskKey}");
          await ref.update({
            "taskName": _urusanController.text.trim(),
            "taskPriority": _selectedPriority,
            "taskDescription": _deskripsiController.text.trim(),
            "taskTime": _waktuController.text.trim(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Berhasil Mengubah Detail Urusan', style: GoogleFonts.plusJakartaSans(
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi Kesalahan', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal
        )),), backgroundColor: Colors.red,),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 24,)),
        title: Text('Ubah Detail Urusan', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600
        )),),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottom),
          child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                        key: _formKey, 
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Urusan', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600
                            )),),
                            SizedBox(height: 8,),
                            TextFormField(
                              controller: _urusanController,
                              style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                                  color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600
                              )),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.black, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColor.blueColor, width: 1),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.red, width: 1),
                                ),
                                errorStyle: TextStyle(
                                  height: 1, // Mengurangi tinggi pesan error
                                  color: Colors.red,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 14.0,
                                  horizontal: 16.0, // Padding konsisten agar teks di dalam field tetap rapi
                                ),
                                helperText: ' ',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Urusan tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 8,),
                            Text('Prioritas Urusan', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600
                            )),),
                            SizedBox(height: 8,),
                            Container(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: AppColor.grayColor, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: AppColor.blueColor, width: 1),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.red, width: 1),
                                    ),
                                    errorStyle: TextStyle(
                                      height: 1, // Mengurangi tinggi pesan error
                                      color: Colors.red,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 14.0,
                                      horizontal: 16.0, // Padding konsisten agar teks di dalam field tetap rapi
                                    ),
                                    helperText: ' ',
                                  ),
                                  isExpanded: true,
                                  style: GoogleFonts.plusJakartaSans(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  dropdownColor: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  value: _selectedPriority,
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Prioritas Tidak Boleh Kosong';
                                    }
                                    return null;
                                  },
                                  items: _itemsPriority.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedPriority = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 8,),
                            Text('Deskripsi Urusan', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600
                            )),),
                            SizedBox(height: 8,),
                            TextFormField(
                              maxLines: 5,
                              controller: _deskripsiController,
                              style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                                  color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600
                              )),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.black, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColor.blueColor, width: 1),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.red, width: 1),
                                ),
                                errorStyle: TextStyle(
                                  height: 1, // Mengurangi tinggi pesan error
                                  color: Colors.red,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 14.0,
                                  horizontal: 16.0, // Padding konsisten agar teks di dalam field tetap rapi
                                ),
                                helperText: ' ',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Deskripsi Urusan tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 8,),
                            Text('Waktu Urusan', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600
                            )),),
                            SizedBox(height: 8,),
                            TextFormField(
                              controller: _waktuController,
                              style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
                                  color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600
                              )),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.black, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColor.blueColor, width: 1),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.red, width: 1),
                                ),
                                errorStyle: TextStyle(
                                  height: 1, // Mengurangi tinggi pesan error
                                  color: Colors.red,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 14.0,
                                  horizontal: 16.0, // Padding konsisten agar teks di dalam field tetap rapi
                                ),
                                helperText: ' ',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Waktu Urusan tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 8,),
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
                                    updateTask();
                                  }, child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.save, color: Colors.white,),
                                  SizedBox(width: 8,),
                                  Text('Simpan Perubahan', style: GoogleFonts.plusJakartaSans(
                                      textStyle: TextStyle(
                                          color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold
                                      )
                                  ),)
                                ],
                              )),
                            ),
                          ],
                        )
                    )
                  ],
                ),
              )
          ),),
      ),
    );
  }
}
