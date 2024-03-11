import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelligent_pharmacy/models/message_model.dart';
import 'package:intelligent_pharmacy/shared/utils/constants.dart';
import 'package:intl/intl.dart';

part 'doctor_chat_state.dart';

class DoctorChatCubit extends Cubit<DoctorChatState> {
  DoctorChatCubit() : super(DoctorChatInitial());

  static DoctorChatCubit get(context) => BlocProvider.of(context);
  final TextEditingController messageController = TextEditingController();
  List<MessageModel> chatMessage = [];
  List<MessageModel> reversedChatMessage = [];
  ScrollController scrollController = ScrollController();

  void sendMessage(MessageModel message) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(message.senderId)
        .collection('chat')
        .doc(message.receiverId)
        .set({
      'lastMessage': message.text,
      'lastMessageDate': DateFormat('hh:mm').format(DateTime.now()),
    });
    var inUserDocument = FirebaseFirestore.instance
        .collection('users')
        .doc(message.senderId)
        .collection('chat')
        .doc(message.receiverId)
        .collection('messages')
        .doc();
    inUserDocument.set(message.toMap(inUserDocument.id));
    FirebaseFirestore.instance
        .collection('doctors')
        .doc(message.receiverId)
        .collection('chat')
        .doc(message.senderId)
        .set({
      'lastMessage': message.text,
      'name': Constants.userModel!.name,
      'image': Constants.userModel!.image,
      'lastMessageDate': DateFormat('hh:mm').format(DateTime.now()),
      'id': Constants.userModel!.id,
    });
    var inDoctorDocument = FirebaseFirestore.instance
        .collection('doctors')
        .doc(message.receiverId)
        .collection('chat')
        .doc(message.senderId)
        .collection('messages')
        .doc();
    inDoctorDocument.set(message.toMap(inDoctorDocument.id));
  }

  void getMessages(doctorId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(Constants.userModel!.id)
        .collection('chat')
        .doc(doctorId)
        .collection('messages')
        .orderBy('date')
        .snapshots()
        .listen((event) {
      chatMessage.clear();
      for (var element in event.docs) {
        chatMessage.add(MessageModel.fromJson(element.data()));
        emit(GetAllMessagesSuccessfully());
      }
      reversedChatMessage = chatMessage.reversed.toList();
      scrollController.animateTo(
        double.minPositive,
        duration: const Duration(microseconds: 1),
        curve: Curves.bounceIn,
      );
    });
  }
}
