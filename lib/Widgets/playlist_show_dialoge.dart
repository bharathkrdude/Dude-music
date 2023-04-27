import 'package:flutter/material.dart';

import '../db/model/model.dart';
import 'package:dude_music/db/model/dbfunctions.dart';

TextEditingController textController = TextEditingController();
  final formkey = GlobalKey<FormState>();

Future playlistShowdialogue(BuildContext context, {required List<Songs> plylists}) {
  return showDialog(
      context: context,
      builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                height: 200,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Playlist name',
                      style: TextStyle(color: Colors.black,fontSize: 22),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Enter playlist name',
                      style: TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 222, 218, 218),
                          borderRadius: BorderRadius.circular(10)),
                      child: Form(
                        key: formkey,
                        child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              border: InputBorder.none),
                          controller: textController,
                          validator: (value) {
                            
                            List<Playlists> values = playlistsBox.values.toList();
                      
                            bool isAlreadyAdded = values
                                .where((element) =>
                                    element.playlistname == value!.trim())
                                .isNotEmpty;
                      
                            if (value!.trim() == '') {
                              return 'Name Required';
                            }
                            if (isAlreadyAdded) {
                              return 'This Name Already Exist';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 222, 218, 218),
                              borderRadius: BorderRadius.circular(50)),
                          height: 40,
                          width: 100,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              textController.clear();
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 222, 218, 218),
                              borderRadius: BorderRadius.circular(50)),
                          height: 40,
                          width: 100,
                          child: TextButton(
                            onPressed: () {
                              // if (textController.text.trim().isEmpty) {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(
                              //       backgroundColor: Colors.white,
                              //       duration: const Duration(seconds: 1),
                              //       margin: const EdgeInsets.symmetric(
                              //           horizontal: 10, vertical: 10),
                              //       behavior: SnackBarBehavior.floating,
                              //       shape: RoundedRectangleBorder(
                              //           borderRadius:
                              //               BorderRadius.circular(10)),
                              //       content: const Text('Enter Valid Name',style: TextStyle(color: Colors.black),),
                              //     ),
                              //   );
                              // }
                              if(formkey.currentState!.validate()){
                              playlistsBox.add(Playlists(
                                  playlistname: textController.text,
                                  playlistsonglist: []));
                              Navigator.pop(context);
                              }
                              textController.clear();
                            },
                            child: const Text(
                              "Save",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ));
}