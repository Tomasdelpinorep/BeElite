class Block {
  String? movement;
  bool? isCompleted;

  Block({this.movement, this.isCompleted});

  factory Block.fromJson(Map<String, dynamic> json) => Block(
        movement: json['movement'] as String?,
        isCompleted: json['isCompleted'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'movement': movement,
        'isCompleted': isCompleted,
      };
}
