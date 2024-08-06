

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Dietchart extends StatefulWidget {
  const Dietchart({super.key});

  @override
  State<Dietchart> createState() => _DietchartState();
}

class _DietchartState extends State<Dietchart> {
  List<RadialData> chartData = [
    RadialData(200, 'Carbohydrate'),
    RadialData(100, 'Fat'),
    RadialData(200, 'Protien'),
  ];

  @override
  Widget build(BuildContext context) {
    return  Container(
        margin: const EdgeInsets.all(10),
        child:   SfCircularChart(
         // title: const ChartTitle(text: 'Diet Chart'),
          legend: const Legend(isVisible: true,
          
          position: LegendPosition.bottom,
          textStyle: TextStyle(color: Colors.black)),
          palette: const [Colors.blueAccent,Colors.deepPurpleAccent,Colors.purpleAccent],
          series: [
            RadialBarSeries<RadialData, String>(
             // radius: '70%',
             // innerRadius: '30%',
             // trackColor: Colors.grey,
              gap:'3%',
              cornerStyle: CornerStyle.bothCurve,
              dataSource: chartData,
                xValueMapper: (RadialData data, _) => data.nutrients,
                yValueMapper: (RadialData data, _) => data.calorie,
                dataLabelSettings:const DataLabelSettings(
                  isVisible:true,
                 
                  ),),
          ],
        ),
      );
    
  }
}

class RadialData {
  final double calorie;
  final String nutrients;
  RadialData(this.calorie, this.nutrients);
}
