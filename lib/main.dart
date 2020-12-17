import 'package:artcraftliving/artwork/my_soldartwork.dart';
import 'package:artcraftliving/artwork/purchased_artwork.dart';
import 'package:artcraftliving/artwork/sold_artwork.dart';
import 'package:artcraftliving/artwork/users.artwork.dart';
import 'package:artcraftliving/constant.dart';
import 'package:artcraftliving/home_screen.dart';
import 'package:artcraftliving/login/buyapp.dart';
import 'package:artcraftliving/login/forgot_password.dart';
import 'package:artcraftliving/login/login.dart';
import 'package:artcraftliving/login/sign_up.dart';
import 'package:artcraftliving/menu/collected_points.dart';
import 'package:artcraftliving/menu/exhibition.dart';
import 'package:artcraftliving/menu/help/help.dart';
import 'package:artcraftliving/menu/my_supporters.dart';
import 'package:artcraftliving/menu/mysold.dart';
import 'package:artcraftliving/menu/payment.dart';
import 'package:artcraftliving/menu/purchased.dart';
import 'package:artcraftliving/menu/communitysales.dart';
import 'package:artcraftliving/profiles/after_signup.dart';
import 'package:artcraftliving/profiles/edit_Profile.dart';
import 'package:artcraftliving/profiles/my_gallery.dart';
import 'package:artcraftliving/profiles/user_profile.dart';
import 'package:artcraftliving/splash_screen.dart';
import 'package:artcraftliving/uplaod_art.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import 'login/inapp_payment_provider.dart';

void main() {
  InAppPurchaseConnection.enablePendingPurchases();
  runApp(ArtCraftLiving());
}

class ArtCraftLiving extends StatelessWidget {
  const ArtCraftLiving({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=> ProviderModel(),
      child: MaterialApp(
        title: 'main page',
        routes: <String, WidgetBuilder>{
          SPLASH_SCREEN: (BuildContext context) => SplashScreen(),
          LOGIN: (BuildContext context) => LogIn(),
          SIGN_UP: (BuildContext context) => SignUp(),
          FORGOT_PASSWORD: (BuildContext context) => ForgotPassword(),
          AFTER_SIGNUP: (BuildContext context) => AfterSignup(),
          EDIT_PROFILE: (BuildContext context) => EditProfile(),
          UPLOAD_ART: (BuildContext context) => UploadArt(),
          HOME_SCREEN: (BuildContext context) => Home(),
          MY_GALLERY: (BuildContext context) => MyGallery(),
          USER_PROFILE: (BuildContext context) => UserProfile(),
          USERS_ARTWORK: (BuildContext context) => UsersArtwork(),
          COMMUNITY_SALE: (BuildContext context) => CommunitySales(),
          SOLD_ARTWORKS: (BuildContext context) => SoldArtwork(),
          MYSOLD: (BuildContext context) => MySold(),
          MYSOLD_ARTWORKS: (BuildContext context) => MySoldArtwork(),
          PURCHASED: (BuildContext context) => Purchased(),
          PURCHASED_ARTWORKS: (BuildContext context) => PurchasedArtwork(),
          MY_SUPPOERTERS: (BuildContext context) => MySupporters(),
          COLLECTED_POINTS: (BuildContext context) => CollectedPoints(),
          PAYMENT: (BuildContext context) => Payment(),
          BUYAPP: (BuildContext context) => BuyApp(),
          HELP: (BuildContext context) => Help(),
          EXHIBITION: (BuildContext context) => Exhibition(),
        },
        initialRoute: SPLASH_SCREEN,
      ),
    );
  }
}
