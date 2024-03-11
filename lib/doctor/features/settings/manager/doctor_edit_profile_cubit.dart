import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intelligent_pharmacy/shared/utils/constants.dart';
import 'package:intelligent_pharmacy/shared/utils/image_helper/image_helper.dart';

import '../../../../models/doctor_model.dart';
import '../../../../shared/network/cache_keys.dart';
import '../../../../shared/network/cached_preference.dart';

part 'doctor_edit_profile_state.dart';

class DoctorEditProfileCubit extends Cubit<DoctorEditProfileState> {
  DoctorEditProfileCubit() : super(DoctorEditProfileInitial());

  static DoctorEditProfileCubit get(context) => BlocProvider.of(context);
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  String specialityValue = 'other';

  void initialize() {
    nameController.text = Constants.doctorModel!.name!;
    phoneController.text = Constants.doctorModel!.phoneNo!;
    addressController.text = Constants.doctorModel!.address!;
    bioController.text = Constants.doctorModel!.bio!;
    specialityValue =
        Constants.doctorModel!.speciality!.isEmpty ? 'other' : Constants.doctorModel!.speciality!;
  }

  File? imageFile;

  void changeImage(context) async {
    final files = await ImageHelper().pickImage();
    if (files.isNotEmpty) {
      final croppedImage = await ImageHelper().crop(file: files.first!, cropStyle: CropStyle.circle);
      if (croppedImage != null) {
        imageFile = File(croppedImage.path);
      } else {
        imageFile = File(files.first!.path);
      }
    }
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Change profile picture ?'),
              content: FittedBox(
                child: CircleAvatar(
                  radius: 80,
                  foregroundImage: FileImage(imageFile!),
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceAround,
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                MaterialButton(
                  onPressed: () {
                    emit(ChangeProfilePicture());
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            ));
  }

  void changeSpeciality(value) {
    specialityValue = value;
    emit(ChangeSpeciality());
  }

  void saveData(context) {
    if (imageFile != null) {
      FirebaseStorage.instance
          .ref()
          .child('doctors/${Constants.doctorModel!.id}')
          .putFile(imageFile!)
          .then((p0) {
        p0.ref.getDownloadURL().then((value) {
          FirebaseFirestore.instance
              .collection('doctors')
              .doc(Constants.doctorModel!.id)
              .update({'image': value});
        });
      });
    }
    var doctorDoc = FirebaseFirestore.instance.collection('doctors').doc(Constants.doctorModel!.id);
    doctorDoc.update({
      'name': nameController.text,
      'phoneNo': phoneController.text,
      'address': {
        'text': addressController.text,
        'addressLongitude': '',
        'addressLatitude': '',
      },
      'bio': bioController.text,
      'speciality': specialityValue,
    }).then((value) {
      doctorDoc.get().then((value) async {
        await CacheHelper.removeData(key: CacheKeys.userId);
        await cachingUser(value, CacheKeys.doctorId);
        Constants.doctorModel =
            DoctorModel.fromCache(jsonDecode(await CacheHelper.getData(key: CacheKeys.doctorId)));
        initialize();
        Phoenix.rebirth(context);
      });
    });
  }

  Future<void> cachingUser(DocumentSnapshot<Map<String, dynamic>> value, String userType) async {
    List<String> map = [];
    dynamic array = value.data().toString().split('');
    await array.removeAt(0);
    await array.removeLast();
    array = await array.join('');
    array = await array.split(',');
    await CacheHelper.setData(key: userType, value: (handlingMapResponse(array, map).toString()));
  }

  String handlingMapResponse(List array, List<String> map) {
    for (int i = 0; i < array.length; i++) {
      dynamic key = array[i].toString().trim().split(" ")[0].split("");
      var value = array[i].toString().trim().split(" ").last == array[i].toString().trim().split(" ")[0]
          ? ''
          : array[i].toString().trim().split(":").last.trim();
      debugPrint(array[i].toString().trim().split(":").last.trim());
      key.removeLast();
      key = key.join();
      map.add('"$key" : "$value",');
    }
    String last = (map.last.split('')..removeLast()).join();
    map
      ..removeLast()
      ..insert(map.length, last);
    debugPrint(map.join());
    return '{${map.join().toString()}}';
  }
}
