import 'package:flutter/material.dart';
import 'package:flutter_bootstrap5/Home/Alert/AlertUI.dart';
import 'package:flutter_bootstrap5/Home/Dash/dash.dart';
import 'package:flutter_bootstrap5/Home/TextFieldsModule/TextFieldsModule.dart';
import 'package:flutter_bootstrap5/Home/widgets/widgets.dart';
import '../Table/TableModule.dart';

class NavBarModule extends StatefulWidget {
  const NavBarModule({super.key});

  @override
  State<NavBarModule> createState() => _NavBarModuleState();
}

class _NavBarModuleState extends State<NavBarModule> {
  late int index = 0;
  late List<String> moduleList = [
    "DashBoard",
    "TableView",
    "Alert",
    "TextFields"
  ];
  late double width;
  late bool isDevice;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    isDevice = getData(width) == "xs" || getData(width) == "sm";
    return isDevice
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurple,
              title: Text("Bottom Bar"),
            ),
            body: buildWidget(context),
            bottomNavigationBar: BottomAppBar(
              height: 55,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: moduleList
                    .map((module) => InkWell(
                          child: Icon(
                            index == selectedModule(module, moduleList)
                                ? Icons.home
                                : Icons.home_outlined,
                            color: Colors.deepPurple,
                          ),
                          onTap: () {
                            setState(() {
                              index = selectedModule(module, moduleList);
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
          )
        : Column(
            children: [
              AppBar(
                backgroundColor: Colors.deepPurple,
                title: Text("Navigation Bar"),
                actions: moduleList
                    .map((module) => InkWell(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            color: index == selectedModule(module, moduleList)
                                ? Colors.white
                                : Colors.transparent,
                            child: Text(
                              module,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: index ==
                                          selectedModule(module, moduleList)
                                      ? FontWeight.bold
                                      : FontWeight.w400,
                                  color: index ==
                                          selectedModule(module, moduleList)
                                      ? Colors.deepPurple
                                      : Colors.white),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              index = selectedModule(module, moduleList);
                            });
                          },
                        ))
                    .toList(),
              ),
              buildWidget(context)
            ],
          );
  }

  selectedModule(String module, List<String> moduleList) {
    return moduleList.indexWhere((element) => element == module);
  }

  buildWidget(BuildContext context) {
    return index == 0
        ? Dash()
        : index == 1
            ? TableModule()
            : index == 2
                ? AlertUI()
                : TextFieldsModule();
  }
}
