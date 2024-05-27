class FrequentItemset {
  final List<String> items;
  final int freq;

  FrequentItemset({
    required this.items,
    required this.freq,
  });

  factory FrequentItemset.fromJson(Map<String, dynamic> json) {
    return FrequentItemset(
      items: List<String>.from(json['items']),
      freq: json['freq'],
    );
  }
}
