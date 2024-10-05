// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class FavoriteSurahModel {
  final String? id;
  final String? surah_id;
  final String? user_id;
  FavoriteSurahModel({
    this.id,
    this.surah_id,
    this.user_id,
  });

  FavoriteSurahModel copyWith({
    String? id,
    String? surah_id,
    String? user_id,
  }) {
    return FavoriteSurahModel(
      id: id ?? this.id,
      surah_id: surah_id ?? this.surah_id,
      user_id: user_id ?? this.user_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'surah_id': surah_id,
      'user_id': user_id,
    };
  }

  factory FavoriteSurahModel.fromMap(Map<String, dynamic> map) {
    return FavoriteSurahModel(
      id: map['id'] != null ? map['id'] as String : null,
      surah_id: map['surah_id'] != null ? map['surah_id'] as String : null,
      user_id: map['user_id'] != null ? map['user_id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FavoriteSurahModel.fromJson(String source) => FavoriteSurahModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'FavoriteSurahModel(id: $id, surah_id: $surah_id, user_id: $user_id)';

  @override
  bool operator ==(covariant FavoriteSurahModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.surah_id == surah_id &&
      other.user_id == user_id;
  }

  @override
  int get hashCode => id.hashCode ^ surah_id.hashCode ^ user_id.hashCode;
}
