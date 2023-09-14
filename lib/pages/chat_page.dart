import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/widgetss/chat_buble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatelessWidget {
  static String id = 'ChatPage';

  final  _controller = ScrollController();

  CollectionReference messages =
      FirebaseFirestore.instance.collection(KMessagesCollections);
  TextEditingController controller =TextEditingController();

  @override
  Widget build(BuildContext context) {

     var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(KCreatedAt,descending: true).snapshots(),
      builder: (context,snapshot)
      {
        if(snapshot.hasData)
        {
          List<Message> messagesList =[];
          for(int i = 0; i<snapshot.data!.docs.length; i++)
          {
            messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: KPrimaryColor,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    KLogo,
                    height: 65,
                  ),
                  Text('Chat'),
                ],
              ),
              centerTitle: true,
            ),

            body:Column(
                children:[
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      controller: _controller,
                      itemCount: messagesList.length,
                        itemBuilder: (context,index)
                        {
                          return messagesList[index].id == email ? ChatBuble(
                            message: messagesList[index],
                          ) : ChatBubleForFriend(message: messagesList[index]);
                        }
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: controller,
                      onSubmitted: (data)
                      {
                        messages.add({KMessage :data, KCreatedAt:DateTime.now(), KID: email,
                        });
                        controller.clear();
                        _controller.animateTo(0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.fastOutSlowIn,
                        );
                      },
                      decoration: InputDecoration(
                        hintText: 'Send Message',
                        suffixIcon: Icon(
                          Icons.send,
                          color: KPrimaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: KPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
            ),
          );
        }
        else{
          return Text('Loading........');
        }
      },
    );
  }
}


