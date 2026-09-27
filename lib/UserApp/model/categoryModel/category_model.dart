class CategoryModel {
  final String id;
  final String name;
  final String image;
  final String category;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map["id"]?.toString() ?? "",
      name: map["name"]?.toString() ?? "",
      image: map["image"]?.toString() ?? "",
      category: map["category"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "image": image,
      "category": category,
    };
  }
}