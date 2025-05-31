import 'package:blog_app/core/common/cubits/connection/app_connection_cubit.dart';
import 'package:blog_app/core/common/cubits/user/app_user_cubit.dart';
import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppUserCubit, AppUserState>(
      listener: (BuildContext context, AppUserState state) {},
      builder: (context, state) {
        final user = (state as AppUserLoggedIn).user;
        return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
            actions: [
              BlocBuilder<AppConnectionCubit, AppConnectionState>(
                builder: (context, state) {
                  final isConnected = state is AppConnectionConnected;
                  return IconButton(
                    onPressed: null,
                    icon: const Icon(Icons.logout),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16).copyWith(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 24,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Hi',
                    style: Theme.of(context).textTheme.titleLarge,
                    children: [
                      TextSpan(
                        text: user.name.isEmpty ? '' : ', ${user.name}',
                        style: TextStyle(
                          color: AppPallet.gradient2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Email: ',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: AppPallet.grey),
                    children: [
                      TextSpan(
                        text: user.email,
                        style: TextStyle(
                          color: AppPallet.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'ID: ',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: AppPallet.grey),
                    children: [
                      TextSpan(
                        text: user.id,
                        style: TextStyle(
                          color: AppPallet.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
