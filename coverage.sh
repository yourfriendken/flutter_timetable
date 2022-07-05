#!/usr/bin/env bash
flutter test --coverage
# requires
# brew install lcov
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html