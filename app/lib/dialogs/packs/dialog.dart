import 'dart:convert';

import 'package:butterfly/api/file_system.dart';
import 'package:butterfly/bloc/document_bloc.dart';
import 'package:butterfly/cubits/settings.dart';
import 'package:butterfly/dialogs/export.dart';
import 'package:butterfly/models/converter.dart';
import 'package:butterfly/models/pack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../widgets/header.dart';
import '../import.dart';
import 'create.dart';

class PacksDialog extends StatefulWidget {
  const PacksDialog({super.key});

  @override
  State<PacksDialog> createState() => _PacksDialogState();
}

class _PacksDialogState extends State<PacksDialog>
    with TickerProviderStateMixin {
  late final TabController _controller;
  late final PackFileSystem _fileSystem;

  @override
  initState() {
    _controller = TabController(length: 2, vsync: this);
    _fileSystem = PackFileSystem.fromPlatform(
        remote: context.read<SettingsCubit>().state.getDefaultRemote());
    super.initState();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
        child: Stack(children: [
          Column(mainAxisSize: MainAxisSize.min, children: [
            Header(
              title: Text(AppLocalizations.of(context)!.packs),
            ),
            TabBar(
              controller: _controller,
              tabs: [
                Tab(
                  icon: const Icon(PhosphorIcons.fileLight),
                  text: AppLocalizations.of(context)!.document,
                ),
                Tab(
                  icon: const Icon(PhosphorIcons.appWindowLight),
                  text: AppLocalizations.of(context)!.local,
                ),
              ],
            ),
            Flexible(
              child: BlocBuilder<DocumentBloc, DocumentState>(
                  builder: (context, state) {
                if (state is! DocumentLoadSuccess) return Container();
                final packs = state.document.packs;
                return TabBarView(controller: _controller, children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: packs.length,
                    itemBuilder: (context, index) => Dismissible(
                      key: ValueKey('localpack:${packs[index].name}'),
                      onDismissed: (direction) {
                        context
                            .read<DocumentBloc>()
                            .add(DocumentPackRemoved(packs[index].name));
                      },
                      background: Container(
                        color: Colors.red,
                      ),
                      child: ListTile(
                        title: Text(packs[index].name),
                        subtitle: Text(AppLocalizations.of(context)!
                            .packDescription(packs[index].components.length)),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              padding: EdgeInsets.zero,
                              child: ListTile(
                                leading:
                                    const Icon(PhosphorIcons.appWindowLight),
                                title:
                                    Text(AppLocalizations.of(context)!.local),
                                onTap: () async {
                                  Navigator.of(context).pop();
                                  _addPack(packs[index], true);
                                },
                              ),
                            ),
                            PopupMenuItem(
                              padding: EdgeInsets.zero,
                              child: ListTile(
                                leading:
                                    const Icon(PhosphorIcons.downloadLight),
                                title:
                                    Text(AppLocalizations.of(context)!.export),
                                onTap: () async {
                                  Navigator.of(context).pop();
                                  _exportPack(packs[index]);
                                },
                              ),
                            ),
                            PopupMenuItem(
                              padding: EdgeInsets.zero,
                              child: ListTile(
                                leading: const Icon(PhosphorIcons.trashLight),
                                title:
                                    Text(AppLocalizations.of(context)!.delete),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  context.read<DocumentBloc>().add(
                                      DocumentPackRemoved(packs[index].name));
                                },
                              ),
                            ),
                          ],
                          onSelected: (value) {},
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder<List<ButterflyPack>>(
                    future: _fileSystem.getPacks(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      if (!snapshot.hasData) {
                        return const Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        );
                      }
                      final globalPacks = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: globalPacks.length,
                        itemBuilder: (context, index) => Dismissible(
                          key:
                              ValueKey('globalpack:${globalPacks[index].name}'),
                          onDismissed: (direction) async {
                            await _fileSystem
                                .deletePack(globalPacks[index].name);
                            if (mounted) Navigator.of(context).pop();
                          },
                          background: Container(
                            color: Colors.red,
                          ),
                          child: ListTile(
                            title: Text(globalPacks[index].name),
                            subtitle: Text(AppLocalizations.of(context)!
                                .packDescription(
                                    globalPacks[index].components.length)),
                            trailing: PopupMenuButton(
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  padding: EdgeInsets.zero,
                                  child: ListTile(
                                    leading:
                                        const Icon(PhosphorIcons.fileLight),
                                    title: Text(
                                        AppLocalizations.of(context)!.document),
                                    onTap: () async {
                                      Navigator.of(context).pop();
                                      _addPack(globalPacks[index], false);
                                    },
                                  ),
                                ),
                                PopupMenuItem(
                                  padding: EdgeInsets.zero,
                                  child: ListTile(
                                    leading:
                                        const Icon(PhosphorIcons.downloadLight),
                                    title: Text(
                                        AppLocalizations.of(context)!.export),
                                    onTap: () async {
                                      Navigator.of(context).pop();
                                      _exportPack(globalPacks[index]);
                                    },
                                  ),
                                ),
                                PopupMenuItem(
                                  padding: EdgeInsets.zero,
                                  child: ListTile(
                                    leading:
                                        const Icon(PhosphorIcons.trashLight),
                                    title: Text(
                                        AppLocalizations.of(context)!.delete),
                                    onTap: () async {
                                      await _fileSystem
                                          .deletePack(globalPacks[index].name);
                                      if (mounted) Navigator.of(context).pop();
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                              onSelected: (value) {},
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ]);
              }),
            ),
          ]),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                child: const Icon(PhosphorIcons.plusLight),
                onPressed: () {
                  showModalBottomSheet<ThemeMode>(
                    context: context,
                    builder: (context) => Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: ListView(shrinkWrap: true, children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: Text(
                            AppLocalizations.of(context)!.add,
                            style: Theme.of(context).textTheme.headline5,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ListTile(
                          title: Text(AppLocalizations.of(context)!.import),
                          leading: const Icon(PhosphorIcons.arrowSquareInLight),
                          onTap: () async {
                            Navigator.of(context).pop();
                            final data = await showDialog<String>(
                              context: context,
                              builder: (context) => const ImportDialog(),
                            );
                            if (data == null) return;
                            final pack = const PackJsonConverter()
                                .fromJson(json.decode(data));
                            final success = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(AppLocalizations.of(context)!
                                        .sureImportPack),
                                    scrollable: true,
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(pack.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6),
                                        Text(AppLocalizations.of(context)!
                                            .byAuthor(pack.author)),
                                        Text(pack.description),
                                        Text(AppLocalizations.of(context)!
                                            .packDescription(
                                                pack.components.length)),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .cancel),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .import),
                                      ),
                                    ],
                                  ),
                                ) ??
                                false;
                            if (!success) return;
                            _addPack(pack);
                          },
                        ),
                        ListTile(
                          title: Text(AppLocalizations.of(context)!.create),
                          leading: const Icon(PhosphorIcons.plusCircleLight),
                          onTap: () async {
                            Navigator.of(context).pop();
                            final pack = await showDialog<ButterflyPack>(
                              context: context,
                              builder: (context) => CreatePackDialog(),
                            );
                            if (pack != null) {
                              _addPack(pack);
                            }
                          },
                        ),
                      ]),
                    ),
                  );
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> _addPack(ButterflyPack pack, [bool? global]) async {
    global ??= (_controller.index == 1);
    if (global) {
      await _fileSystem.updatePack(pack);
      setState(() {});
    } else {
      context.read<DocumentBloc>().add(DocumentPackAdded(pack));
    }
  }

  Future<void> _exportPack(ButterflyPack pack) async {
    return showDialog(
      context: context,
      builder: (context) => ExportDialog(
        data: json.encode(const PackJsonConverter().toJson(pack)),
      ),
    );
  }
}