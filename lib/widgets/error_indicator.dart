import 'package:flutter/material.dart';

class NetworkErrorIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.public_off_rounded,
          color: Theme.of(context).textTheme.subtitle1.color,
          size: 45.0,
        ),
        Text(
          '網路連線錯誤',
          style: TextStyle(
            color: Theme.of(context).textTheme.subtitle1.color,
            fontSize: 17.0,
          ),
        ),
      ],
    );
  }
}

class TryAgainIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error_outline_rounded,
          color: Theme.of(context).textTheme.subtitle1.color,
          size: 45.0,
        ),
        Text(
          '暫時性錯誤，請重試',
          style: TextStyle(
            color: Theme.of(context).textTheme.subtitle1.color,
            fontSize: 17.0,
          ),
        ),
      ],
    );
  }
}

class LoginErrorIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.account_circle_rounded,
          color: Theme.of(context).textTheme.subtitle1.color,
          size: 45.0,
        ),
        Text(
          '帳號密碼錯誤',
          style: TextStyle(
            color: Theme.of(context).textTheme.subtitle1.color,
            fontSize: 17.0,
          ),
        ),
      ],
    );
  }
}

class UnknownErrorIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.bubble_chart,
          color: Theme.of(context).textTheme.subtitle1.color,
          size: 45.0,
        ),
        Text(
          '未知的錯誤',
          style: TextStyle(
            color: Theme.of(context).textTheme.subtitle1.color,
            fontSize: 17.0,
          ),
        ),
      ],
    );
  }
}

class APIChangeErrorIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.design_services_rounded,
          color: Theme.of(context).textTheme.subtitle1.color,
          size: 45.0,
        ),
        Text(
          '原 API 已無法使用，移植至新 API 開發中',
          style: TextStyle(
            color: Theme.of(context).textTheme.subtitle1.color,
            fontSize: 17.0,
          ),
        ),
      ],
    );
  }
}
