import 'package:blog_app/core/cubits/connection/app_connection_cubit.dart';
import 'package:blog_app/core/features/user/ui/bloc/user_cubit.dart';
import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:blog_app/core/utils/snackbar_service.dart';
import 'package:blog_app/core/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    void onLogout() {
      context.read<UserCubit>().signOut();
    }

    return BlocConsumer<UserCubit, UserState>(
      listener: (BuildContext context, UserState state) {
        if (state is UserFailure) {
          SnackBarService.showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is UserSuccess) {
          final user = state.user;

          return Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
              actions: [
                BlocBuilder<AppConnectionCubit, AppConnectionState>(
                  builder: (context, state) {
                    final isConnected = state is AppConnectionConnected;
                    return IconButton(
                      onPressed: isConnected ? onLogout : null,
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
                      text: 'Hi${user.name.isEmpty ? '' : ', '}',
                      style: Theme.of(context).textTheme.titleLarge,
                      children: [
                        TextSpan(
                          text: user.name,
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
        }

        return const Center(child: Loader());
      },
    );
  }
}
