import 'package:flutter/material.dart';
import 'package:habit_tracker/utils/validators.dart';
import 'package:habit_tracker/l10n/generated/app_localizations.dart';




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
  _canSave = _isValidInitial(_controller.text);

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted) return;
    final ok = _validator(_controller.text) == null;
    if (ok != _canSave) setState(() => _canSave = ok);
  });
}


// initState için hızlı, context'siz kontrol
bool _isValidInitial(String? v) {
  final t = (v ?? '').trim();
  return t.isNotEmpty && t != _original;
}


String? _validator(String? v) {
  final base = validateHabitName(v);      // Boş olamaz vb.
  if (base != null) return base;

  final t = (v ?? '').trim();
  if (t == _original) {
    // Bu satır artık sadece build sırasında çalışır → güvenli
    return AppLocalizations.of(context)!.noChange;
  }
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
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l.editHabitTitle)),
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
                decoration:  InputDecoration(
                  labelText: l.newName,
                  hintText:  l.newNameHint,
                  border: const OutlineInputBorder(),
                ),
                validator: _validator,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canSave ? _save : null,
                  child: Text(l.updated),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
