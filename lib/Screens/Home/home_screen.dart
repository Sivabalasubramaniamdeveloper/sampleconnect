import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sampleconnect/Screens/UserList/Presentation/user_list.dart';
import '../../Components/CommonFunctions.dart';
import '../../Utils/Constants/ColorConstants.dart';
import '../../Utils/Constants/CustomWidgets.dart';
import '../../Utils/Constants/TextStyle.dart';
import '../../Utils/Theme/ThemeCubit/ThemeCubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  static final List<Widget> _widgetOptions = <Widget>[
    Text(
      'Home',
      style: TextStyleClass.textSize18Bold(),
    ),
    ChatList(),
    Text(
      'Search',
      style: TextStyleClass.textSize18Bold(),
    ),
    Text(
      'Profile',
      style: TextStyleClass.textSize18Bold(),
    ),
  ];
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    analytics.setAnalyticsCollectionEnabled(true);
     analytics.logEvent(
      name: 'screen_view',
      parameters: {
        'screen_name': 'HomePage',
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 50.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24.r,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.r))),
                        child: ClipOval(
                          child: CachedNetworkImage(
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              imageUrl: auth.currentUser!.photoURL!),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomWidgets().getGreetingWidget(context),
                        Text(
                          "${capitalizeFirstLetter(auth.currentUser!.displayName!)} 👋",
                          style: TextStyleClass.textSize18Bold(
                              color: Theme.of(context).hintColor),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    context
                        .read<ThemeCubit>()
                        .setMode(!context.read<ThemeCubit>().isDarkTheme);
                  },
                  child: Icon(
                    !context.read<ThemeCubit>().isDarkTheme
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    size: 30.sp,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                GestureDetector(
                  onTap: () {
                    CustomWidgets().showLogoutDialog(context);
                  },
                  child: Icon(Icons.logout,
                      color: Theme.of(context).hintColor, size: 28.sp),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Expanded(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0).r,
        child: Container(
          decoration: BoxDecoration(
            // color: Colors.white,
            color: Theme.of(context).primaryColor,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black12,
              )
            ],
          ),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            backgroundColor: Theme.of(context).primaryColor,
            activeColor: Theme.of(context).hintColor,
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15).r,
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: Theme.of(context).cardColor,
            color: Colors.black,
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.chat,
                text: 'Chats',
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                icon: Icons.person_off,
                text: 'Profile',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
