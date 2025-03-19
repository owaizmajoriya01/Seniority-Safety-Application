import 'package:elderly_care/models/my_audio_notes.dart';
import 'package:elderly_care/provider/audio_note_provider.dart';
import 'package:elderly_care/screens/voice_note_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../my_theme.dart';
import '../widgets/no_data_found_widget.dart';

class AudionNoteListScreen extends StatefulWidget {
  const AudionNoteListScreen({Key? key}) : super(key: key);

  @override
  State<AudionNoteListScreen> createState() => _AudionNoteListScreenState();
}

class _AudionNoteListScreenState extends State<AudionNoteListScreen> with SingleTickerProviderStateMixin {
  //var list = List.generate(200, (index) => Pair(index % 5, "Element $index"));
  late final _tabController = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.offWhiteScaffoldColor,
      floatingActionButton: FloatingActionButton.extended(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => VoiceNoteScreen()));
      }, label: const Text("Send audio note")),
      body: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Audio notes",
                    style: TextStyle(fontSize: 16, color: MyTheme.secondaryAccentColor, fontWeight: FontWeight.w800)),
                TabBar(
                    indicator: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)), // Creates border
                        color: MyTheme.secondaryColor),
                    unselectedLabelStyle:
                    const TextStyle(fontSize: 14, color: MyTheme.secondaryAccentColor, fontWeight: FontWeight.w500),
                    labelStyle: const TextStyle(fontSize: 14, color: MyTheme.white, fontWeight: FontWeight.w600),
                    unselectedLabelColor: MyTheme.secondaryAccentColor,
                    controller: _tabController,
                    padding: const EdgeInsets.only(top: 16, bottom: 20),
                    labelPadding: const EdgeInsets.only(top: 8, bottom: 8),
                    onTap: (int index) {},
                    tabs: const [Text("Received"), Text("Sent")]),
                Expanded(
                  child: Consumer<AudioNoteProvider>(builder: (context, provider, child) {
                    return TabBarView(controller: _tabController, children: [
                      _MyListView(
                        notes: provider.receivedAudioNotes,
                      ),
                      _MyListView(notes: provider.sentAudioNotes),
                    ]);
                  }),
                ),
              ],
            ),
          )),
    );
  }
}

class _MyListView extends StatelessWidget {
  const _MyListView({Key? key, required this.notes}) : super(key: key);
  final List<MyAudioNotes> notes;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (notes.isEmpty) {
      child = SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            NoDataFound(
              message: "No Audio Note found",
            ),
          ],
        ),
      );
    } else {
      child = ListView.builder(
          itemCount: notes.length, itemBuilder: (context, index) => AudioNoteItem(audioNote: notes[index]));
    }
    return RefreshIndicator(
        onRefresh: () {
          debugPrint('Debug _AllUserScreenState.build : ');
          return context.read<AudioNoteProvider>().refresh();
        },
        child: child);
  }
}
