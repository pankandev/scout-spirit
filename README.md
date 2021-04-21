# scout_spirit

The Scout Spirit app for the gamified progression system project

## Requirements

- Flutter > 2

## Things to consider

- Most of the app features (basically all of the 3D graphics) won't work on emulators as Unity does
not.

## For development

This app will run as most Flutter, but with the ``no-sound-null-safety`` parameter as some critical
dependencies does not have null-safety yet:

``
flutter run --no-sound-null-safety
``

To communicate with the API Gateway on development, you need to run the gateway following the
instructions [here](https://github.com/pankandev/scout-progression-system-sam/blob/master/README.md)
and then use the following command to simulate all the localhost requests sent by the device to be
redirected to your computer:

````sh
adb reverse tcp:3000 tcp:3000
```` 

Only the API Gateway and Database are called locally in development, Amazon Cognito and S3 are
called directly to the server using IAM permissions. 
