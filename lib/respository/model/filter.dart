class FilterManager {
  String? name;
  bool? isActive;
  int? minPrice;
  int? maxPrice;
  FilterManager({
    this.name,
    required this.isActive,
    this.minPrice,
    this.maxPrice,
  });

  FilterManager.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    return data;
  }
}
