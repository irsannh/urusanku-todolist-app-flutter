import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urusanku_app/page/home_page.dart';

import '../config/app_color.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _urusanController = TextEditingController();
  final List<String> items = ['Prioritas Rendah', 'Prioritas Sedang', 'Prioritas Tinggi'];
  String? _selectedValue;
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();

  Future<void> addNewTask() async {
    if (_formKey.currentState!.validate()) {
      try {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        DatabaseReference ref = FirebaseDatabase.instance.ref("UsersData/$uid");
        int timestamp = DateTime.now().millisecondsSinceEpoch;

        await ref.child('tasks').child('$timestamp').set({
          "taskName": _urusanController.text.trim(),
          "taskPriority": _selectedValue,
          "taskDescription": _deskripsiController.text.trim(),
          "taskTime": _waktuController.text.trim(),
          "isDone": false,
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Berhasil Membuat Urusan Baru', style: GoogleFonts.plusJakartaSans(
                textStyle: TextStyle(
                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal
                )
            ),), backgroundColor: Colors.green,)
        );

        setState(() {
          _urusanController.clear();
          _selectedValue = null;
          _deskripsiController.clear();
          _waktuController.clear();
        });
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
        }, icon: Icon(Icons.arrow_back_ios, color: Colors.black,)),
        title: Text('Buat Urusan Baru', style: GoogleFonts.plusJakartaSans(textStyle: TextStyle(
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
                                decoration: InputDecoration(
                                  hintText: 'Ketikkan apa urusan anda di sini',
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                      textStyle: TextStyle(
                                          color: AppColor.grayColor, fontSize: 16, fontWeight: FontWeight.w600
                                      )
                                  ),
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
                                    hint: Text(
                                      'Pilih Prioritas Urusan',
                                      style: GoogleFonts.plusJakartaSans(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    value: _selectedValue,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Prioritas Tidak Boleh Kosong';
                                      }
                                      return null;
                                    },
                                    items: items.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedValue = newValue;
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
                                decoration: InputDecoration(
                                  hintText: 'Deskripsikan apa urusan anda di sini',
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                      textStyle: TextStyle(
                                          color: AppColor.grayColor, fontSize: 16, fontWeight: FontWeight.w600
                                      )
                                  ),
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
                                decoration: InputDecoration(
                                  hintText: 'Ketikkan kapan waktu urusan anda di sini',
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                      textStyle: TextStyle(
                                          color: AppColor.grayColor, fontSize: 16, fontWeight: FontWeight.w600
                                      )
                                  ),
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
                                      addNewTask();
                                    }, child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.save, color: Colors.white,),
                                    SizedBox(width: 8,),
                                    Text('Simpan', style: GoogleFonts.plusJakartaSans(
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
            ),
        ),
      ),
    );
  }
}
