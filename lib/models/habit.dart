class Habit {
  final String id;
  final String nama;
  final String icon;
  final String color;
  final int streak;
  final List<String> history;

  Habit({
    required this.id,
    required this.nama,
    required this.icon,
    required this.color,
    this.streak = 0,
    List<String>? history,
  }) : history = history ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'icon': icon,
      'color': color,
      'streak': streak,
      'history': history,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] ?? '',
      nama: json['nama'] ?? '',
      icon: json['icon'] ?? '✅',
      color: json['color'] ?? 'blue',
      streak: json['streak'] ?? 0,
      history: List<String>.from(json['history'] ?? []),
    );
  }

  Habit copyWith({
    String? id,
    String? nama,
    String? icon,
    String? color,
    int? streak,
    List<String>? history,
  }) {
    return Habit(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      streak: streak ?? this.streak,
      history: history ?? this.history,
    );
  }
}