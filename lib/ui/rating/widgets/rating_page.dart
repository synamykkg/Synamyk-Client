import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synamyk/data/repositories/rating/rating_repository.dart';
import 'package:synamyk/ui/analyst/widgets/select_option_for_date.dart';
import 'package:synamyk/ui/rating/bloc/rating_bloc.dart';

class RatingPage extends StatelessWidget {
  const RatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create:
            (context) =>
                RatingBloc(GetIt.I<RatingRepository>())
                  ..add(LoadRatingsEvent()),
        child: BlocBuilder<RatingBloc, RatingState>(
          builder: (context, state) {
            if (state is RatingLoaded) {
              final selectedFilterIndex = state.filters.indexWhere(
                (filter) => filter.id == state.selectedTestId,
              );

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              state.selectedTestTitle,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SelectOptionForDate(
                            type: SelectOptionForDateType.subject,
                            value: state.selectedTestTitle,
                            items:
                                state.filters
                                    .map((filter) => filter.title)
                                    .toList(),
                            onChanged: (index) {
                              final selectedFilter = state.filters[index];
                              context.read<RatingBloc>().add(
                                SelectRatingFilterEvent(selectedFilter.id),
                              );
                            },
                            selectedIndex:
                                selectedFilterIndex >= 0
                                    ? selectedFilterIndex
                                    : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          // color: Colors.amber,
                          width: 350,
                          height: 52,
                          decoration: BoxDecoration(
                            color: _colorMethods(index),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  spacing: 10,
                                  children: [
                                    Text(
                                      '${state.users[index].rank}.',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color:
                                            (index >= 0 && index <= 2)
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                    Text(
                                      state.users[index].name,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color:
                                            (index >= 0 && index <= 2)
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  state.users[index].points.toString(),
                                  style: GoogleFonts.inter(
                                    color:
                                        (index >= 0 && index <= 2)
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      childCount: state.users.length,
                    ),
                  ),
                ],
              );
            }
            if (state is RatingError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

Color _colorMethods(int index) {
  switch (index) {
    case 0:
      return Color(0xFFFFD700);
    case 1:
      return Color(0xFFC0C0C0);
    case 2:
      return Color(0xFFD56A00);
    default:
      return Color(0xFFF6F6F6);
  }
}
