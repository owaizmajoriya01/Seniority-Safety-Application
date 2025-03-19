import 'package:flutter/material.dart';

import '../../my_theme.dart';

class ViewUsersScreen extends StatefulWidget {
  const ViewUsersScreen({Key? key}) : super(key: key);

  @override
  State<ViewUsersScreen> createState() => _ViewUsersScreenState();
}

class _ViewUsersScreenState extends State<ViewUsersScreen>
    with SingleTickerProviderStateMixin {
  var list = List.generate(200, (index) => "Element $index");
  late final _tabController = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.offWhiteScaffoldColor,
      body: SizedBox.expand(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("All Users",
                style: TextStyle(
                    fontSize: 16,
                    color: MyTheme.secondaryAccentColor,
                    fontWeight: FontWeight.w800)),
            TabBar(
                indicator: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    // Creates border
                    color: MyTheme.secondaryColor),
                unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    color: MyTheme.secondaryAccentColor,
                    fontWeight: FontWeight.w500),
                labelStyle: const TextStyle(
                    fontSize: 14,
                    color: MyTheme.white,
                    fontWeight: FontWeight.w600),
                unselectedLabelColor: MyTheme.secondaryAccentColor,
                controller: _tabController,
                padding: const EdgeInsets.only(top: 16, bottom: 20),
                labelPadding: const EdgeInsets.only(top: 8, bottom: 8),
                onTap: (int index) {},
                tabs: const [Text("Elders"), Text("Caretakers")]),
            Expanded(
              child: TabBarView(controller: _tabController, children: [
                /*MyListView(
                  list: list,
                ),
                MyListView(list: list),
              */
              ]),
            ),
          ],
        ),
      )),
    );
  }
}
/*
class MyListView extends StatelessWidget {
  const MyListView({
    Key? key,
    required this.list,
  }) : super(key: key);

  final List<MyUser> list;

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: NoDataFound(
            message: "No Users found",
          ));
    } else {
      return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) =>
              UserItem(user: list[index], isCaretaker: true));
    }
  }
}*/
