class Language {
  final int id;
  final String name;
  final String code;
  Language({this.name,this.id,this.code});

  factory Language.fromJson(Map<String, dynamic> json){
    return Language(
      id: json['language_id'],
      name: json['name'],
      code: json['code']
    );
  }
}