class Screenshot {
  final int id;
  final String image;

  Screenshot({
    required this.id,
    required this.image,
  });


  Screenshot.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        image = json['image'];

}