import 'package:dude_music/Screens/Playlist/playlistdetails.dart';
import 'package:dude_music/Widgets/playlist_show_dialoge.dart';
import 'package:dude_music/db/model/dbfunctions.dart';
import 'package:dude_music/db/model/model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../style.dart';

List<Songs> playlistsongs = [];
List<Playlists> listPlaylist = [];

class ScreenPlaylist extends StatefulWidget {
  const ScreenPlaylist({super.key});

  @override
  State<ScreenPlaylist> createState() => _ScreenPlaylistState();
}

class _ScreenPlaylistState extends State<ScreenPlaylist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          topPlaylist(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      playlistShowdialogue(context, plylists: playlistsongs);
                    },
                    icon: const Icon(
                      Icons.add_box_outlined,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: Hive.box<Playlists>('playlists').listenable(),
                builder: (context, Box<Playlists> allplaylists, child) {
                  listPlaylist = allplaylists.values.toList();
                  if (listPlaylist.isEmpty) {
                    return const Center(child: Text("No playlists created ..",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),));
                  }
                  return GridView.builder(
                    itemCount: allplaylists.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                        mainAxisSpacing: 25,
                        crossAxisSpacing: 20),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell( onTap:() =>  Navigator.of(context).push(MaterialPageRoute(builder:((context) => PlaylistDetails(playlistName: listPlaylist[index].playlistname, allPlaylistSongs: listPlaylist[index].playlistsonglist, index: index,)))),child: playlistBox(index: index));
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }

  Future addPlaylist() {
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
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Playlist name',
                        style: TextStyle(color: Colors.black, fontSize: 23),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Enter playlist name',
                        style: TextStyle(color: Colors.black,fontSize: 24),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 113, 107, 107),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                
                          style: const TextStyle(color: Colors.black),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              border: InputBorder.none),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
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
                              onPressed: () {},
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
}

Padding topPlaylist() {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset("assets/IMAGES/Playlist.png"),
      ],
    ),
  );
}

Container playlistBox({required int index,}) {
  return Container(
     height:140,
    // width: 80,
    // color: Colors.yellow,
    child: Column(
      children: [
        Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              "assets/IMAGES/playlistlogo.png",
              height: 80,
            ),
          ),
          Positioned(
            right: -10,
            top: -5,
            child:
                Popupbutton1(playlistindex: index, playlistlist: listPlaylist[index].playlistsonglist), 
          )
        ]),
        Text(listPlaylist[index].playlistname, style: const TextStyle()),
      ],
    ),
  );
}

class Popupbutton1 extends StatefulWidget {
  Popupbutton1(
      {super.key, required this.playlistindex, required this.playlistlist});
  int playlistindex;
  List<Songs> playlistlist;

  @override
  State<Popupbutton1> createState() => _Popupbutton1State();
}

class _Popupbutton1State extends State<Popupbutton1> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: const Color.fromARGB(255, 255, 255, 255),
      icon: const Icon(
        Icons.more_vert_outlined,
        color: Colors.black,
      ),
      itemBuilder: (item) => <PopupMenuItem<int>>[
        const PopupMenuItem(
          value: 0,
          child: SizedBox(
            width: 80,
            child: Text(
              'Rename',
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
        ),
        const PopupMenuItem(
          value: 1,
          child: SizedBox(
            width: 80,
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
        )
      ],
      onSelected: (selectedindex) async {
        switch (selectedindex) {
          case 0:
            showdialogue1(context, textController, widget.playlistindex,
                widget.playlistlist);
            break;
          case 1:
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  content: const Text(
                    'Do you want to delete ?',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        playlistsBox.deleteAt(widget.playlistindex);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('No',
                          style: TextStyle(color: Colors.black, fontSize: 15)),
                    ),
                  ],
                );
              },
            );
        }
      },
    );
  }
}

Future showdialogue1(BuildContext context, TextEditingController textController,
    int index, List<Songs> playlistslist) {
  textController =
      TextEditingController(text: playlistsBox.values.toList()[index].playlistname);
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
                      'Edit Playlist name',
                      style: showdialogtext1,
                    ),
                  const SizedBox(height: 10),
                    // const Text(
                    //   'Enter playlist name',
                    //   style: showdialogtext2,
                    // ),
                    //SizedBox(height: 20),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 222, 218, 218),
                          borderRadius: BorderRadius.circular(10)),
                      child: Form(
                        key: formkey,
                        child: TextFormField(
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              border: InputBorder.none),
                          controller: textController,
                          validator: (value) =>
                              (value!.trim().isEmpty) ? 'Name Required' : null,
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
                              //List<Playlists> playlists = [];
                              if (textController.text.trim() ==
                                  playlistsBox.values.toList()[index].playlistname) {
                                Navigator.pop(context);
                              } else if(formkey.currentState!.validate()){
                                playlistsBox.putAt(
                                  index,
                                  Playlists(playlistname: textController.text, playlistsonglist:playlistsBox.values.toList()[index].playlistsonglist)
                                );
                                Navigator.pop(context);
                                // Navigator.pop(context);

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
