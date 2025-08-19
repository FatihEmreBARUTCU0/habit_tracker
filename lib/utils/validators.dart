String? validateHabitName(String? value) {
  final t = (value ?? '').trim();
  if (t.isEmpty) return 'İsim boş olamaz.';
  return null;
}
