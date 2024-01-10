import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelligent_pharmacy/shared/utils/icons.dart';
import 'package:intelligent_pharmacy/user/features/chatbot/view/widgets/chat_bubble.dart';
import 'package:intelligent_pharmacy/user/features/chatbot/view/widgets/typing_indicator.dart';

import '../../../../shared/styles/colors.dart';
import '../manager/chatbot_cubit.dart';

class ChatBotPage extends StatelessWidget {
  const ChatBotPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey();

    return BlocProvider(
      create: (context) => ChatbotCubit(),
      child: BlocConsumer<ChatbotCubit, ChatbotState>(
        listener: (context, state) {},
        builder: (context, state) {
          ChatbotCubit cubit = ChatbotCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageIcon(
                    AssetImage(IconsAsset.chatBotLogo),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text("Chatbot"),
                  SizedBox(
                    width: 2,
                  ),
                ],
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: cubit.scrollController,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final message = cubit.reversedChatMessage[index];
                      return ChatBubble(
                        text: message.text,
                        isUser: message.isUser,
                      );
                    },
                    itemCount: cubit.reversedChatMessage.length,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: TypingIndicator(
                    showIndicator: cubit.isTyping,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: Form(
                      key: formKey,
                      child: TextFormField(
                        controller: cubit.messageController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Send Message",
                          hintStyle: Theme.of(context).textTheme.bodyMedium,
                          suffixIcon: IconButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                cubit.sendMessage(cubit.messageController.text);
                                cubit.messageController.clear();
                              }
                            },
                            icon: const Icon(Icons.send),
                          ),
                          errorStyle: const TextStyle(height: 0),
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: ColorsAsset.mainColor,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: ColorsAsset.mainColor,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: ColorsAsset.mainColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
