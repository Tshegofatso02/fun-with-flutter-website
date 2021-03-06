import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/blog/blog_bloc.dart';
import '../../../application/filtered_blog/filtered_blog_bloc.dart';
import '../../../application/page/page_bloc.dart';
import '../../common/header.dart';
import '../../common/info_bar.dart';
import '../../common/loading_indicator.dart';
import '../../core/constants.dart';
import '../blog/widgets/blog_posts.dart';
import 'widgets/sliver_course_header.dart';

class HomePage extends StatelessWidget {
  const HomePage();
  @override
  Widget build(BuildContext context) {
    // TODO create a standard implementation for all of the different pages with scrolling
    // and make it in such a way that the entire page is withing the scrollable area
    return BlocBuilder<BlogBloc, BlogState>(
      builder: (BuildContext context, BlogState state) {
        return Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Scrollbar(
                child: CustomScrollView(
                  slivers: <Widget>[
                    const SliverSafeArea(
                      sliver: SliverHeader(label: 'Courses'),
                    ),
                    const SliverCourseHeader(),
                    const SliverHeader(label: 'Recent blog posts'),
                    _displayPosts(
                      context,
                      state,
                      constraints.maxWidth > kMaxBodyWidth
                          ? kMaxBodyWidth
                          : constraints.maxWidth,
                      constraints.maxWidth,
                    ),
                    const SliverBottomInfoBar()
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _displayPosts(
      BuildContext context, BlogState state, double width, double maxWidth) {
    return state.map(
      initial: (_) {
        return const SliverLoadingIndicator();
      },
      loading: (_) {
        return const SliverLoadingIndicator();
      },
      error: (_) {
        return const NoBlogPosts();
      },
      loaded: (state) {
        return BlogPosts(
          blog: state.blog,
          width: width,
          maxWidth: maxWidth,
          limitNumberOfBlogs: 2,
          onTagTap: (tag) {
            context.bloc<FilterBlogBloc>().add(
                  FilterBlogEvent.filterByTag(tag),
                );
            context.bloc<PageBloc>().add(
                  const PageEvent.update(PageState.blog),
                );
          },
        );
      },
    );
  }
}
