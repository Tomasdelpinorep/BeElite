class Sort {
  bool? empty;
  bool? sorted;
  bool? unsorted;

  Sort({this.empty, this.sorted, this.unsorted});

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
        empty: json['empty'] as bool?,
        sorted: json['sorted'] as bool?,
        unsorted: json['unsorted'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'empty': empty,
        'sorted': sorted,
        'unsorted': unsorted,
      };
}
