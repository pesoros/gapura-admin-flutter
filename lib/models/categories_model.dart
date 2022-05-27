class CategoriesModel {
  double id;
  String title;
  String subtitle;
  String description;
  String image;
  String background;

  CategoriesModel({
    this.id,
    this.title,
    this.subtitle,
    this.description,
    this.image,
    this.background,
  });

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subtitle = json['subtitle'];
    description = json['description'];
    image = json['image'];
    background = json['background'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['description'] = this.description;
    data['image'] = this.image;
    data['background'] = this.background;

    return data;
  }
}
