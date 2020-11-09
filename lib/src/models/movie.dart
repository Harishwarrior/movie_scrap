class Movie {
  final String name;
  final String normalizedName;
  final List magnets;

  Movie({
    this.name,
    this.normalizedName,
    this.magnets,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        name: json['name'] as String,
        normalizedName: json['normalized_name'] as String,
        magnets: json['magnets'] as List);
  }
}
