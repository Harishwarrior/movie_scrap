class Movie {
  final String name;
  final String normalizedName;
  final List magnets;

  Movie({
    required this.name,
    required this.normalizedName,
    required this.magnets,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        name: json['name'] as String,
        normalizedName: json['normalized_name'] as String,
        magnets: json['magnets'] as List);
  }
}
