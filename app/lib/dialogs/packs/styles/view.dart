import 'package:butterfly/dialogs/packs/styles/style.dart';
import 'package:butterfly_api/butterfly_api.dart';
import 'package:butterfly_api/butterfly_text.dart' as text;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../bloc/document_bloc.dart';

class StylesPackView extends StatelessWidget {
  final ButterflyPack value;
  final ValueChanged<ButterflyPack> onChanged;

  const StylesPackView({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Stack(
        children: [
          ListView(
            children: [
              const SizedBox(height: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: value.styles
                    .asMap()
                    .entries
                    .map(
                      (e) => Dismissible(
                        key: ValueKey(e.key),
                        onDismissed: (direction) {
                          onChanged(value.copyWith(
                            styles: List<text.TextStyleSheet>.from(value.styles)
                              ..removeAt(e.key),
                          ));
                        },
                        child: ListTile(
                          title: Text(e.value.name),
                          onTap: () async {
                            var styleSheet = e.value;
                            final bloc = context.read<DocumentBloc>();
                            final result = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => BlocProvider.value(
                                value: bloc,
                                child: StyleDialog(
                                  value: styleSheet,
                                  onChanged: (value) {
                                    styleSheet = value;
                                  },
                                ),
                              ),
                            );
                            if (result != true) return;
                            onChanged(value.copyWith(
                              styles:
                                  List<text.TextStyleSheet>.from(value.styles)
                                    ..[e.key] = styleSheet,
                            ));
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton.extended(
              onPressed: () async {
                var styleSheet = const text.TextStyleSheet();
                final result = await showDialog<bool>(
                  context: context,
                  builder: (context) => StyleDialog(
                    value: styleSheet,
                    onChanged: (value) {
                      styleSheet = value;
                    },
                  ),
                );
                if (result != true) return;
                onChanged(value.copyWith(
                  styles: List<text.TextStyleSheet>.from(value.styles)
                    ..add(styleSheet),
                ));
              },
              icon: const Icon(PhosphorIcons.plusLight),
              label: Text(AppLocalizations.of(context).create),
            ),
          ),
        ],
      ),
    );
  }
}