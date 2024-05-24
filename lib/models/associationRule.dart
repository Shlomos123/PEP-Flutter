class AssociationRule {
  final List<String> antecedent;
  final List<String> consequent;
  final double confidence;
  final double lift;
  final double support;

  AssociationRule({
    required this.antecedent,
    required this.consequent,
    required this.confidence,
    required this.lift,
    required this.support,
  });

  factory AssociationRule.fromJson(Map<String, dynamic> json) {
    return AssociationRule(
      antecedent: List<String>.from(json['antecedent']),
      consequent: List<String>.from(json['consequent']),
      confidence: json['confidence'],
      lift: json['lift'],
      support: json['support'],
    );
  }
}
