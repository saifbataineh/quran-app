// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class SurahModel {
  final String id;
  final String surah_name;
  final String hex_code;
  final String thumbnail_url;
  final String shaikh;
  final String surah_url;
  SurahModel({
    required this.id,
    required this.surah_name,
    required this.hex_code,
    required this.thumbnail_url,
    required this.shaikh,
    required this.surah_url,
  });



  SurahModel copyWith({
    String? id,
    String? surah_name,
    String? hex_code,
    String? thumb,
    String? shaikh,
    String? surah_url,
  }) {
    return SurahModel(
      id: id ?? this.id,
      surah_name: surah_name ?? this.surah_name,
      hex_code: hex_code ?? this.hex_code,
      thumbnail_url: thumbnail_url ,
      shaikh: shaikh ?? this.shaikh,
      surah_url: surah_url ?? this.surah_url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'surah_name': surah_name,
      'hex_code': hex_code,
      'thumbnail_url': thumbnail_url,
      'shaikh': shaikh,
      'surah_url': surah_url,
    };
  }

  factory SurahModel.fromMap(Map<String, dynamic> map) {
    return SurahModel(
      id: map['id'] ??'',
      surah_name: map['surah_name'] ??'',
      hex_code: map['hex_code'] ??'',
      thumbnail_url: map['thumbnail_url'] ??'',
      shaikh: map['shaikh'] ??'',
      surah_url: map['surah_url'] ??'',
    );
  }

  String toJson() => json.encode(toMap());

  factory SurahModel.fromJson(String source) => SurahModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SurahModel(id: $id, surah_name: $surah_name, hex_code: $hex_code, thumbnail_url: $thumbnail_url, shaikh: $shaikh, surah_url: $surah_url)';
  }

  @override
  bool operator ==(covariant SurahModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.surah_name == surah_name &&
      other.hex_code == hex_code &&
      other.thumbnail_url == thumbnail_url &&
      other.shaikh == shaikh &&
      other.surah_url == surah_url;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      surah_name.hashCode ^
      hex_code.hashCode ^
      thumbnail_url.hashCode ^
      shaikh.hashCode ^
      surah_url.hashCode;
  }
}
