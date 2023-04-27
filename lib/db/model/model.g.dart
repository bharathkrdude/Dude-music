// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongsAdapter extends TypeAdapter<Songs> {
  @override
  final int typeId = 0;

  @override
  Songs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Songs(
      songname: fields[0] as String,
      artist: fields[1] as String,
      duration: fields[2] as int,
      songurl: fields[3] as String,
      id: fields[4] as int,
      count: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Songs obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.songname)
      ..writeByte(1)
      ..write(obj.artist)
      ..writeByte(2)
      ..write(obj.duration)
      ..writeByte(3)
      ..write(obj.songurl)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FavsongsAdapter extends TypeAdapter<Favsongs> {
  @override
  final int typeId = 1;

  @override
  Favsongs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Favsongs(
      songname: fields[0] as String,
      artist: fields[1] as String,
      duration: fields[2] as String,
      songurl: fields[3] as String,
      id: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Favsongs obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.songname)
      ..writeByte(1)
      ..write(obj.artist)
      ..writeByte(2)
      ..write(obj.duration)
      ..writeByte(3)
      ..write(obj.songurl)
      ..writeByte(4)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavsongsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlaylistsAdapter extends TypeAdapter<Playlists> {
  @override
  final int typeId = 2;

  @override
  Playlists read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Playlists(
      playlistname: fields[0] as String,
      playlistsonglist: (fields[1] as List).cast<Songs>(),
    );
  }

  @override
  void write(BinaryWriter writer, Playlists obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.playlistname)
      ..writeByte(1)
      ..write(obj.playlistsonglist);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecentSongsAdapter extends TypeAdapter<RecentSongs> {
  @override
  final int typeId = 3;

  @override
  RecentSongs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentSongs(
      songname: fields[0] as String,
      artist: fields[1] as String,
      duration: fields[2] as String,
      songurl: fields[3] as String,
      id: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RecentSongs obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.songname)
      ..writeByte(1)
      ..write(obj.artist)
      ..writeByte(2)
      ..write(obj.duration)
      ..writeByte(3)
      ..write(obj.songurl)
      ..writeByte(4)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentSongsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
