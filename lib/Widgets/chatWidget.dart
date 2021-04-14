import 'package:flutter/material.dart';
import 'package:garage/Backend/backend.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ChatWidget extends StatelessWidget {
  final String chatId;
  final List<dynamic> messages;
  final String sender ;
  final _current = FirebaseAuth.instance.currentUser;
  ChatWidget(this.chatId, this.messages , this.sender);

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return messages.length == 0
        ? Scaffold(
            appBar: AppBar(
              elevation: 0,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Start a conversation with our administrator',
                  style: _theme.textTheme.bodyText2,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: TextFormField(
                          controller: _controller,
                          decoration: InputDecoration(
                              hintText: 'Enter your message ....',
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.5)),
                        ),
                      )),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Chat()
                              .sendMessage(
                                  chat: Chat(
                                    content: _controller.text,
                                    sender: sender == '' ?_current!.email!:'kamanzishema@gmail.com',
                                  ),
                                  id: chatId)
                              .then((_) {
                            _controller.clear();
                          }).catchError((e) {
                            print('this is where the error is $e');
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment:
                            messages[index]['sender'] == _current!.email
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color:messages[index]['sender'] == _current!.email ?Colors.grey.withOpacity(0.3):Colors.orangeAccent.withOpacity(0.9),
                                  borderRadius: BorderRadius.only(
                                    topRight:messages[index]['sender'] == _current!.email ? Radius.circular(0): Radius.circular(10),
                                    topLeft:messages[index]['sender'] == _current!.email  ? Radius.circular(10): Radius.circular(0),
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  )),
                              padding: const EdgeInsets.all(10),
                              width: 200,
                              child: Text(
                                messages[index]['content'],
                                style: _theme.textTheme.headline6!
                                    .copyWith(fontSize: 15),
                              )),
                          Text(DateFormat.MMMEd()
                              .format(DateTime.parse(messages[index]['id'])))
                        ],
                      ),
                    );
                  },
                  itemCount: messages.length,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: TextFormField(
                        controller: _controller,
                        decoration: InputDecoration(
                            hintText: 'Enter your message ....',
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.5)),
                      ),
                    )),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        Chat()
                            .sendMessage(
                                chat: Chat(
                                  content: _controller.text,
                                  sender: sender == ''?_current!.email!:sender,
                                ),
                                id: chatId)
                            .then((_) {
                          _controller.clear();
                        }).catchError((e) {
                          print('this is where the error is $e');
                        });
                      },
                    ),
                  ],
                ),
              )
            ],
          );
  }
}
