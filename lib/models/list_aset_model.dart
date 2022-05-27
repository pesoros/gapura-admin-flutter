// ignore_for_file: non_constant_identifier_names

class ListAsetModel {
  double id;
  String title;
  String image;
  String file;
  String imagelink;
  String filelink;

  ListAsetModel({
    this.id,
    this.title,
    this.image,
    this.file,
    this.imagelink,
    this.filelink,
  });

  ListAsetModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    file = json['file'];
    imagelink = json['imagelink'];
    filelink = json['filelink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['file'] = this.file;
    data['imagelink'] = this.imagelink;
    data['filelink'] = this.filelink;

    return data;
  }
}
