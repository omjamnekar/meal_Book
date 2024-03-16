class Combo {
  final int id;
  final String items;
  final num rate; // Use num instead of double for rate
  final String description;
  final String category;
  final bool available;
  final num likes; // Use num instead of double for likes
  final num overallRating; // Use num instead of double for overallRating
  final String image;
  final bool isVeg;
  final String type;
  final bool isPopular;
  final List<String> ingredients;

  Combo({
    required this.id,
    required this.items,
    required this.rate,
    required this.description,
    required this.category,
    required this.available,
    required this.likes,
    required this.overallRating,
    required this.image,
    required this.isPopular,
    required this.isVeg,
    required this.type,
    required this.ingredients,
  });

  factory Combo.fromMap(Map<dynamic, dynamic> map) {
    return Combo(
      id: map['ID'],
      items: map['ITEMS'],
      rate: map['RATE'],
      description: map['DESCRIPTION'],
      category: map['CATEGORY'],
      available: map['AVAILABLE'],
      likes: map['LIKES'],
      isPopular: map['POPULAR'],
      overallRating: map['OVERALL_RATING'],
      image: map['IMAGE'],
      isVeg: map['IS_VEG'],
      type: map['TYPE'],
      ingredients: List<String>.from(map['INGREDIENTS']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'ITEMS': items,
      'RATE': rate,
      'DESCRIPTION': description,
      'CATEGORY': category,
      'AVAILABLE': available,
      'LIKES': likes,
      'OVERALL_RATING': overallRating,
      'IMAGE': image,
      'IS_VEG': isVeg,
      'POPULAR': isPopular,
      'TYPE': type,
      'INGREDIENTS': ingredients,
    };
  }
}
