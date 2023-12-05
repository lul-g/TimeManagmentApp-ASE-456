import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:time_app/src/services/FirebaseUtils.dart';
import 'package:time_app/src/utils/constants.dart';
import 'package:time_app/src/utils/custom_toast.dart';
import 'package:time_app/src/widgets/add_record.dart';
import 'package:time_app/src/widgets/calendar.dart';

class CustomAppBar extends StatelessWidget {
  final Function onSearch;
  final Function updateRecordList;
  final Function initRecordsList;

  final TextEditingController _searchController = TextEditingController();

  CustomAppBar({
    super.key,
    required this.onSearch,
    required this.updateRecordList,
    required this.initRecordsList,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth <= 600;
    return Center(
      child: Container(
        width: isMobile ? MediaQuery.of(context).size.width : 600,
        height: isMobile ? 200 : 80.0,
        padding: const EdgeInsets.all(20),
        child: isMobile
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Logo(),
                      PopupMenu(
                        initRecordsList: initRecordsList,
                        updateRecordList: updateRecordList,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SearchBar(controller: _searchController, onSearch: onSearch),
                ],
              )
            : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Logo(),
                SearchBar(controller: _searchController, onSearch: onSearch),
                PopupMenu(
                  initRecordsList: initRecordsList,
                  updateRecordList: updateRecordList,
                )
              ]),
      ),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({super.key});
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth <= 600;
    return isMobile
        ? const Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage('lib/assets/images/jack.png'),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Welcome, Jack',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: KThemeColors.primary),
              ),
            ],
          )
        : const Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage('lib/assets/images/jack.png'),
              ),
            ],
          );
  }
}

class SearchBar extends StatelessWidget {
  final Function onSearch;
  final TextEditingController controller;

  const SearchBar({required this.controller, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth <= 600;
    return Container(
      height: isMobile ? 35 : 50,
      padding: isMobile
          ? const EdgeInsets.fromLTRB(15, 0, 0, 3)
          : const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: KThemeColors.primary,
        borderRadius: isMobile
            ? KThemeBorderRadius.borderRadius_xs
            : KThemeBorderRadius.borderRadius_sm,
        border: KThemeBorders.border_md,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: Colors.white60,
          ),
          const SizedBox(width: 8.0),
          Container(
            width: isMobile ? 200 : 400,
            alignment: Alignment.center,
            child: TextField(
              controller: controller,
              style: const TextStyle(
                color: KThemeColors.secondary,
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  onSearch(value);
                } else {
                  ToastManager.showWarning('⚠ Please enter a keyword');
                }
              },
              decoration: const InputDecoration(
                hintText: "Search Records",
                hintStyle: TextStyle(
                  color: Colors.white60,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
        ],
      ),
    );
  }
}

class PopupMenu extends StatelessWidget {
  final Function initRecordsList;
  final Function updateRecordList;

  const PopupMenu({
    required this.initRecordsList,
    required this.updateRecordList,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const FaIcon(
        FontAwesomeIcons.ellipsisV,
        color: KThemeColors.primary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: KThemeBorderRadius.borderRadius_sm,
      ),
      surfaceTintColor: KThemeColors.secondary,
      color: KThemeColors.primary,
      itemBuilder: (BuildContext context) {
        return {'Reset', 'Add', 'Calendar'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Row(
              children: [
                choice == 'Add'
                    ? const FaIcon(FontAwesomeIcons.plusCircle)
                    : choice == 'Calendar'
                        ? const FaIcon(FontAwesomeIcons.calendarDay)
                        : const FaIcon(FontAwesomeIcons.refresh),
                const SizedBox(width: 8),
                Text(choice),
              ],
            ),
          );
        }).toList();
      },
      onSelected: (String choice) {
        if (choice == 'Add') {
          _showAddRecordModal(context);
        } else if (choice == 'Calendar') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: KThemeBorderRadius.borderRadius_md,
                ),
                child: CalendarTableView(updateRecordList: updateRecordList),
              );
            },
          );
        } else if (choice == "Reset") {
          initRecordsList();
          FirebaseUtils.fetchRecordsByDate(DateTime.now());
        }
      },
    );
  }
}

void _showAddRecordModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return AddRecord();
    },
  );
}
