import 'package:flutter/material.dart';
import 'package:habit_tracker/utils/validators.dart';
import 'package:habit_tracker/l10n/generated/app_localizations.dart';




class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  bool _canSave = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _canSave = false;
  }

  void _onChanged(String v) {
     final ok = validateHabitName(context)(v) == null;
    if (ok != _canSave) setState(() => _canSave = ok);
    // Sadece butonu aktif/pasif etmek için; asıl kontrol _validator'da.
  }

  void _save() {
    final name = _controller.text.trim();
    if (!_formKey.currentState!.validate()) return; // Hata varsa kaydetme
    Navigator.pop(context, name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l.addHabitTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                textInputAction: TextInputAction.done,
                onChanged: _onChanged,
                onFieldSubmitted: (_) => _save(),
                decoration: InputDecoration(
                  labelText: l.habitName,
                  hintText: l.habitNameHint,
                  border: const OutlineInputBorder(),
                ),
                validator: validateHabitName(context),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canSave ? _save : null,
                  child: Text(l.save),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
