import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void openEatery(BuildContext context, String eateryId) {
  context.push('/eatery/$eateryId');
}

void openVisit(BuildContext context, String visitId) {
  context.push('/visit/$visitId');
}
