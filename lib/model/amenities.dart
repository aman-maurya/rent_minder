class AmenitiesModel {
  late final String name;
  late final String img;
  //late final String ?userId;

  AmenitiesModel({required this.name, required this.img});
  AmenitiesModel.fromJson(Map<String,dynamic> json){
    name = json['name'];
    img = json['img'];
    //userId = json['userId'];
  }

  Map<String, dynamic> toJson(){
    final data = <String, dynamic>{};
    data['name'] = name;
    data['img'] = 'assets/icons/$img';
    //data['userId'] = userId;
    return data;
  }
}