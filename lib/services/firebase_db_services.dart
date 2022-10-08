import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FirebaseDBServices {
  var db = FirebaseFirestore.instance;

  Future addCatatan({
    String? judulCatatan,
    String? isiCatatan,
  }) async {
    var box = await Hive.openBox('userBox');
    var uid = box.get('uid');
    var email = box.get('email');
    var catatan = {
      "judul": judulCatatan,
      "isi": isiCatatan,
      "createdBy": email,
      "uidUser": uid,
    };

    var hasil = await db.collection('catatan').doc().set(catatan).then((value) {
      print('$judulCatatan berhasil dibuat');
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCatatan(String uid) async {
    var hasil =
        await db.collection('catatan').where('uidUser', isEqualTo: uid).get();
    return hasil;
  }

  Future editCatatan({
    required String uidCatatan,
    String? judulCatatan,
    String? isiCatatan,
  }) async {
    var catatan = {
      "judul": judulCatatan,
      "isi": isiCatatan,
    };
    var hasil = await db
        .collection('catatan')
        .doc(uidCatatan)
        .update(catatan)
        .then((value) {
      print('$judulCatatan berhasil di update');
    });
  }

  deleteCatatan(uidCatatan) async {
    var hasil = await db.collection('catatan').doc(uidCatatan).delete();
  }
}
