import 'package:catatan_apps/screen/login_screen.dart';
import 'package:catatan_apps/services/firebase_auth_services.dart';
import 'package:catatan_apps/services/firebase_db_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController judulController = TextEditingController();
  TextEditingController isiController = TextEditingController();
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home screen'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuthServices().logout().then((value) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(),
                  ),
                );
              });
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addCatatan(context);
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<QuerySnapshot>(
          future: getData(),
          builder: (context, snapshot) {
            //
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data?.docs.isEmpty ?? true) {
                return Text('no data');
              } else {
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context, index) {
                      var data = snapshot.data;
                      return Dismissible(
                        key: Key('${data?.docs[index]}'),
                        background: Container(color: Colors.red),
                        confirmDismiss: (_) async {
                          FirebaseDBServices()
                              .deleteCatatan(data?.docs[index].id);
                          setState(() {});
                          return true;
                        },
                        child: Card(
                          child: ListTile(
                            title: Text('${data?.docs[index]['judul']}'),
                            subtitle: Text('tanggal catatan'),
                            trailing: IconButton(
                                onPressed: () {
                                  editCatatan(
                                    context,
                                    uidCatatan: '${data?.docs[index].id}',
                                    judul: '${data?.docs[index]['judul']}',
                                    isiCatatan: '${data?.docs[index]['isi']}',
                                  );
                                },
                                icon: Icon(Icons.edit)),
                          ),
                        ),
                      );
                    });
              }
            } else {
              return Text('');
            }
          }),
    );
  }

  addCatatan(BuildContext context) async {
    var hasil = await showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        contentPadding: EdgeInsets.all(8),
        title: Text('add catatan'),
        children: [
          TextField(
            controller: judulController,
            decoration: InputDecoration(
              labelText: 'Judul',
              hintText: 'masukkan judul',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: isiController,
            decoration: InputDecoration(
              labelText: 'Isi',
              hintText: 'masukkan isi',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SimpleDialogOption(
                child: Text('simpan'),
                padding: EdgeInsets.all(4),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              SimpleDialogOption(
                child: Text('batal'),
                padding: EdgeInsets.all(4),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          ),
        ],
      ),
    );

    if (hasil == true) {
      FirebaseDBServices()
          .addCatatan(
        judulCatatan: judulController.text,
        isiCatatan: isiController.text,
      )
          .then((value) {
        setState(() {});
      });
      judulController.clear();
      isiController.clear();
    }
  }

  editCatatan(
    BuildContext context, {
    required String uidCatatan,
    String? judul,
    String? isiCatatan,
  }) async {
    judulController.text = judul ?? '';
    isiController.text = isiCatatan ?? '';
    var hasil = await showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        contentPadding: EdgeInsets.all(8),
        title: Text('edit catatan'),
        children: [
          TextField(
            controller: judulController,
            decoration: InputDecoration(
              labelText: 'Judul',
              hintText: 'masukkan judul',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: isiController,
            decoration: InputDecoration(
              labelText: 'Isi',
              hintText: 'masukkan isi',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SimpleDialogOption(
                child: Text('simpan'),
                padding: EdgeInsets.all(4),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              SimpleDialogOption(
                child: Text('batal'),
                padding: EdgeInsets.all(4),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          ),
        ],
      ),
    );
    if (hasil == true) {
      FirebaseDBServices()
          .editCatatan(
        uidCatatan: uidCatatan,
        judulCatatan: judulController.text,
        isiCatatan: isiController.text,
      )
          .then((value) {
        setState(() {});
      });
    }

    judulController.clear();
    isiController.clear();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getData() async {
    var box = Hive.box('userBox');
    var uid = box.get('uid');
    var hasil = FirebaseDBServices().getCatatan(uid);
    return hasil;
  }
}
