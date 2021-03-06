import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'application/auth/auth_bloc.dart';
import 'application/blog/blog_bloc.dart';
import 'application/contact_form/bloc/contact_form_bloc.dart';
import 'application/filtered_blog/filtered_blog_bloc.dart';
import 'application/page/page_bloc.dart';
import 'application/simple_bloc_delegate.dart';
import 'application/theme/bloc/theme_bloc.dart';
import 'injection.dart';
import 'presentation/core/app_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  String env = Environment.prod;
  assert(() {
    env = Environment.dev;
    BlocSupervisor.delegate = SimpleBlocDelegate();
    return true;
  }());
  configureInjection(env);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) =>
            getIt<AuthBloc>()..add(const AuthEvent.authCheckRequested()),
      ),
      BlocProvider<BlogBloc>(
        create: (context) => getIt<BlogBloc>()..add(const BlogEvent.fetch()),
      ),
      BlocProvider<ContactFormBloc>(
        create: (context) => getIt<ContactFormBloc>(),
      ),
      BlocProvider<FilterBlogBloc>(
        create: (context) {
          return FilterBlogBloc(blogBloc: BlocProvider.of<BlogBloc>(context));
        },
        // lazy loading off to allow blog filtering before
        // the blog page has been accessed
        lazy: false,
      ),
      BlocProvider<PageBloc>(create: (context) {
        return PageBloc();
      }),
      BlocProvider<ThemeBloc>(create: (context) {
        return ThemeBloc();
      }),
    ],
    child: const MyApp(),
  ));
}
