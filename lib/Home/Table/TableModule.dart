import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_listfilter/flutter_listfilter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../Packages/flutter_bootstrap5.dart';

import '../widgets/widgets.dart';
import 'Model/DataTableList.dart';

class TableModule extends StatefulWidget {
  const TableModule({super.key});

  @override
  State<TableModule> createState() => _TableModuleState();
}

class _TableModuleState extends State<TableModule> {
  late List<String> tableModuleLis = [
    "RegNo",
    "PatName",
    "doctorname",
    "Age",
    "sex",
  ];
  late List<DataTableList> tableList = [];
  late List<DataTableList> selectedDataTableList = [];
  late List<DataTableList> dataTableList = [];
  late List<DataTableList> uniqueDataTableList = [];
  late String response = "";

  late bool sort = false;
  late int columnIndexSort = 0;
  late Color lightPurple = Color(0xFFD1C4E9);
  late SingleValueDropDownController dropDownController =
      SingleValueDropDownController(
    data: const DropDownValueModel(name: "All", value: 3),
  );
  late List<DropDownValueModel> dropDownList = const [
    DropDownValueModel(name: "5", value: 0),
    DropDownValueModel(name: "10", value: 1),
    DropDownValueModel(name: "15", value: 2),
    DropDownValueModel(name: "All", value: 3),
  ];

  late int selectedIndex = 1;
  late int startPage;
  late int endPage;
  late int pageVisible;
  late int numOfPage;
  late double width;
  late double height;
  late Offset offset = const Offset(0.5, 0.5);

