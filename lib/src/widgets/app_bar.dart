import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:time_app/src/models/record.dart';
import 'package:time_app/src/services/FirebaseService.dart';
import 'package:time_app/src/utils/constants.dart';
import 'package:time_app/src/services/ToastService.dart';
import 'package:time_app/src/widgets/add_record.dart';
import 'package:time_app/src/widgets/calendar.dart';

class CustomAppBar extends StatelessWidget {
  final Function onSearch;
  final Function updateRecordList;
  final Function getRecords;

  final TextEditingController _searchController = TextEditingController();

  CustomAppBar({
    super.key,
    required this.onSearch,
    required this.updateRecordList,
    required this.getRecords,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth <= 600;
    return Center(
      child: Container(
        width: isMobile ? MediaQuery.of(context).size.width : 600,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        color: KThemeColors.secondary,
        child: isMobile
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Logo(),
                      PopupMenu(
                        getRecords: getRecords,
                        updateRecords: updateRecordList,
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
                  getRecords: getRecords,
                  updateRecords: updateRecordList,
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

  const SearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth <= 600;
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  onSearch('');
                  ToastService.showWarning(
                      '⚠ No keyword entered! Fetching all records.');
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
  final Function getRecords;
  final Function updateRecords;

  const PopupMenu({
    required this.getRecords,
    required this.updateRecords,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, int> choices = {
      'Add': 0,
      'Calendar': 1,
      'OrderBy Priority': 2,
      'App-Description': 3,
      'Reset': 4,
    };
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
        List<PopupMenuEntry<String>> menuItems = [];

        choices.entries.forEach((entry) {
          String choice = entry.key;
          int index = entry.value;
          menuItems.add(
            PopupMenuItem<String>(
              value: choice,
              child: Row(
                children: [
                  assignIcon(choice)!,
                  const SizedBox(width: 8),
                  Text(choice),
                ],
              ),
            ),
          );
          if (index == 2) {
            menuItems.add(const PopupMenuDivider());
          }
        });

        return menuItems;
      },
      onSelected: (String choice) async {
        if (choice == 'Add') {
          _showAddRecordModal(context, updateRecords, getRecords);
        } else if (choice == 'Calendar') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: KThemeBorderRadius.borderRadius_md,
                ),
                child: CalendarTableView(updateRecords: updateRecords),
              );
            },
          );
        } else if (choice == "Reset") {
          updateRecords(await FirebaseService.fetchAllRecords());
        } else if (choice == "OrderBy Priority") {
          updateRecords(Record.sortByPriority(getRecords()));
        } else if (choice == 'App-Description') {
          _showDescriptionDialog(context);
        }
      },
    );
  }
}

FaIcon? assignIcon(String option) {
  switch (option) {
    case 'Add':
      return const FaIcon(FontAwesomeIcons.plusCircle);
    case 'Calendar':
      return const FaIcon(FontAwesomeIcons.calendarDay);
    case 'Reset':
      return const FaIcon(FontAwesomeIcons.refresh);
    case 'OrderBy Priority':
      return const FaIcon(FontAwesomeIcons.sort);
    case 'App-Description':
      return const FaIcon(FontAwesomeIcons.circleInfo);
  }
  return null;
}

void _showAddRecordModal(
    BuildContext context, Function updateRecords, Function getRecords) {
  bool isMobile = MediaQuery.of(context).size.width <= 600;
  isMobile
      ? showBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return AddRecord(
              updateRecords: updateRecords,
              getRecords: getRecords,
            );
          },
        )
      : showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: KThemeBorderRadius.borderRadius_md,
              ),
              child: AddRecord(
                updateRecords: updateRecords,
                getRecords: getRecords,
              ),
            );
          },
        );
}

void _showDescriptionDialog(BuildContext context) {
  const TextStyle sentenceStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: KThemeColors.teritiary,
  );
  const TextStyle leadingStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.red, // Red color for emphasis
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: KThemeBorderRadius.borderRadius_sm,
        ),
        child: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width < 600
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.width / 3,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: KThemeColors.primary,
                borderRadius: KThemeBorderRadius.borderRadius_sm,
                border: KThemeBorders.border_md,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.circleInfo,
                        color: Colors.blueAccent,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Time Forge',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: KThemeColors.secondary,
                        ),
                      ),
                    ],
                  )),
                  SizedBox(height: 15),
                  Text(
                    'How To Search',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: KThemeColors.secondary,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Start with the filter type. The following are the supported search types and their queries:',
                    style: sentenceStyle,
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Text('1. DATE:', style: leadingStyle),
                    title: Text(
                        '- mm/dd/yyyy or mm-dd-yyyy - use to search by date',
                        style: sentenceStyle),
                  ),
                  ListTile(
                    leading: Text('2. KEY: or just the search text',
                        style: leadingStyle),
                    contentPadding: EdgeInsets.zero,
                    title:
                        Text('- use to search by title', style: sentenceStyle),
                  ),
                  ListTile(
                    leading: Text('3. RANGE:', style: leadingStyle),
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                        '- date.1 - date.2 - use to search by date range. both - and / formats supported',
                        style: sentenceStyle),
                  ),
                  ListTile(
                    leading: Text('4. #[tagName1], #[tagName2], ...',
                        style: leadingStyle),
                    contentPadding: EdgeInsets.zero,
                    title: Text('Include # before tag names to search by',
                        style: sentenceStyle),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Note: You can also use our integrated calendar to search by date. Also include the `:` incase it was not clear.',
                    style: sentenceStyle,
                  ),
                ],
              )),
        ),
      );
    },
  );
}
