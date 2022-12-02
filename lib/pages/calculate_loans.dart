import 'package:flutter/material.dart';
import 'package:vibank/pages/credit_score.dart';
import '../helper/custom_colors.dart';

class CalculateLoans extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // navigation to new screen
    void navigateToCreditScore() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreditScore()));
    }

    return Scaffold(
      appBar: buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23.0),
        child: Column(
          children: [
            //Build header
            const Align(
              alignment: Alignment.center,
              child: Header(
                title1: "Loan",
                title2: "Calculator",
                fontColor: Colors.black,
              ),
            ),
            //Build Custom TextField
            const TextFieldWithSlider(
              labelTitle: 'Home Price',
              prefixTitle: '\$',
              suffixTitle: '',
            ),
            const SizedBox(
              height: 20,
            ),
            const TextFieldWithSlider(
              labelTitle: 'Down Payment',
              prefixTitle: '\$',
              suffixTitle: '12.31\%',
            ),
            const SizedBox(
              height: 20,
            ),
            //Build Loan Lenghts Section
            LenghtOfLoan(),
            const TextFieldWithSlider(
              labelTitle: 'Interest rate',
              prefixTitle: '',
              suffixTitle: '\%',
            ),
            const Spacer(),
            //Build Button
            BottomButton(
              buttonPressed: navigateToCreditScore,
              buttonText: "Calculate",
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: const Icon(
        Icons.short_text,
        size: 33,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }
}

class Header extends StatelessWidget {
  final String title1;
  final String title2;
  final Color fontColor;

  const Header(
      {super.key,
      required this.title1,
      required this.title2,
      required this.fontColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title1,
          style: TextStyle(
              color: fontColor, fontSize: 35, fontWeight: FontWeight.bold),
        ),
        Text(
          title2,
          style: TextStyle(
              color: fontColor, fontSize: 35, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}

class TextFieldWithSlider extends StatelessWidget {
  final String labelTitle;
  final String prefixTitle;
  final String suffixTitle;

  const TextFieldWithSlider(
      {super.key,
      required this.labelTitle,
      required this.prefixTitle,
      required this.suffixTitle});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  labelTitle,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
            TextFormField(
                decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        prefixTitle,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        prefixTitle,
                        style: const TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0))))
          ],
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: SizedBox(
            height: 5.0,
            child: Slider(
              value: 15.0,
              max: 100.0,
              divisions: 5,
              activeColor: CustomColors.lightPurple,
              inactiveColor: CustomColors.lightPurple,
              onChanged: (double newvalue) {},
            ),
          ),
        )
      ],
    );
  }
}

class LenghtOfLoan extends StatefulWidget {
  const LenghtOfLoan({super.key});

  @override
  _LenghtOfLoanstate createState() => _LenghtOfLoanstate();
}

class _LenghtOfLoanstate extends State<LenghtOfLoan> {
  late int selectedLoan;
  @override
  Widget build(BuildContext context) {
    var loanYears = [24, 12, 10, 5];
    return SizedBox(
      height: 90,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Lenght of Loan",
                  style: TextStyle(
                    color: Colors.grey,
                  )),
              Text("Months",
                  style: TextStyle(
                    color: Colors.grey,
                  )),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: loanYears.map((e) => Text(e.toString())).toList(),
          )
        ],
      ),
    );
  }
}

/* Widget loanButton(int numOfYears) {
  var isSelected = numOfYears == selectedLoan ? true : false;
  return InkWell(
    onTap: () {
      setState(() {
        selectedLoan = numOfYears;
      });
    },
    child: Container(
        height: 55,
        width: 78,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color:
                isSelected ? CustomColors.lightPurple : CustomColors.grayColor),
        child: Text(
          numOfYears.toString(),
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black),
        )),
  );
}
 */
class BottomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback buttonPressed;

  const BottomButton(
      {super.key, required this.buttonText, required this.buttonPressed});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 350,
      child: ElevatedButton(
/*         color: CustomColors.darkPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), */
        onPressed: () => buttonPressed(),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
