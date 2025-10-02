import 'package:flutter/material.dart';
import 'package:habit_tracker/core/utils/validators.dart';
import 'package:habit_tracker/l10n/generated/app_localizations.dart';
import 'package:habit_tracker/ui/widgets/neon_scaffold.dart';
import 'package:habit_tracker/ui/widgets/neon_app_bar.dart';
import 'package:habit_tracker/ui/widgets/glass_card.dart';
import 'package:habit_tracker/ui/widgets/neon_button.dart';

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
   

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final ok = _validator(_controller.text) == null;
      if (ok != _canSave) setState(() => _canSave = ok);
    });
  }



  String? _validator(String? v) {
    final base = validateHabitName(context)(v);
    if (base != null) return base;

    final t = (v ?? '').trim();
    if (t == _original) {
      return AppLocalizations.of(context).noChange;
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
    final l = AppLocalizations.of(context);

    return NeonScaffold(
      appBar: NeonAppBar(
        title: Text(l.editHabitTitle),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  controller: _controller,
                  textInputAction: TextInputAction.done,
                  onChanged: _onChanged,
                  onFieldSubmitted: (_) => _save(),
                  decoration: InputDecoration(
                    labelText: l.newName,
                    hintText: l.newNameHint,
                    border: const OutlineInputBorder(),
                  ),
                  validator: _validator,
                ),
              ),
            ),
            const SizedBox(height: 12),
            NeonButton(
              text: l.update,
              onPressed: _canSave ? _save : null,
            ),
          ],
        ),
      ),
    );
  }
}
