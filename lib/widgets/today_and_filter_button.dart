import 'package:doable_todo_list_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TodayAndFilterButton extends StatelessWidget {
  final VoidCallback? onFilterTapped;

  const TodayAndFilterButton({super.key, this.onFilterTapped});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Today",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        GestureDetector(
          onTap: onFilterTapped ??
              () {
                // Show filter options in a modal bottom sheet
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Filter Tasks",
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(height: 15),
                        ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: const Text("Today's Tasks"),
                          onTap: () {
                            Navigator.pop(context);
                            // Implement filtering logic in HomePage
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.calendar_month),
                          title: const Text("All Tasks"),
                          onTap: () {
                            Navigator.pop(context);
                            // Implement filtering logic in HomePage
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.04,
            width: MediaQuery.of(context).size.width * 0.25,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            decoration: BoxDecoration(
                color: blackColor,
                borderRadius:
                    BorderRadius.circular(MediaQuery.of(context).size.width)),
            child: Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Filter",
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(color: whiteColor, fontSize: 13),
                    ),
                    SvgPicture.asset("assets/filter.svg",
                        height: MediaQuery.of(context).size.height * 0.014),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
