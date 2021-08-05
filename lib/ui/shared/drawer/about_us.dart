import 'package:enna/core/services/api/api.dart';
import 'package:enna/core/services/api/http_api.dart';
import 'package:enna/core/services/auth/authentication_service.dart';
import 'package:enna/ui/shared/widgets/app_bar.dart';
import 'package:enna/ui/shared/widgets/drawer.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../../core/services/localization/localization.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: BaseWidget<AboutUsPageModel>(
          //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
          model: AboutUsPageModel(
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
                            locale.get('About Us') ?? 'About Us',
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
                            locale.get('About Enna') ?? 'About Enna',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w900),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          buildHeader(
                              "An Introduction to Enna App’s Terms of Service"),
                          buildParagraph(
                              "Welcome to Enna App! Here is a quick summary of the highlights of our Terms of Service:"),
                          buildHeader("•	Our mission "),
                          buildParagraph(
                              "The Enna App platform offers a place to grow your business through connecting with people."),
                          buildHeader(
                              "•	You own the content that we post on behalf of you;"),
                          buildParagraph(
                              "You also grant us and other users of the Enna App platform certain rights and license to use it. The details of these licenses are described in section 3(c) below."),
                          buildHeader(
                              "•	You are responsible for the content that you provide to post. "),
                          buildParagraph(
                              "This includes ensuring that you have the rights needed for you to post that content and that your content does not violate the legal rights of another party or any applicable laws."),
                          buildHeader(
                              "•	You can repost content from Enna App elsewhere."),
                          buildParagraph(
                              "Provided that you attribute the content back to the Enna App platform and respect the rights of the original poster, including any “not for reproduction” designation, and do not use automated tools."),
                          buildHeader(
                              "•	We verify manually the contents posted by users. "),
                          buildParagraph(
                              "The contents posted by each user will be manually verified and provided to us “as is”, without any guarantees. You are solely responsible for your own use of the Enna App platform."),
                          buildHeader(
                              "•	You agree to follow the rules of our platform. "),
                          buildParagraph(
                              "When you use the Enna App platform, you also agree to our Terms of Service, accept our Privacy Policy, and agree to follow our Acceptable Use Policy, Copyright Policy and Trademark Policy."),
                          buildHeader(
                              "•	We offer tools for you to give feedback and report complaints."),
                          buildParagraph(
                              " If you think someone has violated your intellectual property rights, other laws, or Enna App's policies, you can initiate a report at the contact us portal."),
                          buildParagraph(
                              "We are pleased that you want to join the Enna App platform and encourage you to read the full Terms of Service."),
                          buildHeader("Enna App Terms of Service"),
                          buildParagraph(
                              "Welcome to Enna App! Enna App is a platform to publish materials related to business, empowering people to find and search related matters. "),
                          buildParagraph(
                              "These terms of service (“Terms of Service”) set forth the agreement (“Agreement”) between you and Enna App, (“Enna App” “we” or “us”). It governs your use of the products and services we offer through our websites and applications (collectively the “Enna App Platform”)."),
                          buildParagraph(
                              "Please make sure to read it, because, by using the Enna App Platform, you consent to these terms."),
                          buildHeader("1.	Using the Enna App Platform"),
                          buildHeader("a.	Who Can Use It. "),
                          buildParagraph(
                              "Use of the Enna App Platform by anyone under 13 years of age is prohibited. You represent that you are at least the age of majority in the jurisdiction where you live or, if you are not, your parent or legal guardian must consent to these Terms of Service and affirm that they accept this Agreement on your behalf and bear responsibility for your use. If you are accepting these Terms of Service on behalf of someone else or an entity, you confirm that you have the legal authority to bind that person or entity to this Agreement."),
                          buildHeader("b.	Registration. "),
                          buildParagraph(
                              "When you set up a profile on the Enna App Platform, you will be asked to provide certain information about yourself. You agree to provide us accurate information, including your real name or real name of the entity you represent, when you create your account on the Enna App Platform. We will treat information you provide as part of registration in accordance with our Privacy Policy .You should take care in maintaining the confidentiality of your password."),
                          buildHeader("c.	Privacy Policy. "),
                          buildParagraph(
                              "Our privacy practices are set forth in our privacy Policy. By use of the Enna App Platform, you agree to accept our Privacy Policy, regardless of whether you are a registered user."),
                          buildHeader("d.	Acceptable Use Policy. "),
                          buildParagraph(
                              "In your interaction with others on the Enna App Platform, you agree to follow the Acceptable Use Policy at all times."),
                          buildHeader("e.	Termination. "),
                          buildParagraph(
                              "You may close your account at any time by going to account settings and disabling your account. We may terminate or suspend your Enna App account if you violate any Enna App policy or for any other reason"),
                          buildHeader("f.	Changes to the Enna App Platform. "),
                          buildParagraph(
                              "We are always trying to improve your experience on the Enna App Platform. We may need to add or change features and may do so without notice to you."),
                          buildHeader("g.	Feedback. "),
                          buildParagraph(
                              "We welcome your feedback and suggestions about how to improve the Enna App Platform. Feel free to submit feedback at Enna App.com. By submitting feedback, you agree to grant us the right, at our discretion, to use, disclose and otherwise exploit the feedback, in whole or part, freely and without compensation to you."),
                          buildHeader("2.	Your Content"),
                          buildHeader("a.	Definition of Your Content. "),
                          buildParagraph(
                              "The Enna App Platform needs the permission from you to posts, texts, photos, videos, links, and other files and information about yourself to share with others. All material that you upload, publish or display to others via the Enna App Platform will be referred to collectively as “Your Content.” Your acknowledge and agree that, as part of using the Enna App Platform, Your Content may be viewed by the general public."),
                          buildHeader("b.	Ownership. "),
                          buildParagraph(
                              "You, or your licensors, as applicable, retain ownership of the copyright and other intellectual property in Your Content, subject to the non-exclusive rights granted below."),
                          buildHeader(
                              "c.	License and Permission to Use Your Content."),
                          buildParagraph(
                              "i.	By submitting, posting, or displaying Your Content on the Enna App Platform, you grant Enna App and its affiliated companies a nonexclusive, worldwide, royalty free, fully paid up, transferable, sub licensable (through multiple tiers), license to use, copy, reproduce, process, adapt, modify, create derivative works from, publish, transmit, store, display and distribute, translate, communicate and make available to the public, and otherwise use Your Content in connection with the operation or use of the Enna App Platform or the promotion, advertising or marketing of the Enna App Platform or our business partners, in any and all media or distribution methods (now known or later developed), including via means of automated distribution, such as through an application programming interface (also known as an “API”). You agree that this license includes the right for Enna App to make Your Content available to other companies, organizations, business partners, or individuals who collaborate with Enna App for the syndication, broadcast, communication and making available to the public, distribution or publication of Your Content on the Enna App Platform or through other media or distribution methods. This license also includes the right for other users of the Enna App Platform to use, copy, reproduce, adapt, modify, create derivative works from, publish, transmit, display, and distribute, translate, communicate and make available to the public Your Content, subject to our Terms of Service. Except as expressly provided in these Terms of Service, this license will not confer the right for you to use automated technology to copy or post questions and answers or to aggregate questions and answers for the purpose of making derivative works. If you do not wish to allow your answers to be translated by other users, you can globally opt out of translation in your profile settings or you can designate certain answers not for translation."),
                          buildParagraph(
                              "ii.	Once you post an answer to a question, you may edit or delete your answer at any time from public display on Enna App Website except in the case of anonymously posted answers. However, we may not be able to control removal of the answer from display on syndicated channels or other previously distributed methods outside of Enna App Website. Enna App may remove suspected spam from your answers. Once you post content, it may be edited or deleted by Enna App at any time. Any edits and changes made by you may be visible to other users. The right for Enna App to copy, display, transmit, publish, perform, distribute, store, modify, and otherwise use any question you post, and sublicense those rights to others, is perpetual and irrevocable, to the maximum extent permitted by law, except as otherwise specified in this Agreement."),
                          buildParagraph(
                              "iii.	You acknowledge and agree that Enna App may preserve Your Content and may also disclose Your Content and related information if required to do so by law or in the good faith belief that such preservation or disclosure is reasonably necessary to: (a) comply with legal process, applicable laws or government requests; (b) enforce these Terms of Service; (c) respond to claims that any of Your Content violates the rights of third parties; (d) detect, prevent, or otherwise address fraud, security or technical issues; or (e) protect the rights, property, or personal safety of Enna App, its users, or the public."),
                          buildParagraph(
                              "iv.	You understand that we may modify, adapt, or create derivative works from Your Content in order to transmit, display or distribute it over computer networks, devices, service providers, and in various media. We also may remove or refuse to publish Your Content, in whole or part, at any time."),
                          buildParagraph(
                              "v.	You further give us the permission and authority to act as your nonexclusive agent to take enforcement action against any unauthorized use by third parties of any of Your Content outside of the Enna App Platform or in violation of our Terms of Service."),
                          buildHeader(
                              "d.	Your Responsibilities for Your Content"),
                          buildParagraph(
                              "By posting Your Content on the Enna App Platform, you represent and warrant to us that: i) you have the ownership rights, or you have obtained all necessary licenses or permissions to use Your Content and grant us the rights to use Your Content as provided for under this Agreement, and ii) that posting Your Content violates no intellectual property or personal right of others or any applicable law or regulation, including any laws or regulations requiring disclosure that you have been compensated for Your Content. You accept full responsibility for avoiding infringement of the intellectual property or personal rights of others or violation of laws and regulations in connection with Your Content. You are responsible for ensuring that Your Content does not violate Enna App’s Acceptable Use Policy, Copyright Policy, Trademark Policy, other published Enna App policy, or any applicable law or regulation. You agree to pay all royalties, fees, and any other monies owed to any person by reason of Your Content."),
                          buildHeader("3.	Our Content and Materials"),
                          buildHeader(
                              "a.	Definition of Our Content and Materials. "),
                          buildParagraph(
                              "All intellectual property in or related to the Enna App Platform (specifically including, but not limited to our software, the Enna App marks, the Enna App logo, but excluding Your Content) is the property of Enna, Inc., or its subsidiaries and affiliates, or content posted by other Enna App users licensed to us (collectively “Our Content and Materials”)."),
                          buildHeader("b.	Data. "),
                          buildParagraph(
                              "All data Enna App collects (“Data”) about use of the Enna App Platform by you or others is the property of Enna App, Inc., its subsidiaries, and affiliates. For clarity, Data does not include Your Content and is separate from Our Content and Materials."),
                          buildHeader("c.	Our License to You."),
                          buildParagraph(
                              "i.	We grant you a personal, limited, non-exclusive license to use and access Our Content and Materials and Data as made available to you on the Enna App Platform in connection with your use of the Enna App Platform, subject to the terms and conditions of this Agreement."),
                          buildParagraph(
                              "ii.	We may terminate our license to you at any time for any reason. We have the right but not the obligation to refuse to distribute any content on the Enna App Platform or to remove content. Except for the rights and license granted in these Terms of Service, we reserve all other rights and grant no other rights or licenses, implied or otherwise."),
                          buildHeader("d.	Endorsement or Verification."),
                          buildParagraph(
                              "Please note that the Enna App Platform contains access to third-party content, products and services, and it offers interactions with third parties. Participation or availability on the Enna App Platform does endorsement or verification by us."),
                          buildHeader("e.	Ownership. "),
                          buildParagraph(
                              "You acknowledge and agree that Our Content and Materials remain the property of Enna App. The content, information and services made available on the Enna App Platform are protected and international copyright, trademark, and other laws, and you acknowledge that these rights are valid and enforceable."),
                          buildHeader(
                              "4.	Reporting Violations of Your Intellectual Property Rights, Enna App Policies, or Applicable Laws. "),
                          buildParagraph(
                              "We have a special process for reporting violations of your intellectual property rights or other violations of Enna App policies or applicable laws."),
                          buildHeader(
                              "a.	Copyright Policy and Trademark Policy"),
                          buildParagraph(
                              "We have adopted and implemented a Copyright Policy and Trademark policy. For more information, including detailed information about how to submit a request for takedown if you believe content on the Enna App Platform infringes your intellectual property rights, please read our Copyright Policy."),
                          buildHeader("b.	Reports of Other Violations. "),
                          buildParagraph(
                              "If you believe content on the Enna App Platform violates Enna App’s Acceptable use Policy or otherwise violates applicable law (apart from copyright or trademark violations) or other Enna App policies, report to us. We have no obligation to delete content that you personally may find objectionable or offensive. We endeavour to respond promptly to requests for content removal, consistent with our policies and applicable law."),
                          buildHeader(
                              "5.	DISCLAIMERS AND LIMITATION OF LIABILITY PLEASE READ THIS SECTION CAREFULLY SINCE IT LIMITS THE LIABILITY OF ENNA APP ENTITIES TO YOU."),
                          buildParagraph(
                              "“ENNA APP ENTITIES” MEANS ENNA APP. AND ANY SUBSIDIARIES, AFFILIATES, RELATED COMPANIES, SUPPLIERS, LICENSORS AND PARTNERS, AND THE OFFICERS, DIRECTORS, EMPLOYEES, AGENTS AND REPRESENTATIVES OF EACH OF THEM. EACH PROVISION BELOW APPLIES TO THE MAXIMUM EXTENT PERMITTED UNDER APPLICABLE LAW."),
                          buildParagraph(
                              "a.	WE ARE PROVIDING YOU THE ENNA APP PLATFORM, ALONG WITH OUR CONTENT AND MATERIALS AND THE OPPORTUNITY TO CONNECT WITH OTHERS, ON AN “AS IS” AND “AS AVAILABLE” BASIS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED. WITHOUT LIMITING THE FOREGOING, ENNA APPENTITIES EXPRESSLY DISCLAIM ANY AND ALL WARRANTIES AND CONDITIONS OF MERCHANTABILITY, TITLE, ACCURACY AND COMPLETENESS, UNINTERRUPTED OR ERROR-FREE SERVICE, FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT, NON-INFRINGEMENT, AND ANY WARRANTIES ARISING OUT OF COURSE OF DEALING OR TRADE USAGE."),
                          buildParagraph(
                              "b.	ENNA APP MAKES NO PROMISES WITH RESPECT TO, AND EXPRESSLY DISCLAIMS ALL LIABILITY FOR: (i) CONTENT POSTED BY ANY USER OR THIRD PARTY; (ii) ANY THIRD-PARTY WEBSITE, THIRD-PARTY PRODUCT, OR THIRD-PARTY SERVICE LISTED ON OR ACCESSIBLE TO YOU THROUGH THE ENNA APP PLATFORM, INCLUDING AN INTEGRATED SERVICE PROVIDER OR PROFESSIONAL CONTRIBUTOR; (iii) THE QUALITY OR CONDUCT OF ANY THIRD PARTY YOU ENCOUNTER IN CONNECTION WITH YOUR USE OF THE ENNA APP PLATFORM; OR (iv) UNAUTHORIZED ACCESS, USE OR ALTERATION OF YOUR CONTENT. ENNA APP MAKES NO WARRANTY THAT: (a) THE ENNA APP PLATFORM WILL MEET YOUR REQUIREMENTS; (b) THE ENNA APP PLATFORM WILL BE UNINTERRUPTED, TIMELY, SECURE, OR ERROR-FREE; (c) THE RESULTS OR INFORMATION THAT YOU MAY OBTAIN FROM THE USE OF THE ENNA APP PLATFORM, A PROFESSIONAL CONTRIBUTOR, OR ANY OTHER USER WILL BE ACCURATE OR RELIABLE; OR (d) THE QUALITY OF ANY PRODUCTS, SERVICES, INFORMATION, OR OTHER MATERIAL OBTAINED OR PURCHASED BY YOU THROUGH THE ENNA APP PLATFORM WILL BE SATISFACTORY."),
                          buildParagraph(
                              "c.	YOU AGREE THAT TO THE MAXIMUM EXTENT PERMITTED BY LAW, ENNA APP ENTITIES WILL NOT BE LIABLE TO YOU UNDER ANY THEORY OF LIABILITY. WITHOUT LIMITING THE FOREGOING, YOU AGREE THAT, TO THE MAXIMUM EXTENT PERMITTED BY LAW, ENNA APP ENTITIES SPECIFICALLY WILL NOT BE LIABLE FOR ANY INDIRECT, INCIDENTAL, CONSEQUENTIAL, SPECIAL, OR EXEMPLARY DAMAGES, LOSS OF PROFITS, BUSINESS INTERRUPTION, REPUTATIONAL HARM, OR LOSS OF DATA (EVEN IF WE HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES OR SUCH DAMAGES ARE FORESEEABLE) ARISING OUT OF OR IN ANY WAY CONNECTED WITH YOUR USE OF, OR INABILITY TO USE, THE ENNA APP PLATFORM."),
                          buildParagraph(
                              "d.	YOUR SOLE REMEDY FOR DISSATISFACTION WITH THE ENNA APP PLATFORM IS TO STOP USING THE ENNA APP PLATFORM."),
                          buildParagraph(
                              "e.	WITHOUT LIMITING THE FOREGOING, ENNA APP’S MAXIMUM AGGREGATE LIABILITY TO YOU FOR LOSSES OR DAMAGES THAT YOU SUFFER IN CONNECTION WITH THE ENNA APP PLATFORM OR THIS AGREEMENT IS LIMITED TO THE AMOUNT PAID TO ENNA APP IN CONNECTION WITH THE ENNA APP PLATFORM IN THE TWELVE (12) MONTHS PRIOR TO THE ACTION GIVING RISE TO LIABILITY."),
                          buildParagraph(
                              "f.	SOME JURISDICTIONS DO NOT ALLOW LIMITATIONS ON IMPLIED WARRANTIES OR EXCLUSION OF LIABILITY FOR CERTAIN TYPES OF DAMAGES. AS A RESULT, THE ABOVE LIMITATIONS OR EXCLUSIONS MAY NOT APPLY TO YOU IN WHOLE OR IN PART, AND THE FOREGOING SECTIONS 8(c), 8(d), AND 8(e) WILL NOT APPLY TO A RESIDENT OF NEW JERSEY, TO THE EXTENT DAMAGES TO SUCH NEW JERSEY RESIDENT ARE THE RESULT OF ENNA APP’S NEGLIGENT, FRAUDULENT, RECKLESS, OR INTENTIONAL MISCONDUCT."),
                          buildHeader("6.	Indemnification"),
                          buildParagraph(
                              "You agree to release, indemnify, and defend Enna App Entities from all third-party claims and costs (including reasonable attorneys’ fees) arising out of or related to: i) your use of the Enna App Platform, ii) Your Content, iii) your conduct or interactions with other users of the Enna App Platform, or iv) your breach of any part of this Agreement. We will promptly notify you of any such claim and will provide you (at your expense) with reasonable assistance in defending the claim. You will allow us to participate in the defence and will not settle any such claim without our prior written consent. We reserve the right, at our own expense, to assume the exclusive defence of any matter otherwise subject to indemnification by you. In that event, you will have no further obligation to defend us in that matter."),
                          buildHeader("7.	Dispute Resolution"),
                          buildParagraph(
                              "This Agreement and any action arising out of your use of the Enna App Platform will be governed by the laws of the State of Qatar without regard to or application of its conflict of law provisions or your state or country of residence. Unless submitted to arbitration as set forth in the following paragraph, all claims, legal proceedings or litigation arising in connection with your use of the Enna App Platform will be brought solely in Qatar and you consent to the jurisdiction of and venue in such courts and waive any objection as to inconvenient forum."),
                          buildHeader("General Terms"),
                          buildHeader("a.	Changes to these Terms of Service. "),
                          buildParagraph(
                              "We may amend this Agreement at any time, in our sole discretion. If we amend material terms to this Agreement, such amendment will be effective after we send you notice of the amended agreement. Such notice will be in our sole discretion, and the manner of notification could include, for example, via email, posted notice on the Enna App Platform, or other manner. You can view the Agreement and our main policies at any time here. Your failure to cancel your account, or cease use of the Enna App Platform, after receiving notification of the amendment, will constitute your acceptance of the amended terms. If you do not agree to the amendments or to any of the terms in this Agreement, your only remedy is to cancel your account or to cease use of the Enna App Platform."),
                          buildHeader("b.	Governing Law and Jurisdiction. "),
                          buildParagraph(
                              "You agree that Enna App is operated in Qatar and will be deemed to be solely based in Qatar and a passive service for purposes of jurisdictional analysis. For any claims for which arbitration is inapplicable, you agree that such claims will be brought in federal or court of Qatar, and governed by laws of Qatar, without regard to any conflict of law provisions."),
                          buildHeader("c.	Export."),
                          buildParagraph(
                              "The Enna App Platform is controlled and operated from Qatar. Enna App software is subject to export controls. No software for Enna App may be downloaded or otherwise exported or re-exported in violation of any applicable laws or regulations. You represent that you are not (1) located in a country that is subject to Qatar government embargo and (2) listed on any Qatar government list of prohibited or restricted parties."),
                          buildHeader("d.	Applications and Mobile Devices. "),
                          buildParagraph(
                              "If you access the Enna App Platform through a Enna App application, you acknowledge that this Agreement is between you and Enna App only, and not with another application service provider or application platform provider (such as Apple Inc. or Google Inc.), which may provide you the application subject to its own terms. To the extent you access the Enna App Platform through a mobile device, your wireless carrier’s standard charges, data rates, and other fees may apply."),
                          buildHeader("e.	Assignment. "),
                          buildParagraph(
                              "You may not assign or transfer this Agreement (or any of your rights or obligations under this Agreement) without our prior written consent; any attempted assignment or transfer without complying with the foregoing will be void. We may freely assign or transfer this Agreement. This Agreement inures to the benefit of and is binding upon the parties and their respective legal representatives, successors, and assigns."),
                          buildHeader("f.	Electronic Communications. "),
                          buildParagraph(
                              "You consent to receive communications from us by email in accordance with this Agreement and applicable law. You acknowledge and agree that all agreements, notices, disclosures and other communications that we provide to you electronically will satisfy any legal requirement that such communications be in writing."),
                          buildHeader("g.	Entire Agreement/ Severability. "),
                          buildParagraph(
                              "This Agreement supersedes all prior terms, agreements, discussions and writings regarding the Enna App Platform and constitutes the entire agreement between you and us regarding the Enna App Platform (except as to services that require separate written agreement with us, in addition to this Agreement). If any provision in this Agreement is found to be unenforceable, then that provision will not affect the enforceability of the remaining provisions of the Agreement, which will remain in full force and effect."),
                          buildHeader("h.	Notices. "),
                          buildParagraph(
                              "All notices permitted or required under this Agreement, unless specified otherwise in this Agreement, must be sent in writing as follows in order to be valid: (i) if to you, by us via email to the address associated with your account, and (ii) if to us, by you via legal@Enna App.com. Notices will be deemed given (a) if to you, when emailed, and (b) if to us, on receipt by us."),
                          buildHeader("i.	Relationship. "),
                          buildParagraph(
                              "This Agreement does not create a joint venture, agency, partnership, or other form of joint enterprise between you and us. Except as expressly provided herein, neither party has the right, power, or authority to create any obligation or duty, express or implied, on behalf of the other."),
                          buildHeader("j.	Waiver. "),
                          buildParagraph(
                              "No waiver of any terms will be deemed a further or continuing waiver of such term or any other term. Our failure to assert a right or provision under this Agreement will not constitute a waiver of such right or provision."),
                          buildHeader("k.	Further Assurances. "),
                          buildParagraph(
                              "You agree to execute a hard copy of this Agreement and any other documents, and to take any actions at our expense that we may request to confirm and affect the intent of this Agreement and any of your rights or obligations under this Agreement."),
                          buildHeader("l.	Contact. "),
                          buildParagraph(
                              "Feel free to contact us through Enna App with any questions about these terms. "),
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

class AboutUsPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  final key = GlobalKey<ScaffoldState>();

  AboutUsPageModel({NotifierState state, this.api, this.auth, this.context})
      : super(state: state);
}
