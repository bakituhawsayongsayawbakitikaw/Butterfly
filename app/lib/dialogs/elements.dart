import 'package:butterfly/cubits/current_index.dart';
import 'package:butterfly/handlers/handler.dart';
import 'package:butterfly/visualizer/event.dart';
import 'package:butterfly_api/butterfly_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../renderers/renderer.dart';
import '../bloc/document_bloc.dart';

class ElementsDialog extends StatelessWidget {
  final Offset position;
  final List<Renderer<PadElement>> renderers;

  const ElementsDialog(
      {super.key, required this.position, required this.renderers});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Flexible(
          child: ListView(
        shrinkWrap: true,
        children: [
          MenuItemButton(
            leadingIcon:
                const PhosphorIcon(PhosphorIconsLight.arrowsOutCardinal),
            onPressed: () {
              Navigator.of(context).pop(true);
              context
                  .read<CurrentIndexCubit>()
                  .fetchHandler<HandHandler>()
                  ?.move(context.read<DocumentBloc>(), renderers, false);
            },
            child: Text(AppLocalizations.of(context).move),
          ),
          MenuItemButton(
            leadingIcon: const PhosphorIcon(PhosphorIconsLight.arrowsClockwise),
            onPressed: () {
              Navigator.of(context).pop(true);
              context
                  .read<CurrentIndexCubit>()
                  .fetchHandler<HandHandler>()
                  ?.setRotate(context.read<DocumentBloc>());
            },
            child: Text(AppLocalizations.of(context).rotate),
          ),
          MenuItemButton(
            leadingIcon: const PhosphorIcon(PhosphorIconsLight.copy),
            onPressed: () {
              Navigator.of(context).pop(true);
              context
                  .read<CurrentIndexCubit>()
                  .fetchHandler<HandHandler>()
                  ?.move(
                      context.read<DocumentBloc>(),
                      renderers
                          .map((e) => Renderer.fromInstance(e.element))
                          .toList(),
                      true);
            },
            child: Text(AppLocalizations.of(context).duplicate),
          ),
          MenuItemButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              context.read<DocumentBloc>().add(
                  ElementsRemoved(renderers.map((r) => r.element).toList()));
            },
            leadingIcon: const PhosphorIcon(PhosphorIconsLight.trash),
            child: Text(AppLocalizations.of(context).delete),
          ),
          SubmenuButton(
            leadingIcon: const Icon(PhosphorIconsLight.layout),
            menuStyle: const MenuStyle(alignment: Alignment.centerRight),
            menuChildren: Arrangement.values
                .map((e) => MenuItemButton(
                      leadingIcon: Icon(e.icon(PhosphorIconsStyle.light)),
                      child: Text(e.getLocalizedName(context)),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        context.read<DocumentBloc>().add(ElementsArranged(
                            renderers.map((r) => r.element).toList(), e));
                      },
                    ))
                .toList(),
            child: Text(AppLocalizations.of(context).arrange),
          ),
          MenuItemButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              if (renderers.isEmpty) return;
              final cubit = context.read<CurrentIndexCubit>();
              cubit.changeSelection(renderers.first);
              renderers.sublist(1).forEach((r) => cubit.insertSelection(r));
            },
            leadingIcon: const PhosphorIcon(PhosphorIconsLight.faders),
            child: Text(AppLocalizations.of(context).properties),
          ),
        ],
      ))
    ]);
  }
}
