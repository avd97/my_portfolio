import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              color: Colors.grey.shade400,
              child: SingleChildScrollView(
                child: Row(
                  spacing: 18,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Home',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Experience',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Projects',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Contact',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: screen.width * 0.1,
                  vertical: 16,
                ),
                width: screen.width,
                height: screen.height,
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   color: Colors.black87,
                  //   style: BorderStyle.solid,
                  //   width: 1,
                  // ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 👈 add this line
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Image.network(
                              'https://media.licdn.com/dms/image/v2/D4D16AQFyobAAV9ALlw/profile-displaybackgroundimage-shrink_350_1400/profile-displaybackgroundimage-shrink_350_1400/0/1704461315572?e=1763596800&v=beta&t=bdounbzeYhVQCuPPYWGNz3_33VKMJLxDef5L91sDQzQ',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 250,
                            ),
                          ),
                          Positioned(
                            top: 120,
                            left: 50,
                            child: CircleAvatar(
                              radius: 100,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 95,
                                backgroundImage: NetworkImage(
                                  'https://media.licdn.com/dms/image/v2/D4D03AQFmYACBRKiQdA/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1699343417875?e=1763596800&v=beta&t=VV5PBZe6TeuvI2TBM4iWQWM50WTIhtAu98h1xGGiKe4',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 100),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50), // 👈 optional for alignment match
                        child: Text(
                          'Abhishek Deshpande',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50), // 👈 optional for alignment match
                        child: Text(
                          'Mobile App Developer (Flutter | Kotlin | Java)',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50), // 👈 optional for alignment match
                        child: Text(
                          'Pune, Maharashtra',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 12,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50), // 👈 optional for alignment match
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(onPressed: (){}, child: Row(
                              children: [
                                Icon(Icons.call),
                                SizedBox(width: 12,),
                                Text(
                                  '+91-********72',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                  textAlign: TextAlign.left,
                                )
                              ],
                            )),
                            TextButton(onPressed: (){}, child: Row(
                              children: [
                                Icon(Icons.mail),
                                SizedBox(width: 12,),
                                Text(
                                  'abhi.pande215@gmail.com',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                  textAlign: TextAlign.left,
                                )
                              ],
                            )),
                            TextButton(onPressed: (){}, child: Row(
                              children: [
                                Icon(Icons.insert_link_rounded),
                                SizedBox(width: 12,),
                                Text(
                                  'LinkedIn',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                  textAlign: TextAlign.left,
                                )
                              ],
                            )),

                          ],
                        ),
                      ),
                      SizedBox(height: 12,),
                      Divider(),
                      SizedBox(height: 30,),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 50), // 👈 optional for alignment match
                                  child: Text(
                                    'Technical Skills',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Divider(),
                                SizedBox(height: 12,),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 50), // 👈 optional for alignment match
                                  child: Text(
                                    '• Languages & Frameworks: Dart, Flutter, Java, Kotlin, Node.js, Express.js• Architecture & Patterns: MVVM, Clean Architecture, Provider\n• Mobile Development: Android (Java/Kotlin), iOS (Flutter), UI/UX, State Management\n• APIs & Integrations: REST APIs, Google Maps, Razorpay, CCAvenue, Firebase\n• Databases: MySQL, PostgreSQL, SQLite, Room, Sqflite\n• Authentication: JWT, OAuth, Firebase Auth\n• Tools & Collaboration: Git, GitHub, Bitbucket, Postman, Agile/Scrum\n• Deployment: CI/CD, Play Console, App Store Connect\n• Cloud & Services: Firebase, AWS, Secure Data Storage, Localization, Text-to-Speech',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 50), // 👈 optional for alignment match
                                  child: Text(
                                    'Work Experience',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Divider(),
                                SizedBox(height: 12,),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 50), // 👈 optional for alignment match
                                  child: Text(
                                    '1. Senior Flutter Developer (Knackbe Technologies, Pune)\nMAR 2022 - PRESENT',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 50), // 👈 optional for alignment match
                                  child: Text(
                                    '• Designed and built advanced mobile applications for Android & iOS using Flutter.\n• Delivered production-ready apps, ensuring robustness, unit testing, and performance optimization.\n• Integrated Firebase, Google Maps API, and payment gateways (Razorpay, CCAvenue).\n• Mentored a team of 5 developers, reducing app development time by 15%.                           \n• Collaborated with stakeholders and cross-functional teams to define and ship new features.',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                SizedBox(height: 12,),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 50), // 👈 optional for alignment match
                                  child: Text(
                                    '2. Android Developer (Knackbe Technologies, Pune) JUL 2020 - MAR 2022',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 50), // 👈 optional for alignment match
                                  child: Text(
                                    '• Designed and developed native Android applications, implementing innovative solutions for improved user experience.\n• Integrated APIs and services, leveraging Android SDK to add functionalities like location services, payments, and multimedia features.\n• Collaborated with teams, including designers and QA engineers, to deliver high-quality applications.\n• Contributed to code optimization efforts, enhancing app performance and responsiveness.',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                SizedBox(height: 12,),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 50), // 👈 optional for alignment match
                                  child: Text(
                                    '3. Android Developer (OmVSab IT Solution)\nDEC 2019 - JUN 2020',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 50), // 👈 optional for alignment match
                                  child: Text(
                                    '• Developed Android applications with a focus on usability and performance.\n• Utilized Java & Kotlin to create native apps following best practices.\n• Integrated Data Storage solutions such as Room, SQLite, and Shared Preferences.',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                      /// Projects
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50), // 👈 optional for alignment match
                        child: Text(
                          'Projects',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
