import 'package:flutter/material.dart';
import 'package:handicraft_app/provider/report_service.dart';

void reportDialog(BuildContext context, dynamic uid, int type) async {
  ReportService reportService = ReportService();
  final geReport = type == 1
      ? reportService.getReportSeller()
      : reportService.getReportProduct();

  int _selectReport;
  print(uid);
  bool _report = false, _loadingreport = false, _error = false;
  _error = type == 1
      ? await reportService.findOutReportUser(uid)
      : await reportService.findOutReportProduct(uid);
  _error
      ? showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Error!"),
                content: Text(
                    "Ya denunciaste el ${type == 1 ? "usuario" : "producto"}"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                actions: [
                  MaterialButton(
                      child: Text(
                        "ok",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 3,
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ))
      : showDialog(
          context: context,
          builder: (context) =>
              StatefulBuilder(builder: (context, StateSetter setState) {
                return _report
                    ? AlertDialog(
                        title: Text("Gracias!"),
                        content: Text("Se ha enviado el reporte "),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        actions: [
                          MaterialButton(
                              child: Text(
                                "ok",
                                style: TextStyle(color: Colors.black),
                              ),
                              elevation: 3,
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ],
                      )
                    : AlertDialog(
                        title: Text("Denunciar vendedor",
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Montserrat',
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        content: Container(
                          height: 200,
                          child: FutureBuilder(
                            future: geReport,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                final data = snapshot.data;
                                return Container(
                                  height: 180,
                                  width: double.maxFinite,
                                  child: ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          _selectReport == data[index]["id"]
                                              ? _selectReport = null
                                              : _selectReport =
                                                  data[index]["id"];

                                          setState(() {});
                                        },
                                        child: Row(
                                          children: [
                                            _selectReport == data[index]["id"]
                                                ? Icon(
                                                    Icons.brightness_1_rounded)
                                                : Icon(Icons
                                                    .brightness_1_outlined),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(data[index]["name"],
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontFamily: 'Montserrat',
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        actions: [
                          Divider(
                            color: Colors.black,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MaterialButton(
                                  child: Text(
                                    "Cancelar",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  elevation: 3,
                                  onPressed: () => Navigator.pop(context)),
                              _loadingreport
                                  ? Container(
                                      margin:
                                          EdgeInsets.only(right: 46, left: 20),
                                      child: SizedBox(
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                        ),
                                        height: 20.0,
                                        width: 20.0,
                                      ),
                                    )
                                  : MaterialButton(
                                      child: Text(
                                        "Reportar",
                                        style: TextStyle(
                                            color: _selectReport == null
                                                ? Colors.grey
                                                : Colors.white),
                                      ),
                                      color: Colors.black,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      elevation: 3,
                                      onPressed: _selectReport == null
                                          ? null
                                          : () async {
                                              setState(() {
                                                _loadingreport = true;
                                              });

                                              final resp = type == 1
                                                  ? await reportService
                                                      .postReportUser(
                                                          _selectReport, uid)
                                                  : await reportService
                                                      .postReportProduct(
                                                          _selectReport, uid);
                                              if (resp) {
                                                _error = true;
                                                _report = true;
                                                _loadingreport = false;
                                                setState(() {});
                                              } else {
                                                setState(() {
                                                  _error = true;
                                                  _loadingreport = false;
                                                  setState(() {});
                                                });
                                              }
                                            })
                            ],
                          )
                        ],
                      );
              }));
}
