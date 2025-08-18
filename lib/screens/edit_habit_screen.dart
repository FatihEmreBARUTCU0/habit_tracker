import 'package:flutter/material.dart';

class EditHabitScreen extends StatefulWidget {
  const EditHabitScreen({super.key, required this.initialName});

  final String initialName;

  @override
  State<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  late final TextEditingController _controller;
  late final String _original;
  final _formKey = GlobalKey<FormState>();
  bool _canSave = false;

  @override
  void initState() {
    super.initState();
    _original = widget.initialName.trim();
    _controller = TextEditingController(text: widget.initialName);
    _canSave = _validator(_controller.text) == null;
  }

  String? _validator(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return 'İsim boş olamaz.';
    if (t == _original) return 'Bir değişiklik yapmadın.';
    return null;
  }

  void _onChanged(String v) {
    final ok = _validator(v) == null;
    if (ok != _canSave) setState(() => _canSave = ok);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final t = _controller.text.trim();
    Navigator.pop(context, t); // yeni adı geri döndür
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alışkanlık Düzenle')),
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
                decoration: const InputDecoration(
                  labelText: 'Yeni ad',
                  hintText: 'Örn: Sabah su içmek',
                  border: OutlineInputBorder(),
                ),
                validator: _validator,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canSave ? _save : null,
                  child: const Text('Güncelle'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
