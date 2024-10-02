//import 'package:etrucknet_app/view/assigned_loads_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Screens/OperatoreRemoto/camion_disponibili.dart';
import 'package:flutter_etrucknet_new/States/home_screen.dart';
import 'package:flutter_etrucknet_new/Utils/routes_name.dart';
//import 'package:etrucknet_app/view/carrier_signup/first_step_signup_view.dart';
//import 'package:etrucknet_app/view/carrier_signup/second_step_signup_view.dart';
//import 'package:etrucknet_app/view/carrier_signup/third_step_signup_view.dart';
/*import 'package:etrucknet_app/view/edit_path_view.dart';
import 'package:etrucknet_app/view/empty_carrier_views/unexisting_page.dart';
import 'package:etrucknet_app/view/faq_view.dart';
import 'package:etrucknet_app/view/filter_transport.dart';
import 'package:etrucknet_app/view/forgot_password_view.dart';
import 'package:etrucknet_app/view/invoice_details_view.dart';
import 'package:etrucknet_app/view/invoices_view.dart';
import 'package:etrucknet_app/view/loads_view.dart';
import 'package:etrucknet_app/view/payment_done_view.dart';
import 'package:etrucknet_app/view/payment_view.dart';
import 'package:etrucknet_app/view/pdf_transport_view.dart';
import 'package:etrucknet_app/view/search_loads_filter_view.dart';
import 'package:etrucknet_app/view/services_carrier_view.dart';
import 'package:etrucknet_app/view/video_guide_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_etrucknet_new/Utils/routes_name.dart';
import 'package:flutter_etrucknet_new/States/home_screen.dart';
import 'package:flutter_etrucknet_new/view/login_view.dart';
import 'package:etrucknet_app/view/onboarding_view.dart';
import 'package:etrucknet_app/view/profile_screen.dart';*/
import 'package:flutter_etrucknet_new/Widgets/sign_in_form.dart';
//import 'package:etrucknet/view/splash_view.dart';

//import '../../res/components/distance_filter.dart';
//import '../../view/available_trucks_list_view.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    /// Splash screen
    switch (settings.name) {
      /*case RoutesName.splash:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SplashView(),
        );

      /// Onboarding screen
      case RoutesName.onboarding:
        return MaterialPageRoute(
          builder: (BuildContext context) => const OnboardingView(),
        );

      /// First step registration
      case RoutesName.second_step:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SecondStepSignupCarrier(),
        );

      /// First step registration
      case RoutesName.third_step:
        return MaterialPageRoute(
          builder: (BuildContext context) => const ThirdStepSignupCarrier(),
        );

      /// First step registration
      case RoutesName.first_step:
        return MaterialPageRoute(
          builder: (BuildContext context) => const FirstStepSignupCarrier(),
        );*/

      /// Home screen
      case RoutesName.home:
        return MaterialPageRoute(
          builder: (BuildContext context) => const HomeScreen(),
        );

      /// Login screen
      case RoutesName.login:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SignInForm(),
        );

      /// Register screen
      /*case RoutesName.signup:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SignUpView(),
        );

      /// Forgot password page
      case RoutesName.forgot_password:
        return MaterialPageRoute(
          builder: (BuildContext context) => const ForgotPasswordView(),
        );

      /// Profile screen
      case RoutesName.profile:
        return MaterialPageRoute(
          builder: (BuildContext context) => const ProfileView(),
        );*/

      /// Trucks available list screen
      case RoutesName.trucks_available_list:
        return MaterialPageRoute(
          builder: (BuildContext context) => const AvailableTrucksScreen(),
        );

      /// Trucks available add screen
      /*case RoutesName.add_available_truck:
        return MaterialPageRoute(
          builder: (BuildContext context) => const AvailableTruckAddView(),
        );

      /// Distance filter search camion
      case RoutesName.distance_filter:
        return MaterialPageRoute(
          builder: (BuildContext context) => const DistanceFilter(),
        );
      case RoutesName.invoice_list:
        return MaterialPageRoute(
          builder: (BuildContext context) => const InvoicesView(),
        );*/

      /// Invoice detail page
      /*case RoutesName.invoice:
        return MaterialPageRoute(
          builder: (BuildContext context) => const InvoiceDetailsView(),
        );

      /// Loads list page
      case RoutesName.carichi:
        return MaterialPageRoute(
          builder: (BuildContext context) => const LoadsView(),
        );

      /// Load detail page
      case RoutesName.load_detail:
        return MaterialPageRoute(
          builder: (BuildContext context) => LoadDetailsView(),
        );
      case RoutesName.payment_done:
        return MaterialPageRoute(
          builder: (BuildContext context) => const PaymentDoneView(),
        );

      /// Payment page
      case RoutesName.payment:
        return MaterialPageRoute(
          builder: (BuildContext context) => const PaymentView(),
        );

      ///
      case RoutesName.transport:
        return MaterialPageRoute(
          builder: (BuildContext context) => const AssignedLoadsView(),
        );
      case RoutesName.pdf_transport:
        return MaterialPageRoute(
          builder: (BuildContext context) => const PdFTransportView(),
        );
      case RoutesName.edit_path:
        return MaterialPageRoute(
          builder: (BuildContext context) => const EditPathView(),
        );

      /// Services page
      case RoutesName.services:
        return MaterialPageRoute(
          builder: (BuildContext context) => const ServicesView(),
        );

      /// Filter loads page
      case RoutesName.filter_loads:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SearchLoads(),
        );

      /// FAQ page
      case RoutesName.faq:
        return MaterialPageRoute(
          builder: (BuildContext context) => const FaqView(),
        );

      /// Video guide page
      case RoutesName.video:
        return MaterialPageRoute(
          builder: (BuildContext context) => const VideoGuideView(),
        );

      /// Filter loads page
      case RoutesName.filter_transport:
        return MaterialPageRoute(
          builder: (BuildContext context) => const FilterTransport(),
        );*/
      default:
        return MaterialPageRoute(builder: (_) {
          return const HomeScreen();
        });
    }
  }
}
