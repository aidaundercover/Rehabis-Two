class Relative {
  final String number;
  final String relation;

  Relative({required this.number, required this.relation});

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'number': this.number,
      'relaion' : this.relation
    } as Map<String, dynamic>;
  }
}
