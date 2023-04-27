
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
part 'model.g.dart';

 @HiveType(typeId: 0)

class Songs {
  @HiveField(0)
  final String songname;
  @HiveField(1)
  final String artist;
   @HiveField(2)
  final int duration;
   @HiveField(3)
  final String songurl;
   @HiveField(4)
  final int id;
   @HiveField(5)
   int count;
  Songs({required this.songname,required this.artist,required this.duration,required this.songurl,required this.id,required this.count});
}
class SongBox{
 static  Box<Songs>? _box;
 static Box<Songs> getInstance(){
    return _box ??= Hive.box('Songs');
  }
}
@HiveType(typeId: 1)
class Favsongs{
  @HiveField(0)
  final String songname;
  @HiveField(1)
  final String artist;
  @HiveField(2)
  final String duration;
  @HiveField(3)
  final String songurl;
  @HiveField(4)
  final String id;
  Favsongs({required this.songname,required this.artist,required this.duration,required this.songurl,required this.id});
}
class FavsongBox{
  static Box<Favsongs>? _box;
  static Box<Favsongs> getInstance(){
    return _box ??= Hive.box('favsongs');
  }
}
@HiveType(typeId: 2)
class Playlists{
  @HiveField(0)
  final String playlistname;
  @HiveField(1)
  final List<Songs> playlistsonglist;
  Playlists({required this.playlistname,required this.playlistsonglist});
}
@HiveType(typeId: 3)
class RecentSongs{
   @HiveField(0)
  final String songname;
  @HiveField(1)
  final String artist;
  @HiveField(2)
  final String duration;
  @HiveField(3)
  final String songurl;
  @HiveField(4)
  final String id;
  RecentSongs({required this.songname,required this.artist,required this.duration,required this.songurl,required this.id, });
}