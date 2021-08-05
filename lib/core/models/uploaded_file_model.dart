class UploadedFileModel {
  String path;

  UploadedFileModel({this.path});

  UploadedFileModel.fromJson(Map<String, dynamic> json) {
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    return data;
  }
}
