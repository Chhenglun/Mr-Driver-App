class BookModel {
  int? id;
  String? title;
  String? images;
  bool? recommendation;
  bool? newest;
  String? authorName;
  String? type;
  String? language;
  String? description;
  String? price;

  BookModel({
    this.id,
    this.title,
    this.images,
    this.recommendation,
    this.newest,
    this.authorName,
    this.type,
    this.language,
    this.description,
    this.price,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) => BookModel(
    id: json['id'],
    title: json['title'],
    images: json['images'],
    recommendation: json['recommendation'],
    newest: json['newest'],
    authorName: json['author_name'],
    type: json['type'],
    language: json['language'],
    description: json['description'],
    price: json['price'],
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'images': images,
    'recommendation': recommendation,
    'newest': newest,
    'author_name': authorName,
    'type': type,
    'language': language,
    'description': description,
    'price': price,
  };
}