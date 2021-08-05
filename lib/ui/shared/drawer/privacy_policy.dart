import 'package:enna/ui/shared/widgets/app_bar.dart';
import 'package:enna/ui/shared/widgets/drawer.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../../core/services/localization/localization.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: BaseWidget<PrivacyPolicyPageModel>(
          //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
          model: PrivacyPolicyPageModel(
              api: Provider.of<Api>(context),
              auth: Provider.of(context),
              context: context),
          builder: (context, model, child) {
            return Scaffold(
              key: model.key,
              appBar: AppBarWidget(
                openDrawer: () => model.key.currentState.openDrawer(),
              ),
              drawer: AppDrawer(ctx: context),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 30),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 4,
                          ),
                          Text(
                            locale.get('Privacy Policy') ?? 'Privacy Policy',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            locale.get('Data Policy') ?? 'Data Policy',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w900),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          buildHeader("Privacy Policy"),
                          buildParagraph(
                              "Enna App recognizes that your privacy is very important, and we take it seriously. This Privacy Policy (“Privacy Policy”) describes our policies and procedures on the collection, use, disclosure, and sharing of your personal information when you use the Enna App Platform."),
                          buildParagraph(
                              "This Privacy Policy applies to activities by Enna App and its affiliates and subsidiaries (collectively “Enna App,” “we” or “us”). Capitalized terms that are not defined in this Privacy Policy have the meaning given to them in our Terms and Conditions."),
                          buildHeader("The Information We Collect"),
                          buildParagraph(
                              "We collect information directly from individuals, from third parties, and automatically through the Enna App Platform."),
                          buildHeader("Account and Profile Information: "),
                          buildParagraph(
                              "When you create an account and profile on the Enna App Platform, we collect your name, contact information, demographic information, and other information you provide, such as topics that you know about or find interesting. Your name and any other information that you choose to add to your public-facing profile will be available for viewing by the public and other users of the Enna App Platform. Once you create a profile, others will be able to see in your profile certain information about your activity on the Enna App Platform, such as the questions and answers you post, your followers and who you follow, topics of interest to you, the information you list as credentials, and your edits to your content. For more information about your choices for publicly displayed information, see the section below about Your Choices."),
                          buildHeader("Your Content: "),
                          buildParagraph(
                              "We collect the information and content that you post to the Enna App Platform, including your reviews and comments. Unless you have posted certain content anonymously, your content, date and time stamps, and all associated comments are publicly viewable on the Enna App Platform, along with your name. This also may be indexed by search engines and be republished elsewhere on the Internet in accordance with our Terms and conditions. For more information about what you can change, see the below section on Your Choices."),
                          buildHeader("Communications: "),
                          buildParagraph(
                              "When you communicate with us (via email, through the Enna App Platform, or otherwise), we may maintain a record of your communication"),
                          buildHeader(
                              "Integrated Service Provider and Linked Networks. "),
                          buildParagraph(
                              "You can connect your existing Enna App account with certain third-party networks like Twitter or Google, for example (each a “Linked Network”). You can also elect to sign in or sign up to the Enna App Platform through a Linked Network. If you elect to sign up through or connect a Linked Network, we receive certain profile and account information about you from the Linked Network. These Linked Networks may also appear in your profile, so that people can find you on these Linked Networks. The specific information provided to us by Linked Networks is determined by you and these third parties, and may vary by network. In all cases, the permissions page for the Linked Network will describe the information being shared. You should consult their respective privacy policies for information about their practices. You may elect to use information from the Linked Network to populate your profile on the Enna App Platform and help you find and follow your contacts on the Enna App Platform. For information on your choices, including how to disconnect a Linked Network from your Enna App profile, see the Your Choices section below. You may also elect to connect and make and receive payments to and from use through third-party networks (“Integrated Service Provider”); if you do so, you will be allowing us to pass to and receive from the Integrated Service Provider your login information and other user data for payment purposes."),
                          buildHeader(
                              "Automatically Collected Information About Your Activity. "),
                          buildParagraph(
                              "We use cookies, log files, pixel tags, local storage objects, and other tracking technologies to automatically collect information about your activities, such as your searches, page views, date and time of your visit, and other information about your use of the Enna App Platform. We also collect information that your computer or mobile device provides to us in connection with your use of the Enna App Platform such as your browser type, type of computer or mobile device, browser language, IP address, mobile carrier, unique device identifier, location, and requested and referring URLs. We also receive information when you view content on or otherwise interact with the Enna App Platform, even if you have not created an account. For more information, see the “Cookies, Pixels and Tracking” section below."),
                          buildHeader("Engagement : "),
                          buildParagraph(
                              "We collect browsing information – such as IP address and location, date and time stamp, user agent, Enna App cookie ID (if applicable), URL, unique advertising or content identifiers (if applicable) and time zone, and other information about user activities on the Enna App Platform, as well as on third-party sites and services that have embedded our Enna  App pixels (“Pixels”), widgets, plug-ins, buttons, or related services. See the section below about Enna App Ads and Personalization for more detailed information about how our Pixels may be used by publishers or users of our advertising services (“Ad Services”) on the Enna App Platform to enable personalization, as well as your choices related to advertising and personalization. We may also receive information about you from third parties, such as other users, partners (including ad partners), or our affiliated companies."),
                          buildHeader("How We Use Your Information"),
                          buildParagraph(
                              "We do not sell your personal information – such as your name and contact information – to third parties to use for their own marketing purposes. Enna App uses the information we collect for the following purposes:"),
                          buildHeader("•	Provide our Services. "),
                          buildParagraph(
                              "To provide you the services we offer on the Enna App Platform and make the Enna App Platform available to the public, communicate with you about your use of the Enna App Platform, respond to your inquiries, provide troubleshooting, and for other customer service purposes."),
                          buildHeader("•	Personalization. "),
                          buildParagraph(
                              "To tailor the content and information that we may send or display to you in the Enna App Platform, to suggest followers and content, to offer location customization, and personalized help and instructions, and to otherwise personalize your experiences while using the Enna App Platform."),
                          buildHeader("•	Advertising. "),
                          buildParagraph(
                              "To display interest-based advertising to you in the Enna App Platform, to improve our advertising and measurement systems so we can show you relevant ads, to pre-fill forms in ads, and to measure the effectiveness and reach of ads and services. For more information, see the Ad Services section below about Enna App Ads and Personalization."),
                          buildHeader("•	Marketing and Promotions. "),
                          buildParagraph(
                              "For marketing and promotional purposes, such as to send you news and newsletters, special offers, and promotions or to otherwise contact you about products or information we think may interest you, including information about third-party products and services."),
                          buildHeader("•	Analytics. "),
                          buildParagraph(
                              "To gather metrics to better understand how users access and use the Enna App Platform; to evaluate and improve the Enna App Platform, including the Ad Services and personalization, and to develop new products and services."),
                          buildHeader("•	Comply with Law. "),
                          buildParagraph(
                              "To comply with legal obligations, as part of our general business operations, and for other business administration purposes."),
                          buildHeader("•	Prevent Misuse. "),
                          buildParagraph(
                              "Where we believe necessary to investigate, prevent or take action regarding illegal activities, suspected fraud, situations involving potential threats to the safety of any person or violations of our Terms of Service or this Privacy Policy."),
                          buildHeader("How We Share Your Information"),
                          buildParagraph(
                              "We share information as set forth below, and where individuals have otherwise consented:"),
                          buildHeader("Service Providers. "),
                          buildParagraph(
                              "We may share your information with third-party service providers who use this information to perform services for us, such as payment processors, hosting providers, auditors, advisors, consultants, customer service and support providers, as well as those who assist us in providing the Ad Services."),
                          buildHeader("Affiliates. "),
                          buildParagraph(
                              "The information collected about you may be accessed by or shared with subsidiaries and affiliates of Enna App, Inc., whose use and disclosure of your personal information is subject to this Privacy Policy."),
                          buildHeader("Business Transfers. "),
                          buildParagraph(
                              "We may disclose or transfer information, including personal information, as part of any merger, sale, and transfer of our assets, acquisition or restructuring of all or part of our business, bankruptcy, or similar event."),
                          buildHeader("Legally Required. "),
                          buildParagraph(
                              "We may disclose your information if we are required to do so by law."),
                          buildHeader("Protection of Rights. "),
                          buildParagraph(
                              "We may disclose information where we believe it necessary to respond to claims asserted against us or, comply with legal process (e.g., subpoenas or warrants), enforce or administer our agreements and terms, for fraud prevention, risk assessment, investigation, and protect the rights, property or safety of Enna App, its users, or others."),
                          buildHeader("Your Content and Public Information"),
                          buildParagraph(
                              "Your content, including your name, profile picture, profile information, and certain associated activity information is available to other users of the Enna App Platform and may be viewed publicly. Public viewing includes availability to non-registered visitors and can occur when users share your content across other sites or services. In addition, your content may be indexed by search engines. In some cases, we may charge for access to your content and public information on the Enna App Platform. See the section below about Your Choices for information about how you may change how certain information is shared or viewed by others."),
                          buildHeader("Metrics. "),
                          buildParagraph(
                              "We may share with our advertisers or publishers aggregate statistics, metrics and other reports about the performance of their ads or content in the Enna App Platform such as the number of unique user views, demographics about the users who saw their ads or content, conversion rates, and date and time information. We do not share IP addresses or personal information, but certain features may allow you to share your personal information with advertisers on our platform if you choose to do so. We may also allow our advertisers or publishers to use Pixels on the Enna App Platform in order to collect information about the performance of their ads or content."),
                          buildHeader("Anonymized and Aggregated Data. "),
                          buildParagraph(
                              "We may share aggregated or de-identified information with third parties for research, marketing, analytics and other purposes, provided such information does not identify a particular individual."),
                          buildHeader("Cookies, Pixels and Tracking"),
                          buildParagraph(
                              "We and our third-party providers use cookies, clear GIFs/pixel tags, JavaScript, local storage, log files, and other mechanisms to automatically collect and record information about your usage and browsing activities on the Enna App Platform and across third-party sites or online services. We may combine this information with other information we collect about users. Below, we provide a brief summary these activities. For more detailed information about these mechanisms and how we collect activity information. "),
                          buildHeader("•	Cookies. "),
                          buildParagraph(
                              "These are small files with a unique identifier that are transferred to your browser through our websites. They allow us to remember users who are logged in, to understand how users navigate through and use the Enna App Platform, and to display personalized content and targeted ads (including on third-party sites and applications)."),
                          buildHeader("•	Pixels"),
                          buildParagraph(
                              "web beacons, clear GIFs. These are tiny graphics with a unique identifier, similar in function to cookies, which we use to track the online movements of users of the Enna App Platform and the web pages of users of our Ad Services, and to personalize content. We also use these in our emails to let us know when they have been opened or forwarded, so we can gauge the effectiveness of our communications."),
                          buildHeader("•	Analytics Tools. "),
                          buildParagraph(
                              "We may use internal and third-party analytics tools, including Google Analytics. The third-party analytics companies we work with may combine the information collected with other information they have independently collected from other websites and/or other online products and services. Their collection and use of information is subject to their own privacy policies."),
                          buildHeader("Do-Not-Track Signals. "),
                          buildParagraph(
                              "Please note we do not change system behaviour within the Enna App Platform in response to browser requests not to be tracked. You may, however, disable certain tracking by third parties as discussed in the Enna App Ads and Personalization section below. You may also opt out of tracking by Enna App Pixels, as described below in Enna App Ads and Personalization."),
                          buildHeader("Enna App Ads and Personalization"),
                          buildParagraph(
                              "We may display personalized content (including from third-party content publishers) and personalized ads (including sponsored content), based on information that we have collected via the Enna App Platform, and through our Pixels, widgets, and buttons embedded on third-party sites. We also may report aggregated or de-identified information about the number of users that saw a particular ad or content and related audience engagement information to users of our Ad Services and to publishers of content on the Enna App Platform. See Enna App’s Pixel Privacy Terms for more information about how our Pixels are used, and also see the Your Choices section below for information about opting out of tracking by our Pixels"),
                          buildParagraph(
                              "Advertisers who use our Ad Services may also provide us with information as part of their ad campaigns, including customer information (e.g., email addresses, phone numbers, or other contact information, demographic or interest data) in order to create custom audiences for personalizing their ad campaigns or for measuring the effectiveness of their ads; we only use this information to facilitate the particular advertiser’s campaign (including ad metrics and reporting to that advertiser); and we do not disclose this information to third parties (other than our service providers) unless required by law. We also do not disclose to the advertisers who use our Ad Services the names or contact information of their customers that were successfully reached as part of such campaigns without those customers’ consent."),
                          buildHeader("Third-Party Ads on Enna App"),
                          buildParagraph(
                              "As described in our Cookie policy, we may also work with third parties such as network advertisers to serve ads on the Enna App Platform and on third-party websites or other media (e.g., social networking platforms), such as Google Ad Sense and Facebook Audience Network. These third parties may use cookies, JavaScript, web beacons (including clear GIFs), Flash LSOs and other tracking technologies to measure the effectiveness of their ads and to personalize advertising content to you. In addition to opting out of tracking across sites by our Pixels (see Your Choices section below), you also may opt out of much interest-based advertising on third-party sites and through third-party ad networks (including Facebook Audience Network and Google AdSense). See Your Choices section below for more information about opting out of third-party ad networks."),
                          buildHeader("How We Protect Your Information"),
                          buildParagraph(
                              "The security of your information is important to us. Enna App has implemented safeguards to protect the information we collect. However, no website or Internet transmission is completely secure. We urge you to take steps to keep your personal information safe, such as choosing a strong password and keeping it private, as well as logging out of your user account, and closing your web browser when finished using the Enna App Platform on a shared or unsecured device."),
                          buildHeader("Access and Amend Your Information"),
                          buildParagraph(
                              "You may update or correct your account information at any time by logging in to your account. You may also make a number of other adjustments to settings or the display of information about you as described in more detail in the following section about Your Choices."),
                          buildHeader("Your Choices"),
                          buildParagraph(
                              "You may, of course, decline to submit information through the Enna App Platform, in which case we may not be able to provide certain services to you. You may also control the types of notifications and communications we send, limit the information shared within the Enna App Platform about you, and otherwise amend certain privacy settings. Here is some further information about some of your choices:"),
                          buildHeader("Anonymous Posts. "),
                          buildParagraph(
                              "You may post certain content anonymously, including questions and answers. In such event, your name is not displayed along with the content, and Enna App does not associate such content with your user ID and other profile data"),
                          buildHeader("Your Content. "),
                          buildParagraph(
                              "You may edit or delete the answers that you post at any time. Any questions you have posted may remain on the Enna App Platform and be edited by other users. Any deleted content will be removed from third party sites from which it has been shared via Enna App’s standard sharing features; however we have no control over deletions or changes to your content if it has been shared manually by others. When you make edits to your content, other users will be able to see the history of those edits in your profile activity and on content edit logs."),
                          buildHeader("Adult Content. "),
                          buildParagraph(
                              "In your profile’s privacy settings, you can elect whether to receive adult content."),
                          buildHeader("Emails and Communications. "),
                          buildParagraph(
                              "When you join the Enna App Platform by signing up for an account or creating a profile, as part of the service, you will receive the Enna App digest containing content that we believe may match your interests. You can manage your email and notice preferences in your account profile settings, under your Emails and Notifications settings. If you opt out of receiving emails about recommendations or other information we think may interest you, we may still send you transactional emails about your account or any services you have requested or received from us."),
                          buildParagraph(
                              "Third parties may comment on your postings within the Enna App Platform. In your profile, under your Privacy Settings, you can adjust whether to allow people to comment on your answers and posts. You can also adjust permissions about who you allow to send you messages on the Enna App Platform."),
                          buildHeader("Followers. "),
                          buildParagraph(
                              "You can block the ability of another Enna App user to follow you by selecting the setting for this in the other user’s profile. You can change whether or not you follow other users."),
                          buildHeader("Topics. "),
                          buildParagraph(
                              "You can change topics that you follow or that your profile lists as areas that you know about."),
                          buildHeader("Credentials. "),
                          buildParagraph(
                              "You can change your credentials that are displayed in your profile or in connection with a specific answer."),
                          buildHeader("Indexed Search. "),
                          buildParagraph(
                              "In your privacy settings, you can control whether your profile and name is indexed by search engines. Changes to privacy settings may only apply on a going-forward basis; for example, your name (e.g., answers and profile) that has already been indexed by search engines may remain indexed for a period of time even after you have turned off indexing, as implementing this change is outside of our control."),
                          buildHeader("Deleted or Deactivated Account. "),
                          buildParagraph(
                              "If you choose “Delete Account” in your profile’s “Privacy Settings,” then all of your content will be removed from public visibility on the Enna App Platform, and it may not be restored by us, even if you change your mind. If you choose “Deactivate Account,” then you will no longer receive any communications from us, and users will not be able to interact with you; however your content will remain on the Enna App Platform. Once you deactivate your account, you can reactivate it any time by choosing to log in."),
                          buildHeader("Pixels. "),
                          buildParagraph(
                              "To opt out of tracking via the Enna App Pixels check our site. Opting out of Pixels tracking may impact our ability to personalize ads and content tailored to your interests. This setting is tied to your cookies, and, unless you are logged in to the Enna App Platform, will only be effective on the browser for which you have performed the opt-out."),
                          buildHeader("Linked Networks. "),
                          buildParagraph(
                              "You may connect or disconnect your Linked Networks, such as Google, through the Account Settings tab in your profile settings, and you may access, amend and delete much of your profile information through your profile settings. Once you disconnect a Linked Network, we will not receive information from that Linked Network going forward unless you choose to reconnect it. You may also control whether the Linked Network is visible in your profile."),
                          buildHeader("Transferring Your Data"),
                          buildParagraph(
                              "Enna App is headquartered in the United States, and has operations, entities and service providers in the United States and throughout the world. As such, we and our service providers may transfer your personal information to, or access it in, jurisdictions (including the United States) that may not provide equivalent levels of data protection as your home jurisdiction. We will take steps to ensure that your personal information receives an adequate level of protection in the jurisdictions in which we process it."),
                          buildHeader("Children’s Privacy"),
                          buildParagraph(
                              "We do not knowingly collect or solicit personal information from anyone under the age of 13 or knowingly allow such persons to register. If we become aware that we have collected personal information from a child under the relevant age without parental consent, we take steps to delete that information."),
                          buildHeader("Links to Other Websites"),
                          buildParagraph(
                              "The Enna App Platform may contain links to third-party sites or online services. We are not responsible for the practices of such third parties, whose information practices are subject to their own policies and procedures, not to this Privacy Policy."),
                          buildHeader("Changes to Our Privacy Policy"),
                          buildParagraph(
                              "If we change our privacy policies and procedures, we will post those changes on this page. If we make any changes to this Privacy Policy that materially change how we treat your personal information, we will endeavour to provide you with reasonable notice of such changes, such as via prominent notice in the Enna App Platform or to your email address of record, and where required by law, we will obtain your consent or give you the opportunity to opt out of such changes."),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  buildHeader(text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  buildParagraph(text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        text,
      ),
    );
  }
}

class PrivacyPolicyPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  final key = GlobalKey<ScaffoldState>();

  PrivacyPolicyPageModel(
      {NotifierState state, this.api, this.auth, this.context})
      : super(state: state);
}
