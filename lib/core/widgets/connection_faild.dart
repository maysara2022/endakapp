import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/core/constants/app_size.dart';
import 'package:flutter/material.dart';

class ConnectionFailed extends StatefulWidget {
  final void Function() fun;
  const ConnectionFailed({super.key, required this.fun});


  @override
  State<ConnectionFailed> createState() => _ConnectionFailedState();
}

class _ConnectionFailedState extends State<ConnectionFailed> {
  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('تعذّر الإتصال بالخادم',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
        AppSize.box(.02, 0),
        SizedBox(
          width: AppSize.screenWidth/2,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                Colors.blueAccent,
              ),
            ),
              onPressed: (){
           widget.fun;
          }, child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.update,color: Colors.white,size: 22,),
              AppSize.box(0, .02),
              Text('إعادة التحميل',style: TextStyle(color: AppColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 18),),
            ],
          )),
        )

      ],
    );
  }
}
