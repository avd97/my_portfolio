import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
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
            ],
          ),
        ),
      ),
    );
  }
}