  @override
  void initState() {
    for (var res in getJson()) {
      var list = DataTableList.fromJson(res);
      tableList.add(list);
    }
    calculateVisiblePages(tableList.length, tableList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    dataTableList = selectedDataTableList.isEmpty
        ? dropDownController.dropDownValue?.name == "All"
            ? tableList
            : dataTableList
        : selectedDataTableList;

    return getData(width) == "xs" || getData(width) == "sm"
        ? tableMobileView()
        : tableWebView();
  }

  calculateVisiblePages(int pagesVisible, List<DataTableList> tableList) {
    int numOfPages = (tableList.length / pagesVisible).ceil();
    int selectedPage = selectedIndex + 1;

    /// If the number of pages is less than or equal to the number of pages visible, then show all the pages
    if (numOfPages <= pagesVisible) {
      startPage = 1;
      endPage = numOfPages;
    } else {
      /// If the number of pages is greater than the number of pages visible, then show the pages visible
      int middle = (pagesVisible - 1) ~/ 2;
      if (selectedPage <= middle + 1) {
        startPage = 1;
        endPage = pagesVisible;
      } else if (selectedPage >= numOfPages - middle) {
        startPage = numOfPages - (pagesVisible - 1);
        endPage = numOfPages;
      } else {
        startPage = selectedPage - middle;
        endPage = selectedPage + middle;
      }
    }

    setState(() {
      pageVisible = pagesVisible;
      numOfPage = numOfPages;
      startPage;
      endPage;
    });
  }

  Widget showAlertDialog(List<DataTableList> uniqueDataTableLis, String res,
      StateSetter setAlertState) {
    return FB5Col(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: FB5Row(
        classNames: 'justify-content-between',
        children: [
          //HEADER
          FB5Col(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25))),
              child: FB5Row(classNames: 'align-items-center', children: [
                FB5Col(
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          //uniqueDataTableList=[];
                          response = "";
                        });
                      },
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.white,
                      )),
                ),
                FB5Col(
                  child: Text(
                    res,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              ]),
            ),
          ),
          //CHECK BOX
          FB5Col(
            //height: 250,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 250),
              child: SingleChildScrollView(
                child: FB5Row(
                  children: uniqueDataTableLis
                      .map((unique) => FB5Col(
                            child: CheckboxListTile(
                              value: selectedDataTableList.contains(unique),
                              onChanged: (value) {
                                if (value == true) {
                                  List<DataTableList> list = [];
                                  for (int i =
                                          (selectedIndex - 1) * pageVisible;
                                      i <
                                          ((selectedIndex * pageVisible) >
                                                  dataTableList.length
                                              ? dataTableList.length
                                              : (selectedIndex * pageVisible));
                                      i++) {
                                    if (dataTableList[i].get(res) ==
                                        unique.get(res)) {
                                      list.add(dataTableList[i]);
                                    }
                                  }

                                  selectedDataTableList.addAll(list);
                                } else {
                                  selectedDataTableList.remove(unique);
                                }
                                setAlertState(() {
                                  selectedDataTableList;
                                });
                              },
                              title: Text(unique.get(res)),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
          //BTN
          FB5Col(
            child: FB5Row(
              classNames: 'justify-content-between m-2',
              children: [
                FB5Col(
                  child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        setAlertState(() {
                          selectedDataTableList = [];
                        });
                        calculateVisiblePages(
                            selectedDataTableList.isEmpty
                                ? tableList.length
                                : selectedDataTableList.length,
                            selectedDataTableList.isEmpty
                                ? tableList
                                : selectedDataTableList);
                        setState(() {
                          selectedDataTableList = [];
                          dropDownController = SingleValueDropDownController(
                            data:
                                const DropDownValueModel(name: "All", value: 3),
                          );
                          selectedIndex = 1;
                          //uniqueDataTableList=[];
                          response = "";
                        });
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                FB5Col(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple),
                      onPressed: () {
                        calculateVisiblePages(
                            selectedDataTableList.isEmpty
                                ? tableList.length
                                : selectedDataTableList.length,
                            selectedDataTableList.isEmpty
                                ? tableList
                                : selectedDataTableList);

                        setState(() {
                          dropDownController = SingleValueDropDownController(
                            data:
                                const DropDownValueModel(name: "All", value: 3),
                          );
                          selectedIndex = 1;
                          selectedDataTableList;
                        });

                        setState(() {
                          //uniqueDataTableList=[];
                          response = "";
                        });
                      },
                      child: const Text(
                        "Apply",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  showingText() {
    return Text(
        "Showing ${(selectedIndex - 1) * pageVisible + 1} to ${((selectedIndex * pageVisible) > dataTableList.length ? dataTableList.length : (selectedIndex * pageVisible))} of ${tableList.length}");
  }

  paginationFunc() {
    return FB5Row(classNames: 'justify-content-center', children: [
      //BACK
      FB5Col(
        classNames: 'justify-content-center',
        child: IconButton(
            onPressed: selectedIndex > 1
                ? () {
                    setState(() {
                      selectedIndex -= 1;
                    });
                    calculateVisiblePages(
                        dropDownController.dropDownValue?.name == "All"
                            ? dataTableList.length
                            : int.parse(dropDownController.dropDownValue!.name),
                        dataTableList);
                  }
                : null,
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: selectedIndex > 1 ? Colors.grey : Colors.transparent,
            )),
      ),
      FB5Col(
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (int i = startPage; i <= endPage; i++) ...[
              InkWell(
                child: Container(
                  color: selectedIndex == i ? Colors.grey : Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      i.toString(),
                      style: TextStyle(
                          color:
                              selectedIndex == i ? Colors.black : Colors.grey),
                    ),
                  ),
                ),
                onTap: () {
                  calculateVisiblePages(
                      dropDownController.dropDownValue?.name == "All"
                          ? dataTableList.length
                          : int.parse(dropDownController.dropDownValue!.name),
                      dataTableList);
                  setState(() {
                    selectedIndex = i;
                  });
                },
              ),
            ]
          ],
        ),
      ),
      //NEXT
      FB5Col(
        classNames: 'justify-content-center',
        child: IconButton(
            onPressed: selectedIndex < numOfPage
                ? () {
                    setState(() {
                      selectedIndex += 1;
                    });
                    calculateVisiblePages(
                        dropDownController.dropDownValue?.name == "All"
                            ? dataTableList.length
                            : int.parse(dropDownController.dropDownValue!.name),
                        dataTableList);
                  }
                : null,
            icon: Icon(
              Icons.arrow_forward_ios_outlined,
              color:
                  selectedIndex < numOfPage ? Colors.grey : Colors.transparent,
            )),
      ),
    ]);
  }

  tableWebView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: DropDownTextField(
                        clearOption: false,
                        controller: dropDownController,
                        enableSearch: false,
                        onChanged: (value) {
                          setState(() {
                            dropDownController;
                            selectedIndex = 1;
                          });
                          calculateVisiblePages(
                              value.name == "All"
                                  ? dataTableList.length
                                  : int.parse(value.name.toString()),
                              dataTableList);
                        },
                        textFieldDecoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1))),
                        dropDownList: dropDownList)),
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Entries per Page",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              ],
            ),
            //DATA TABLE
            Scrollbar(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    primary: true,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            iconTheme: Theme.of(context)
                                .iconTheme
                                .copyWith(color: Colors.white)),
                        child: DataTable(
                          sortAscending: sort,
                          sortColumnIndex: columnIndexSort,
                          border: TableBorder.all(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 2),
                          headingRowColor: MaterialStateColor.resolveWith(
                              (states) => Colors.deepPurple),
                          dataRowColor: MaterialStateColor.resolveWith(
                              (states) => lightPurple),
                          columns: tableModuleLis
                              .map((res) => DataColumn(
                                  onSort: (columnIndex, ascending) {
                                    setState(() {
                                      sort = !sort;
                                      columnIndexSort = columnIndex;
                                    });
                                    if (columnIndex == columnIndexSort) {
                                      /*List<DataTableList> existing=[];
                                      for (int i = (selectedIndex - 1) * pageVisible;
                                      i <
                                          ((selectedIndex * pageVisible) >
                                              dataTableList.length
                                              ? dataTableList.length
                                              : (selectedIndex * pageVisible));
                                      i++){
                                        existing.add(dataTableList[i]);
                                      }*/
                                      if (ascending) {
                                        dataTableList.sort((a, b) =>
                                            a.get(res).compareTo(b.get(res)));
                                      } else {
                                        dataTableList.sort((a, b) =>
                                            b.get(res).compareTo(a.get(res)));
                                      }
                                    }
                                  },
                                  label: Row(
                                    children: [
                                      Text(
                                        res,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                      GestureDetector(
                                        onTapDown: (details) {
                                          final RenderBox box = context
                                              .findRenderObject() as RenderBox;
                                          // find the coordinate
                                          final Offset localOffset =
                                              box.globalToLocal(
                                                  details.globalPosition);
                                          setState(() {
                                            offset = localOffset;
                                          });
                                          print("offset=>$offset");

                                        },
                                        onTap: () {
                                          var set = <String>{};
                                          List<DataTableList> existing = [];
                                          for (int i = (selectedIndex - 1) *
                                                  pageVisible;
                                              i <
                                                  ((selectedIndex *
                                                              pageVisible) >
                                                          dataTableList.length
                                                      ? dataTableList.length
                                                      : (selectedIndex *
                                                          pageVisible));
                                              i++) {
                                            existing.add(dataTableList[i]);
                                          }
                                          List<DataTableList>
                                              uniqueDataTableLis = existing
                                                  .where((element) =>
                                                      set.add(element.get(res)))
                                                  .toList();
                                          setState(() {
                                            uniqueDataTableList =
                                                uniqueDataTableLis;
                                            response = res;
                                          });
                                          /*showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Scaffold(
                                                backgroundColor: Colors.transparent,
                                                body: StatefulBuilder(
                                                  builder: (context, setStateFul) =>
                                                      Stack(
                                                    children: [
                                                      Positioned(
                                                        left: offset.dx >
                                                                ((getData(width) ==
                                                                        'md')
                                                                    ? 450
                                                                    : (getData(width) ==
                                                                            'lg')
                                                                        ? 680
                                                                        : 1000)
                                                            ? offset.dx - 150
                                                            : offset.dx + 100,
                                                        top: widget.isMain
                                                            ? offset.dy + offset.dy
                                                            : offset.dy + 80,
                                                        child: Container(
                                                          width: 300,
                                                          height: 350,
                                                          decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25)),
                                                          child: StatefulBuilder(
                                                            builder: (context,setStateFul) {
                                                              return showAlertDialog(
                                                                  uniqueDataTableLis,
                                                                  res,
                                                                  setStateFul);
                                                            }
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );*/
                                        },
                                        child: const Icon(
                                          Icons.filter_alt_outlined,
                                          color: Colors.white,
                                        ),
                                      ),
                                      /*IconButton(
                                      onPressed: () {

                                      },
                                      icon: Icon(
                                        Icons.filter_alt_outlined,
                                        color: Colors.white,
                                      ))*/
                                    ],
                                  )))
                              .toList(),
                          rows: [
                            for (int i = (selectedIndex - 1) * pageVisible;
                                i <
                                    ((selectedIndex * pageVisible) >
                                            dataTableList.length
                                        ? dataTableList.length
                                        : (selectedIndex * pageVisible));
                                i++) ...[
                              DataRow(
                                  cells: tableModuleLis
                                      .map((index) => DataCell(
                                            Text(
                                              dataTableList[i]
                                                  .get(index)
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                selectedDataTableList = [];
                                                List<DataTableList> list = [];
                                                for (int j =
                                                        (selectedIndex - 1) *
                                                            pageVisible;
                                                    j <
                                                        ((selectedIndex *
                                                                    pageVisible) >
                                                                dataTableList
                                                                    .length
                                                            ? dataTableList
                                                                .length
                                                            : (selectedIndex *
                                                                pageVisible));
                                                    j++) {
                                                  if (dataTableList[j]
                                                          .get(index) ==
                                                      dataTableList[i]
                                                          .get(index)) {
                                                    list.add(dataTableList[j]);
                                                  }
                                                }

                                                selectedDataTableList = list;
                                                dropDownController =
                                                    SingleValueDropDownController(
                                                  data:
                                                      const DropDownValueModel(
                                                          name: "All",
                                                          value: 3),
                                                );
                                              });
                                            },
                                          ))
                                      .toList())
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (response.isNotEmpty) ...[
                    Positioned(
                      left: offset.dx >450
                          ? offset.dx - 350
                          : offset.dx,
                      child: Container(
                        /*  width: 300,
                        height: 350,*/
                        constraints:
                            const BoxConstraints(maxWidth: 300, maxHeight: 400),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25)),
                        child: StatefulBuilder(builder: (context, setStateFul) {
                          return showAlertDialog(
                              uniqueDataTableList, response, setStateFul);
                        }),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            //PAGINATION
            FB5Row(
              classNames:
                  'row-cols-md-3 row-cols-lg-4 row-cols-xl-5 row-cols-xxl-5 justify-content-between',
              children: [
                FB5Col(
                  classNames: 'justify-content-center',
                  child: showingText(),
                ),
                FB5Col(
                  classNames: 'justify-content-center',
                  child: paginationFunc(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  tableMobileView() {
    return SingleChildScrollView(
      child: FlutterListFilter(
          dynamicList: tableList,
          filterHeaderList: tableModuleLis,
          primaryColor: Colors.deepPurple,
          lineColor: Colors.grey,
          builder: (List<dynamic> tableList) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: tableList
                  .map((module) => SizedBox(
                        width: width,
                        child: Card(
                          margin: EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Wrap(
                              runSpacing: 5,
                              spacing: 15,
                              children: tableModuleLis
                                  .map((key) => Wrap(
                                        runSpacing: 5,
                                        spacing: 5,
                                        children: [
                                          if (key == "RegNo") ...[
                                            const Icon(
                                              Icons.person_outline_rounded,
                                              color: Colors.grey,
                                              size: 20,
                                            ),
                                          ],
                                          Text(
                                            "$key:",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Text(
                                            module.get(key),
                                            style:
                                                TextStyle(color: Colors.black),
                                          )
                                        ],
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            );
          }),
    );
  }
}

getJson() {
  return [
    {
      "RegNo": "1",
      "PatName": "Mr.Devilaal",
      "doctorname": "Dr.Ram",
      "Age": "26 Y",
      "sex": "MALE",
      "batch": "Batch 1"
    },
    {
      "RegNo": "2",
      "PatName": "Mr.Damodara",
      "doctorname": "Dr.John",
      "Age": "36 Y",
      "sex": "MALE",
      "batch": "Batch 2"
    },
    {
      "RegNo": "3",
      "PatName": "Mr.Daler",
      "doctorname": "Dr.Jenny",
      "Age": "36 Y",
      "sex": "MALE",
      "batch": "Batch 3"
    },
    {
      "RegNo": "4",
      "PatName": "Dr.Bhagat",
      "doctorname": "Dr.Ram",
      "Age": "36 Y",
      "sex": "MALE",
      "batch": "Batch 4"
    },
    {
      "RegNo": "5",
      "PatName": "Mr.Bansi",
      "doctorname": "Dr.John",
      "Age": "37 Y",
      "sex": "MALE",
      "batch": "Batch 1"
    },
    {
      "RegNo": "6",
      "PatName": "Mr.Balwant",
      "doctorname": "Dr.Jenny",
      "Age": "26 Y",
      "sex": "MALE",
      "batch": "Batch 2"
    },
    {
      "RegNo": "7",
      "PatName": "Mr.Balvinder",
      "doctorname": "Dr.Ram",
      "Age": "26 Y",
      "sex": "MALE",
      "batch": "Batch 3"
    },
    {
      "RegNo": "8",
      "PatName": "Mr.Abhay",
      "doctorname": "Dr.Sam",
      "Age": "26 Y",
      "sex": "MALE",
      "batch": "Batch 4"
    },
    {
      "RegNo": "9",
      "PatName": "Mr.Dev",
      "doctorname": "Dr.Sam",
      "Age": "36 Y",
      "sex": "MALE",
      "batch": "Batch 1"
    },
    {
      "RegNo": "10",
      "PatName": "Mr.Bani",
      "doctorname": "Dr.Ram",
      "Age": "39 Y",
      "sex": "FEMALE",
      "batch": "Batch 2"
    },
    {
      "RegNo": "11",
      "PatName": "Mr.DON",
      "doctorname": "Dr.John",
      "Age": "30 Y",
      "sex": "MALE",
      "batch": "Batch 3"
    },
    {
      "RegNo": "12",
      "PatName": "Dr.Par",
      "doctorname": "Dr.Sam",
      "Age": "20 Y",
      "sex": "MALE",
      "batch": "Batch 4"
    },
    {
      "RegNo": "13",
      "PatName": "Mr.BAN",
      "doctorname": "Dr.John",
      "Age": "60 Y",
      "sex": "MALE",
      "batch": "Batch 1"
    },
    {
      "RegNo": "14",
      "PatName": "Mr.pal",
      "doctorname": "Dr.Jenny",
      "Age": "60 Y",
      "sex": "FEMALE",
      "batch": "Batch 2"
    },
    {
      "RegNo": "15",
      "PatName": "Mr.MAN",
      "doctorname": "Dr.John",
      "Age": "20 Y",
      "sex": "MALE",
      "batch": "Batch 3"
    },
    {
      "RegNo": "16",
      "PatName": "Mr.ABI",
      "doctorname": "Dr.John",
      "Age": "18 Y",
      "sex": "MALE",
      "batch": "Batch 4"
    },
    ////
  ];
}
